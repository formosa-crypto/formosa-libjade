(* -------------------------------------------------------------------- *)
(* The matrix sampler of one polynomial against the specification's    *)
(* parse: the buffer-window rejection filter, and the fill loop over    *)
(* the SHAKE128 stream of the seed.                                     *)
(* -------------------------------------------------------------------- *)
require import AllCore IntDiv List IntMin.

from Jasmin require import JModel.

from JazzEC require import WArray8 WArray32 Array8 Array25 Array32 Array168 Array256 Array536.
from JazzEC require import Array1024 Array2048 Array2144.

require import MLKEM_W16_Rep MLKEMFCLib AVX2_Ops.
require import EclibExtra JWordList.
require import Agree Rejstream.
from CryptoSpecs require import Keccak1600_Spec.
require import MLKEM_keccak_avx2.
require import Mlkem_filters_bridge.

from JazzEC require import Jkem_avx2.

import GFq Rq Sampling Symmetric Correctness.

lemma take_rejection16_done n buf buf_o bo:
 0 <= buf_o <= bo <= 504 =>
 3 %| buf_o =>
 3 %| bo =>
 size (take n (rejection16 (buf_subl buf buf_o bo))) = n =>
 take n (rejection16 (buf_subl buf buf_o bo))
 = take n (rejection16 (buf_subl buf buf_o 504)).
proof.
move=> H H1 H2 /size_takel' [Hsz1].
rewrite size_map => Hsz2.
rewrite -(buf_subl_cat _ _ bo 504) 1:/# /rejection16 rejection_cat.
 by rewrite size_buf_subl /#.
rewrite -map_take eq_sym -map_take; congr.
by rewrite take_cat' ifT.
qed.

lemma pack32_sample_load_shuffle:
 pack32 (to_list sample_load_shuffle)
 = get256_direct ((init8 ("_.[_]" sample_load_shuffle)))%WArray32 0.
proof.
rewrite get256E; congr.
apply W32u8.Pack.all_eqP.
by rewrite of_listK 1:/# /all_eq /= !initiE /#.
qed.

lemma size_rejection16_le buf bstart bend1 bend2:
 3 %| bstart =>
 3 %| bend1 =>
 3 %| bend2 =>
 0 <= bstart <= bend1 <= bend2 <= 536 =>
 size (rejection16 (buf_subl buf bstart bend1))
 <= size (rejection16 (buf_subl buf bstart bend2)).
proof.
move=> H1 H2 H3 H.
rewrite /rejection16 !size_map.
rewrite -(buf_subl_cat _ _ bend1 bend2) 1:/#.
rewrite bytes2coeffs_cat.
 by rewrite size_buf_subl /#.
by rewrite filter_cat size_cat; smt(size_ge0).
qed.

lemma rejection16_cat l1 l2:
 3 %| size l1 =>
 rejection16 (l1++l2) = rejection16 l1 ++ rejection16 l2.
proof.
by move=> H; rewrite /rejection16 rejection_cat 1:// map_cat.
qed.

hoare gen_matrix_buf_rejection_h _pol _ctr _buf _buf_offset:
 Jkem_avx2.M._gen_matrix_buf_rejection
 : counter = _ctr
   /\ pol = _pol
   /\ buf = _buf
   /\ buf_offset = _buf_offset
   /\ 0 <= to_uint counter < 256
   /\ (to_uint buf_offset = 0 \/ to_uint buf_offset = 2*168)
   ==>
   let l = take (256-to_uint _ctr) (rejection16 (buf_subl _buf (to_uint _buf_offset) 504))
   in plist res.`1 (to_uint _ctr + size l)
      = plist _pol (to_uint _ctr) ++ l
      /\ to_uint _ctr + size l = min 256 (to_uint res.`2).
