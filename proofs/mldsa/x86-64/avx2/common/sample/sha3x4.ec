(* -------------------------------------------------------------------- *)
(* The interleaved 4-lane SHA-3 sponge abstraction shared by the ML-DSA *)
(* samplers.                                                            *)
(*                                                                      *)
(* A lane is described logically by the bytes it has absorbed and how   *)
(* many output bytes have been consumed ([sha3_state]); the relation    *)
(* [\sha3for] of the parametric theory [Xof4x] links the concrete       *)
(* interleaved state to four such descriptions.  The output stream is   *)
(* [Xof.slice] of a byte oracle, so the size/cat properties of stream   *)
(* slices are lemmas, not axioms.                                       *)
(*                                                                      *)
(* A lane state is the FIPS 202 sponge state ([sha3_lane]): a lane      *)
(* still absorbing holds the partially absorbed input, and a lane that  *)
(* has been read [n] bytes far holds the absorbed state permuted        *)
(* [n / rate] times.  The specifications of the extracted Keccak        *)
(* primitives are derived from the FIPS 202 development, to which the   *)
(* extracted procedures are equivalent by [sim].                        *)
(*                                                                      *)
(* The theory is instantiated for SHAKE128 (rate 168) and SHAKE256      *)
(* (rate 136); below each instance sit the specifications of the        *)
(* Keccak primitives and the block-squeeze and absorb wrappers built on *)
(* them.                                                                *)
require import AllCore List IntDiv.
require Xof.
from CryptoSpecs require Keccak1600_Spec.
from Jasmin require import JWord JUtils JArray.
require import MldsaConstants.
require Parameters MldsaT.
require import Array4 Array7 Array25 Array28 Array32 Array48 Array64 Array136 Array168.
require import Array2 WArray2 WArray224.
require import WArray32 WArray48 WArray64 WArray136 WArray168.
require import Avx2red.
from Keccak require import Keccakf1600 Keccak1600_ref Keccak1600_fixedsizes_ref.
from Keccak require import Keccakf1600_avx2 Keccak1600_avx2 Keccak1600_fixedsizes_avx2.
from Keccak require import Keccak1600_fixedsizes_avx2x4.
require import Keccak1600_statebytes.

abstract theory Sha3x4T.

clone import Parameters.ParamsT as P.
clone import MldsaT.MldsaT as R with theory P <- P.
clone import Avx2red.Avx2redT as AR with theory P <- P, theory R <- R.
import Array_ctilde WArray_ctilde.


(* -------------------------------------------------------------------- *)
(* logical sponge bookkeeping                                           *)
type sha3_state = { absorbed : W8.t list; read : int option }.

