(* -------------------------------------------------------------------- *)
(* Keccak-f[1600] is a permutation                                      *)
(*                                                                      *)
(* Each step of a round is injective: iota xors a constant, rho and pi  *)
(* rotate lanes and move them around, chi is a bijection on every row,  *)
(* and theta's kernel is trivial because the column-parity map          *)
(* c |-> c ^ D(c) is.  The state space being finite, every state is     *)
(* periodic under keccak_f1600_op (Periodic.injective_periodic).        *)
(* -------------------------------------------------------------------- *)
require import AllCore List Int IntDiv Finite.
require import Keccakf1600_Spec.
require import Periodic.
require import CircuitBindings.

(* -------------------------------------------------------------------- *)
(* word-level facts, by bit-blasting                                    *)
lemma theta_parity_inj (c0 c1 c2 c3 c4 : W64.t) :
     c0 = c4 `^` (c1 `|<<<|` 1)
  => c1 = c0 `^` (c2 `|<<<|` 1)
  => c2 = c1 `^` (c3 `|<<<|` 1)
  => c3 = c2 `^` (c4 `|<<<|` 1)
  => c4 = c3 `^` (c0 `|<<<|` 1)
  => c0 = W64.zero /\ c1 = W64.zero /\ c2 = W64.zero /\ c3 = W64.zero /\ c4 = W64.zero.
proof. circuit. qed.

lemma chi_row_inj (b0 b1 b2 b3 b4 c0 c1 c2 c3 c4 : W64.t) :
     b0 `^` (invw b1 `&` b2) = c0 `^` (invw c1 `&` c2)
  => b1 `^` (invw b2 `&` b3) = c1 `^` (invw c2 `&` c3)
  => b2 `^` (invw b3 `&` b4) = c2 `^` (invw c3 `&` c4)
  => b3 `^` (invw b4 `&` b0) = c3 `^` (invw c4 `&` c0)
  => b4 `^` (invw b0 `&` b1) = c4 `^` (invw c0 `&` c1)
  => b0 = c0 /\ b1 = c1 /\ b2 = c2 /\ b3 = c3 /\ b4 = c4.
proof. circuit. qed.

lemma xor_move (a b da db : W64.t) : a `^` da = b `^` db => a `^` b = da `^` db.
proof. circuit. qed.

lemma xor5_par (a0 a1 a2 a3 a4 b0 b1 b2 b3 b4 d : W64.t) :
  a0 `^` b0 = d => a1 `^` b1 = d => a2 `^` b2 = d => a3 `^` b3 = d => a4 `^` b4 = d =>
  (a0 `^` a1 `^` a2 `^` a3 `^` a4) `^` (b0 `^` b1 `^` b2 `^` b3 `^` b4) = d.
proof. circuit. qed.

lemma xor_rol_diff (p q r s : W64.t) :
  (p `^` (q `|<<<|` 1)) `^` (r `^` (s `|<<<|` 1)) = (p `^` r) `^` ((q `^` s) `|<<<|` 1).
proof. circuit. qed.

lemma xor_eq0 (a b : W64.t) : a `^` b = W64.zero => a = b.
proof. circuit. qed.

lemma rol64_inj (x y : W64.t) (k : int) : x `|<<<|` k = y `|<<<|` k => x = y.
proof.
move=> h; apply W64.wordP => i rgi.
have := congr1 (fun w : W64.t => w.[(i + k) %% 64]) _ _ h => /=.
rewrite (_ : 0 <= (i + k) %% 64 < 64) 1:/# /=.
by rewrite modzDml (_ : i + k - k = i) 1:#ring pmod_small.
qed.

(* -------------------------------------------------------------------- *)
(* the steps of a round are injective                                   *)
lemma iota_inj c (a b : state) : keccak_iota_op c a = keccak_iota_op c b => a = b.
proof.
rewrite /keccak_iota_op => h; apply Array25.tP => i rgi.
have := congr1 (fun s : state => s.[i]) _ _ h => /=.
rewrite !Array25.get_setE //; case: (i = 0) => [->> /= |//].
by move=> h0; have := congr1 (fun w => w `^` c) _ _ h0; rewrite /= -!W64.xorwA !W64.xorwK !W64.xorw0.
qed.

lemma chi_inj (a b : state) : keccak_chi_op a = keccak_chi_op b => a = b.
proof.
move=> h.
have hrow : forall y, 0 <= y < 5 =>
  forall x, 0 <= x < 5 => a.[x + 5 * y] = b.[x + 5 * y].
- move=> y rgy.
  have e : forall x, 0 <= x < 5 =>
       a.[x + 5 * y] `^` (invw a.[(x + 1) %% 5 + 5 * y] `&` a.[(x + 2) %% 5 + 5 * y])
     = b.[x + 5 * y] `^` (invw b.[(x + 1) %% 5 + 5 * y] `&` b.[(x + 2) %% 5 + 5 * y]).
  + move=> x rgx; have := congr1 (fun s : state => s.[x + 5 * y]) _ _ h.
    rewrite /= /keccak_chi_op /init_25_64 !Array25.initiE 1,2:/# /=.
    by rewrite (_ : (x + 5 * y) %% 5 = x) 1:/# (_ : (x + 5 * y) %/ 5 = y) 1:/# (_ : y %% 5 = y) 1:/# (_ : x %% 5 = x) 1:/#.
  have := chi_row_inj _ _ _ _ _ _ _ _ _ _ (e 0 _) (e 1 _) (e 2 _) (e 3 _) (e 4 _) => //=.
  move=> [h0 [h1 [h2 [h3 h4]]]] x rgx.
  have hx : x = 0 \/ x = 1 \/ x = 2 \/ x = 3 \/ x = 4 by smt().
  by case: hx => [|[|[|[|]]]] ->.
apply Array25.tP => i rgi.
have := hrow (i %/ 5) _ (i %% 5) _; 1,2: smt().
by rewrite (_ : i %% 5 + 5 * (i %/ 5) = i) 1:#smt:(divz_eq).
qed.

lemma rho_inj (a b : state) : keccak_rho_op a = keccak_rho_op b => a = b.
proof.
rewrite /keccak_rho_op => h; apply Array25.tP => i rgi.
have := congr1 (fun s : state => s.[i]) _ _ h => /=.
by rewrite /init_25_64 !Array25.initiE //=; apply rol64_inj.
qed.

lemma pi_inj (a b : state) : keccak_pi_op a = keccak_pi_op b => a = b.
proof.
rewrite /keccak_pi_op => h; apply Array25.tP => j rgj.
pose src := fun i => let (x, y) = invidx i in idx (x + 3 * y, x).
have hall : all (fun j => j \in map src (iota_ 0 25)) (iota_ 0 25).
- by rewrite -iotaredE /src /idx /=.
have /mapP [i [/mem_iota rgi ->]] : j \in map src (iota_ 0 25).
- move: hall; rewrite allP => hall.
  by have /= := hall j _; [rewrite mem_iota /# | done].
have := congr1 (fun s : state => s.[i]) _ _ h => /=.
by rewrite /init_25_64 !Array25.initiE /#.
qed.

lemma keccak_DE (C : W64.t Array5.t) (x : int) : 0 <= x < 5 =>
  (keccak_D C).[x] = C.[(x - 1) %% 5] `^` (C.[(x + 1) %% 5] `|<<<|` 1).
proof. by move=> rgx; rewrite /keccak_D /init_5_64 Array5.initiE. qed.

lemma keccak_CE (A : state) (x : int) : 0 <= x < 5 =>
  (keccak_C A).[x] = A.[x] `^` A.[x + 5] `^` A.[x + 10] `^` A.[x + 15] `^` A.[x + 20].
proof. by move=> rgx; rewrite /keccak_C /init_5_64 Array5.initiE. qed.

(* theta: the difference of two preimages is constant along columns,    *)
(* and its column parity is in the (trivial) kernel of c |-> c ^ D(c)    *)
lemma theta_inj (a b : state) : keccak_theta_op a = keccak_theta_op b => a = b.
proof.
move=> h.
pose c := fun x => (keccak_C a).[x] `^` (keccak_C b).[x].
pose d := fun x => (keccak_D (keccak_C a)).[x] `^` (keccak_D (keccak_C b)).[x].
have hlane : forall i, 0 <= i < 25 => a.[i] `^` b.[i] = d (i %% 5).
- move=> i rgi; have := congr1 (fun s : state => s.[i]) _ _ h.
  by rewrite /= /keccak_theta_op /init_25_64 !Array25.initiE //=; apply xor_move.
have hc : forall x, 0 <= x < 5 => c x = d x.
- move=> x rgx; rewrite /c !keccak_CE //.
  apply xor5_par.
  + by rewrite hlane 1:/# pmod_small.
  + by rewrite hlane 1:/# (_ : (x + 5) %% 5 = x) 1:/#.
  + by rewrite hlane 1:/# (_ : (x + 10) %% 5 = x) 1:/#.
  + by rewrite hlane 1:/# (_ : (x + 15) %% 5 = x) 1:/#.
  by rewrite hlane 1:/# (_ : (x + 20) %% 5 = x) 1:/#.
have hd : forall x, 0 <= x < 5 => d x = c ((x - 1) %% 5) `^` (c ((x + 1) %% 5) `|<<<|` 1).
- by move=> x rgx; rewrite /d /c !keccak_DE // xor_rol_diff.
have := theta_parity_inj (c 0) (c 1) (c 2) (c 3) (c 4) _ _ _ _ _.
- by rewrite {1}hc // hd.
- by rewrite {1}hc // hd.
- by rewrite {1}hc // hd.
- by rewrite {1}hc // hd.
- by rewrite {1}hc // hd.
move=> hz; apply Array25.tP => i rgi; apply xor_eq0.
rewrite hlane // -hc 1:/#.
have hi : i %% 5 = 0 \/ i %% 5 = 1 \/ i %% 5 = 2 \/ i %% 5 = 3 \/ i %% 5 = 4 by smt().
by case: hz => [h0 [h1 [h2 [h3 h4]]]]; case: hi => [|[|[|[|]]]] ->.
qed.

(* -------------------------------------------------------------------- *)
lemma round_inj c (a b : state) : keccak_round_op c a = keccak_round_op c b => a = b.
proof. by rewrite /keccak_round_op /keccak_pround_op => /iota_inj /chi_inj /pi_inj /rho_inj /theta_inj. qed.

lemma keccak_f1600_inj : injective keccak_f1600_op.
proof.
have h : forall (l : int list) a b,
  foldl (fun s ir => keccak_round_op rc_spec.[ir] s) a l
  = foldl (fun s ir => keccak_round_op rc_spec.[ir] s) b l => a = b.
- by elim=> [|ir l ih] a b //= /ih /round_inj.
by move=> a b; rewrite /keccak_f1600_op; apply h.
qed.

lemma finite_state : finite_type<:state>.
proof.
apply (is_finite_surj (Array25.of_list witness) (fun r => size r = max 0 25 /\ all predT r)).
- move=> st _; exists (Array25.to_list st) => /=.
  split; [split | ].
  + by rewrite Array25.size_to_list.
  + by apply/List.allP.
  by rewrite Array25.to_listK.
by apply finite_list; apply/finiteP; exists W64.all_words => x _; apply W64.all_wordsP.
qed.

(* every Keccak state lies on a cycle of keccak_f1600_op                *)
lemma keccak_f1600_periodic (st : state) :
  exists L, 0 < L /\ iter L keccak_f1600_op st = st.
proof. by apply injective_periodic; [apply finite_state | apply keccak_f1600_inj]. qed.
