#!/usr/bin/env python3
"""Backend-agnostic KAT runner.

Loads _build/<backend>_<scheme>.so (built by `make libs`) and replays the KAT
vectors through the common derand ABI (adapters/common_abi.h): kem_* for ML-KEM,
sig_* for ML-DSA; selects the library by backend.

Usage:
    python3 kat.py --backend jasmin vectors/*.json
    python3 kat.py --backend mlkem-native --lib-dir _build vectors/mlkem768.json
"""

import argparse
import ctypes
import hashlib
import json
import sys
from ctypes import c_int, c_size_t, c_void_p
from pathlib import Path


def _mldsa(base, vk, sk, sig):
    return {"kind": "mldsa", "base": base,
            "verification_key": vk, "signing_key": sk, "signature": sig}


def _mlkem(base, pk, sk, ct):
    return {"kind": "mlkem", "base": base,
            "public_key": pk, "secret_key": sk, "ciphertext": ct,
            "shared_secret": 32}


SCHEMES = {
    "ML-DSA-44": _mldsa("mldsa44", 1312, 2560, 2420),
    "ML-DSA-65": _mldsa("mldsa65", 1952, 4032, 3309),
    "ML-DSA-87": _mldsa("mldsa87", 2592, 4896, 4627),
    "ML-KEM-512": _mlkem("mlkem512", 800, 1632, 768),
    "ML-KEM-768": _mlkem("mlkem768", 1184, 2400, 1088),
    "ML-KEM-1024": _mlkem("mlkem1024", 1568, 3168, 1568),
}


# The AVX2 backends want 32-byte-aligned buffers. create_string_buffer is only
# malloc-aligned, so over-allocate and expose a 32-aligned from_buffer view: a
# real ctypes object, so it keeps the backing alive and is passed by object
# (ctypes takes its address for the c_void_p params and keeps it alive per call).
_ALIGN = 32


def _aligned(size, data=None):
    store = ctypes.create_string_buffer(size + _ALIGN)
    off = (-ctypes.addressof(store)) % _ALIGN
    view = (ctypes.c_char * size).from_buffer(store, off)
    if data:
        ctypes.memmove(view, bytes(data), len(data))
    return view


def in_buf(data):
    return _aligned(len(data), data)


def out_buf(size):
    return _aligned(size)


def h(block, field):
    return bytes.fromhex(block[field])


class Report:
    def __init__(self):
        self.passed = self.failed = self.skipped = self.unsupported = 0
        self.failures = []

    def check(self, label, ok, detail=""):
        if ok:
            self.passed += 1
        else:
            self.failed += 1
            self.failures.append(f"{label}: {detail}")

    def check_output(self, label, block, field, actual):
        # KAT sources differ in hex case (ML-KEM ACVP is upper, ML-DSA pqc is
        # lower); .hex()/.hexdigest() are lower. Compare case-insensitively.
        if field in block:
            want, got = block[field].lower(), actual.hex()
            self.check(f"{label}.{field}", got == want,
                       f"expected {want[:24]}..., got {got[:24]}...")
        key = field + "_sha3_256"
        if key in block:
            want, got = block[key].lower(), hashlib.sha3_256(actual).hexdigest()
            self.check(f"{label}.{key}", got == want, f"expected {want}, got {got}")


RUNNERS = {}


def runner(kind):
    def register(cls):
        RUNNERS[kind] = cls
        return cls
    return register


class Scheme:
    OPS = ()
    STATE = ()

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
                # a list of blocks runs the operation once per block, in order
                blocks = t.get(op, [])
                for b in blocks if isinstance(blocks, list) else [blocks]:
                    getattr(self, op)(b, rep)

    def label(self, op):
        return f"[{self.cid}] {op}"


