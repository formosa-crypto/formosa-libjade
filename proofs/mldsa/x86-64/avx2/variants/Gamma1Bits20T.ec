require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings JWordExtra.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array256 Array640 WArray640.
require import ArrayExtra JWord_extra EclibExtra JWordList.
require import XArray256 XArray640 XArray16 XWord20.
require BaseT PreludeT Gamma1T.

(* The encoding of a polynomial with coefficients in (-gamma1, gamma1], for
   the sets where gamma1 = 2^19 (ML-DSA-65, ML-DSA-87): 20 bits per
   coefficient, 640 bytes per polynomial. *)
abstract theory Gamma1Bits20T.

clone import BaseT.BaseT as B with
  op S.gamma1_log = 19,
  theory R.Array_gamma1_enc <- Array640,
  theory R.WArray_gamma1_enc <- WArray640.
import S R.
clone PreludeT.PreludeT as PR with theory B <- B.
import BitEncoding BitChunking.
import Round ZModQ Zq.

lemma gamma1_val : gamma1 = 524288 by rewrite /gamma1.

lemma truncateu_32_20E (w : W32.t) : BS_W32_W20_U.truncateu20 w = W20.bits2w (take 20 (W32.w2bits w)).
proof.
rewrite /truncateu20 W20.of_intE W32.to_uintE BS2Int.bs2int_mod //;congr.
have {1}-> : 20 = size (take 20 (w2bits w)) by rewrite size_take //.
by rewrite BS2Int.bs2intK.
qed.

import W20.
(* Circuit spec *)

op gamma1_encode_polynomial_lane(c : W32.t) : W20.t =
    BS_W32_W20_U.truncateu20 ((W32.of_int 524288) + (-c)).


lemma BitPack_liftE (p : wpoly) :
  wpoly_srng (gamma1 - 1) gamma1 p =>
    BitPack (lifts_wpoly p) (gamma1 - 1) gamma1
  = to_list (let mapped = BSWA_256u20.init (fun i => gamma1_encode_polynomial_lane p.[i]) in
             BSWA_640u8.init (fun i => W8.init (fun j => mapped.[(i*8+j) %/ 20].[(i*8+j) %% 20]))).
proof.
have Hgamma1 := gamma1_val.
move=> h @/BitPack; (pose l := ilog 2 _) => /=.
have Hlog := ilog_gamma1.
have ? : size
  (flatten (map (fun (x : W32.t) => IntegerToBits (gamma1 - crepr (incoeff (to_sint x))) (l + 1)) (to_list p))) = 256*20.
+  rewrite  (size_flatten_ctt (l+1)).
  +  by move => x; rewrite mapP => Hx;elim Hx => xw /= [? ->]; rewrite /IntegerToBits BS2Int.size_int2bs // /#.
  by rewrite size_map /= size_to_list  /l /= /#.

rewrite /BitsToBytes !array256_mapE /=.
rewrite  -map_comp &(eq_sym) -map_comp /(\o) /=.
apply (eq_from_nth witness);1: by rewrite size_to_list /= size_map size_iota /#.
move => i; rewrite size_to_list => Hi.
rewrite get_to_list (nth_map witness) /=; 1: by rewrite size_iota /#.
rewrite wordP => j jb.
rewrite !initiE //= initiE 1:/# /= get_bits2w // nth_take // 1:/# nth_drop;2: by smt().
+ rewrite nth_iota /#.
rewrite (nth_flatten false (l+1)).
+ by rewrite allP => x;rewrite mapP => Hx;elim Hx => xw /= [? ->]; rewrite /IntegerToBits BS2Int.size_int2bs // /#.
rewrite nth_iota 1:/#  (nth_map witness) /=; 1: by rewrite size_to_list /= /#.
rewrite /gamma1_encode_polynomial_lane .
pose v:=p.[(i * 8 + j) %/ gamma1_bits].
have -> : p.[(8 * i + j) %/ (l + 1)] = v by smt().
move: h => @/wpoly_srng /array256_allP /(_ v _) //= /=.
+ rewrite /to_list /mkseq mapP; exists ((i * 8 + j) %/ gamma1_bits); smt(mem_iota).
move => h.
rewrite incoeffK_centered 1,2:/# truncateu_32_20E get_bits2w 1:/#.
rewrite nth_take 1,2:/# w2bits_int2bsE.
have  -> := BS2Int.int2bs_cat 20 32 (to_uint (W32.of_int 524288 - v)) _;1:smt().
rewrite /IntegerToBits nth_cat ifT;1: by rewrite BS2Int.size_int2bs /#.
congr;2:smt().
congr;1:smt().
have := (W32.of_uintK (gamma1 - to_sint v)).
rewrite modz_small;1:by smt(pow2_64).
move => <-; rewrite -W32.of_intD';congr.
rewrite W32.of_intN;congr.
rewrite /=.
case (2147483648 <= to_uint v) => ?;last by smt(W32.to_uintK pow2_32).
move : h; rewrite /to_sint /smod ifT /#.
congr;rewrite to_uint_eq of_uintK /=;smt(W32.to_uint_cmp pow2_32).
qed.

