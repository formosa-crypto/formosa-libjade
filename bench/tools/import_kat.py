#!/usr/bin/env python3
"""Import KAT vectors into the bench/ JSON schema.

ML-DSA: converts the hash-based "pqc" KAT files (key_generation_seed, context,
        message, signing_randomness + sha3_256 hashes of vk/sk/sig), and
        downloads NIST ACVP ML-DSA-keyGen / -sigGen / -sigVer, converted to
        full-value vectors (mldsa<n>-acvp.json). Only the groups of the
        external, pure interface are imported, the one the common ABI
        exposes; the importer lists the others.
ML-KEM: downloads NIST ACVP ML-KEM-keyGen / ML-KEM-encapDecap (prompt +
        expectedResults) and converts to full-value vectors, the
        encapsulation and decapsulation key checks (FIPS 203 7.2, 7.3)
        included.

    python3 tools/import_kat.py --out vectors \\
        --pqc /path/to/formosa-mldsa/tests/pqc --acvp-version v1.1.0.43
"""

import argparse
import json
import sys
import urllib.request
from pathlib import Path

ACVP_BASE = "https://raw.githubusercontent.com/usnistgov/ACVP-Server/{v}/gen-val/json-files"
ACVP_MLKEM = ["ML-KEM-keyGen-FIPS203", "ML-KEM-encapDecap-FIPS203"]
ACVP_MLDSA = ["ML-DSA-keyGen-FIPS204", "ML-DSA-sigGen-FIPS204", "ML-DSA-sigVer-FIPS204"]


def base_name(algo):
    return algo.replace("-", "").lower()  # "ML-KEM-512" -> "mlkem512"


def write_scheme(out_dir, algo, tests, source, suffix=""):
    path = out_dir / f"{base_name(algo)}{suffix}.json"
    path.write_text(json.dumps(
        {"algorithm": algo, "source": source, "tests": tests}, indent=1))
    print(f"  {path.name}: {len(tests)} test(s)")


# --------------------------------------------------------------------------
# ML-DSA: hash-based pqc KAT -> schema
# --------------------------------------------------------------------------
def import_mldsa(pqc_dir, out_dir):
    for setn in (44, 65, 87):
        src = pqc_dir / f"ml_dsa_{setn}.json"
        if not src.exists():
            print(f"  (skip ML-DSA-{setn}: {src} not found)")
            continue
        tests = []
        for r in json.loads(src.read_text()):
            tests.append({
                "count": int(r["count"]),
                "keygen": {
                    "seed": r["key_generation_seed"],
                    "verification_key_sha3_256": r["sha3_256_hash_of_verification_key"],
                    "signing_key_sha3_256": r["sha3_256_hash_of_signing_key"],
                },
                "sign": {
                    "context": r["context"],
                    "message": r["message"],
                    "randomness": r["signing_randomness"],
                    "signature_sha3_256": r["sha3_256_hash_of_signature"],
                },
            })
        write_scheme(out_dir, f"ML-DSA-{setn}", tests, f"pqc KAT ({src.name})")


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
    ap.add_argument("--pqc", type=Path,
                    default=Path("/Users/strub/Projects/formosa-mldsa/tests/pqc"),
                    help="directory with ml_dsa_{44,65,87}.json (pqc KAT)")
    ap.add_argument("--acvp-version", default="v1.1.0.43")
    ap.add_argument("--only", choices=("mldsa", "mlkem"))
    args = ap.parse_args(argv)
    args.out.mkdir(parents=True, exist_ok=True)

    cache = args.out / ".acvp-cache" / args.acvp_version
    if args.only != "mlkem":
        print("ML-DSA (pqc KAT):")
        import_mldsa(args.pqc, args.out)
        print("ML-DSA (NIST ACVP):")
        import_mldsa_acvp(args.acvp_version, args.out, cache)
    if args.only != "mldsa":
        print("ML-KEM (NIST ACVP):")
        import_mlkem(args.acvp_version, args.out, cache)
    return 0


if __name__ == "__main__":
    sys.exit(main())
