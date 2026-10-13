(**
  Shared algebraic layer for the NTT correctness proofs (both
  directions, `Fnttalg` and `Inttalg`).

  Contents:
    - interpretation of word-level data (`sval`, `cbnd`);
    - no-overflow word arithmetic;
    - the exact characterization of the Montgomery multiplier `mmr`
      (`mmr_svalE`) and its congruence/bound corollaries: against a
      table entry `qcenter (mrepr w)`, the Montgomery factor cancels;
    - the integer powers of zeta_ (`zpw`, order 512, zeta_^256 = -1);
    - the exponent tree `E`: block j at level k is the residue
      modulo X^(2^k) - zeta_^(E k j);
    - the residue coefficients in closed form (`nttsum`) and the CRT
      butterfly identity on them (`nttsum_split`), which both
      directions instantiate: forwards as the butterfly, backwards
      (summing/subtracting the two equations) as the GS merge.

  Values are interpreted through `W32.to_sint`; congruences are stated
  modulo q over the integers.
*)

(* ==================================================================== *)
(* ==================================================================== *)
require import AllCore CoreUtils List Ring IntDiv BitEncoding.
require import StdRing StdOrder StdBigop.
(*---*) import Bigint BIA IntOrder.

(* -------------------------------------------------------------------- *)
require import ListExtra Nttlogspec Nttspec Nttzetas.

(* -------------------------------------------------------------------- *)
from Jasmin require import JUtils JWord.

(* -------------------------------------------------------------------- *)
require import Array256.

(* -------------------------------------------------------------------- *)
require import Listred.

(* ==================================================================== *)
(* Interpretation of word-level data                                    *)
(* ==================================================================== *)
abbrev sval (w : W32.t) = W32.to_sint w.

(* all coefficients bounded by B in magnitude *)
op cbnd (p : wpoly) (B : int) =
  forall i, 0 <= i < 256 => `|sval p.[i]| <= B.

(* ==================================================================== *)
(* Basic facts about q                                                  *)
(* ==================================================================== *)
lemma gt0_q : 0 < q.
proof. by rewrite /q. qed.

lemma odd_q : 2 %| (q - 1).
proof. by rewrite /q. qed.

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
proof. by smt(gt0_q). qed.

lemma qcenter_bnd (x : int) : 2 * `|qcenter x| < q.
proof. by smt(gt0_q odd_q). qed.

(* table entries are read back exactly by to_sint *)
lemma to_sint_qcenter (x : int) :
  sval (W32.of_int (qcenter x)) = qcenter x.
proof. by rewrite W32.to_sintK_small; smt(qcenter_bnd gt0_q lt_q_2p23). qed.

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
  by apply IntOrder.ler_pmul; smt(IntOrder.normr_ge0 gt0_q).
rewrite /W32.smod /=.
smt().
qed.

lemma mmr_cgr (u z : W32.t) :
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

lemma mmr_bnd (u z : W32.t) :
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

(* bound with parametric input bounds: enough room in the 64-bit       *)
(* product keeps the reduced output within [-q, q]                     *)
lemma mmr_bnd2 (u z : W32.t) (B1 B2 : int) :
  `|sval u| <= B1 => `|sval z| <= B2 => B1 * B2 <= 2^31 * q =>
  `|sval (mmr u z)| <= q.
proof.
move=> hu hz hB.
rewrite mmr_svalE.
have habs : `|sval u * sval z| <= 2^31 * q.
- rewrite normrM.
  apply (IntOrder.ler_trans (B1 * B2)); 2: by apply hB.
  apply IntOrder.ler_pmul.
  - by apply IntOrder.normr_ge0.
  - by apply IntOrder.normr_ge0.
  - by apply hu.
  by apply hz.
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
have hDu : sval u * sval z
    - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q
    <= 2^32 * q.
- by move: habs habsT; rewrite /q /#.
have hDl : -(2^32 * q)
    <= sval u * sval z
       - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q.
- by move: habs habsT; rewrite /q /#.
have hup := leq_div2r (2^32)
  (sval u * sval z - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q)
  (2^32 * q) hDu _.
- by apply expr_ge0.
have hdn := leq_div2r (2^32) (-(2^32 * q))
  (sval u * sval z - sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) * q)
  hDl _.