proof.
proc; simplify.
while ( buf=_buf /\ 24 %| to_uint buf_offset /\ 3 %| to_uint _buf_offset /\
        0 <= to_uint _buf_offset <= to_uint buf_offset <= 504 /\
        0 <= to_uint _ctr < 256 /\
        to_uint _ctr <= to_uint counter /\
        auxdata_ok load_shuffle mask bounds ones sst /\
        (plist pol (min 256 (to_uint counter))
         = plist _pol (to_uint _ctr)
           ++ take (256-to_uint _ctr) (rejection16 (buf_subl _buf (to_uint _buf_offset) (to_uint buf_offset)))
        ) /\
        (condition_loop <=> to_uint buf_offset <= 504-24)).
 wp.
 seq 2: (#{/~condition_loop}pre /\ to_uint buf_offset <= 504 - 24 /\ (condition_loop <=> to_uint counter < 256)).
 + by auto => /> &m *; rewrite ultE.
 if; last first.
 + auto => /> &m Hdvd1 Hdvd2 Ho1 Ho2 Ho3 Hctr1 Hctr2 Hctr3 H Hcond1 Hcond2; split; first smt().
   have : size (take (256 - to_uint _ctr) (rejection16 (buf_subl _buf (to_uint _buf_offset) (to_uint buf_offset{m})))) = 256 - to_uint _ctr.
   * have : size (plist pol{m} (min 256 (to_uint counter{m}))) = 256 by rewrite size_plist; smt().
     rewrite H size_cat size_plist; smt().
   rewrite size_takel' => - [] _ Hsz.
   move: H; rewrite take_rejection16_done 1, 3:/#; first by [].
   * rewrite size_take; first smt().
     by rewrite -/(min _ _) lez_minl.
   exact.
 wp; ecall (buf_rejection_filter24_h pol counter buf buf_offset).
 auto => &m /> Hdvd1 Hdvd2 Ho1 Ho2 Ho3 Hctr1 Hctr2 Hctr3 H Hcond1 Hcond2.
 have Hsz: min 256 (to_uint counter{m}) = to_uint _ctr + min (256-to_uint _ctr) (size (rejection16 (buf_subl buf{m} (to_uint _buf_offset) (to_uint buf_offset{m})))).
  rewrite -(size_plist pol{m} (min 256 (to_uint counter{m}))) 1:/# H size_cat size_plist 1:/#; congr.
  by rewrite size_take_min /#.
 move: H; rewrite take_oversize 1:/# lez_minr 1:/# => H; split; first smt(). 
 move=> Hoff Hcounter [p c' ms'] /= /> Hstep.
 rewrite !to_uintD_small 1:/# !of_uintK=> Hc'; split; first smt().
 split.
  split; first by rewrite !modz_small 1:// /= /#.
  by move=> *; rewrite !modz_small 1:// /= /#.
 split; first smt(size_ge0). 
 rewrite modz_small; first smt(size_ge0 size_take_min).
 split; last rewrite ultE to_uintD_small /#.
 rewrite Hc'.
 rewrite Hstep H -catA; congr.
 rewrite -(buf_subl_cat _ (to_uint _buf_offset) (to_uint buf_offset{m}) (to_uint buf_offset{m} + 24)) 1:/#.
 rewrite rejection16_cat.
  by rewrite size_buf_subl /#.
 by rewrite take_catr 1:/#; congr; congr; smt().
wp.
while ( buf=_buf /\ 24 %| to_uint saved_buf_offset /\ 3 %| to_uint _buf_offset /\
        0 <= to_uint _buf_offset <= to_uint saved_buf_offset <= 504 /\
        0 <= to_uint _ctr <= to_uint counter <= 256 /\
        auxdata_ok load_shuffle mask bounds ones sst /\
        plist pol (min 256 (to_uint counter))
        = plist _pol (to_uint _ctr)
           ++ rejection16 (buf_subl _buf (to_uint _buf_offset) (to_uint saved_buf_offset)) /\
        to_uint _ctr + size (rejection16 (buf_subl _buf (to_uint _buf_offset) (to_uint saved_buf_offset))) <= 256 /\
        (condition_loop <=> to_uint buf_offset <= 504-48) /\
        (to_uint buf_offset <= 504 - 48 => saved_buf_offset = buf_offset)).
 seq 2: (#{/~condition_loop}pre /\ to_uint buf_offset <= 504 - 48 /\ saved_buf_offset = buf_offset /\ (condition_loop <=> to_uint counter <= 256 - 32)).
 + auto => &m /> *; rewrite ultE /#.
 if; last by auto.
 wp; ecall (buf_rejection_filter48_h pol counter buf buf_offset).
 auto; rewrite /protect_64 => &m />.
 move => Hdvd1 Hdvd2 Ho1 Ho2 Ho3 Hctr1 Hctr2 Hctr3 + Hbo Hctr4 Hbo4.
 have -> : (min 256 (to_uint counter{m})) = to_uint counter{m} by smt().
 move => H.
 split;1:smt().
 move => ? [p c'] /= /> Hstep. 
 rewrite !to_uintD_small 1:/# !of_uintK; split; first smt().
 split;1: by rewrite !modz_small 1:// /= /#.
 pose R:= rejection16 _.
 have ?: 0 <= size R <= 32.
  rewrite size_map; split; first smt(size_ge0).
  move=> _; apply (size_rejection_le' 48); 1:done => /=.
  by rewrite /buf_subl !size_take 1:/# !size_drop /#.
 rewrite !modz_small 1..2:/#.
  have -> : (min 256 (to_uint counter{m} + size R)) = to_uint counter{m} + size R by smt().
 split; first smt().
 rewrite -andaE; split.
  rewrite -(buf_subl_cat _ (to_uint _buf_offset) (to_uint buf_offset{m}) (to_uint buf_offset{m} + 48)) 1:/#.
  rewrite Hstep H -catA; congr.
  rewrite rejection16_cat 2://.
  by rewrite size_buf_subl /#.
 move => HH. 
 have : size (plist p (to_uint counter{m} + size R)) <= 256.
  by rewrite size_plist /#.
 by rewrite HH size_cat size_plist 1:/# ultE to_uintD_small /#.
auto; rewrite /protect_64 => &m /> Hctr1 Hctr2 Hbo; split.
 split; first smt().
 split; first smt().
 split; first smt().
 split; first smt().
 split; 1:  by rewrite pack32_sample_load_shuffle.
 have -> : (min 256 (to_uint counter{m})) = to_uint counter{m} by smt().
 split; 1: by rewrite buf_subl0 1:/# /rejection16 rejection0 cats0.
 split; last by rewrite ultE /#.
 by rewrite buf_subl0 1:/# /rejection16 rejection0 /#.
move => buf_o cond ctr pol saved_buf_offset Hcond Hdvd1 Hdvd2 Hbo1 Hbo2 Hbo3 Hctr3 Hctr4 _ H Hsz Hterm; split.
 by rewrite ultE take_oversize /#.
move=> buf_o2 cond2 ctr2 pol2 HC2 Hdvd3 Hbo4 Hbo5 Hctr5 HH.
case: (to_uint ctr2 < 256) => /= C1.
 move=> C2; move: HH; have ->: to_uint buf_o2 = 504 by smt().
 rewrite lez_minr 1:/#.
 move => HH; rewrite andbC -andaE; split.
  rewrite -(size_plist pol2 (to_uint ctr2)) 1:/# HH.
  by rewrite size_cat size_plist 1:/#.
 by move => E; move: HH; rewrite -E => ->.
move: HH.
have E: min 256 (to_uint ctr2) = 256 by smt().
rewrite !E => HH.
rewrite andbC -andaE.
have HHsz: 256 = to_uint counter{m} + min (256 - to_uint counter{m})
      (size (rejection16 (buf_subl buf{m} (to_uint buf_offset{m}) (to_uint buf_o2)))).
 rewrite -(size_plist pol2 256) 1:/#.
 by rewrite HH size_cat size_plist 1:/# size_take_min /#.
rewrite size_take_min 1:/#.
move => _.
split; first smt(size_rejection16_le).
move => ->; rewrite HH; congr.
apply take_rejection16_done; first 3 smt().
by rewrite size_take_min /#.
qed.

lemma gen_matrix_buf_rejection_ll:
 islossless Jkem_avx2.M._gen_matrix_buf_rejection.
proof.
proc.
seq 13: (true)=> //.
 wp; while ((condition_loop
            <=> to_uint buf_offset <= 504-48) /\ (condition_loop => saved_buf_offset = buf_offset))
           (504 - to_uint buf_offset).
  move=> z.
  exlim buf_offset => _buf_offset.
  seq 2: (#{~condition_loop} pre /\ saved_buf_offset = buf_offset /\ to_uint buf_offset <= 504 - 48) => //.
  - by auto => &m />.
  - if; last by auto => &m /> /#.
    wp; call buf_rejection_filter48_ll; auto => &m /> H _.
    rewrite ultE to_uintD_small /#.
  by hoare; auto => />.
 auto => &m />.
 rewrite ultE /#.
 exlim buf_offset => _buf_offset.
 exlim counter => _counter.
while (condition_loop
       <=> to_uint buf_offset <= 504-24)
      (504 - to_uint buf_offset).
 move=> z.
 seq 2: (#{~condition_loop}pre /\ to_uint buf_offset <= 504 - 24) => //.
 - auto.
 - if; last auto => &m /> /#.
    wp; call buf_rejection_filter24_ll; auto => &m /> H _.
    rewrite /protect_64 ultE to_uintD_small /#.
 by hoare; auto.
auto => &m />.
rewrite ultE /#.
qed.

phoare gen_matrix_buf_rejection_ph _pol _ctr _buf _buf_offset:
 [ Jkem_avx2.M._gen_matrix_buf_rejection
 : counter = _ctr
   /\ pol = _pol
   /\ buf = _buf
   /\ buf_offset = _buf_offset
   /\ 0 <= to_uint counter < 256
   /\ (to_uint buf_offset = 0 \/ to_uint buf_offset = 2*168)
   ==>
   let l = take (256-to_uint _ctr) (rejection16 (buf_subl _buf (to_uint _buf_offset) 504))
   in plist res.`1 (to_uint _ctr + size l)
      = plist _pol (to_uint _ctr) ++ l
      /\ to_uint _ctr + size l = min 256 (to_uint res.`2)
 ] = 1%r.
proof.
by conseq gen_matrix_buf_rejection_ll (gen_matrix_buf_rejection_h _pol _ctr _buf _buf_offset).
qed.

(* -------------------------------------------------------------------- *)
(* The fill loop against the stream: after k blocks, the buffer holds   *)
(* the sponge state permuted k times, and the polynomial the accepted   *)
(* prefix of the first k blocks.                                        *)
op unlift_polyu (a : poly) = Array256.init (fun i => W16.of_int (Zq.asint a.[i])).

lemma unlift_polyuE a:
 unlift_polyu a = Array256.map (fun x => W16.of_int (Zq.asint x)) a.
proof. by apply Array256.ext_eq => i Hi; rewrite initiE //= mapiE. qed.

op fill_inv seed (k : int) (buf : W8.t Array536.t) (pol : W16.t Array256.t) (ctr : W64.t) =
     3 <= k
  /\ sub buf (2*168) 200
     = state2bytes (FIPS202_SHA3_Spec.st_i (SHAKE128_ABSORB (rejection_seed seed)) k)
  /\ min 256 (to_uint ctr) = min 256 (size (rejection (expand_seed seed k)))
  /\ plist pol (min 256 (to_uint ctr)) = take 256 (rejection16 (expand_seed seed k)).

(* the in-place permutation of the stored state squeezes the next block *)
lemma next_blockE seed k (buf buf' : W8.t Array536.t) :
  0 <= k =>
  sub buf (2*168) 200
  = state2bytes (FIPS202_SHA3_Spec.st_i (SHAKE128_ABSORB (rejection_seed seed)) k) =>
  sub buf' (2*168) 200 = state2bytes (keccak_f1600_op (bytes2state (sub buf (2*168) 200))) =>
     sub buf' (2*168) 200
     = state2bytes (FIPS202_SHA3_Spec.st_i (SHAKE128_ABSORB (rejection_seed seed)) (k + 1))
  /\ buf_subl buf' (2*168) 504
     = squeezestate_i c256_r8 (SHAKE128_ABSORB (rejection_seed seed)) k.
proof.
move=> ge0k hb hr; rewrite hb state2bytesK in hr.
have e : keccak_f1600_op (FIPS202_SHA3_Spec.st_i (SHAKE128_ABSORB (rejection_seed seed)) k)
         = FIPS202_SHA3_Spec.st_i (SHAKE128_ABSORB (rejection_seed seed)) (k + 1).
- by rewrite /FIPS202_SHA3_Spec.st_i iterS.
rewrite -e -hr; split => //.
rewrite buf_sublE 1:// /squeezestate_i /squeezestate /c256_r8 -e -hr /=.
by rewrite /sub take_mkseq.
qed.

(* a filtered block extends the accepted prefix                         *)
lemma fill_stepE (ctr rc : int) (pol rp : W16.t Array256.t) (ek blk : W8.t list) :
  3 %| size ek => 0 <= ctr < 256 =>
  min 256 ctr = min 256 (size (rejection ek)) =>
  plist pol ctr = take 256 (rejection16 ek) =>
  plist rp (ctr + size (take (256 - ctr) (rejection16 blk)))
  = plist pol ctr ++ take (256 - ctr) (rejection16 blk) =>
  ctr + size (take (256 - ctr) (rejection16 blk)) = min 256 rc =>
     min 256 rc = min 256 (size (rejection (ek ++ blk)))
  /\ plist rp (min 256 rc) = take 256 (rejection16 (ek ++ blk)).
proof.
move=> h3 rgc hc hp hrp hrc.
have es : size (rejection16 ek) = ctr by rewrite /rejection16 size_map /#.
rewrite rejection16_cat // rejection_cat // size_cat -hrc hrp hp.
rewrite (take_cat 256 (rejection16 ek)) es ifF 1:/# (take_oversize 256 (rejection16 ek)) 1:/#.
split => //; rewrite size_take 1:/#; move: es; rewrite /rejection16 !size_map; smt(size_ge0).
qed.

(* The buffer holds three squeezed blocks and the state after them.     *)
(* The stored state does not determine the block count, so the loop     *)
(* variant is the largest count up to needed_blocks consistent with it. *)
lemma fill_polynomial_ph _rho _j _i :
 phoare [ Jkem_avx2.M.__gen_matrix_fill_polynomial
        : buf_subl buf 0 504 = expand_seed (_rho, (_j, _i)) 3
          /\ sub buf (2*168) 200
             = state2bytes (FIPS202_SHA3_Spec.st_i
                 (SHAKE128_ABSORB (rejection_seed (_rho, (_j, _i)))) 3)
        ==> res.`1 = unlift_polyu (parse _rho _j _i) ] = 1%r.
proof.
pose seed := (_rho, (_j, _i)).
pose K := needed_blocks seed.
have geK3 : 3 <= K by apply needed_blocks_ge3.
proc.
while (to_uint buf_offset = 2*168 /\ exists k, k <= K /\ fill_inv seed k buf pol counter)
      (K - argmax idfun (fun k => k <= K /\ fill_inv seed k buf pol counter)).
- move=> z.
  exlim (argmax idfun (fun k => k <= K /\ fill_inv seed k buf pol counter)) => m.
  conseq (_ : to_uint buf_offset = 2*168 /\ fill_inv seed m buf pol counter
              /\ m < K /\ K - m = z /\ to_uint counter < 256 ==> _).
  + move=> &hr [-> [[[ho [k [hk hinv]]] hc] hz]].
    have := argmax_bounded (fun k => fill_inv seed k buf{hr} pol{hr} counter{hr}) K k _ hinv.
    - by case: hinv => /#.
    move=> /= [rgm [hm _]]; rewrite ho /=; split; 1: exact hm.
    rewrite ultE /= in hc; split; 2: smt().
    case: hm => [ge3m [_ [hcm _]]].
    pose a := argmax idfun (fun k0 => k0 <= K /\ fill_inv seed k0 buf{hr} pol{hr} counter{hr}).
    by have := lt_needed_blocks seed a _ _; smt().
  ecall (gen_matrix_buf_rejection_ph pol counter buf buf_offset).
  ecall (shake128_next_state_ph buf).
  skip => &hr |> ho [ge3m [hst [hcm hpm]]] ltmK hc buf1 hb1.
  have [hst1 hblk] := next_blockE seed m buf{hr} buf1 _ hst hb1; 1: smt().
  split; 1: smt(W64.to_uint_cmp).
  move=> ge0c [rp rc] /= hrp hrc.
  rewrite ho (_ : 336 = 2 * 168) // hblk in hrp.
  rewrite ho (_ : 336 = 2 * 168) // hblk in hrc.
  have hpm' : plist pol{hr} (to_uint counter{hr}) = take 256 (rejection16 (expand_seed seed m)).
  - by move: hpm; rewrite (_ : min 256 (to_uint counter{hr}) = to_uint counter{hr}) 1:/#.
  have [hcm1 hpm1] := fill_stepE (to_uint counter{hr}) (to_uint rc) pol{hr} rp
                        (expand_seed seed m)
                        (squeezestate_i c256_r8 (SHAKE128_ABSORB (rejection_seed seed)) m)
                        _ _ hcm hpm' hrp hrc; 2: smt().
  - by rewrite size_expand_seed 1:/# dvdz_mulr.
  rewrite -expand_seedS 1:/# in hcm1; rewrite -expand_seedS 1:/# in hpm1.
  have hinv : fill_inv seed (m + 1) buf1 rp rc.
  - by split; [smt() | split; [exact hst1 | split; [exact hcm1 | exact hpm1]]].
  split; 1: by exists (m + 1); split; [smt() | exact hinv].
  have := argmax_bounded (fun k => fill_inv seed k buf1 rp rc) K (m + 1) _ hinv; 1: smt().
  by move=> /= /#.
- by exlim buf => b; call (shake128_next_state_ph b); auto.
wp; ecall (gen_matrix_buf_rejection_ph pol counter buf buf_offset); auto => &hr |> hb hst.
move=> [rp rc] /=; rewrite plist0 /= hb => hrp hrc.
split.
- exists 3; split; 1: smt().
  split => //; split; 1: exact hst.
  have hsz : size (take 256 (rejection16 (expand_seed seed 3)))
             = min 256 (size (rejection (expand_seed seed 3))).
  - by rewrite size_take // /rejection16 size_map /#.
  by rewrite -hrc hsz /= -hsz hrp.
move=> b0 c0 p0; split.
- move=> k hk hinv hv.
  have := argmax_bounded (fun k => fill_inv seed k b0 p0 c0) K k _ hinv; 1: by case: hinv => /#.
  move=> /= [rgm [hm _]].
  have hK : argmax idfun (fun k => k <= K /\ fill_inv seed k b0 p0 c0) = K by smt().
  move: hm; rewrite hK => -[_ [_ [hc _]]].
  by have := needed_blocksP seed; rewrite /enough_blocks ultE /= => h; smt().
rewrite ultE /= => hc k hk [ge3k [_ [hcm hpm]]].
have hsz : 256 <= size (rejection (expand_seed seed k)) by smt().
rewrite (_ : min 256 (to_uint c0) = 256) 1:/# in hpm.
apply Array256.ext_eq => idx rgidx.
rewrite /unlift_polyu initiE //= (parseE _ _ _ k) 1..3:/#.
have := congr1 (fun l => nth witness l idx) _ _ hpm => /=.
rewrite /plist nth_mkseq //= nth_take 1,2:/# /rejection16 (nth_map witness) 1:/# /=.
by move=> h; exact h.
qed.

(* -------------------------------------------------------------------- *)
(* Four polynomials from one 4-way SHAKE128: lane k samples the seed    *)
(* given by bytes 2k and 2k+1 of the index word.                        *)
op pack4poly ['a] (ps: 'a Array256.t * 'a Array256.t * 'a Array256.t * 'a Array256.t) =
 Array1024.of_list witness (to_list ps.`1 ++ to_list ps.`2 ++ to_list ps.`3 ++ to_list ps.`4).

lemma pack4polyP ['a] (p0 p1 p2 p3 : 'a Array256.t) (x : 'a Array1024.t) :
  (forall i, 0 <= i < 1024 =>
     x.[i] = if i < 256 then p0.[i] else if i < 512 then p1.[i - 256]
             else if i < 768 then p2.[i - 512] else p3.[i - 768]) =>
  x = pack4poly (p0, p1, p2, p3).
proof.
move=> hx; apply Array1024.ext_eq => i rgi; rewrite hx // /pack4poly get_of_list //=.
rewrite -!catA !nth_cat !size_to_list.
by case: (i < 256) => h0; [|case: (i < 512) => h1; [|case: (i < 768) => h2]];
   rewrite /= ?get_to_list //; smt().
qed.

lemma squeeze3E seed :
  SHAKE128_SQUEEZE (3*168) (SHAKE128_ABSORB (rejection_seed seed)) = expand_seed seed 3.
proof.
rewrite /SQUEEZE1600 /expand_seed /c256_r8 /= take_oversize //.
by rewrite size_squeezeblocks.
qed.

abbrev idx_of (w : W64.t) =
  Array8.init (WArray8.get8 (WArray8.set64_direct
    (WArray8.init8 ("_.[_]" witness<:W8.t Array8.t>)) 0 w)).

lemma idx_subE (a : W8.t Array8.t) (w : W64.t) (k : int) :
  0 <= k < 4 =>
  sub (Array8.init (WArray8.get8 (WArray8.set64_direct (WArray8.init8 ("_.[_]" a)) 0 w)))
      (2 * k) 2
  = [w \bits8 (2 * k); w \bits8 (2 * k + 1)].
proof.
move=> rgk; rewrite /sub /mkseq -iotaredE /= !Array8.initiE 1,2:/# /=.
by rewrite !ifT 1,2:/#.
qed.

(* a lane that holds the squeezed buffer of a seed meets fill_polynomial *)
lemma lane_okP (b : W8.t Array2144.t) (x : W8.t Array536.t) off seed :
  0 <= off => off + 536 <= 2144 =>
  (forall i, 0 <= i < 536 => x.[i] = b.[off + i]) =>
  sub b off 504 = SHAKE128_SQUEEZE (3*168) (SHAKE128_ABSORB (rejection_seed seed)) =>
  sub b (off + 2*168) 200
  = state2bytes (FIPS202_SHA3_Spec.st_i (SHAKE128_ABSORB (rejection_seed seed)) 3) =>
     buf_subl x 0 504 = expand_seed seed 3
  /\ sub x (2*168) 200
     = state2bytes (FIPS202_SHA3_Spec.st_i (SHAKE128_ABSORB (rejection_seed seed)) 3).
proof.
move=> ge0o hlo hx hs hst; rewrite -squeeze3E -hs -hst buf_sublE 1:// /=.
by split; rewrite /sub; apply eq_in_mkseq => i rgi /=; rewrite hx /#.
qed.

abbrev lane_poly (rho : W8.t Array32.t) (w : W64.t) (k : int) =
  unlift_polyu (parse rho (w \bits8 (2*k)) (w \bits8 (2*k+1))).

(* the index table is set-specific: its read is a hypothesis            *)
lemma sample_four_ph (_rho : W8.t Array32.t) (_b _tt w : W64.t) :
  phoare [ Jkem_avx2.M.gen_matrix_get_indexes : arg = (_b, _tt) ==> res = w ] = 1%r =>
  phoare [ Jkem_avx2.M._gen_matrix_sample_four_polynomials
         : rho = _rho /\ pos_entry = _b /\ transposed = _tt
           ==> res.`1 = pack4poly (lane_poly _rho w 0, lane_poly _rho w 1,
                                   lane_poly _rho w 2, lane_poly _rho w 3) ] = 1%r.
proof.
move=> hidx; proc.
wp; call (fill_polynomial_ph _rho (w \bits8 6) (w \bits8 7)).
wp; call (fill_polynomial_ph _rho (w \bits8 4) (w \bits8 5)).
wp; call (fill_polynomial_ph _rho (w \bits8 2) (w \bits8 3)).
wp; call (fill_polynomial_ph _rho (w \bits8 0) (w \bits8 1)).
wp; call (shake128x4_squeeze3blocks_ph
            (SHAKE128_ABSORB (rejection_seed (_rho, (w \bits8 0, w \bits8 1))))
            (SHAKE128_ABSORB (rejection_seed (_rho, (w \bits8 2, w \bits8 3))))
            (SHAKE128_ABSORB (rejection_seed (_rho, (w \bits8 4, w \bits8 5))))
            (SHAKE128_ABSORB (rejection_seed (_rho, (w \bits8 6, w \bits8 7))))).
wp; call (shake128x4_absorb_A32_A2_ph _rho (idx_of w)).
wp; call hidx; auto => &hr |> /=.
have hpp : forall (x : W8.t Array2144.t) ms, SLH64.protect_ptr x ms = x.
- by rewrite /SLH64.protect_ptr.
have /= i0 := idx_subE witness w 0 _; 1: done.
have /= i1 := idx_subE witness w 1 _; 1: done.
have /= i2 := idx_subE witness w 2 _; 1: done.
have /= i3 := idx_subE witness w 3 _; 1: done.
rewrite i0 i1 i2 i3 => st hst; split; 1: exact hst.
move=> _ [st' b] /= hb0 hb1 hb2 hb3 hs0 hs1 hs2 hs3.
split; 1: by apply (lane_okP b _ 0) => // i rgi; rewrite initiE.
move=> _ _ [p0 b0] /= hp0; rewrite !hpp.
split.
- apply (lane_okP b _ 536) => //= i rgi.
  by rewrite Array536.initiE //= Array2144.initiE 1:/# /= ifF 1:/#.
move=> _ _ [p1 b1] /= hp1.
split.
- apply (lane_okP b _ 1072) => //= i rgi.
  rewrite Array536.initiE //= Array2144.initiE 1:/# /= ifF 1:/#.
  by rewrite Array2144.initiE 1:/# /= ifF 1:/#.
move=> _ _ [p2 b2] /= hp2.
split.
- apply (lane_okP b _ 1608) => //= i rgi.
  rewrite Array536.initiE //= Array2144.initiE 1:/# /= ifF 1:/# hpp.
  by rewrite Array2144.initiE 1:/# /= ifF 1:/# Array2144.initiE 1:/# /= ifF 1:/#.
move=> _ _ [p3 b3] /= hp3.
apply pack4polyP => i rgi.
rewrite Array1024.initiE //= hp3 hp2 hp1 hp0.
smt(Array1024.initiE).
qed.
