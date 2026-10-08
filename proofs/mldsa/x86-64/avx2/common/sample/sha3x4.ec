(* -------------------------------------------------------------------- *)
(* The interleaved 4-lane SHA-3 sponge abstraction shared by the ML-DSA *)
(* samplers.                                                            *)
(*                                                                      *)
(* A lane is described logically by the bytes it has absorbed and how   *)
(* many output bytes have been consumed ([sha3_state]); the abstract    *)
(* relation [\sha3for] of the parametric theory [Xof4x] links the       *)
(* concrete interleaved state to four such descriptions.  The output    *)
(* stream is [Xof.slice] of an abstract byte oracle, so the size/cat    *)
(* properties of stream slices are lemmas, not axioms.                  *)
(*                                                                      *)
(* The theory is instantiated for SHAKE128 (rate 168) and SHAKE256      *)
(* (rate 136); below each instance sit the admitted specifications of   *)
(* the extracted Keccak primitives (the trust boundary towards the      *)
(* formosa-keccak development) and the proved block-squeeze and absorb  *)
(* wrappers built on them.                                              *)

require import AllCore List IntDiv.
require Xof.

from Jasmin require import JWord JUtils JArray.
from JazzEC require import Ml_dsa_65_avx2.

require import Array4 Array7 Array25 Array28 Array32 Array64 Array136 Array168.
require import Array2 WArray2 WArray224.
require import Avx2red.

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
abstract theory Xof4x.

op rate : int.
axiom gt0_rate : 0 < rate.

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
op (\sha3for) : sha3x4 -> sha3x4_state -> bool.

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

end Xof4x.

(* ==================================================================== *)
(* SHAKE128, rate 168                                                   *)

op shake128_xof : W8.t list -> int -> W8.t.

clone import Xof4x as Shake128x4 with
      op rate <- 168,
      op xof  <- shake128_xof,
  theory AB   <- Array168

  rename "slice" as "shake128_slice"

  proof gt0_rate by done.

(* -------------------------------------------------------------------- *)
(* Keccak-level trust boundary (SHAKE128 flavor): the extracted         *)
(* interleaved-sponge primitives, specified against [\sha3for].         *)

lemma state_init_avx2x4_128P :
  hoare[ M.__state_init_avx2x4 :
    true ==> res \sha3for Array4.init (fun _ => mk_absorbing []) ].
proof. admitted. (* Keccak trust boundary *)

lemma absorb_bcast_avx2x4_128P (rho_ : W8.t Array32.t) :
  hoare[ M.a32____absorb_bcast_avx2x4 :
       st \sha3for Array4.init (fun _ => mk_absorbing [])
    /\ buf = rho_ /\ aT = 0 /\ _TRAILB = 0 /\ _RATE8 = 168
    ==> res.`1 \sha3for Array4.init (fun _ => mk_absorbing (to_list rho_)) ].
proof. admitted. (* Keccak trust boundary *)

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
proof. admitted. (* Keccak trust boundary *)

lemma keccakf1600_avx2x4_128P (data : W8.t list Array4.t) (k : int) :
  hoare[ M._keccakf1600_avx2x4 :
       0 <= k /\ a \sha3for Array4.map (mk_read (168 * k)) data
    ==> res \sha3for Array4.map (mk_read (168 * (k + 1))) data ].
proof. admitted. (* Keccak trust boundary *)

lemma dumpstate_avx2x4_128P (data : W8.t list Array4.t) (k : int) :
  hoare[ M.a168____dumpstate_avx2x4 :
       0 <= k /\ st \sha3for Array4.map (mk_read (168 * (k + 1))) data
    /\ offset = 0 /\ _LEN = 168
    ==> forall i, 0 <= i < 4 =>
          Array168.to_list (nth witness [res.`1; res.`2; res.`3; res.`4] i)
          = shake128_slice data.[i] (168 * k) 168 ].
proof. admitted. (* Keccak trust boundary *)

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

op shake256_xof : W8.t list -> int -> W8.t.

clone Xof4x as Shake256x4 with
      op rate <- 136,
      op xof  <- shake256_xof,
  theory AB   <- Array136

  rename "slice" as "shake256_slice"

  proof gt0_rate by done.

(* -------------------------------------------------------------------- *)
(* Keccak-level trust boundary (SHAKE256 flavor)                        *)

lemma state_init_avx2x4_256P :
  hoare[ M.__state_init_avx2x4 :
    true ==> Shake256x4.(\sha3for) res (Array4.init (fun _ => mk_absorbing [])) ].
proof. admitted. (* Keccak trust boundary *)

lemma absorb_bcast_avx2x4_256P (rho_ : W8.t Array64.t) :
  hoare[ M.a64____absorb_bcast_avx2x4 :
       Shake256x4.(\sha3for) st (Array4.init (fun _ => mk_absorbing []))
    /\ buf = rho_ /\ aT = 0 /\ _TRAILB = 0 /\ _RATE8 = 136
    ==> Shake256x4.(\sha3for) res.`1
          (Array4.init (fun _ => mk_absorbing (to_list rho_))) ].
