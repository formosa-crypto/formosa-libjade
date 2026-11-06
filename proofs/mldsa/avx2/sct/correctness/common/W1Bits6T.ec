require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings JWordExtra.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array16 Array192 Array256 WArray16 WArray192 WArray1024.
require import XArray16 XArray192 XArray256 XWord6.
require import ArrayExtra JWord_extra EclibExtra JWordList Polyslices.
require BaseT PreludeT CommitmentT.

(* the polynomials as 256 lanes of 6 bits *)
clone BSWA as BSWA_256u6 with
      op asize <- 256,
      op bsize <- 6,
  theory A     <- Array256,
  theory BSA   <- BSA256,
  theory W     <- W6 { rename "_XX" as "_6" },
  theory WE    <- WE6,
  theory BSW   <- BSW6.

(* a 128-bit write into the encoding *)
op wr128 (t : W8.t Array192.t) (o : int) (s : W128.t) : W8.t Array192.t =
  Array192.init (WArray192.get8 (WArray192.set128_direct (WArray192.init8 (fun i => t.[i])) o s)).

(* The encoding of a polynomial of w1, for the sets where gamma2 =
   (q - 1) / 88 (ML-DSA-44): 6 bits per coefficient, 192 bytes per
   polynomial. *)
abstract theory W1Bits6T.

clone import BaseT.BaseT as B with
  op S.gamma2_div = 88,
  theory R.Array_w1_enc <- Array192,
  theory R.WArray_w1_enc <- WArray192.
import S R.
clone PreludeT.PreludeT as PR with theory B <- B.
import BitEncoding BitChunking.
import Round ZModQ Zq.

lemma truncateu_32_6E (w : W32.t) : BS_W32_W6_U.truncateu6 w = W6.bits2w (take 6 (W32.w2bits w)).
proof.
rewrite /truncateu6 W6.of_intE W32.to_uintE BS2Int.bs2int_mod //; congr.
have {1}-> : 6 = size (take 6 (w2bits w)) by rewrite size_take.
by rewrite BS2Int.bs2intK.
qed.

op b_w1 = 43. (* hb_range - 1 *)
lemma ilog_b_w1 : ilog 2 b_w1 = w1_bits - 1 by rewrite /b_w1 /=.

op commitment_encode_polynomial_lane (c : W32.t) : W6.t = BS_W32_W6_U.truncateu6 c.

lemma SimpleBitPack_liftE (p : wpoly) :
  wpoly_urng (b_w1 + 1) p =>
    SimpleBitPack (liftu_wpoly p) b_w1
  = to_list
  (BSWA_192u8.init
     (fun (i0 : int) =>
        W8.init
          (fun (j : int) =>
             (BSWA_256u6.init (fun (i1 : int) => commitment_encode_polynomial_lane p.[i1])).[
             (i0 * 8 + j) %/ 6].[(i0 * 8 + j) %% 6]))).
proof.
move=> h @/SimpleBitPack; (pose l := ilog 2 _) => /=.
have := ilog_b_w1; rewrite /= => ?.
have ? : size (flatten (map (fun (x : W32.t) =>
    IntegerToBits (asint (incoeff (to_uint x))) (l + 1)) (to_list p))) = 256 * 6.
+ rewrite (size_flatten_ctt (l + 1)).
  + by move=> x; rewrite mapP => Hx; elim Hx => xw /= [? ->];
      rewrite /IntegerToBits BS2Int.size_int2bs.
  by rewrite size_map /= size_to_list /l /= /#.
rewrite /BitsToBytes !array256_mapE /=.
rewrite -map_comp &(eq_sym) -map_comp /(\o) /=.
apply (eq_from_nth witness); 1: by rewrite size_to_list /= size_map size_iota /#.
move=> i; rewrite size_to_list => Hi.
rewrite get_to_list (nth_map witness) /=; 1: by rewrite size_iota /#.
rewrite wordP => j jb.
rewrite !initiE //= initiE 1:/# /= get_bits2w // nth_take // 1:/# nth_drop; 2: by smt().
+ by rewrite nth_iota /#.
rewrite (nth_flatten false (l + 1)).
+ by rewrite allP => x; rewrite mapP => Hx; elim Hx => xw /= [? ->];
    rewrite /IntegerToBits BS2Int.size_int2bs.
rewrite nth_iota 1:/# (nth_map witness) /=; 1: by rewrite size_to_list /= /#.
rewrite /commitment_encode_polynomial_lane.
pose v := p.[(i * 8 + j) %/ 6].
have -> : p.[(8 * i + j) %/ (l + 1)] = v by smt().
move: h => @/wpoly_urng /array256_allP /(_ v _) //= /=.
+ by rewrite /to_list /mkseq mapP; exists ((i * 8 + j) %/ 6); smt(mem_iota).
move=> h.
rewrite incoeffK truncateu_32_6E get_bits2w 1:/#.
rewrite nth_take 1,2:/#.
rewrite /IntegerToBits w2bits_int2bsE /l ilog_b_w1 /= (modz_small _ q) 1:/# /BS2Int.int2bs.
by rewrite !nth_mkseq 1,2:/# /= /#.
qed.

