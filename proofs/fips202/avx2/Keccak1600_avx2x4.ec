(******************************************************************************
   Keccak1600_avx2x4.ec:

   Correctness proof for the 4-way AVX2 implementation



******************************************************************************)

require import AllCore List Real Int IntDiv StdOrder.

from Jasmin require import JModel_x86.

from CryptoSpecs require export FIPS202_SHA3 FIPS202_Keccakf1600.
from CryptoSpecs require import Keccakf1600_Spec Keccak1600_Spec FIPS202_SHA3_Spec.

require import Keccak_bindings.
require import Avx2_extra.

from JazzEC require import Keccak1600_Jazz.


from JazzEC require import WArray200 WArray800.
from JazzEC require import Array100 Array25.

import IntOrder.



(** Packed 4x-state *)

type state4x = W256.t Array25.t.

op st4x_get a k=
 init_25_64 (fun i => sliceget64_256_25 a (8*(4*i+k)*8)).


lemma st4x_getiE x k i:
 0 <= k < 4 =>
 0 <= i < 25 =>
 (st4x_get x k).[i] = x.[i] \bits64 k.
proof.  
move=> Hk Hi; rewrite initiE //= /sliceget64_256_25 ifT 1:/#.
rewrite get64E pack8E.
apply W64.ext_eq => b Hb.
rewrite bits64iE // initiE //= initiE 1:/# /= initiE 1:/# /= bits8E initiE 1:/# /=.
by congr; smt().
qed.

op st4x_pack (sts: state*state*state*state): state4x =
 init_25_256 (fun i => u256_pack4 sts.`1.[i] sts.`2.[i] sts.`3.[i] sts.`4.[i]).

lemma st4x_packiE (sts: state*state*state*state) i:
 0 <= i < 25 =>
 (st4x_pack sts).[i] = u256_pack4 (sts.`1.[i]) (sts.`2.[i]) (sts.`3.[i]) (sts.`4.[i]).
proof. by rewrite /st4x_pack => Hi; rewrite initiE //. qed.

op st4x_unpack (st4: state4x): state*state*state*state =
 ( st4x_get st4 0
 , st4x_get st4 1
 , st4x_get st4 2
 , st4x_get st4 3
 ).

lemma st4x_unpackK st4x:
 st4x_pack (st4x_unpack st4x) = st4x.
proof.
rewrite /st4x_pack /st4x_unpack.
apply Array25.ext_eq => i Hi; rewrite initiE //.
beta; iota.
rewrite !st4x_getiE //=.
rewrite u256_pack4E -{5}(unpack64K st4x.[i]); congr.
by rewrite unpack64E init_of_list -iotaredE /=. 
qed.

lemma st4x_packK (sts: state*state*state*state):
 st4x_unpack (st4x_pack sts) = sts.
