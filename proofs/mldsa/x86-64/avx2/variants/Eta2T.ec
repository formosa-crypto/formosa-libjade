require import AllCore List IntDiv RealExp.
from Jasmin require import JModel_x86.
require import CircuitBindings Bindings Keccak_bindings JWordExtra.
from Spec require import GFq Rq Parameters MLDSA_W32_Rep.
require import Array16 Array96 Array256 WArray16 WArray96 WArray1024.
require import XArray16 XArray96 XArray256 XWord3.
require import ArrayExtra JWord_extra EclibExtra JWordList Polyslices.
require BaseT ErrorPolynomialT.

(* the polynomials as 256 lanes of 3 bits *)
clone BSWA as BSWA_256u3 with
      op asize <- 256,
      op bsize <- 3,
  theory A     <- Array256,
  theory BSA   <- BSA256,
  theory W     <- W3 { rename "_XX" as "_3" },
  theory WE    <- WE3,
  theory BSW   <- BSW3.

(* a 128-bit write into the encoding *)
op wr128 (t : W8.t Array96.t) (o : int) (s : W128.t) : W8.t Array96.t =
  Array96.init (WArray96.get8 (WArray96.set128_direct (WArray96.init8 (fun i => t.[i])) o s)).

lemma set8_96E (t : W8.t Array96.t) (k : int) (x : W8.t) :
  Array96.init (WArray96.get8 (WArray96.init8 (fun i => t.[i])).[k <- x]) = t.[k <- x].
proof.
rewrite Array96.tP => i hi; rewrite Array96.initiE //= /WArray96.get8.
by rewrite WArray96.get_set_if Array96.get_set_if /init8 WArray96.initiE.
qed.

(* The encoding of a polynomial with coefficients in [-Eta, Eta], for the
   sets where Eta = 2 (ML-DSA-44 and ML-DSA-87): 3 bits per coefficient,
   96 bytes per polynomial. *)
abstract theory Eta2T.

clone import BaseT.BaseT as B with
  op S.Eta = 2,
  theory R.Array_eta_enc <- Array96,
  theory R.WArray_eta_enc <- WArray96.
import S R.
import BitEncoding BitChunking.
import Round ZModQ Zq.

lemma Eta_val : Eta = 2 by done.

lemma eta_encE : eta_enc = 96 by rewrite /eta_enc.

lemma truncateu_32_3E (w : W32.t) :
  BS_W32_W3_U.truncateu3 w = W3.bits2w (take 3 (W32.w2bits w)).
proof.
rewrite /truncateu3 W3.of_intE W32.to_uintE BS2Int.bs2int_mod //; congr.
have {1}-> : 3 = size (take 3 (w2bits w)) by rewrite size_take.
by rewrite BS2Int.bs2intK.
qed.

lemma ilog_Eta : ilog 2 (Eta + Eta) = 2 by rewrite Eta_val /=.

(* each 3-bit field of the encoding is at most 2 Eta *)
op valid_eta_bytes (a : W8.t Array96.t) =
  forall i, 0 <= i < 256 =>
    to_uint (W3.init (fun j => a.[(3 * i + j) %/ 8].[(3 * i + j) %% 8])) <= 2 * Eta.

op error_polynomial_encode_lane (c : W32.t) : W3.t =
  BS_W32_W3_U.truncateu3 (W32.of_int 2 - c).

op error_polynomial_decode_lane (c : W3.t) : W32.t =
  W32.of_int 2 - BS_W32_W3_U.zeroextu32 c.

lemma BitPack_liftE (p : wpoly) :
  wpoly_srng Eta Eta p =>
    BitPack (lifts_wpoly p) Eta Eta
  = to_list (let mapped = BSWA_256u3.init (fun i => error_polynomial_encode_lane p.[i]) in
             BSWA_96u8.init (fun i => W8.init (fun j => mapped.[(i*8+j) %/ 3].[(i*8+j) %% 3]))).
proof.
have HEta := Eta_val.
move=> h @/BitPack; (pose l := ilog 2 _) => /=.
have Hlog := ilog_Eta.
have ? : size (flatten (map (fun (x : W32.t) =>
    IntegerToBits (Eta - crepr (incoeff (to_sint x))) (l + 1)) (to_list p))) = 256 * 3.
+ rewrite (size_flatten_ctt (l + 1)).
  + by move=> x; rewrite mapP => Hx; elim Hx => xw /= [? ->];
      rewrite /IntegerToBits BS2Int.size_int2bs /#.
  by rewrite size_map /= size_to_list /l /= Hlog.
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
    rewrite /IntegerToBits BS2Int.size_int2bs /#.
