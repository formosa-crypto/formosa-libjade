(**
  This theory formalizes the machine-level specification of the NTT as it is
  implemented in the target architecture.

  In contrast to the high-level algebraic specification, this file makes the
  implementation structure explicit.  It models the concrete data
  representation, the sequencing of arithmetic operations, and the use of
  low-level techniques such as Montgomery reduction for modular
  multiplication.

  The specification captures the exact computational behavior of the
  implementation, including the operational details required for efficient
  execution on the underlying hardware.

  This machine-level model is intended to be linked upward to the clean
  algebraic specification, enabling a correctness proof that connects the
  concrete implementation to its mathematical meaning.

  The butterfly operators and their algebra (`reduce_level`,
  `ireduce_level`, `nttsum`, `ntt_alg`, `icgr_step`) are those of the
  generic tree `NttTree`, instantiated here with q = 8380417,
  zeta = 1753, 32-bit words, leaves of size 1 and the Montgomery
  multiplication `mmr` against the table encoding `tw32`.
*)

(* ==================================================================== *)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder StdBigop.
(*---*) import BS2Int Bigint IntOrder.

(* -------------------------------------------------------------------- *)
require import ListExtra Nttlogspec.

(* -------------------------------------------------------------------- *)
from Jasmin require import JUtils JWord.

(* -------------------------------------------------------------------- *)
require import Array256 XArray256.

(* -------------------------------------------------------------------- *)
require import Listred NttTree.

(* -------------------------------------------------------------------- *)
(* FIXME: Should be defined in a generic way                            *)
op ( \sx ) (w1 w2 : W32.t) =
  W64.( * ) (W2u32.sigextu64 w1) (W2u32.sigextu64 w2).

(* ==================================================================== *)
op mmr (u w : W32.t) =
  let a = u \sx w in
  let t = W2u32.truncateu32 (a * W64.of_int 58728449) in
  let t = t \sx W32.of_int 8380417 in
  W2u32.truncateu32 ((a - t) `>>>` 32).

(* ==================================================================== *)
(* Interpretation of word-level data                                    *)
(* ==================================================================== *)
abbrev sval (w : W32.t) = W32.to_sint w.

(* ==================================================================== *)
(* Basic facts about q                                                  *)
(* ==================================================================== *)
lemma lt_q_2p23 : q < 2^23.
proof. by rewrite /q. qed.

(* ==================================================================== *)
(* Word-level arithmetic (no-overflow conditions)                       *)
(* ==================================================================== *)
lemma to_sintD_small (a b : W32.t) :
  `|sval a + sval b| < 2^31 => sval (a + b) = sval a + sval b.
proof. by move=> h; apply: W32.to_sintD_small; move: h => /= /#. qed.

lemma to_sintB_small (a b : W32.t) :
  `|sval a - sval b| < 2^31 => sval (a - b) = sval a - sval b.
proof. by move=> h; apply: W32.to_sintB_small; move: h => /= /#. qed.

(* ==================================================================== *)
(* qcenter / mrepr                                                      *)
(* ==================================================================== *)
lemma qcenter_cgr (x : int) : qcenter x %% q = x %% q.
proof. by rewrite /q; smt(). qed.

