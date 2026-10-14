require import Int Xreal Real PROM Leakage Distr DistrExtras DBool FMap FSet.
require AbstractSampling.

(* require Geometric SplitRO. *)
(** The goal of this file is to show indistinguishability between two different
    setups of random oracles:
    - The first one gives the adversary access to a "small" RO, called [InnerRO]
      which is used in [RejRO.get], which performs a rejection sampling loop on
      top of the first RO, and leaks its number of iterations.
    - The second setup replaces [RejRO.get] with a call to [LeakRO.get] which
      performs decorrelated sampling for its result and its leakage, and replaces
      [InnerRO] with a simulator that only makes calls to [LeakRO.get].
 **)

abstract theory SingleStep.

(* -------------------------------------------------------------------- *)
(* Distributions *)
clone include FullRO rename
  "in_t" as "ro_in_t" (* in our case, a product type of seed and context *)
  "out_t" as "ro_out_t".

axiom dout_ll : forall y, is_lossless (dout y).

type s_in_t, s_out_t.
op sampler_of : ro_in_t -> s_in_t. 

op [lossless] ideal_sampler : s_in_t -> s_out_t distr. 

(* Idealized Sampler *)
clone PROM.FullRO as IS with
  type in_t <- s_in_t,
  type out_t <- s_out_t,
  op dout <- ideal_sampler.


(* -------------------------------------------------------------------- *)
(* Main oracle pairs and indistinguishability game *)

module type RO_t = {
  include RO [init, get]
}.

module type Sampler_t = {
  proc init() : unit

  (* sample as in SampleInBall, not as in the RO sampling *)
  proc sample(y : s_in_t) : s_out_t
}. 

type input, output.

module type Distinguisher(R : RO_t, S : Sampler_t) = {
  proc distinguish(x : input) : output { R.get, S.sample }
}.

module Main(D : Distinguisher, R : RO_t, S : Sampler_t) = {
  proc main(x) = {
    var r;
    R.init();
    S.init();
    r <@ D(R, S).distinguish(x);
    return r;
  }
}.

(* Systematically re-sample outputs *)
module ProgRO : RO = {
  include RO [-get]
  proc get(y) = {
    var r;
    r <$ dout y;
    RO.m.[y] <- r;
    return oget RO.m.[y];
  }
}.

(* "Forgetful" RO *)
module ForgetRO : RO = {
  include RO [-get]
  proc get(y) = {
    var r;
    r <$ dout y;
    return r;
  }
}.

module ISAsProc = {
  proc get(x) = {
    var r;
    r <$ ideal_sampler x;
    return r;
  }
}.

(* Idealized version of the sampler *)
module ISR : Sampler_t = {
  include var IS.RO [init]
  proc sample = IS.RO.get
}.

module type Sampler(R : RO_t) = {
  proc init() : unit {}
  proc sample(x : s_in_t) : s_out_t { R.get }
}.

module type RO_set = {
  include RO [set]
}.

module type Reprogrammer(R : RO_set) = {
  proc reprogram(y : s_in_t, r : s_out_t) : unit
}.

(* Simulator *)
(* A first attempt was to simply use reprog = image sampler_of (fdom RO.m) (1).
   It probably works but there are some subtleties.
   One may have an extra axiom which claim that all samplings make at least
   on query to the RO, in which case (1) holds systematically.
   This axiom seems really useless for the user.
   If this is not assumed, then some samplings can make no query to RO.
   In that case, for said inputs, reprogramming should also make no query
   and repeating it several times (because the test [sampler_of y \notin image sampler_of (fdom RO.m)]
   will keep failing) should not be an issue.
   Anyway this requires more proof effort for no real benefit. *)
module Sim(RP : Reprogrammer, S : Sampler_t) : RO_t = {
  module Overlay = {
    var m : (ro_in_t, ro_out_t) fmap
    proc set(x, r) = { m.[x] <- r; }
    proc get(x) = {
      var r;
      r <$ dout x;
      if (x \notin m) {
        m.[x] <- r;
      }
      return oget m.[x];
    }
  }

  var reprog : s_in_t fset

  proc init() = {
    Overlay.m <- empty;
    reprog <- fset0;
  }
  
  proc reprogram(x) = {
    var rs;
    if (x \notin reprog) {
      reprog <- reprog `|` fset1 x; 
      rs <@ S.sample(x);
      RP(Overlay).reprogram(x, rs);
    }
  }

  proc get(y) = {
    var r;
    reprogram(sampler_of y);
    r <@ Overlay.get(y);
    return r;
  }
}.

section.
(* Describes corrects queries that can be made by the sampler.
   These queries must all be fresh (i.e. no query on the same
   input twice) and valid w.r.t. [sampler_of], which describes the
   allowed query space for a given sampler input.
   For example, in the concrete case of the XOF modeling, recall
   that for some sampler input [x], the XOF is called on inputs
   of the form [(x, i)], i.e. [sampler_of = fst]. *)
module SamplerOfCorrect : RO = {
  include RO [-get, set]

  var sampler_input : s_in_t
  var is_valid : bool 

  proc get(y) = {
    var r;
    is_valid <- is_valid
      /\ sampler_of y = sampler_input /\ y \notin RO.m;
    r <@ RO.get(y);
    return r;
  }
  
  proc set(y, r) = {
    is_valid <- is_valid /\ sampler_of y = sampler_input;
    RO.set(y, r);
  }
}.
 
(* Memoized variant of the sampler, which uses
   the memory of the ideal sampler object *)
module Mem(S : Sampler_t) : Sampler_t = {
  proc init = IS.RO.init
  proc sample(x : s_in_t) : s_out_t = {
    var r;
    if (x \notin IS.RO.m) {
      r <@ S.sample(x);
      IS.RO.m.[x] <- r;
    }
    return oget IS.RO.m.[x];
  }
}.

module LogRO = {
  var log : (ro_in_t * ro_out_t) list
  proc init () = {}
  proc get (x : ro_in_t) : ro_out_t = { 
    var y;
    y <@ RO.get(x);
    log <- rcons log (x,y);
    return y;
  }
}.

(* A module without any global variable. *)
module Empty = { }.

(* [S] is stateless: its globals are included in those of [Empty]. *)
declare module S <: Sampler {+Empty}.
declare module SRaw <: Sampler_t {-RO, -IS.RO, -Sim}.
declare axiom S_ll :
  islossless S(RO).init /\ islossless S(RO).sample /\ islossless S(ProgRO).sample.
declare axiom glob_S_tt (s1 s2 : glob S) : s1 = s2. (* S is stateless *)
declare axiom glob_SRaw_tt (s1 s2 : glob SRaw) : s1 = s2.

(* The distribution [ideal_sampler] models correctly the sampler [S] *)
declare axiom ideal_sampler_correct:
  equiv [ SRaw.sample ~ ISAsProc.get : ={arg} ==> ={res}].

(* All queries from S are consistent with its input (w.r.t. [sampler_of]) and all of them
   are fresh (no query is run twice) *)
declare axiom S_sampler_of_correct : hoare [ S(SamplerOfCorrect).sample : 
  arg = SamplerOfCorrect.sampler_input /\ (* sampler_input is used to verify that all calls verify arg = sampler_of y *)
  (forall y, sampler_of y = arg => y \notin RO.m) /\ (* starting from a "fresh" RO *)

  SamplerOfCorrect.is_valid ==> SamplerOfCorrect.is_valid (* only valid queries are made *)
].

op op_sample : (ro_in_t * ro_out_t) list -> s_in_t -> s_out_t option.

module Op_sample_game (S : Sampler) = {
  proc sample(x : s_in_t) : (ro_in_t * ro_out_t) list * s_out_t = {
    var r : s_out_t;
    LogRO.log <- [];    
    r <@ S(LogRO).sample(x);
    return (LogRO.log, r);
  }
}.

declare axiom Op_sample_game_ok : 
  forall x0, 
    hoare [Op_sample_game(S).sample : 
      x = x0 ==>
      op_sample res.`1 x0 = Some res.`2].

