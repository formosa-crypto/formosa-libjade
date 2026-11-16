#!/usr/bin/env python3
"""Import KAT vectors into the bench/ JSON schema.

Three sources, each downloaded at a fixed version:

- NIST ACVP (usnistgov/ACVP-Server), converted to full-value vectors:
  ML-KEM-keyGen / ML-KEM-encapDecap, the encapsulation and decapsulation key
  checks (FIPS 203 7.2, 7.3) included (mlkem<n>.json); ML-DSA-keyGen /
  -sigGen / -sigVer (mldsa<n>-acvp.json), only the groups of the external,
  pure interface, the one the common ABI exposes (the importer lists the
  others).
- the KAT files of post-quantum-cryptography/KAT (an archived repository,
  pinned to a commit), with the SHA3-256 hashes of the long outputs:
  ML-DSA hedged_pure (mldsa<n>.json), keygen then signing; ML-KEM
  (mlkem<n>-pqc.json, the first PQC_TESTS records), keygen, encapsulation,
  decapsulation of its ciphertext, then of an invalid ciphertext (implicit
  rejection).
- the SHA-2 test vectors of NIST CAVP (SHAVS, CAVS 11.1, byte-oriented),
  each file checked against its SHA-256: ShortMsg, LongMsg and Monte of
  SHA-224, SHA-256, SHA-384, SHA-512, SHA-512/224 and SHA-512/256
  (fips180<set>.json). --cavp-dir reads the .rsp files from a directory
  instead of the archive.

    python3 tools/import_kat.py --out vectors --acvp-version v1.1.0.43
"""

import argparse
import hashlib
import json
import sys
import urllib.request
import zipfile
from pathlib import Path

ACVP_BASE = "https://raw.githubusercontent.com/usnistgov/ACVP-Server/{v}/gen-val/json-files"
ACVP_MLKEM = ["ML-KEM-keyGen-FIPS203", "ML-KEM-encapDecap-FIPS203"]
ACVP_MLDSA = ["ML-DSA-keyGen-FIPS204", "ML-DSA-sigGen-FIPS204", "ML-DSA-sigVer-FIPS204"]
PQC_COMMIT = "f238e347b1323344208eb316df9993c923334817"
PQC_BASE = f"https://raw.githubusercontent.com/post-quantum-cryptography/KAT/{PQC_COMMIT}"
PQC_TESTS = 100  # ML-KEM records kept per parameter set (the files have 1000)
CAVP_SHA2 = ("https://csrc.nist.gov/CSRC/media/Projects/"
             "Cryptographic-Algorithm-Validation-Program/documents/shs/shabytetestvectors.zip")
CAVP_SHA2_FILES = {
    "SHA256ShortMsg.rsp": "75e1cb83994638481808e225b9eb0c1ebd0c232d952ac42b61abce6363be283c",
    "SHA256LongMsg.rsp": "6fac36f37360bcf74ffcf4465c18e30d6d5a04cc90885b901fc3130c16060974",
    "SHA256Monte.rsp": "29ea30c6bb4b84e425fb8c1d731c6bb852dac935825f2bd1143e5d3c4f10bfb9",
    "SHA512ShortMsg.rsp": "e53a36c03609e5a3e3cc4b6e117a499db7864c23ec825c6cec99503a45f40764",
    "SHA512LongMsg.rsp": "b1f3f05d5c209777954d49521d7ea1349447c36a0c52849e044bc397a27dd410",
    "SHA512Monte.rsp": "8ca78659286c2f01667a98fc7accd32fc171ae7b24ac00f1a8ce6b77770247fa",
    "SHA224ShortMsg.rsp": "0dad6656c08f77252f6ccb789e42284fd61fc53bba30e83162800aa3d2aa939f",
    "SHA224LongMsg.rsp": "d37115e5d2286dde969c5e1b2275cd83ecb066366d7a38bb6b2b3adb4a88de89",
    "SHA224Monte.rsp": "7854d388666ea3eb01bdaca37dc8ae0bc39d30f8731d9a5487cbd61de47d1d59",
    "SHA384ShortMsg.rsp": "7ea7bcf00fadc20949fae63703e40681ddf288fea808471cb3cbc95f3ec16811",
    "SHA384LongMsg.rsp": "536171765a4278c000ac3c9913edb2eed0ca7ccd5a10b72ed79fdfe7901a6d6a",
    "SHA384Monte.rsp": "4270099431ff52ee1686dc472351e681c26c507433df8f107c7de203b771424e",
    "SHA512_224ShortMsg.rsp": "9b11fb25ff08d8c708e098a22d013c5d38c068d1e398eb573d2055c053bffe75",
    "SHA512_224LongMsg.rsp": "fb578ff1f68713e7dbcfac052bd641a948002b15c7dccb008e5ef1dba9f8a47d",
    "SHA512_224Monte.rsp": "91564691e14d32fc9dda7fb58cc8ae12914dc4ff3e260fd0b88e441c6962dd2f",
    "SHA512_256ShortMsg.rsp": "d8d5008b73f90cb92a8f8d4d9af745809ceef47af4cbeb2ee245cc6b153f5223",
    "SHA512_256LongMsg.rsp": "d2454ce8dfcd7ea9b9ffbe44d35564ca82d2d6744fb4b36f5e056c6064fb0792",
    "SHA512_256Monte.rsp": "f84e3c0296202e06a5c9654df94f89b62906fcf16f7e1a640c28d838353b0a42",
}
# CAVP file prefix -> (algorithm, implementation name: src/fips180/avx2/sct/<set>)
CAVP_SHA2_SETS = {"SHA256": ("SHA2-256", "fips180sha256"),
                  "SHA512": ("SHA2-512", "fips180sha512"),
                  "SHA224": ("SHA2-224", "fips180sha224"),
                  "SHA384": ("SHA2-384", "fips180sha384"),
                  "SHA512_224": ("SHA2-512/224", "fips180sha512_224"),
                  "SHA512_256": ("SHA2-512/256", "fips180sha512_256")}


