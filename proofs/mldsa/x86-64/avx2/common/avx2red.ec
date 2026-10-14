(**
  AVX2 reduction machinery shared by the forward and inverse NTT
  correctness proofs:

    - simplification lemmas giving the lane-wise semantics of the AVX2
      instructions used by the implementation (registered as `hint
      simplify`, so that `/=` symbolically executes vector code);
    - the packed-lane helpers (pack8/unpack32) and the aligned
      get256/set256 bridge between the coefficient array and the
      vector view;
    - the correctness of the vectorized Montgomery multiply-and-reduce
      (`mmrP`).
*)

require import AllCore CoreUtils List List_extra Ring IntDiv BitEncoding.
require import StdRing StdOrder.

import BitChunking BS2Int.

(* -------------------------------------------------------------------- *)
from Jasmin require import JWord JArray.

require import JArrayExtra.
require import CircuitBindings.

(* -------------------------------------------------------------------- *)
from Jasmin require import JModel_x86.
require import MldsaConstants.
require Parameters MldsaT.

(* -------------------------------------------------------------------- *)
require import WArray1024.
require import Array2 WArray2.
require import Array4 Array8 Array16 Array256.
require import XArray256.

(* -------------------------------------------------------------------- *)
type wpoly = W32.t Array256.t.

(* -------------------------------------------------------------------- *)
require import Nttzetas Nttspec Nttlogspec.
require import Listred.

(* ==================================================================== *)
lemma truncateu32_64E (w : W64.t) : truncateu32 w = w \bits32 0.
proof.
apply: W32.ext_eq=> i rgi; rewrite bits32iE //=.
rewrite /truncateu32 of_intwE rgi /= /W32.int_bit.
rewrite modz_pow2_div ~-1://# modz_dvd.
- by rewrite -{1}[2]expr1 dvdz_exp2l /#.
- by rewrite -b2i_get /#.
qed.

hint simplify truncateu32_64E.

(* -------------------------------------------------------------------- *)
lemma truncateu32_256E (w : W256.t) : truncateu32 w = w \bits32 0.
proof.
apply: W32.ext_eq=> i rgi; rewrite bits32iE //=.
rewrite /truncateu32 of_intwE rgi /= /W32.int_bit.
rewrite modz_pow2_div ~-1://# modz_dvd.
- by rewrite -{1}[2]expr1 dvdz_exp2l /#.
- by rewrite -b2i_get /#.
qed.

hint simplify truncateu32_256E.

(* -------------------------------------------------------------------- *)
lemma truncateu128_256E (w : W256.t) : truncateu128 w = w \bits128 0.
proof.
apply: W128.ext_eq=> i rgi; rewrite bits128iE //=.
rewrite /truncateu32 of_intwE rgi /= /W128.int_bit.
rewrite modz_pow2_div ~-1://# modz_dvd.
- by rewrite -{1}[2]expr1 dvdz_exp2l /#.
- by rewrite -b2i_get /#.
qed.

hint simplify truncateu128_256E.

(* ==================================================================== *)
lemma VMOV_32 (w : W32.t) : VMOV_32 w = pack4 [w; zero; zero; zero].
proof. done. qed.

hint simplify VMOV_32.

(* -------------------------------------------------------------------- *)
lemma zeroextu256E (w : W128.t) : zeroextu256 w = pack2 [w; zero].
proof.
rewrite zeroextu256E &(wordP) => i rgi /=.
by rewrite !pack2bE //= of_listE !initiE.
qed.

hint simplify zeroextu256E.

(* -------------------------------------------------------------------- *)
lemma VPBROADCAST_8u32E (w : W32.t) :
  VPBROADCAST_8u32 w = pack8 [w; w; w; w; w; w; w; w].
proof. by rewrite /VPBROADCAST_8u32 -iotaredE. qed.

hint simplify VPBROADCAST_8u32E.

(* -------------------------------------------------------------------- *)
lemma VPADD_8u32E (u w : W256.t) :
    VPADD_8u32 u w
  = W8u32.pack8 [
      (u \bits32 0) + (w \bits32 0); (u \bits32 1) + (w \bits32 1);
      (u \bits32 2) + (w \bits32 2); (u \bits32 3) + (w \bits32 3);
      (u \bits32 4) + (w \bits32 4); (u \bits32 5) + (w \bits32 5);
      (u \bits32 6) + (w \bits32 6); (u \bits32 7) + (w \bits32 7)
    ].
proof. by cbv delta. qed.

hint simplify VPADD_8u32E.

(* -------------------------------------------------------------------- *)
lemma VPSUB_4u64E (u w : W256.t) :
    VPSUB_4u64 u w
  = W4u64.pack4 [
      (u \bits64 0) - (w \bits64 0); (u \bits64 1) - (w \bits64 1);
      (u \bits64 2) - (w \bits64 2); (u \bits64 3) - (w \bits64 3)
    ].
proof. by cbv delta. qed.

hint simplify VPSUB_4u64E.

(* -------------------------------------------------------------------- *)
lemma VPSUB_8u32E (u w : W256.t) :
    VPSUB_8u32 u w
  = W8u32.pack8 [
      (u \bits32 0) - (w \bits32 0); (u \bits32 1) - (w \bits32 1);
      (u \bits32 2) - (w \bits32 2); (u \bits32 3) - (w \bits32 3);
      (u \bits32 4) - (w \bits32 4); (u \bits32 5) - (w \bits32 5);
      (u \bits32 6) - (w \bits32 6); (u \bits32 7) - (w \bits32 7)
    ].
proof. by cbv delta. qed.

hint simplify VPSUB_8u32E.

(* -------------------------------------------------------------------- *)
lemma VPMUL_256 (u v : W256.t) :
    VPMUL_256 u v
  = W4u64.pack4 [
      (u \bits32 0) \sx (v \bits32 0); (u \bits32 2) \sx (v \bits32 2);
      (u \bits32 4) \sx (v \bits32 4); (u \bits32 6) \sx (v \bits32 6)
    ].
proof. by cbv delta. qed.

hint simplify VPMUL_256.

(* -------------------------------------------------------------------- *)
lemma VMOVSHDUP_256E (w : W256.t) :
    VMOVSHDUP_256 w
  = W8u32.pack8 [
      w \bits32 1; w \bits32 1; w \bits32 3; w \bits32 3;
      w \bits32 5; w \bits32 5; w \bits32 7; w \bits32 7
    ].
proof. by cbv delta. qed.

hint simplify VMOVSHDUP_256E.

(* -------------------------------------------------------------------- *)
lemma VPSHUFD_256_216E (w : W256.t) :
    VPSHUFD_256 w (W8.of_int 216)
  = W8u32.pack8 [
      w \bits32 0; w \bits32 2; w \bits32 1; w \bits32 3;
      w \bits32 4; w \bits32 6; w \bits32 5; w \bits32 7
    ].
proof. by cbv delta. qed.

hint simplify VPSHUFD_256_216E.