lemma qcenter_bnd (x : int) : 2 * `|qcenter x| < q.
proof. by rewrite /q; smt(). qed.

(* table entries are read back exactly by to_sint *)
lemma to_sint_qcenter (x : int) :
  sval (W32.of_int (qcenter x)) = qcenter x.
proof. by rewrite W32.to_sintK_small; smt(qcenter_bnd lt_q_2p23). qed.

lemma mrepr_cgr (w : int) : mrepr w %% q = (w * 2^32) %% q.
proof. by rewrite /mrepr modz_mod. qed.

(* ==================================================================== *)
(* Montgomery multiply-reduce: congruence and bound                     *)
(* ==================================================================== *)
(* master lemma: the word-level mmr computes the exact integer
   (u*z - T*q) / 2^32, where T is the (signed) low-word multiplier *)
lemma mmr_svalE (u z : W32.t) :
  sval (mmr u z)
    = (sval u * sval z
        - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q)
      %/ 2^32.
proof.
rewrite /mmr /=.
have hA : W64.to_uint (u \sx z) = (sval u * sval z) %% W64.modulus.
- by rewrite /(\sx) W64.to_uintM /sigextu64 !W64.of_uintK modzMml modzMmr.
have hT64 : W64.to_uint
    (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449) \sx W32.of_int 8380417)
  = (sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q)
    %% W64.modulus.
- rewrite /(\sx) W64.to_uintM /sigextu64 !W64.of_uintK modzMml modzMmr.
  have -> // : sval (W32.of_int 8380417) = q.
  rewrite W32.to_sintK_small.
  - by rewrite /=.
  by rewrite /q.
rewrite W32.to_sintE W2u32.to_uint_truncateu32 W64.to_uint_shr //.
rewrite W64.to_uintD W64.to_uintN hA hT64.
have -> : (sval u * sval z %% JModel_x86.ptr_modulus +
    (- sval (truncateu32 ((u \sx z) * of_int 58728449)) * q %%
       JModel_x86.ptr_modulus) %%
    JModel_x86.ptr_modulus) %% JModel_x86.ptr_modulus
  = (sval u * sval z - sval (truncateu32 ((u \sx z) * of_int 58728449)) * q)
    %% JModel_x86.ptr_modulus.
- by smt(modzBm modz_mod modzNm modzDml modzDmr).
rewrite (: JModel_x86.ptr_modulus = 2^64) 1:// (: W32.modulus = 2^32) 1://.
rewrite modz_pow2_div 1:// (: 64 - 32 = 32) 1:// modz_mod.
have c1 : `|sval u| <= 2147483648.
- by have := W32.to_sint_cmp u => /= /#.
have c2 : `|sval z| <= 2147483648.
- by have := W32.to_sint_cmp z => /= /#.
have c3 : `|sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449))| <= 2147483648.
- by have := W32.to_sint_cmp (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) => /= /#.
have habs : `|sval u * sval z| <= 2147483648 * 2147483648.
- by rewrite normrM; apply IntOrder.ler_pmul; smt(IntOrder.normr_ge0).
have habsT : `|sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q|
    <= 2147483648 * q.