def base_name(algo):
    return algo.replace("-", "").lower()  # "ML-KEM-512" -> "mlkem512"


def write_scheme(out_dir, algo, tests, source, suffix=""):
    path = out_dir / f"{base_name(algo)}{suffix}.json"
    path.write_text(json.dumps(
        {"algorithm": algo, "source": source, "tests": tests}, indent=1))
    print(f"  {path.name}: {len(tests)} test(s)")


# --------------------------------------------------------------------------
# post-quantum-cryptography/KAT -> schema (hashes of the long outputs)
# --------------------------------------------------------------------------
def fetch_pqc(cache, rel):
    """the records of the .rsp file rel, as {field: hex} dicts"""
    cache.mkdir(parents=True, exist_ok=True)
    local = cache / rel.replace("/", "_")
    if not local.exists():
        print(f"  downloading {rel}")
        urllib.request.urlretrieve(f"{PQC_BASE}/{rel}", local)
    records, rec = [], {}
    for line in local.read_text().splitlines():
        if " = " in line:
            key, value = (x.strip() for x in line.split(" = ", 1))
            if key == "count" and rec:
                records.append(rec)
                rec = {}
            rec[key] = value
    return records + [rec] if rec else records


def sha3(hexstr):
    return hashlib.sha3_256(bytes.fromhex(hexstr)).hexdigest()


def import_mldsa_pqc(out_dir, cache):
    for setn in (44, 65, 87):
        rel = f"MLDSA/kat_MLDSA_{setn}_hedged_pure.rsp"
        tests = []
        for r in fetch_pqc(cache, rel):
            sm, mlen = r["sm"], 2 * int(r["mlen"])  # sm = signature || message
            if sm[len(sm) - mlen:] != r["msg"]:
                raise SystemExit(f"{rel}: count {r['count']}: sm does not end with msg")
            tests.append({
                "count": int(r["count"]),
                "keygen": {"seed": r["xi"],
                           "verification_key_sha3_256": sha3(r["pk"]),
                           "signing_key_sha3_256": sha3(r["sk"])},
                "sign": {"context": r["ctx"], "message": r["msg"], "randomness": r["rng"],
                         "signature_sha3_256": sha3(sm[:len(sm) - mlen])},
            })
        write_scheme(out_dir, f"ML-DSA-{setn}", tests, f"{rel} of post-quantum-cryptography/KAT "
                     f"{PQC_COMMIT[:8]}")


def import_mlkem_pqc(out_dir, cache):
    for setn in (512, 768, 1024):
        rel = f"MLKEM/kat_MLKEM_{setn}.rsp"
        tests = []
        for r in fetch_pqc(cache, rel)[:PQC_TESTS]:
            tests.append({
                "count": int(r["count"]),
                "keygen": {"coins": r["d"] + r["z"],  # ML-KEM.KeyGen coins = d || z
                           "public_key_sha3_256": sha3(r["pk"]),
                           "secret_key_sha3_256": sha3(r["sk"])},
                "encaps": {"coins": r["msg"], "ciphertext_sha3_256": sha3(r["ct"]),
                           "shared_secret": r["ss"]},
                # the ciphertext of encaps, then an invalid one (implicit rejection)
                "decaps": [{"shared_secret": r["ss"]},
                           {"ciphertext": r["ct_n"], "shared_secret": r["ss_n"]}],
            })
        write_scheme(out_dir, f"ML-KEM-{setn}", tests, f"{rel} of post-quantum-cryptography/KAT "
                     f"{PQC_COMMIT[:8]}, first {PQC_TESTS} records", suffix="-pqc")