- by apply expr_ge0.
move: hup hdn.
rewrite (: 2^32 * q %/ 2^32 = q) 1:/q 1://.
rewrite (: (-(2^32 * q)) %/ 2^32 = -q) 1:/q 1://.
move=> hup hdn.
rewrite IntOrder.ler_norml.
split.
- by apply hdn.
move=> _.
by apply hup.
qed.

(* the exact reading: the low-word multiplier t makes u*z - t*q        *)
(* divisible by 2^32, and mmr is the exact quotient                     *)
lemma mmr_exact (u z : W32.t) : exists t,
  -2^31 <= t < 2^31 /\ 2^32 * sval (mmr u z) = sval u * sval z - t * q.
proof.
pose t := sval (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)).
exists t; split; first by have := W32.to_sint_cmp (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449)) => /#.
have hA : W64.to_uint (u \sx z) = (sval u * sval z) %% W64.modulus.
- by rewrite /(\sx) W64.to_uintM /sigextu64 !W64.of_uintK modzMml modzMmr.
have hu : W32.to_uint (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449))
    = (sval u * sval z * 58728449) %% 2^32.
- rewrite W2u32.to_uint_truncateu32 W64.to_uintM hA W64.of_uintK.
  rewrite modzMml modzMmr (: W64.modulus = 2^64) 1:// (: W32.modulus = 2^32) 1://.
  by rewrite modz_dvd_pow 1://.
have hT : t %% 2^32 = (sval u * sval z * 58728449) %% 2^32.
- rewrite /t W32.to_sintE /W32.smod /=.
  by case (2147483648 <= W32.to_uint (W2u32.truncateu32 ((u \sx z) * W64.of_int 58728449))) => _;
       rewrite hu; smt().
have hdvd : 2^32 %| (sval u * sval z - t * q).
- rewrite dvdzE -modzBm -(modzMml t q) hT (modzMml (sval u * sval z * 58728449) q) modzBm.
  have -> : sval u * sval z - sval u * sval z * 58728449 * q
          = (sval u * sval z) * (1 - 58728449 * q) by ring.
  by rewrite -modzMmr (: (1 - 58728449 * q) %% W32.modulus = 0) 1:/q.
by rewrite mmr_svalE -/t mulzC divzK.
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

(* mmr against a table entry: the Montgomery factor cancels *)
lemma mmr_table (u : W32.t) (w : int) :
  (sval (mmr u (W32.of_int (qcenter (mrepr w)))) %% q)
    = (sval u * w) %% q.
proof.
apply cgr_pow2_cancel.
rewrite mmr_cgr to_sint_qcenter.
rewrite -(modzMmr (sval u) (qcenter (mrepr w)) q) qcenter_cgr mrepr_cgr modzMmr.
by have -> : sval u * (w * 2^32) = 2^32 * (sval u * w) by ring.
qed.