@runner("mldsa")
class MLDSA(Scheme):
    OPS = ("keygen", "sign", "verify")
    STATE = ("vk", "sk", "sig", "ctx", "msg")

    def bind(self, lib):
        self.keygen_fn = lib.sig_keygen
        self.keygen_fn.restype, self.keygen_fn.argtypes = None, [c_void_p] * 3
        self.sign_fn = lib.sig_sign
        self.sign_fn.restype = c_int
        self.sign_fn.argtypes = [c_void_p, c_void_p, c_void_p, c_size_t,
                                 c_void_p, c_size_t, c_void_p]
        self.verify_fn = lib.sig_verify
        self.verify_fn.restype = c_int
        self.verify_fn.argtypes = [c_void_p, c_void_p, c_size_t, c_void_p,
                                   c_size_t, c_void_p]

    def keygen(self, b, rep):
        vkb, skb = out_buf(self.spec["verification_key"]), out_buf(self.spec["signing_key"])
        self.keygen_fn(vkb, skb, in_buf(h(b, "seed")))
        self.vk, self.sk = vkb.raw, skb.raw
        rep.check_output(self.label("keygen"), b, "verification_key", self.vk)
        rep.check_output(self.label("keygen"), b, "signing_key", self.sk)

    def sign(self, b, rep):
        sk = h(b, "signing_key") if "signing_key" in b else self.sk
        self.ctx, self.msg = h(b, "context"), h(b, "message")
        sigb = out_buf(self.spec["signature"])
        r = self.sign_fn(sigb, in_buf(sk),
                         in_buf(self.ctx), len(self.ctx),
                         in_buf(self.msg), len(self.msg),
                         in_buf(h(b, "randomness")))
        rep.check(self.label("sign") + ".result", r == b.get("result", 0), f"got {r}")
        self.sig = sigb.raw
        rep.check_output(self.label("sign"), b, "signature", self.sig)

    def verify(self, b, rep):
        vk = h(b, "verification_key") if "verification_key" in b else self.vk
        ctx = h(b, "context") if "context" in b else self.ctx
        msg = h(b, "message") if "message" in b else self.msg
        sig = h(b, "signature") if "signature" in b else self.sig
        r = self.verify_fn(in_buf(vk),
                           in_buf(ctx), len(ctx),
                           in_buf(msg), len(msg),
                           in_buf(sig))
        # verify only promises 0 or nonzero: compare acceptance, not the value
        rep.check(self.label("verify") + ".result",
                  (r == 0) == (b.get("result", 0) == 0), f"got {r}")