lemma commitment_encode_polynomial_bits6_circuit (_a : W32.t Array256.t) :
   hoare [ M.commitment____encode_polynomial_bits6 :
       raw = BSWA_256u32.init (fun i => BS_W32_W6_U.zeroextu32 (BS_W32_W6_U.truncateu6 _a.[i]))
     ==>
       res =
         (let mapped = BSWA_256u6.init (fun i => commitment_encode_polynomial_lane _a.[i]) in
          BSWA_192u8.init (fun i => W8.init (fun j => mapped.[(i*8+j) %/ 6].[(i*8+j) %% 6])))
   ].
proof.
proc; inline *.
(* the writes are slices of the encoding *)
proc change ^while.^encoded<- : {
  encoded <-
    if 0 <= output_offset * 8 <= 1408
    then BSWAS_192u8_128.sliceset encoded (output_offset * 8) bytestream_lower
    else wr128 encoded (output_offset) bytestream_lower; }.
+ auto => /> &2; case (0 <= output_offset{2} * 8 <= 1408) => h; last by auto.
  by rewrite (BSWAS_192u8_128_slicesetE _ _ _ h).
proc change ^while.^encoded<-{2} : {
  encoded <-
    if 0 <= (output_offset + 12) * 8 <= 1408
    then BSWAS_192u8_128.sliceset encoded ((output_offset + 12) * 8) bytestream_upper
    else wr128 encoded (output_offset + 12) bytestream_upper; }.
+ auto => /> &2; case (0 <= (output_offset{2} + 12) * 8 <= 1408) => h; last by auto.
  by rewrite (BSWAS_192u8_128_slicesetE _ _ _ h).
proc change ^encoded<- : {
  encoded <-
    if 0 <= output_offset * 8 <= 1408
    then BSWAS_192u8_128.sliceset encoded (output_offset * 8) bytestream_lower
    else wr128 encoded (output_offset) bytestream_lower; }.
+ auto => /> &2; case (0 <= output_offset{2} * 8 <= 1408) => h; last by auto.
  by rewrite (BSWAS_192u8_128_slicesetE _ _ _ h).
proc change ^final_encoded_bytes<-{2} : {
  final_encoded_bytes <- BSWAS_16u8_128.sliceset final_encoded_bytes 0 bytestream_upper; }.
+ by auto => /> &2; rewrite (BSWAS_16u8_128_slicesetE _ 0).
(* the offsets are constants once the loops are unrolled *)
unroll for ^while.
unroll for ^while.
cfold 2; cfold ^output_offset<-; wp -3; proc rewrite /=.
proc rewrite get256_polyE; proc rewrite /=.
by circuit.
qed.

lemma commitment_encode_polynomial_bits6 (_a : W32.t Array256.t) :
   hoare [ M.commitment____encode_polynomial_bits6 :
       raw = _a /\ wpoly_urng (b_w1 + 1) _a
     ==>
       to_list res = SimpleBitPack (liftu_wpoly _a) b_w1 ].
proof.
conseq (commitment_encode_polynomial_bits6_circuit _a).
- move=> &hr [-> +]; rewrite /wpoly_urng allP => ?.
  rewrite tP => k kb; rewrite initiE 1:/# /= /zeroextu32 /truncateu6 /= of_uintK /=.
  by rewrite modz_small 1:/# to_uintK.
by move=> &hr [_ h] r ->; rewrite SimpleBitPack_liftE.
qed.

lemma commitment_encode_polynomial (_a : W32.t Array256.t) :
   hoare [ M.commitment____encode_polynomial :
       commitment = _a /\ wpoly_urng (b_w1 + 1) _a
     ==>
       to_list res = SimpleBitPack (liftu_wpoly _a) b_w1 ].
proof. by proc; rcondt 1; [auto | call (commitment_encode_polynomial_bits6 _a); auto]. qed.

lemma commitment____encode_polynomial_ll : islossless M.commitment____encode_polynomial.
proof.
proc; rcondt 1; 1: by auto.
inline *; wp.
by unroll for ^while; unroll for ^while; auto.
qed.

(* -------------------------------------------------------------------- *)
(* The hypotheses of CommitmentT, for these sets                        *)
(* -------------------------------------------------------------------- *)
clone CommitmentT.CommitmentT as CMT with theory B <- B, theory PR <- PR
proof *.
realize commitment_encode_polynomial.
move=> _a; conseq (commitment_encode_polynomial _a).
- by move=> &hr; rewrite /hb_range /gamma2 /b_w1 /=.
by move=> &hr _ r; rewrite /hb_range /gamma2 /b_w1 /=.
qed.
realize commitment____encode_polynomial_ll by exact commitment____encode_polynomial_ll.

end W1Bits6T.