proof.
move: sts => [st0 st1 st2 st3].
rewrite /st4x_pack /st4x_unpack.
congr; 
 by (apply Array25.ext_eq => i Hi;
     rewrite st4x_getiE //= initiE //= u256_pack4E pack4bE //).
qed.

lemma st4x_get_pack0 sts:
 st4x_get (st4x_pack sts) 0 = sts.`1.
proof.
move: sts => [st0 st1 st2 st3] /=.
by circuit.
qed.

lemma st4x_get_pack1 sts:
 st4x_get (st4x_pack sts) 1 = sts.`2.
proof.
move: sts => [st0 st1 st2 st3] /=.
by circuit.
qed.

lemma st4x_get_pack2 sts:
 st4x_get (st4x_pack sts) 2 = sts.`3.
proof.
move: sts => [st0 st1 st2 st3] /=.
by circuit.
qed.

lemma st4x_get_pack3 sts:
 st4x_get (st4x_pack sts) 3 = sts.`4.
proof.
move: sts => [st0 st1 st2 st3] /=.
by circuit.
qed.


op st4x_match st4x sts = (st4x = st4x_pack sts).


op st4x_map (f:W64.t Array25.t->W64.t Array25.t) (st4x:W256.t Array25.t): W256.t Array25.t =
 st4x_pack (f (st4x_get st4x 0), f (st4x_get st4x 1), f (st4x_get st4x 2), f (st4x_get st4x 3)).

lemma st4x_mapE (f: state->state) (st4x: state4x):
 st4x_map f st4x
 = st4x_pack (f (st4x_get st4x 0), f (st4x_get st4x 1), f (st4x_get st4x 2), f (st4x_get st4x 3)).
proof.
apply Array25.ext_eq => i Hi.
by rewrite initiE //= st4x_packiE. 
qed.

lemma st4x_get_map f st4x k:
 0 <= k < 4 =>
 st4x_get (st4x_map f st4x) k
 = f (st4x_get st4x k).
proof.
move=> Hk.
have: k=0 \/ k=1 \/ k=2 \/ k=3 by smt().
move=> [->|]; first by rewrite st4x_get_pack0.
move=> [->|]; first by rewrite st4x_get_pack1.
move=> [->|]; first by rewrite st4x_get_pack2.
move=> ->; by rewrite st4x_get_pack3.
qed.

lemma st4x_map_comp (f g: state -> state) st4x:
 st4x_map f (st4x_map g st4x) = st4x_map (fun s => f (g s)) st4x.
proof.
rewrite {1}/st4x_map /=.
rewrite (st4x_get_map g st4x 0) 1:// (st4x_get_map g st4x 1) 1://.
rewrite (st4x_get_map g st4x 2) 1:// (st4x_get_map g st4x 3) 1://.
by rewrite /st4x_map.
qed.

abbrev st4x_keccak_iota rc (st4x:state4x) =
 st4x.[0 <- VPBROADCAST_4u64 rc `^` st4x.[0]].

lemma sliceget64_256_25E k i st4x:
 0 <= k < 4 =>
 0 <= i < 25 =>
 sliceget64_256_25 st4x (8 * (4 * i + k) * 8)
 = st4x.[i] \bits64 k.
proof.
move=> Hk Hi.
rewrite /sliceget64_256_25 ifT 1:/# get64E bits64E /=.
apply W64.ext_eq => b Hb.
rewrite !initiE //= pack8E initiE //= initiE 1:/# /= initiE 1:/# /=.
by rewrite bits8iE 1:/# /#.
qed.

lemma VPBROADCAST_4u64_bits64 w k:
 0 <= k < 4 =>
 VPBROADCAST_4u64 w \bits64 k = w.
proof.
move=> Hk; have: k\in iota_ 0 4 by smt(mem_iota).
move: {Hk} k; apply/List.allP.
rewrite -iotaredE /=.
by circuit.
qed.

lemma st4x_keccak_iotaE rc st4x:
 st4x_keccak_iota rc st4x
 = st4x_map (fun st=>st.[0 <- st.[0] `^` rc]) st4x.
proof.
rewrite tP => i Hi.
rewrite get_setE //.
rewrite initiE //= !get_setE // !initiE //=.
rewrite -(W4u64.unpack64K) u256_pack4E.
congr.
rewrite unpack64E.
rewrite W4u64.Pack.init_of_list; congr.
rewrite -iotaredE /=.
case: (i=0) => Ei.
 rewrite (sliceget64_256_25E 0 0) // (sliceget64_256_25E 1 0) //.
 rewrite (sliceget64_256_25E 2 0) // (sliceget64_256_25E 3 0) //.
 by rewrite xorwC !xorb64E !VPBROADCAST_4u64_bits64 //.
rewrite (sliceget64_256_25E 0 i) // (sliceget64_256_25E 1 i) //.
by rewrite (sliceget64_256_25E 2 i) // (sliceget64_256_25E 3 i) //.
qed.


op st4x_keccak_pround =  st4x_map keccak_pround_op.

abbrev keccak_round_i i st =
 foldl (fun s i => keccak_round_op rc_spec.[i] s) st (iota_ 0 i).




(******************************************************************************
   
******************************************************************************)

import BitEncoding BitChunking.


op keccak_f1600_x4 = st4x_map keccak_f1600_op.

op st4x0 = Array25.create W256.zero.

lemma st4x0E: st4x_match st4x0 (st0,st0,st0,st0).
proof.
rewrite /st4x_match tP => i Hi.
rewrite createiE // st4x_packiE //; iota.
by rewrite initiE // u256_pack4_zero.
qed.


abbrev st4x_xor64 (st: state4x) (x: int) (t: W64.t) : state4x =
 Array25.init (WArray800.get256 (WArray800.set64 (WArray800.init256 (fun i => st.[i])) x (WArray800.get64 (WArray800.init256 (fun i => st.[i])) x `^` t))).

lemma st4x_get_xor64 (st: state4x) j k t k':
 0 <= j < 25 => 0 <= k < 4 => 0 <= k' < 4 =>
 st4x_get (Array25.init (WArray800.get256 (WArray800.set64 (WArray800.init256 (fun i => st.[i])) (4*j + k) (WArray800.get64 (WArray800.init256 (fun i => st.[i])) (4*j + k) `^` t)))) k'
 = if k' = k then (st4x_get st k).[j <- (st4x_get st k).[j] `^` t] else st4x_get st k'.
proof.
move=> Hj Hk Hk'.
have Ha : forall (a : WArray800.t) i k, 0 <= i < 25 => 0 <= k < 4 => WArray800.get256 a i \bits64 k = WArray800.get64 a (4*i+k).
+ move=> a i0 k0 Hi0 Hk0; rewrite WArray800.get256E WArray800.get64E; apply W64.wordP => b Hb.
  by rewrite W4u64.bits64iE // W32u8.pack32wE 1:/# W8u8.pack8wE // W32u8.Pack.initiE 1:/# W8u8.Pack.initiE 1:/# /= /#.
have Hb : forall (f : int -> W256.t) i k, 0 <= i < 25 => 0 <= k < 4 => WArray800.get64 (WArray800.init256 f) (4*i+k) = f i \bits64 k.
+ move=> f i0 k0 Hi0 Hk0; rewrite WArray800.get64E; apply W64.wordP => b Hb.
  rewrite W8u8.pack8wE // W8u8.Pack.initiE 1:/# /= /WArray800.init256 WArray800.initiE 1:/# /= W4u64.bits64iE //.
  by rewrite W32u8.bits8iE 1:/# (_ : (8 * (4 * i0 + k0) + b %/ 8) %/ 32 = i0) 1:/#; congr; smt().
apply Array25.ext_eq => i Hi; rewrite st4x_getiE // initiE //= Ha // get_set64E 1,2:/# !Hb //.
have -> : (4 * i + k' = 4 * j + k) = (i = j /\ k' = k) by smt().
case: (k' = k) => Ck /=; last by rewrite st4x_getiE.
by rewrite get_setE // !st4x_getiE // Ck; case: (i = j).
qed.

lemma bytes2state_w64L ws:
 bytes2state (w64L_to_bytes ws) = Array25.of_list W64.zero ws.
proof. by rewrite /bytes2state w64L_to_bytesK. qed.

lemma addstate_of_list_rcons (s: state) ws w:
 size ws < 25 =>
 (addstate s (Array25.of_list W64.zero ws)).[size ws <- (addstate s (Array25.of_list W64.zero ws)).[size ws] `^` w]
 = addstate s (Array25.of_list W64.zero (rcons ws w)).
proof.
move=> Hs; have Hs0 := size_ge0 ws.
apply Array25.ext_eq => i Hi; rewrite get_setE 1:/# /addstate /map2 !initiE 1..3:// /= !get_of_list 1..3:// nth_rcons.
case: (i = size ws) => C; first by rewrite C nth_default //= W64.xorw0.
by case: (i < size ws) => C2 //; rewrite nth_default 1:/#.
qed.

lemma w64L_to_bytes_nseq0 n:
 0 <= n => w64L_to_bytes (nseq n W64.zero) = u8zeros (8*n).
proof.
elim/natind: n => [n Hn _ | n Hn IH _]; first by rewrite !nseq0_le 1,2:/#.
rewrite nseqS // -cat1s w64L_to_bytes_cat IH // w64L_to_bytes_singl (_ : 8 * (n + 1) = 8 + 8 * n) 1:/#.
by rewrite -/(u64bytes W64.zero) u64bytes0 cat_nseq // /#.
qed.

op addstate_avx2x4 (st: state4x, l0 l1 l2 l3: W8.t list): state4x =
 st4x_pack ( addstate (st4x_get st 0) (bytes2state l0)
           , addstate (st4x_get st 1) (bytes2state l1)
           , addstate (st4x_get st 2) (bytes2state l2)
           , addstate (st4x_get st 3) (bytes2state l3)).

op absorb_spec_avx2x4 (r8: int) (tb: int) (l0 l1 l2 l3: W8.t list) st4x =
 st4x_match st4x ( ABSORB1600 (W8.of_int tb) r8 l0
                 , ABSORB1600 (W8.of_int tb) r8 l1
                 , ABSORB1600 (W8.of_int tb) r8 l2
                 , ABSORB1600 (W8.of_int tb) r8 l3).

op pabsorb_spec_avx2x4 r8 l0 l1 l2 l3 st4x: bool =
 0 < r8 <= 200 /\
 size l1 = size l0 /\ size l2 = size l0 /\ size l3 = size l0 /\
 st4x_match st4x
            ( addstate (stateabsorb_iblocks (chunk r8 l0) st0) (bytes2state (chunkremains r8 l0))
            , addstate (stateabsorb_iblocks (chunk r8 l1) st0) (bytes2state (chunkremains r8 l1))
            , addstate (stateabsorb_iblocks (chunk r8 l2) st0) (bytes2state (chunkremains r8 l2))
            , addstate (stateabsorb_iblocks (chunk r8 l3) st0) (bytes2state (chunkremains r8 l3))).

lemma pabsorb_spec_avx2x4_nil r8:
 0 < r8 <= 200 =>
 pabsorb_spec_avx2x4 r8 [] [] [] [] st4x0.
proof.
move=> Hr; rewrite /pabsorb_spec_avx2x4 /= chunk0 1:/# /stateabsorb_iblocks /= /chunkremains /= addstate_st0 bytes2state0; split; first smt().
exact st4x0E.
qed.

lemma get256_init256 (f: int -> W256.t) k:
 0 <= k < 25 => WArray800.get256 (WArray800.init256 f) k = f k.
proof.
move=> Hk; rewrite WArray800.get256E -(W32u8.unpack8K (f k)); congr; apply W32u8.Pack.ext_eq => j Hj; rewrite W32u8.get_unpack8 // W32u8.Pack.initiE //= /WArray800.init256 WArray800.initiE 1:/# /=.
by rewrite (: (32 * k + j) %/ 32 = k) 1:/# (: (32 * k + j) %% 32 = j) 1:/#.
qed.

lemma st4x_get_bcast (st: state4x) j w k:
 0 <= j < 25 => 0 <= k < 4 =>
 st4x_get (st.[j <- VPBROADCAST_4u64 w `^` st.[j]]) k = (st4x_get st k).[j <- (st4x_get st k).[j] `^` w].
proof.
move=> Hj Hk; apply Array25.ext_eq => i Hi; rewrite !st4x_getiE // !get_setE //; case: (i = j) => C //.
+ by rewrite W4u64.xorb64E VPBROADCAST_4u64_bits64 // xorwC.
by rewrite st4x_getiE.
qed.

lemma st4x_set256 (st: state4x) j x:
 0 <= j < 25 =>
 Array25.init (WArray800.get256 (WArray800.set256_direct (WArray800.init256 (fun i => st.[i])) (32*j) (x `^` WArray800.get256_direct (WArray800.init256 (fun i => st.[i])) (32*j))))
 = st.[j <- x `^` st.[j]].
proof.
move=> Hj; have G : forall i, 0 <= i < 25 => WArray800.get256 (WArray800.init256 (fun i => st.[i])) i = st.[i].
+ move=> i Hi; rewrite WArray800.get256E; apply W256.wordP => b Hb; rewrite W32u8.pack32wE 1:// W32u8.Pack.initiE 1:/# /= /WArray800.init256 WArray800.initiE 1:/# /= W32u8.bits8iE 1:/#; congr; smt().
by apply Array25.ext_eq => i Hi; rewrite initiE //= get_set256E 1,2:/# get_setE //; case: (i = j) => C; rewrite ?C G.
qed.

lemma st4x_get64_direct (st: state4x) m k:
 0 <= m < 25 => 0 <= k < 4 =>
 WArray800.get64_direct (WArray800.init256 (fun i => st.[i])) (32*m + 8*k) = st.[m] \bits64 k.
proof.
move=> Hm Hk; apply W64.wordP => b Hb; rewrite /WArray800.get64_direct pack8E initiE 1:/# /= initiE 1:/# /=.
by rewrite /WArray800.init256 WArray800.initiE 1:/# /= bits8iE 1:/# bits64iE 1:/#; congr; smt().
qed.

lemma stbytes_st4x (st: state4x) l j:
 0 <= l < 4 => 0 <= j < 200 =>
 (stbytes (st4x_get st l)).[j] = st.[j %/ 8] \bits64 l \bits8 (j %% 8).
proof. by move=> Hl Hj; rewrite /WArray200.init64 WArray200.initiE //= st4x_getiE // /#. qed.

lemma st4x_get_iter k (st: state4x) l:
 0 <= k => 0 <= l < 4 =>
 st4x_get (iter k keccak_f1600_x4 st) l = st_i (st4x_get st l) k.
proof.
move=> Hk Hl; elim: k Hk => [|k Hk IH]; first by rewrite /st_i !iter0.
by rewrite iterS // /keccak_f1600_x4 st4x_get_map // IH /st_i iterS.
qed.

(******************************************************************************
   
******************************************************************************)

lemma state_init_avx2x4_ll:
 islossless M.__state_init_avx2x4.
proof.
proc.
while true (32*25-i).
 by move=> z; auto => /> &m /#.
by auto => /#.
qed.

hoare state_init_avx2x4_h':
 M.__state_init_avx2x4
 : true
 ==> res = st4x0.
proof.
proc; while (0 <= i <= 800 /\ i %% 32 = 0 /\ z256 = W256.zero /\ forall k, 0 <= k < i %/ 32 => st.[k] = W256.zero).
+ wp; skip => &hr [#] Hi0 Hi1 Hm -> H Hc /=; rewrite (: i{hr} = 32 * (i{hr} %/ 32)) 1:/#; split; first smt().
  split; first smt().
  move=> k Hk; rewrite Array25.initiE 1:/# /= WArray800.get_set256E 1,2:/#; case: (k = i{hr} %/ 32) => // C; rewrite get256_init256 1:/# H /#.
auto => /> &hr.
split; first smt().
move=> i0 st0' C1 _ C2 _ H; apply Array25.tP => k Hk; rewrite /st4x0 Array25.createiE // H /#.
qed.


phoare state_init_avx2x4_ph':
 [ M.__state_init_avx2x4
 : true
 ==> res = st4x0
 ] = 1%r.
proof. by conseq state_init_avx2x4_ll state_init_avx2x4_h'. qed.

hoare state_init_avx2x4_h _r8:
 M.__state_init_avx2x4
 : 0 < _r8 <= 200
 ==> pabsorb_spec_avx2x4 _r8 [] [] [] [] res.
proof.
conseq state_init_avx2x4_h' => _ Hr8 st ->.
exact pabsorb_spec_avx2x4_nil.
qed.

phoare state_init_avx2x4_ph _r8:
 [ M.__state_init_avx2x4
 : 0 < _r8 <= 200
 ==> pabsorb_spec_avx2x4 _r8 [] [] [] [] res
 ] = 1%r.
proof. by conseq state_init_avx2x4_ll (state_init_avx2x4_h _r8). qed.


lemma addratebit_avx2x4_ll: islossless M.__addratebit_avx2x4
 by islossless.

hoare addratebit_avx2x4_h _r8 _st:
 M.__addratebit_avx2x4
 : st = _st /\ rATE8 = _r8 /\ 0 < _r8 <= 200
 ==> res = st4x_map (addratebit _r8) _st.
proof.
proc; auto => /> Hr0 Hr1.
rewrite st4x_mapE /addratebit -!addratebitE 1..4:/#.
apply Array25.ext_eq => i Hi; rewrite st4x_packiE // /= !get_setE 1..5:/#.
case: (i = (_r8 - 1) %/ 8) => C /=; last by rewrite -{1}(st4x_unpackK _st) st4x_packiE.
rewrite !st4x_getiE 1..8:/#.
have Hb : 0 <= (8 * _r8 - 1) %% 64 < 64 by smt().
move: Hb (_st.[(_r8 - 1) %/ 8]); move: ((8 * _r8 - 1) %% 64) => b Hb x.
have : b \in iota_ 0 64 by rewrite mem_iota /#.
rewrite -iotaredE /=; do 63! (case => [-> | ]; first by circuit).
by move => ->; circuit.
qed.

phoare addratebit_avx2x4_ph _r8 _st:
 [ M.__addratebit_avx2x4
 : st = _st /\ rATE8 = _r8 /\ 0 < _r8 <= 200
 ==> res = st4x_map (addratebit _r8) _st
 ] = 1%r.
proof. by conseq addratebit_avx2x4_ll (addratebit_avx2x4_h _r8 _st). qed.