@runner("mlkem")
class MLKEM(Scheme):
    OPS = ("keygen", "encaps", "decaps", "check_pk", "check_sk")
    STATE = ("pk", "sk", "ct", "ss")

    def bind(self, lib):
        self.keypair_fn = lib.kem_keypair_derand
        self.keypair_fn.restype, self.keypair_fn.argtypes = c_int, [c_void_p] * 3
        self.enc_fn = lib.kem_enc_derand
        self.enc_fn.restype, self.enc_fn.argtypes = c_int, [c_void_p] * 4
        self.dec_fn = lib.kem_dec
        self.dec_fn.restype, self.dec_fn.argtypes = c_int, [c_void_p] * 3
        # The key checks are optional in the ABI: None for a backend that
        # does not perform them.
        self.check_fn = {}
        for op in ("check_pk", "check_sk"):
            f = getattr(lib, f"kem_{op}", None)
            if f is not None:
                f.restype, f.argtypes = c_int, [c_void_p]
            self.check_fn[op] = f

    def keygen(self, b, rep):
        pkb, skb = out_buf(self.spec["public_key"]), out_buf(self.spec["secret_key"])
        r = self.keypair_fn(pkb, skb, in_buf(h(b, "coins")))
        rep.check(self.label("keygen") + ".result", r == b.get("result", 0), f"got {r}")
        self.pk, self.sk = pkb.raw, skb.raw
        rep.check_output(self.label("keygen"), b, "public_key", self.pk)
        rep.check_output(self.label("keygen"), b, "secret_key", self.sk)

    def encaps(self, b, rep):
        pk = h(b, "public_key") if "public_key" in b else self.pk
        ctb, ssb = out_buf(self.spec["ciphertext"]), out_buf(self.spec["shared_secret"])
        r = self.enc_fn(ctb, ssb, in_buf(pk), in_buf(h(b, "coins")))
        rep.check(self.label("encaps") + ".result", r == b.get("result", 0), f"got {r}")
        self.ct, self.ss = ctb.raw, ssb.raw
        rep.check_output(self.label("encaps"), b, "ciphertext", self.ct)
        rep.check_output(self.label("encaps"), b, "shared_secret", self.ss)

    def decaps(self, b, rep):
        ct = h(b, "ciphertext") if "ciphertext" in b else self.ct
        sk = h(b, "secret_key") if "secret_key" in b else self.sk
        ssb = out_buf(self.spec["shared_secret"])
        r = self.dec_fn(ssb, in_buf(ct), in_buf(sk))
        rep.check(self.label("decaps") + ".result", r == b.get("result", 0), f"got {r}")
        rep.check_output(self.label("decaps"), b, "shared_secret", ssb.raw)

    # A key check runs the exported check, and on a rejected key also enc
    # (zero coins) or dec (zero ciphertext), which must reject it the same way.
    def check_pk(self, b, rep):
        if self.check_fn["check_pk"] is None:
            rep.unsupported += 1
            return
        pk, want = in_buf(h(b, "public_key")), b.get("result", 0)
        r = self.check_fn["check_pk"](pk)
        rep.check(self.label("check_pk") + ".result", r == want, f"got {r}")
        if want != 0:
            ctb, ssb = out_buf(self.spec["ciphertext"]), out_buf(self.spec["shared_secret"])
            r = self.enc_fn(ctb, ssb, pk, in_buf(bytes(32)))
            rep.check(self.label("check_pk") + ".encaps", r == want, f"got {r}")

    def check_sk(self, b, rep):
        if self.check_fn["check_sk"] is None:
            rep.unsupported += 1
            return
        sk, want = in_buf(h(b, "secret_key")), b.get("result", 0)
        r = self.check_fn["check_sk"](sk)
        rep.check(self.label("check_sk") + ".result", r == want, f"got {r}")
        if want != 0:
            ssb = out_buf(self.spec["shared_secret"])
            r = self.dec_fn(ssb, in_buf(bytes(self.spec["ciphertext"])), sk)
            rep.check(self.label("check_sk") + ".decaps", r == want, f"got {r}")


def load_backend(backend, scheme_base, lib_dir):
    lib_path = lib_dir / f"{backend}_{scheme_base}.so"
    if not lib_path.exists():
        # A backend need not provide every parameter set (e.g. jasmin has only
        # mldsa65 / mlkem768 / mlkem1024). Signal "unsupported" so the caller
        # can skip rather than abort the whole run.
        return None
    try:
        return ctypes.CDLL(str(lib_path))
    except OSError as e:
        raise SystemExit(f"cannot load {lib_path}: {e}\n"
                         "(backends are x86-64 + AVX2; load them on a matching host)")


def run_file(path, backend, lib_dir, rep):
    data = json.loads(path.read_text())
    algo = data["algorithm"]
    if algo not in SCHEMES:
        raise SystemExit(f"{path}: unknown algorithm {algo!r}")
    spec = SCHEMES[algo]
    lib = load_backend(backend, spec["base"], lib_dir)
    if lib is None:
        print(f"{path.name}: {backend} / {algo}, skipped (no {backend}_{spec['base']}.so)")
        rep.skipped += 1
        return
    tests = data.get("tests", [])
    print(f"{path.name}: {backend} / {algo}, {len(tests)} test(s)")
    RUNNERS[spec["kind"]](lib, spec).run(tests, rep)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("vectors", nargs="+", type=Path, help="KAT JSON file(s)")
    ap.add_argument("--backend", required=True, help="backend name, e.g. jasmin, mlkem-native")
    ap.add_argument("--lib-dir", type=Path,
                    default=Path(__file__).resolve().parent / "_build")
    args = ap.parse_args(argv)

    rep = Report()
    for path in args.vectors:
        run_file(path, args.backend, args.lib_dir, rep)

    print(f"\n{rep.passed} passed, {rep.failed} failed, {rep.skipped} file(s) skipped"
          + (f", {rep.unsupported} key check(s) not supported by {args.backend}"
             if rep.unsupported else ""))
    for f in rep.failures:
        print(f"  FAIL {f}")
    return 1 if rep.failed else 0


if __name__ == "__main__":
    sys.exit(main())