op is_valid_sha3_state (state : sha3_state) =
  match state.`read with None => true | Some i => 0 <= i end.

op mk_absorbing (data : W8.t list) =
  {| absorbed = data; read = None |}.

op mk_absorbed (data : W8.t list) =
  {| absorbed = data; read = Some 0 |}.

op mk_read (read : int) (data : W8.t list) =
  {| absorbed = data; read = Some read |}.

lemma mk_absorbed_read0 (data : W8.t list) :
  mk_absorbed data = mk_read 0 data.
proof. by done. qed.

(* -------------------------------------------------------------------- *)
type sha3x4_state = sha3_state Array4.t.

op is_valid_sha3x4_state (state : sha3x4_state) =
  Array4.all is_valid_sha3_state state.

type sha3x4 = W256.t Array25.t.

(* -------------------------------------------------------------------- *)
(* the FIPS 202 sponge state of a lane: an absorbing lane holds less    *)
(* than one block, XORed into the zero state                            *)
op sha3_lane (r8 : int) (st : W64.t Array25.t) (s : sha3_state) : bool =
  match s.`read with
  | None   => size s.`absorbed < r8 /\ pabsorb_spec r8 s.`absorbed st
  | Some n => st = iter (n %/ r8) keccak_f1600_op
                      (ABSORB1600 Keccak1600_Spec.SHAKE_DS_BYTE r8 s.`absorbed)
  end.

(* the four lanes of an interleaved state *)
op sha3_lanes (r8 : int) (st : sha3x4) (s : sha3x4_state) : bool =
  forall k, 0 <= k < 4 => sha3_lane r8 (st4x_get st k) s.[k].

(* byte [i] of the SHAKE stream at rate [r8] *)
op keccak_xof (r8 : int) (m : W8.t list) (i : int) : W8.t =
  nth W8.zero (KECCAK1600 r8 m Keccak1600_Spec.SHAKE_DS_BYTE (i + 1)) i.

(* a lane read up to the end of block [k] holds block [k] in its rate   *)
lemma sha3_lane_block (r8 : int) (n : W8.t list) (k j : int) st :
  0 < r8 <= 200 => 0 <= k => 0 <= j < r8 =>
  sha3_lane r8 st (mk_read (r8 * (k + 1)) n) =>
  (stbytes st).[j] = keccak_xof r8 n (r8 * k + j).
proof.
move=> hr hk hj; rewrite /sha3_lane /mk_read /= mulzC mulzK 1:/# => ->.
rewrite /keccak_xof /KECCAK1600 nth_SQUEEZE1600 //; 1: smt().
rewrite /FIPS202_SHA3_Spec.st_i; congr; last by rewrite mulzC modzMDl pmod_small.
by rewrite mulzC divzMDl 1:/# pdiv_small.
qed.

lemma sha3_lanes_absorbingE (r8 : int) (l : W8.t list) (st : sha3x4) :
  sha3_lanes r8 st (Array4.init (fun _ => mk_absorbing l))
  <=> size l < r8 /\ pabsorb_spec_avx2x4 r8 l l l l st.
proof.
have hl : forall k, 0 <= k < 4 =>
  (Array4.init (fun _ => mk_absorbing l)).[k] = mk_absorbing l.
- by move=> k rgk; rewrite Array4.initiE.
rewrite pabsorb_spec_avx2x4E /sha3_lanes; split => [h | [hsz [_ [_ [_ h]]]] k rgk].
- split; first by move: (h 0 _) => //; rewrite hl // /sha3_lane /mk_absorbing /= => -[].
  do 3! split => //; move=> k rgk; rewrite nth4_const //.
  by move: (h k rgk); rewrite hl // /sha3_lane /mk_absorbing /= => -[].
by rewrite hl // /sha3_lane /mk_absorbing /= hsz -(nth4_const [] l k) // h.
qed.

(* ==================================================================== *)
(* The extracted Keccak primitives are those of the FIPS 202            *)
(* development                                                          *)

clone KeccakArrayRef as Ref2
  with op _ASIZE <- 2, theory A <- Array2, theory WA <- WArray2
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayRef as RefCt
  with op _ASIZE <- ctilde, theory A <- Array_ctilde, theory WA <- WArray_ctilde
  proof _ASIZE_ge0 by exact ge0_ctilde
  proof _ASIZE_u64 by (rewrite /ctilde; smt(P.param_sets)).

clone KeccakArrayRef as Ref64
  with op _ASIZE <- 64, theory A <- Array64, theory WA <- WArray64
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayRef as Ref136
  with op _ASIZE <- 136, theory A <- Array136, theory WA <- WArray136
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayAvx2 as Avx2_2
  with op _ASIZE <- 2, theory A <- Array2, theory WA <- WArray2
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayAvx2 as Avx2_Ct
  with op _ASIZE <- ctilde, theory A <- Array_ctilde, theory WA <- WArray_ctilde
  proof _ASIZE_ge0 by exact ge0_ctilde
  proof _ASIZE_u64 by (rewrite /ctilde; smt(P.param_sets)).

clone KeccakArrayAvx2 as Avx2_64
  with op _ASIZE <- 64, theory A <- Array64, theory WA <- WArray64
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayAvx2 as Avx2_136
  with op _ASIZE <- 136, theory A <- Array136, theory WA <- WArray136
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayAvx2x4 as X4_2
  with op _ASIZE <- 2, theory A <- Array2, theory WA <- WArray2
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayAvx2x4 as X4_32
  with op _ASIZE <- 32, theory A <- Array32, theory WA <- WArray32
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayAvx2x4 as X4_64
  with op _ASIZE <- 64, theory A <- Array64, theory WA <- WArray64
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayAvx2x4 as X4_136
  with op _ASIZE <- 136, theory A <- Array136, theory WA <- WArray136
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

clone KeccakArrayAvx2x4 as X4_168
  with op _ASIZE <- 168, theory A <- Array168, theory WA <- WArray168
  proof _ASIZE_ge0 by done proof _ASIZE_u64 by done.

equiv state_init_fips202 :
  M.__state_init ~ Keccak1600_Jazz.M.__state_init : ={arg} ==> ={res}
by sim.

equiv state_init_avx2_fips202 :
  M.__state_init_avx2 ~ Keccak1600_Jazz.M.__state_init_avx2 : ={arg} ==> ={res}
by sim.

equiv state_init_avx2x4_fips202 :
  M.__state_init_avx2x4 ~ Keccak1600_Jazz.M.__state_init_avx2x4 : ={arg} ==> ={res}
by sim.

equiv keccakf1600_fips202 :
  M._keccakf1600 ~ Keccak1600_Jazz.M._keccakf1600 : ={arg} ==> ={res}
by sim.

equiv keccakf1600_avx2_fips202 :
  M._keccakf1600_avx2 ~ Keccak1600_Jazz.M._keccakf1600_avx2 : ={arg} ==> ={res}
by sim.

equiv keccakf1600_avx2x4_fips202 :
  M._keccakf1600_avx2x4 ~ Keccak1600_Jazz.M._keccakf1600_avx2x4 : ={arg} ==> ={res}
by sim.

equiv a2_absorb_fips202 :
  M.a2____absorb ~ Ref2.MM.__absorb : ={arg} ==> ={res}
by sim.

equiv act_absorb_fips202 :
  M.a_COMMITMENT_HASH____absorb ~ RefCt.MM.__absorb : ={arg} ==> ={res}
by sim.

equiv a64_absorb_fips202 :
  M.a64____absorb ~ Ref64.MM.__absorb : ={arg} ==> ={res}
by sim.

equiv a136_dumpstate_fips202 :
  M.a136____dumpstate ~ Ref136.MM.__dumpstate : ={arg} ==> ={res}
by sim.

equiv a2_absorb_avx2_fips202 :
  M.a2____absorb_avx2 ~ Avx2_2.MM.__absorb_avx2 : ={arg} ==> ={res}
by sim.

equiv act_absorb_avx2_fips202 :
  M.a_COMMITMENT_HASH____absorb_avx2 ~ Avx2_Ct.MM.__absorb_avx2 : ={arg} ==> ={res}
by sim.

equiv a64_absorb_avx2_fips202 :
  M.a64____absorb_avx2 ~ Avx2_64.MM.__absorb_avx2 : ={arg} ==> ={res}
by sim.

equiv a136_dumpstate_avx2_fips202 :
  M.a136____dumpstate_avx2 ~ Avx2_136.MM.__dumpstate_avx2 : ={arg} ==> ={res}
by sim.

equiv a2_absorb_avx2x4_fips202 :
  M.a2____absorb_avx2x4 ~ X4_2.MM.__absorb_avx2x4 : ={arg} ==> ={res}
by sim.

equiv a32_absorb_bcast_avx2x4_fips202 :
  M.a32____absorb_bcast_avx2x4 ~ X4_32.MM.__absorb_bcast_avx2x4 : ={arg} ==> ={res}
by sim.

equiv a64_absorb_bcast_avx2x4_fips202 :
  M.a64____absorb_bcast_avx2x4 ~ X4_64.MM.__absorb_bcast_avx2x4 : ={arg} ==> ={res}
by sim.

equiv a136_dumpstate_avx2x4_fips202 :
  M.a136____dumpstate_avx2x4 ~ X4_136.MM.__dumpstate_avx2x4 : ={arg} ==> ={res}
by sim.

equiv a168_dumpstate_avx2x4_fips202 :
  M.a168____dumpstate_avx2x4 ~ X4_168.MM.__dumpstate_avx2x4 : ={arg} ==> ={res}
by sim.

(* -------------------------------------------------------------------- *)
(* rate-generic specifications of the 4-lane primitives                 *)

lemma state_init_avx2x4P (r8 : int) : 0 < r8 <= 200 =>
  hoare[ M.__state_init_avx2x4 :
    true ==> sha3_lanes r8 res (Array4.init (fun _ => mk_absorbing [])) ].
proof.
move=> hr; conseq state_init_avx2x4_fips202 (state_init_avx2x4_h r8)
  => [&1 _ | &1 &2 ->]; 1: by exists arg{1}.
rewrite pabsorb_spec_avx2x4E => -[_ [_ [_ h]]] k rgk.
rewrite Array4.initiE //= /sha3_lane /mk_absorbing /= (_ : 0 < r8) 1:/#.
by have := h k rgk; rewrite nth4_const.
qed.

lemma keccakf1600_avx2x4P (r8 : int) (data : W8.t list Array4.t) (k : int) :
  0 < r8 =>
  hoare[ M._keccakf1600_avx2x4 :
       0 <= k /\ sha3_lanes r8 a (Array4.map (mk_read (r8 * k)) data)
    ==> sha3_lanes r8 res (Array4.map (mk_read (r8 * (k + 1))) data) ].
proof.
move=> hr; exlim a => a0.
case: (0 <= k /\ sha3_lanes r8 a0 (Array4.map (mk_read (r8 * k)) data))
  => [[hk h] | hn]; last by conseq (_ : false ==> _) => // /#.
conseq keccakf1600_avx2x4_fips202 (keccakf1600_avx2x4_h a0)
  => [&1 [<- _] | &1 &2 -> ->]; 1: by exists a0.
move=> i rgi; rewrite st4x_get_map //; have := h i rgi.
by rewrite /sha3_lane !Array4.mapiE //= /mk_read /= !(mulzC r8) !mulzK 1,2:/# iterS // => ->.
qed.

lemma absorb_2_final_avx2x4P (r8 : int) (pre_ : W8.t list) (ds_ : W16.t Array4.t) :
  hoare[ M.a2____absorb_avx2x4 :
       sha3_lanes r8 st (Array4.init (fun _ => mk_absorbing pre_))
    /\ to_list buf0 = W2u8.to_list ds_.[0]
    /\ to_list buf1 = W2u8.to_list ds_.[1]
    /\ to_list buf2 = W2u8.to_list ds_.[2]
    /\ to_list buf3 = W2u8.to_list ds_.[3]
    /\ aT = size pre_ /\ _TRAILB = 31 /\ _RATE8 = r8
    ==> sha3_lanes r8 res.`1
          (Array4.map (fun w => mk_absorbed (pre_ ++ W2u8.to_list w)) ds_) ].
