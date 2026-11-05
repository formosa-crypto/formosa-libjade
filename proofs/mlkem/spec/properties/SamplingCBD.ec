(* SamplePolyCBD_eta in closed form, and its eta = 2 instance on a 128-byte
   array (two coefficients per byte), the form the noise proofs use *)
require import AllCore IntDiv List StdBigop.
from Jasmin require import JWord.
from JazzEC require import Array32 Array128 Array256.
from CryptoSpecs require import Keccak1600_Spec.
from Spec require import GFq Rq Serialization Symmetric Sampling.
import Zq Bigint BIA.

(* The coefficient k of SamplePolyCBD_e, on the bits of its input *)
op cbd_coef (e : int) (bits : bool list) (k : int) : int =
  bigi predT (fun j => b2i (nth false bits (2 * k * e + j))) 0 e -
  bigi predT (fun j => b2i (nth false bits (2 * k * e + e + j))) 0 e.

op cbd_poly (e : int) (bytes : W8.t list) : poly =
  Array256.init (fun k => incoeff (cbd_coef e (BytesToBits bytes) k)).

lemma samplePolyCBD_h _e _bytes :
  hoare [SamplePolyCBD.sample : arg = (_e, _bytes) /\ 0 <= _e ==> res = cbd_poly _e _bytes].
proof.
proc; sp.
while (0 <= i <= 256 /\ eta_ = _e /\ bits = BytesToBits _bytes /\ 0 <= _e /\
       forall k, 0 <= k < i => rr.[k] = incoeff (cbd_coef _e bits k)).
+ wp; while (0 <= j <= eta_ /\ 0 <= i < 256 /\
      x = bigi predT (fun t => b2i (nth false bits (2 * i * eta_ + t))) 0 j /\
      y = bigi predT (fun t => b2i (nth false bits (2 * i * eta_ + eta_ + t))) 0 j).
  + by auto => /> &hr *; rewrite !big_int_recr //=; smt().
  auto => /> &hr 3? hr ?; rewrite !big_geq //=.
  move=> j ???; have -> : j = _e by smt().
  split; 1: smt().
  move=> k k0 k1; rewrite Array256.get_setE 1:/#.
  by case: (k = i{hr}) => [->|?] //=; apply hr; smt().
auto => /> &hr; split; 1: smt().
move=> i rr 3? h; apply Array256.tP => k kb.
by rewrite Array256.initiE //= h /#.
qed.

lemma samplePolyCBD_ll : islossless SamplePolyCBD.sample.
proof.
proc; sp; while (true) (256 - i); 2: by auto => /#.
move=> z; wp; while (true) (eta_ - j); auto => /#.
qed.

lemma samplePolyCBD_ph _e _bytes :
  phoare [SamplePolyCBD.sample :
    arg = (_e, _bytes) /\ 0 <= _e ==> res = cbd_poly _e _bytes] = 1%r.
proof. by conseq samplePolyCBD_ll (samplePolyCBD_h _e _bytes). qed.

(* the sampler computes its operator *)
lemma samplePolyCBD_opph _e _bytes :
  phoare [SamplePolyCBD.sample : arg = (_e, _bytes) ==> res = samplePolyCBD _e _bytes] = 1%r.
proof.
bypr => &m h.
have -> : Pr[SamplePolyCBD.sample(eta_{m}, bytes{m}) @ &m : res = samplePolyCBD _e _bytes] =
          Pr[SamplePolyCBD.sample(_e, _bytes) @ &m : res = samplePolyCBD _e _bytes].
+ by byequiv (_: ={arg} ==> ={res}) => //; [sim | move: h => /= ->].
by have /= <- := samplePolyCBD_opsem &m (samplePolyCBD _e _bytes) _e _bytes.
qed.

(* the operator in closed form (stated at a memory, as the operator is the
   semantics of the sampler) *)
lemma samplePolyCBDE &m _e _bytes : 0 <= _e => samplePolyCBD _e _bytes = cbd_poly _e _bytes.
proof.
move=> he; have := samplePolyCBD_opsem &m (cbd_poly _e _bytes) _e _bytes.
have -> /= : Pr[SamplePolyCBD.sample(_e, _bytes) @ &m : res = cbd_poly _e _bytes] = 1%r.
+ by byphoare (samplePolyCBD_ph _e _bytes).
by case: (samplePolyCBD _e _bytes = cbd_poly _e _bytes).
qed.

(* ------------------------------------------------------------------------ *)
(* eta = 2 on a 128-byte array *)