require import WArray640 WArray1024.

lemma gamma1_encode_polynomial_bits20 _a :
   hoare [ M.gamma1____encode_polynomial_bits20 :
       polynomial = _a /\ wpoly_srng 524287 524288 _a
     ==>
       to_list res = BitPack (lifts_wpoly _a) (gamma1-1) gamma1
   ].
have Hgamma1 := gamma1_val.
proc;inline * => /=.
proc change 2 : { temp <- W64.of_int 524288;}; 1: by  auto; rewrite /(`<<`) /= /#.
proc change 3 : { gamma1 <- zeroextu256 temp; }.
+ auto => &1 &2 ->; rewrite /VMOV_64 zeroextu256E zeroextu256E.
  rewrite wordP => i ib.
  rewrite pack2E pack2E pack4E initiE 1:/# /= initiE 1:/# /= initiE 1:/# /= initiE 1:/# /=.
  case (i %/ 64 = 0) => ?; 1: by rewrite ifT 1:/# initiE 1:/# /= get_of_list /#.
  case (i %/ 128 = 0) => ?; 2: by auto.
  rewrite initiE 1:/# /= get_of_list 1:/#.
  by have -> /= : (i %% 128 %/ 64) = 1 by smt().
proc change ^while.1 : { coefficients <- if (0 <= input_offset*8 <= 32*256-256)
                                         then BSWAS_256u32_256.sliceget polynomial (input_offset*8)
                                         else get256_direct (WArray1024.init32 (fun (i_0 : int) => polynomial.[i_0])) input_offset ;}.
                + auto => /> &2.
                  case (0 <= input_offset{2} * 8 <= 7936); last by auto.
                  by move => ?; rewrite BSWAS_256u32_256_slicegetE /#.
proc change ^while.13 : {output <- if (0 <= output_offset*8 <= 8*640-128)
                                    then BSWAS_640u8_128.sliceset output (output_offset*8) lower
                                    else Array640.init (get8 (set128_direct (WArray640.init8 (fun (i_0 : int) => output.[i_0])) output_offset lower));}.
               + auto => /> &2.
                 case (0 <= output_offset{2} * 8 <= 4992); last by auto.
                 by move => ?; rewrite BSWAS_640u8_128_slicesetE /#.
proc change ^while.15 : {output <- if (0 <= output_offset*8 <= 8*640-128)
                                    then BSWAS_640u8_128.sliceset output (output_offset*8) upper
                                    else Array640.init (get8 (set128_direct (WArray640.init8 (fun (i_0 : int) => output.[i_0])) output_offset upper));}.
               + auto => /> &2.
                 case (0 <= output_offset{2} * 8 <= 4992); last by auto.
                 by move => ?; rewrite BSWAS_640u8_128_slicesetE /#.
proc change 8 : { coefficients <- if (0 <= input_offset*8 <= 32*256-256)
                                  then BSWAS_256u32_256.sliceget polynomial (input_offset*8)
                                  else get256_direct (WArray1024.init32 (fun (i_0 : int) => polynomial.[i_0])) input_offset;}.
                + auto => /> &2.
                  case (0 <= input_offset{2} * 8 <= 7936); last by auto.
                  by move => ?; rewrite BSWAS_256u32_256_slicegetE /#.
