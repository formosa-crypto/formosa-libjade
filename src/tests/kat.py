#!/usr/bin/env python3
"""Known-answer test runner for the Jasmin ML-DSA / ML-KEM AVX2 builds.

A single driver that, given one or more KAT JSON files, loads the matching
shared library (built into ../_build by `make libs`) and replays each test
vector through the derand entry points, checking the produced outputs.

Usage:
    python3 kat.py [--lib-dir DIR] vectors/*.json

JSON schema (one file per algorithm)
------------------------------------
{
  "algorithm": "ML-DSA-{44,65,87}" | "ML-KEM-{512,768,1024}",
  "tests": [ { "count": <int>, <operation blocks...> } ]
}

Every value is a hex string, in either case. For each expected output FIELD
you may instead give FIELD_sha3_256 (the SHA3-256 of the output, hex) to keep
vectors small. Expected fields that are absent are simply not checked; later blocks
reuse earlier outputs when their inputs are omitted.

ML-DSA blocks:
  "keygen": { "seed": <32B>,  "verification_key"?, "signing_key"? }
  "sign":   { "context": <hex>, "message": <hex>, "randomness": <32B>,
              "signing_key"?,                         -- default: from keygen
              "signature"? }
  "verify": { "context"?, "message"?, "signature"?,  -- default: from sign
              "verification_key"?,                    -- default: from keygen
              "result"?: <int, default 0> }   -- 0 accepts; any nonzero
                                                 value matches a rejection

ML-KEM blocks:
  "keygen": { "coins": <64B>, "public_key"?, "secret_key"? }
  "encaps": { "coins": <32B>, "public_key"?,   -- default: from keygen
              "ciphertext"?, "shared_secret"? }
  "decaps": { "ciphertext"?, "secret_key"?,    -- default: from encaps/keygen
              "shared_secret"? }
  "check_pk": { "public_key": <hex>, "result"?: <int, default 0> }
  "check_sk": { "secret_key": <hex>, "result"?: <int, default 0> }
              -- FIPS 203 7.2 / 7.3 input checks; a rejected key must also
                 be rejected by encaps (zero coins) / decaps (zero ciphertext)
"""

import argparse
import ctypes
import hashlib
import json
import sys
from ctypes import c_int, c_uint64, c_void_p
from pathlib import Path


# --------------------------------------------------------------------------
# Algorithm table (pure data): per parameter set, the shared-library name, the
# exported-symbol prefix, the runner kind, and the FIPS byte sizes.
# --------------------------------------------------------------------------
def _mldsa(param, vk, sk, sig):
    return {
        "kind": "mldsa",
        "lib": "mldsa%d_avx2.so" % param,
        "sym": "ml_dsa_%d" % param,
        "verification_key": vk,
        "signing_key": sk,
        "signature": sig,
    }


def _mlkem(param, pk, sk, ct):
    return {
        "kind": "mlkem",
        "lib": "mlkem%d_avx2.so" % param,
        "sym": "jade_kem_mlkem_mlkem%d_amd64_avx2" % param,
        "public_key": pk,
        "secret_key": sk,
        "ciphertext": ct,
        "shared_secret": 32,
    }


# FIPS-204 (ML-DSA) and FIPS-203 (ML-KEM) byte sizes for every parameter set.
SCHEMES = {
    "ML-DSA-44": _mldsa(44, 1312, 2560, 2420),
    "ML-DSA-65": _mldsa(65, 1952, 4032, 3309),
    "ML-DSA-87": _mldsa(87, 2592, 4896, 4627),
    "ML-KEM-512": _mlkem(512, 800, 1632, 768),
    "ML-KEM-768": _mlkem(768, 1184, 2400, 1088),
    "ML-KEM-1024": _mlkem(1024, 1568, 3168, 1568),
}


# --------------------------------------------------------------------------
# ctypes helpers
# --------------------------------------------------------------------------
def in_buf(data: bytes):
    """A ctypes buffer holding exactly `data` (no trailing NUL)."""
    return ctypes.create_string_buffer(bytes(data), len(data))


def out_buf(size: int):
    return ctypes.create_string_buffer(size)


def addr(buf) -> int:
    return ctypes.cast(buf, c_void_p).value or 0


def h(block, field):
    """Decode a required hex field."""
    return bytes.fromhex(block[field])