# --------------------------------------------------------------------------
# NIST ACVP -> schema (full values)
# --------------------------------------------------------------------------
def fetch_acvp(version, cache, names):
    """(prompt, expected results by tcId) of each ACVP file pair in `names`."""
    cache.mkdir(parents=True, exist_ok=True)
    out = {}
    for name in names:
        pair = []
        for part in ("prompt.json", "expectedResults.json"):
            rel = f"{name}/{part}"
            local = cache / rel.replace("/", "_")
            if not local.exists():
                url = f"{ACVP_BASE.format(v=version)}/{rel}"
                print(f"  downloading {rel}")
                urllib.request.urlretrieve(url, local)
            pair.append(json.loads(local.read_text()))
        out[name] = (pair[0], by_tcid(pair[1]))
    return out


def by_tcid(expected):
    m = {}
    for g in expected["testGroups"]:
        for t in g["tests"]:
            m[t["tcId"]] = t
    return m


def import_mlkem(version, out_dir, cache):
    a = fetch_acvp(version, cache, ACVP_MLKEM)
    schemes = {}  # algo -> list of tests

    prompt, kg_exp = a["ML-KEM-keyGen-FIPS203"]
    for g in prompt["testGroups"]:
        algo = g["parameterSet"]
        for t in g["tests"]:
            e = kg_exp[t["tcId"]]
            schemes.setdefault(algo, []).append({
                "count": t["tcId"],
                "keygen": {"coins": t["d"] + t["z"],  # ML-KEM.KeyGen coins = d || z
                           "public_key": e["ek"], "secret_key": e["dk"]},
            })

    prompt, ed_exp = a["ML-KEM-encapDecap-FIPS203"]
    for g in prompt["testGroups"]:
        algo = g["parameterSet"]
        func = (g.get("function") or "").lower()
        if func not in ("encapsulation", "decapsulation",
                        "encapsulationkeycheck", "decapsulationkeycheck"):
            raise SystemExit(f"ML-KEM-encapDecap group {g['tgId']}: unknown function {func!r}")
        for t in g["tests"]:
            e = ed_exp[t["tcId"]]
            if func == "encapsulation":
                schemes.setdefault(algo, []).append({
                    "count": t["tcId"],
                    "encaps": {"public_key": t["ek"], "coins": t["m"],
                               "ciphertext": e["c"], "shared_secret": e["k"]},
                })
            elif func == "decapsulation":
                schemes.setdefault(algo, []).append({
                    "count": t["tcId"],
                    "decaps": {"secret_key": t.get("dk", g.get("dk")),
                               "ciphertext": t["c"], "shared_secret": e["k"]},
                })
            else:
                op, key, field = (("check_pk", "ek", "public_key")
                                  if func.startswith("encap") else
                                  ("check_sk", "dk", "secret_key"))
                schemes.setdefault(algo, []).append({
                    "count": t["tcId"],
                    op: {field: t[key], "result": 0 if e["testPassed"] else -1},
                })

    for algo, tests in schemes.items():
        write_scheme(out_dir, algo, tests, f"NIST ACVP {version}")


def import_mldsa_acvp(version, out_dir, cache):
    a = fetch_acvp(version, cache, ACVP_MLDSA)
    schemes = {}  # algo -> list of tests

    def external_pure(name, g):
        if g.get("signatureInterface") == "external" and g.get("preHash") == "pure":
            return True
        iface = g.get("signatureInterface")
        mode = g.get("preHash") or ("external mu" if g.get("externalMu") else "message")
        print(f"  skipped {name} group {g['tgId']} ({g['parameterSet']}, {iface}, {mode},"
              f" {len(g['tests'])} tests): not in the common ABI")
        return False

    prompt, exp = a["ML-DSA-keyGen-FIPS204"]
    for g in prompt["testGroups"]:
        for t in g["tests"]:
            e = exp[t["tcId"]]
            schemes.setdefault(g["parameterSet"], []).append({
                "count": t["tcId"],
                "keygen": {"seed": t["seed"],
                           "verification_key": e["pk"], "signing_key": e["sk"]},
            })

    prompt, exp = a["ML-DSA-sigGen-FIPS204"]
    for g in prompt["testGroups"]:
        if not external_pure("sigGen", g):
            continue
        for t in g["tests"]:
            # deterministic signing is hedged signing with rnd = 0^32
            rnd = "00" * 32 if g["deterministic"] else t["rnd"]
            schemes.setdefault(g["parameterSet"], []).append({
                "count": t["tcId"],
                "sign": {"signing_key": t["sk"], "context": t["context"],
                         "message": t["message"], "randomness": rnd,
                         "signature": exp[t["tcId"]]["signature"]},
            })

    prompt, exp = a["ML-DSA-sigVer-FIPS204"]
    for g in prompt["testGroups"]:
        if not external_pure("sigVer", g):
            continue
        for t in g["tests"]:
            schemes.setdefault(g["parameterSet"], []).append({
                "count": t["tcId"],
                "verify": {"verification_key": t["pk"], "context": t["context"],
                           "message": t["message"], "signature": t["signature"],
                           "result": 0 if exp[t["tcId"]]["testPassed"] else -1},
            })

    for algo, tests in schemes.items():
        write_scheme(out_dir, algo, tests, f"NIST ACVP {version}", suffix="-acvp")