proc change 20 : {output <- if (0 <= output_offset*8 <= 8*640-128)
                             then BSWAS_640u8_128.sliceset output (output_offset*8) lower
                             else Array640.init (get8 (set128_direct (WArray640.init8 (fun (i_0 : int) => output.[i_0])) output_offset lower));}.
               + auto => /> &2.
                 case (0 <= output_offset{2} * 8 <= 4992); last by auto.
                 by move => ?; rewrite BSWAS_640u8_128_slicesetE /#.
proc change 22 : { final_output_block <- BSWAS_16u8_128.sliceset final_output_block 0 upper;}.
               + by auto => /> &2;have /= -> := BSWAS_16u8_128_slicesetE final_output_block{2} 0 upper{2} _;1:smt().
unroll for ^while.
unroll for ^while.
cfold 5.
cfold 439.
wp -3.

conseq (:  _ ==>
           output = let mapped = BSWA_256u20.init (fun i => gamma1_encode_polynomial_lane _a.[i]) in
             BSWA_640u8.init (fun i => W8.init (fun j => mapped.[(i*8+j) %/ 20].[(i*8+j) %% 20])));last by circuit.

+ by move => &hr [<- Hrng] ? /= => ->;rewrite BitPack_liftE //= /#.

qed.

lemma gamma1_encode_polynomial _a :
   hoare [ M.gamma1____encode_polynomial :
       polynomial = _a /\ wpoly_srng 524287 524288 _a
     ==>
       to_list res = BitPack (lifts_wpoly _a) (gamma1-1) gamma1
   ].
proof. by proc; rcondf 1; [auto | call (gamma1_encode_polynomial_bits20 _a); auto]. qed.


op gamma1_decode_to_polynomial_lane(c : W20.t) : W32.t =
    ((W32.of_int 524288) + (- (BS_W32_W20_U.zeroextu32 c))).

lemma gamma1_decode_lane_sint (c : W20.t) :
    W32.to_sint (gamma1_decode_to_polynomial_lane c) = gamma1 - W20.to_uint c.
have Hgamma1 := gamma1_val.
have Hc := W20.to_uint_cmp c.
rewrite /gamma1_decode_to_polynomial_lane /zeroextu32.
have := W32.to_sintK_small (gamma1 - W20.to_uint c).
have /= /#:= W20.to_uint_cmp .
qed.

lemma BitUnack_liftE (bytes : W8.t Array640.t) :
    BitUnpack (to_list bytes) (gamma1 - 1) gamma1
  =
  (map (fun (w : W32.t) => incoeff (to_sint w))
     (BSWA_256u32.init
        (fun (i : int) =>
           gamma1_decode_to_polynomial_lane
             (W20.init (fun (j : int) => bytes.[(gamma1_bits * i + j) %/ 8].[(gamma1_bits * i + j) %% 8]))))).
