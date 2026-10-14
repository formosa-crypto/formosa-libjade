require import AllCore Real RealSeq RealSeries Xreal StdOrder StdBigop List Dexcepted PROM.
import RField RealOrder Xreal Distr DBool Bigreal.BRA FMap.

abstract theory Le_Eq.

type in_t, out_t.

module type Adv = { 
  proc main (x:in_t) : out_t
}.

lemma mu1_le_eq_mu1 (A <: Adv) (dA : in_t -> out_t distr) &m in_:
   isdistr (mass (dA in_)) =>
   Pr[ A.main(in_) @ &m : true] = 1%r =>
   (forall out, Pr[ A.main(in_) @ &m : res = out ] <= mu1 (dA in_) out) => 
   forall out, Pr[ A.main(in_) @ &m : res = out ] = mu1 (dA in_) out.
proof.
  move=> hisdistr hll hle out.
  pose pr_mass := fun k => Pr[A.main(in_) @ &m : res = k].
  pose d := mk pr_mass.
  have hd: isdistr pr_mass.
  + split. 
    + move=> x;rewrite /pr_mass; smt(mu_bounded).
    move=> s huniq; case: hisdistr => _ /(_ _ huniq).
    apply: ler_trans; apply Bigreal.ler_sum => k' _.
    by rewrite massE hle.
  have -> : Pr[A.main(in_) @ &m : res = out] = mu1 d out.
  + by rewrite muK.
  apply mu1_le_eq_mu1.
  + rewrite /is_lossless -hll.
    rewrite muE Pr[muE] /predT /=; apply eq_sum => x /=.
    by rewrite muK.
  by move=> x; rewrite muK // hle.
qed.

end Le_Eq.

section Parametrized.

(* The main parameter, generally the probability of success *)
declare op p : real. 
(* { real | 0%r < p <= 1%r } as in01_p. *)

(* Probability mass function. Note that this is the definition
   which starts at [n = 0]. *)
op g_mass_failure i = let p = Biased.clamp p in if 0 <= i then p * (1%r - p) ^ i else 0%r.
op geometric_failure = mk g_mass_failure.

local lemma summable_mass : summable g_mass_failure.
proof.
pose cp := Biased.clamp p.
apply (summable_from_bounded _ (fun i => Some i)); 1: by split => /#. 
exists 1%r => n.
rewrite pmap_some map_id.
rewrite /partial (@eq_big_seq _ (fun i => cp * (1%r - cp) ^ i)).
- smt(mem_range expr_ge0).
case (0 <= n) => nat_n; 2: smt(big_geq).
rewrite -mulr_sumr.
case: (0%r < cp) => hgt; 2: smt().
apply ler_pdivl_mull; 1: smt(). 
have -> : inv cp * 1%r = (1%r / (1%r - (1%r - cp))) by smt().
by apply Bigreal.sum_pow_le => /#.
qed.

local lemma sum_mass : 0%r < p => sum g_mass_failure = 1%r. 
proof.
move=> hgt; rewrite (sumEw _ (fun i => Some i) (fun i => 0 <= i) _ _ summable_mass); 2: smt(). 
- by split => /#.
pose cp := Biased.clamp p.
have -> : (fun n => big predT g_mass_failure (pmap (fun i => Some i) (range 0 n))) =
  (fun n => if 0 <= n then (1%r - (1%r - cp) ^ n) else 0%r).
- apply/fun_ext => n. rewrite pmap_some map_id.
  rewrite (@eq_big_seq _ (fun i => cp * (1%r - cp) ^ i)).
  + smt(mem_range expr_ge0).
  case (0 <= n) => nat_n; 2: smt(big_geq).
  rewrite -mulr_sumr Bigreal.sum_pow; 1,2: smt(). 
  by field => /#. 
rewrite (lim_eq 0 _ (fun n => (1%r - (1%r - cp) ^ n))); 1: by auto => />.
rewrite limD; 1: exact cnvC.
- by apply/cnvN/cnv_pow; smt().
by rewrite limC limN lim_pow; 1: smt().
qed.