proof.
exlim st, buf0, buf1, buf2, buf3 => s b0 b1 b2 b3.
case: (   to_list b0 = W2u8.to_list ds_.[0] /\ to_list b1 = W2u8.to_list ds_.[1]
       /\ to_list b2 = W2u8.to_list ds_.[2] /\ to_list b3 = W2u8.to_list ds_.[3])
  => [[e0 [e1 [e2 e3]]] | hn]; last first.
- conseq (_ : false ==> _) => //.
  by move=> &hr [[_ [<- [<- [<- <-]]]] [_ [h0 [h1 [h2 [h3 _]]]]]]; apply: hn.
conseq a2_absorb_avx2x4_fips202
  (X4_2.absorb_avx2x4_h pre_ pre_ pre_ pre_ s b0 b1 b2 b3 31 r8).
- move=> &1 [[hs [hb0 [hb1 [hb2 hb3]]]] [+ [_ [_ [_ [_ [ha [ht hr]]]]]]]].
  rewrite sha3_lanes_absorbingE -hs => -[hsz h].
  by exists arg{1}; rewrite hs hb0 hb1 hb2 hb3 ha ht hr /= -hs h /= pmod_small // size_ge0.
move=> &1 &2 ->; rewrite ifT // absorb_spec_avx2x4E => h k rgk.
rewrite Array4.mapiE // /sha3_lane /mk_absorbed /= h // iter0 // e0 e1 e2 e3.
have hk : k = 0 \/ k = 1 \/ k = 2 \/ k = 3 by smt().
by case: hk => [|[|[|]]] ->>.
qed.

(* -------------------------------------------------------------------- *)
abstract theory Xof4x.

op rate : int.
axiom gt0_rate : 0 < rate.
axiom le200_rate : rate <= 200.

(* the byte oracle of the XOF *)
op xof : W8.t list -> int -> W8.t.

(* one output block *)
clone import PolyArray as AB with op size <- rate.

op [opaque] slice (n : W8.t list) (base len : int) : W8.t list =
  Xof.slice xof n base len.

lemma size_slice (n : W8.t list) (i m : int) :
  0 <= m => size (slice n i m) = m.
proof. by move=> ge0m; rewrite /slice /Xof.slice size_mkseq /#. qed.

lemma slice_cat (n : W8.t list) (i m l : int) :
  0 <= m => 0 <= l =>
  slice n i (m + l) = slice n i m ++ slice n (i + m) l.
proof.
move=> ge0m ge0l; rewrite /slice /Xof.slice mkseq_add //; congr.
by apply eq_in_mkseq => j rgj /=; congr; ring.
qed.

(* the concrete interleaved state realizes four logical lanes *)
op [opaque] (\sha3for) (st : sha3x4) (s : sha3x4_state) : bool =
  sha3_lanes rate st s.

lemma sha3forE (st : sha3x4) (s : sha3x4_state) :
  st \sha3for s <=> sha3_lanes rate st s.
proof. by rewrite /(\sha3for). qed.

lemma sha3for_eqR rstate s1 s2 :
  s1 = s2 => rstate \sha3for s1 => rstate \sha3for s2.
proof. by move=> ->. qed.