(* -------------------------------------------------------------------- *)
lemma VPSHUFD_128_228E (w : W128.t) : VPSHUFD_128 w (W8.of_int 228) = w.
proof.
rewrite /VPSHUFD_128 -{2}(W4u32.unpack32K w) iotaredE -/(range 0 4).
rewrite -/(mkseq _ 4) -(eq_in_mkseq (fun i => w \bits32 i)) /=.
- move=> i rgi @/VPSHUFD_128_B /=; congr.
  by move/mem_range: rgi; rewrite /range -iotaredE /= => [#|] ->.
rewrite -{2}[w](unpack32K); congr; apply/W4u32.Pack.ext_eq.
by move=> i rgi; rewrite !(get_unpack32, get_of_list, nth_mkseq).
qed.

hint simplify VPSHUFD_128_228E.

(* -------------------------------------------------------------------- *)
lemma VPSHUFD_256_228E (w : W256.t) : VPSHUFD_256 w (W8.of_int 228) = w.
proof.
rewrite /VPSHUFD_256 mapE map_to_list.
rewrite (List.eq_map _ idfun) //=.
rewrite map_id.
rewrite -{2}[w](unpack128K); congr; apply/W2u128.Pack.ext_eq.
move=> i rgi; rewrite !(get_unpack128, nth_mkseq) //.
by rewrite to_listK /unpack128 initE /= ifT.
qed.

hint simplify VPSHUFD_256_228E.

(* -------------------------------------------------------------------- *)
lemma VPSHUFD_128_245E (w : W128.t) :
    VPSHUFD_128 w (W8.of_int 245)
  = W4u32.pack4 [w \bits32 1; w \bits32 1; w \bits32 3; w \bits32 3].
proof. by cbv delta. qed.

hint simplify VPSHUFD_128_245E.

(* -------------------------------------------------------------------- *)
lemma VPSHUFD_256_245E (w : W256.t) :
    VPSHUFD_256 w (W8.of_int 245)
  = W8u32.pack8 [
      w \bits32 1; w \bits32 1; w \bits32 3; w \bits32 3;
      w \bits32 5; w \bits32 5; w \bits32 7; w \bits32 7
    ].
proof. by cbv delta. qed.

hint simplify VPSHUFD_256_245E.

(* -------------------------------------------------------------------- *)
lemma VPUNPCKL_4u64E (u v : W256.t) :
    VPUNPCKL_4u64 u v
  = W4u64.pack4 [u \bits64 0; v \bits64 0; u \bits64 2; v \bits64 2].
proof. by cbv delta. qed.

hint simplify VPUNPCKL_4u64E.

(* -------------------------------------------------------------------- *)
lemma VPUNPCKH_4u64E (u v : W256.t) :
    VPUNPCKH_4u64 u v
  = W4u64.pack4 [u \bits64 1; v \bits64 1; u \bits64 3; v \bits64 3].
proof. by cbv delta. qed.

hint simplify VPUNPCKH_4u64E.

(* -------------------------------------------------------------------- *)
lemma VPBLENDD_256_170E (u v : W256.t) :
    VPBLENDD_256 u v (W8.of_int 170)
  = pack8 [
      u \bits32 0; v \bits32 1; u \bits32 2; v \bits32 3;
      u \bits32 4; v \bits32 5; u \bits32 6; v \bits32 7
    ].
proof. by cbv delta; rewrite !of_intwE; cbv delta. qed.

hint simplify VPBLENDD_256_170E.

(* -------------------------------------------------------------------- *)
lemma VPERM2I128_19E (u v : W256.t) :
    VPERM2I128 u v (W8.of_int 19)
  = pack2 [v \bits128 1; u \bits128 1].
proof. by cbv delta; rewrite !of_intwE /=; cbv delta. qed.

hint simplify VPERM2I128_19E.

(* -------------------------------------------------------------------- *)
lemma VINSERTI128_L (u : W256.t) (w : W128.t) :
  VINSERTI128 u w W8.zero = pack2 [w; u \bits128 1].
proof. done. qed.

hint simplify VINSERTI128_L.

(* -------------------------------------------------------------------- *)
lemma VINSERTI128_R (u : W256.t) (w : W128.t) :
  VINSERTI128 u w W8.one = pack2 [u \bits128 0; w].
proof. done. qed.

hint simplify VINSERTI128_R.

(* -------------------------------------------------------------------- *)
hint simplify W8u32.Pack.of_listK.
hint simplify W8u32.Pack.to_listK.

(* -------------------------------------------------------------------- *)
lemma to_list_unpack32E (w : W256.t) :
  to_list (unpack32 w) = [
    w \bits32 0; w \bits32 1; w \bits32 2; w \bits32 3;
    w \bits32 4; w \bits32 5; w \bits32 6; w \bits32 7
  ].
proof. by rewrite /to_list /mkseq -iotaredE. qed.

hint simplify to_list_unpack32E.

(* -------------------------------------------------------------------- *)

(* ==================================================================== *)
lemma pack8K (w : W256.t) : W8u32.pack8 (mkseq (W8u32.(\bits32) w) 8) = w.
proof. 
apply/W8u32.wordP=> i rgi; rewrite pack8bE //.
by rewrite of_listE initiE //= nth_mkseq .
qed.

hint simplify pack8K.

(* -------------------------------------------------------------------- *)
lemma pack8_bits32E (w : W32.t list) (i : int) : 0 <= i < 8 =>
  (W8u32.pack8 w) \bits32 i = nth W32.zero w i.
proof.
move=> rgi; apply/W32.ext_eq=> j rgj; rewrite pack8E bits32E /= initE rgj /=.
rewrite initE ifT 1:/# /= modzMDl divzMDl // !(pdiv_small, pmod_small) //=.
by rewrite get_of_list.
qed.

hint simplify pack8_bits32E.

(* -------------------------------------------------------------------- *)
lemma pack8_eq (F G : int -> W32.t) :
     (forall i, 0 <= i < 8 => F i = G i)
  =>   pack8 [F 0; F 1; F 2; F 3; F 4; F 5; F 6; F 7]
     = pack8 [G 0; G 1; G 2; G 3; G 4; G 5; G 6; G 7].
proof. by move=> eq; rewrite !eq. qed.

(* ==================================================================== *)
abbrev MODULUS = 8380417.

(* -------------------------------------------------------------------- *)
abbrev MODULUS_8u32 =
  225935595421087293402315996791205668696012104344015382954355885915737415681.

(* -------------------------------------------------------------------- *)
op MODULUS_VECTOR : W256.t =
 W8u32.pack8 (nseq 8 (W32.of_int MODULUS)).

(* -------------------------------------------------------------------- *)
lemma MODULUS_VECTOR_E : W256.of_int MODULUS_8u32 = MODULUS_VECTOR.
proof.
have eq: forall i, 0 <= i < 8 =>
  W256.of_int MODULUS_8u32 \bits32 i = W32.of_int MODULUS.
- by move=> i /mem_range @/range; rewrite -iotaredE /= => [#|] -> /=.
apply/W8u32.wordP=> i rgi; rewrite eq 1://.
by rewrite /MODULUS_VECTOR pack8_bits32E // nth_nseq.
qed.

(* -------------------------------------------------------------------- *)
abbrev INVERSE_OF_MODULUS_MOD_MONTGOMERY_R = 58728449.

(* -------------------------------------------------------------------- *)
abbrev INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_8u32 = 
  1583315853253120773718772168429862829322770379248453373268938642773050925057.

(* -------------------------------------------------------------------- *)
op INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR : W256.t =
 W8u32.pack8 (nseq 8 (W32.of_int INVERSE_OF_MODULUS_MOD_MONTGOMERY_R)).

(* -------------------------------------------------------------------- *)
lemma INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR_E :
    W256.of_int INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_8u32
  = INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR.
proof.
have eq: forall i, 0 <= i < 8 =>
    W256.of_int INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_8u32 \bits32 i
  = W32.of_int INVERSE_OF_MODULUS_MOD_MONTGOMERY_R.
- by move=> i /mem_range @/range; rewrite -iotaredE /= => [#|] -> /=.
apply/W8u32.wordP=> i rgi; rewrite eq 1://.
rewrite /INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR.
by rewrite pack8_bits32E // nth_nseq.
qed.

(* ==================================================================== *)
section.
(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
lemma wpoly_get256_aligned (p : wpoly) (s : int) :
     0 <= s < 256 - 7
  =>   WArray1024.get256_direct (WArray1024.init32 ("_.[_]" p)) (4 * s)
     = W8u32.pack8 (mkseq (fun i => p.[s + i]) 8).
proof.
hint +listred.
move=> *; apply/W8u32.wordP=> i rgi; rewrite get_pack8 1://.
rewrite nth_mkseq //= get256E &(W32.ext_eq) => j rgj.
rewrite bits32_W32u8 ifT // pack4wE //=.
rewrite of_listE 4!initE /= !ifT ~-1:/#.
rewrite 4!initE /= !ifT ~-1:/# !addrA -mulrDr.
rewrite [4*_]mulrC modzMl !modzMDl ![_%%4]pmod_small //.
rewrite !(mulzK, divzMDl) // ![_ %/ 4]pdiv_small //.
rewrite -(W4u8.Pack.init_ext ((\bits8) p.[s + i])) 1:/#.
by rewrite initE ifT 1:/# -get_bits8.
qed.

(* -------------------------------------------------------------------- *)
lemma wpoly_get256_alignedE (p : wpoly) (s : int) :
     0 <= s %/ 4 < 256 - 7
  => s %% 4 = 0
  =>   WArray1024.get256_direct (WArray1024.init32 ("_.[_]" p)) s
     = W8u32.pack8 (mkseq (fun i => p.[s %/ 4 + i]) 8).
proof. by move=> ?; have := wpoly_get256_aligned p (s %/ 4); smt(). qed.

(* -------------------------------------------------------------------- *)
lemma wpoly_set256_aligned (s : int) (p : wpoly) (w : W256.t) :
     0 <= s < 256 - 7
  =>   Array256.init
          (fun (i : int) =>
            get32
              (WArray1024.set256_direct (WArray1024.init32 ("_.[_]" p)) (4 * s) w) i)
     = Array256.fill (fun i =>  w \bits32 (i - s)) s 8 p.
proof.
hint +listred.
move=> ?; apply: Array256.ext_eq=> j rgj; rewrite fillE !initE rgj /=.
rewrite get32E /= &(W32.ext_eq) => k rgk; rewrite pack4wE //= initE /=.
rewrite ifT 1:/# /set256_direct WArray1024.initE /= ifT 1:/#.
have /= -> := fun_if (fun (w : W8.t) => w.[k %% 8]).
have /= -> := fun_if (fun (w : W32.t) => w.[k]).
rewrite &(if_congr) 1:/#; last first.
- rewrite initE ifT 1:/# /= [4*_]mulrC divzMDl // -divz_mul //=.
  by rewrite pdiv_small 1:// /= modzMDl modz_small 1:/# -get_bits8.
- by rewrite addrAC -mulrBr -W256_bits32_bits8 1:/# -get_bits8.
qed.

(* -------------------------------------------------------------------- *)
lemma wpoly_set256_alignedE (s : int) (p : wpoly) (w : W256.t) :
     0 <= s %/ 4 < 256 - 7
  => s %% 4 = 0
  =>   Array256.init                                                           
          (fun (i : int) =>                                                     
            get32
              (WArray1024.set256_direct (WArray1024.init32 ("_.[_]" p)) s w) i)
     = Array256.fill (fun i =>  w \bits32 (i - s %/ 4)) (s %/ 4) 8 p.
proof. by move=> ?; have := wpoly_set256_aligned (s %/ 4) p w; smt(). qed.

end section.

(* -------------------------------------------------------------------- *)
hint simplify W64.of_uintK.

(* -------------------------------------------------------------------- *)
lemma VPERM2I128_32E (u v : W256.t) :
    VPERM2I128 u v (W8.of_int 32)
  = pack2 [u \bits128 0; v \bits128 0].
proof. by cbv delta; rewrite !of_intwE /=; cbv delta. qed.

hint simplify VPERM2I128_32E.

(* -------------------------------------------------------------------- *)
lemma VPERM2I128_49E (u v : W256.t) :
    VPERM2I128 u v (W8.of_int 49)
  = pack2 [u \bits128 1; v \bits128 1].
proof. by cbv delta; rewrite !of_intwE /=; cbv delta. qed.

hint simplify VPERM2I128_49E.

(* -------------------------------------------------------------------- *)

(* -------------------------------------------------------------------- *)
lemma to_list_unpack32_128E (x : W128.t) :
  W4u32.Pack.to_list (W4u32.unpack32 x)
  = [x \bits32 0; x \bits32 1; x \bits32 2; x \bits32 3].
proof.
by rewrite W4u32.unpack32E W4u32.Pack.to_listE /mkseq -iotaredE /= ?W4u32.Pack.initiE.
qed.

(* -------------------------------------------------------------------- *)
(* Symbolic execution of VPSHUFB_128 by simplification                  *)
lemma VPSHUFB_128_B_E (w : W128.t) (m : W8.t) :
  VPSHUFB_128_B w m
  = if 128 <= to_uint m then W8.zero else w \bits8 (to_uint m %% 16).
proof. by rewrite /VPSHUFB_128_B /=. qed.

hint simplify VPSHUFB_128_B_E.

lemma VPSHUFB_128_pack16E (w : W128.t) (b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 b11 b12 b13 b14 b15 : W8.t) :
  VPSHUFB_128 w (W16u8.pack16 [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15])
  = W16u8.pack16
    [VPSHUFB_128_B w b00;
     VPSHUFB_128_B w b01;
     VPSHUFB_128_B w b02;
     VPSHUFB_128_B w b03;
     VPSHUFB_128_B w b04;
     VPSHUFB_128_B w b05;
     VPSHUFB_128_B w b06;
     VPSHUFB_128_B w b07;
     VPSHUFB_128_B w b08;
     VPSHUFB_128_B w b09;
     VPSHUFB_128_B w b10;
     VPSHUFB_128_B w b11;
     VPSHUFB_128_B w b12;
     VPSHUFB_128_B w b13;
     VPSHUFB_128_B w b14;
     VPSHUFB_128_B w b15].
proof. by apply W128.all_eq_eq; cbv W128.all_eq VPSHUFB_128 W16u8.unpack8. qed.

hint simplify VPSHUFB_128_pack16E.

(* recombining four consecutive bytes into the dword they came from *)
lemma pack4_bits8_0 (w : W128.t) :
  W4u8.pack4 [w \bits8 0; w \bits8 1; w \bits8 2; w \bits8 3] = w \bits32 0.
proof.
apply W4u8.wordP => j hj.
rewrite W4u8.pack4bE 1:// W128_bits32_bits8 1:// /=.
by have [|[|[|]]]-> : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
qed.
lemma pack4_bits8_1 (w : W128.t) :
  W4u8.pack4 [w \bits8 4; w \bits8 5; w \bits8 6; w \bits8 7] = w \bits32 1.
proof.
apply W4u8.wordP => j hj.
rewrite W4u8.pack4bE 1:// W128_bits32_bits8 1:// /=.
by have [|[|[|]]]-> : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
qed.
lemma pack4_bits8_2 (w : W128.t) :
  W4u8.pack4 [w \bits8 8; w \bits8 9; w \bits8 10; w \bits8 11] = w \bits32 2.
proof.
apply W4u8.wordP => j hj.
rewrite W4u8.pack4bE 1:// W128_bits32_bits8 1:// /=.
by have [|[|[|]]]-> : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
qed.
lemma pack4_bits8_3 (w : W128.t) :
  W4u8.pack4 [w \bits8 12; w \bits8 13; w \bits8 14; w \bits8 15] = w \bits32 3.
proof.
apply W4u8.wordP => j hj.
rewrite W4u8.pack4bE 1:// W128_bits32_bits8 1:// /=.
by have [|[|[|]]]-> : j = 0 \/ j = 1 \/ j = 2 \/ j = 3 by smt().
qed.

lemma pack4_zeroE :
  W4u8.pack4 [W8.zero; W8.zero; W8.zero; W8.zero] = W32.zero.
proof. by apply W32.all_eq_eq; cbv W32.all_eq W4u8.unpack8. qed.

hint simplify (pack4_bits8_0, pack4_bits8_1, pack4_bits8_2, pack4_bits8_3,
               pack4_zeroE).
hint simplify to_list_unpack32_128E.


(* ==================================================================== *)
(* Generic reductions for VPERMD / VPSHUFB_256                          *)

(* -------------------------------------------------------------------- *)
hint simplify W32.of_uintK.

hint simplify W4u8.Pack.get_of_list.
hint simplify W16u8.Pack.get_of_list.
hint simplify W32u8.Pack.get_of_list.
hint simplify W8u32.Pack.get_of_list.

(* -------------------------------------------------------------------- *)
lemma permdE (w : W256.t) (i : W32.t) :
  permd w i = w \bits32 (to_uint i %% 8).
proof. by rewrite /permd. qed.

hint simplify permdE.

(* -------------------------------------------------------------------- *)
lemma VPERMD_E (i w : W256.t) :
  VPERMD i w =
    W8u32.pack8
      [permd w (i \bits32 0); permd w (i \bits32 1);
       permd w (i \bits32 2); permd w (i \bits32 3);
       permd w (i \bits32 4); permd w (i \bits32 5);
       permd w (i \bits32 6); permd w (i \bits32 7)].
proof. by rewrite /VPERMD; apply W8u32.allP => /=. qed.

hint simplify VPERMD_E.

(* -------------------------------------------------------------------- *)
lemma VPSHUFB_256_E (w m : W256.t) :
  VPSHUFB_256 w m =
    W2u128.pack2 [VPSHUFB_128 (w \bits128 0) (m \bits128 0);
                  VPSHUFB_128 (w \bits128 1) (m \bits128 1)].
proof. by rewrite /VPSHUFB_256; apply W2u128.allP => /=. qed.

hint simplify VPSHUFB_256_E.

(* ==================================================================== *)
(* Word-level helper lemmas shared by the ML-DSA samplers               *)

(* -------------------------------------------------------------------- *)
lemma truncateu16_256E (w : W256.t) :
  truncateu16 w = w \bits16 0.
proof.
apply: W16.ext_eq=> i rgi; rewrite bits16iE //=.
rewrite /truncateu16 of_intwE rgi /= /W16.int_bit.
rewrite modz_pow2_div ~-1://# modz_dvd.
- by rewrite -{1}[2]expr1 dvdz_exp2l /#.
- by rewrite -b2i_get /#.
qed.

(* -------------------------------------------------------------------- *)
lemma bits8_256_shiftE (w : W256.t) (i : int) : 0 <= i < 16 =>
  (w `<<<` 8 * i) \bits8 i = w \bits8 0.
proof.
move=> rgi; apply W8.wordP => j hj.
by rewrite !bits8iE // shlwE; smt().
qed.

(* -------------------------------------------------------------------- *)
lemma bits8_256_le_shiftE (w : W256.t) (i j : int) :
  0 <= i < 16 => 0 <= j < i =>
    (w `<<<` 8 * i) \bits8 j = W8.zero.
proof.
move=> rgi rgj; apply W8.wordP => t ht.
rewrite bits8iE // shlwE.
by smt(W256.get_out W8.zerowE).
qed.

(* -------------------------------------------------------------------- *)
lemma w256_shift_wintE (w i : int) :
  0 <= i < 256 => W256.of_int (w `<<` i) = W256.of_int w `<<<` i.
proof.
move=> rgi.
by rewrite W256.shlMP 1:/# /(`<<`) ifT 1:/#.
qed.

(* -------------------------------------------------------------------- *)
lemma w256_ofint_bits8E (w i : int) : 0 <= i < 32 =>
  (W256.of_int w) \bits8 i = W8.of_int (w %/ 2^(8*i)).
proof. by apply W32u8.of_int_bits8_div. qed.


(* -------------------------------------------------------------------- *)
(* the 16-bit domain separator, stored through WArray2, reads back as   *)
(* its two bytes                                                        *)
lemma pack2_set16_to_listE (a : W8.t Array2.t) (w : W16.t) :
  Array2.to_list (Array2.init (WArray2.get8
    (WArray2.set16 (WArray2.init8 ("_.[_]" a)) 0 w)))
  = W2u8.to_list w.
proof. by rewrite /to_list /mkseq -iotaredE /=. qed.

(* -------------------------------------------------------------------- *)
lemma pack2_to_listE (a : W8.t Array2.t) (w : W16.t) :
  Array2.to_list (Array2.init (WArray2.get8
    (WArray2.set16_direct (WArray2.init8 ("_.[_]" a)) 0 w)))
  = W2u8.to_list w.
proof. by rewrite /to_list /mkseq -iotaredE /=. qed.

(* -------------------------------------------------------------------- *)
hint exact : W64.WRingA.oner_neq0.

(* -------------------------------------------------------------------- *)
lemma of_int_b2i_eq1P (b : bool) : W64.of_int (b2i b) = W64.one => b.
proof. by case: b => //; rewrite b2i0 /= eq_sym. qed.

(* ==================================================================== *)
(* Leaf lemmas for the vectorized rejection-sampling loop body          *)
(* ==================================================================== *)
(* -------------------------------------------------------------------- *)
lemma to_uint_and15 (g : W64.t) :
  to_uint (g `&` W64.of_int 15) = to_uint g %% 16.
proof.
have := W64.to_uint_and_mod 4 g _ => //=.
qed.

lemma to_uint_shr4 (g : W64.t) :
  to_uint (g `>>` W8.of_int 4) = to_uint g %/ 16.
proof. by rewrite W64.shr_div of_uintK /=. qed.

lemma popcnt6E (g : W64.t) :
  (POPCNT_64 g).`6 = W64.of_int (count idfun (W64.w2bits g)).
proof. by rewrite /POPCNT_64 /flags_w. qed.

lemma popcnt_count (g : W64.t) (bs : bool list) :
  size bs = 4 => to_uint g = bs2int bs =>
  count idfun (W64.w2bits g) = count idfun bs.
proof.
move=> szb hg.
have e1 : bs2int (W64.w2bits g) = bs2int (bs ++ nseq 60 false).
- by rewrite -W64.to_uintE hg bs2int_cat bs2int_nseq_false szb /=.
have h1 := bs2intK (W64.w2bits g).
have h2 := bs2intK (bs ++ nseq 60 false).
move: h1 h2; rewrite W64.size_w2bits size_cat szb size_nseq /= e1 => h1 h2.
rewrite -h1 h2.
by rewrite count_cat count_nseq /idfun /=.
qed.

(* -------------------------------------------------------------------- *)
(* the shuffle table compacts the dwords selected by the 4-bit mask to  *)
(* the front, in order                                                  *)
lemma shuffle_compact (x : W128.t) (m : int) : 0 <= m < 16 =>
    take (count idfun (int2bs 4 m))
      (W4u32.Pack.to_list (W4u32.unpack32 (VPSHUFB_128 x
        (W16u8.pack16 (Array256.sub matrix_A__SHUFFLE_TABLE (16 * m) 16)))))
  = mask (int2bs 4 m) (W4u32.Pack.to_list (W4u32.unpack32 x)).
proof.
move: m; apply/allP_range.
by rewrite /range /sub /int2bs /mkseq -iotaredE /=.
qed.

(* -------------------------------------------------------------------- *)
lemma to_uint_shr2 (g : W64.t) :
  to_uint (g `>>` W8.of_int 2) = to_uint g %/ 4.
proof. by rewrite W64.shr_div of_uintK /=. qed.

(* -------------------------------------------------------------------- *)
lemma zext32_8E (x : W8.t) :
  zeroextu32 x = W4u8.pack4 [x; W8.zero; W8.zero; W8.zero].
proof.
rewrite W4u8.zeroextu32E &(W4u8.wordP) => i rgi.
rewrite !W4u8.pack4bE 1,2:// initiE 1:// get_of_list 1://.
by move: rgi => /#.
qed.

(* -------------------------------------------------------------------- *)
lemma shl8E (w : W32.t) :
  w `<<` W8.of_int 8 = W4u8.pack4 [W8.zero; w \bits8 0; w \bits8 1; w \bits8 2].
proof.
apply W32.wordP; apply/allP_range.
by rewrite /range -iotaredE /= /(`<<`) of_uintK /=.
qed.

(* -------------------------------------------------------------------- *)
lemma shl16E (w : W32.t) :
  w `<<` W8.of_int 16 = W4u8.pack4 [W8.zero; W8.zero; w \bits8 0; w \bits8 1].
proof.
apply W32.wordP; apply/allP_range.
by rewrite /range -iotaredE /= /(`<<`) of_uintK /=.
qed.

(* -------------------------------------------------------------------- *)
(* the scalar candidate assembly is the packed 3-byte group             *)
lemma or3E (x y z : W8.t) :
  (zeroextu32 x `|` (zeroextu32 y `<<` W8.of_int 8)) `|`
  (zeroextu32 z `<<` W8.of_int 16)
  = W4u8.pack4 [x; y; z].
proof.
by rewrite !zext32_8E shl8E shl16E; apply W4u8.allP => /=.
qed.

hint simplify or3E.

(* -------------------------------------------------------------------- *)
(* local reduction hints for the bytestream decoder                     *)
lemma and255E (x : W8.t) : x `&` W8.of_int 255 = x.
proof.
have -> : W8.of_int 255 = W8.onew.
- by rewrite /onew /=.
by done.
qed.

hint simplify and255E.

lemma pack4_3_and_maskE (a b c : W8.t) :
  W4u8.pack4 [a; b; c] `&` W32.of_int 8388607
  = W4u8.pack4 [a; b; c `&` W8.of_int 127; W8.zero].
proof.
apply W4u8.allP => /=.
by rewrite !W4u8.of_int_bits8_div //=.
qed.

hint simplify pack4_3_and_maskE.

(* DECODING_TABLE.[0]: the dword permutation [0 1 2 0 3 4 5 0]          *)
lemma DECODING_PERM_E :
  W256.of_int 31385508682779410369523405889615886801803926611390921441280
  = W8u32.pack8
    [W32.zero; W32.of_int 1; W32.of_int 2; W32.zero;
     W32.of_int 3; W32.of_int 4; W32.of_int 5; W32.zero].
proof.
apply W8u32.allP => /=.
by rewrite !W8u32.of_int_bits32_div //=.
qed.

hint simplify DECODING_PERM_E.

(* DECODING_TABLE.[1]: the in-lane 3-of-4 byte spread                   *)
lemma DECODING_SHUFFLE_E :
  W256.of_int 115359280993406415849895417079880437751483271933338715711596891385178068484352
  = W32u8.pack32
    [W8.zero; W8.of_int   1; W8.of_int   2; W8.of_int 255;
     W8.of_int   3; W8.of_int   4; W8.of_int   5; W8.of_int 255;
     W8.of_int   6; W8.of_int   7; W8.of_int   8; W8.of_int 255;
     W8.of_int   9; W8.of_int  10; W8.of_int  11; W8.of_int 255;
     W8.zero; W8.of_int   1; W8.of_int   2; W8.of_int 255;
     W8.of_int   3; W8.of_int   4; W8.of_int   5; W8.of_int 255;
     W8.of_int   6; W8.of_int   7; W8.of_int   8; W8.of_int 255;
     W8.of_int   9; W8.of_int  10; W8.of_int  11; W8.of_int 255].
proof. by apply W32u8.allP => /=. qed.

hint simplify DECODING_SHUFFLE_E.

(* DECODING_TABLE.[2]: the 8u32 23-bit mask, fused with the AND         *)
lemma mask23_and_pack32E (x00 x01 x02 x03 x04 x05 x06 x07 x08 x09 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 x31 : W8.t) :
  W32u8.pack32
    [x00; x01; x02; x03; x04; x05; x06; x07;
     x08; x09; x10; x11; x12; x13; x14; x15;
     x16; x17; x18; x19; x20; x21; x22; x23;
     x24; x25; x26; x27; x28; x29; x30; x31] `&`
  W256.of_int 226156397384342666605459106258636701594091082888230722833791023177481060351
  = W32u8.pack32
    [x00; x01; x02 `&` W8.of_int 127; W8.zero;
     x04; x05; x06 `&` W8.of_int 127; W8.zero;
     x08; x09; x10 `&` W8.of_int 127; W8.zero;
     x12; x13; x14 `&` W8.of_int 127; W8.zero;
     x16; x17; x18 `&` W8.of_int 127; W8.zero;
     x20; x21; x22 `&` W8.of_int 127; W8.zero;
     x24; x25; x26 `&` W8.of_int 127; W8.zero;
     x28; x29; x30 `&` W8.of_int 127; W8.zero].
proof.
apply W32u8.allP => /=.
by rewrite !W32u8.of_int_bits8_div //=.
qed.

hint simplify mask23_and_pack32E.

(* -------------------------------------------------------------------- *)
lemma of_int_b2i_eq1P8 (b : bool) : W8.of_int (b2i b) = W8.one => b.
proof.
by case: b => //= _; rewrite W8.to_uint_eq /=.
qed.


(* ==================================================================== *)
(* Reductions for the error-vector (expandS) bytestream decoder:        *)
(* 16 bytes -> 32 nibble candidates via VPMOVZX / VPSLL / VPOR / VPAND  *)

lemma truncateu8_256E (w : W256.t) : truncateu8 w = w \bits8 0.
proof.
apply: W8.ext_eq=> i rgi; rewrite bits8iE //=.
rewrite /truncateu8 of_intwE rgi /= /W8.int_bit.
rewrite modz_pow2_div ~-1://# modz_dvd.
- by rewrite -{1}[2]expr1 dvdz_exp2l /#.
- by rewrite -b2i_get /#.
qed.

(* the broadcast nibble mask assembled by the extracted code            *)
lemma NIBBLE_MASK_E :
  truncateu8 (W2u128.pack2 [VMOV_64 (W64.of_int ((1 `<<` 4) - 1)); W128.zero])
  = W8.of_int 15.
proof.
by rewrite truncateu8_256E -(W256_bits128_bits8 _ 0 0) // W2u128.pack2bE //.
qed.

(* -------------------------------------------------------------------- *)
lemma VPMOVZX_16u8_16u16_pack16E (x : W128.t) :
  VPMOVZX_16u8_16u16 x
  = W16u16.pack16 [MOVZX_u16u8 (x \bits8 0); MOVZX_u16u8 (x \bits8 1); MOVZX_u16u8 (x \bits8 2); MOVZX_u16u8 (x \bits8 3); MOVZX_u16u8 (x \bits8 4); MOVZX_u16u8 (x \bits8 5); MOVZX_u16u8 (x \bits8 6); MOVZX_u16u8 (x \bits8 7); MOVZX_u16u8 (x \bits8 8); MOVZX_u16u8 (x \bits8 9); MOVZX_u16u8 (x \bits8 10); MOVZX_u16u8 (x \bits8 11); MOVZX_u16u8 (x \bits8 12); MOVZX_u16u8 (x \bits8 13); MOVZX_u16u8 (x \bits8 14); MOVZX_u16u8 (x \bits8 15)].
proof.
by apply W256.all_eq_eq;
   cbv W256.all_eq VPMOVZX_16u8_16u16 W16u8.unpack8 W16u16.unpack16.
qed.

lemma MOVZX_u16u8E (b : W8.t) : MOVZX_u16u8 b = W2u8.pack2 [b; W8.zero].
proof.
apply W2u8.allP => /=.
rewrite /MOVZX_u16u8 !W2u8.of_int_bits8_div //=.
by rewrite pdiv_small 1:W8.to_uint_cmp.
qed.

lemma VPSLL_16u16_pack16E (l0 l1 l2 l3 l4 l5 l6 l7 l8 l9 l10 l11 l12 l13 l14 l15 : W16.t) (cnt : W128.t) :
  VPSLL_16u16 (W16u16.pack16 [l0; l1; l2; l3; l4; l5; l6; l7; l8; l9; l10; l11; l12; l13; l14; l15]) cnt
  = W16u16.pack16
    [l0 `<<<` to_uint (W64.of_int (to_uint cnt));
     l1 `<<<` to_uint (W64.of_int (to_uint cnt));
     l2 `<<<` to_uint (W64.of_int (to_uint cnt));
     l3 `<<<` to_uint (W64.of_int (to_uint cnt));
     l4 `<<<` to_uint (W64.of_int (to_uint cnt));
     l5 `<<<` to_uint (W64.of_int (to_uint cnt));
     l6 `<<<` to_uint (W64.of_int (to_uint cnt));
     l7 `<<<` to_uint (W64.of_int (to_uint cnt));
     l8 `<<<` to_uint (W64.of_int (to_uint cnt));
     l9 `<<<` to_uint (W64.of_int (to_uint cnt));
     l10 `<<<` to_uint (W64.of_int (to_uint cnt));
     l11 `<<<` to_uint (W64.of_int (to_uint cnt));
     l12 `<<<` to_uint (W64.of_int (to_uint cnt));
     l13 `<<<` to_uint (W64.of_int (to_uint cnt));
     l14 `<<<` to_uint (W64.of_int (to_uint cnt));
     l15 `<<<` to_uint (W64.of_int (to_uint cnt))].
proof.
by apply W256.all_eq_eq; cbv W256.all_eq VPSLL_16u16 W16u16.unpack16.
qed.

(* -------------------------------------------------------------------- *)
(* regrouping a pack16 of byte pairs as a pack32 of bytes               *)
lemma pack16_2E (b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20 b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 : W8.t) :
  W16u16.pack16 [W2u8.pack2 [b00; b01]; W2u8.pack2 [b02; b03]; W2u8.pack2 [b04; b05]; W2u8.pack2 [b06; b07]; W2u8.pack2 [b08; b09]; W2u8.pack2 [b10; b11]; W2u8.pack2 [b12; b13]; W2u8.pack2 [b14; b15]; W2u8.pack2 [b16; b17]; W2u8.pack2 [b18; b19]; W2u8.pack2 [b20; b21]; W2u8.pack2 [b22; b23]; W2u8.pack2 [b24; b25]; W2u8.pack2 [b26; b27]; W2u8.pack2 [b28; b29]; W2u8.pack2 [b30; b31]]
  = W32u8.pack32 [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15; b16; b17; b18; b19; b20; b21; b22; b23; b24; b25; b26; b27; b28; b29; b30; b31].
proof.
by apply W256.all_eq_eq;
   cbv W256.all_eq W16u16.unpack16 W32u8.unpack8 W2u8.unpack8.
qed.

lemma VPBROADCAST_32u8_pack16E (w : W8.t) :
  VPBROADCAST_32u8 w = W16u16.pack16 [W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]; W2u8.pack2 [w; w]].
proof.
by rewrite /VPBROADCAST_32u8 -iotaredE /= -pack16_2E.
qed.

(* -------------------------------------------------------------------- *)
(* one 16-bit lane: zero-extended byte or-ed with its 4-shift, masked   *)
lemma nib_laneE (b : W8.t) :
  (W2u8.pack2 [b; W8.zero] `|` (W2u8.pack2 [b; W8.zero] `<<<` 4)) `&`
  W2u8.pack2 [W8.of_int 15; W8.of_int 15]
  = W2u8.pack2 [b `&` W8.of_int 15; b `>>>` 4].
proof.
apply W16.wordP; apply/allP_range.
rewrite /range -iotaredE /=.
rewrite !W8.of_intwE /W8.int_bit /=.
rewrite ?W16.get_out // ?orbF.
by rewrite !W8.get_to_uint /=.
qed.

(* -------------------------------------------------------------------- *)
(* the assembled decoder dataflow: byte 2j is the low nibble of input   *)
(* byte j, byte 2j+1 its high nibble                                    *)
lemma nibble_decodeE (x : W128.t) :
  (VPMOVZX_16u8_16u16 x `|`
   VPSLL_16u16 (VPMOVZX_16u8_16u16 x) (W128.of_int 4)) `&`
  VPBROADCAST_32u8
    (truncateu8 (W2u128.pack2 [VMOV_64 (W64.of_int ((1 `<<` 4) - 1)); W128.zero]))
  = W32u8.pack32
      [(x \bits8  0) `&` W8.of_int 15; (x \bits8  0) `>>>` 4;
       (x \bits8  1) `&` W8.of_int 15; (x \bits8  1) `>>>` 4;
       (x \bits8  2) `&` W8.of_int 15; (x \bits8  2) `>>>` 4;
       (x \bits8  3) `&` W8.of_int 15; (x \bits8  3) `>>>` 4;
       (x \bits8  4) `&` W8.of_int 15; (x \bits8  4) `>>>` 4;
       (x \bits8  5) `&` W8.of_int 15; (x \bits8  5) `>>>` 4;
       (x \bits8  6) `&` W8.of_int 15; (x \bits8  6) `>>>` 4;
       (x \bits8  7) `&` W8.of_int 15; (x \bits8  7) `>>>` 4;
       (x \bits8  8) `&` W8.of_int 15; (x \bits8  8) `>>>` 4;
       (x \bits8  9) `&` W8.of_int 15; (x \bits8  9) `>>>` 4;
       (x \bits8 10) `&` W8.of_int 15; (x \bits8 10) `>>>` 4;
       (x \bits8 11) `&` W8.of_int 15; (x \bits8 11) `>>>` 4;
       (x \bits8 12) `&` W8.of_int 15; (x \bits8 12) `>>>` 4;
       (x \bits8 13) `&` W8.of_int 15; (x \bits8 13) `>>>` 4;
       (x \bits8 14) `&` W8.of_int 15; (x \bits8 14) `>>>` 4;
       (x \bits8 15) `&` W8.of_int 15; (x \bits8 15) `>>>` 4].
proof.
rewrite NIBBLE_MASK_E VPBROADCAST_32u8_pack16E.
rewrite VPMOVZX_16u8_16u16_pack16E VPSLL_16u16_pack16E !of_uintK /=.
rewrite !MOVZX_u16u8E /=.
rewrite !nib_laneE.
by rewrite pack16_2E.
qed.

(* -------------------------------------------------------------------- *)
lemma VPSUB_32u8E (u w : W256.t) :
    VPSUB_32u8 u w
  = W32u8.pack32 [
      (u \bits8  0) - (w \bits8  0);
      (u \bits8  1) - (w \bits8  1);
      (u \bits8  2) - (w \bits8  2);
      (u \bits8  3) - (w \bits8  3);
      (u \bits8  4) - (w \bits8  4);
      (u \bits8  5) - (w \bits8  5);
      (u \bits8  6) - (w \bits8  6);
      (u \bits8  7) - (w \bits8  7);
      (u \bits8  8) - (w \bits8  8);
      (u \bits8  9) - (w \bits8  9);
      (u \bits8 10) - (w \bits8 10);
      (u \bits8 11) - (w \bits8 11);
      (u \bits8 12) - (w \bits8 12);
      (u \bits8 13) - (w \bits8 13);
      (u \bits8 14) - (w \bits8 14);
      (u \bits8 15) - (w \bits8 15);
      (u \bits8 16) - (w \bits8 16);
      (u \bits8 17) - (w \bits8 17);
      (u \bits8 18) - (w \bits8 18);
      (u \bits8 19) - (w \bits8 19);
      (u \bits8 20) - (w \bits8 20);
      (u \bits8 21) - (w \bits8 21);
      (u \bits8 22) - (w \bits8 22);
      (u \bits8 23) - (w \bits8 23);
      (u \bits8 24) - (w \bits8 24);
      (u \bits8 25) - (w \bits8 25);
      (u \bits8 26) - (w \bits8 26);
      (u \bits8 27) - (w \bits8 27);
      (u \bits8 28) - (w \bits8 28);
      (u \bits8 29) - (w \bits8 29);
      (u \bits8 30) - (w \bits8 30);
      (u \bits8 31) - (w \bits8 31)
    ].
proof. by cbv delta. qed.

(* -------------------------------------------------------------------- *)
(* the broadcast-constant assembly VMOV_64 / zeroext / truncate / bcast *)
lemma truncateu8_bcastE (n : int) :
  truncateu8 (W2u128.pack2 [VMOV_64 (W64.of_int n); W128.zero]) = W8.of_int n.
proof.
rewrite truncateu8_256E -(W256_bits128_bits8 _ 0 0) // W2u128.pack2bE //.
rewrite W2u128.Pack.get_of_list //=.
rewrite -(W128_bits64_bits8 _ 0 0) // W2u64.pack2bE // W2u64.Pack.get_of_list //=.
by rewrite W8u8.of_int_bits8_div //= divz1.
qed.

(* -------------------------------------------------------------------- *)
(* signed byte-to-dword extension of a 4 - z coefficient byte           *)
lemma MOVSX_u32s8_subE (z : W8.t) :
  to_uint z < 128 =>
  MOVSX_u32s8 (W8.of_int 4 - z) = W32.of_int 4 - zeroextu32 z.
proof.
move=> hz; rewrite /MOVSX_u32s8.
have -> : W8.of_int 4 - z = W8.of_int (4 - to_uint z).
- by rewrite -{1}(W8.to_uintK z); ring.
have -> : to_sint (W8.of_int (4 - to_uint z)) = 4 - to_uint z.
- rewrite /to_sint /smod W8.of_uintK.
  by smt(W8.to_uint_cmp).
rewrite /zeroextu32.
by rewrite -{2}(W8.to_uintK z); ring.
qed.

(* -------------------------------------------------------------------- *)
lemma VPMOVSX_8u8_8u32_to_listE (w : W64.t) :
  W8u32.Pack.to_list (W8u32.unpack32 (VPMOVSX_8u8_8u32 w))
  = map MOVSX_u32s8 (W8u8.to_list w).
proof. by rewrite /VPMOVSX_8u8_8u32 /=. qed.

(* -------------------------------------------------------------------- *)
(* acceptance as the sign of the z - 9 comparison byte                  *)
lemma msb_sub9E (z : W8.t) :
  to_uint z < 16 =>
  W8.msb (z - W8.of_int 9) = (to_uint z < 9).
proof.
move=> hz; rewrite /msb.
have -> : z - W8.of_int 9 = W8.of_int (to_uint z - 9).
- by rewrite -{1}(W8.to_uintK z); ring.
rewrite W8.of_uintK.
by smt(W8.to_uint_cmp).
qed.

(* -------------------------------------------------------------------- *)
(* 8-candidate versions of the popcount byte-counter lemmas             *)
lemma popcnt_count8 (g : W64.t) (bs : bool list) :
  size bs = 8 => to_uint g = bs2int bs =>
  count idfun (W64.w2bits g) = count idfun bs.
proof.
move=> szb hg.
have e1 : bs2int (W64.w2bits g) = bs2int (bs ++ nseq 56 false).
- by rewrite -W64.to_uintE hg bs2int_cat bs2int_nseq_false szb /=.
have h1 := bs2intK (W64.w2bits g).
have h2 := bs2intK (bs ++ nseq 56 false).
move: h1 h2; rewrite W64.size_w2bits size_cat szb size_nseq /= e1 => h1 h2.
rewrite -h1 h2.
by rewrite count_cat count_nseq /idfun /=.
qed.

lemma popcnt_step8 (bf h : W64.t) (bs : bool list) :
  size bs = 8 => to_uint h = bs2int bs => to_uint bf <= 1024 =>
  to_uint (bf + ((POPCNT_64 h).`6 `<<` W8.of_int 2))
  = to_uint bf + 4 * count idfun bs.
proof.
move=> szbs hh hbf.
have hcle : count idfun bs <= 8 by have := count_size idfun bs; rewrite szbs.
have hcnt : count idfun (W64.w2bits h) = count idfun bs.
- by apply popcnt_count8.
have hp : to_uint ((POPCNT_64 h).`6 `<<` W8.of_int 2) = 4 * count idfun bs.
- rewrite popcnt6E hcnt /(`<<`) of_uintK /= W64.to_uint_shl // of_uintK /ptr_modulus.
  rewrite pmod_small; 1: by move: hcle => /=; smt(count_ge0).
  rewrite pmod_small; 1: by move: hcle => /=; smt(count_ge0).
  by ring.
by rewrite W64.to_uintD_small hp /=; smt(count_ge0).
qed.

(* -------------------------------------------------------------------- *)
(* the shuffle-table row selected by an 8-bit acceptance mask           *)
lemma shuffle_slot8 (h : W64.t) (bs : bool list) :
  size bs = 8 => to_uint h = bs2int bs =>
  to_uint (h `<<` W8.of_int 3) = 8 * bs2int bs.
proof.
move=> szbs hh.
have hbnd : 0 <= bs2int bs < 256.
- by rewrite bs2int_ge0 /=; have := bs2int_le2Xs bs; rewrite szbs.
by rewrite /(`<<`) of_uintK /= W64.to_uint_shl // hh pmod_small /#.
qed.

(* ==================================================================== *)
(* Phase-3 leaf adapters for the error-vector rejection loops           *)
section.

hint simplify b2i0, b2i1.

lemma to_uint_lonib_lt16 (b : W8.t) : to_uint (b `&` W8.of_int 15) < 16.
proof. by rewrite (_ : 15 = 2 ^ 4 - 1) // W8.to_uint_and_mod // ltz_pmod. qed.

lemma to_uint_hinib_lt16 (b : W8.t) : to_uint (b `>>>` 4) < 16.
proof.
rewrite W8.to_uint_shr // ltz_divLR //=.
by have := W8.to_uint_cmp b => /#.
qed.

lemma and255_bs2int (h : W64.t) (bs : bool list) :
  to_uint h = bs2int bs =>
  to_uint (h `&` W64.of_int 255) = bs2int (take 8 bs).
proof.
by move=> hh; rewrite (_ : 255 = 2 ^ 8 - 1) // W64.to_uint_and_mod // hh bs2int_mod.
qed.

lemma shr8_bs2int (h : W64.t) (bs : bool list) :
  to_uint h = bs2int bs =>
  to_uint (h `>>` W8.of_int 8) = bs2int (drop 8 bs).
proof.
by move=> hh; rewrite W64.shr_div of_uintK /= hh (_ : 256 = 2 ^ 8) 1:// bs2int_div.
qed.

lemma VPBROADCAST_32u8_pack32E (w : W8.t) :
  VPBROADCAST_32u8 w = W32u8.pack32 [w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w; w].
proof. by rewrite /VPBROADCAST_32u8 -iotaredE. qed.

lemma VEXTRACTI128_0_pack32E (b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20 b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 : W8.t) :
  VEXTRACTI128 (W32u8.pack32 [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15; b16; b17; b18; b19; b20; b21; b22; b23; b24; b25; b26; b27; b28; b29; b30; b31]) W8.zero
  = W16u8.pack16 [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15].
proof. by rewrite /VEXTRACTI128 /=. qed.

lemma VEXTRACTI128_1_pack32E (b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20 b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 : W8.t) :
  VEXTRACTI128 (W32u8.pack32 [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15; b16; b17; b18; b19; b20; b21; b22; b23; b24; b25; b26; b27; b28; b29; b30; b31]) W8.one
  = W16u8.pack16 [b16; b17; b18; b19; b20; b21; b22; b23; b24; b25; b26; b27; b28; b29; b30; b31].
proof.
rewrite /VEXTRACTI128.
by have -> : b2i W8.one.[0] = 1 by rewrite W8.get_to_uint.
qed.

lemma VPSRLDQ8_pack16E (b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 b11 b12 b13 b14 b15 : W8.t) :
  VPSRLDQ_128 (W16u8.pack16 [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15]) (W8.of_int 8)
  = W16u8.pack16 [b08; b09; b10; b11; b12; b13; b14; b15; W8.zero; W8.zero; W8.zero; W8.zero; W8.zero; W8.zero; W8.zero; W8.zero].
proof.
rewrite /VPSRLDQ_128 /= /min /=.
apply W128.wordP; apply/allP_range.
rewrite /range -iotaredE /=.
by rewrite ?W128.get_out //=.
qed.

lemma VPSUB_bcast4_pack32E (b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20 b21 b22 b23 b24 b25 b26 b27 b28 b29 b30 b31 : W8.t) :
  VPSUB_32u8 (VPBROADCAST_32u8 (W8.of_int 4)) (W32u8.pack32 [b00; b01; b02; b03; b04; b05; b06; b07; b08; b09; b10; b11; b12; b13; b14; b15; b16; b17; b18; b19; b20; b21; b22; b23; b24; b25; b26; b27; b28; b29; b30; b31])
  = W32u8.pack32 [W8.of_int 4 - b00; W8.of_int 4 - b01; W8.of_int 4 - b02; W8.of_int 4 - b03; W8.of_int 4 - b04; W8.of_int 4 - b05; W8.of_int 4 - b06; W8.of_int 4 - b07; W8.of_int 4 - b08; W8.of_int 4 - b09; W8.of_int 4 - b10; W8.of_int 4 - b11; W8.of_int 4 - b12; W8.of_int 4 - b13; W8.of_int 4 - b14; W8.of_int 4 - b15; W8.of_int 4 - b16; W8.of_int 4 - b17; W8.of_int 4 - b18; W8.of_int 4 - b19; W8.of_int 4 - b20; W8.of_int 4 - b21; W8.of_int 4 - b22; W8.of_int 4 - b23; W8.of_int 4 - b24; W8.of_int 4 - b25; W8.of_int 4 - b26; W8.of_int 4 - b27; W8.of_int 4 - b28; W8.of_int 4 - b29; W8.of_int 4 - b30; W8.of_int 4 - b31].
proof. by rewrite VPBROADCAST_32u8_pack32E VPSUB_32u8E /=. qed.


end section.

(* -------------------------------------------------------------------- *)
lemma VPSRLV_8u32E (u w : W256.t) :
    VPSRLV_8u32 u w
  = W8u32.pack8 [
      (u \bits32 0) `>>>` to_uint (w \bits32 0);
      (u \bits32 1) `>>>` to_uint (w \bits32 1);
      (u \bits32 2) `>>>` to_uint (w \bits32 2);
      (u \bits32 3) `>>>` to_uint (w \bits32 3);
      (u \bits32 4) `>>>` to_uint (w \bits32 4);
      (u \bits32 5) `>>>` to_uint (w \bits32 5);
      (u \bits32 6) `>>>` to_uint (w \bits32 6);
      (u \bits32 7) `>>>` to_uint (w \bits32 7)
    ].
proof. by cbv delta. qed.

hint simplify VPSRLV_8u32E.

(* -------------------------------------------------------------------- *)
lemma VPSHUFB_256_pack2E (a b m0 m1 : W128.t) :
  VPSHUFB_256 (W2u128.pack2 [a; b]) (W2u128.pack2 [m0; m1])
  = W2u128.pack2 [VPSHUFB_128 a m0; VPSHUFB_128 b m1].
proof. by cbv delta. qed.

hint simplify VPSHUFB_256_pack2E.

(* -------------------------------------------------------------------- *)
(* regroup a byte-level 256-bit value into its eight 32-bit slots       *)
lemma pack2_pack16_8u32E
  (c00 c01 c02 c03 c04 c05 c06 c07 c08 c09 c10 c11 c12 c13 c14 c15 : W8.t)
  (d00 d01 d02 d03 d04 d05 d06 d07 d08 d09 d10 d11 d12 d13 d14 d15 : W8.t) :
  W2u128.pack2
    [W16u8.pack16 [c00; c01; c02; c03; c04; c05; c06; c07;
                   c08; c09; c10; c11; c12; c13; c14; c15];
     W16u8.pack16 [d00; d01; d02; d03; d04; d05; d06; d07;
                   d08; d09; d10; d11; d12; d13; d14; d15]]
  = W8u32.pack8
      [W4u8.pack4 [c00; c01; c02; c03]; W4u8.pack4 [c04; c05; c06; c07];
       W4u8.pack4 [c08; c09; c10; c11]; W4u8.pack4 [c12; c13; c14; c15];
       W4u8.pack4 [d00; d01; d02; d03]; W4u8.pack4 [d04; d05; d06; d07];
       W4u8.pack4 [d08; d09; d10; d11]; W4u8.pack4 [d12; d13; d14; d15]].
proof. by cbv delta. qed.


(* -------------------------------------------------------------------- *)
lemma zeroextu128E (w : W64.t) : zeroextu128 w = pack2 [w; W64.zero].
proof.
rewrite zeroextu128E &(W128.wordP) => i rgi /=.
rewrite !pack2wE ~-1:// initiE 1:/# get_of_list 1:/#.
by have [->|->] /= : i %/ 64 = 0 \/ i %/ 64 = 1 by smt().
qed.

lemma truncateu32_VMOV_64 (w : W64.t) :
  truncateu32 (VMOV_64 w) = truncateu32 w.
proof.
rewrite /VMOV_64 -zeroextu128E.
rewrite -(W32.to_uintK (truncateu32 (zeroextu128 w))).
rewrite W4u32.to_uint_truncateu32 W2u64.to_uint_zeroextu128.
by rewrite -(W32.to_uintK (truncateu32 w)) W2u32.to_uint_truncateu32.
qed.

hint simplify truncateu32_VMOV_64.

(* ==================================================================== *)
(* Montgomery multiplication of 8 lanes, in the model of any set        *)
(* ==================================================================== *)
abstract theory Avx2redT.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.

lemma mmrP (u v : W256.t) : hoare[M.montgomery_multiply_and_reduce :
      arg = (u, v)
    ==>
      res = W8u32.pack8_t (W8u32.Pack.map2 mmr (W8u32.unpack32 u) (W8u32.unpack32 v))
  ].
proof.
hint +listred.
proc.
auto=> &hr [#] 2!->>.
pose uw (i : int) := u \bits32 i; pose vw (i : int) := v \bits32 i.
rewrite -[u]pack8K /= -!/~(uw _) -[v]pack8K /= -!/~(vw _).
rewrite INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR_E MODULUS_VECTOR_E.
rewrite /INVERSE_OF_MODULUS_MOD_MONTGOMERY_R_VECTOR /=.
rewrite /MODULUS_VECTOR //=.

pose qinv := W32.of_int INVERSE_OF_MODULUS_MOD_MONTGOMERY_R.
pose q    := W32.of_int MODULUS.

pose F    := fun k =>
    (uw k \sx vw k)
  - (uw k \sx vw k \bits32 0 \sx qinv \bits32 0 \sx q) \bits32 1.

apply: (pack8_eq F (fun i => mmr (uw i) (vw i))).
move=> i rgi @/F @/mmr /=; move: (uw i) (vw i) => w1 w2.
by rewrite -shr_shrw 1:// => {F vw uw}; circuit.
qed.

(* -------------------------------------------------------------------- *)
lemma mmr_ll (u v : W256.t) : phoare[M.montgomery_multiply_and_reduce :
      arg = (u, v)
    ==>
      true
  ] = 1%r.
proof. by proc; islossless. qed.

(* -------------------------------------------------------------------- *)
lemma mmrP_ll (u v : W256.t) : phoare[M.montgomery_multiply_and_reduce :
      arg = (u, v)
    ==>
      res = W8u32.pack8_t (W8u32.Pack.map2 mmr (W8u32.unpack32 u) (W8u32.unpack32 v))
  ] = 1%r.
proof. by conseq (mmr_ll u v) (mmrP u v). qed.

(* -------------------------------------------------------------------- *)

end Avx2redT.
