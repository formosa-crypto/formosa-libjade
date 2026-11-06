#!/bin/sh
# The checks of one job of the checks workflow, one result per check and
# target, recorded by checks-record.py into OUT (JSON lines). Every check
# runs; the script fails if one of them fails.
#
#   checks.sh ct|extraction|kat-memcheck OUT
set -u
job=$1
out=$2
here=$(cd "$(dirname "$0")" && pwd)
cd "$here/.."
mkdir -p "$(dirname "$out")"
: > "$out"

rec() { python3 "$here/checks-record.py" "$@"; }
rc=0

case $job in
  ct)
    rec tool "$out" jasmin -- jasminc -version
    for t in mlkem512 mlkem768 mlkem1024 mldsa44 mldsa65 mldsa87; do
      for k in ct sct; do
        rec run "$out" $k $t -- make -C src $k-$t || rc=1
      done
    done
    ;;
  extraction)
    rec tool "$out" jasmin -- jasminc -version
    rec tool "$out" jasmin2ec -- jasmin2ec --version
    rec tool "$out" jasmin2ec-safety -- jasmin2ec-safety --version
    for k in correctness safety; do
      rec run "$out" extraction $k -- make -C proofs extract-$k || rc=1
    done
    rec run "$out" extraction unchanged -- make -C proofs extraction-unchanged || rc=1
    rec run "$out" extraction assembly -- make -C src extract-asm || rc=1
    rec run "$out" extraction assembly-unchanged -- make -C src asm-unchanged || rc=1
    ;;
  kat-memcheck)
    rec tool "$out" jasmin -- jasminc -version
    rec tool "$out" cc -- cc --version
    rec tool "$out" valgrind -- valgrind --version
    rec run "$out" build assembly -- make -C src || exit 1
    for v in bench/vectors/*.json; do
      f=$(basename "$v")
      rec run "$out" kat "${f%.json}" -- make -C bench test BACKENDS=jasmin VECTORS=vectors/$f || rc=1
    done
    for s in ML-KEM-512 ML-KEM-768 ML-KEM-1024 ML-DSA-44 ML-DSA-65 ML-DSA-87; do
      t=$(echo $s | tr -d - | tr A-Z a-z)
      rec run "$out" memcheck $t -- make -C bench memcheck ALL_SCHEMES=$s || rc=1
    done
    ;;
  *)
    echo "unknown job $job" >&2
    exit 2
    ;;
esac
exit $rc