# --------------------------------------------------------------------------
# NIST CAVP SHAVS (SHA-2) -> schema
# --------------------------------------------------------------------------
def cavp_files(cache, cavp_dir):
    """{name: text} of the pinned .rsp files, from cavp_dir or the archive"""
    if cavp_dir is None:
        cache.mkdir(parents=True, exist_ok=True)
        archive = cache / "shabytetestvectors.zip"
        if not archive.exists():
            print(f"  downloading {CAVP_SHA2}")
            urllib.request.urlretrieve(CAVP_SHA2, archive)
        with zipfile.ZipFile(archive) as z:
            members = {Path(n).name: n for n in z.namelist()}
            data = {f: z.read(members[f]) for f in CAVP_SHA2_FILES if f in members}
    else:
        data = {f: (cavp_dir / f).read_bytes() for f in CAVP_SHA2_FILES
                if (cavp_dir / f).exists()}
    for f, digest in CAVP_SHA2_FILES.items():
        if f not in data:
            raise SystemExit(f"CAVP: no {f}")
        if hashlib.sha256(data[f]).hexdigest() != digest:
            raise SystemExit(f"CAVP: {f}: SHA-256 differs from the pinned one")
    return {f: d.decode() for f, d in data.items()}


def rsp_fields(text):
    """the (key, value) pairs of a CAVP .rsp file, in order"""
    for line in text.splitlines():
        if " = " in line and not line.startswith("#"):
            key, value = (x.strip() for x in line.split(" = ", 1))
            yield key, value


def import_sha2(out_dir, cache, cavp_dir):
    files = cavp_files(cache, cavp_dir)
    for prefix, (algo, name) in CAVP_SHA2_SETS.items():
        tests, count = [], 0
        for kind in ("ShortMsg", "LongMsg"):
            length = None
            for key, value in rsp_fields(files[f"{prefix}{kind}.rsp"]):
                if key == "Len":
                    length = int(value)
                elif key == "Msg":
                    msg = value[: length // 4]  # Len 0 is written as Msg = 00
                elif key == "MD":
                    tests.append({"count": count, "hash": {"message": msg, "digest": value}})
                    count += 1
        seed, digests = None, []
        for key, value in rsp_fields(files[f"{prefix}Monte.rsp"]):
            if key == "Seed":
                seed = value
            elif key == "MD":
                digests.append(value)
        tests.append({"count": count, "monte": {"seed": seed, "digests": digests}})
        path = out_dir / f"{name}.json"
        path.write_text(json.dumps({"algorithm": algo, "source": "NIST CAVP SHAVS (CAVS 11.1)",
                                    "tests": tests}, indent=1))
        print(f"  {path.name}: {len(tests)} test(s)")


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    here = Path(__file__).resolve().parent.parent
    ap.add_argument("--out", type=Path, default=here / "vectors")
    ap.add_argument("--acvp-version", default="v1.1.0.43")
    ap.add_argument("--only", choices=("mldsa", "mlkem", "sha2"))
    ap.add_argument("--cavp-dir", type=Path,
                    help="directory of the CAVP SHA-2 .rsp files (default: the archive)")
    args = ap.parse_args(argv)
    args.out.mkdir(parents=True, exist_ok=True)

    cache = args.out / ".cache"
    acvp = cache / "acvp" / args.acvp_version
    if args.only in (None, "sha2"):
        print("SHA-2 (NIST CAVP):")
        import_sha2(args.out, cache / "cavp", args.cavp_dir)
    if args.only == "sha2":
        return 0
    if args.only != "mlkem":
        print("ML-DSA (post-quantum-cryptography/KAT):")
        import_mldsa_pqc(args.out, cache / "pqc")
        print("ML-DSA (NIST ACVP):")
        import_mldsa_acvp(args.acvp_version, args.out, acvp)
    if args.only != "mldsa":
        print("ML-KEM (NIST ACVP):")
        import_mlkem(args.acvp_version, args.out, acvp)
        print("ML-KEM (post-quantum-cryptography/KAT):")
        import_mlkem_pqc(args.out, cache / "pqc")
    return 0


if __name__ == "__main__":
    sys.exit(main())