proof.
have Hgamma1 := gamma1_val.
move=>  @/BitUnpack /=; rewrite tP => i ib.
rewrite initiE 1:// mapiE //= initiE 1:/# /=.
pose l1 := List.map _ _.
have sl1 : size l1 = n.
+   rewrite /l1;rewrite !size_map size_iota ilog_gamma1 /= /BytesToBits.
  rewrite (EclibExtra.size_flatten' 8);1: by smt(mapP W8.size_w2bits).
  by rewrite size_map size_to_list /= /#.
rewrite (nth_map []) /=.
+ rewrite size_chunk ilog_gamma1 //=.
  rewrite /BytesToBits.
  rewrite (EclibExtra.size_flatten' 8);1: by smt(mapP W8.size_w2bits).
  by rewrite size_map size_to_list /= /#.
congr; rewrite  /gamma1_decode_to_polynomial_lane.
rewrite ilog_gamma1 /= /zeroextu32.
rewrite nth_chunk // 1:/#.
+ rewrite /BytesToBits.
  rewrite (EclibExtra.size_flatten' 8);1: by smt(mapP W8.size_w2bits).
  by rewrite size_map size_to_list /= /#.
have  := BS2Int.bs2int_le2Xs ((take gamma1_bits (drop (gamma1_bits * i) (BytesToBits (to_list bytes))))).
+ rewrite size_take // size_drop 1:/# /max /= (EclibExtra.size_flatten' 8);1: by smt(mapP W8.size_w2bits).
  rewrite !size_map !size_iota /max /=.
  pose ll := if _ then _ else _.
  have -> /= : ll = 20;1: by smt().
rewrite /BitsToInteger.
pose p := BS2Int.bs2int  (take gamma1_bits (drop (gamma1_bits * i) (BytesToBits (to_list bytes)))) .
move => ?.
have ? : 0 <= p by smt(BS2Int.bs2int_ge0).
have <- : p = to_uint (W20.init (fun (j : int) => bytes.[(gamma1_bits * i + j) %/ 8].[(gamma1_bits * i + j) %% 8])); last by have /= :=  W32.to_sintK_small (gamma1 - p); smt().
rewrite /to_uint /p;congr.
apply (eq_from_nth false).
+ rewrite size_take // size_drop 1:/# size_w2bits /BytesToBits.
  rewrite (EclibExtra.size_flatten' 8);1: by smt(mapP W8.size_w2bits).
  by rewrite size_map size_to_list /= /#.
move => k kb.
have ? : size (take gamma1_bits (drop (gamma1_bits * i) (BytesToBits (to_list bytes)))) = gamma1_bits.
+ rewrite size_take // size_drop 1:/# /BytesToBits.
  rewrite (EclibExtra.size_flatten' 8);1: by smt(mapP W8.size_w2bits).
  by rewrite size_map size_to_list /= /#.
rewrite nth_take 1,2:/# nth_drop 1,2:/# /BytesToBits.
rewrite (nth_flatten false 8).
+ rewrite allP => j /=.
  rewrite mapP => Hx;elim Hx;smt(W8.size_w2bits).
rewrite (nth_map witness) /=; 1: by rewrite size_to_list /#.
by rewrite initiE 1:/# /=.
qed.


lemma gamma1_decode_to_polynomial_bits20 _a :
   hoare [ M.gamma1____decode_to_polynomial_bits20 :
       bytes = _a
     ==>
       lifts_wpoly res = BitUnpack (to_list _a) (gamma1-1) gamma1 /\
       wpoly_srng (gamma1-1) gamma1 res
   ].
proc => /=.
proc change 1 : { temp <- W64.of_int 524288;}; 1: by  auto; rewrite /(`<<`) /= /#.
proc change 2 : { temp1 <- zeroextu128 temp; }.
+ auto => &1 &2 ->; rewrite /VMOV_64 zeroextu128E.
  rewrite wordP => i ib.
  rewrite pack2E  initiE 1:/# /= pack2E initiE 1:/# /= initiE 1:/# /=.
  case (i %/ 64 = 0) => ?;1: by rewrite get_of_list /#.
  by rewrite get_of_list 1:/# /= ifF 1:/# /=.
proc change 4 : { temp <- W64.of_int 1048575;}; 1: by auto.
proc change 5 : { temp1 <- zeroextu128 temp; }.
+ auto => &1 &2 ->; rewrite /VMOV_64 zeroextu128E.
  rewrite wordP => i ib.
  rewrite pack2E  initiE 1:/# /= pack2E initiE 1:/# /= initiE 1:/# /=.
  case (i %/ 64 = 0) => ?;1: by rewrite get_of_list /#.
  by rewrite get_of_list 1:/# /= ifF 1:/# /=.
proc change ^while.1 : { sixteen_bytes <- if (0 <= input_offset*8 <= 8*640-128)
                                          then BSWAS_640u8_128.sliceget bytes (input_offset*8)
                                          else get128_direct (WArray640.init8 (fun (i_0 : int) => bytes.[i_0])) input_offset ;}.
                + auto => /> &2.
                  case (0 <= input_offset{2} * 8 <= 4992); last by auto.
                  by move => ?; rewrite -BSWAS_640u8_128_slicegetE /#.
proc change ^while.4 : { sixteen_bytes <- if (0 <= input_offset*8 <= 8*640-128)
                                          then BSWAS_640u8_128.sliceget bytes (input_offset*8)
                                          else get128_direct (WArray640.init8 (fun (i_0 : int) => bytes.[i_0])) input_offset ;}.
                + auto => /> &2.
                  case (0 <= input_offset{2} * 8 <= 4992); last by auto.
                  by move => ?; rewrite -BSWAS_640u8_128_slicegetE /#.
proc change ^while.13 : {polynomial <- if (0 <= output_offset*8 <= 32*256-256)
                                        then BSWAS_256u32_256.sliceset polynomial (output_offset*8) coefficients
                                        else Array256.init (get32 (set256_direct (WArray1024.init32 (fun (i_0 : int) => polynomial.[i_0])) output_offset coefficients));}.
               + auto => /> &2.
                 case (0 <= output_offset{2} * 8 <= 7936); last by auto.
                 by move => ?; rewrite BSWAS_256u32_256_slicesetE /#.

unroll for ^while.

cfold 8.
wp -2.
conseq (_: _ ==>
    polynomial = BSWA_256u32.init (fun i => gamma1_decode_to_polynomial_lane (W20.init (fun j =>
               _a.[(20*i+j) %/ 8].[(20*i+j) %% 8])))); last by circuit.

(* Part 1: lifts_wpoly equality, Part 2: wpoly_srng range *)
move=> &hr |>; split.
+ rewrite /lifts_wpoly /=; apply (inj_eq Array256.to_list Array256.to_list_inj).
  by rewrite BitUnack_liftE ~-1:// !array256_mapE; do 2!congr => //.

rewrite /wpoly_srng array256_allP /= => w.
rewrite /to_list mkseqP => He;elim He => k [Hk ->] /=.
rewrite initiE 1:/# /=.
rewrite gamma1_decode_lane_sint.
rewrite gamma1_val /=.
have /= /#:= W20.to_uint_cmp.
qed.

lemma gamma1_decode_to_polynomial _a :
   hoare [ M.gamma1____decode_to_polynomial :
       bytes = _a
     ==>
       lifts_wpoly res = BitUnpack (to_list _a) (gamma1-1) gamma1 /\
       wpoly_srng (gamma1-1) gamma1 res
   ].
proof. by proc; rcondf 1; [auto | call (gamma1_decode_to_polynomial_bits20 _a); auto]. qed.

lemma gamma1_encode_polynomial_ll_bits20 : islossless M.gamma1____encode_polynomial_bits20.
proc.
while (0 <= i <= 10) (10 - i); 1: by auto => /> /#.
inline 9; wp;conseq (: _ ==> true); 1: by smt().
by while (0 <= input_offset <= 992 /\ input_offset %% 32 = 0) (992 - input_offset); move => *; inline *; auto => /> /#.
qed.

lemma gamma1_encode_polynomial_ll : islossless M.gamma1____encode_polynomial.
proof. by proc; rcondf 1; [auto | call gamma1_encode_polynomial_ll_bits20]. qed.

lemma gamma1_decode_to_polynomial_ll_bits20 : islossless M.gamma1____decode_to_polynomial_bits20.
proc.
while (0 <= output_offset <= 1024 /\ output_offset %% 32 = 0) (1024 - output_offset); 1: by auto => /> /#.
by auto => /> /#.
qed.

lemma gamma1_decode_to_polynomial_ll : islossless M.gamma1____decode_to_polynomial.
proof. by proc; rcondf 1; [auto | call gamma1_decode_to_polynomial_ll_bits20]. qed.

(* -------------------------------------------------------------------- *)
(* The hypotheses of Gamma1T, for these sets                            *)
(* -------------------------------------------------------------------- *)
clone Gamma1T.Gamma1T as G1 with theory B <- B, theory PR <- PR
proof *.
realize gamma1_encode_polynomial by exact gamma1_encode_polynomial.
realize gamma1_decode_to_polynomial by exact gamma1_decode_to_polynomial.
realize gamma1_encode_polynomial_ll by exact gamma1_encode_polynomial_ll.
realize gamma1_decode_to_polynomial_ll by exact gamma1_decode_to_polynomial_ll.

end Gamma1Bits20T.