module SamplePolyCBD2 = {
  proc sample(bytes : W8.t Array128.t) : poly = {
    var i,j,a,b;
    var rr : poly;
    rr <- witness;
    j <- 0; i <- 0;
    while (i < 128) {
      a <- b2i bytes.[i].[j %% 2 * 4 + 0] + b2i bytes.[i].[j %% 2 * 4 + 1];
      b <- b2i bytes.[i].[j %% 2 * 4 + 2] + b2i bytes.[i].[j %% 2 * 4 + 3];
      rr.[j] <- incoeff  (a - b);
      j <- j + 1;
      a <- b2i bytes.[i].[j %% 2 * 4 + 0] + b2i bytes.[i].[j %% 2 * 4 + 1];
      b <- b2i bytes.[i].[j %% 2 * 4 + 2] + b2i bytes.[i].[j %% 2 * 4 + 3];
      rr.[j] <- incoeff  (a - b);
      j <- j + 1;
      i <- i + 1;
    }
    return rr;
  }
}.

lemma nth_bits128 (b : W8.t Array128.t) n : 0 <= n < 1024 =>
  nth false (BytesToBits (to_list b)) n = b.[n %/ 8].[n %% 8].
proof.
move=> hn; rewrite /BytesToBits (BitEncoding.BitChunking.nth_flatten false 8).
+ by rewrite allP => x /mapP [y [_ ->]]; smt(W8.size_w2bits').
rewrite (nth_map witness); 1: smt(Array128.size_to_list).
by rewrite get_to_list w2bitsE /= nth_mkseq /#.
qed.

lemma cbd_coef2 bits k : cbd_coef 2 bits k =
  b2i (nth false bits (4 * k)) + b2i (nth false bits (4 * k + 1)) -
  (b2i (nth false bits (4 * k + 2)) + b2i (nth false bits (4 * k + 3))).
proof.
rewrite /cbd_coef !(big_ltn 0 2) //= !(big_ltn 1 2) //= !big_geq //=.
by rewrite (: 2 * k * 2 = 4 * k) 1:/#.
qed.

lemma samplePolyCBD2_h _b :
  hoare [SamplePolyCBD2.sample : bytes = _b ==> res = cbd_poly 2 (to_list _b)].
proof.
proc; sp.
while (0 <= i <= 128 /\ j = 2 * i /\ bytes = _b /\
       forall k, 0 <= k < j => rr.[k] = incoeff (cbd_coef 2 (BytesToBits (to_list _b)) k)).
+ auto => /> &hr ?? h ?; split; 1: smt().
  split; 1: ring.
  rewrite (: 2 * i{hr} %% 2 = 0) 1:/# (: (2 * i{hr} + 1) %% 2 = 1) 1:/# /=.
  move=> k k0 k1; rewrite !Array256.get_setE 1,2:/#.
  case: (k = 2 * i{hr} + 1) => [->|?] /=.
  + by rewrite cbd_coef2 !nth_bits128 1..4:/# /#.
  case: (k = 2 * i{hr}) => [->|?] /=.
  + by rewrite cbd_coef2 !nth_bits128 1..4:/# /#.
  by apply h => /#.
auto => />; split; 1: smt().
move=> i rr 3? h; apply Array256.tP => k kb.
by rewrite Array256.initiE //= h /#.
qed.

lemma samplePolyCBD2_ll : islossless SamplePolyCBD2.sample.
proof. by proc; while (true) (128 - i); auto => /#. qed.

lemma samplePolyCBD2_ph _b :
  phoare [SamplePolyCBD2.sample : bytes = _b ==> res = cbd_poly 2 (to_list _b)] = 1%r.
proof. by conseq samplePolyCBD2_ll (samplePolyCBD2_h _b). qed.

equiv samplePolyCBD2_eq :
  SamplePolyCBD2.sample ~ SamplePolyCBD.sample : arg{2} = (2, to_list arg{1}) ==> ={res}.
proof.
proc*; exists* bytes{1}; elim* => b.
call{1} (samplePolyCBD2_ph b); call{2} (samplePolyCBD_ph 2 (to_list b)).
by auto.
qed.

lemma PRF2E s b : PRF 2 s b = to_list (SHAKE256_33_128 s b).
proof. by rewrite /PRF /SHAKE256_33_128 Array128.of_listK // size_SHAKE256. qed.

(* a shorter SHAKE256 output is a prefix of a longer one *)
lemma SHAKE256_take m n1 n2 : 0 <= n1 <= n2 => take n1 (SHAKE256 m n2) = SHAKE256 m n1.
proof. by move=> h; rewrite /SHAKE256 /KECCAK1600 -(SQUEEZE1600_ext _ _ n1 n2). qed.
