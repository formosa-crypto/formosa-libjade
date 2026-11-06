#!/usr/bin/env python3
"""Import KAT vectors into the bench/ JSON schema.

Two sources, both downloaded at a fixed version:

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

    python3 tools/import_kat.py --out vectors --acvp-version v1.1.0.43
"""

import argparse
import hashlib
import json
import sys
import urllib.request
from pathlib import Path

ACVP_BASE = "https://raw.githubusercontent.com/usnistgov/ACVP-Server/{v}/gen-val/json-files"
ACVP_MLKEM = ["ML-KEM-keyGen-FIPS203", "ML-KEM-encapDecap-FIPS203"]
ACVP_MLDSA = ["ML-DSA-keyGen-FIPS204", "ML-DSA-sigGen-FIPS204", "ML-DSA-sigVer-FIPS204"]
PQC_COMMIT = "f238e347b1323344208eb316df9993c923334817"
PQC_BASE = f"https://raw.githubusercontent.com/post-quantum-cryptography/KAT/{PQC_COMMIT}"
PQC_TESTS = 100  # ML-KEM records kept per parameter set (the files have 1000)


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


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    here = Path(__file__).resolve().parent.parent
    ap.add_argument("--out", type=Path, default=here / "vectors")
    ap.add_argument("--acvp-version", default="v1.1.0.43")
    ap.add_argument("--only", choices=("mldsa", "mlkem"))
    args = ap.parse_args(argv)
    args.out.mkdir(parents=True, exist_ok=True)

    cache = args.out / ".cache"
    acvp = cache / "acvp" / args.acvp_version
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
