(* -------------------------------------------------------------------- *)
(* The challenge sampler against the specification's SampleInBall      *)
(*                                                                      *)
(* The code reads the SHAKE256 stream of the commitment hash in 136-byte *)
(* blocks, the specification byte by byte; both follow [sib_iter].  The *)
(* code's termination follows from the specification's criterion       *)
(* [sib_ok]: the inner rejection loop's variant is the distance to the  *)
(* first acceptable byte, measured from the largest stream position the *)
(* state is consistent with (the XOF state need not determine it).      *)
(* -------------------------------------------------------------------- *)
require import AllCore List IntDiv IntMin BitEncoding.

from Jasmin require import JModel_x86.

from JazzEC require import Ml_dsa_65_avx2 Mldsa_65_prelude.

from Spec require import GFq Rq Serialization Conversion Parameters VecMat
                         Symmetric Sampling MLDSA_W32_Rep MLDSA.

from CryptoSpecs require import Keccak1600_Spec.

import Round ZModQ Zq.

require import Array25 Array28 Array48 Array136 Array256 WArray136 WArray1024.
require import Rejstream Sha3x4. import Shake256x4.

(* -------------------------------------------------------------------- *)
(* the stream as the code reads it                                      *)
lemma sib_byteE (s : W8.t Array48.t) (t : int) :
  sib_byte (BytesCT.of_list (to_list s)) t = to_uint (shake256_xof (to_list s) t).
proof. by rewrite /sib_byte BytesCT.of_listK // size_to_list mldsa65_lambda. qed.

lemma blk_byteE (n : W8.t list) (blk : W8.t Array136.t) (kb off : int) :
  Array136.to_list blk = shake256_slice n (136 * kb) 136 => 0 <= off < 136 =>
  blk.[off] = shake256_xof n (136 * kb + off).
proof.
move=> hb rgo; have := congr1 (fun l => nth witness l off) _ _ hb => /=.
by rewrite /shake256_slice /Xof.slice nth_mkseq //= -Array136.get_to_list.
qed.

(* the sign bits are the first 8 bytes of the first block               *)
lemma sib_signsE (s : W8.t Array48.t) (blk : W8.t Array136.t) (b : int) :
  Array136.to_list blk = shake256_slice (to_list s) 0 136 => 0 <= b < 64 =>
  (sib_signs (BytesCT.of_list (to_list s))).[b] = blk.[b %/ 8].[b %% 8].
proof.
move=> hb rgb.
rewrite /sib_signs /H_sib BytesCT.of_listK; 1: by rewrite size_to_list mldsa65_lambda.
rewrite Bytes8.of_listK; 1: by rewrite size_SHAKE256.
rewrite /BytesToBits /"_.[_]" (BitChunking.nth_flatten witness 8).
- by rewrite allP => l /mapP [w [_ ->]].
rewrite (nth_map witness) 1:size_SHAKE256 1,2:/#.
rewrite -shake256_sliceE // /shake256_slice /Xof.slice nth_mkseq 1:/# /=.
have := blk_byteE _ _ 0 (b %/ 8) hb _; 1: smt().
rewrite /= => ->.
by rewrite (nth_change_dfl false) ?W8.size_w2bits 1:/# W8.get_w2bits.
qed.

(* -------------------------------------------------------------------- *)
(* the word-level steps of the code                                     *)
lemma get64_bitE (blk : W8.t Array136.t) (b : int) : 0 <= b < 64 =>
  (get64_direct (WArray136.init8 (fun i => blk.[i])) 0).[b] = blk.[b %/ 8].[b %% 8].
proof.
move=> rgb; rewrite /get64_direct W8u8.pack8wE // W8u8.Pack.initiE 1:/# /=.
by rewrite WArray136.initiE 1:/#.
qed.

lemma shr1_bitE (w : W64.t) (b : int) : 0 <= b < 63 =>
  (w `>>` W8.of_int 1).[b] = w.[b + 1].
proof. by move=> rgb; rewrite /(`>>`) W64.shrwE /=; smt(). qed.

lemma and1E (w : W64.t) : w `&` W64.one = if w.[0] then W64.one else W64.zero.
proof.
apply W64.wordP => i rgi; rewrite W64.andwE.
case: (w.[0]) => h.
- by rewrite W64.nth_one; case: (i = 0) => [->> | ne] //=; rewrite h.
by rewrite W64.zerowE W64.nth_one /=; case: (i = 0) => [->> | ne] //=; rewrite h.
qed.

lemma sign_coeff1 (w : W64.t) : w `&` W64.one = W64.one =>
  W32.of_int 1 - ((truncateu32 w `&` W32.of_int 1) `<<` W8.of_int 1) = W32.of_int (-1).
proof. circuit. qed.

lemma sign_coeff0 (w : W64.t) : w `&` W64.one = W64.zero =>
  W32.of_int 1 - ((truncateu32 w `&` W32.of_int 1) `<<` W8.of_int 1) = W32.one.
proof. circuit. qed.

(* the coefficient written at the sampled position: 1 - 2 * sign bit    *)
lemma sign_coeffE (w : W64.t) :
  W32.of_int 1 - ((truncateu32 w `&` W32.of_int 1) `<<` W8.of_int 1)
  = if w.[0] then W32.of_int (-1) else W32.one.
proof.
have := and1E w; case: (w.[0]) => _ h.
- by apply sign_coeff1.
by apply sign_coeff0.
qed.

lemma lifts_wpoly_set (w : W32.t Array256.t) (k : int) (x : W32.t) : 0 <= k < 256 =>
  lifts_wpoly w.[k <- x] = (lifts_wpoly w).[k <- incoeff (to_sint x)].
proof.
move=> rgk; apply Array256.tP => i rgi.
rewrite /lifts_wpoly Array256.mapiE // !Array256.get_setE // Array256.mapiE //=.
by case: (i = k).
qed.

lemma srng_set (w : W32.t Array256.t) (k : int) (x : W32.t) : 0 <= k < 256 =>
  wpoly_srng 1 1 w => -1 <= to_sint x <= 1 => wpoly_srng 1 1 w.[k <- x].
proof.
rewrite /wpoly_srng !Array256.allP => rgk hw hx i rgi /=.
rewrite Array256.get_setE //; case: (i = k) => _ //.
by have /= := hw i rgi.
qed.

(* -------------------------------------------------------------------- *)
(* losslessness of the single-lane SHAKE256 wrappers                    *)
lemma __load_shake256_state_ll : islossless M.__load_shake256_state.
proof. proc; while true (7 - i); auto => /#. qed.
hint solve 0 lossless : __load_shake256_state_ll.

lemma __store_shake256_state_ll : islossless M.__store_shake256_state.
proof. proc; while true (7 - i); auto => /#. qed.
hint solve 0 lossless : __store_shake256_state_ll.

lemma shake256_squeezeblock_ll : islossless M.shake256_squeezeblock.
proof. by islossless. qed.
hint solve 0 lossless : shake256_squeezeblock_ll.

lemma shake256_absorb_commitment_hash_ll : islossless M.shake256_absorb_commitment_hash.
proof. by islossless. qed.
hint solve 0 lossless : shake256_absorb_commitment_hash_ll.

(* -------------------------------------------------------------------- *)
(* the code's position in the SHAKE256 stream: block kb is buffered,     *)
(* the sponge has squeezed blocks 0..kb, and p = 136 * kb + off          *)
op xof_at (n : W8.t list) (p : int) (st : W64.t Array28.t) (blk : W8.t Array136.t) (off : W64.t) =
  exists kb, 0 <= kb
    /\ lanes_of st \sha3one mk_read (136 * (kb + 1)) n
    /\ Array136.to_list blk = shake256_slice n (136 * kb) 136
    /\ to_uint off <= 136 /\ p = 136 * kb + to_uint off.

(* reading the buffered byte at a position below the block end           *)
lemma xof_read (s : W8.t Array48.t) (p : int) st blk (off : W64.t) :
  xof_at (to_list s) p st blk off => to_uint off < 136 =>
     to_uint (zeroextu64 blk.[to_uint off]) = sib_byte (BytesCT.of_list (to_list s)) p
  /\ xof_at (to_list s) (p + 1) st blk (off + W64.one).
proof.
move=> [kb [ge0kb [hst [hblk [hle ->]]]]] hlt.
have h1 : to_uint (off + W64.one) = to_uint off + 1 by rewrite to_uintD_small /= /#.
split.
- rewrite /zeroextu64 W64.of_uintK sib_byteE.
  have := blk_byteE _ _ kb (to_uint off) hblk _; 1: smt(W64.to_uint_cmp).
  move=> <-; have /= hb := W8.to_uint_cmp blk.[to_uint off]; rewrite pmod_small //; split; smt().
by exists kb; rewrite h1 hst hblk /= /#.
qed.

(* refilling at the block end squeezes the next block                   *)
lemma squeeze_refillP (n : W8.t list) (p : int) :
  hoare[ M.shake256_squeezeblock :
     exists kb, 0 <= kb /\ lanes_of st \sha3one mk_read (136 * (kb + 1)) n
                /\ p = 136 * (kb + 1)
     ==> xof_at n p res.`1 res.`2 W64.zero ].
proof.
elim* => kb.
conseq (shake256_squeezeblockP n (kb + 1)).
- by move=> &hr [h0 [hs _]]; split => // /#.
move=> &hr [h0 [hs hp]] r [hr1 hr2]; exists (kb + 1); rewrite hr1 hr2 /= hp /#.
qed.

(* the part of the loop state that a byte read leaves alone              *)
op ch_frame (ct : BytesCT.t) (i0 : int) (i signs : W64.t) (out : W32.t Array256.t) =
     to_uint i = i0
  /\ (forall b, 0 <= b < 64 - (i0 - (256 - tau)) =>
        signs.[b] = (sib_signs ct).[i0 - (256 - tau) + b])
  /\ lifts_wpoly out = (sib_iter ct (i0 - (256 - tau))).`1
  /\ wpoly_srng 1 1 out.

(* -------------------------------------------------------------------- *)
lemma sample____challengeP (s : W8.t Array48.t) :
  phoare [ M.sample____challenge : seed = s ==>
     lifts_wpoly res = (sampleInBall (BytesCT.of_list (to_list s))).`1
  /\ wpoly_srng 1 1 res ] = 1%r.
proof.
pose n := to_list s; pose ct := BytesCT.of_list n.
have hok := sib_terminates ct.
have ht : tau = 49 by exact mldsa65_tau.
proc.
(* zeroing, absorb, first block, sign bits *)
seq 12 : (true) 1%r 1%r 0%r 0%r
  (to_uint i = 256 - tau /\ condition_loop = (i \ult W64.of_int 256)
   /\ xof_at n (sib_iter ct 0).`3 state xof_block xof_offset
   /\ (forall b, 0 <= b < 64 => signs.[b] = (sib_signs ct).[b])
   /\ lifts_wpoly output_challenge = (sib_iter ct 0).`1 /\ wpoly_srng 1 1 output_challenge).
- seq 5 : (seed = s /\ forall k, 0 <= k < 256 => output_challenge.[k] = W32.zero).
  + while (seed = s /\ 0 <= to_uint i <= 1024 /\ 32 %| to_uint i /\ zeros_256 = set0_256
           /\ forall k, 0 <= k < to_uint i %/ 4 => output_challenge.[k] = W32.zero).
    * auto=> &hr [#] hs ge0 le1024 hdvd hz0 hz hlt /=.
      have hlt' : to_uint i{hr} < 1024 by move: hlt; rewrite W64.ultE of_uintK /=.
      have hle : to_uint i{hr} <= 992 by move: hdvd hlt' => /dvdzP [q ->] /#.
      have hi : to_uint (i{hr} + W64.of_int 32) = to_uint i{hr} + 32 by rewrite to_uintD_small /#.
      rewrite hi hs hz0 /=; do 2! (split; 1: smt()).
      move=> k rgk; rewrite (Avx2red.wpoly_set256_alignedE (to_uint i{hr})) 1,2:/#.
      rewrite Array256.filliE 1:/# /=.
      case: (to_uint i{hr} %/ 4 <= k < to_uint i{hr} %/ 4 + 8) => hr; last by apply hz => /#.
      by apply W32.wordP => b rgb; rewrite W8u32.bits32iE.
    * auto=> &hr -> /=; split; 1: smt().
      move=> i0 o0; rewrite W64.ultE of_uintK /= => hge [#] _ hle _ hz k rgk.
      by apply hz; smt().
  wp; ecall (shake256_squeezeblockP n 0); ecall (shake256_absorb_commitment_hashP s).
  auto=> &hr [-> hz] st hst; split; 1: by rewrite /= -mk_absorbed_read0.
  move=> _ r [hr1 hr2].
  have hit0 : sib_iter ct 0 = (poly_zero, [], 8) by rewrite /sib_iter iota0.
  rewrite hit0 /=; split; 1: by rewrite ht.
  split; 1: by exists 0 => /=; rewrite hr1 hr2.
  split.
  - move=> b rgb; rewrite /ct /n (sib_signsE s r.`2 b) //.
    exact (get64_bitE r.`2 b rgb).
  split.
  - apply Array256.tP => k rgk; rewrite /lifts_wpoly Array256.mapiE // hz //= /poly_zero Array256.createiE //.
    by rewrite W32.to_sintE /smod /= incoeff0.
  by rewrite /wpoly_srng Array256.allP => k rgk /=; rewrite hz //= W32.to_sintE /smod.
- wp; call shake256_squeezeblock_ll; call shake256_absorb_commitment_hash_ll.
  while (0 <= to_uint i <= 1024 /\ 32 %| to_uint i) (1024 - to_uint i).
  + move=> z; auto => &hr [[[h0 hd] h1] hlt] /=.
    move: h1; rewrite W64.ultE of_uintK /= => h1.
    have hle : to_uint i{hr} <= 992 by move: hd h1 => /dvdzP [q ->] /#.
    by rewrite to_uintD_small /= 1:/#; smt(dvdzD).
  by auto => /> i0; rewrite W64.ultE of_uintK /=; smt(W64.to_uint_cmp).
(* the outer loop: one coefficient per iteration *)
- while (256 - tau <= to_uint i <= 256 /\ condition_loop = (i \ult W64.of_int 256)
    /\ xof_at n (sib_iter ct (to_uint i - (256 - tau))).`3 state xof_block xof_offset
    /\ (forall b, 0 <= b < 64 - (to_uint i - (256 - tau)) =>
          signs.[b] = (sib_signs ct).[to_uint i - (256 - tau) + b])
    /\ lifts_wpoly output_challenge = (sib_iter ct (to_uint i - (256 - tau))).`1
    /\ wpoly_srng 1 1 output_challenge)
    (256 - to_uint i); last first.
  + auto=> &hr [#] hi -> hx hs hl hr /=; split.
    * rewrite hi (_ : 256 - tau - (256 - tau) = 0) 1:#ring hx hl hr /=.
      split; 1: smt().
      by move=> b rgb; rewrite hs.
    move=> cl i0 o0 s0 st0 xb xo; split; 1: by move=> [#] h1 h2 -> *; rewrite W64.ultE of_uintK /= /#.
    move=> hcl [#] h1 h2 hcl' _ _ hlo hro.
    have hi0 : to_uint i0 = 256 by move: hcl hcl'; rewrite W64.ultE of_uintK /= /#.
    by rewrite hlo hro /sampleInBall hi0 (_ : 256 - (256 - tau) = tau) 1:#ring.
  + move=> z; exlim (to_uint i) => i0.
    case @[ambient]: (256 - tau <= i0 < 256) => hi0; last first.
    * conseq (_ : false ==> _) => // &hr [hi [[[#] h1 h2 hcl _ _ _ _] hc] _].
      by apply hi0; move: hc; rewrite hcl W64.ultE of_uintK /= /#.
    pose m := i0 - (256 - tau).
    pose p0 := (sib_iter ct m).`3.
    have [hs0 [hb0 hm0]] := sib_skipP ct i0 p0 _.
    * have := hok m _; 1: smt().
      by rewrite /p0 (_ : 256 - tau + m = i0) 1:/#.
    pose P := p0 + sib_skip ct i0 p0 + 1.
    conseq (_ : ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
                /\ xof_at n p0 state xof_block xof_offset ==> _).
    * move=> &hr [hi [[[#] h1 h2 hcl hx hs hl hr] hc] hz].
      move: hx hs hl; rewrite -hi => hx hs hl.
      split; 1: by rewrite /ch_frame; split; [smt() | split; [exact hs | split; [exact hl | exact hr]]].
      by split; [smt() | exact hx].
    (* the first byte read: position p0 *)
    seq 7 : (true) 1%r 1%r 0%r 0%r
      (ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
       /\ xof_at n (p0 + 1) state xof_block xof_offset
       /\ to_uint sample_at = sib_byte ct p0
       /\ condition_resample = (i \ult sample_at)).
    * seq 3 : (ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
               /\ xof_at n p0 state xof_block xof_offset /\ to_uint xof_offset < 136).
      - seq 2 : (#pre /\ condition_refill = (W64.of_int 136 \ule xof_offset)); 1: by auto.
        if.
        + wp; call (squeeze_refillP n p0).
          skip => &hr [[[hf [hz hx]] hcr] hc]; case: hx => kb [h0 [hst [hb [hle hp]]]].
          have ho : to_uint xof_offset{hr} = 136 by move: hc; rewrite hcr W64.uleE /= /#.
          split; 1: by exists kb; rewrite hst /= h0 /= hp ho /#.
          by move=> _ r hx' /=; rewrite hf hz hx'.
        auto => &hr [[[hf [hz hx]] hcr] hc]; rewrite hf hz hx /=.
        move: hc; rewrite hcr W64.uleE /= -ltzNge => hc.
        by case: hx => kb [_ [_ [_ [hle _]]]]; smt().
      auto => &hr [hf [hz [hx hlt]]].
      have [hb hx'] := xof_read s p0 _ _ _ hx hlt.
      by rewrite /SLH64.protect_64 /= hf hz hx' hb.
    * by islossless.
    * (* the rejection loop: it stops at position P *)
      seq 1 : (ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
               /\ xof_at n P state xof_block xof_offset
               /\ to_uint sample_at = sib_byte ct (P - 1)) 1%r 1%r 0%r 0%r.
      - by conseq (: _ ==> true).
      - while (ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
               /\ condition_resample = (i \ult sample_at)
               /\ exists p, p0 < p <= P /\ xof_at n p state xof_block xof_offset
                    /\ to_uint sample_at = sib_byte ct (p - 1)
                    /\ (forall t, p0 <= t < p - 1 => i0 < sib_byte ct t))
              (P - argmax idfun (fun p => p <= P /\ (p0 < p /\ xof_at n p state xof_block xof_offset
                    /\ to_uint sample_at = sib_byte ct (p - 1)
                    /\ (forall t, p0 <= t < p - 1 => i0 < sib_byte ct t)))); last first.
        + skip => &hr [hf [hz [hx [hb hc]]]]; split.
          * rewrite hf hz hc /=; exists (p0 + 1); rewrite hx /= hb; smt().
          move=> cr sa st0 xb xo; split.
          * move=> [hf' [hz' [-> [p [rgp [hxp [hbp hmp]]]]]]] hv.
            have ge0p : 0 <= p by case: hxp => kb [h0 [_ [_ [_ ->]]]]; smt(W64.to_uint_cmp).
            have := argmax_bounded (fun p => p0 < p /\ xof_at n p st0 xb xo
                      /\ to_uint sa = sib_byte ct (p - 1)
                      /\ (forall t, p0 <= t < p - 1 => i0 < sib_byte ct t)) P p _ _; 1,2: smt().
            move=> /= [rgm [[_ [_ [hbm _]]] _]].
            have hmP : argmax idfun (fun p => p <= P /\ (p0 < p /\ xof_at n p st0 xb xo
                      /\ to_uint sa = sib_byte ct (p - 1)
                      /\ (forall t, p0 <= t < p - 1 => i0 < sib_byte ct t))) = P by smt().
            move: hbm; rewrite hmP /P (_ : p0 + sib_skip ct i0 p0 + 1 - 1 = p0 + sib_skip ct i0 p0) 1:#ring => hbm.
            by case: hf' => hi _; rewrite W64.ultE -lezNgt hbm hi.
          move=> hnc [hf' [hz' [hcr [p [rgp [hxp [hbp hmp]]]]]]].
          have hpP : p = P.
          * case: (p = P) => // hne.
            have := hm0 (p - 1 - p0) _; 1: smt().
            rewrite (_ : p0 + (p - 1 - p0) = p - 1) 1:#ring -hbp.
            by move: hnc; rewrite hcr W64.ultE; case: hf' => -> _; smt().
          by rewrite hf' hz' /= -hpP hxp hbp.
        (* one rejected byte: from the largest consistent position p *)
        move=> z'.
        exlim (argmax idfun (fun p => p <= P /\ (p0 < p /\ xof_at n p state xof_block xof_offset
                  /\ to_uint sample_at = sib_byte ct (p - 1)
                  /\ (forall t, p0 <= t < p - 1 => i0 < sib_byte ct t)))) => p.
        case @[ambient]: (p0 < p < P /\ z' = P - p /\ (forall t, p0 <= t < p => i0 < sib_byte ct t)) => hp; last first.
        + conseq (_ : false ==> _) => // &hr [hpa [[[hf [hz [hcr [q [rgq [hxq [hbq hmq]]]]]]] hg] hv]].
          apply: hp.
          have ge0q : 0 <= q by case: hxq => kb [h0 [_ [_ [_ ->]]]]; smt(W64.to_uint_cmp).
          have := argmax_bounded (fun p => p0 < p /\ xof_at n p state{hr} xof_block{hr} xof_offset{hr}
                    /\ to_uint sample_at{hr} = sib_byte ct (p - 1)
                    /\ (forall t, p0 <= t < p - 1 => i0 < sib_byte ct t)) P q _ _; 1,2: smt().
          rewrite /= -hpa => [[rgm [[hm1 [_ [hbm hmm]]] _]]].
          have hgm : i0 < sib_byte ct (p - 1).
          * by rewrite -hbm; move: hg; rewrite hcr W64.ultE; case: hf => -> _.
          split; 2: split; 1: smt().
          * by rewrite -hv -hpa.
          by move=> t rgt; case: (t = p - 1) => [->//|ne]; apply hmm => /#.
        conseq (_ : ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
                    /\ xof_at n p state xof_block xof_offset ==> _).
        + move=> &hr [hpa [[[hf [hz [hcr [q [rgq [hxq [hbq hmq]]]]]]] hg] hv]].
          have ge0q : 0 <= q by case: hxq => kb [h0 [_ [_ [_ ->]]]]; smt(W64.to_uint_cmp).
          have := argmax_bounded (fun p => p0 < p /\ xof_at n p state{hr} xof_block{hr} xof_offset{hr}
                    /\ to_uint sample_at{hr} = sib_byte ct (p - 1)
                    /\ (forall t, p0 <= t < p - 1 => i0 < sib_byte ct t)) P q _ _; 1,2: smt().
          rewrite /= -hpa => [[rgm [[hm1 [hxm _]] _]]].
          by rewrite hf hz hxm.
        seq 7 : (true) 1%r 1%r 0%r 0%r
          (ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
           /\ xof_at n (p + 1) state xof_block xof_offset
           /\ to_uint sample_at = sib_byte ct p
           /\ condition_resample = (i \ult sample_at)).
        + seq 3 : (ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
                   /\ xof_at n p state xof_block xof_offset /\ to_uint xof_offset < 136).
          * seq 2 : (#pre /\ condition_refill = (W64.of_int 136 \ule xof_offset)); 1: by auto.
            if.
            - wp; call (squeeze_refillP n p).
              skip => &hr [[[hf [hz hx]] hcr] hc]; case: hx => kb [h0 [hst [hb [hle hp']]]].
              have ho : to_uint xof_offset{hr} = 136 by move: hc; rewrite hcr W64.uleE /= /#.
              split; 1: by exists kb; rewrite hst /= h0 /= hp' ho /#.
              by move=> _ r hx' /=; rewrite hf hz hx'.
            auto => &hr [[[hf [hz hx]] hcr] hc]; rewrite hf hz hx /=.
            move: hc; rewrite hcr W64.uleE /= -ltzNge => hc.
            by case: hx => kb [_ [_ [_ [hle _]]]]; smt().
          auto => &hr [hf [hz [hx hlt]]].
          have [hb hx'] := xof_read s p _ _ _ hx hlt.
          by rewrite /SLH64.protect_64 /= hf hz hx' hb.
        + by islossless.
        + skip => &hr [hf [hz [hx [hb hc]]]]; split.
          * rewrite hf hz hc /=; exists (p + 1); rewrite hx hb /=; smt().
          have ge0p : 0 <= p + 1 by case: hx => kb [h0 [_ [_ [_ ->]]]]; smt(W64.to_uint_cmp).
          have := argmax_bounded (fun p => p0 < p /\ xof_at n p state{hr} xof_block{hr} xof_offset{hr}
                    /\ to_uint sample_at{hr} = sib_byte ct (p - 1)
                    /\ (forall t, p0 <= t < p - 1 => i0 < sib_byte ct t)) P (p + 1) _ _; 1: smt().
          * by rewrite /= hx hb /=; smt().
          by move=> /= [_ [_ hle]]; smt().
        + by hoare; conseq (: _ ==> true).
        by [].
      - (* write the coefficient, consume one sign bit *)
        auto => &hr [[hi [hs [hl hr]]] [hz [hx hb]]].
        have hi1 : to_uint (i{hr} + W64.one) = i0 + 1 by rewrite to_uintD_small /= hi /#.
        have hm1 : i0 + 1 - (256 - tau) = m + 1 by rewrite /m; ring.
        have hst : sib_iter ct (m + 1) = sib_step ct (sib_iter ct m) i0.
        + by rewrite sib_iterS 1:/# (_ : 256 - tau + m = i0) 1:/#.
        pose j := sib_byte ct (p0 + sib_skip ct i0 p0).
        have hj : to_uint sample_at{hr} = j by rewrite hb /P /j; congr; ring.
        have rgj : 0 <= j < 256.
        + by rewrite /j /sib_byte; move: (nth witness _ _) => w; have /= := W8.to_uint_cmp w.
        rewrite /= hi1 hm1 hst /sib_step /= -/p0 -/j hi hj.
        split; 2: smt().
        do 2! (split; 1: smt()).
        split.
        + move=> b rgb; rewrite shr1_bitE 1:/# hs 1:/#; congr; rewrite /m; ring.
        have := sign_coeffE signs{hr}; rewrite /= => hsg; rewrite hsg.
        have hs0' : signs{hr}.[0] = (sib_signs ct).[i0 + tau - 256].
        + by rewrite hs 1:/#; congr; ring.
        have hcj : incoeff (to_sint output_challenge{hr}.[j]) = (sib_iter ct m).`1.[j].
        + by rewrite /m -hl /lifts_wpoly Array256.mapiE.
        split.
        + rewrite !lifts_wpoly_set // 1:/# hcj /m -hl -/m hs0'.
          case: ((sib_signs ct).[i0 + tau - 256]) => _.
          * by rewrite W32.of_sintK /smod.
          by rewrite W32.to_sintE /smod.
        apply srng_set => //; 2: by case: (signs{hr}.[0]) => _; [rewrite W32.of_sintK /smod | rewrite W32.to_sintE /smod].
        apply srng_set => //; 1: smt().
        by move: hr; rewrite /wpoly_srng Array256.allP => hr; have /= := hr j rgj.
      - (* the rejection loop again, as a Hoare triple, for the zero-mass side *)
        hoare.
        while (ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
               /\ condition_resample = (i \ult sample_at)
               /\ exists p, p0 < p <= P /\ xof_at n p state xof_block xof_offset
                    /\ to_uint sample_at = sib_byte ct (p - 1)
                    /\ (forall t, p0 <= t < p - 1 => i0 < sib_byte ct t)).
        + conseq (_ : exists p, ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
                     /\ (p0 < p < P /\ (forall t, p0 <= t < p => i0 < sib_byte ct t))
                     /\ xof_at n p state xof_block xof_offset ==> _).
          * move=> &hr [[hf [hz [hcr [p [rgp [hxp [hbp hmp]]]]]]] hg]; exists p.
            have hgp : i0 < sib_byte ct (p - 1).
            - by rewrite -hbp; move: hg; rewrite hcr W64.ultE; case: hf => -> _.
            rewrite hf hz hxp /=; split; 2: by move=> t rgt; case: (t = p - 1) => [->//|ne]; apply hmp => /#.
            split; 1: smt().
            move=> _; rewrite ltz_def; split; 2: smt().
            apply/negP => heq; move: hgp; rewrite -heq /P.
            by rewrite (_ : p0 + sib_skip ct i0 p0 + 1 - 1 = p0 + sib_skip ct i0 p0) 1:#ring; smt().
          elim* => p.
          seq 3 : (ch_frame ct i0 i signs output_challenge /\ 256 - to_uint i = z
                   /\ (p0 < p < P /\ (forall t, p0 <= t < p => i0 < sib_byte ct t))
                   /\ xof_at n p state xof_block xof_offset /\ to_uint xof_offset < 136).
          * seq 2 : (#pre /\ condition_refill = (W64.of_int 136 \ule xof_offset)); 1: by auto.
            if.
            - wp; call (squeeze_refillP n p).
              skip => &hr [[[hf [hz [hp hx]]] hcr] hc]; case: hx => kb [h0 [hst [hb [hle hp']]]].
              have ho : to_uint xof_offset{hr} = 136 by move: hc; rewrite hcr W64.uleE /= /#.
              split; 1: by exists kb; rewrite hst /= h0 /= hp' ho /#.
              by move=> _ r hx' /=; rewrite hf hz hp hx'.
            auto => &hr [[[hf [hz [hp hx]]] hcr] hc]; rewrite hf hz hp hx /=.
            move: hc; rewrite hcr W64.uleE /= -ltzNge => hc.
            by case: hx => kb [_ [_ [_ [hle _]]]]; smt().
          auto => &hr [hf [hz [[rgp hmp] [hx hlt]]]].
          have [hb hx'] := xof_read s p _ _ _ hx hlt.
          rewrite /SLH64.protect_64 /= hf hz /=; exists (p + 1); rewrite hx' hb /=; smt().
        skip => &hr [hf [hz [hx [hb hc]]]]; split.
        + rewrite hf hz hc /=; exists (p0 + 1); rewrite hx /= hb; smt().
        move=> cr sa st0 xb xo hnc [hf' [hz' [hcr [p [rgp [hxp [hbp hmp]]]]]]].
        have hpP : p = P.
        + case: (p = P) => // hne.
          have := hm0 (p - 1 - p0) _; 1: smt().
          rewrite (_ : p0 + (p - 1 - p0) = p - 1) 1:#ring -hbp.
          by move: hnc; rewrite hcr W64.ultE; case: hf' => -> _; smt().
        by rewrite hf' hz' /= -hpP hxp hbp.
      - by [].
    * by hoare; conseq (: _ ==> true).
    by [].
- by hoare; conseq (: _ ==> true).
by [].
qed.