(* This is temporary, it should reside in Distr.ec *)
lemma isdistr_summable_equiv (m : 'a -> real) :
  isdistr m <=> (forall x, 0%r <= m x) /\ summable m /\ sum m <= 1%r.
proof.
rewrite/bounded. split => [ [ * ] | [ ? [ * ] ] ]; last first.
- split; 1: assumption.
  move => ? ?. apply (ler_trans (sum m)) => //.
  by apply ler_big_sum => //. 
have sumM : summable m.
- exists 1%r.
  have <- : (fun i => `|m i|) = m; smt().
do 2 ! (split => //).
by apply (lerfin_sum _ _ sumM).
qed.

lemma isdistr_geometric_failure : isdistr g_mass_failure.
proof.
apply isdistr_summable_equiv.
split; 1: smt(expr_ge0).
split; 1: exact summable_mass.
case (0%r < p) => h.
+ by apply/lerr_eq/sum_mass.
smt (le0_sum).
qed.

lemma geometric_failure_ll : 0%r < p => is_lossless geometric_failure.
proof.
move=> h; rewrite /is_lossless mu_mass (massK _ isdistr_geometric_failure).
exact sum_mass.
qed.

lemma geometric_failure1E k : 
  mu1 geometric_failure k = 
    let p = Biased.clamp p in 
    if 0 <= k then p * (1%r - p) ^ k else 0%r.
proof. rewrite -massE massK // isdistr_geometric_failure. qed.

section NULL.

declare axiom p_le0 : p <= 0%r.

lemma geometric_failure1E_0 k : mu1 geometric_failure k = 0%r.
proof. rewrite geometric_failure1E; smt(p_le0). qed.

lemma geometric_failure_dnull : geometric_failure = dnull.
proof. by apply eq_distr => ?; rewrite geometric_failure1E_0 dnull1E. qed.

end section NULL.

op geometric = dmap geometric_failure (fun k => k + 1).

lemma geometric1E k : 
  mu1 geometric k = 
   let p = Biased.clamp p in 
   if 1 <= k then p * (1%r - p) ^ (k - 1) else 0%r.
proof.
  rewrite dmap1E /pred1 /(\o) /=. 
  rewrite (mu_eq _ _ (fun x => x = k - 1)) 1:/#.
  rewrite geometric_failure1E /#.
qed.
 
lemma geometric_ll : 0%r < p => is_lossless geometric.
proof. by move=> h; apply/dmap_ll/geometric_failure_ll. qed.

end section Parametrized.

theory ModuleBased.

module M = {
  (* Direct sampling *)
  proc geometric(p : real) = {
      var i;
      i <$ geometric p;
      return i;
  }

  proc geometric_failure(p : real) = {
      var i;
      i <$ geometric_failure p;
      return i;
  }
  
  (* Number of try from a bernoulli *)
  proc loop_try (p : real) = {
    var i <- 0;
    var b <- false;
    while (!b) {
      i <- i + 1;
      b <$ Biased.dbiased p;
    }
    return i;
  }

  proc loop_failure (p : real) = {
    var i <- -1;
    var b <- false;
    while (!b) {
      i <- i + 1;
      b <$ Biased.dbiased p;
    }
    return i;
  }
}.

section Proofs.

lemma loop_failure_ll : phoare [M.loop_failure : 0%r < p ==> true] = 1%r .
proof.
proc.
sp. conseq (: 0%r < p ==> _) => //.
while (0%r < p) (b2i (!b)) 1 (Biased.clamp p); 1..3: smt().
- move=> H. seq 2 : true 1%r 1%r 0%r 0%r (0%r < p) => //.
  + by conseq />.
  + auto; smt(Biased.dbiased_ll).
  auto; smt(Biased.dbiased_ll).
split; 1: smt().
move=> /> z.
rnd; wp; skip => /> &hr.
rewrite Biased.dbiasedE /= /#.
qed.

(* This shall be in Xreal.ec *)
local lemma Ep_bool_gen (d : bool distr) (f : bool -> xreal) :
  Ep d f = mu1 d false ** f false + mu1 d true ** f true.
proof.
have -> := Ep_fin [false; true] d f //; 1: by move => [] //.
rewrite /big.
by have -> : map (d ** f) (filter predT [false; true]) =
  [(d ** f) false; (d ** f) true].
qed.

local lemma loop_failure_bound &m k p_:
  Pr[ M.loop_failure(p_) @ &m : res = k ] <= mu1 (geometric_failure p_) k.
proof.
rewrite geometric_failure1E.
case: (0%r < p_) => hp; last first.
+ have -> : (let p = Biased.clamp p_ in if 0 <= k then p * (1%r - p) ^ k else 0%r) = 0%r by smt().
  byehoare (: (p = p_) `|` 0%xr ==> (false `|` 0%xr)) => //.
  proc.
  while ((!b /\ p = p_) `|` 0%xr); auto.
  + by move=> &hr /=; apply xle_cxr_b => /#.
  move=> &hr; rewrite Ep_bool_gen /= !Biased.dbiased1E /=.
  apply xle_cxr_r => /> _.
  have -> // : Biased.clamp p{hr} = 0%r by smt().
byehoare (: (p = p_) `|` (g_mass_failure p k)%xr ==> _)=> //.
proc.
while ((p = p_ /\ -1 <= i /\ (b => 0 <= i)) `|` (if b then b2r (i = k) else
  let p = Biased.clamp p in if i < k then p * (1%r - p) ^ (k - i - 1) else 0%r)%xr); last first.
+ auto => /> &hr; apply xle_cxr_f => /> /#. 
+ by move=> &hr; do 2!(apply xle_cxr_r => /> *).
wp. skip => /> &h. 
rewrite Ep_bool_gen Biased.dbiased1E Biased.dbiased1E /=.
apply xle_cxr_r => /> *.
have -> /= : -1 <= i{h} + 1 by smt().
have -> /= : 0 <= i{h} + 1 by smt().
case (i{h} + 1 < k) => * />; first by smt(Domain.exprS).
+ by rewrite /(%pos); smt(Domain.expr0).
by rewrite /Biased.clamp; smt(StdOrder.RealOrder.expr_ge0).
qed.

(* FIXME : we can do a generic lemma for this proof *)
local clone Le_Eq as LE with 
  type in_t <- real,
  type out_t <- int.
local module A = { proc main = M.loop_failure }.

lemma loop_failure_distr &m k p_:
  Pr[ M.loop_failure(p_) @ &m : res = k ] = mu1 (geometric_failure p_) k.
proof.
  case : (0%r < p_) => hp; last first.
  + have := loop_failure_bound &m k p_. 
    rewrite geometric_failure1E /=.
    smt (mu_bounded).
  have <- : Pr[ M.loop_failure(p_) @ &m : res = k ] = Pr[ A.main(p_) @ &m : res = k ] by done.
  apply (LE.mu1_le_eq_mu1 A).
  + by rewrite massK; apply isdistr_geometric_failure.
  + by byphoare loop_failure_ll.
  by move=> k'; apply loop_failure_bound.
qed.

equiv loop_failure_equiv : M.loop_failure ~ M.geometric_failure : ={p} ==> ={res}.
proof.
bypr (res{1}) (res{2}) => /> &1 &2*.
rewrite loop_failure_distr //.
byphoare (: p = arg{2} ==> _); 2,3: by auto.
by proc; rnd; auto => />.
qed.

local equiv loop_try_failure : M.loop_try ~ M.loop_failure : ={arg} ==> res{1} = res{2} + 1.
proof. proc; while (={p, b} /\ i{1} = i{2} + 1); auto. qed.

lemma loop_try_ll : phoare [M.loop_try : 0%r < p ==> true] = 1%r .
proof.
bypr => &m h.
have -> : Pr[M.loop_try(arg{m}) @ &m : true] = Pr[M.loop_failure(arg{m}) @ &m : true].
+ by byequiv loop_try_failure.
by byphoare loop_failure_ll.
qed.

lemma loop_try_distr &m k p_:
  Pr[ M.loop_try(p_) @ &m : res = k ] = mu1 (geometric p_) k.
proof.
  have -> : Pr[ M.loop_try(p_) @ &m : res = k ] = Pr[ M.loop_failure(p_) @ &m : res = k - 1 ].
  + by byequiv loop_try_failure.
  rewrite loop_failure_distr // dmap1E /pred1 /(\o).
  apply mu_eq => /#.
qed.

equiv loop_try_equiv : M.loop_try ~ M.geometric : ={p} ==> ={res}.
proof.
bypr (res{1}) (res{2}) => /> &1 &2*.
rewrite loop_try_distr //.
byphoare (: p = arg{2} ==> _); 2,3: by auto.
by proc; rnd; auto => />.
qed.

abstract theory RejSampling.
type out_t.

module Rej = { 
  proc sample_test (d : out_t distr, test : out_t -> bool) = { 
    var r;
    r <$ d;
    return (test r, r);
  } 

  proc sample_biased (d : out_t distr, test : out_t -> bool) = { 
    var b, r;
    b <$ Biased.dbiased (mu d test);
    r <$ if b then dcond d test else d \ test;
    return (b, r);
  } 

  proc sample (d : out_t distr, test : out_t -> bool) = { 
    var r;
    r <$ dcond d test;
    return r;
  }

  proc sample_c2 (d : out_t distr, test : out_t -> bool) = { 
    var c, r;
    c <$ geometric (mu d test);
    r <$ dcond d test;
    return (c, r);
  }

  proc sample_c (d : out_t distr, test : out_t -> bool) = { 
    var cr;
    cr <$ geometric (mu d test) `*` dcond d test;
    return cr;
  } 

  proc loop_c (d : out_t distr, test : out_t -> bool) = { 
    var t, c, r;
    c <- 0;
    t <- false;
    while (!t) { 
      r <$ d;
      t <- test r;
      c <- c + 1;
    }
    return (c, r);
  }

  proc loop (d : out_t distr, test : out_t -> bool) = { 
    var t, r;
    t <- false;
    while (!t) { 
      r <$ d;
      t <- test r;
    }
    return r;
  }
}.

equiv sample_test_biased : Rej.sample_test ~ Rej.sample_biased : ={arg} /\ is_lossless d{1} ==> ={res}.
proof.
 proc.
 rndsem{2} 0.
 rnd (fun r => (test{1} r, r)) snd; skip => /> &2 hdll.
 have -> : dlet (Biased.dbiased (mu d{2} test{2}))
          (fun (b0 : bool) =>
               dmap (if b0 then dcond d{2} test{2} else d{2} \ test{2})
                    (fun (r0 : out_t) => (b0, r0))) = 
        dmap d{2} (fun r => (test{2} r, r)).
 + apply eq_distr => -[b r].
   rewrite dlet1E /= RealSeries.fin_sum_type 1:Finite.finite_bool.     
   rewrite -(eq_big_perm _ _ _ _ Bool.BoolFin.perm_eq_enum_to_seq).
   rewrite !big_cons big_nil /predT /=. 
   rewrite !dmap1E /(\o) /pred1 /=.
   rewrite dexceptedE dcondE /predI /predC /= !Biased.dbiased1E /=.
   have -> : (fun (x : out_t) => test{2} x = b /\ x = r) = 
             (fun (x : out_t) => x = r /\ if b then test{2} r else !test{2} r).
   + apply fun_ext => /#.
   case : b => /= _; rewrite mu0 /=. 
   + smt (eq0_mu mu0_false mu_bounded).
   case: (mu d{2} test{2} = weight d{2}); 2: smt (mu_bounded).
   smt(mu_in_weight mu0_false).
 split.
 + by move=> ? /supp_dmap />. 
 move=> _; split.
 + move=> ? /supp_dmap /> ? ?.
   by rewrite dmap1E /pred1 /(\o) /=; apply mu_eq => /#.
 move=> _ ??; apply /supp_dmap => /#.
qed.

equiv sample_c_c2 : Rej.sample_c2 ~ Rej.sample_c : ={arg} ==> ={res}.
proof.
  proc; rndsem{1} 0; auto => /> &2.
  by rewrite -dprod_dlet => /> [].
qed.

section AUX.

(* FIXME: this version seems beter than the lemma Dexcepted.dexcepted_ll *)
local lemma dexcepted_ll (d : 'a distr) P:
  mu d P < weight d =>
  is_lossless (d \ P).
proof.
move=> h; apply dscale_ll.
rewrite drestrictE /predI /predT /= mu_not /#.
qed.

local op dc (i:out_t distr * (out_t -> bool)) =
  let (d, t) = (i.`1, i.`2) in if 0%r < mu d t then dcond d t else dunit witness.

local lemma dc_ll x : is_lossless (dc x).
proof.
  rewrite /dc /=.
  case: (0%r < mu x.`1 x.`2) => h; last by apply dunit_ll.
  by apply dcond_ll.
qed.

local clone PROM.FullRO as ROi with
  type in_t <- out_t distr * (out_t -> bool),
  type out_t <- out_t,
  op dout <- dc, 
  type d_in_t <- out_t distr * (out_t -> bool),
  type d_out_t <- int * out_t. 

local clone ROi.FullEager.

local module A(RO:ROi.RO) = { 
  proc distinguish(d : out_t distr, test : out_t -> bool) = { 
    var t, c, r; 
    t <- false; c <- 0;
    while (!t) {
      t <$ Biased.dbiased (mu d test);
      if (t) RO.sample (d, test);
      c <- c + 1;
    }
    r <@ RO.get(d, test);
    return (c, r);
  }
}.

equiv loop_c_sample_c2 : Rej.loop_c ~ Rej.sample_c2 : ={arg} /\ is_lossless d{1} ==> ={res}.
proof.
  proc.
  transitivity*{1} { (c,r) <@ ROi.MainD(A, ROi.RO).distinguish(d,test); }.
  + inline distinguish; wp.
    seq 3 6 : (c{1} = c0{2} /\ (ROi.RO.m.[d0,test0]){2} = Some r{1}); last first.
    + inline *; auto => />.
      by move=> &1 &2 hget; rewrite dc_ll /= => r; rewrite domE hget.
    while ( (c, t, d, test){1} = (c0, t0, d0, test0){2} /\ is_lossless d{1} /\ (ROi.RO.m.[d0,test0]){2} = if t{1} then Some r{1} else None);
      last by inline *; auto => /> *; rewrite emptyE.
    wp 2 2.
    transitivity*{1} { (t, r) <@ Rej.sample_test(d, test); }.
    + by inline *; auto.
    transitivity*{1} { (t, r) <@ Rej.sample_biased(d, test); }.
    + by call sample_test_biased; auto => />.
    inline Rej.sample_biased; wp; conseq />.
    seq 3 1 :  ((c, b, d0, test0){1} = (c0, t0, d0, test0){2} /\ is_lossless d0{1} /\ 
                (b \in Biased.dbiased (mu d0 test0)){1} /\ (ROi.RO.m.[d0,test0]){2} = None).
    + by auto => /> /#.
    if{2}; last first.
    + auto => />.
      move=> &2 hll hin _ hn; apply dexcepted_ll.
      by move: hin; rewrite hn /support Biased.dbiased1E /= /#.
    inline *; auto => /> &2 hll hin hget ht.
    move: hin; rewrite /support Biased.dbiased1E ht domE hget /= /dc /=.
    have -> /> : Biased.clamp (mu d0{2} test0{2}) = mu d0{2} test0{2} by smt(mu_bounded).
    by move=> *; rewrite get_setE.
  transitivity*{1} { (c,r) <@ ROi.MainD(A, ROi.LRO).distinguish(d,test); }.
  + call (FullEager.RO_LRO A _); 1: by apply dc_ll.
    by auto => />.
  transitivity*{1} { c <@ M.loop_try (mu d test);
                     r <$ dcond d test; }.
  + inline distinguish M.loop_try.
    seq 6 4: (c0{1} = i{2} /\ (d0, test0){1} = (d,test){2} /\ (0%r < mu d0 test0 /\ (d0, test0) \notin ROi.RO.m){1});
      last first.
    + by inline *; auto; rewrite /dc => /> *; rewrite get_setE.
    while ((c0, t0){1} = (i,b){2} /\ p{2} = (mu d0 test0){1} /\ ((t0 => 0%r < mu d0 test0) /\ (d0, test0) \notin ROi.RO.m){1}).
    + inline *; auto => /> &1 &2 _ _ _ b.
      by rewrite /support Biased.dbiased1E /= /#.
    by inline *; auto => /> *; apply mem_empty.
  sim.
  transitivity*{1} { c <@ M.geometric(mu d test); }.
  + by call loop_try_equiv; auto.
  inline *; auto.
qed.

equiv loop_c_sample_c : Rej.loop_c ~ Rej.sample_c : ={arg} /\ is_lossless d{1} ==> ={res}.
proof.
  transitivity Rej.sample_c2
    (={arg} /\ is_lossless d{1} ==> ={res})
    (={arg} ==> ={res}) => //; 1: smt().
  + apply loop_c_sample_c2.
  proc; rndsem{1} 0; auto => /> &2.
  by rewrite -dprod_dlet => /> -[].
qed.

(* A proof of rejection sampling *)
equiv loop_sample : Rej.loop ~ Rej.sample : ={arg} /\ is_lossless d{1} ==> ={res}.
proof.
 transitivity Rej.loop_c
    (={arg} /\ is_lossless d{1} ==> res{1} = res{2}.`2)
    (={arg} /\ is_lossless d{1} ==> res{1}.`2 = res{2}) => //; 1: smt().
 + proc => /=.
   by while(={t, d, test} /\ (t{1} => ={r})); auto => />.
 transitivity Rej.sample_c2
   (={arg} /\ is_lossless d{1} ==> ={res})
   (={arg} /\ is_lossless d{1} ==> res{1}.`2 = res{2}) => //; 1: smt().
 + by apply loop_c_sample_c2.
 proc *.
 case(0%r < (mu d test){1}).
 + by inline *; auto => /> *; apply geometric_ll.
 suff : equiv [Rej.sample_c2 ~ Rej.sample : ={arg} /\ ! 0%r < mu d{1} test{1} ==> res{1}.`2 = res{2}].
 + by move=> h; call h; auto.
 bypr (res{1}.`2) (res{2}) => /> &1 &2 r h.
 have {h}h: mu d{2} test{2} = 0%r by smt(mu_bounded).
 have ? : Pr[Rej.sample_c2(d{2}, test{2}) @ &1 : res.`2 = r] <= 0%r.
 + byehoare (: ( (mu d test = 0%r) `|` 0%xr) ==> _) => //; 2: by rewrite /= h.
   proc; auto => &hr; apply xle_cxr_r => /eq0_mu ?.
   rewrite EpC Ep_mu /= dcond1E; smt(supportPn).
 have ? : Pr[Rej.sample(d{2}, test{2}) @ &2 : res = r] <= 0%r.
 + byehoare (: ( (mu d test = 0%r) `|` 0%xr) ==> _) => //; 2: by rewrite /= h.
   proc; auto => &hr; apply xle_cxr_r => /eq0_mu ?.
   rewrite Ep_mu /= dcond1E; smt(supportPn).
 smt(mu_bounded).
qed.

end section AUX.

end RejSampling.

end section Proofs.

end ModuleBased.