declare axiom Op_sample_game_fun log y m:
    phoare [Op_sample_game(S).sample : 
      (forall a b, (a, b) \in log => RO.m.[a] = Some b) /\
      op_sample log x = Some y /\ RO.m = m
      ==>
      res.`1 = log /\ RO.m = m] = 1%r.

section S_MEM.

declare module D <: Distinguisher {-LogRO, -Mem, -S, -SRaw}.
 
local module Mem_log = {
  var m : (s_in_t, (ro_in_t * ro_out_t) list) fmap

  proc init () = { m <- empty; }

  proc sample(x : s_in_t) : s_out_t = {
    var log : (ro_in_t * ro_out_t) list;
    var r : s_out_t;
  
    if (x \notin m) {
      (log, r) <@ Op_sample_game(S).sample(x);
      m.[x] <- log;
    }
    return oget (op_sample (oget m.[x]) x);
  }
}.

local op inv (m : (ro_in_t, ro_out_t) fmap) (logm : (s_in_t, (ro_in_t * ro_out_t) list) fmap) = 
  forall x log, logm.[x] = Some log => 
    (forall a b, (a, b) \in log => m.[a] = Some b) /\
    exists y, op_sample log x = Some y.

local equiv sample_Op_sample : S(RO).sample ~ Op_sample_game(S).sample : 
   ={x, RO.m, glob S} /\ inv RO.m{2} Mem_log.m{2} 
   ==> 
   ={RO.m, glob S} /\ res{1} = res{2}.`2 /\ 
   inv RO.m{2} Mem_log.m{2} /\ (forall a b, (a, b) \in res.`1 => RO.m.[a] = Some b){2}.
proof.
  proc *; inline *; auto.
  call (: ={RO.m} /\ inv RO.m{2} Mem_log.m{2} /\ (forall a b, (a, b) \in LogRO.log => RO.m.[a] = Some b){2}); auto.
  proc; inline *; auto => />.
  rewrite /inv; smt (mem_rcons domE get_setE).
qed.

local equiv sample_Op_sample' x0 : S(RO).sample ~ Op_sample_game(S).sample : 
   ={x, RO.m, glob S} /\ inv RO.m{2} Mem_log.m{2} /\ x0 = x{2} 
   ==> 
   ={RO.m, glob S} /\ op_sample res{2}.`1 x0 = Some res{1} /\ 
   inv RO.m{2} Mem_log.m{2} /\ (forall a b, (a, b) \in res.`1 => RO.m.[a] = Some b){2}.
proof. by conseq sample_Op_sample _ (Op_sample_game_ok x0). qed.

local lemma Op_sample_game_fun' log y m :
  phoare [Op_sample_game(S).sample : 
    (forall a b, (a, b) \in log => RO.m.[a] = Some b) /\
    op_sample log x = Some y /\ RO.m = m
    ==>
   res.`1 = log /\ res.`2 = y /\ RO.m = m] = 1%r.
proof.
  exlim x => x0.
  conseq (Op_sample_game_fun log y m) (Op_sample_game_ok x0) => /> /#.
qed.

local equiv S_mem_log : Main(D, RO, S(RO)).main ~ Main(D, RO, Mem_log).main : ={glob D, arg} ==> ={glob D, res}.
proof.
  proc.
  call (: ={RO.m} /\ inv RO.m{2} Mem_log.m{2}).
  + proc; auto => />; rewrite /inv; smt(domE get_setE).
  + proc *; inline{2} Mem_log.sample.
    sp 0 1; if{2}; auto.
    + ecall (sample_Op_sample' x{1}); auto => />.
      by rewrite /inv; smt(get_setE domE glob_S_tt).
    transitivity{2} { (log, r) <@ Op_sample_game(S).sample(x); }
       (={glob S, RO.m, x} ==> ={RO.m, r}) 
       (x0{2} = x{1} /\ ={RO.m} /\ inv RO.m{2} Mem_log.m{2} /\ x0{2} \in Mem_log.m{2} /\
        exists (y : s_out_t), op_sample (oget Mem_log.m{2}.[x0{2}]) x0{2} = Some y
         ==> 
        r{1} = oget (op_sample (oget Mem_log.m{2}.[x0{2}]) x0{2}) /\
        RO.m{1} = RO.m{2} /\ inv RO.m{2} Mem_log.m{2}) => //.
    + move=> /> &1 &2 hi /(domE Mem_log.m{2} x{2}) hdom.
      exists (glob S){1} RO.m{2} x{2}.
      by case _ : (Mem_log.m{2}.[x{2}]) hdom => // log /hi [_ ].
    + inline *; auto; call (: ={RO.m}); auto.
      proc; inline *; auto.
    elim* => y.
    ecall{1} (Op_sample_game_fun' (oget Mem_log.m{2}.[x0{2}]) y RO.m{1}); auto => />.
    rewrite /inv; smt(domE).
  inline *; auto. 
  move: S_ll => [init_ll _]; call{1} init_ll; auto => />.
  rewrite /inv; smt(emptyE).
qed.
                   
local equiv mem_log_mem: Main(D, RO, Mem_log).main ~ Main(D, RO, Mem(S(RO))).main : ={glob D, arg} ==> ={glob D, res}.
proof.
  proc.
  call (: ={RO.m} /\ IS.RO.m{2} = map (fun x log => oget (op_sample log x)) Mem_log.m{1} /\
           inv RO.m{1} Mem_log.m{1}).
  + proc; auto => />.
    rewrite /inv; smt(get_setE).
  + proc.
    if.
    + by move=> /> &1 &2; rewrite mem_map.
    + symmetry; wp.
      ecall (sample_Op_sample' x{2}); auto => /> &1 &2 hi hnin.
      split; 1: by apply glob_S_tt.  
      rewrite /inv; smt(get_setE map_set).
    by auto => /> &1 &2 *; rewrite oget_map.
  inline *; auto => />; rewrite /inv map_empty /=; smt(emptyE).
qed.

equiv S_mem : Main(D, RO, S(RO)).main ~ Main(D, RO, Mem(S(RO))).main : ={glob D, arg} ==> ={glob D, res}.
proof.
  transitivity  Main(D, RO, Mem_log).main
    (={glob D, arg} ==> ={glob D, res})
    (={glob D, arg} ==> ={glob D, res}) => //; 1: smt().
  + by apply S_mem_log.
  by apply mem_log_mem.
qed.

end section S_MEM.

(* [RP] is stateless: its globals are included in those of [Empty].
   This is what allows commuting two calls to [RP] (with [eager]/[swap]). *)
declare module RP <: Reprogrammer {+Empty}.

declare axiom glob_RP_tt (s1 s2 : glob RP) : s1 = s2. (* RP is stateless *)

declare axiom RP_ll (R <: RO_set {-RP}) : islossless R.set => islossless RP(R).reprogram.
declare axiom RP_sampler_of_correct : hoare [ RP(SamplerOfCorrect).reprogram :
  arg.`1 = SamplerOfCorrect.sampler_input /\ SamplerOfCorrect.is_valid ==> SamplerOfCorrect.is_valid ].

module DelayReprog(S : Sampler_t, RP : Reprogrammer) : Sampler_t = {
  proc init = S.init
  proc sample(x) = {
    var r;
    r <@ S.sample(x);
    RP(RO).reprogram(x, r);
    return r;
  }
}.


declare axiom reprogram_correct:
  equiv [ S(ProgRO).sample ~ DelayReprog(SRaw, RP).sample : ={arg, RO.m} ==> ={res, RO.m} ].

local lemma S_init_ll : islossless S(RO).init.
proof. by case S_ll. qed.

(* ==================================================================== *)
(* Proof of equivalence *)

section EquivProof.
declare module D <: Distinguisher{-RO, -S, -SRaw, -RP, -ISR, -Sim}.

(* -------------------------------------------------------------------- *)
local module EagerRO(S : Sampler_t) : RO_t = {
  proc init = RO.init
  proc get(y) = {
    var r;
    
    (* eager sampling of the sampling function *)
    S.sample(sampler_of y);
    r <@ RO.get(y);
    return r;
  }
}.

(* Call the reprogrammer after each query to the sampler *)
local module ThenReprog(S' : Sampler_t) : Sampler_t = {
  proc init = S'.init
  proc sample(x) = {
    var r;
    r <@ S'.sample(x);
    Sim(RP, S').reprogram(x);
    return r;
  }
}.

local module M(R : RO_t, S : Sampler_t) = Main(D, R, S).
local module MEager(S : Sampler_t) = M(EagerRO(S), S).

(* The base game: the adversary has access to both the RO and
   the sampler, which uses the RO. *)
local module Game0 = M(RO, S(RO)).

(* First hop: before any query to the RO, perform a query
   to the Sampler *)
local module Game1 = MEager(S(RO)). (* = M(EagerRO(S(RO)), S(RO)) *)

(* Second hop: memoize the output of the sampler,
   computing results only once *)
local module Game2 = MEager(Mem(S(RO))).

(* Third hop: all computations from the sampler are
   performed on fresh arguments. The RO used by the sampler
   is thus [ProgRO], which systematically samples/programs its output. *)
local module Game3 = MEager(Mem(S(ProgRO))).

(* Fourth hop: introduce the reprogrammer module *)
local module Game4 = MEager(Mem(DelayReprog(SRaw, RP))).

(* Fifth hop: perform the reprogramming using explicitely the
   simulator in the sampler. This hop is mostly syntactic.
   The behaviour of the RO, which is now explicitely the simulator,
   is unchanged. *)
local module Game5 = M(Sim(RP, Mem(SRaw)), ThenReprog(Mem(SRaw))).

(* Sixth hop: make the ideal object explicit, using
   the fact that [ideal_sampler] is correctly defined *)
local module Game6 = M(Sim(RP, ISR), ThenReprog(ISR)).

(* Seventh (final) hop: remove the reprogramming after a call to the sampler.
   This uses a lazy/eager argument. *)
local module Game7 = M(Sim(RP, ISR), ISR).

(* Hop 0 -> 1 *)
local clone AbstractSampling as AS with
  type in_t <- ro_in_t,
  type s_in_t <- s_in_t,
  type s_out_t <- s_out_t,
  type out_t <- ro_out_t,
  type input <- input,
  type output <- output,
  op dout <- dout
proof *.
realize dout_ll by exact dout_ll.

local module (Game01_LE : AS.Distinguisher)(R : AS.ROPair) = {
  module RO = {
    proc init = R.init  

    proc get(y) = {
      var r;
      R.sample(sampler_of y);
      r <@ R.get(y);
      return r;
    }
  }

  module S = {
    proc init() = {}
    proc sample = R.sample_force  
  }

  proc distinguish = D(RO, S).distinguish
}.

local equiv hop1 : Game0.main ~ Game1.main : ={glob D, arg} ==> ={glob D, res}.
proof.
symmetry. transitivity AS.Main(Game01_LE, AS.ROS(S)).distinguish
  (={glob D, arg} ==> ={glob D, res}) (={glob D, arg} ==> ={glob D, res}); 1,2: smt().
- proc. call (: ={m}(RO, AS.RO)).
  + proc. inline{2} 1.
    do 2 ! (call (: ={m}(RO, AS.RO)); 1: by sim). 
    by auto; smt(glob_S_tt).
  + sim. smt(glob_S_tt).
  + call{1} S_init_ll; inline; auto.
transitivity AS.Main(Game01_LE, AS.LROS(S)).distinguish
  (={glob D, arg} ==> ={glob D, res}) (={glob D, arg} ==> ={glob D, res}); 1,2: smt().
- conseq (AS.lazy_eager S _ glob_S_tt Game01_LE) => //. 
  have S_ll : islossless S(RO).sample by case S_ll.
  have eq : equiv [ S(AS.RO).sample ~ S(RO).sample :
    ={glob S, arg} /\ ={m}(AS.RO,RO) ==> ={res} ] by sim.
  by conseq eq S_ll; smt(glob_S_tt).
proc. call (: ={m}(AS.RO, RO)); first last.
- by sim; smt(glob_S_tt).
- by call{2} S_init_ll; inline; auto.
proc. kill{1} 1; 1: by inline; auto. 
inline. wp 3 2. sim.
qed.

local module (DMem : Distinguisher)(R : RO_t, S : Sampler_t) = {
  module R' = {
    include R [init]
    proc get(y) = {
      var r;
      S.sample(sampler_of y);
      r <@ R.get(y);
      return r;
    }
  }

  proc distinguish = D(R', S).distinguish
}.

local equiv hop2 : Game1.main ~ Game2.main : ={glob D, arg} ==> ={glob D, res}.
proof.
transitivity Main(DMem, RO, S(RO)).main
  (={glob D, arg} ==> ={glob D, res}) (={glob D, arg} ==> ={glob D, res}); 1,2: smt().
- proc. call (: ={RO.m, glob S}); 1,2: by sim.
  call{1} S_init_ll. call{2} S_init_ll.
  by inline; auto; smt(glob_S_tt).
transitivity Main(DMem, RO, Mem(S(RO))).main
  (={glob D, arg} ==> ={glob D, res}) (={glob D, arg} ==> ={glob D, res}); 1,2: smt().
- by conseq (S_mem DMem). 
proc. call (: ={RO.m, IS.RO.m, glob S}); 1,2: by sim. 
by inline; auto; smt(glob_S_tt).
qed.

(* Hop 2 -> 3 *)
local op prog_inv
  (ideal_m : s_in_t fset) (ro_m : (ro_in_t, ro_out_t) fmap) =
  forall y, y \in ro_m => sampler_of y \in ideal_m.

local lemma prog_ideal_up ideal_m ro_m x :
  prog_inv ideal_m ro_m => prog_inv (ideal_m `|` fset1 x) ro_m.
proof.
move => inv x' /inv ?.
rewrite in_fsetU. by left.
qed.

local lemma prog_ro_up ideal_m ro_m y r :
  prog_inv ideal_m ro_m => sampler_of y \in ideal_m =>
  prog_inv ideal_m ro_m.[y <- r].
proof. by move => inv in_ideal x /mem_set [/inv |] //. qed.

local equiv sampler_preserve_valid m :
  S(SamplerOfCorrect).sample ~ S(ProgRO).sample :
    ={arg, RO.m} /\ (SamplerOfCorrect.is_valid /\ SamplerOfCorrect.sampler_input = arg /\ prog_inv m RO.m){1} ==>
    SamplerOfCorrect.is_valid{1} =>
      ={RO.m, res} /\ (prog_inv (m `|` fset1 SamplerOfCorrect.sampler_input) RO.m){1}.
proof.
move: S_ll => [#] _ S_RO_ll ?.
symmetry. proc*. call @[ll] (: !SamplerOfCorrect.is_valid, ={RO.m} /\
  (prog_inv (m `|` fset1 SamplerOfCorrect.sampler_input) RO.m){2}).
- have equiv_S : equiv [ S(SamplerOfCorrect).sample ~ S(RO).sample : ={RO.m, arg} ==> true ].
  + proc (={RO.m}) => //; 1: smt(glob_S_tt).
    by proc*; inline{1} 1; sim.
  conseq equiv_S S_RO_ll => //.
  smt().
- proc. inline. auto => /> &h _ ?? _ _ <<-.
  apply /prog_ro_up => //.
  by rewrite in_fsetU in_fset1.
- move => ? _. done. 
- move => _. proc. inline. auto => /> ? _.
auto => />. smt(glob_S_tt prog_ideal_up).
qed.

local equiv sample_inv m x0 : S(RO).sample ~ S(ProgRO).sample :
  ={arg, RO.m} /\ (arg = x0 /\ x \notin m /\ prog_inv m RO.m){1} ==>
  ={res, RO.m} /\ (prog_inv (m `|` fset1 x0) RO.m){1}.
proof.
transitivity S(SamplerOfCorrect).sample
  (={arg, RO.m} ==> ={res, RO.m})
  (={arg, RO.m} /\ (SamplerOfCorrect.is_valid /\ SamplerOfCorrect.sampler_input = x0 /\ arg = x0 /\ prog_inv m RO.m){1} /\ x0 \notin m
  ==> ={res, RO.m} /\ (prog_inv (m `|` fset1 x0) RO.m){1}) => //; 1: smt().
- proc*. call (: ={RO.m}) => //; 2: by auto; smt(glob_S_tt).
  proc*. inline{2} 1. kill{2} ^SamplerOfCorrect.is_valid<-; 1: by wp.
  by sim.
conseq (: ={RO.m, arg} /\ arg{1} = x0 /\
  (SamplerOfCorrect.is_valid /\ SamplerOfCorrect.sampler_input = arg{2} /\ prog_inv m RO.m){1} ==>
  SamplerOfCorrect.is_valid{1} => (={RO.m, res} /\ (prog_inv (m `|` fset1 SamplerOfCorrect.sampler_input) RO.m){1}))
 (:  arg = SamplerOfCorrect.sampler_input /\ (forall y, sampler_of y = arg => y \notin RO.m)/\ SamplerOfCorrect.is_valid ==> SamplerOfCorrect.is_valid)
 _; 1,2: by auto => /#.
- by conseq S_sampler_of_correct.
by conseq (sampler_preserve_valid m); auto => /#.
qed.

local equiv mem_sample_inv x : Mem(S(RO)).sample ~ Mem(S(ProgRO)).sample :
  ={arg, RO.m, IS.RO.m} /\ (arg = x /\ prog_inv (fdom IS.RO.m) RO.m){1} ==>
  ={res, RO.m, IS.RO.m} /\ (x \in IS.RO.m /\ prog_inv (fdom IS.RO.m) RO.m){1}.
proof.
proc. if => //. wp.
ecall (sample_inv (fdom IS.RO.m{1}) x).
auto => /> &2 _ ?. split; 1: by rewrite mem_fdom.
move => _ 3?. split; 1: exact mem_set.
by rewrite fdom_set.
qed.

local equiv hop3 : Game2.main ~ Game3.main : ={glob D, arg} ==> ={glob D, res}.
proof.
proc.
call (: ={RO.m, IS.RO.m} /\ (prog_inv (fdom IS.RO.m) RO.m){1}); last first.
- by inline init; auto => />; smt(mem_empty). 
- proc. call (: (prog_inv (fdom IS.RO.m) RO.m /\ sampler_of arg \in IS.RO.m){1} /\
    ={RO.m, arg} ==> ={res, RO.m} /\ (prog_inv (fdom IS.RO.m) RO.m){1}); last first.
  + by ecall (mem_sample_inv (sampler_of y{1})) => //.
  proc. seq 1 1: (#pre /\ ={r}); 1: by auto.
  by auto => /> 3? /mem_fdom 2?; apply prog_ro_up.
proc*.
by ecall (mem_sample_inv x{1}).
qed.


(* Hop 3 -> 4 *)
local equiv Mem_Prog_inv : Mem(S(ProgRO)).sample ~ Mem(DelayReprog(SRaw, RP)).sample :
  ={arg, RO.m, IS.RO.m} ==> ={res, RO.m, IS.RO.m}.
proof. proc. if => //. wp. by call reprogram_correct. qed.

local equiv hop4 : Game3.main ~ Game4.main : ={glob D, arg} ==> ={glob D, res}.
proof.
proc. call (: ={RO.m, IS.RO.m}); 3: by sim />.
- proc. sim 1 1. by call Mem_Prog_inv.
by conseq Mem_Prog_inv.
qed.

(* Hop 4 -> 5 *)
local lemma fdom_set (m : ('a, 'b) fmap) x r:
  fdom m `|` fset1 x = fdom m.[x <- r].
proof.
rewrite fsetP => ?.
by rewrite in_fsetU1 mem_fdom mem_fdom mem_set.
qed.

local equiv hop5 : Game4.main ~ Game5.main : ={glob D, arg} ==> ={glob D, res}.
proc. call (: ={IS.RO.m} /\ ={m}(RO, Sim.Overlay) /\
    (Sim.reprog = fdom IS.RO.m){2}); last first.
- by inline; auto => />; smt(fdom0).
- proc. call (: ={m}(RO, Sim.Overlay)); 1: by sim.
  inline. sp. if => //; 1: smt(mem_fdom).
  rcondt{2} ^if; 1: by auto.
  wp. call (: ={m}(RO, Sim.Overlay)); 1: by sim.
  wp. call (: true).
  auto; smt(glob_SRaw_tt glob_RP_tt get_set_sameE fdom_set).
proc. inline{2} Mem. sp. if => //; last first.
- sp. inline.
  rcondf{2} ^if; 1: by auto => />; apply mem_fdom.
  by auto.
inline{1} DelayReprog. swap{1} ^ <@{2} 2.
seq 4 3 : (={x, IS.RO.m} /\ (RO.m, x0, r0){1} = (Sim.Overlay.m, x, r){2}
  /\ (x \notin Sim.reprog /\ r = oget IS.RO.m.[x]
  /\ Sim.reprog `|` fset1 x = fdom IS.RO.m /\ x \in IS.RO.m){2}).
- wp. call(: true).
  auto; smt(glob_SRaw_tt get_set_eqE mem_fdom fdom_set mem_set).
inline{2}.
rcondt{2} ^if; 1: by auto. 
rcondf{2} ^if; 1: by auto.
call (: ={m}(RO,Sim.Overlay)); 1: by sim.
by auto => /> *; exact glob_RP_tt.
qed.

(* Hop 5 -> 6 *)
(* Ideal Object, just expressed w.r.t. S *)
local module type ISDistinguisher(S : Sampler_t) = {
  proc distinguish(x : input) : output
}.

local equiv dist_ideal (D <: ISDistinguisher {-IS.RO}) :
  D(Mem(SRaw)).distinguish ~ D(ISR).distinguish :
  ={arg, IS.RO.m, glob D} ==> ={res, glob D}.
proof.
proc (={IS.RO.m}); 1,2: smt().
- by sim.
proc.
if{1}; last by rcondf{2} ^if; auto.
rcondt{2} ^if; 1: by auto.
wp. proc change{1} 1 : { r <@ ISAsProc.get(x); }. 
- call ideal_sampler_correct. skip; smt().
inline get. conseq (: ={IS.RO.m, r}); 1: by auto.
by sim.
qed.

local module MI(S : Sampler_t) = D(Sim(RP, S), ThenReprog(S)).
local equiv hop6 : Game5.main ~ Game6.main : ={glob D, arg} ==> ={glob D, res}.  
proof.
proc. call (dist_ideal MI). inline. auto; smt(glob_RP_tt).
qed.

(* Hop 6 -> 7 *)
local module Sim' = Sim(RP, ISR).

local clone include IterProc with
  type t <- s_in_t.

local module RRO : Sampler_t = {
  var l : s_in_t list
  proc init() = {
    ISR.init();
    l <- [];
  }

  proc sample(x) = {
    var r;
    r <@ ISR.sample(x);
    l <- rcons l x;
    Sim'.reprogram(x);
    return r;
  }

  module I = { proc f = Sim'.reprogram }
  proc reprog() = { Iter(I).iter(l); }
}.

local module LRRO : Sampler_t = {
  include RRO [-sample]
  proc sample(x) = {
    var r;
    r <@ ISR.sample(x);
    RRO.l <- rcons RRO.l x;
    return r;
  }
}.

local module WrapLE = {
  proc eager_(x) = {
    var r;
    Sim'.init();
    RRO.init();
    RRO.reprog();
    r <@ D(Sim', RRO).distinguish(x);
    return r;
  }
    
  proc lazy(x) = {
    var r;
    Sim'.init();
    RRO.init();
    r <@ D(Sim', LRRO).distinguish(x);
    RRO.reprog();
    return r;
  }
}.
    
local lemma reprog_ll : islossless RRO.reprog.
proof.
proc. call (iter_ll RRO.I) => //.
proc.
islossless.
conseq (RP_ll Sim'.Overlay _).
by proc; wp.
qed.

local equiv reprogram_iter1 : Sim'.reprogram ~ Iter(RRO.I).iter :
  ={glob Sim'} /\ l{2} = [x{1}] ==> ={glob Sim'}.
proof.
proc*.
inline{2} iter.
rcondt{2} ^while. by auto.
seq 1 2 : (#pre /\ (l0{2} = [x{1}])).
- by call (: ={glob Sim'}); [ sim | wp ].
by rcondf{2} ^while; auto.
qed.

local lemma eager_f_sample y : eager [
  RRO.I.f(y);, ISR.sample ~ ISR.sample, RRO.I.f(y); :
    ={x, glob Sim'} ==> ={res, glob Sim'} ].
proof.
eager proc.
outline{1} [ ^r<$ .. ^result<- ] IS.RO.get. (* ISR.sample causes "cannot unify abstract functions" for some reason. *)
outline{2} [ ^r<$ .. ^result<- ] IS.RO.get. 
inline f. swap{2} ^x0<- -1. sp.
if{1}; last first.
- rcondf{2} ^if; 2: by sim.
  by auto => />.
rcondt{2} ^if; 1: by auto => />.
swap{2} ^Sim.reprog<- -1.
swap{1} 3 1. sim 3 3.
conseq />.
inline.
swap{1} [ ^x2<- .. ^ <$ {2} ] -2.
swap{2} [ ^x2<- .. ^ <$ {2} ] -2.
wp.
case (x0{1} = x{1}); 1: by auto => />; smt(mem_set).
swap{1} [ ^x2<- .. ^ <$ {2} ] -2.
auto => />. smt(set_set_neqE get_setE).
qed.

(* This is annoying; but such module is practically mandatory when having to prove
   an eager statement that deals with the output of both commands. *)
local module S' = {
  var arg : s_in_t
  var res_ : s_out_t
  proc sample() = { res_ <@ ISR.sample(arg); }
}.

local lemma eager_sample : eager [
  RRO.reprog();, ISR.sample ~ ISR.sample, RRO.reprog(); :
    ={x, RRO.l, glob Sim'} ==> ={res, glob Sim'} ].
proof.
eager proc.
outline{1} [ ^r<$ .. ^result<- ] IS.RO.get. 
outline{2} [ ^r<$ .. ^result<- ] IS.RO.get. 
transitivity{1}
  { S'.res_ <- witness; RRO.reprog(); S'.sample(); }
  (x{1} = S'.arg{2} /\ ={RRO.l, glob Sim'} ==> result{1} = S'.res_{2} /\ ={RRO.l, glob Sim'})
  (S'.arg{1} = x{2} /\ ={RRO.l, glob Sim'} ==> S'.res_{1} = result{2} /\ ={RRO.l, glob Sim'}); 1,2: smt(); 1: by inline{2} S'.sample; sim.
transitivity{2}
  { S'.res_ <- witness; S'.sample(); RRO.reprog(); }
  (={RRO.l, S'.arg, glob Sim'} ==> ={RRO.l, S'.res_, glob Sim'})
  (S'.arg{1} = x{2} /\ ={RRO.l, glob Sim'} ==> S'.res_{1} = result{2} /\ ={RRO.l, glob Sim'}); 1,2: smt(); 2: by inline{1} S'.sample; sim.
inline reprog iter.
swap{2} ^l<- -1. sp. symmetry. conseq />.
eager while (={l, glob S', glob Sim'}) => //; 3..5: by sim.
- inline S'. swap{2} ^l<- 1. wp. symmetry.
  exlim (head witness l{1}) => y.
  proc change{1} 1 : { RRO.I.f(y); }.
  - call (: ={IS.RO.m, glob Sim, glob RP}); by sim />.
  conseq />.
  transitivity{2} { S'.res_ <@ ISR.sample(S'.arg); RRO.I.f(y); }
    (={glob S', glob Sim'} ==> ={glob S', glob Sim'})
    (y = head witness l{2} /\ ={glob S', glob Sim, glob RP} ==> ={glob Sim, glob RP, glob S'}); 1,2: smt(); last first.
  - call (: ={IS.RO.m, glob Sim, glob RP}); by sim />.
  by eager call (eager_f_sample y).
by move=> ??; inline; auto => />. 
qed.

local module O' = Sim(RP, ISR).Overlay.
  
local hoare Sim_reprog_monotone y m : Sim'.reprogram :
  y = arg /\ m = Sim.reprog
  ==> forall z, z \in m \/ z = y => z \in Sim.reprog.
proof.
proc.
if; 2: by auto => /> ?? [] //.
do 2!(call (: true) => //).
auto => &m [#] 2<- 2? []; rewrite in_fsetU in_fset1 => />.
qed.

local module O'' = {
  var input : ro_in_t
  var output : ro_out_t
  proc sample() : unit = { output <@ O'.get(input); }
}.

local module OverlayBad = {
  var arg : s_in_t
  proc set(x, r) = {
    if (sampler_of x = arg /\ sampler_of O''.input <> arg) {
      O'.set(x, r);
    }
  }
}.

local equiv RP_Good : RP(Sim'.Overlay).reprogram ~ RP(OverlayBad).reprogram :
  ={glob RP, Sim.Overlay.m, arg} /\ (OverlayBad.arg = arg.`1 /\ sampler_of O''.input <> OverlayBad.arg){2} ==> ={glob RP, Sim.Overlay.m}.
proof.
transitivity RP(SamplerOfCorrect).reprogram
  (={glob RP, arg} /\ ={m}(Sim'.Overlay,RO) ==> ={glob RP} /\ ={m}(Sim'.Overlay,RO))
  (={glob RP, arg} /\ ={m}(RO,Sim'.Overlay) /\ (SamplerOfCorrect.is_valid{1} /\ SamplerOfCorrect.sampler_input{1} = OverlayBad.arg{2} /\ (OverlayBad.arg = y /\ sampler_of O''.input <> OverlayBad.arg){2}) ==> ={glob RP} /\ ={m}(RO,Sim'.Overlay)); 1,2: smt().
- proc (={m}(Sim'.Overlay,RO)) => //.
  by proc; inline; sim.
conseq
  (: ={glob RP, arg} /\ ={m}(RO,Sim'.Overlay) /\ SamplerOfCorrect.sampler_input{1} = OverlayBad.arg{2} /\ (sampler_of O''.input <> OverlayBad.arg){2}
    ==> SamplerOfCorrect.is_valid{1} => (={glob RP} /\ ={m}(RO,Sim'.Overlay)))
  (: SamplerOfCorrect.sampler_input = y /\ SamplerOfCorrect.is_valid
    ==> SamplerOfCorrect.is_valid)
  => //. 
- by conseq RP_sampler_of_correct.
symmetry.
proc (!SamplerOfCorrect.is_valid) (={m}(Sim'.Overlay, RO) /\ SamplerOfCorrect.sampler_input{2} = OverlayBad.arg{1} /\ (sampler_of O''.input <> OverlayBad.arg){1}); 1,2: smt().
- exact RP_ll.
- by proc; inline; auto => />.
- by move => ? _; islossless.
move => _. proc.
by inline; auto => ? -> //.
qed.

(* swap RRO.reprog ; Sim'.get whenever y has already been reprogrammed *)
local lemma eager_reprog_overlay : eager [
  RRO.reprog();, O'.get ~ O'.get, RRO.reprog(); :
  ={x, glob O', glob RRO} /\ (sampler_of x \in Sim.reprog){1}
  ==> ={res, glob O', glob RRO} ].
proof. eager proc.
outline{1} [ ^r<$ .. ^result<- ] O'.get. 
outline{2} [ ^r<$ .. ^result<- ] O'.get.
transitivity*{1} { result <- witness; RRO.reprog(); result <@ O'.get(x); }; 1: by sim.
transitivity*{2} { result <- witness; result <@ O'.get(x); RRO.reprog(); }; 2: by sim.
inline reprog iter.
swap{2} ^l<- -1. sp.
symmetry.
eager while (={glob RRO, glob O', result, l, x} /\ (sampler_of x \in Sim.reprog){2}) => //; first last.
- by auto => />.
- wp.
  conseq (: _ ==> ={glob Sim', result, l}) (: _ ==> _) (: sampler_of x \in Sim.reprog ==> sampler_of x \in Sim.reprog); 1,2: smt().
  - done.
  - ecall (Sim_reprog_monotone (head witness l) Sim.reprog); 1: by auto => /#.
  by sim.
- wp.
  conseq (: _ ==> ={glob Sim', result, l}) (: _ ==> _) (: sampler_of x \in Sim.reprog ==> sampler_of x \in Sim.reprog); 1,2: smt().
  - done.
  - ecall (Sim_reprog_monotone (head witness l) Sim.reprog); 1: by auto => /#.
  by sim.
- sim />.
swap{2} ^<- +1. wp.
inline f.
swap{1} ^x0<- -1. sp.
if{2}; last first.
- rcondf{1} ^if; 1: by auto; conseq (: true).
  by sim />.
rcondt{1} ^if; 1: by auto; conseq (: true).
swap{1} 1 2.
conseq />.
seq 2 2 : (={glob Sim', result, rs, x, x0, l} /\ (sampler_of x <> x0 /\ sampler_of x \in Sim.reprog){2}).
- swap 1 1. wp. 
  conseq (: ={IS.RO.m, rs}); 2: by sim. 
  auto => /> &m. smt(in_fsetU).
conseq />.
transitivity{1} { O''.sample(); RP(OverlayBad).reprogram(x0, rs); }
  (={glob RP, O'.m, x0, rs} /\ ((result, x){1} = (O''.output, O''.input){2}) /\ (OverlayBad.arg = x0 /\ sampler_of O''.input <> OverlayBad.arg){2} ==> ={glob RP, O'.m} /\ result{1} = O''.output{2})
  (={glob RP, O'.m, rs, x, x0, l} /\ (O''.output, O''.input){1} = (result, x){2} /\ (OverlayBad.arg = x0){1} /\ (sampler_of x <> x0){2} ==> ={glob RP, O'.m} /\ O''.output{1} = result{2}); 1,2: smt().
- call RP_Good. inline sample. by sim />. 
transitivity{2} { RP(OverlayBad).reprogram(x0, rs); O''.sample(); }
  (={glob RP, glob O'', OverlayBad.arg, x0, rs} /\ (OverlayBad.arg = x0){1}
  ==>
  ={glob RP, glob O''})
  (={glob RP, O'.m, rs, x0} /\ (O''.output, O''.input){1} = (result, x){2} /\ (OverlayBad.arg = x0 /\ sampler_of O''.input <> OverlayBad.arg){1}
  ==>
  ={glob RP, O'.m} /\ result{2} = O''.output{1}); 1,2: smt(); last first.
- inline sample. sim 1 1. symmetry. by call RP_Good.
(* FIXME: eager call avec inv devrait être équivalent à ça *)
eager call (: ={glob O'', OverlayBad.arg, arg} ==> ={glob O'', OverlayBad.arg});
2: by auto; smt(glob_RP_tt).
(* TOTHINK: eager proc avec des invariants unilatéraux ? *)
eager proc (={glob O'', OverlayBad.arg}); 1,2: smt(glob_RP_tt); 1,3,4: by sim.
eager proc.
if{2}.
- rcondt{1} ^if; 1: by move => ? /=; conseq />.
  inline. swap{2} [ ^x1<- .. ^ <$ ] @0.
  by auto => />; smt(get_setE set_set_neqE).
rcondf{1} ^if; 1: by move => ? /=; conseq />.
by sim.
qed.

(* -------------------------------------------------------------------- *)
(* Commuting two calls to [Sim'.reprogram] on distinct inputs.
   The two calls write disjoint slices of the overlay, so they commute. *)

(* The two (distinct) inputs of the two calls. *)
local module Args = {
  var a : s_in_t
  var b : s_in_t
}.

(* Guarded overlays: [OverlayA] (resp. [OverlayB]) only performs the writes
   belonging to the slice of [Args.a] (resp. [Args.b]).  As for [OverlayBad],
   the guard is part of the module so that [eager proc] only needs equality
   invariants. *)
local module OverlayA = {
  proc set(x : ro_in_t, r : ro_out_t) = {
    if (sampler_of x = Args.a /\ Args.a <> Args.b) {
      O'.set(x, r);
    }
  }
}.

local module OverlayB = {
  proc set(x : ro_in_t, r : ro_out_t) = {
    if (sampler_of x = Args.b /\ Args.a <> Args.b) {
      O'.set(x, r);
    }
  }
}.

local equiv RP_GoodA : RP(Sim'.Overlay).reprogram ~ RP(OverlayA).reprogram :
  ={glob RP, Sim.Overlay.m, arg} /\ (Args.a = arg.`1 /\ Args.a <> Args.b){2}
  ==> ={glob RP, Sim.Overlay.m}.
proof.
transitivity RP(SamplerOfCorrect).reprogram
  (={glob RP, arg} /\ ={m}(Sim'.Overlay,RO) ==> ={glob RP} /\ ={m}(Sim'.Overlay,RO))
  (={glob RP, arg} /\ ={m}(RO,Sim'.Overlay) /\ (SamplerOfCorrect.is_valid{1} /\
     SamplerOfCorrect.sampler_input{1} = Args.a{2} /\ (Args.a = y /\ Args.a <> Args.b){2})
   ==> ={glob RP} /\ ={m}(RO,Sim'.Overlay)); 1,2: smt().
- proc (={m}(Sim'.Overlay,RO)) => //.
  by proc; inline; sim.
conseq
  (: ={glob RP, arg} /\ ={m}(RO,Sim'.Overlay) /\
     (SamplerOfCorrect.sampler_input{1} = Args.a{2} /\ (Args.a <> Args.b){2})
    ==> SamplerOfCorrect.is_valid{1} => (={glob RP} /\ ={m}(RO,Sim'.Overlay)))
  (: SamplerOfCorrect.sampler_input = y /\ SamplerOfCorrect.is_valid
    ==> SamplerOfCorrect.is_valid)
  => //.
- by conseq RP_sampler_of_correct.
symmetry.
proc (!SamplerOfCorrect.is_valid)
  (={m}(Sim'.Overlay, RO) /\ SamplerOfCorrect.sampler_input{2} = Args.a{1} /\
   (Args.a <> Args.b){1}); 1,2: smt().
- exact RP_ll.
- by proc; inline; auto => />.
- by move => ? _; islossless.
move => _. proc.
by inline; auto => ? -> //.
qed.

local equiv RP_GoodB : RP(Sim'.Overlay).reprogram ~ RP(OverlayB).reprogram :
  ={glob RP, Sim.Overlay.m, arg} /\ (Args.b = arg.`1 /\ Args.a <> Args.b){2}
  ==> ={glob RP, Sim.Overlay.m}.
proof.
transitivity RP(SamplerOfCorrect).reprogram
  (={glob RP, arg} /\ ={m}(Sim'.Overlay,RO) ==> ={glob RP} /\ ={m}(Sim'.Overlay,RO))
  (={glob RP, arg} /\ ={m}(RO,Sim'.Overlay) /\ (SamplerOfCorrect.is_valid{1} /\
     SamplerOfCorrect.sampler_input{1} = Args.b{2} /\ (Args.b = y /\ Args.a <> Args.b){2})
   ==> ={glob RP} /\ ={m}(RO,Sim'.Overlay)); 1,2: smt().
- proc (={m}(Sim'.Overlay,RO)) => //.
  by proc; inline; sim.
conseq
  (: ={glob RP, arg} /\ ={m}(RO,Sim'.Overlay) /\
     (SamplerOfCorrect.sampler_input{1} = Args.b{2} /\ (Args.a <> Args.b){2})
    ==> SamplerOfCorrect.is_valid{1} => (={glob RP} /\ ={m}(RO,Sim'.Overlay)))
  (: SamplerOfCorrect.sampler_input = y /\ SamplerOfCorrect.is_valid
    ==> SamplerOfCorrect.is_valid)
  => //.
- by conseq RP_sampler_of_correct.
symmetry.
proc (!SamplerOfCorrect.is_valid)
  (={m}(Sim'.Overlay, RO) /\ SamplerOfCorrect.sampler_input{2} = Args.b{1} /\
   (Args.a <> Args.b){1}); 1,2: smt().
- exact RP_ll.
- by proc; inline; auto => />.
- by move => ? _; islossless.
move => _. proc.
by inline; auto => ? -> //.
qed.

(* Argument passing through globals, as required by [eager]. *)
local module RPB = {
  var y : s_in_t
  var r : s_out_t
  proc run() = { RP(OverlayB).reprogram(y, r); }
}.

local module SetA = {
  var x : ro_in_t
  var r : ro_out_t
  proc run() = { OverlayA.set(x, r); }
}.

(* Innermost commutation: a single write in the slice of [Args.a] commutes
   with the whole [RP(OverlayB)] call, which only writes in the slice of
   [Args.b]. *)
local lemma eager_setA_RPB : eager [
  SetA.run();, RP(OverlayB).reprogram ~ RP(OverlayB).reprogram, SetA.run(); :
  ={glob RP, Sim.Overlay.m, SetA.x, SetA.r, Args.a, Args.b, arg}
  ==> ={glob RP, Sim.Overlay.m, SetA.x, SetA.r, Args.a, Args.b} ].
proof.
eager proc (={Sim.Overlay.m, SetA.x, SetA.r, Args.a, Args.b});
  1,2: (by move => &1 &2 />); 1,3,4: by sim.
(* [OverlayB.set] is the only oracle of [RP]: two writes on distinct keys. *)
eager proc.
by inline; wp; skip => />; smt(set_set_neqE).
qed.

(* The two guarded [RP] calls commute. *)
local lemma eager_RPA_RPB : eager [
  RPB.run();, RP(OverlayA).reprogram ~ RP(OverlayA).reprogram, RPB.run(); :
  ={glob RP, Sim.Overlay.m, RPB.y, RPB.r, Args.a, Args.b, arg}
  ==> ={glob RP, Sim.Overlay.m, RPB.y, RPB.r, Args.a, Args.b} ].
proof.
eager proc (={Sim.Overlay.m, RPB.y, RPB.r, Args.a, Args.b});
  1,2: (by move => &1 &2 />); 1: (by sim; smt(glob_RP_tt)); 2,3: by sim.
(* [OverlayA.set] is the only oracle of [RP]; its argument has to be passed
   through globals since a swapping statement may only use globals. *)
eager proc.
transitivity*{1} { RPB.run(); SetA.x <- x; SetA.r <- r; SetA.run(); }; 1: by inline; sim.
transitivity*{2} { SetA.x <- x; SetA.r <- r; SetA.run(); RPB.run(); }; 2: by inline; sim.
swap{1} 1 2. sp 2 2. symmetry. inline RPB.run.
by eager call eager_setA_RPB; auto; smt(glob_RP_tt).
qed.

(* [Sim'.reprogram(t1); Sim'.reprogram(t2)] and [Sim'.reprogram(t2); Sim'.reprogram(t1)]
   are equivalent, i.e. [RRO.I] satisfies the [iter2_eq] hypothesis of [IterProc]. *)
local equiv reprogram_comm : Iter(RRO.I).iter_12 ~ Iter(RRO.I).iter_21 :
  ={glob RRO.I, t1, t2} ==> ={glob RRO.I}.
proof.
proc. inline RRO.I.f.
(* [t1 = t2]: the two programs are the same *)
case (t1{1} = t2{1}); first by sim.
sp 1 1.
(* [t1] is already reprogrammed: that call is a no-op on both sides *)
case (t1{1} \in Sim.reprog{1}).
- rcondf{1} 1; 1: by auto.
  rcondf{2} 3.
  + move => &m. wp; if.
    - do 2!(call (: true) => //).
      by auto; smt(in_fsetU).
    by auto; smt().
  by swap{2} 2 -1; sim.
(* [t2] is already reprogrammed *)
case (t2{1} \in Sim.reprog{1}).
- rcondf{2} 1; 1: by auto; smt().
  rcondf{1} 3.
  + move => &m. wp; if.
    - do 2!(call (: true) => //).
      by auto; smt(in_fsetU).
    by auto; smt().
  by swap{1} 2 -1; sim.
(* both are fresh and distinct: both calls are performed, in reverse order *)
rcondt{1} 1; 1: by auto.
rcondt{2} 1; 1: by auto; smt().
rcondt{1} 5.
- move => &m. wp. do 2!(call (: true) => //). by auto; smt(in_fsetU in_fset1).
rcondt{2} 5.
- move => &m. wp. do 2!(call (: true) => //). by auto; smt(in_fsetU in_fset1).
(* the two updates of [Sim.reprog] commute *)
swap 4 -3. swap 5 -2.
seq 3 3 : (={Sim.reprog, glob RP, Sim.Overlay.m, IS.RO.m} /\
           x{1} = x0{2} /\ x0{1} = x{2} /\ x{1} <> x0{1});
  1: by auto => />; smt(fsetUA fsetUC).
swap 3 -1.
seq 2 2 : (#pre /\ rs{1} = rs0{2} /\ rs0{1} = rs{2}); last first.
(* the two calls to [RP] write disjoint slices of the overlay *)
- conseq (: ={Sim.reprog, glob RP, Sim.Overlay.m, IS.RO.m} /\ x{1} = x0{2} /\ x0{1} = x{2} /\
            x{1} <> x0{1} /\ x{2} <> x0{2} /\ rs{1} = rs0{2} /\ rs0{1} = rs{2} ==> _); 1: smt().
  (* guard the two calls by their respective slices *)
  transitivity*{1}
    { Args.a <- x; Args.b <- x0; RP(OverlayA).reprogram(x, rs); RP(OverlayB).reprogram(x0, rs0); };
    1: by call RP_GoodB; call RP_GoodA; auto.
  transitivity*{2}
    { Args.a <- x0; Args.b <- x; RP(OverlayB).reprogram(x, rs); RP(OverlayA).reprogram(x0, rs0); };
    2: by symmetry; call RP_GoodA; call RP_GoodB; auto => /#.
  (* the [OverlayB] call becomes the swapping statement of [eager_RPA_RPB] *)
  transitivity*{1}
    { Args.a <- x; Args.b <- x0; RPB.y <- x0; RPB.r <- rs0;
      RP(OverlayA).reprogram(x, rs); RPB.run(); }; 1: by inline RPB.run; sim.
  transitivity*{2}
    { Args.a <- x0; Args.b <- x; RPB.y <- x; RPB.r <- rs;
      RPB.run(); RP(OverlayA).reprogram(x0, rs0); }; 2: by inline RPB.run; sim.
  sp 4 4. symmetry.
  by eager call eager_RPA_RPB; auto; smt(glob_RP_tt).
(* the two samplings are on distinct keys *)
inline.
swap 5 -3. swap 6 -3. swap{2} 3 1. sp 2 2.
by auto => />; smt(set_set_neqE get_setE mem_set).
qed.

local lemma eager_D : eager [
  RRO.reprog();, D(Sim', RRO).distinguish ~ D(Sim', LRRO).distinguish, RRO.reprog(); :
    ={x, RRO.l, glob Sim', glob D} ==> ={res, RRO.l, glob Sim', glob D} ].
proof.
eager proc (={RRO.l, glob Sim'}) => //;
  1,3,4,6,7: (by sim; smt(glob_RP_tt)); last first.
- eager proc. swap{2} ^result<- 1. wp.
  proc change{1} [ 1 .. 2 ] : { r <@ ISR.sample(x); RRO.reprog(); }.
  + by eager call eager_sample.
  seq 1 1 : (#pre /\ ={r}); 1: by sim.
  proc change{2} [ 1 .. 2 ] : { Iter(RRO.I).iter(rcons RRO.l x); RRO.l <- rcons RRO.l x; }.
  + by inline reprog; wp; call (: ={glob Sim'}); [ sim | wp ].
  swap{1} ^<- 1. wp. conseq />.
  proc change{2} 1 : { Iter(RRO.I).iters(RRO.l, [x]); }.
  + by call (iter_cat RRO.I); skip => /> ?; rewrite cats1.
  inline{2} iters. inline{1} reprog.
  call reprogram_iter1.
  by call (: ={glob Sim'}); [ sim | wp ].
eager proc.
eager seq 1 1 : RRO.reprog(); : (#pre /\ (sampler_of y \in Sim.reprog){1}); 4: (by sim); first last.
- swap{2} ^result<- 1. wp.
  by eager call eager_reprog_overlay.
- inline{1} 1. inline{2} 1. sp. if => //.
  seq 1 1: (#post /\ ={x} /\ (sampler_of y \in Sim.reprog){1}); 2: by sim />.
  wp. skip.
  by auto => /> &h _; rewrite in_fsetU in_fset1.
conseq (: _ ==> ={glob RP, glob Sim'})
       (: true ==> sampler_of y \in Sim.reprog) (: true ==> true); 1: by auto.
- by ecall (Sim_reprog_monotone (sampler_of y) Sim.reprog); conseq (: true) => // /> 3?; apply.
- by conseq (: true).
(* [RRO.reprog(); reprogram(z)] and [reprogram(z); RRO.reprog()] both iterate
   [Sim'.reprogram] over two permutations of the same list. *)
inline RRO.reprog.
transitivity*{1} { Iter(RRO.I).iters(RRO.l, [sampler_of y]); };
  1: by inline{2} Iter(RRO.I).iters; call reprogram_iter1; call (: ={glob Sim'}); [ sim | auto ].
transitivity*{2} { Iter(RRO.I).iter_1s(sampler_of y, RRO.l); };
  2: by inline{1} Iter(RRO.I).iter_1s; sp 2 0;
        call (: ={glob Sim'}); [ sim | ]; call (: ={glob Sim'}); [ sim | auto ].
transitivity*{1} { Iter(RRO.I).iter(sampler_of y :: RRO.l); };
  1: by call (iters_perm RRO.I reprogram_comm); auto => /> &2; rewrite -cat1s perm_catC.
symmetry; call (iter1_perm RRO.I reprogram_comm).
skip => />. by move => &1; apply/allP.
qed.

local equiv hop7 : Game6.main ~ Game7.main : ={glob D, arg} ==> ={glob D, res}.
transitivity WrapLE.eager_
  (={glob D, arg} ==> ={glob D, res})
  (={glob D, arg} ==> ={glob D, res}); 1,2: smt().
- proc. call (: ={glob Sim'}); 1,2: by sim.
  inline*.
  rcondf{2} ^while; 1: by auto.
  auto => />. smt(glob_RP_tt).
transitivity WrapLE.lazy
  (={glob D, arg} ==> ={glob D, res})
  (={glob D, arg} ==> ={glob D, res}); 1,2: smt(); last first.
- proc.
  call{1} reprog_ll.
  call (: ={glob Sim'}); 1: by sim.
  + by proc*; inline{1} 1; sim.
  inline init. wp. auto => />. smt(glob_RP_tt).
proc.
seq 2 2 : (#pre /\ ={glob RRO}).
- by sim; smt(glob_RP_tt).
by eager call eager_D.
qed.

equiv equiv_rej_sim :
  Main(D, RO, S(RO)).main ~ Main(D, Sim(RP, ISR), ISR).main :
  ={glob D, arg} ==> ={glob D, res}.
proof.
transitivity Game1.main
  (={glob D, arg} ==> ={glob D, res})
  (={glob D, arg} ==> ={glob D, res}); 1,2: by smt().
- exact hop1.
transitivity Game2.main
  (={glob D, arg} ==> ={glob D, res})
  (={glob D, arg} ==> ={glob D, res}); 1,2: by smt().
- exact hop2.
transitivity Game3.main
  (={glob D, arg} ==> ={glob D, res})
  (={glob D, arg} ==> ={glob D, res}); 1,2: by smt().
- exact hop3.
transitivity Game4.main
  (={glob D, arg} ==> ={glob D, res})
  (={glob D, arg} ==> ={glob D, res}); 1,2: by smt().
- exact hop4.
transitivity Game5.main
  (={glob D, arg} ==> ={glob D, res})
  (={glob D, arg} ==> ={glob D, res}); 1,2: by smt().
- exact hop5.
transitivity Game6.main
  (={glob D, arg} ==> ={glob D, res})
  (={glob D, arg} ==> ={glob D, res}); 1,2: by smt().
- exact hop6.
exact hop7.
qed.
end section EquivProof.
end section.

end SingleStep.


abstract theory TwoSteps.

type ro_in, ro_out.
type s_inner_in, s_inner_out.
type s_in, s_out.

type input, output.

clone SingleStep as F1 with
  type input <- input,
  type output <- output,
  type ro_in_t <- ro_in,
  type ro_out_t <- ro_out,
  type s_in_t <- s_inner_in,
  type s_out_t <- s_inner_out.

clone SingleStep as F2 with
  type input <- input,
  type output <- output,
  type ro_in_t <- s_inner_in,
  type ro_out_t <- s_inner_out,
  type s_in_t <- s_in,
  type s_out_t <- s_out,
  op dout <= F1.ideal_sampler.

module RO = F1.RO.
module ISR = F2.ISR.
  
module type Distinguisher(R : F1.RO_t, S : F2.Sampler_t) = {
  proc distinguish(x : input) : output { R.get, S.sample }
}.

module Main(D : Distinguisher, R : F1.RO_t, S : F2.Sampler_t) = {
  proc main(x) = {
    var r;
    R.init();
    S.init();
    r <@ D(R, S).distinguish(x);
    return r;
  }
}.

module ToRO(S : F1.Sampler_t) : F2.RO_t = {
  proc init = S.init
  proc get = S.sample
}.

module ToSampler(R : F2.RO_t) : F1.Sampler_t = {
  proc init = R.init
  proc sample = R.get
}.

(* The simulator is morally the composition of the two "inner" simulators:
   Sim(R1, R2, S) = F1.Sim(R1, F2.Sim(R2, S)).
   Because of the name changes, it cannot be written as is. *)
module Sim(R1 : F1.Reprogrammer, R2 : F2.Reprogrammer, S : F2.Sampler_t) : F1.RO_t = {
  module Sim2 : F1.Sampler_t = ToSampler(F2.Sim(R2, S))
  module Sim' : F1.RO_t = F1.Sim(R1, Sim2)

  proc init() = {
    Sim2.init();
    Sim'.init();
  }

  proc get = Sim'.get 
}.

module Comp(S2 : F2.Sampler, S1 : F1.Sampler, R : F1.RO_t) : F2.Sampler_t = {
  module S = ToRO(S1(R))
  include S2(S) [sample]
  proc init() = {}
}. 

section.

(* Unfortunately, axioms have to be duplicated manually. *)
(* Oracle restrictions are very verbose but are concretely unimportant,
   as all of S1, S2, RP1 and RP2 are expected to have no global memory. *)
declare module S1 <: F1.Sampler {+F1.Empty}.
declare module SRaw1 <: F1.Sampler_t
  {-F1.RO, -F1.ISR, -F1.SamplerOfCorrect, -F1.Sim, -F1.LogRO}.
declare module RP1 <: F1.Reprogrammer {+F1.Empty}. 

declare module S2 <: F2.Sampler {+F2.Empty}.
declare module SRaw2 <: F2.Sampler_t
  {-F1.ISR, -F1.Sim, -F2.Sim, -F1.RO, -F2.RO, -F2.LogRO, -S1, -RP1, -F2.ISR, -F1.SamplerOfCorrect}.
declare module RP2 <: F2.Reprogrammer {+F2.Empty}. 

declare module D <: TwoSteps.Distinguisher
  {-S1, -S2, -SRaw1, -SRaw2, -RP1, -RP2, -F1.RO, -F2.RO, -F1.ISR, -F2.ISR, -TwoSteps.Sim}.

import F1.
declare axiom S1_ll :
  islossless S1(RO).init /\ islossless S1(RO).sample /\ islossless S1(ProgRO).sample.
declare axiom glob_S1_tt (s1 s2 : glob S1) : s1 = s2. (* S1 is stateless *)
declare axiom glob_SRaw1_tt (s1 s2 : glob SRaw1) : s1 = s2. (* S1 is stateless *)

declare axiom ideal_sampler1_correct:
  equiv [ SRaw1.sample ~ ISAsProc.get : ={arg} ==> ={res}].

declare axiom S1_sampler_of_correct : hoare [ S1(SamplerOfCorrect).sample : 
  arg = SamplerOfCorrect.sampler_input /\
  (forall y, sampler_of y = arg => y \notin RO.m) /\

  SamplerOfCorrect.is_valid ==> SamplerOfCorrect.is_valid 
].

declare axiom S1_Op_sample_game_ok : 
  forall x0, 
    hoare [F1.Op_sample_game(S1).sample : 
      x = x0 ==>
      F1.op_sample res.`1 x0 = Some res.`2].

declare axiom S1_Op_sample_game_fun log y m:
    phoare [F1.Op_sample_game(S1).sample : 
      (forall a b, (a, b) \in log => RO.m.[a] = Some b) /\
      F1.op_sample log x = Some y /\ RO.m = m
      ==>
      res.`1 = log /\ RO.m = m] = 1%r.

declare axiom glob_RP1_tt (s1 s2 : glob RP1) : s1 = s2.

declare axiom RP1_ll (R <: RO_set {-RP1}) : islossless R.set => islossless RP1(R).reprogram.

declare axiom RP1_sampler_of_correct : hoare [ RP1(SamplerOfCorrect).reprogram :
  arg.`1 = SamplerOfCorrect.sampler_input /\ SamplerOfCorrect.is_valid ==> SamplerOfCorrect.is_valid ].

declare axiom reprogram1_correct:
  equiv [ S1(ProgRO).sample ~ DelayReprog(SRaw1, RP1).sample : ={arg, RO.m} ==> ={res, RO.m} ].

import F2.
declare axiom S2_ll :
  islossless S2(RO).init /\ islossless S2(RO).sample /\ islossless S2(ProgRO).sample.
declare axiom glob_S2_tt (s1 s2 : glob S2) : s1 = s2. (* S2 is stateless *)
declare axiom glob_SRaw2_tt (s1 s2 : glob SRaw2) : s1 = s2.

declare axiom ideal_sampler2_correct:
  equiv [ SRaw2.sample ~ ISAsProc.get : ={arg} ==> ={res}].

declare axiom S2_sampler_of_correct : hoare [ S2(SamplerOfCorrect).sample : 
  arg = SamplerOfCorrect.sampler_input /\
  (forall y, sampler_of y = arg => y \notin RO.m) /\

  SamplerOfCorrect.is_valid ==> SamplerOfCorrect.is_valid 
].

declare axiom S2_Op_sample_game_ok : 
  forall x0, 
    hoare [F2.Op_sample_game(S2).sample : 
      x = x0 ==>
      F2.op_sample res.`1 x0 = Some res.`2].

declare axiom S2_Op_sample_game_fun log y m:
    phoare [F2.Op_sample_game(S2).sample : 
      (forall a b, (a, b) \in log => RO.m.[a] = Some b) /\
      F2.op_sample log x = Some y /\ RO.m = m
      ==>
      res.`1 = log /\ RO.m = m] = 1%r.

declare axiom glob_RP2_tt (s1 s2 : glob RP2) : s1 = s2.

declare axiom RP2_ll (R <: RO_set {-RP2}) : islossless R.set => islossless RP2(R).reprogram.

declare axiom RP2_sampler_of_correct : hoare [ RP2(SamplerOfCorrect).reprogram :
  arg.`1 = SamplerOfCorrect.sampler_input /\ SamplerOfCorrect.is_valid ==> SamplerOfCorrect.is_valid ].

declare axiom reprogram2_correct:
  equiv [ S2(ProgRO).sample ~ DelayReprog(SRaw2, RP2).sample : ={arg, RO.m} ==> ={res, RO.m} ].

local module (D1 : F1.Distinguisher)(R : F1.RO_t, S : F1.Sampler_t) = D(R, S2(ToRO(S))).
local module (D2 : F2.Distinguisher)(R : F2.RO_t, S : F2.Sampler_t) = {
    module Sim : F1.RO_t = F1.Sim(RP1, ToSampler(R))
    proc distinguish(x : input) = {
      var y;
      Sim.init();
      y <@ D(Sim, S).distinguish(x);
      return y;
    }
}.

equiv equiv_rej_sim :
  TwoSteps.Main(D, TwoSteps.RO, Comp(S2, S1, TwoSteps.RO)).main ~
    TwoSteps.Main(D, TwoSteps.Sim(RP1, RP2, ISR), ISR).main :
  ={glob D, arg} ==> ={glob D, res}.
proof.
 
have H1 := F1.equiv_rej_sim
  S1 SRaw1 S1_ll glob_S1_tt glob_SRaw1_tt ideal_sampler1_correct S1_sampler_of_correct S1_Op_sample_game_ok S1_Op_sample_game_fun
  RP1 glob_RP1_tt RP1_ll RP1_sampler_of_correct reprogram1_correct D1.
have H2 := F2.equiv_rej_sim
  S2 SRaw2 S2_ll glob_S2_tt glob_SRaw2_tt ideal_sampler2_correct S2_sampler_of_correct S2_Op_sample_game_ok S2_Op_sample_game_fun
  RP2 glob_RP2_tt RP2_ll RP2_sampler_of_correct reprogram2_correct D2.
transitivity F1.Main(D1, F1.RO, S1(F1.RO)).main
  (={glob D, arg} ==> ={res, glob D}) (={glob D, arg} ==> ={res, glob D}); 1,2: smt().
- proc. call (: ={F1.RO.m}); 1,2: sim; 1: smt(glob_S1_tt glob_S2_tt).
  inline. conseq />.
  call{2} (: true ==> true); 2: by auto.
  by case S1_ll.
transitivity F1.Main(D1, F1.Sim(RP1, F1.ISR), F1.ISR).main
  (={glob D, arg} ==> ={res, glob D}) (={glob D, arg} ==> ={res, glob D}); 1,2: smt().
- by conseq H1; smt(glob_S2_tt).
proc*.
transitivity{1} {
  F1.Sim(RP1, F1.ISR).init();
  r <@ Main(D2, RO, S2(RO)).main(x); }
  (={glob D, x} ==> ={r, glob D}) (={glob D, x} ==> ={r, glob D}); 1,2: smt().
- call (: ={glob D}); 2: by inline; auto.
  inline{2} ^ r<@. wp.
  call (: ={m}(F1.IS.RO,RO) /\ ={glob F1.Sim}).
  - by sim; smt(glob_RP1_tt).
  - by sim; smt(glob_S2_tt).
  kill{2} 2; 2: by inline; auto.
  islossless. by case S2_ll.
transitivity{2} {
  F1.Sim(RP1, F1.ISR).init();
  r <@ Main(D2, Sim(RP2, ISR), ISR).main(x);}
  (={glob D, x} ==> ={r, glob D}) (={glob D, x} ==> ={r, glob D}); 1,2: smt().
- by call H2; inline; auto; smt(glob_RP1_tt).
call (: ={glob D}); 2: by inline; auto.
inline. sim. wp. skip; smt(glob_RP1_tt glob_RP2_tt).
qed.
end section.
end TwoSteps.