lemma mmr_table_bnd (u : W32.t) (w : int) :
  `|sval (mmr u (W32.of_int (qcenter (mrepr w))))| < q.
proof. by apply mmr_bnd; rewrite to_sint_qcenter qcenter_bnd. qed.

(* ==================================================================== *)
(* Integer powers of zeta_                                              *)
(* ==================================================================== *)
(* helper: mod-pow compatibility (missing from IntDiv) *)
lemma modzXm (x n m : int) : 0 <= n => (x %% m) ^ n %% m = x ^ n %% m.
proof.
move=> ge0_n; elim: n ge0_n => [|n ge0_n ih]; first by rewrite !expr0.
by rewrite !exprS // modzMml -modzMmr ih modzMmr.
qed.

(* zeta_ has order 512 mod q *)
lemma zeta_512 : zeta_ ^ 512 %% q = 1.
proof. by rewrite /zeta_ /q /=. qed.

lemma zexp_modE (n : int) : 0 <= n =>
  zeta_ ^ (n %% 512) %% q = zeta_ ^ n %% q.
proof.
move=> ge0_n.
rewrite {2}(divz_eq n 512) exprD_nneg 1:mulr_ge0 1:divz_ge0 // 1:modz_ge0 //.
rewrite mulzC (mulzC (n %/ 512) 512) exprM.
rewrite -(modzMmr (zeta_ ^ (n %% 512)) (zeta_ ^ 512 ^ (n %/ 512)) q).
rewrite -(modzXm (zeta_ ^ 512) (n %/ 512) q) 1:divz_ge0 ~-1://.
by rewrite zeta_512 expr1z modzMmr /=.
qed.

(* reduce exponents mod 512 *)
op zpw (e : int) : int = zeta_ ^ (e %% 512).

lemma zpw_cgr_exp (e e' : int) :
  e %% 512 = e' %% 512 => zpw e = zpw e'.
proof. by move=> @/zpw ->. qed.

lemma zpwD (a b : int) : zpw (a + b) %% q = (zpw a * zpw b) %% q.
proof.
by rewrite /zpw -exprD_nneg ?modz_ge0 // -modzDm zexp_modE ?addr_ge0 ?modz_ge0.
qed.

(* zeta_^256 = -1 mod q: the key sign identity of the CRT tree *)
lemma zpw_256 : zpw 256 %% q = (-1) %% q.
proof. by rewrite /zpw /zeta_ /q /=. qed.

lemma zpw_oppE (e : int) : zpw (e + 256) %% q = (- zpw e) %% q.
proof. by rewrite zpwD -modzMmr zpw_256 modzMmr mulrN1. qed.

lemma bitrev8_rg (x : int) : 0 <= bitrev8 x < 256.
proof.
rewrite /bitrev8; split; [exact BS2Int.bs2int_ge0 | move=> _].
have := BS2Int.bs2int_le2Xs (rev (BS2Int.int2bs 8 x)).
by rewrite size_rev BS2Int.size_int2bs /=.
qed.

lemma bitrev8_0 : bitrev8 0 = 0.
proof.
by rewrite /bitrev8 BS2Int.int2bs0 rev_nseq BS2Int.bs2int_nseq_false.
qed.

(* the halving identity behind the exponent tree *)
lemma bitrev8_half (x : int) : 0 <= x < 256 =>
  2 * bitrev8 x = bitrev8 (x %/ 2) + 256 * (x %% 2).
proof.
move=> rgx @/bitrev8.
rewrite (BS2Int.int2bs_cons 8 x) // rev_cons BS2Int.bs2int_rcons.
rewrite size_rev BS2Int.size_int2bs /=.
rewrite (BS2Int.int2bs_rcons 8 (x %/ 2)) //.
have -> /=: x %/ 2 %/ 2 ^ (8 - 1) = 0 by smt().
rewrite rev_rcons BS2Int.bs2int_cons /max /=.
case (2 %| x) => hx /=.
- rewrite b2i0 /=.
  by have -> : x %% 2 = 0 by rewrite -dvdzE.
rewrite b2i1 /=.
have -> : x %% 2 = 1 by smt().
by ring.
qed.

(* link with the table exponents of Nttlogspec *)
lemma zpow_zpw (x : int) : zpow x = zpw (bitrev8 x) %% q.
proof.
by rewrite /zpow /zpw (pmod_small (bitrev8 x) 512); smt(bitrev8_rg).
qed.

(* ==================================================================== *)
(* The exponent tree                                                    *)
(* ==================================================================== *)
(* E k j: block j at level k holds P mod (X^(2^k) - zeta_^(E k j)).
   Level 8 is the whole input: X^256 + 1 = X^256 - zeta_^256.
   Splitting block j of level k+1 with w = zeta_^(bitrev8 (j + 2^(7-k)))
   yields children 2j (minus sign) and 2j+1 (plus sign, i.e. e + 256). *)
op E (k j : int) : int =
  if k = 8 then 256
  else bitrev8 (j %/ 2 + 2^(7-k)) + 256 * (j %% 2).

lemma E_even (k j : int) : 0 <= k < 8 =>
  E k (2*j) = bitrev8 (j + 2^(7-k)).
proof. by move=> rgk @/E; rewrite ifF 1:/# mulKz // modzMr /=. qed.

lemma E_odd (k j : int) : 0 <= k < 8 =>
  E k (2*j+1) = E k (2*j) + 256.
proof. by move=> rgk @/E; rewrite !ifF 1,2:/#; smt(). qed.

lemma E_range (k j : int) :
  0 <= k <= 8 => 0 <= j < 2^(8-k) => 0 <= E k j < 512.
proof. by move=> rgk rgj @/E; smt(bitrev8_rg). qed.

(* squaring a child exponent gives the parent exponent *)
lemma E_double (k j : int) : 0 <= k < 8 => 0 <= j < 2^(7-k) =>
  (2 * E k (2*j)) %% 512 = E (k+1) j %% 512.
proof.
move=> rgk rgj; rewrite E_even //.
case (k = 7) => [->>|neq7].
- move: rgj => /= rgj; have ->: j = 0 by smt().
  by have := bitrev8_half 1 _; smt(bitrev8_0).
have h2: 2^(7-k) = 2 * 2^(6-k) by rewrite -exprS 1:/# /#.
rewrite /E ifF 1:/#.
have le: 2^(7-k) <= 128.
- have e7 : 128 = 2 ^ 7 by rewrite /=.
  by rewrite e7; apply IntOrder.ler_weexpn2l => /#.
rewrite bitrev8_half 1:/#.
have -> : (j + 2^(7-k)) %/ 2 = j %/ 2 + 2^(6-k) by smt().
have -> : (j + 2^(7-k)) %% 2 = j %% 2 by smt().
by have -> : 7 - (k + 1) = 6 - k by smt().
qed.

(* ==================================================================== *)
(* The target sums: coefficients of P mod (X^(2^k) - zeta_^(E k j))     *)
(* ==================================================================== *)
(* helpers: congruence of big sums, and even/odd splitting *)
lemma big_cgr (m : int) (f g : int -> int) (a b : int) :
  (forall i, a <= i < b => f i %% m = g i %% m) =>
  bigi predT f a b %% m = bigi predT g a b %% m.
proof.
move=> h; have {h} : forall i, i \in range a b => f i %% m = g i %% m.
- by move=> i /mem_range; apply h.
elim: (range a b) => [|x s ih] hs; first by rewrite !big_nil.
rewrite !big_cons /predT /=.
by rewrite -modzDm hs // ih 1:/# modzDm.
qed.

lemma big_split_parity (F : int -> int) (n : int) : 0 <= n =>
    bigi predT F 0 (2*n)
  = bigi predT (fun u => F (2*u)) 0 n + bigi predT (fun u => F (2*u+1)) 0 n.
proof.
elim: n => [|n ge0_n ih]; first by rewrite !big_geq.
have ->: 2*(n+1) = (2*n+1)+1 by ring.
rewrite big_int_recr 1:/# big_int_recr 1:/# ih.
rewrite big_int_recr // big_int_recr //=.
by ring.
qed.

(* Since X^(s * 2^k + t) = (X^(2^k))^s * X^t = zeta_^(E k j * s) * X^t
   modulo the block modulus, coefficient t of the residue is: *)
op nttsum (p : wpoly) (k j t : int) : int =
  bigi predT (fun s => zpw (E k j * s) * sval p.[s * 2^k + t]) 0 (2^(8-k)).

(* level 8: the residue is the polynomial itself *)
lemma nttsum8 (p : wpoly) (t : int) : nttsum p 8 0 t = sval p.[t].
proof. by rewrite /nttsum /= big_int1 /= /zpw /=. qed.

(* the butterfly identity on sums: splitting even/odd s in the parent
   sum realizes the CRT step *)
lemma nttsum_split (p : wpoly) (k j t : int) :
  0 <= k < 8 => 0 <= j < 2^(7-k) => 0 <= t < 2^k =>
     nttsum p k (2*j) t %% q
       = (nttsum p (k+1) j t + zpw (E k (2*j)) * nttsum p (k+1) j (t + 2^k)) %% q
  /\ nttsum p k (2*j+1) t %% q
       = (nttsum p (k+1) j t - zpw (E k (2*j)) * nttsum p (k+1) j (t + 2^k)) %% q.
proof.
move=> rgk rgj rgt.
have cgrM : forall (a a' b : int), a %% q = a' %% q => (a * b) %% q = (a' * b) %% q.
- by move=> a a' b h; rewrite -modzMml h modzMml.
have e8k : 2^(8-k) = 2 * 2^(7-k).
- by rewrite (_ : 8 - k = (7 - k) + 1) 1:/# exprS 1:/#.
have heven : forall u, zpw (E k (2*j) * (2*u)) = zpw (E (k+1) j * u).
- move=> u; apply zpw_cgr_exp.
  have ->: E k (2*j) * (2*u) = (2 * E k (2*j)) * u by ring.
  by rewrite -modzMml E_double // modzMml.
have hidx : forall u, (2*u) * 2^k + t = u * 2^(k+1) + t.
- by move=> u; rewrite exprS 1:/# /#.
have hidx1 : forall u, (2*u+1) * 2^k + t = u * 2^(k+1) + (t + 2^k).
- by move=> u; rewrite exprS 1:/# /#.
have hodd :
    bigi predT
      (fun u => zpw (E k (2*j) * (2*u+1)) * sval p.[(2*u+1) * 2^k + t])
      0 (2^(7-k)) %% q
  = (zpw (E k (2*j)) *
       bigi predT
         (fun u => zpw (E (k+1) j * u) * sval p.[u * 2^(k+1) + (t + 2^k)])
         0 (2^(7-k))) %% q.
- rewrite BIA.mulr_sumr.
  apply big_cgr => u rgu /=.
  rewrite hidx1 mulrA.
  rewrite -modzMml -(modzMml
    (zpw (E k (2*j)) * zpw (E (k+1) j * u))
    (sval p.[u * 2^(k+1) + (t + 2^k)]) q).
  congr; congr.
  have ->: E k (2*j) * (2*u+1) = E k (2*j) + E k (2*j) * (2*u) by ring.
  by rewrite zpwD heven.
split.
- rewrite /nttsum.
  have -> : 8 - (k + 1) = 7 - k by smt().
  rewrite e8k big_split_parity 1:expr_ge0 //=.
  have -> :
      bigi predT
        (fun (u : int) => zpw (E k (2*j) * (2*u)) * sval p.[(2*u) * 2^k + t])
        0 (2^(7-k))
    = bigi predT
        (fun (u : int) => zpw (E (k+1) j * u) * sval p.[u * 2^(k+1) + t])
        0 (2^(7-k)).
  + by apply eq_big_int => u rgu /=; rewrite heven hidx.
  by rewrite -modzDmr hodd modzDmr.
have heven2 : forall u, zpw (E k (2*j+1) * (2*u)) = zpw (E (k+1) j * u).
- move=> u; rewrite E_odd //; apply zpw_cgr_exp.
  have ->: (E k (2*j) + 256) * (2*u) = u * 512 + (2 * E k (2*j)) * u by ring.
  by rewrite modzMDl -modzMml E_double // modzMml.
have hodd2 :
    bigi predT
      (fun u => zpw (E k (2*j+1) * (2*u+1)) * sval p.[(2*u+1) * 2^k + t])
      0 (2^(7-k)) %% q
  = (- zpw (E k (2*j)) *
       bigi predT
         (fun u => zpw (E (k+1) j * u) * sval p.[u * 2^(k+1) + (t + 2^k)])
         0 (2^(7-k))) %% q.
- rewrite BIA.mulr_sumr BIA.sumrN /=.
  apply big_cgr => u rgu /=.
  rewrite hidx1 E_odd //.
  have ->: (E k (2*j) + 256) * (2*u+1)
         = (E k (2*j) + 256) + (E k (2*j) + 256) * (2*u) by ring.
  rewrite mulrA -mulNr.
  rewrite mulrA.
  apply cgrM.
  rewrite zpwD.
  have ->: (E k (2*j) + 256) * 2 * u = E k (2*j+1) * (2*u).
  + by rewrite E_odd //; ring.
  rewrite heven2.
  by apply cgrM; apply zpw_oppE.
rewrite /nttsum.
have -> : 8 - (k + 1) = 7 - k by smt().
rewrite e8k big_split_parity 1:expr_ge0 //=.
have -> :
    bigi predT
      (fun (u : int) => zpw (E k (2*j+1) * (2*u)) * sval p.[(2*u) * 2^k + t])
      0 (2^(7-k))
  = bigi predT
      (fun (u : int) => zpw (E (k+1) j * u) * sval p.[u * 2^(k+1) + t])
      0 (2^(7-k)).
- by apply eq_big_int => u rgu /=; rewrite heven2 hidx.
by rewrite -modzDmr hodd2 modzDmr.
qed.