proof. admitted. (* Keccak trust boundary *)

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
proof. admitted. (* Keccak trust boundary *)

lemma keccakf1600_avx2x4_256P (data : W8.t list Array4.t) (k : int) :
  hoare[ M._keccakf1600_avx2x4 :
       0 <= k /\ Shake256x4.(\sha3for) a (Array4.map (mk_read (136 * k)) data)
    ==> Shake256x4.(\sha3for) res (Array4.map (mk_read (136 * (k + 1))) data) ].
proof. admitted. (* Keccak trust boundary *)

lemma dumpstate_avx2x4_256P (data : W8.t list Array4.t) (k : int) :
  hoare[ M.a136____dumpstate_avx2x4 :
       0 <= k /\ Shake256x4.(\sha3for) st (Array4.map (mk_read (136 * (k + 1))) data)
    /\ offset = 0 /\ _LEN = 136
    ==> forall i, 0 <= i < 4 =>
          Array136.to_list (nth witness [res.`1; res.`2; res.`3; res.`4] i)
          = Shake256x4.shake256_slice data.[i] (136 * k) 136 ].
proof. admitted. (* Keccak trust boundary *)

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

op (\sha3one) : W256.t Array7.t -> sha3_state -> bool.

(* -------------------------------------------------------------------- *)
(* Keccak-level trust boundary (single-lane SHAKE256 flavor)            *)

lemma state_init_avx2_256P :
  hoare[ M.__state_init_avx2 : true ==> res \sha3one mk_absorbing [] ].
proof. admitted. (* Keccak trust boundary *)

lemma absorb_64_avx2_256P (rho_ : W8.t Array64.t) :
  hoare[ M.a64____absorb_avx2 :
       st \sha3one mk_absorbing []
    /\ buf = rho_ /\ aT = 0 /\ _TRAILB = 0 /\ _RATE8 = 136
    ==> res.`1 \sha3one mk_absorbing (to_list rho_) ].
proof. admitted. (* Keccak trust boundary *)

lemma absorb_2_final_avx2_256P (pre_ bs_ : W8.t list) :
  hoare[ M.a2____absorb_avx2 :
       st \sha3one mk_absorbing pre_
    /\ to_list buf = bs_
    /\ aT = size pre_ /\ _TRAILB = 31 /\ _RATE8 = 136
    ==> res.`1 \sha3one mk_absorbed (pre_ ++ bs_) ].
proof. admitted. (* Keccak trust boundary *)

lemma keccakf1600_avx2_256P (n : W8.t list) (k : int) :
  hoare[ M._keccakf1600_avx2 :
       0 <= k /\ state \sha3one mk_read (136 * k) n
    ==> res \sha3one mk_read (136 * (k + 1)) n ].
proof. admitted. (* Keccak trust boundary *)

