(* The eta = 3 noise sampler of ML-KEM-512 against the specification, by circuit *)
require import AllCore List Int IntDiv BitEncoding StdBigop.
from Jasmin require import JModel.
from JazzEC require import Array256 Array200 Array32 WArray512 WArray200 WArray32.
from JazzEC require import Jkem_avx2.
require import AVX2_Ops W16extra.
require import Mlkem_bindings CircuitBindings.
require import XWord6.
require import XArray32 XArray200 XArray256.
from Spec require import GFq Rq Serialization Sampling SamplingCBD.
require import MLKEMFCLib.
import Zq Bigint BIA.

(* coefficient i: the sum of the bits 6i, 6i+1, 6i+2 of the input, minus the sum of
   the bits 6i+3, 6i+4, 6i+5 *)
op cbd3_bit (c : W6.t) (k : int) : W32.t =
  BSW32.shr (BS_W32_W6_U.zeroextu32 c) (W32.of_int k) `&` W32.of_int 1.

op cbd3_circuit (c : W6.t) : W16.t =
  truncateu16 (cbd3_bit c 0 + cbd3_bit c 1 + cbd3_bit c 2 -
               (cbd3_bit c 3 + cbd3_bit c 4 + cbd3_bit c 5)).

lemma cbd3_circuit_h (_b : W8.t Array200.t) :
  hoare [Jkem_avx2.M.__cbd3 : buf = _b ==>
    res = BSWA_256u16.init (fun i =>
      cbd3_circuit (W6.init (fun j => _b.[(6 * i + j) %/ 8].[(6 * i + j) %% 8])))].
proof.
proc.
proc change ^while.1 : { f0 <- if (0 <= (24*i)*8 <= 200*8-256) then
  BSWAS_200u8_256.sliceget buf ((24*i)*8) else get256_direct (WArray200.init8 (fun (i_0 : int) =>
  buf.[i_0])) (24*i); }.
+ by auto => &1 &2 [-> ->]; case (0 <= (24*i{2})*8 <= 200*8-256) => h //;
    rewrite BSWAS_200u8_256_slicegetE /#.
proc change ^while.29 : { rp <- if (0 <= (32*(2*i))*8 <= 256*16-256) then
  BSWAS_256u16_256.sliceset rp ((32*(2*i))*8) f0 else Array256.init (fun (i1:int) =>
  WArray512.get16 (WArray512.set256 (WArray512.init16 (fun (i_0 : int) => rp.[i_0])) (2*i) f0)
  i1); }.
+ by auto => &1 &2 [-> [-> ->]]; case (0 <= (32*(2*i{2}))*8 <= 256*16-256) => h //;
    rewrite BSWAS_256u16_256_slicesetE.
proc change ^while.30 : { rp <- if (0 <= (32*(2*i+1))*8 <= 256*16-256) then
  BSWAS_256u16_256.sliceset rp ((32*(2*i+1))*8) f1 else Array256.init (fun (i1:int) =>
  WArray512.get16 (WArray512.set256 (WArray512.init16 (fun (i_0 : int) => rp.[i_0])) (2*i+1) f1)
  i1); }.
+ by auto => &1 &2 [-> [-> ->]]; case (0 <= (32*(2*i{2}+1))*8 <= 256*16-256) => h //;
    rewrite BSWAS_256u16_256_slicesetE.
proc change 11 : { shufbidx <- BSWAS_32u8_256.sliceget cbd_jshufbidx 0; }.
+ auto => &1 &2 _; have := BSWAS_32u8_256_slicegetE 0 cbd_jshufbidx _; 1: done.
  by move=> h; rewrite (: 0 = 0 * 8) // -h.
cfold 12. unroll for ^while. cfold ^i<-.
wp -2.
conseq (: _ ==> rp = BSWA_256u16.init (fun i =>
  cbd3_circuit (W6.init (fun j => buf.[(6 * i + j) %/ 8].[(6 * i + j) %% 8])))).
+ by move=> &hr /= -> r ->.
by circuit.
qed.