rewrite nth_iota 1:/# (nth_map witness) /=; 1: by rewrite size_to_list /= /#.
rewrite /error_polynomial_encode_lane.
pose v := p.[(i * 8 + j) %/ 3].
have -> : p.[(8 * i + j) %/ (l + 1)] = v by smt().
move: h => @/wpoly_srng /array256_allP /(_ v _) //= /=.
+ by rewrite /to_list /mkseq mapP; exists ((i * 8 + j) %/ 3); smt(mem_iota).
move=> h.
rewrite incoeffK_centered 1,2:/# truncateu_32_3E get_bits2w 1:/#.
rewrite nth_take 1,2:/# w2bits_int2bsE.
have -> := BS2Int.int2bs_cat 3 32 (to_uint (W32.of_int 2 - v)) _; 1: smt().
rewrite /IntegerToBits nth_cat ifT; 1: by rewrite BS2Int.size_int2bs /#.
congr; 2: smt().
congr; 1: smt().
have := W32.of_uintK (Eta - to_sint v).
rewrite modz_small; 1: by smt().
move=> <-; rewrite -W32.of_intD'; congr.
rewrite W32.of_intN; congr; 1: smt().
rewrite /to_sint /smod /=.
case (2147483648 <= to_uint v) => ?; last by smt(W32.to_uintK pow2_32).
move: h; rewrite /to_sint /smod ifT //= => ?.
by congr; rewrite to_uint_eq /= of_uintK /=; smt(W32.to_uint_cmp pow2_32).
qed.

lemma error_polynomial_encode_eta2_circuit _a :
   hoare [ M.error_polynomial__encode_eta2 :
       polynomial = _a /\ wpoly_srng 2 2 _a
     ==>
       res =
         (let mapped = BSWA_256u3.init (fun i => error_polynomial_encode_lane _a.[i]) in
          BSWA_96u8.init (fun i => W8.init (fun j => mapped.[(i*8+j) %/ 3].[(i*8+j) %% 3])))
    /\ List.all (fun i => W3.init (fun j => res.[(3*i+j) %/ 8].[(3*i+j) %% 8]) \ule W3.of_int 4)
         (iotared 0 256)
   ].
proof.
proc.
proc change 2 : { temp <- W64.of_int 2; }; 1: by auto.
proc change 3 : { eta_0 <- zeroextu256 temp; }.
+ auto => &1 &2 ->; rewrite /VMOV_64 zeroextu256E zeroextu256E.
  rewrite wordP => i ib.
  rewrite pack2E pack2E pack4E initiE 1:/# /= initiE 1:/# /= initiE 1:/# /= initiE 1:/# /=.
  case (i %/ 64 = 0) => ?; 1: by rewrite ifT 1:/# initiE 1:/# /= get_of_list /#.
  case (i %/ 128 = 0) => ?; 2: by auto.
  rewrite initiE 1:/# /= get_of_list 1:/#.
  by have -> /= : (i %% 128 %/ 64) = 1 by smt().
(* the writes are slices of the encoding *)
proc change ^while.^encoded<- : {
  encoded <-
    if 0 <= output_offset * 8 <= 640
    then BSWAS_96u8_128.sliceset encoded (output_offset * 8) (truncateu128 c0)
    else wr128 encoded (output_offset) (truncateu128 c0); }.
+ auto => /> &2; case (0 <= output_offset{2} * 8 <= 640) => h; last by auto.
  by rewrite (BSWAS_96u8_128_slicesetE _ _ _ h).
proc change ^while.^encoded<-{2} : {
  encoded <-
    if 0 <= (output_offset + 12) * 8 <= 640
    then BSWAS_96u8_128.sliceset encoded ((output_offset + 12) * 8) (VEXTRACTI128 c0 W8.one)
    else wr128 encoded (output_offset + 12) (VEXTRACTI128 c0 W8.one); }.
+ auto => /> &2; case (0 <= (output_offset{2} + 12) * 8 <= 640) => h; last by auto.
  by rewrite (BSWAS_96u8_128_slicesetE _ _ _ h).
proc change ^encoded<- : {
  encoded <-
    if 0 <= output_offset * 8 <= 640
    then BSWAS_96u8_128.sliceset encoded (output_offset * 8) (truncateu128 c0)
    else wr128 encoded (output_offset) (truncateu128 c0); }.
+ auto => /> &2; case (0 <= output_offset{2} * 8 <= 640) => h; last by auto.
  by rewrite (BSWAS_96u8_128_slicesetE _ _ _ h).
proc change ^final_encoded_bytes<-{2} : {
  final_encoded_bytes <- BSWAS_16u8_128.sliceset final_encoded_bytes 0 (VEXTRACTI128 c0 W8.one); }.
+ by auto => /> &2; rewrite (BSWAS_16u8_128_slicesetE _ 0).
proc change ^while{2}.1 : {
  encoded <- encoded.[output_offset <- final_encoded_bytes.[input_offset]]; }.
