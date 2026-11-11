(* -------------------------------------------------------------------- *)
(* The matrix sampler of one polynomial against the specification's    *)
(* parse: the buffer-window rejection filter, and the fill loop over    *)
(* the SHAKE128 stream of the seed.                                     *)
(* -------------------------------------------------------------------- *)
require import AllCore IntDiv List IntMin.

from Jasmin require import JModel_x86.

from JazzEC require import WArray8 WArray32 Array8 Array25 Array32 Array168 Array256 Array536.
from JazzEC require import Array368 WArray512 WArray736.
from JazzEC require import Array1024 Array2048 Array2144.

require import MLKEMFCLib AVX2_Ops.
require import EclibExtra JWordList JArrayExtra.
require import Agree Rejstream.
from CryptoSpecs require import Keccak1600_Spec.
from Spec require import GFq Rq Sampling Symmetric Correctness.
require import JkemConstants.
require BaseT MLKEM_keccak_avx2T Mlkem_filters_bridgeT.

abstract theory MLKEM_sampler_avx2T.

clone import BaseT.BaseT as B.
import R.
clone import MLKEM_keccak_avx2T.MLKEM_keccak_avx2T as MLKEM_keccak_avx2 with theory B <- B.
clone import Mlkem_filters_bridgeT.Mlkem_filters_bridgeT as Mlkem_filters_bridge with
  theory B <- B.

import GFq Rq Sampling Symmetric Correctness.

lemma pack32_sample_load_shuffle:
 pack32 (to_list sample_load_shuffle)
 = get256_direct ((init8 ("_.[_]" sample_load_shuffle)))%WArray32 0.
proof.
rewrite get256E; congr.
apply W32u8.Pack.all_eqP.
by rewrite of_listK 1:/# /all_eq /= !initiE /#.
qed.

lemma rejection16_cat l1 l2:
 3 %| size l1 =>
 rejection16 (l1++l2) = rejection16 l1 ++ rejection16 l2.
proof.
by move=> H; rewrite /rejection16 rejection_cat 1:// map_cat.
qed.

(* at most two coefficients per three bytes *)
lemma size_rejection16_subl buf o1 o2:
 0 <= o1 <= o2 <= 536 =>
 size (rejection16 (buf_subl buf o1 o2)) <= 2 * (o2 - o1) %/ 3.
proof.
move=> H; rewrite /rejection16 size_map.
by apply (size_rejection_le' (o2 - o1)) => //; rewrite size_buf_subl.
qed.

(* -------------------------------------------------------------------- *)
(* The buffer window from _bo, filtered up to bo: the coefficients      *)
(* found are appended to the _ctr ones of _pol. The window starts on a  *)
(* fresh buffer, or on its third block with fewer than 256 coefficients *)
(* found: either way they fit in the array.                             *)
op rej_inv (_pol : W16.t Array368.t) (_ctr _bo : int) (buf : W8.t Array536.t)
           (pol : W16.t Array368.t) (ctr bo : int) =
     (_bo = 0 /\ _ctr = 0 \/ _bo = 2*168 /\ 0 <= _ctr < 256)
  /\ _bo <= bo <= 504 /\ 3 %| (bo - _bo)
  /\ ctr = _ctr + size (rejection16 (buf_subl buf _bo bo))
  /\ slist pol ctr = slist _pol _ctr ++ rejection16 (buf_subl buf _bo bo).

lemma rej_inv0 _pol _ctr _bo buf :
  (_bo = 0 /\ _ctr = 0 \/ _bo = 2*168 /\ 0 <= _ctr < 256) =>
  rej_inv _pol _ctr _bo buf _pol _ctr _bo.
proof.
move=> hs; rewrite /rej_inv buf_subl0 // /rejection16 rejection0 /= cats0.
by rewrite hs /= dvdz0 /#.
qed.

lemma rej_inv_bound _pol _ctr _bo buf pol ctr bo :
  rej_inv _pol _ctr _bo buf pol ctr bo =>
  0 <= ctr /\ 3 * ctr + 2 * (504 - bo) <= 3 * 368.
proof.
move=> [hs [hb [hd [hc hp]]]].
have := size_rejection16_subl buf _bo bo _; 1: smt().
smt(size_ge0).
qed.

(* a filtered piece of the buffer extends the window *)
lemma rej_inv_step n _pol _ctr _bo buf pol pol' ctr bo :
  3 %| n => 0 <= n => bo + n <= 504 =>
  rej_inv _pol _ctr _bo buf pol ctr bo =>
  slist pol' (ctr + size (rejection16 (buf_subl buf bo (bo + n))))
  = slist pol ctr ++ rejection16 (buf_subl buf bo (bo + n)) =>
  rej_inv _pol _ctr _bo buf pol'
          (ctr + size (rejection16 (buf_subl buf bo (bo + n)))) (bo + n).
proof.
move=> h3 ge0n hle [hs [hb [hd [hc hp]]]] hstep.
have hcat : rejection16 (buf_subl buf _bo (bo + n))
            = rejection16 (buf_subl buf _bo bo) ++ rejection16 (buf_subl buf bo (bo + n)).
- by rewrite -(buf_subl_cat _ _bo bo (bo + n)) 1:/# rejection16_cat // size_buf_subl /#.
split; 1: exact hs.
split; 1: smt().
split; 1: smt().
split; 1: by rewrite hcat size_cat /#.
by rewrite hstep hp hcat catA.
qed.

hoare gen_matrix_buf_rejection_h _pol _ctr _buf _buf_offset:
 M._gen_matrix_buf_rejection
 : counter = _ctr
   /\ pol = _pol
   /\ buf = _buf
   /\ buf_offset = _buf_offset
   /\ (   to_uint buf_offset = 0 /\ to_uint counter = 0
       \/ to_uint buf_offset = 2*168 /\ to_uint counter < 256)
   ==>
   let l = rejection16 (buf_subl _buf (to_uint _buf_offset) 504)
   in slist res.`1 (to_uint _ctr + size l)
      = slist _pol (to_uint _ctr) ++ l
      /\ to_uint res.`2 = to_uint _ctr + size l.
proof.
proc; simplify.
ecall (buf_rejection_filter24_h pol counter buf buf_offset).
wp.
while (   buf = _buf
       /\ auxdata_ok load_shuffle mask bounds ones sst
       /\ rej_inv _pol (to_uint _ctr) (to_uint _buf_offset) buf
                  pol (to_uint counter) (to_uint buf_offset)
       /\ 48 %| (to_uint buf_offset - to_uint _buf_offset)
       /\ to_uint buf_offset <= 480
       /\ (condition_loop <=> to_uint buf_offset < 480)).
- wp; ecall (buf_rejection_filter48_h pol counter buf buf_offset).
  auto => &hr |> haux hinv hd hle hlt.
  have [ge0c hb] := rej_inv_bound _ _ _ _ _ _ _ hinv.
  have hbo : to_uint buf_offset{hr} <= 432.
  + by case/dvdzP: hd => k hk; case: hinv => /#.
  split; 1: smt().
  move=> _ _ [rp rc] /= hrp ->.
  have hl := size_rejection16_subl buf{hr} (to_uint buf_offset{hr})
               (to_uint buf_offset{hr} + 48) _; 1: smt().
  rewrite ultE to_uintD_small /= 1:/# of_uintK modz_small 1:#smt:(size_ge0).
  split; 1: by apply (rej_inv_step 48 _ _ _ _ _ rp _ _ _ _ _ hinv hrp) => // /#.
  split; last smt().
  rewrite (: to_uint buf_offset{hr} + 48 - to_uint _buf_offset
             = to_uint buf_offset{hr} - to_uint _buf_offset + 48) 1:#ring.
  by apply dvdzD.
auto => &hr |> hs.
split.
- rewrite /auxdata_ok /= pack32_sample_load_shuffle /= ultE /=.
  by split; [apply rej_inv0; smt(W64.to_uint_cmp) | smt()].
move=> bo cl c p hcl _ hinv hd hle hge.
have hbo : to_uint bo = 480 by smt().
have [ge0c hb] := rej_inv_bound _ _ _ _ _ _ _ hinv.
split; 1: smt().
move=> _ _ [rp rc] /= hrp ->.
have := rej_inv_step 24 _ _ _ _ _ rp _ _ _ _ _ hinv hrp; 1..3: smt().
have hl := size_rejection16_subl buf{hr} (to_uint bo) (to_uint bo + 24) _; 1: smt().
rewrite of_uintK modz_small 1:#smt:(size_ge0).
by move: hrp hl; rewrite hbo /= => hrp hl -[_ [_ [_ [hc hp]]]]; rewrite -hc hp.
qed.

lemma gen_matrix_buf_rejection_ll:
 islossless M._gen_matrix_buf_rejection.
proof.
proc.
call buf_rejection_filter24_ll; wp.
while (condition_loop <=> to_uint buf_offset < 480) (504 - to_uint buf_offset).
- move=> z; wp; call buf_rejection_filter48_ll; auto => &hr |> hlt.
  by rewrite ultE to_uintD_small /= /#.
by auto => &hr |>; rewrite ultE /= /#.
qed.

phoare gen_matrix_buf_rejection_ph _pol _ctr _buf _buf_offset:
 [ M._gen_matrix_buf_rejection
 : counter = _ctr
   /\ pol = _pol
   /\ buf = _buf
   /\ buf_offset = _buf_offset
   /\ (   to_uint buf_offset = 0 /\ to_uint counter = 0
       \/ to_uint buf_offset = 2*168 /\ to_uint counter < 256)
   ==>
   let l = rejection16 (buf_subl _buf (to_uint _buf_offset) 504)
   in slist res.`1 (to_uint _ctr + size l)
      = slist _pol (to_uint _ctr) ++ l
      /\ to_uint res.`2 = to_uint _ctr + size l
 ] = 1%r.
proof.
by conseq gen_matrix_buf_rejection_ll (gen_matrix_buf_rejection_h _pol _ctr _buf _buf_offset).
qed.

(* -------------------------------------------------------------------- *)
(* The fill loop against the stream: after k blocks, the buffer holds   *)
(* the sponge state permuted k times, and the array of samples the      *)
(* coefficients accepted in the first k blocks.                         *)
op unlift_polyu (a : poly) = Array256.init (fun i => W16.of_int (Zq.asint a.[i])).

lemma unlift_polyuE a:
 unlift_polyu a = Array256.map (fun x => W16.of_int (Zq.asint x)) a.
proof. by apply Array256.ext_eq => i Hi; rewrite initiE //= mapiE. qed.

op fill_inv seed (k : int) (buf : W8.t Array536.t) (samples : W16.t Array368.t) (ctr : W64.t) =
     3 <= k
  /\ sub buf (2*168) 200
     = state2bytes (FIPS202_SHA3_Spec.st_i (SHAKE128_ABSORB (rejection_seed seed)) k)
  /\ to_uint ctr = size (rejection (expand_seed seed k))
  /\ slist samples (to_uint ctr) = rejection16 (expand_seed seed k).

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

(* a filtered block extends the accepted coefficients                   *)
lemma fill_stepE (ctr rc : int) (samples rs : W16.t Array368.t) (ek blk : W8.t list) :
  3 %| size ek =>
  ctr = size (rejection ek) =>
  slist samples ctr = rejection16 ek =>
  slist rs (ctr + size (rejection16 blk)) = slist samples ctr ++ rejection16 blk =>
  rc = ctr + size (rejection16 blk) =>
     rc = size (rejection (ek ++ blk))
  /\ slist rs rc = rejection16 (ek ++ blk).
proof.
move=> h3 hc hp hrp ->.
rewrite rejection16_cat // rejection_cat // size_cat hrp hp /= hc.
by rewrite !size_map.
qed.

(* the 256-bit copy of sixteen coefficients                             *)
clone JArrayExtra.WAE as WAE512 with op size <- 512, theory A <- WArray512.
clone JArrayExtra.WAE as WAE736 with op size <- 736, theory A <- WArray736.

lemma copy_stepE (samples : W16.t Array368.t) (pol : W16.t Array256.t) (i j : int) :
  0 <= i < 16 => 0 <= j < 256 =>
  (Array256.init (WArray512.get16 (WArray512.set256_direct
     (WArray512.init16 (fun k => pol.[k])) (32 * i)
     (WArray736.get256_direct (WArray736.init16 (fun k => samples.[k])) (32 * i))))).[j]
  = if 16 * i <= j < 16 * i + 16 then samples.[j] else pol.[j].
proof.
move=> rgi rgj; rewrite Array256.initiE //= WAE512.get16_set256_direct 1..3:/#.
rewrite (_ : 32 * i %/ 2 = 16 * i) 1:/#.
case: (16 * i <= j < 16 * i + 16) => hj; 2: by rewrite WAE512.get16_init16 /#.
rewrite WAE736.get256_direct_bits16 1,2:/# (_ : 32 * i %/ 2 + (j - 16 * i) = j) 1:/#.
by rewrite WAE736.get16_init16 /#.
qed.

(* The buffer holds three squeezed blocks and the state after them.     *)
(* The stored state does not determine the block count, so the loop     *)
(* variant is the largest count up to needed_blocks consistent with it. *)
lemma fill_polynomial_ph _rho _j _i :
 phoare [ M.__gen_matrix_fill_polynomial
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
(* the copy of the first 256 samples *)
while (0 <= i <= 16 /\ inc = 16 /\
       (forall j, 0 <= j < 256 => samples.[j] = (unlift_polyu (parse _rho _j _i)).[j]) /\
       forall j, 0 <= j < 16 * i => pol.[j] = samples.[j]) (16 - i).
- move=> z; auto => &hr |> ge0i _ hs hp lti; split; 2: smt().
  split; 1: smt().
  move=> j ge0j ltj; rewrite copy_stepE 1,2:/#.
  by case: (16 * i{hr} <= j < 16 * i{hr} + 16) => hj //; apply hp => /#.
wp.
(* the fill loop *)
while (   (more <=> to_uint counter < 256)
       /\ exists k, k <= K /\ fill_inv seed k buf samples counter)
      (K - argmax idfun (fun k => k <= K /\ fill_inv seed k buf samples counter)).
- move=> z.
  exlim (argmax idfun (fun k => k <= K /\ fill_inv seed k buf samples counter)) => m.
  conseq (_ : fill_inv seed m buf samples counter /\ m < K /\ K - m = z
              /\ to_uint counter < 256 ==> _).
  + move=> &hr [-> [[[hmore [k [hk hinv]]] hc] hz]].
    have := argmax_bounded (fun k => fill_inv seed k buf{hr} samples{hr} counter{hr}) K k _ hinv.
    - by case: hinv => /#.
    move=> /= [rgm [hm _]]; split; 1: exact hm.
    have hc' : to_uint counter{hr} < 256 by smt().
    split; 2: smt().
    case: hm => [ge3m [_ [hcm _]]].
    pose a := argmax idfun
                (fun k0 => k0 <= K /\ fill_inv seed k0 buf{hr} samples{hr} counter{hr}).
    by have := lt_needed_blocks seed a _ _; smt().
  wp; ecall (gen_matrix_buf_rejection_ph samples counter buf buf_offset).
  wp; ecall (shake128_next_state_ph buf).
  skip => &hr |> [ge3m [hst [hcm hpm]]] ltmK hc buf1 hb1.
  have [hst1 hblk] := next_blockE seed m buf{hr} buf1 _ hst hb1; 1: smt().
  move=> [rp rc rms] /=; rewrite (_ : 336 = 2 * 168) // hblk => hrp hrc.
  have [hcm1 hpm1] := fill_stepE (to_uint counter{hr}) (to_uint rc) samples{hr} rp
                        (expand_seed seed m)
                        (squeezestate_i c256_r8 (SHAKE128_ABSORB (rejection_seed seed)) m)
                        _ hcm hpm hrp hrc.
  - by rewrite size_expand_seed 1:/# dvdz_mulr.
  rewrite -expand_seedS 1:/# in hcm1; rewrite -expand_seedS 1:/# in hpm1.
  have hinv : fill_inv seed (m + 1) buf1 rp rc.
  - by split; [smt() | split; [exact hst1 | split; [exact hcm1 | exact hpm1]]].
  rewrite ultE /=.
  split; 1: by exists (m + 1); split; [smt() | exact hinv].
  have := argmax_bounded (fun k => fill_inv seed k buf1 rp rc) K (m + 1) _ hinv; 1: smt().
  by move=> /= /#.
- by exlim buf => b; call (shake128_next_state_ph b); auto.
wp; ecall (gen_matrix_buf_rejection_ph samples counter buf buf_offset); auto => &hr |> hb hst.
move=> [rp rc rms] /=; rewrite hb {2}/slist mkseq0 /= => hrp hrc.
split.
- rewrite ultE /=; exists 3; split; 1: smt().
  split => //; split; 1: exact hst.
  by split; [rewrite hrc /rejection16 size_map | rewrite hrc hrp].
move=> b0 c0 more0 ms0 s0; split.
- move=> k hk hinv hv.
  have := argmax_bounded (fun k => fill_inv seed k b0 s0 c0) K k _ hinv; 1: by case: hinv => /#.
  move=> /= [rgm [hm _]].
  have hK : argmax idfun (fun k => k <= K /\ fill_inv seed k b0 s0 c0) = K by smt().
  move: hm; rewrite hK => -[_ [_ [hc _]]].
  by have := needed_blocksP seed; rewrite /enough_blocks => h; smt().
move=> _ hc k hk [ge3k [_ [hcm hpm]]].
have hs : forall j, 0 <= j < 256 => s0.[j] = (unlift_polyu (parse _rho _j _i)).[j].
- move=> j rgj; rewrite /unlift_polyu initiE //= (parseE _ _ _ k) 1..3:/#.
  have := congr1 (fun l => nth witness l j) _ _ hpm => /=.
  rewrite /slist nth_mkseq 1:/# /= /rejection16 (nth_map witness) 1:/# /=.
  by move=> h; exact h.
split; 1: smt().
move=> i0 p0; split; 1: smt().
move=> gei ge0i lei _ hp.
by apply Array256.ext_eq => j rgj; rewrite -hs 1:// hp /#.
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
  phoare [ M.gen_matrix_get_indexes : arg = (_b, _tt) ==> res = w ] = 1%r =>
  phoare [ M._gen_matrix_sample_four_polynomials
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
have hpq : forall (x : W16.t Array1024.t) ms, SLH64.protect_ptr x ms = x.
- by rewrite /SLH64.protect_ptr.
have /= i0 := idx_subE witness w 0 _; 1: done.
have /= i1 := idx_subE witness w 1 _; 1: done.
have /= i2 := idx_subE witness w 2 _; 1: done.
have /= i3 := idx_subE witness w 3 _; 1: done.
rewrite i0 i1 i2 i3 => st hst; split; 1: exact hst.
move=> _ [st' b] /= hb0 hb1 hb2 hb3 hs0 hs1 hs2 hs3.
split; 1: by apply (lane_okP b _ 0) => // i rgi; rewrite initiE.
move=> _ _ [p0 b0 m0] /= hp0; rewrite !hpp !hpq.
split.
- apply (lane_okP b _ 536) => //= i rgi.
  by rewrite Array536.initiE //= Array2144.initiE 1:/# /= ifF 1:/#.
move=> _ _ [p1 b1 m1] /= hp1; rewrite !hpp !hpq.
split.
- apply (lane_okP b _ 1072) => //= i rgi.
  rewrite Array536.initiE //= Array2144.initiE 1:/# /= ifF 1:/#.
  by rewrite Array2144.initiE 1:/# /= ifF 1:/#.
move=> _ _ [p2 b2 m2] /= hp2; rewrite !hpp !hpq.
split.
- apply (lane_okP b _ 1608) => //= i rgi.
  rewrite Array536.initiE //= Array2144.initiE 1:/# /= ifF 1:/#.
  by rewrite Array2144.initiE 1:/# /= ifF 1:/# Array2144.initiE 1:/# /= ifF 1:/#.
move=> _ _ [p3 b3 m3] /= hp3; rewrite !hpq.
apply pack4polyP => i rgi.
rewrite Array1024.initiE //= hp3 hp2 hp1 hp0.
smt(Array1024.initiE).
qed.

end MLKEM_sampler_avx2T.
