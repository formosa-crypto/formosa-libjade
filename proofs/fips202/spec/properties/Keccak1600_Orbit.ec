(* -------------------------------------------------------------------- *)
(* The orbit of a single-block sponge input                             *)
(*                                                                      *)
(* A message shorter than the rate absorbs into the padded state P      *)
(* (no permutation call).  Block i of the output is the first bytes of  *)
(* keccak_f^(i+1) P, and keccak_f is a permutation: P comes back after  *)
(* L steps, so block k*L - 1 of the output is P again, and P's bytes    *)
(* between the domain-separation byte and the final padding bit are     *)
(* zero.  Every rejection sampler accepting a zero byte terminates.     *)
(* -------------------------------------------------------------------- *)
require import AllCore List Int IntDiv.
require import Keccak1600_Spec Keccakf1600_Perm Periodic.

(* -------------------------------------------------------------------- *)
(* a single-block message absorbs into its padded block                 *)
lemma ABSORB1600_single (trail : W8.t) (r8 : int) (m : W8.t list) :
  0 < r8 => size m < r8 =>
  ABSORB1600 trail r8 m = addratebit r8 (bytes2state (rcons m trail)).
proof.
move=> gt0r hsz; rewrite /ABSORB1600 /stateabsorb_last /stateabsorb_iblocks.
have -> : BitEncoding.BitChunking.chunk r8 m = [].
- by rewrite /BitEncoding.BitChunking.chunk pdiv_small 1:size_ge0 1:// mkseq0.
by rewrite /= /chunkremains pdiv_small 1:size_ge0 1:// /= drop0 /stateabsorb addstate_st0.
qed.

(* whose bytes after the domain-separation byte, before the last, are 0 *)
lemma absorbed_zero (trail : W8.t) (r8 : int) (m : W8.t list) (q : int) :
  0 < r8 <= 200 => size m < q < r8 - 1 =>
  (stbytes (ABSORB1600 trail r8 m)).[q] = W8.zero.
proof.
move=> hr hq; rewrite ABSORB1600_single 1,2:/# /addratebit stwordsK /addratebit8.
rewrite WArray200.get_setE 1:/# ifF 1:/# -bytes2stbytesP stwordsK.
rewrite WArray200.get_of_list 1:#smt:(size_ge0).
by rewrite nth_default // size_rcons /#.
qed.

(* -------------------------------------------------------------------- *)
(* the zero bytes of the padded block recur in the output stream, once   *)
(* per period of the absorbed state                                     *)
lemma KECCAK1600_zero_run (trail : W8.t) (r8 : int) (m : W8.t list) :
  0 < r8 <= 200 => size m < r8 =>
  exists L, 0 < L /\
    forall k q len, 1 <= k => size m < q < r8 - 1 => (k * L - 1) * r8 + q < len =>
      nth W8.zero (KECCAK1600 r8 m trail len) ((k * L - 1) * r8 + q) = W8.zero.
proof.
move=> hr hsz; have [L [gt0L hL]] := keccak_f1600_periodic (ABSORB1600 trail r8 m).
exists L; split => // k q len hk hq hlen.
have hkL : 1 <= k * L by smt(StdOrder.IntOrder.ler_pmul).
have hm : 0 <= (k * L - 1) * r8 by apply StdOrder.IntOrder.mulr_ge0; smt().
have ge0t : 0 <= (k * L - 1) * r8 + q by smt(size_ge0).
rewrite /KECCAK1600 nth_SQUEEZE1600.
- done.
- smt().
have -> : ((k * L - 1) * r8 + q) %/ r8 + 1 = k * L.
- by rewrite divzMDl 1:/# pdiv_small; smt(size_ge0).
have -> : ((k * L - 1) * r8 + q) %% r8 = q.
- by rewrite modzMDl pmod_small; smt(size_ge0).
by rewrite /FIPS202_SHA3_Spec.st_i (iter_periodM _ L k) 1,2:/# // (absorbed_zero trail r8 m q).
qed.

lemma SHAKE128_zero_run (m : W8.t list) : size m < 168 =>
  exists L, 0 < L /\
    forall k q len, 1 <= k => size m < q < 167 => (k * L - 1) * 168 + q < len =>
      nth witness (SHAKE128 m len) ((k * L - 1) * 168 + q) = W8.zero.
proof.
move=> hsz; have [L [gt0L hL]] := KECCAK1600_zero_run SHAKE_DS_BYTE 168 m _ hsz; 1: done.
exists L; split => // k q len hk hq hlen.
have hkL : 1 <= k * L by smt(StdOrder.IntOrder.ler_pmul).
have hm : 0 <= (k * L - 1) * 168 by apply StdOrder.IntOrder.mulr_ge0; smt().
rewrite (nth_change_dfl W8.zero) 2:/SHAKE128 2:hL //.
by rewrite size_SHAKE128; smt(size_ge0).
qed.

lemma SHAKE256_zero_run (m : W8.t list) : size m < 136 =>
  exists L, 0 < L /\
    forall k q len, 1 <= k => size m < q < 135 => (k * L - 1) * 136 + q < len =>
      nth witness (SHAKE256 m len) ((k * L - 1) * 136 + q) = W8.zero.
proof.
move=> hsz; have [L [gt0L hL]] := KECCAK1600_zero_run SHAKE_DS_BYTE 136 m _ hsz; 1: done.
exists L; split => // k q len hk hq hlen.
have hkL : 1 <= k * L by smt(StdOrder.IntOrder.ler_pmul).
have hm : 0 <= (k * L - 1) * 136 by apply StdOrder.IntOrder.mulr_ge0; smt().
rewrite (nth_change_dfl W8.zero) 2:/SHAKE256 2:hL //.
by rewrite size_SHAKE256; smt(size_ge0).
qed.