(* the circuit of a coefficient, as a difference of bit sums *)
op cbd3_w (c : W6.t) (k : int) : W16.t = if c.[k] then W16.one else W16.zero.

lemma cbd3_circuitE (c : W6.t) : cbd3_circuit c =
  cbd3_w c 0 + cbd3_w c 1 + cbd3_w c 2 - (cbd3_w c 3 + cbd3_w c 4 + cbd3_w c 5).
proof. by circuit. qed.

lemma cbd3_circuit_sint (c : W6.t) : to_sint (cbd3_circuit c) =
  b2i c.[0] + b2i c.[1] + b2i c.[2] - (b2i c.[3] + b2i c.[4] + b2i c.[5]).
proof.
rewrite cbd3_circuitE /cbd3_w.
by case: c.[0]; case: c.[1]; case: c.[2]; case: c.[3]; case: c.[4]; case: c.[5] => /= *;
  rewrite /b2i /to_sint /smod /=.
qed.

lemma nth_bits192 (b : W8.t Array200.t) n : 0 <= n < 1536 =>
  nth false (BytesToBits (take 192 (to_list b))) n = b.[n %/ 8].[n %% 8].
proof.
move=> hn; rewrite /BytesToBits (BitEncoding.BitChunking.nth_flatten false 8).
+ by rewrite allP => x /mapP [y [_ ->]]; smt(W8.size_w2bits).
rewrite (nth_map witness); 1: smt(size_take Array200.size_to_list).
by rewrite nth_take 1,2:/# get_to_list w2bitsE /= nth_mkseq /#.
qed.

lemma cbd_coef3 bits k : cbd_coef 3 bits k =
  b2i (nth false bits (6 * k)) + b2i (nth false bits (6 * k + 1)) +
  b2i (nth false bits (6 * k + 2)) -
  (b2i (nth false bits (6 * k + 3)) + b2i (nth false bits (6 * k + 4)) +
   b2i (nth false bits (6 * k + 5))).
proof.
rewrite /cbd_coef !(big_ltn 0 3) //= !(big_ltn 1 3) //= !(big_ltn 2 3) //= !big_geq //=.
by rewrite (: 2 * k * 3 = 6 * k) 1:/#; ring.
qed.

lemma cbd3_post (b : W8.t Array200.t) &m :
  let r = BSWA_256u16.init (fun i =>
            cbd3_circuit (W6.init (fun j => b.[(6 * i + j) %/ 8].[(6 * i + j) %% 8]))) in
  lift_array256 r = samplePolyCBD 3 (take 192 (to_list b)) /\
  forall k, 0 <= k < 256 => -5 < to_sint r.[k] < 5.
proof.
rewrite /= (samplePolyCBDE &m) //.
have hc : forall k, 0 <= k < 256 =>
  to_sint (BSWA_256u16.init (fun (i : int) =>
    cbd3_circuit (W6.init (fun j => b.[(6 * i + j) %/ 8].[(6 * i + j) %% 8])))).[k] =
  cbd_coef 3 (BytesToBits (take 192 (to_list b))) k.
+ move=> k kb; rewrite /BSWA_256u16.init Array256.initiE //= cbd3_circuit_sint cbd_coef3.
  by rewrite !nth_bits192 1..6:/# !W6.initiE.
split.
+ apply Array256.tP => k kb; rewrite /lift_array256 mapiE //= hc //.
  by rewrite /cbd_poly Array256.initiE.
move=> k kb; rewrite hc // cbd_coef3; smt().
qed.

lemma cbd3_ll : islossless Jkem_avx2.M.__cbd3.
proof. by proc; while (true) (8 - i); auto => /#. qed.

phoare cbd3_corr_512 (_b : W8.t Array200.t) :
  [Jkem_avx2.M.__cbd3 : buf = _b ==>
    lift_array256 res = samplePolyCBD 3 (take 192 (to_list _b)) /\
    forall k, 0 <= k < 256 => -5 < to_sint res.[k] < 5] = 1%r.
proof.
conseq cbd3_ll (cbd3_circuit_h _b) => &hr _ r.
by split => [[] //|->]; have := cbd3_post _b &hr.
qed.