- rewrite normrM (: `|q| = q) 1:/q //.
  by apply IntOrder.ler_pmul; smt(IntOrder.normr_ge0).
rewrite /W32.smod /=.
smt().
qed.

lemma mmr_mont (u z : W32.t) :
  (2^32 * sval (mmr u z)) %% q = (sval u * sval z) %% q.
proof.
have hA : W64.to_uint (u \sx z) = (sval u * sval z) %% W64.modulus.
- by rewrite /(\sx) W64.to_uintM /sigextu64 !W64.of_uintK modzMml modzMmr.
have hu : W32.to_uint (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449))
    = (sval u * sval z * 58728449) %% 2^32.
- rewrite W2u32.to_uint_truncateu32 W64.to_uintM hA W64.of_uintK.
  rewrite modzMml modzMmr (: W64.modulus = 2^64) 1:// (: W32.modulus = 2^32) 1://.
  by rewrite modz_dvd_pow 1://.
have hT : sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) %% 2^32
    = (sval u * sval z * 58728449) %% 2^32.
- rewrite W32.to_sintE /W32.smod /=.
  by case (2147483648 <= W32.to_uint (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449))) => _;
       rewrite hu; smt().
have hdvd : 2^32 %|
    (sval u * sval z - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q).
- rewrite dvdzE.
  rewrite -modzBm -(modzMml (sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449))) q) hT.
  rewrite (modzMml (sval u * sval z * 58728449) q) modzBm.
  have -> : sval u * sval z - sval u * sval z * 58728449 * q
          = (sval u * sval z) * (1 - 58728449 * q) by ring.
  rewrite -modzMmr.
  have -> : (1 - 58728449 * q) %% W32.modulus = 0.
  - by rewrite /q /=.
  by rewrite /=.
rewrite mmr_svalE.
have -> : 2^32 * ((sval u * sval z
      - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q) %/ 2^32)
  = sval u * sval z - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q.
- by rewrite mulzC divzK.
rewrite -modzBm modzMl /=.
by rewrite modz_mod.
qed.

lemma mmr_small (u z : W32.t) :
  2 * `|sval z| < q => `|sval (mmr u z)| < q.
proof.
move=> hz.
rewrite mmr_svalE.
have c1 : `|sval u| <= 2147483648.
- by have := W32.to_sint_cmp u => /= /#.
have hsz : `|sval z| <= 4190208.
- by move: hz; rewrite /q /#.
have habs : `|sval u * sval z| <= 2147483648 * 4190208.
- rewrite normrM.
  apply IntOrder.ler_pmul.
  - by apply IntOrder.normr_ge0.
  - by apply IntOrder.normr_ge0.
  - by apply c1.
  by apply hsz.
have c3 : `|sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449))| <= 2147483648.
- by have := W32.to_sint_cmp (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) => /= /#.
have hq : `|q| = q.
- by rewrite /q.
have habsT : `|sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q|
    <= 2147483648 * q.
- rewrite normrM hq.
  apply IntOrder.ler_pmul.
  - by apply IntOrder.normr_ge0.
  - by rewrite /q.
  - by apply c3.
  by done.
(* bound the dividend, then conclude by monotonicity of division:
   no division reasoning is left to the provers *)
have hDu : sval u * sval z
    - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q
    <= 26995211632640000.
- by move: habs habsT; rewrite /q /#.
have hDl : -26995211632640000
    <= sval u * sval z
       - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q.
- by move: habs habsT; rewrite /q /#.
have hup := leq_div2r (2^32)
  (sval u * sval z - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q)
  26995211632640000 hDu _.
- by apply expr_ge0.
have hdn := leq_div2r (2^32) (-26995211632640000)
  (sval u * sval z - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q)
  hDl _.
- by apply expr_ge0.
move: hup hdn.
rewrite (: 26995211632640000 %/ 2^32 = 6285312) 1://.
rewrite (: (-26995211632640000) %/ 2^32 = -6285313) 1://.
move=> hup hdn.
apply (IntOrder.ler_lt_trans 6285313).
- rewrite IntOrder.ler_norml.
  split.
  - by apply hdn.
  move=> _.
  apply (IntOrder.ler_trans 6285312).
  - by apply hup.
  by done.
by rewrite /q.
qed.

(* Montgomery reduction of a 64-bit value: mmr is its instance on a
   product, mmr u w = mred (u \sx w). The dot product reduces a sum of
   products with it. *)
op mred (a : W64.t) : W32.t =
  let t = W2u32.truncateu32 (a * W64.of_int 58728449) in
  let t = t \sx W32.of_int 8380417 in
  W2u32.truncateu32 ((a - t) `>>>` 32).

lemma mmr_mred (u w : W32.t) : mmr u w = mred (u \sx w).
proof. by []. qed.

(* the exact reading of mred: with |a| <= 2^62, the low-word multiplier t
   makes a - t*q divisible by 2^32, and mred a is the exact quotient *)
lemma mred_exact (a : W64.t) : `|W64.to_sint a| <= 2^62 => exists t,
  -2^31 <= t < 2^31 /\ 2^32 * sval (mred a) = W64.to_sint a - t * q.
proof.
(* on the words: the low word of a - t*q is zero, and a 64-bit word
   with a zero low word is 2^32 times its high word *)
have hlow : forall (x : W64.t), W2u32.truncateu32
    (x - (W2u32.truncateu32 (x * W64.of_int 58728449) \sx W32.of_int 8380417)) = W32.zero.
+ by rewrite /(\sx); circuit.
have hhigh : forall (d : W64.t), W2u32.truncateu32 d = W32.zero =>
    d = W2u32.sigextu64 (W2u32.truncateu32 (d `>>` W8.of_int 32)) * W64.of_int 4294967296.
+ by circuit.
move=> ha; pose tw := W2u32.truncateu32 (a * W64.of_int 58728449).
exists (sval tw); split; 1: by have := W32.to_sint_cmp tw => /#.
have hq : sval (W32.of_int 8380417) = q by rewrite W32.to_sintK_small.
have htw := W32.to_sint_cmp tw.
(* on the integers: no overflow *)
have hT : W64.to_sint (tw \sx W32.of_int 8380417) = sval tw * q.
+ rewrite /(\sx) /sigextu64 W64.of_intM hq W64.to_sintK_small //.
  by move: htw; rewrite /q /=; smt().
have hD : W64.to_sint (a - (tw \sx W32.of_int 8380417)) = W64.to_sint a - sval tw * q.
+ by rewrite W64.to_sintB_small hT //; move: ha htw; rewrite /q /=; smt().
have := hhigh _ (hlow a); rewrite W64.shr_shrw // -/tw => hE.
have hm : mred a = W2u32.truncateu32 ((a - (tw \sx W32.of_int 8380417)) `>>>` 32).
+ by rewrite /mred.
rewrite -hD hE -hm /sigextu64 W64.of_intM W64.to_sintK_small /=; 2: by ring.
by have := W32.to_sint_cmp (mred a) => /#.
qed.

(* the exact reading of mmr, the instance of mred on a product *)
lemma mmr_exact (u z : W32.t) : exists t,
  -2^31 <= t < 2^31 /\ 2^32 * sval (mmr u z) = sval u * sval z - t * q.
proof.
have hb : `|sval u * sval z| <= 2^62.
+ rewrite normrM (: 2^62 = 2^31 * 2^31) 1://.
  have /= hu := W32.to_sint_cmp u; have /= hz := W32.to_sint_cmp z.
  by rewrite (: 4611686018427387904 = 2147483648 * 2147483648) 1:// IntOrder.ler_pmul; smt().
have hp : W64.to_sint (u \sx z) = sval u * sval z.
+ rewrite /(\sx) /sigextu64 W64.of_intM W64.to_sintK_small //.
  by move: hb => /=; smt().
by rewrite mmr_mred -hp; apply mred_exact; rewrite hp.
qed.

(* the product bound: wide operands are fine as long as their product  *)
(* is; with |u*z| <= P, |mmr u z| <= (P + 2^31 q) / 2^32                *)
lemma mmr_bnd_prod (u z : W32.t) (P : int) :
  `|sval u * sval z| <= P => 2^32 * `|sval (mmr u z)| <= P + 2^31 * q.
proof.
move=> hP; have [t [rgt E]] := mmr_exact u z.
have -> : 2^32 * `|sval (mmr u z)| = `|sval u * sval z - t * q| by rewrite -E normrM.
by move: hP rgt; rewrite /q /=; smt().
qed.

(* bound and congruence of mred, from its exact reading *)
lemma mred_bnd (a : W64.t) (P : int) :
  `|W64.to_sint a| <= P => P <= 2^62 =>
  2^32 * `|sval (mred a)| <= P + 2^31 * q.
proof.
move=> hP hP62; have [t [rgt E]] := mred_exact a (IntOrder.ler_trans _ _ _ hP hP62).
have -> : 2^32 * `|sval (mred a)| = `|W64.to_sint a - t * q| by rewrite -E normrM.
by move: hP hP62 rgt; rewrite /q /=; smt().
qed.

lemma mred_mont (a : W64.t) : `|W64.to_sint a| <= 2^62 =>
  (2^32 * sval (mred a)) %% q = W64.to_sint a %% q.
proof.
move=> ha; have [t [_ ->]] := mred_exact a ha.
by rewrite -modzBm modzMl /= modz_mod.
qed.

(* 2^32 is invertible mod q (q odd): cancellation *)
lemma cgr_pow2_cancel (a b : int) :
  (2^32 * a) %% q = (2^32 * b) %% q => a %% q = b %% q.
proof.
move=> h.
have e : (8265825 * 2^32) %% q = 1 by rewrite /q /=.
have -> : a %% q = ((8265825 * 2^32) %% q * a) %% q.
- by rewrite e /=.
have -> : b %% q = ((8265825 * 2^32) %% q * b) %% q.
- by rewrite e /=.
rewrite !modzMml.
have -> : 8265825 * 2^32 * a = 8265825 * (2^32 * a) by ring.
have -> : 8265825 * 2^32 * b = 8265825 * (2^32 * b) by ring.
by rewrite -modzMmr h modzMmr.
qed.

(* the table entry of a factor x: its centered Montgomery representative *)
op tw32 (x : int) : W32.t = W32.of_int (qcenter (mrepr x)).

(* mmr against a table entry: the Montgomery factor cancels *)
lemma mmr_table (u : W32.t) (w : int) :
  (sval (mmr u (tw32 w)) %% q) = (sval u * w) %% q.
proof.
apply cgr_pow2_cancel.
rewrite mmr_mont /tw32 to_sint_qcenter.
rewrite -(modzMmr (sval u) (qcenter (mrepr w)) q) qcenter_cgr mrepr_cgr modzMmr.
by have -> : sval u * (w * 2^32) = 2^32 * (sval u * w) by ring.
qed.

lemma mmr_table_bnd (u : W32.t) (w : int) : `|sval (mmr u (tw32 w))| < q.
proof. by apply mmr_small; rewrite /tw32 to_sint_qcenter qcenter_bnd. qed.


(* ==================================================================== *)
(* The instance of the generic tree                                     *)
(* ==================================================================== *)
clone include NttTreeT with
  op q      <- q,
  op s      <- 0,
  op zeta_  <- zeta_,
  type w    <- W32.t,
  op sval   <- W32.to_sint,
  op wmax   <- 2^31,
  op ( + )  <- W32.( + ),
  op ( - )  <- fun (a b : W32.t) => a - b,
  type tw   <- W32.t,
  op tw_of  <- tw32,
  op mmr    <- mmr,
  op isub   <- fun (a b : W32.t) => b - a,
  op isgn   <- 1
proof *.

realize gt1_q by rewrite /q.
realize odd_q by rewrite /q.
realize rg_s by done.
realize zeta_half by rewrite /zeta_ /q.
realize svalD by move=> a b; apply to_sintD_small.
realize svalB by move=> a b; apply to_sintB_small.
realize mmr_cgr by apply mmr_table.
realize mmr_bnd by apply mmr_table_bnd.
realize isgnP by done.
realize svalI by move=> a b /= h; rewrite to_sintB_small.

(* -------------------------------------------------------------------- *)
(* The forward twiddles, as integers                                    *)
op [opaque] zetaL (i : int) =
  if 0 <= i < 8 then
    mkseq (fun j => qcenter (mrepr (zpow (j + 2^(7-i))))) (2^(7-i))
  else [].

(* ==================================================================== *)
(* Final scaling: every coefficient is montgomery-multiplied by 41978   *)
(* (MONT^2/256 mod q).                                                  *)
(* ==================================================================== *)
op iscale (p : wpoly) : wpoly =
  Array256.map (fun (c : W32.t) => mmr c (W32.of_int 41978)) p.

(* The last level of the inverse NTT with the scaling folded in: the     *)
(* sums are multiplied by 41978 and the differences by the root of the  *)
(* level (25847) times 41978, reduced once more (-3975713).             *)
op ifinal (p : wpoly) : wpoly =
  Array256.init (fun t =>
    if t < 128 then mmr (p.[t] + p.[t + 128]) (W32.of_int 41978)
    else mmr (p.[t] - p.[t - 128]) (W32.of_int (-3975713))).

(* ==================================================================== *)
(* Pointwise (NTT-domain) multiplication: every coefficient of the      *)
(* product is the montgomery-multiplication of the matching             *)
(* coefficients, cf. pointwise_montgomery_multiply_and_reduce.          *)
(* ==================================================================== *)
op pwmul (a b : wpoly) : wpoly =
  Array256.init (fun j => mmr a.[j] b.[j]).

(* Prefix-multiplied polynomial: coefficients [0, n) already written,   *)
(* the rest still holding the destination's initial contents.           *)
op pwmul_partial (a b t : wpoly) (n : int) : wpoly =
  Array256.init (fun j => if j < n then mmr a.[j] b.[j] else t.[j]).

(* -------------------------------------------------------------------- *)
lemma pwmul_partial0 (a b t : wpoly) : pwmul_partial a b t 0 = t.
proof. hint +listred. by apply/Array256.ext_eq => x rgx; rewrite initiE //#. qed.

(* -------------------------------------------------------------------- *)
lemma pwmul_partial_full (a b t : wpoly) : pwmul_partial a b t 256 = pwmul a b.
proof.
hint +listred.
by apply/Array256.ext_eq => x rgx; rewrite !initiE //= ifT //#.
qed.

(* -------------------------------------------------------------------- *)
lemma pwmul_partialS (a b t : wpoly) (n : int) :
     0 <= n
  => n + 8 <= 256
  =>   pwmul_partial a b t (n + 8)
     = replace_ (pwmul_partial a b t n) n
         (mkseq (fun k => mmr a.[n + k] b.[n + k]) 8).
proof.
hint +listred.
move=> ge0n hle; apply/Array256.ext_eq => x rgx.
rewrite initiE //= /replace_ filliE //=.
case: (n <= x < n + 8) => hx; first by smt().
by rewrite initiE //= /#.
qed.