(* one squeezed block appended to a lane's consumed stream *)
lemma slice_cat_block (n : W8.t list) (k : int) (b : W8.t AB.t) :
  0 <= k =>
  AB.to_list b = slice n (rate * k) rate =>
  slice n 0 (rate * k) ++ AB.to_list b = slice n 0 (rate * (k + 1)).
proof.
move=> hk hb; rewrite hb (_ : rate * (k + 1) = rate * k + rate); 1: by ring.
rewrite slice_cat 1,2:#smt:(gt0_rate).
by rewrite (_ : 0 + rate * k = rate * k) 1:/#.
qed.

(* -------------------------------------------------------------------- *)
(* the 4-lane primitives at this rate                                   *)
lemma state_init_avx2x4_rateP :
  hoare[ M.__state_init_avx2x4 :
    true ==> res \sha3for Array4.init (fun _ => mk_absorbing []) ].
proof.
conseq (state_init_avx2x4P rate _) => [_ _ st | ]; first by rewrite sha3forE.
by rewrite gt0_rate le200_rate.
qed.

lemma keccakf1600_avx2x4_rateP (data : W8.t list Array4.t) (k : int) :
  hoare[ M._keccakf1600_avx2x4 :
       0 <= k /\ a \sha3for Array4.map (mk_read (rate * k)) data
    ==> res \sha3for Array4.map (mk_read (rate * (k + 1))) data ].
proof.
conseq (keccakf1600_avx2x4P rate data k gt0_rate) => [&hr | &hr _ st]; by rewrite sha3forE.
qed.

lemma absorb_2_final_avx2x4_rateP (pre_ : W8.t list) (ds_ : W16.t Array4.t) :
  hoare[ M.a2____absorb_avx2x4 :
       st \sha3for Array4.init (fun _ => mk_absorbing pre_)
    /\ to_list buf0 = W2u8.to_list ds_.[0]
    /\ to_list buf1 = W2u8.to_list ds_.[1]
    /\ to_list buf2 = W2u8.to_list ds_.[2]
    /\ to_list buf3 = W2u8.to_list ds_.[3]
    /\ aT = size pre_ /\ _TRAILB = 31 /\ _RATE8 = rate
    ==> res.`1 \sha3for
          Array4.map (fun w => mk_absorbed (pre_ ++ W2u8.to_list w)) ds_ ].
proof.
conseq (absorb_2_final_avx2x4P rate pre_ ds_) => [&hr | &hr _ st]; by rewrite sha3forE.
qed.

end Xof4x.

(* ==================================================================== *)
(* SHAKE128, rate 168                                                   *)

(* the byte oracle is the byte stream of the specification's SHAKE128 *)
op shake128_xof (m : W8.t list) (i : int) : W8.t =
  nth witness (Keccak1600_Spec.SHAKE128 m (i + 1)) i.

lemma shake128_xofE (m : W8.t list) (i : int) :
  0 <= i => shake128_xof m i = keccak_xof 168 m i.
proof.
move=> hi; rewrite /shake128_xof /keccak_xof (nth_change_dfl W8.zero) //.
by rewrite Keccak1600_Spec.size_SHAKE128 /#.
qed.

clone import Xof4x as Shake128x4 with
      op rate <- 168,
      op xof  <- shake128_xof,
  theory AB   <- Array168

  rename "slice" as "shake128_slice"

  proof gt0_rate by done
  proof le200_rate by done.

(* -------------------------------------------------------------------- *)
(* the 4-lane Keccak primitives (SHAKE128 flavor), against [\sha3for]   *)

lemma state_init_avx2x4_128P :
  hoare[ M.__state_init_avx2x4 :
    true ==> res \sha3for Array4.init (fun _ => mk_absorbing []) ].
proof. by apply state_init_avx2x4_rateP. qed.

lemma absorb_bcast_avx2x4_128P (rho_ : W8.t Array32.t) :
  hoare[ M.a32____absorb_bcast_avx2x4 :
       st \sha3for Array4.init (fun _ => mk_absorbing [])
    /\ buf = rho_ /\ aT = 0 /\ _TRAILB = 0 /\ _RATE8 = 168
    ==> res.`1 \sha3for Array4.init (fun _ => mk_absorbing (to_list rho_)) ].
proof.
exlim st => s.
conseq a32_absorb_bcast_avx2x4_fips202
  (X4_32.absorb_bcast_avx2x4_h [] [] [] [] s rho_ 0 168).
- move=> &1 [hs [+ [hb [ha [ht hr]]]]]; rewrite sha3forE sha3_lanes_absorbingE -hs => -[_ h].
  by exists arg{1}; rewrite ha hb ht hr hs /= -hs h.
move=> &1 &2 ->; rewrite ifF //= => -[h _].
by rewrite sha3forE sha3_lanes_absorbingE h size_to_list.
qed.

lemma absorb_2_final_avx2x4_128P (pre_ : W8.t list) (ds_ : W16.t Array4.t) :
  hoare[ M.a2____absorb_avx2x4 :
       st \sha3for Array4.init (fun _ => mk_absorbing pre_)
    /\ to_list buf0 = W2u8.to_list ds_.[0]
    /\ to_list buf1 = W2u8.to_list ds_.[1]
    /\ to_list buf2 = W2u8.to_list ds_.[2]
    /\ to_list buf3 = W2u8.to_list ds_.[3]
    /\ aT = size pre_ /\ _TRAILB = 31 /\ _RATE8 = 168
    ==> res.`1 \sha3for
          Array4.map (fun w => mk_absorbed (pre_ ++ W2u8.to_list w)) ds_ ].
proof. by apply absorb_2_final_avx2x4_rateP. qed.

lemma keccakf1600_avx2x4_128P (data : W8.t list Array4.t) (k : int) :
  hoare[ M._keccakf1600_avx2x4 :
       0 <= k /\ a \sha3for Array4.map (mk_read (168 * k)) data
    ==> res \sha3for Array4.map (mk_read (168 * (k + 1))) data ].
proof. by apply keccakf1600_avx2x4_rateP. qed.

lemma dumpstate_avx2x4_128P (data : W8.t list Array4.t) (k : int) :
  hoare[ M.a168____dumpstate_avx2x4 :
       0 <= k /\ st \sha3for Array4.map (mk_read (168 * (k + 1))) data
    /\ offset = 0 /\ _LEN = 168
    ==> forall i, 0 <= i < 4 =>
          Array168.to_list (nth witness [res.`1; res.`2; res.`3; res.`4] i)
          = shake128_slice data.[i] (168 * k) 168 ].
proof.
exlim buf0, buf1, buf2, buf3, st => b0 b1 b2 b3 s.
case: (0 <= k /\ sha3_lanes 168 s (Array4.map (mk_read (168 * (k + 1))) data))
  => [[hk h] | hn]; last first.
- by conseq (_ : false ==> _) => // &hr [[_ [_ [_ [_ <-]]]]]; rewrite sha3forE /#.
conseq a168_dumpstate_avx2x4_fips202
  (X4_168.dumpstate_avx2x4_h b0 b1 b2 b3 0 168 s) => [&1 /> * | &1 &2 -> />].
- by exists arg{1} => /#.
move=> h0 h1 h2 h3 _ l ge0l ltl4.
have hl : forall (b : W8.t Array168.t),
  to_list (fill ("_.[_]" (stbytes (st4x_get s l))) 0 168 b) = shake128_slice data.[l] (168 * k) 168.
- move=> b; rewrite /to_list /shake128_slice /Xof.slice; apply eq_in_mkseq => j rgj /=.
  rewrite Array168.filliE // rgj /= shake128_xofE 1:/#.
  by rewrite (sha3_lane_block 168 data.[l] k j) //; have := h l _; rewrite // Array4.mapiE.
have : l = 0 \/ l = 1 \/ l = 2 \/ l = 3 by smt().
by case=> [|[|[|]]] ->> /=; rewrite ?h0 ?h1 ?h2 ?h3 hl.
qed.

(* -------------------------------------------------------------------- *)
(* one block squeezed out of the four lanes                             *)
lemma shake128_squeezeblock4xP (data : W8.t list Array4.t) (k : int) :
hoare[
  M.shake128_squeezeblock4x :
      0 <= k /\ state \sha3for Array4.map (mk_read (168 * k)) data
    ==>
         res.`1 \sha3for Array4.map (mk_read (168 * (k + 1))) data
      /\ (forall i, 0 <= i < 4 =>
            Array168.to_list (nth witness [res.`2; res.`3; res.`4; res.`5] i)
            = shake128_slice data.[i] (168 * k) 168)
  ].
proof.
proc.
(* the permutation advances every lane by one block *)
seq 1 : (0 <= k /\ state \sha3for Array4.map (mk_read (168 * (k + 1))) data).
- by call (keccakf1600_avx2x4_128P data k); auto.
(* the fresh block is read off the rate part of the state *)
by sp; call (dumpstate_avx2x4_128P data k); auto.
qed.

(* ==================================================================== *)
(* SHAKE256, rate 136                                                   *)

(* the byte oracle is the byte stream of the specification's SHAKE256 *)
op shake256_xof (m : W8.t list) (i : int) : W8.t =
  nth witness (Keccak1600_Spec.SHAKE256 m (i + 1)) i.

lemma shake256_xofE (m : W8.t list) (i : int) :
  0 <= i => shake256_xof m i = keccak_xof 136 m i.
proof.
move=> hi; rewrite /shake256_xof /keccak_xof (nth_change_dfl W8.zero) //.
by rewrite Keccak1600_Spec.size_SHAKE256 /#.
qed.

clone Xof4x as Shake256x4 with
      op rate <- 136,
      op xof  <- shake256_xof,
  theory AB   <- Array136

  rename "slice" as "shake256_slice"

  proof gt0_rate by done
  proof le200_rate by done.

(* -------------------------------------------------------------------- *)
(* the 4-lane Keccak primitives (SHAKE256 flavor)                       *)

lemma state_init_avx2x4_256P :
  hoare[ M.__state_init_avx2x4 :
    true ==> Shake256x4.(\sha3for) res (Array4.init (fun _ => mk_absorbing [])) ].
proof. by apply Shake256x4.state_init_avx2x4_rateP. qed.

lemma absorb_bcast_avx2x4_256P (rho_ : W8.t Array64.t) :
  hoare[ M.a64____absorb_bcast_avx2x4 :
       Shake256x4.(\sha3for) st (Array4.init (fun _ => mk_absorbing []))
    /\ buf = rho_ /\ aT = 0 /\ _TRAILB = 0 /\ _RATE8 = 136
    ==> Shake256x4.(\sha3for) res.`1
          (Array4.init (fun _ => mk_absorbing (to_list rho_))) ].
proof.
exlim st => s.
conseq a64_absorb_bcast_avx2x4_fips202
  (X4_64.absorb_bcast_avx2x4_h [] [] [] [] s rho_ 0 136).
- move=> &1 [hs [+ [hb [ha [ht hr]]]]].
  rewrite Shake256x4.sha3forE sha3_lanes_absorbingE -hs => -[_ h].
  by exists arg{1}; rewrite ha hb ht hr hs /= -hs h.
move=> &1 &2 ->; rewrite ifF //= => -[h _].
by rewrite Shake256x4.sha3forE sha3_lanes_absorbingE h size_to_list.
qed.

lemma absorb_2_final_avx2x4_256P (pre_ : W8.t list) (ds_ : W16.t Array4.t) :
  hoare[ M.a2____absorb_avx2x4 :
       Shake256x4.(\sha3for) st (Array4.init (fun _ => mk_absorbing pre_))
    /\ to_list buf0 = W2u8.to_list ds_.[0]
    /\ to_list buf1 = W2u8.to_list ds_.[1]
    /\ to_list buf2 = W2u8.to_list ds_.[2]
    /\ to_list buf3 = W2u8.to_list ds_.[3]
    /\ aT = size pre_ /\ _TRAILB = 31 /\ _RATE8 = 136
    ==> Shake256x4.(\sha3for) res.`1
          (Array4.map (fun w => mk_absorbed (pre_ ++ W2u8.to_list w)) ds_) ].
proof. by apply Shake256x4.absorb_2_final_avx2x4_rateP. qed.

lemma keccakf1600_avx2x4_256P (data : W8.t list Array4.t) (k : int) :
  hoare[ M._keccakf1600_avx2x4 :
       0 <= k /\ Shake256x4.(\sha3for) a (Array4.map (mk_read (136 * k)) data)
    ==> Shake256x4.(\sha3for) res (Array4.map (mk_read (136 * (k + 1))) data) ].
proof. by apply Shake256x4.keccakf1600_avx2x4_rateP. qed.

lemma dumpstate_avx2x4_256P (data : W8.t list Array4.t) (k : int) :
  hoare[ M.a136____dumpstate_avx2x4 :
       0 <= k /\ Shake256x4.(\sha3for) st (Array4.map (mk_read (136 * (k + 1))) data)
    /\ offset = 0 /\ _LEN = 136
    ==> forall i, 0 <= i < 4 =>
          Array136.to_list (nth witness [res.`1; res.`2; res.`3; res.`4] i)
          = Shake256x4.shake256_slice data.[i] (136 * k) 136 ].
proof.
exlim buf0, buf1, buf2, buf3, st => b0 b1 b2 b3 s.
case: (0 <= k /\ sha3_lanes 136 s (Array4.map (mk_read (136 * (k + 1))) data))
  => [[hk h] | hn]; last first.
- by conseq (_ : false ==> _) => // &hr [[_ [_ [_ [_ <-]]]]]; rewrite Shake256x4.sha3forE /#.
conseq a136_dumpstate_avx2x4_fips202
  (X4_136.dumpstate_avx2x4_h b0 b1 b2 b3 0 136 s) => [&1 /> * | &1 &2 -> />].
- by exists arg{1} => /#.
move=> h0 h1 h2 h3 _ l ge0l ltl4.
have hl : forall (b : W8.t Array136.t),
  to_list (fill ("_.[_]" (stbytes (st4x_get s l))) 0 136 b)
  = Shake256x4.shake256_slice data.[l] (136 * k) 136.
- move=> b; rewrite /to_list /Shake256x4.shake256_slice /Xof.slice.
  apply eq_in_mkseq => j rgj /=; rewrite Array136.filliE // rgj /= shake256_xofE 1:/#.
  by rewrite (sha3_lane_block 136 data.[l] k j) //; have := h l _; rewrite // Array4.mapiE.
have : l = 0 \/ l = 1 \/ l = 2 \/ l = 3 by smt().
by case=> [|[|[|]]] ->> /=; rewrite ?h0 ?h1 ?h2 ?h3 hl.
qed.

(* -------------------------------------------------------------------- *)
lemma shake256_squeezeblock4xP (data : W8.t list Array4.t) (k : int) :
hoare[
  M.shake256_squeezeblock4x :
      0 <= k /\ Shake256x4.(\sha3for) state (Array4.map (mk_read (136 * k)) data)
    ==>
         Shake256x4.(\sha3for) res.`1 (Array4.map (mk_read (136 * (k + 1))) data)
      /\ (forall i, 0 <= i < 4 =>
            Array136.to_list (nth witness [res.`2; res.`3; res.`4; res.`5] i)
            = Shake256x4.shake256_slice data.[i] (136 * k) 136)
  ].
proof.
proc.
seq 1 : (0 <= k /\ Shake256x4.(\sha3for) state (Array4.map (mk_read (136 * (k + 1))) data)).
- by call (keccakf1600_avx2x4_256P data k); auto.
by sp; call (dumpstate_avx2x4_256P data k); auto.
qed.

(* -------------------------------------------------------------------- *)
(* the 66-byte absorb of the mask / error-vector samplers: the four     *)
(* lanes absorb rho' followed by the consecutive domain separators      *)
lemma shake256_absorb_66_4xP (rho_ : W8.t Array64.t) (ds0 : W16.t) :
hoare[
  M.shake256_absorb_66_4x :
      rho_prime = rho_ /\ starting_domain_separator = ds0
    ==>
      Shake256x4.(\sha3for) res
        (Array4.map (fun w => mk_absorbed (to_list rho_ ++ W2u8.to_list w))
          (Array4.init (fun i => ds0 + W16.of_int i)))
  ].
proof.
proc.
(* state initialization *)
seq 5 : (rho_prime = rho_ /\ starting_domain_separator = ds0 /\
         Shake256x4.(\sha3for) state (Array4.init (fun _ => mk_absorbing []))).
- by call state_init_avx2x4_256P; auto.
(* rho' is absorbed identically into the four lanes *)
seq 1 : (starting_domain_separator = ds0 /\
         Shake256x4.(\sha3for) state
           (Array4.init (fun _ => mk_absorbing (to_list rho_)))).
- by call (absorb_bcast_avx2x4_256P rho_); auto.
(* the four consecutive domain separators are marshaled to byte pairs *)
seq 8 : (Shake256x4.(\sha3for) state
           (Array4.init (fun _ => mk_absorbing (to_list rho_)))
         /\ to_list d0 = W2u8.to_list (ds0 + W16.of_int 0)
         /\ to_list d1 = W2u8.to_list (ds0 + W16.of_int 1)
         /\ to_list d2 = W2u8.to_list (ds0 + W16.of_int 2)
         /\ to_list d3 = W2u8.to_list (ds0 + W16.of_int 3)).
- by auto=> &hr |> hst; rewrite ?pack2_set16_to_listE //= ?pack2_to_listE //=.
(* the final absorb completes each lane's stream *)
call (absorb_2_final_avx2x4_256P (to_list rho_)
        (Array4.init (fun i => ds0 + W16.of_int i))).
by skip => &hr |> hst h0 h1 h2 h3; rewrite Array64.size_to_list.
qed.

(* ==================================================================== *)
(* Single-lane SHAKE256 (the tail lane of the mask sampler): the same   *)
(* [shake256_xof] oracle as the four-lane instance, so the single lane  *)
(* reads exactly the streams the staged lanes read.  [read] counts the  *)
(* bytes made available by the permutations run so far: a state at      *)
(* [mk_read (136 * (k + 1))] dumps block [k].                           *)

op [opaque] (\sha3one) (st : W64.t Array25.t) (s : sha3_state) : bool =
  sha3_lane 136 st s.

lemma sha3oneE (st : W64.t Array25.t) (s : sha3_state) :
  st \sha3one s <=> sha3_lane 136 st s.
proof. by rewrite /(\sha3one). qed.

(* -------------------------------------------------------------------- *)
(* the single-lane Keccak primitives (SHAKE256 flavor)                  *)

lemma state_init_256P :
  hoare[ M.__state_init : true ==> res \sha3one mk_absorbing [] ].
proof.
conseq state_init_fips202 (state_init_h 136) => [&1 _ | &1 &2 ->]; 1: by exists arg{1}.
by rewrite sha3oneE /sha3_lane /mk_absorbing /= pabsorb_spec_refE.
qed.

lemma absorb_64_256P (rho_ : W8.t Array64.t) :
  hoare[ M.a64____absorb :
       st \sha3one mk_absorbing []
    /\ buf = rho_ /\ aT = 0 /\ _TRAILB = 0 /\ _RATE8 = 136
    ==> res.`1 \sha3one mk_absorbing (to_list rho_) ].
proof.
conseq a64_absorb_fips202 (Ref64.absorb_h [] rho_ 0 136).
- move=> &1 [+ [hb [ha [ht hr]]]]; rewrite sha3oneE /sha3_lane /mk_absorbing /= => -[_ hst].
  by exists arg{1}; rewrite ha hb ht hr pabsorb_spec_refE.
move=> &1 &2 -> /= [+ _]; rewrite sha3oneE /sha3_lane /mk_absorbing /= pabsorb_spec_refE => ->.
by rewrite size_to_list.
qed.

lemma absorb_2_final_256P (pre_ bs_ : W8.t list) :
  hoare[ M.a2____absorb :
       st \sha3one mk_absorbing pre_
    /\ to_list buf = bs_
    /\ aT = size pre_ /\ _TRAILB = 31 /\ _RATE8 = 136
    ==> res.`1 \sha3one mk_absorbed (pre_ ++ bs_) ].
proof.
exlim buf => b; case: (to_list b = bs_) => [<<- | hb]; last by conseq (_ : false ==> _) => // /#.
conseq a2_absorb_fips202 (Ref2.absorb_h pre_ b 31 136).
- move=> &1 [-> [+ [_ [ha [ht hr]]]]]; rewrite sha3oneE /sha3_lane /mk_absorbing /= => -[hsz hst].
  by exists arg{1}; rewrite ha ht hr pabsorb_spec_refE hst /= pmod_small // size_ge0.
move=> &1 &2 ->; rewrite ifT // => ->.
by rewrite sha3oneE /sha3_lane /mk_absorbed /= iter0.
qed.

lemma absorb_commitment_hash_256P (ct_ : W8.t Array_ctilde.t) :
  hoare[ M.a_COMMITMENT_HASH____absorb :
       st \sha3one mk_absorbing []
    /\ buf = ct_ /\ aT = 0 /\ _TRAILB = 31 /\ _RATE8 = 136
    ==> res.`1 \sha3one mk_absorbed (to_list ct_) ].
proof.
conseq act_absorb_fips202 (RefCt.absorb_h [] ct_ 31 136).
- move=> &1 [+ [hb [ha [ht hr]]]]; rewrite sha3oneE /sha3_lane /mk_absorbing /= => -[_ hst].
  by exists arg{1}; rewrite ha hb ht hr pabsorb_spec_refE hst.
move=> &1 &2 ->; rewrite ifT // => ->.
by rewrite sha3oneE /sha3_lane /mk_absorbed /= iter0.
qed.

lemma keccakf1600_256P (n : W8.t list) (k : int) :
  hoare[ M._keccakf1600 :
       0 <= k /\ a \sha3one mk_read (136 * k) n
    ==> res \sha3one mk_read (136 * (k + 1)) n ].
proof.
case: (0 <= k) => hk; last by conseq (_ : false ==> _) => // /#.
conseq keccakf1600_fips202
  (keccakf1600_h (iter k keccak_f1600_op (ABSORB1600 Keccak1600_Spec.SHAKE_DS_BYTE 136 n)))
  => [&1 [_] | &1 &2 -> ->].
- rewrite sha3oneE /sha3_lane /mk_read /= mulzC mulzK // => ->.
  by exists (iter k keccak_f1600_op (ABSORB1600 Keccak1600_Spec.SHAKE_DS_BYTE 136 n)).
by rewrite sha3oneE /sha3_lane /mk_read /= mulzC mulzK // iterS.
qed.

lemma dumpstate_256P (n : W8.t list) (k : int) :
  hoare[ M.a136____dumpstate :
       0 <= k /\ st \sha3one mk_read (136 * (k + 1)) n
    /\ offset = 0 /\ _LEN = 136
    ==> Array136.to_list res.`1 = Shake256x4.shake256_slice n (136 * k) 136 ].
proof.
case: (0 <= k) => hk; last by conseq (_ : false ==> _) => // /#.
exlim buf => b.
conseq a136_dumpstate_fips202
  (Ref136.dumpstate_h b 0 136
     (iter (k + 1) keccak_f1600_op (ABSORB1600 Keccak1600_Spec.SHAKE_DS_BYTE 136 n))).
- move=> &1 [-> [_ [+ [ho hl]]]]; rewrite sha3oneE /sha3_lane /mk_read /= mulzC mulzK // => hst.
  by exists arg{1}; rewrite ho hl hst.
move=> &1 &2 -> [-> _]; rewrite /to_list /Shake256x4.shake256_slice /Xof.slice.
apply eq_in_mkseq => i rgi /=; rewrite Array136.filliE // rgi /= shake256_xofE 1:/#.
by rewrite (sha3_lane_block 136 n k i) // /sha3_lane /mk_read /= mulzC mulzK.
qed.

(* -------------------------------------------------------------------- *)
(* the sponge state crosses the hashing boundary in the first 25 words  *)
(* of a 28-word buffer                                                   *)

op lanes_of (st : W64.t Array28.t) : W64.t Array25.t =
  Array25.init (fun i => st.[i]).

lemma lanes_of_store (st : W64.t Array28.t) (l : W64.t Array25.t) :
  lanes_of (Array28.init (fun i => if 0 <= i < 0 + 25 then l.[i - 0] else st.[i])) = l.
proof.
rewrite Array25.tP => i hi; rewrite /lanes_of !initiE //=.
by rewrite initiE 1:/# /= ifT 1:/#.
qed.

(* -------------------------------------------------------------------- *)
(* the single-lane sponge procedures                                    *)

lemma shake256_squeezeblockP (n : W8.t list) (k : int) :
  hoare[ M.shake256_squeezeblock :
      0 <= k /\ lanes_of st \sha3one mk_read (136 * k) n
    ==> lanes_of res.`1 \sha3one mk_read (136 * (k + 1)) n
     /\ Array136.to_list res.`2 = Shake256x4.shake256_slice n (136 * k) 136 ].
proof.
proc; inline M.__KECCAK_F.
rcondf 6; 1: by auto => />; rewrite (: 255 = 2^8 - 1) // W256.and_mod.
ecall (dumpstate_256P n k); wp; ecall (keccakf1600_256P n k); auto => &hr |> h0 hst r0 hr0.
by have := lanes_of_store st{hr} hr0; rewrite /lanes_of /= => ->.
qed.

(* -------------------------------------------------------------------- *)
(* the 66-byte absorb: rho' followed by one domain separator            *)
lemma shake256_absorb_66P (rho_ : W8.t Array64.t) (ds_ : W16.t) :
hoare[ M.shake256_absorb_66 :
    rho_prime = rho_ /\ domain_separator = ds_
  ==> lanes_of res \sha3one mk_absorbed (to_list rho_ ++ W2u8.to_list ds_) ].
proof.
proc; inline M.__KECCAK_F.
rcondf 8; 1: by auto => />; rewrite (: 255 = 2^8 - 1) // W256.and_mod.
wp; ecall (absorb_2_final_256P (to_list rho_) (W2u8.to_list ds_)).
ecall (absorb_64_256P rho_); call state_init_256P.
by auto => &hr |> r0 h0 r1 h1; rewrite pack2_set16_to_listE Array64.size_to_list /= => r2 h2; rewrite lanes_of_store.
qed.

(* -------------------------------------------------------------------- *)
(* the 48-byte absorb of the commitment hash (SampleInBall's seed)       *)
lemma shake256_absorb_commitment_hashP (ct_ : W8.t Array_ctilde.t) :
hoare[ M.shake256_absorb_commitment_hash :
    commitment_hash = ct_ ==> lanes_of res \sha3one mk_absorbed (to_list ct_) ].
proof.
proc; inline M.__KECCAK_F.
rcondf 6; 1: by auto => />; rewrite (: 255 = 2^8 - 1) // W256.and_mod.
wp; ecall (absorb_commitment_hash_256P ct_); call state_init_256P.
by auto => &hr |> r0 h0 r1 h1; rewrite lanes_of_store.
qed.

(* ==================================================================== *)
(* The stream slices are prefixes of the specification's SHAKE output   *)
(* ==================================================================== *)
lemma shake128_sliceE (m : W8.t list) (len : int) :
  0 <= len => shake128_slice m 0 len = Keccak1600_Spec.SHAKE128 m len.
proof.
move=> ge0_len; rewrite /shake128_slice /Xof.slice /=.
apply (eq_from_nth witness); rewrite size_mkseq StdOrder.IntOrder.ler_maxr //.
- by rewrite Keccak1600_Spec.size_SHAKE128.
move=> i rgi; rewrite nth_mkseq //= /shake128_xof.
by rewrite (Keccak1600_Spec.SHAKE128_ext m (i + 1) len) 1:/# nth_take /#.
qed.

lemma shake256_sliceE (m : W8.t list) (len : int) :
  0 <= len => Shake256x4.shake256_slice m 0 len = Keccak1600_Spec.SHAKE256 m len.
proof.
move=> ge0_len; rewrite /Shake256x4.shake256_slice /Xof.slice /=.
apply (eq_from_nth witness); rewrite size_mkseq StdOrder.IntOrder.ler_maxr //.
- by rewrite Keccak1600_Spec.size_SHAKE256.
move=> i rgi; rewrite nth_mkseq //= /shake256_xof.
by rewrite (Keccak1600_Spec.SHAKE256_ext m (i + 1) len) 1:/# nth_take /#.
qed.

(* ==================================================================== *)
(* The extracted Keccak primitives are lossless, as their FIPS 202      *)
(* counterparts are.  Registered as [lossless] hints, so that           *)
(* [islossless] stops at them.                                          *)
(* ==================================================================== *)
lemma __state_init_ll : islossless M.__state_init.
proof. by conseq state_init_fips202 state_init_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : __state_init_ll.

lemma __state_init_avx2_ll : islossless M.__state_init_avx2.
proof. by conseq state_init_avx2_fips202 state_init_avx2_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : __state_init_avx2_ll.

lemma __state_init_avx2x4_ll : islossless M.__state_init_avx2x4.
proof. by conseq state_init_avx2x4_fips202 state_init_avx2x4_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : __state_init_avx2x4_ll.

lemma _keccakf1600_ll : islossless M._keccakf1600.
proof. by conseq keccakf1600_fips202 keccakf1600_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : _keccakf1600_ll.

lemma _keccakf1600_avx2_ll : islossless M._keccakf1600_avx2.
proof. by conseq keccakf1600_avx2_fips202 keccakf1600_avx2_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : _keccakf1600_avx2_ll.

lemma _keccakf1600_avx2x4_ll : islossless M._keccakf1600_avx2x4.
proof. by conseq keccakf1600_avx2x4_fips202 keccakf1600_avx2x4_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : _keccakf1600_avx2x4_ll.

lemma a2____absorb_ll : islossless M.a2____absorb.
proof. by conseq a2_absorb_fips202 Ref2.absorb_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a2____absorb_ll.

lemma a64____absorb_ll : islossless M.a64____absorb.
proof. by conseq a64_absorb_fips202 Ref64.absorb_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a64____absorb_ll.

lemma a2____absorb_avx2_ll : islossless M.a2____absorb_avx2.
proof. by conseq a2_absorb_avx2_fips202 Avx2_2.absorb_avx2_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a2____absorb_avx2_ll.

lemma a64____absorb_avx2_ll : islossless M.a64____absorb_avx2.
proof. by conseq a64_absorb_avx2_fips202 Avx2_64.absorb_avx2_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a64____absorb_avx2_ll.

lemma a_COMMITMENT_HASH____absorb_ll : islossless M.a_COMMITMENT_HASH____absorb.
proof. by conseq act_absorb_fips202 RefCt.absorb_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a_COMMITMENT_HASH____absorb_ll.

lemma a_COMMITMENT_HASH____absorb_avx2_ll : islossless M.a_COMMITMENT_HASH____absorb_avx2.
proof. by conseq act_absorb_avx2_fips202 Avx2_Ct.absorb_avx2_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a_COMMITMENT_HASH____absorb_avx2_ll.

lemma a2____absorb_avx2x4_ll : islossless M.a2____absorb_avx2x4.
proof. by conseq a2_absorb_avx2x4_fips202 X4_2.absorb_avx2x4_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a2____absorb_avx2x4_ll.

lemma a32____absorb_bcast_avx2x4_ll : islossless M.a32____absorb_bcast_avx2x4.
proof. by conseq a32_absorb_bcast_avx2x4_fips202 X4_32.absorb_bcast_avx2x4_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a32____absorb_bcast_avx2x4_ll.

lemma a64____absorb_bcast_avx2x4_ll : islossless M.a64____absorb_bcast_avx2x4.
proof. by conseq a64_absorb_bcast_avx2x4_fips202 X4_64.absorb_bcast_avx2x4_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a64____absorb_bcast_avx2x4_ll.

lemma a136____dumpstate_ll : islossless M.a136____dumpstate.
proof. by conseq a136_dumpstate_fips202 Ref136.dumpstate_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a136____dumpstate_ll.

lemma a136____dumpstate_avx2_ll : islossless M.a136____dumpstate_avx2.
proof. by conseq a136_dumpstate_avx2_fips202 Avx2_136.dumpstate_avx2_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a136____dumpstate_avx2_ll.

lemma a136____dumpstate_avx2x4_ll : islossless M.a136____dumpstate_avx2x4.
proof. by conseq a136_dumpstate_avx2x4_fips202 X4_136.dumpstate_avx2x4_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a136____dumpstate_avx2x4_ll.

lemma a168____dumpstate_avx2x4_ll : islossless M.a168____dumpstate_avx2x4.
proof. by conseq a168_dumpstate_avx2x4_fips202 X4_168.dumpstate_avx2x4_ll => // &1 _; exists arg{1}. qed.
hint solve 0 lossless : a168____dumpstate_avx2x4_ll.

end Sha3x4T.