# --------------------------------------------------------------------------
# Result tracking
# --------------------------------------------------------------------------
class Report:
    def __init__(self):
        self.passed = 0
        self.failed = 0
        self.failures = []

    def check(self, label, ok, detail=""):
        if ok:
            self.passed += 1
        else:
            self.failed += 1
            self.failures.append(f"{label}: {detail}")

    def check_output(self, label, block, field, actual: bytes):
        """Check `actual` against block[field] (hex) or block[field+'_sha3_256']."""
        if field in block:
            want, got = block[field].lower(), actual.hex()
            self.check(f"{label}.{field}", got == want,
                       f"expected {want[:24]}..., got {got[:24]}...")
        key = field + "_sha3_256"
        if key in block:
            want, got = block[key].lower(), hashlib.sha3_256(actual).hexdigest()
            self.check(f"{label}.{key}", got == want,
                       f"expected {want}, got {got}")


# --------------------------------------------------------------------------
# Scheme runners: selected from a registry by kind; each declares an ordered
# list of operations and implements one method per operation. The driver walks
# OPS in order and runs the blocks present in a test case -- no cascade of ifs.
# --------------------------------------------------------------------------
RUNNERS = {}


def runner(kind):
    def register(cls):
        RUNNERS[kind] = cls
        return cls
    return register


class Scheme:
    OPS = ()      # operation names, in execution order
    STATE = ()    # attributes carried between operations, reset per test case

    def __init__(self, lib, spec):
        self.spec = spec
        self.cid = None
        self.bind(lib)

    def bind(self, lib):
        raise NotImplementedError

    def reset(self):
        for name in self.STATE:
            setattr(self, name, None)

    def run(self, tests, rep):
        for t in tests:
            self.cid = t.get("count", "?")
            self.reset()
            for op in self.OPS:
                if op in t:
                    getattr(self, op)(t[op], rep)

    def label(self, op):
        return f"[{self.cid}] {op}"


@runner("mldsa")
class MLDSA(Scheme):
    OPS = ("keygen", "sign", "verify")
    STATE = ("vk", "sk", "sig", "ctx", "msg")

    def bind(self, lib):
        sym = self.spec["sym"]
        self.fn = {}
        keygen = getattr(lib, f"{sym}_keygen")
        keygen.restype, keygen.argtypes = None, [c_void_p] * 3
        sign = getattr(lib, f"{sym}_sign")
        sign.restype = c_int
        sign.argtypes = [c_void_p, c_void_p, c_void_p, c_uint64, c_uint64, c_void_p]
        verify = getattr(lib, f"{sym}_verify")
        verify.restype = c_int
        verify.argtypes = [c_void_p, c_void_p, c_uint64, c_uint64, c_void_p]
        self.fn = {"keygen": keygen, "sign": sign, "verify": verify}

    def keygen(self, b, rep):
        vkb = out_buf(self.spec["verification_key"])
        skb = out_buf(self.spec["signing_key"])
        self.fn["keygen"](addr(vkb), addr(skb), addr(in_buf(h(b, "seed"))))
        self.vk, self.sk = vkb.raw, skb.raw
        rep.check_output(self.label("keygen"), b, "verification_key", self.vk)
        rep.check_output(self.label("keygen"), b, "signing_key", self.sk)

    def sign(self, b, rep):
        sk = h(b, "signing_key") if "signing_key" in b else self.sk
        self.ctx, self.msg = h(b, "context"), h(b, "message")
        ctxb, msgb = in_buf(self.ctx), in_buf(self.msg)
        ctx_arr = (c_uint64 * 2)(addr(ctxb), len(self.ctx))
        sigb = out_buf(self.spec["signature"])
        r = self.fn["sign"](addr(sigb), addr(in_buf(sk)),
                            ctypes.cast(ctx_arr, c_void_p),
                            addr(msgb), len(self.msg),
                            addr(in_buf(h(b, "randomness"))))
        rep.check(self.label("sign") + ".result", r == b.get("result", 0), f"got {r}")
        self.sig = sigb.raw
        rep.check_output(self.label("sign"), b, "signature", self.sig)

    def verify(self, b, rep):
        vk = h(b, "verification_key") if "verification_key" in b else self.vk
        ctx = h(b, "context") if "context" in b else self.ctx
        msg = h(b, "message") if "message" in b else self.msg
        sig = h(b, "signature") if "signature" in b else self.sig
        ctxb, msgb = in_buf(ctx), in_buf(msg)
        ctx_arr = (c_uint64 * 2)(addr(ctxb), len(ctx))
        r = self.fn["verify"](addr(in_buf(vk)), ctypes.cast(ctx_arr, c_void_p),
                              addr(msgb), len(msg), addr(in_buf(sig)))
        # verify only promises 0 or nonzero: compare acceptance, not the value
        rep.check(self.label("verify") + ".result",
                  (r == 0) == (b.get("result", 0) == 0), f"got {r}")