+ by auto => /> &2; rewrite -set8_96E.
(* the offsets are constants once the loops are unrolled *)
unroll for ^while.
unroll for ^while.
cfold 5; cfold ^output_offset<-; wp -3; proc rewrite /=.
proc rewrite get256_polyE; proc rewrite /=.
conseq (: List.all (fun i => W32.of_int (-2) \sle _a.[i] /\ _a.[i] \sle W32.of_int 2)
            (iotared 0 256) /\ _a = polynomial ==> _); last by circuit.
move => &hr [<- +]; rewrite iotaredE /wpoly_srng allP /= => Hrng.
rewrite /(\sle) allP => x; rewrite mem_iota /= => Hx.
by rewrite !of_sintK /= /smod /= /#.
qed.

lemma error_polynomial_encode_eta2 _a :
   hoare [ M.error_polynomial__encode_eta2 :
       polynomial = _a /\ wpoly_srng 2 2 _a
     ==>
       to_list res = BitPack (lifts_wpoly _a) Eta Eta /\ valid_eta_bytes res ].
proof.
conseq (error_polynomial_encode_eta2_circuit _a) => &hr [_ Hrng] r [-> +].
rewrite iotaredE allP /= => H; split; 1: by rewrite BitPack_liftE.
move=> k kb; have := H k _; 1: by rewrite mem_iota /#.
by rewrite /(\ule) /= Eta_val.
qed.

lemma BitUnpack_liftE (bytes : W8.t Array96.t) :
    BitUnpack (to_list bytes) Eta Eta
  = map (fun (w : W32.t) => incoeff (to_sint w))
      (BSWA_256u32.init (fun (i : int) => error_polynomial_decode_lane
         (W3.init (fun (j : int) => bytes.[(3 * i + j) %/ 8].[(3 * i + j) %% 8])))).
