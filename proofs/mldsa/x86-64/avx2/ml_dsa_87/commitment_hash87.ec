require import AllCore IntDiv.
from Jasmin require import JModel_x86.
require import Mldsa87.
require import CircuitBindings Bindings XArray64.
require import Array64 WArray64.

(* The comparison of the two commitment hashes of ML-DSA-87 (64 bytes). *)

lemma compare_commitment_hashes_ll : islossless M.__compare_commitment_hashes.
proof.
proc.
wp;while (0 <=  offset <= 64 /\ offset %% 16 = 0) (64 - offset); last by auto => />; smt().
auto => /> ; smt().
qed.

lemma compare_commitment_hashes_correct (_lhs _rhs : W8.t Array64.t) :
    phoare [ M.__compare_commitment_hashes :
        arg.`1 = _lhs /\ arg.`2 = _rhs
        ==>
        res = (if _lhs = _rhs then W64.of_int 0 else -W64.one)
    ] = 1%r.
proof.
have hh : hoare [ M.__compare_commitment_hashes :
    arg.`1 = _lhs /\ arg.`2 = _rhs
    ==>
    res = (if _lhs = _rhs then W64.of_int 0 else -W64.one) ].
+ proc => /=.
  proc change 2 : { lhs_bytes <- if (0 <=  offset * 8 <= 64*8-128)
                                  then BSWAS_64u8_128.sliceget lhs (offset * 8)
                                  else get128_direct (WArray64.init8 (fun i => lhs.[i])) (offset); }.
  + auto => /> &2.
    case (0 <= offset{2} * 8 <= 384); last  by auto.
    by move => ?; rewrite -BSWAS_64u8_128_slicegetE /#.
  proc change 3 : { rhs_bytes <- if (0 <=  offset * 8 <= 64*8-128)
                                  then BSWAS_64u8_128.sliceget rhs ( offset * 8)
                                  else get128_direct (WArray64.init8 (fun i => rhs.[i])) (offset); }.
  + auto => /> &2.
    case (0 <= offset{2} * 8 <= 384); last by auto.
    by move => ?; rewrite -BSWAS_64u8_128_slicegetE /#.
  proc change ^while.1 : { lhs_bytes <- if (0 <= offset * 8 <= 64*8-128)
                                         then BSWAS_64u8_128.sliceget lhs (offset * 8)
                                         else get128_direct (WArray64.init8 (fun i => lhs.[i])) (offset); }.
  + auto => /> &2.
    case (0 <= offset{2} * 8 <= 384); last by auto.
    by move => ?; rewrite -BSWAS_64u8_128_slicegetE /#.
  proc change ^while.2 : { rhs_bytes <- if (0 <= offset * 8 <= 64*8-128)
                                         then BSWAS_64u8_128.sliceget rhs (offset * 8)
                                         else get128_direct (WArray64.init8 (fun i => rhs.[i])) (offset); }.
  + auto => /> &2.
    case (0 <= offset{2} * 8 <= 384); last by auto.
    by move => ?; rewrite -BSWAS_64u8_128_slicegetE /#.
  cfold 1;unroll for ^while.
  cfold 16.
  wp 16.
  conseq (: _ ==> _lhs = _rhs <=> result = W64.of_int 65535).
  + move => &hr [<- <-] rr [Hl Hr].
    case (rr <> W64.of_int 65535); last first.
    + move => HH; rewrite Hr //=.
      move => ?; rewrite ifF 1:/# /=.
      case (lhs{hr} = rhs{hr}) => ?; 1: by
       rewrite to_uint_eq /=; smt(W64.to_uint_cmp pow2_64).
      by rewrite to_uint_eq /= to_uintN /=. 
  by circuit.
conseq compare_commitment_hashes_ll hh;smt().
qed.