@runner("mlkem")
class MLKEM(Scheme):
    OPS = ("keygen", "encaps", "decaps", "check_pk", "check_sk")
    STATE = ("pk", "sk", "ct", "ss")

    def bind(self, lib):
        sym = self.spec["sym"]
        self.fn = {}
        for name, argc in (("keypair_derand", 3), ("enc_derand", 4), ("dec", 3),
                           ("check_pk", 1), ("check_sk", 1)):
            f = getattr(lib, f"{sym}_{name}")
            f.restype, f.argtypes = c_int, [c_void_p] * argc
            self.fn[name] = f

    def keygen(self, b, rep):
        pkb = out_buf(self.spec["public_key"])
        skb = out_buf(self.spec["secret_key"])
        self.fn["keypair_derand"](addr(pkb), addr(skb), addr(in_buf(h(b, "coins"))))
        self.pk, self.sk = pkb.raw, skb.raw
        rep.check_output(self.label("keygen"), b, "public_key", self.pk)
        rep.check_output(self.label("keygen"), b, "secret_key", self.sk)

    def encaps(self, b, rep):
        pk = h(b, "public_key") if "public_key" in b else self.pk
        ctb = out_buf(self.spec["ciphertext"])
        ssb = out_buf(self.spec["shared_secret"])
        self.fn["enc_derand"](addr(ctb), addr(ssb), addr(in_buf(pk)),
                              addr(in_buf(h(b, "coins"))))
        self.ct, self.ss = ctb.raw, ssb.raw
        rep.check_output(self.label("encaps"), b, "ciphertext", self.ct)
        rep.check_output(self.label("encaps"), b, "shared_secret", self.ss)

    def decaps(self, b, rep):
        ct = h(b, "ciphertext") if "ciphertext" in b else self.ct
        sk = h(b, "secret_key") if "secret_key" in b else self.sk
        ssb = out_buf(self.spec["shared_secret"])
        self.fn["dec"](addr(ssb), addr(in_buf(ct)), addr(in_buf(sk)))
        rep.check_output(self.label("decaps"), b, "shared_secret", ssb.raw)

    def check_pk(self, b, rep):
        pk, want = in_buf(h(b, "public_key")), b.get("result", 0)
        r = self.fn["check_pk"](addr(pk))
        rep.check(self.label("check_pk") + ".result", r == want, f"got {r}")
        if want != 0:
            ctb = out_buf(self.spec["ciphertext"])
            ssb = out_buf(self.spec["shared_secret"])
            r = self.fn["enc_derand"](addr(ctb), addr(ssb), addr(pk),
                                      addr(in_buf(bytes(32))))
            rep.check(self.label("check_pk") + ".encaps", r == want, f"got {r}")

    def check_sk(self, b, rep):
        sk, want = in_buf(h(b, "secret_key")), b.get("result", 0)
        r = self.fn["check_sk"](addr(sk))
        rep.check(self.label("check_sk") + ".result", r == want, f"got {r}")
        if want != 0:
            ssb = out_buf(self.spec["shared_secret"])
            ct = in_buf(bytes(self.spec["ciphertext"]))
            r = self.fn["dec"](addr(ssb), addr(ct), addr(sk))
            rep.check(self.label("check_sk") + ".decaps", r == want, f"got {r}")


# --------------------------------------------------------------------------
# Driver
# --------------------------------------------------------------------------
def run_file(path: Path, lib_dir: Path, rep: Report):
    data = json.loads(path.read_text())
    algo = data["algorithm"]
    if algo not in SCHEMES:
        raise SystemExit(f"{path}: unknown algorithm {algo!r}")
    spec = SCHEMES[algo]
    lib_path = lib_dir / spec["lib"]
    if not lib_path.exists():
        raise SystemExit(f"{path}: library not found: {lib_path} (run `make libs`)")
    try:
        lib = ctypes.CDLL(str(lib_path))
    except OSError as e:
        raise SystemExit(
            f"{path}: cannot load {lib_path}: {e}\n"
            "(the libraries are x86-64 + AVX2; load them on a matching host)")
    tests = data.get("tests", [])
    print(f"{path.name}: {algo}, {len(tests)} test(s)")
    RUNNERS[spec["kind"]](lib, spec).run(tests, rep)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("vectors", nargs="+", type=Path, help="KAT JSON file(s)")
    ap.add_argument("--lib-dir", type=Path,
                    default=Path(__file__).resolve().parent.parent / "_build",
                    help="directory holding the built .so files (default: ../_build)")
    args = ap.parse_args(argv)

    rep = Report()
    for path in args.vectors:
        run_file(path, args.lib_dir, rep)

    print(f"\n{rep.passed} passed, {rep.failed} failed")
    for f in rep.failures:
        print(f"  FAIL {f}")
    return 1 if rep.failed else 0


if __name__ == "__main__":
    sys.exit(main())