lemma dumpstate_avx2_256P (n : W8.t list) (k : int) :
  hoare[ M.a136____dumpstate_avx2 :
       0 <= k /\ st \sha3one mk_read (136 * (k + 1)) n
    /\ offset = 0 /\ _LEN = 136
    ==> Array136.to_list res.`1 = Shake256x4.shake256_slice n (136 * k) 136 ].
proof. admitted. (* Keccak trust boundary *)

(* -------------------------------------------------------------------- *)
(* the sponge state crosses the hashing boundary as 28 64-bit words     *)

op load_state (st : W64.t Array28.t) : W256.t Array7.t =
  Array7.init (fun i => get256_direct (WArray224.init64 (fun j => st.[j])) (32 * i)).

lemma load_shake256_stateP (st_ : W64.t Array28.t) :
  hoare[ M.__load_shake256_state : st = st_ ==> res = load_state st_ ].
proof.
proc.
while (st = st_ /\ 0 <= i <= 7
    /\ forall k, 0 <= k < i => state.[k] = (load_state st_).[k]).
- auto => &hr |> h0 _ hk hi; split; 1: smt().
  move=> k hk0 hk1; rewrite get_setE 1:/#.
  case: (k = i{hr}) => [->|hne]; 1: by rewrite /load_state initiE 1:/#.
  by rewrite hk /#.
auto => &hr |>; split; 1: smt().
move=> i state hi _ _ hk; rewrite tP => k hk'; smt().
qed.

lemma init64_get64K (t : WArray224.t) :
  WArray224.init64 (fun j => (Array28.init (fun i => WArray224.get64 t i)).[j]) = t.
proof.
rewrite WArray224.tP => b hb.
rewrite /init64 WArray224.initiE 1:// /= Array28.initiE 1:/# /=.
rewrite get64E pack8bE 1:/# W8u8.Pack.initiE 1:/# /=.
by rewrite {3}(divz_eq b 8) mulzC.
qed.

lemma store_shake256_stateP (s : W256.t Array7.t) :
  hoare[ M.__store_shake256_state : state = s ==> load_state res = s ].
proof.
proc.
while (state = s /\ 0 <= i <= 7
    /\ forall k, 0 <= k < i => (load_state st).[k] = s.[k]).
- auto => &hr |> h0 _ hk hi; split; 1: smt().
  move=> k hk0 hk1; rewrite /load_state initiE 1:/# /= init64_get64K get_set256E 1,2:/#.
  case: (k = i{hr}) => [-> //|hne].
  by move: (hk k _); [smt() | rewrite /load_state initiE 1:/#].
auto => &hr |>; split; 1: smt().
move=> i st hi _ _ hk; rewrite tP => k hk'; smt().
qed.

(* -------------------------------------------------------------------- *)
(* proved wrappers over the trust boundary                              *)

lemma shake256_squeezeblockP (n : W8.t list) (k : int) :
  hoare[ M.shake256_squeezeblock :
      0 <= k /\ load_state st \sha3one mk_read (136 * k) n
    ==> load_state res.`1 \sha3one mk_read (136 * (k + 1)) n
     /\ Array136.to_list res.`2 = Shake256x4.shake256_slice n (136 * k) 136 ].
proof.
proc; inline M.__KECCAK_F.
rcondt 6; 1: by auto => />; rewrite (: 255 = 2^8 - 1) // W256.and_mod.
ecall (dumpstate_avx2_256P n k); wp; ecall (store_shake256_stateP state).
ecall (keccakf1600_avx2_256P n k); ecall (load_shake256_stateP st).
by auto => &hr |> h0 hst r0 hr0 r1 hr1 r2 ->.
qed.

(* -------------------------------------------------------------------- *)
(* the 66-byte absorb: rho' followed by one domain separator            *)
lemma shake256_absorb_66P (rho_ : W8.t Array64.t) (ds_ : W16.t) :
hoare[ M.shake256_absorb_66 :
    rho_prime = rho_ /\ domain_separator = ds_
  ==> load_state res \sha3one mk_absorbed (to_list rho_ ++ W2u8.to_list ds_) ].
proof.
proc; inline M.__KECCAK_F.
rcondt 8; 1: by auto => />; rewrite (: 255 = 2^8 - 1) // W256.and_mod.
ecall (store_shake256_stateP state).
ecall (absorb_2_final_avx2_256P (to_list rho_) (W2u8.to_list ds_)).
ecall (absorb_64_avx2_256P rho_); call state_init_avx2_256P.
auto => &hr |> r0 h0 r1 h1; rewrite pack2_set16_to_listE Array64.size_to_list /= => r2 h2 r3 ->.
exact h2.
qed.