proof.
have HEta := Eta_val.
have Hsz : size (BytesToBits (to_list bytes)) = 768.
+ rewrite /BytesToBits (EclibExtra.size_flatten' 8); 1: by smt(mapP W8.size_w2bits).
  by rewrite size_map size_to_list.
move=> @/BitUnpack /=; rewrite tP => i ib.
rewrite initiE 1:// mapiE //= initiE 1:/# /=.
rewrite (nth_map []) /=; 1: by rewrite size_chunk ilog_Eta //= Hsz.
congr; rewrite /error_polynomial_decode_lane ilog_Eta /= /zeroextu32.
rewrite nth_chunk // 1:/# 1:Hsz 1:/#.
have := BS2Int.bs2int_le2Xs (take 3 (drop (3 * i) (BytesToBits (to_list bytes)))).
rewrite size_take // size_drop 1:/# Hsz.
have -> /= : (if 3 < max 0 (768 - 3 * i) then 3 else max 0 (768 - 3 * i)) = 3 by smt().
rewrite /BitsToInteger.
pose p := BS2Int.bs2int (take 3 (drop (3 * i) (BytesToBits (to_list bytes)))).
move=> ?; have ? : 0 <= p by smt(BS2Int.bs2int_ge0).
have <- : p = to_uint (W3.init (fun (j : int) => bytes.[(3 * i + j) %/ 8].[(3 * i + j) %% 8])).
+ rewrite /to_uint /p; congr.
  apply (eq_from_nth false).
  + by rewrite size_take // size_drop 1:/# size_w2bits Hsz /#.
  move=> k kb.
  have ? : size (take 3 (drop (3 * i) (BytesToBits (to_list bytes)))) = 3.
  + by rewrite size_take // size_drop 1:/# Hsz /#.
  rewrite nth_take 1,2:/# nth_drop 1,2:/# /BytesToBits.
  rewrite (nth_flatten false 8).
  + by rewrite allP => j /=; rewrite mapP => Hx; elim Hx; smt(W8.size_w2bits).
  rewrite (nth_map witness) /=; 1: by rewrite size_to_list /#.
  by rewrite initiE 1:/# /=.
by have /= := W32.to_sintK_small (2 - p); smt().
qed.

lemma zext8_32E (x : W8.t) : W32.of_int (W8.to_uint x) = zeroextu32 x by done.

lemma error_polynomial_decode_eta2_circuit _a :
   hoare [ M.error_polynomial__decode_eta2 :
       encoded = _a /\ valid_eta_bytes _a
     ==>
       res = BSWA_256u32.init (fun i => error_polynomial_decode_lane
               (W3.init (fun j => _a.[(3 * i + j) %/ 8].[(3 * i + j) %% 8])))
    /\ List.all (fun i => W32.of_int (-2) \sle res.[i] /\ res.[i] \sle W32.of_int 2)
         (iotared 0 256)
   ].
proof.
proc.
proc rewrite eta_encE; swap ^input_offset<- 1; unroll for ^while.
proc change 1 : { eTA_BITS_MASK <- 7; }; 1: by auto.
cfold 1; cfold 1; wp -3; proc rewrite /=; proc rewrite zext8_32E.
conseq (: encoded = _a /\
  List.all (fun i => W3.init (fun j => encoded.[(3 * i + j) %/ 8].[(3 * i + j) %% 8])
                       \ule W3.of_int 4) (iotared 0 256) ==> _); last by circuit.
move=> &hr [-> H]; rewrite iotaredE allP => k; rewrite mem_iota /= => kb.
by have := H k _; [smt() | rewrite /(\ule) Eta_val].
qed.

lemma sle_rngE (x : W32.t) :
  W32.of_int (-2) \sle x /\ x \sle W32.of_int 2 => -2 <= to_sint x <= 2.
proof. by rewrite /(\sle) /= !W32.to_sintE /smod /=; smt(W32.to_uint_cmp). qed.

lemma error_polynomial_decode_eta2 _a :
   hoare [ M.error_polynomial__decode_eta2 :
       encoded = _a /\ valid_eta_bytes _a
     ==>
       lifts_wpoly res = BitUnpack (to_list _a) Eta Eta /\ wpoly_srng Eta Eta res ].
proof.
conseq (error_polynomial_decode_eta2_circuit _a) => &hr _ r [-> +].
rewrite iotaredE allP /= => H; split.
- rewrite /lifts_wpoly /=; apply (inj_eq Array256.to_list Array256.to_list_inj).
  by rewrite BitUnpack_liftE !array256_mapE.
rewrite /wpoly_srng allP Eta_val => w Hw /=.
have /= := H w _; 1: by smt(mem_iota).
by apply sle_rngE.
qed.

lemma error_polynomial_encode _a :
   hoare [ M.error_polynomial__encode :
       polynomial = _a /\ wpoly_srng 2 2 _a
     ==>
       to_list res = BitPack (lifts_wpoly _a) Eta Eta /\ valid_eta_bytes res ].
proof. by proc; rcondt 1; [auto | ecall (error_polynomial_encode_eta2 _a); auto]. qed.

lemma error_polynomial_decode _a :
   hoare [ M.error_polynomial__decode :
       encoded = _a /\ valid_eta_bytes _a
     ==>
       lifts_wpoly res = BitUnpack (to_list _a) Eta Eta /\ wpoly_srng Eta Eta res ].
proof. by proc; rcondt 1; [auto | ecall (error_polynomial_decode_eta2 _a); auto]. qed.

lemma error_polynomial_encode_ll : islossless M.error_polynomial__encode.
proof.
proc; rcondt 1; 1: by auto.
inline *; wp.
by unroll for ^while; unroll for ^while; auto.
qed.

lemma error_polynomial_decode_ll : islossless M.error_polynomial__decode.
proof.
proc; rcondt 1; 1: by auto.
inline *; wp.
by proc rewrite eta_encE; swap ^input_offset<- 1; unroll for ^while; auto.
qed.

(* -------------------------------------------------------------------- *)
(* The hypotheses of ErrorPolynomialT, for these sets                   *)
(* -------------------------------------------------------------------- *)

(* the generic validity of an encoding, on 3 bits per coefficient *)
lemma valid_eta2E (a : W8.t Array96.t) :
  (forall i, 0 <= i < 256 =>
     BS2Int.bs2int (mkseq (fun j => a.[(3 * i + j) %/ 8].[(3 * i + j) %% 8]) 3) <= 2 * 2)
  <=> valid_eta_bytes a.
proof.
rewrite /valid_eta_bytes /=.
have E : forall (f : int -> bool), to_uint (W3.init f) = BS2Int.bs2int (mkseq f 3).
+ move=> f; rewrite W3.to_uintE; congr.
  apply (eq_from_nth false); rewrite W3.size_w2bits.
  + by rewrite size_mkseq.
  by move=> j hj; rewrite W3.get_w2bits W3.initiE // nth_mkseq.
by split => H i hi; [rewrite E | rewrite -E]; apply H.
qed.

clone ErrorPolynomialT.ErrorPolynomialT as EP with theory B <- B
proof *.
realize error_polynomial_encode.
move=> _a; conseq (error_polynomial_encode _a) => //.
by move=> &hr _ r [-> /valid_eta2E H].
qed.
realize error_polynomial_decode.
move=> _a; conseq (error_polynomial_decode _a) => //.
by move=> &hr [-> H]; rewrite -valid_eta2E.
qed.
realize error_polynomial_encode_ll by exact error_polynomial_encode_ll.
realize error_polynomial_decode_ll by exact error_polynomial_decode_ll.

end Eta2T.
