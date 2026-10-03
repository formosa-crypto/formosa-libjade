(******************************************************************************
   Keccak1600_fixedsizes_ref.ec:

   Correctness proof for the Keccak (fixed-sized) memory absorb/squeeze
  REF implementation



******************************************************************************)

require import List Real Distr Int IntDiv CoreMap.

from Jasmin require import JModel.

from CryptoSpecs require export Keccakf1600_Spec.

from JazzEC require import Keccak1600_Jazz.

from JazzEC require import WArray200.
from JazzEC require import Array25.

require import JWordList.
from CryptoSpecs require import FIPS202_Keccakf1600.
from CryptoSpecs require import FIPS202_SHA3_Spec Keccakf1600_Spec.


require import Keccak1600_ref Keccakf1600_ref.
require import Keccakf1600.
require import Keccak1600_subreadwrite.

require import StdOrder.
import IntOrder.

lemma get256d_bits8 (t: WArray200.t) q r:
 0 <= r < 32 => WArray200.get256_direct t q \bits8 r = t.[q + r].
proof. by move=> Hr; rewrite /WArray200.get256_direct W32u8.pack32bE // W32u8.Pack.initiE. qed.

lemma get128d_bits8 (t: WArray200.t) q r:
 0 <= r < 16 => WArray200.get128_direct t q \bits8 r = t.[q + r].
proof. by move=> Hr; rewrite /WArray200.get128_direct W16u8.pack16bE // W16u8.Pack.initiE. qed.

lemma get64d_bits8 (t: WArray200.t) q r:
 0 <= r < 8 => WArray200.get64_direct t q \bits8 r = t.[q + r].
proof. by move=> Hr; rewrite /WArray200.get64_direct W8u8.pack8bE // W8u8.Pack.initiE. qed.

op xabs (st: state) at (l: W8.t list) n : state =
 stwords (WArray200.init (fun i => (stbytes st).[i] `^` (if i < n then l.[i - at] else W8.zero))).

lemma xabs0 st at (l: W8.t list) n:
 n <= at => xabs st at l n = st.
proof.
move=> Hn; apply stbytes_inj; rewrite /xabs stwordsK; apply WArray200.tP => i Hi; rewrite WArray200.initiE //=.
by case: (i < n) => C; [rewrite nth_neg 1:/# | ]; rewrite W8.xorw0.
qed.

lemma xabs_addstate_at st at (l: W8.t list) n:
 at + size l <= n => xabs st at l n = addstate_at st at l.
proof.
move=> Hn; apply stbytes_inj; rewrite /xabs /addstate_at !stwordsK; apply WArray200.tP => i Hi; rewrite WArray200.initiE // WArray200.filliE //=.
case: (at <= i < at + size l) => C; first by rewrite ifT /#.
by case: (i < n) => C2; [rewrite nth_out 1:/# | ]; rewrite W8.xorw0.
qed.

lemma addstate_atE st at (l: W8.t list):
 0 <= at => at + size l <= 200 =>
 addstate_at st at l = addstate st (bytes2state (u8zeros at ++ l)).
proof.
move=> H0 H1; apply stbytes_inj; rewrite stbytes_addstate -bytes2stbytesP /addstate_at !stwordsK; apply WArray200.tP => i Hi; rewrite WArray200.filliE // /addstbytes WArray200.map2iE // WArray200.get_of_list //= nth_cat size_nseq.
rewrite (: max 0 at = at) 1:/# nth_u8zeros; case: (at <= i < at + size l) => C; first by rewrite ifF 1:/#.
by case: (i < at) => C2; [ | rewrite nth_out 1:/#]; rewrite W8.xorw0.
qed.

lemma xabs_win (st0: state) at (l: W8.t list) n p m (v: int -> W8.t):
 p <= n <= p + m =>
 (forall i, p <= i < p + m => v i = if n <= i then l.[i - at] else W8.zero) =>
 stwords (WArray200.init (fun i => if p <= i < p + m then (stbytes (xabs st0 at l n)).[i] `^` v i else (stbytes (xabs st0 at l n)).[i]))
 = xabs st0 at l (p + m).
proof.
move=> Hn Hv; apply stbytes_inj; rewrite /xabs !stwordsK; apply WArray200.tP => i Hi; rewrite !WArray200.initiE //=.
rewrite WArray200.initiE //=; case: (p <= i < p + m) => C; last by case: (i < p) => C2; [rewrite ifT 1:/# ifT 1:/# | rewrite ifF 1:/# ifF 1:/#].
rewrite Hv // -W8.xorwA (: (if i < p + m then l.[i - at] else W8.zero) = l.[i - at]) 1:/#; congr; case: (i < n) => C2.
+ by rewrite ifF 1:/# W8.xorw0.
by rewrite ifT 1:/# W8.xorwC W8.xorw0.
qed.

lemma set64d_xor (t: WArray200.t) a (w: W64.t):
 WArray200.set64_direct t a (WArray200.get64_direct t a `^` w)
 = WArray200.init (fun i => if a <= i < a + 8 then t.[i] `^` (w \bits8 (i - a)) else t.[i]).
proof.
rewrite WArray200.set64E; apply WArray200.tP => i Hi; rewrite !WArray200.initiE //=.
by case: (a <= i < a + 8) => // C; rewrite get64d_bits8 1:/# (: a + (i - a) = i) 1:/#.
qed.

lemma set256d_xor (t: WArray200.t) a (x: W256.t):
 WArray200.set256_direct t a (x `^` WArray200.get256_direct t a)
 = WArray200.init (fun i => if a <= i < a + 32 then t.[i] `^` (x \bits8 (i - a)) else t.[i]).
proof.
rewrite WArray200.set256E; apply WArray200.tP => i Hi; rewrite !WArray200.initiE //=.
by case: (a <= i < a + 32) => // C; rewrite get256d_bits8 1:/# (: a + (i - a) = i) 1:/# W8.xorwC.
qed.

lemma set128d_xor (t: WArray200.t) a (x: W128.t):
 WArray200.set128_direct t a (x `^` WArray200.get128_direct t a)
 = WArray200.init (fun i => if a <= i < a + 16 then t.[i] `^` (x \bits8 (i - a)) else t.[i]).
proof.
rewrite WArray200.set128E; apply WArray200.tP => i Hi; rewrite !WArray200.initiE //=.
by case: (a <= i < a + 16) => // C; rewrite get128d_bits8 1:/# (: a + (i - a) = i) 1:/# W8.xorwC.
qed.

lemma setw_xor (st: state) q (w: W64.t):
 0 <= q < 25 =>
 st.[q <- st.[q] `^` w]
 = stwords (WArray200.init (fun i => if 8 * q <= i < 8 * q + 8 then (stbytes st).[i] `^` (w \bits8 (i - 8 * q)) else (stbytes st).[i])).
proof.
move=> Hq; apply stbytes_inj; rewrite stwordsK; apply WArray200.tP => i Hi; rewrite WArray200.initiE //=.
rewrite WArray200.initiE //= Array25.get_setE 1:/#.
rewrite stbytes_get //; case: (i %/ 8 = q) => C; [rewrite ifT 1:/# -C (: i - 8 * (i %/ 8) = i %% 8) 1:/# | rewrite ifF 1:/#] => //.
qed.

lemma upd64_xabs st0 at (l: W8.t list) n a (w: W64.t):
 a <= n <= a + 8 =>
 (forall r, 0 <= r < 8 => w \bits8 r = if n <= a + r then l.[a + r - at] else W8.zero) =>
 Array25.init (WArray200.get64 (WArray200.set64_direct (WArray200.init64 (fun i => (xabs st0 at l n).[i])) a (WArray200.get64_direct (WArray200.init64 (fun i => (xabs st0 at l n).[i])) a `^` w)))
 = xabs st0 at l (a + 8).
proof.
move=> Hn Hw; rewrite set64d_xor -(xabs_win st0 at l n a 8 (fun i => w \bits8 (i - a))) //.
by move=> i Hi /=; rewrite Hw 1:/# (: a + (i - a) = i) 1:/#.
qed.

lemma upd256_xabs st0 at (l: W8.t list) n a (x: W256.t):
 a <= n <= a + 32 =>
 (forall r, 0 <= r < 32 => x \bits8 r = if n <= a + r then l.[a + r - at] else W8.zero) =>
 Array25.init (WArray200.get64 (WArray200.set256_direct (WArray200.init64 (fun i => (xabs st0 at l n).[i])) a (x `^` WArray200.get256_direct (WArray200.init64 (fun i => (xabs st0 at l n).[i])) a)))
 = xabs st0 at l (a + 32).
proof.
move=> Hn Hx; rewrite set256d_xor -(xabs_win st0 at l n a 32 (fun i => x \bits8 (i - a))) //; by move=> i Hi /=; rewrite Hx 1:/# (: a + (i - a) = i) 1:/#.
qed.

lemma upd128_xabs st0 at (l: W8.t list) n a (x: W128.t):
 a <= n <= a + 16 =>
 (forall r, 0 <= r < 16 => x \bits8 r = if n <= a + r then l.[a + r - at] else W8.zero) =>
 Array25.init (WArray200.get64 (WArray200.set128_direct (WArray200.init64 (fun i => (xabs st0 at l n).[i])) a (x `^` WArray200.get128_direct (WArray200.init64 (fun i => (xabs st0 at l n).[i])) a)))
 = xabs st0 at l (a + 16).
proof.
move=> Hn Hx; rewrite set128d_xor -(xabs_win st0 at l n a 16 (fun i => x \bits8 (i - a))) //; by move=> i Hi /=; rewrite Hx 1:/# (: a + (i - a) = i) 1:/#.
qed.

lemma updw_xabs st0 at (l: W8.t list) q (w: W64.t):
 0 <= q < 25 =>
 (forall r, 0 <= r < 8 => w \bits8 r = l.[8 * q + r - at]) =>
 (xabs st0 at l (8 * q)).[q <- (xabs st0 at l (8 * q)).[q] `^` w] = xabs st0 at l (8 * q + 8).
proof.
move=> Hq Hw; rewrite setw_xor // -(xabs_win st0 at l (8 * q) (8 * q) 8 (fun i => w \bits8 (i - 8 * q))).
+ smt().
+ by move=> i Hi /=; rewrite Hw 1:/# ifT 1:/# (: 8 * q + (i - 8 * q) = i) 1:/#.
done.
qed.

lemma pabsorb_spec_ref_add r8 l m st:
 pabsorb_spec_ref r8 l st =>
 size l %% r8 + size m < r8 =>
 pabsorb_spec_ref r8 (l ++ m) (addstate_at st (size l %% r8) m).
proof.
rewrite /pabsorb_spec_ref => [#] Hr0 Hr1 -> Hs; split => //; have Hm0 : 0 <= size l %% r8 by smt(modz_ge0).
rewrite addstate_atE // 1:/# chunk_cat' 1:// chunkremains_cat 1:// (chunkremains_small r8 (chunkremains r8 l ++ m)) 1:size_cat 1:size_chunkremains 1:/#.
have -> : BitEncoding.BitChunking.chunk r8 (chunkremains r8 l ++ m) = [].
+ by apply size_eq0; rewrite BitEncoding.BitChunking.size_chunk // size_cat size_chunkremains divz_small; smt(size_ge0).
by rewrite cats0 -addstateA (bytes2state_cat (chunkremains r8 l) m) size_chunkremains.
qed.

lemma pabsorb_spec_ref_block r8 l m st:
 pabsorb_spec_ref r8 l st =>
 size l %% r8 + size m = r8 =>
 pabsorb_spec_ref r8 (l ++ m) (keccak_f1600_op (addstate_at st (size l %% r8) m)).
proof.
rewrite /pabsorb_spec_ref => [#] Hr0 Hr1 -> Hs; split => //; have Hm0 : 0 <= size l %% r8 by smt(modz_ge0).
have Hd : r8 %| size (l ++ m) by rewrite size_cat dvdzP; exists (size l %/ r8 + 1); smt(divz_eq).
rewrite addstate_atE // 1:/# (chunkremains_nil _ _ Hr0 Hd) bytes2state0 (addstateC _ st0) addstate_st0 chunk_cat' 1://.
rewrite (chunk_size _ (chunkremains r8 l ++ m)) 1://; first by rewrite size_cat size_chunkremains.
by rewrite (cats1 (BitEncoding.BitChunking.chunk r8 l)) stateabsorb_iblocks_rcons /stateabsorb -addstateA (bytes2state_cat (chunkremains r8 l) m) size_chunkremains.
qed.



abstract theory KeccakArrayRef.

op _ASIZE: int.

axiom _ASIZE_ge0: 0 <= _ASIZE.
axiom _ASIZE_u64: _ASIZE < W64.modulus.

(*
module type MParam = {
  proc keccakf1600_ref (a:W64.t Array25.t) : W64.t Array25.t
  proc state_init_ref (st:W64.t Array25.t) : W64.t Array25.t
  proc addratebit_ref (st:W64.t Array25.t, _RATE8:int) : W64.t Array25.t
}.
*)

clone import PolyArray as A
 with op size <- _ASIZE
      proof ge0_size by exact _ASIZE_ge0.

clone import WArray as WA
 with op size <- _ASIZE.

clone import ReadWriteArray as RW
 with op _ASIZE <- _ASIZE,
      theory A <- A,
      theory WA <- WA
      proof _ASIZE_ge0 by exact _ASIZE_ge0
      proof _ASIZE_u64 by exact _ASIZE_u64.


module MM = {
  proc __addstate (st:W64.t Array25.t, aT:int, buf:W8.t A.t,
                   offset:int, _LEN:int, _TRAILB:int) : W64.t Array25.t *
                                                        int * int = {
    var inc:int;
    var hAS_AVX2:bool;
    var dELTA:int;
    var aT8:int;
    var w:W64.t;
    var t256:W256.t;
    var i:int;
    var t128:W128.t;
    var at:int;
    hAS_AVX2 <@ M.__HAS_FEATURE (4, 1+2+4);
    dELTA <- 0;
    if (((aT %% 8) <> 0)) {
      aT8 <- (8 * (aT %/ 8));
      (dELTA, _LEN, _TRAILB, aT, w) <@ RW.MM.__a_ilen_read_upto8_at (buf, offset,
      dELTA, _LEN, _TRAILB, aT8, aT);
      st <-
      (Array25.init
      (WArray200.get64
      (WArray200.set64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
      aT8 ((get64_direct (WArray200.init64 (fun i_0 => st.[i_0])) aT8) `^` w)
      )));
    } else {

    }
    if (hAS_AVX2) {
      inc <- (_LEN %/ 32);
      i <- 0;
      while ((i < inc)) {
        t256 <-
        (get256_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA));
        dELTA <- (dELTA + 32);
        t256 <-
        (t256 `^`
        (get256_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + (32 * i))));
        st <-
        (Array25.init
        (WArray200.get64
        (WArray200.set256_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + (32 * i)) t256)));
        i <- (i + 1);
      }
      if ((16 <= (_LEN %% 32))) {
        t128 <-
        (get128_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA));
        dELTA <- (dELTA + 16);
        t128 <-
        (t128 `^`
        (get128_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + ((_LEN %/ 32) * 32))));
        st <-
        (Array25.init
        (WArray200.get64
        (WArray200.set128_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + ((_LEN %/ 32) * 32)) t128)));
      } else {

      }
      if ((8 <= (_LEN %% 16))) {
        w <-
        (get64_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA));
        dELTA <- (dELTA + 8);
        st <-
        (Array25.init
        (WArray200.get64
        (WArray200.set64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        (aT + ((_LEN %/ 16) * 16))
        ((get64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
         (aT + ((_LEN %/ 16) * 16))) `^`
        w))));
      } else {

      }
    } else {
      at <- (aT %/ 8);
      offset <- (offset + dELTA);
      dELTA <- 0;
      while ((at < ((aT %/ 8) + (_LEN %/ 8)))) {
        w <- (get64_direct (WA.init8 (fun i_0 => buf.[i_0])) offset);
        offset <- (offset + 8);
        st.[at] <- (st.[at] `^` w);
        at <- (at + 1);
      }
    }
    aT <- (aT + (8 * (_LEN %/ 8)));
    _LEN <- (_LEN %% 8);
    if (((0 < _LEN) \/ ((_TRAILB %% 256) <> 0))) {
      aT8 <- aT;
      (dELTA, _LEN, _TRAILB, aT, w) <@ RW.MM.__a_ilen_read_upto8_at (buf, offset,
      dELTA, _LEN, _TRAILB, aT, aT);
      st <-
      (Array25.init
      (WArray200.get64
      (WArray200.set64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
      aT8 ((get64_direct (WArray200.init64 (fun i_0 => st.[i_0])) aT8) `^` w)
      )));
    } else {

    }
    offset <- (offset + dELTA);
    return (st, aT, offset);
  }
  proc __absorb (st:W64.t Array25.t, aT:int, buf:W8.t A.t,
                 _TRAILB:int, _RATE8:int) : W64.t Array25.t * int = {
    var _LEN:int;
    var iTERS:int;
    var offset:int;
    var i:int;
    var  _0:int;
    var  _1:int;
    var  _2:int;
    offset <- 0;
    _LEN <- _ASIZE;
    if ((_RATE8 <= (aT + _LEN))) {
      (st,  _0, offset) <@ __addstate (st, aT, buf, offset, (_RATE8 - aT),
      0);
      _LEN <- (_LEN - (_RATE8 - aT));
      aT <- 0;
      (* Erased call to spill *)
      st <@ M._keccakf1600 (st);
      (* Erased call to unspill *)
      iTERS <- (_LEN %/ _RATE8);
      i <- 0;
      while ((i < iTERS)) {
        (st,  _1, offset) <@ __addstate (st, 0, buf, offset, _RATE8, 0);
        (* Erased call to spill *)
        st <@ M._keccakf1600 (st);
        (* Erased call to unspill *)
        i <- (i + 1);
      }
      _LEN <- (_LEN %% _RATE8);
    } else {

    }
    (st, aT,  _2) <@ __addstate (st, aT, buf, offset, _LEN, _TRAILB);
    if ((_TRAILB <> 0)) {
      st <@ M.__addratebit (st, _RATE8);
    } else {

    }
    return (st, aT);
  }
  proc __dumpstate (buf:W8.t A.t, offset:int, _LEN:int,
                    st:W64.t Array25.t) : W8.t A.t * int = {
    var inc:int;
    var hAS_AVX2:bool;
    var dELTA:int;
    var t:W64.t;
    var j:int;
    var t256:W256.t;
    var t128:W128.t;
    var i:int;
    var  _0:int;
    hAS_AVX2 <@ M.__HAS_FEATURE (4, 1+2+4);
    dELTA <- 0;
    if (hAS_AVX2) {
      inc <- (_LEN %/ 32);
      j <- 0;
      while ((j < inc)) {
        t256 <-
        (get256_direct (WArray200.init64 (fun i_0 => st.[i_0])) (32 * j));
        buf <-
        (A.init
        (WA.get8
        (WA.set256_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA) t256)));
        dELTA <- (dELTA + 32);
        j <- (j + 1);
      }
      if ((16 <= (_LEN %% 32))) {
        t128 <-
        (get128_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        ((_LEN %/ 32) * 32));
        buf <-
        (A.init
        (WA.get8
        (WA.set128_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA) t128)));
        dELTA <- (dELTA + 16);
      } else {

      }
      if ((8 <= (_LEN %% 16))) {
        t <-
        (get64_direct (WArray200.init64 (fun i_0 => st.[i_0]))
        ((_LEN %/ 16) * 16));
        buf <-
        (A.init
        (WA.get8
        (WA.set64_direct (WA.init8 (fun i_0 => buf.[i_0]))
        (offset + dELTA) t)));
        dELTA <- (dELTA + 8);
      } else {

      }
    } else {
      i <- 0;
      while ((i < (_LEN %/ 8))) {
        t <- st.[i];
        buf <-
        (A.init
        (WA.get8
        (WA.set64_direct (WA.init8 (fun i_0 => buf.[i_0]))
        offset t)));
        offset <- (offset + 8);
        i <- (i + 1);
      }
    }
    if ((0 < (_LEN %% 8))) {
      t <- st.[(_LEN %/ 8)];
      (buf, dELTA,  _0) <@ RW.MM.__a_ilen_write_upto8 (buf, offset, dELTA,
      (_LEN %% 8), t);
    } else {

    }
    offset <- (offset + dELTA);
    return (buf, offset);
  }
  proc __squeeze (st:W64.t Array25.t, buf:W8.t A.t, _RATE8:int) :
  W64.t Array25.t * W8.t A.t = {
    var offset:int;
    var i:int;
    offset <- 0;
    i <- 0;
    while ((i < (_ASIZE %/ _RATE8))) {
      i <- (i + 1);
      (* Erased call to spill *)
      st <@ M._keccakf1600 (st);
      (* Erased call to unspill *)
      (buf, offset) <@ __dumpstate (buf, offset, _RATE8, st);
    }
    if ((0 < (_ASIZE %% _RATE8))) {
      (* Erased call to spill *)
      st <@ M._keccakf1600 (st);
      (* Erased call to unspill *)
      (buf, offset) <@ __dumpstate (buf, offset, (_ASIZE %% _RATE8), st);
    } else {

    }
    return (st, buf);
  }
}.

lemma addstate_ll: islossless MM.__addstate.
proof.
(* This proof script is independent of selected `KECCAK_FEATURES` *)
proc.
seq 4: true => //; last by islossless.
seq 2: true => //; first by inline*; auto.
seq 1: true => //; first by islossless.
if => //.
 seq 3: true => //; last by islossless.
 wp; while true (inc - i).
  by move=> z; auto => /#.
 by auto => /#.
while true ((aT %/ 8) + (_LEN %/ 8) - at).
 by move=> z; auto => /#.
by auto => /#.
qed.

hoare addstate_h _st _at _buf _off _len _tb:
 MM.__addstate
 : st=_st /\ aT=_at /\ buf=_buf /\ offset=_off /\ _LEN=_len /\ _TRAILB=_tb
 /\ 0 <= _at <= 200
 /\ 0 <= _len
 /\ _at + _len <= 200 - b2i (_tb<>0)
 /\ 0 <= offset /\ offset + _len <= _ASIZE
 /\ 0 <= _tb < 256
 ==> let l = sub _buf _off _len ++ if _tb <> 0 then [W8.of_int _tb] else []
     in res.`1 = addstate_at _st _at l
     /\ res.`2 = _at + size l
     /\ res.`3 = _off + _len.
proof.
proc => /=; pose L := sub _buf _off _len ++ if _tb <> 0 then [W8.of_int _tb] else []; seq 2 : (#pre /\ dELTA = 0); first by inline*; auto.
case (_at %% 8 <> 0 /\ _at + _len < 8 * (_at %/ 8) + 8).
+ rcondt 1; first by auto => /#.
  seq 3 : (st = xabs _st _at L (8 * (_at %/ 8) + 8) /\ aT = _at + size L /\ offset + dELTA = _off + _len /\ _LEN = 0 /\ _TRAILB = 0 /\ _at + size L <= 8 * (_at %/ 8) + 8).
  + wp; ecall (a_ilen_read_upto8_at_h buf offset dELTA _LEN _TRAILB aT8 aT); wp; skip => &hr [#] Est -> -> -> -> -> Ha0 Ha1 Hl0 Hl1 Ho0 Ho1 Ht0 Ht1 -> Ec1 Ec2 [d l t a w] /= R.
    have SL : size L = _len + b2i (_tb <> 0) by rewrite /L size_cat size_sub //; case: (_tb <> 0).
    have B := asubread_u64_bits8 _buf _off w (8 * (_at %/ 8)) _at 0 _len _tb a d l t _ _ _ _ _ _ R; 1..6: smt().
    rewrite (: st{hr} = xabs _st _at L _at) 1:Est 1:xabs0 // upd64_xabs 1:/#.
    by move=> r Hr; rewrite B.
    have E1 : 0 <= _at - 8 * (_at %/ 8) < 8 by smt(divz_eq modz_ge0).
    move: R; rewrite /asubread /srincr /srfnsh E1 /= (: min (max 0 _len) (8 * (_at %/ 8) + 8 - _at) = _len) 1:/# Hl0 Ec2 /= => [#] _ -> -> -> ->.
    by rewrite SL; smt().
  seq 1 : #pre.
  + if; last by rcondf 4; [auto => /# | auto => /#].
    rcondf 3; first by auto => /#.
    rcondf 3; first by auto => /#.
    by rcondf 3; [auto => /# | auto].
  rcondf 3; first by auto => /#.
  auto => /> &hr.
  by move=> _ H; apply xabs_addstate_at.
seq 1 : (st = xabs _st _at L aT /\ aT %% 8 = 0 /\ _at <= aT <= _at + _len /\ dELTA = aT - _at /\ _LEN = _len - (aT - _at) /\ _TRAILB = _tb /\ offset = _off /\ buf = _buf /\ 0 <= _at <= 200 /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb <> 0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256).
+ if; last by skip => &hr [#] [#] -> -> -> -> -> -> *; rewrite xabs0 //; smt().
  wp; ecall (a_ilen_read_upto8_at_h buf offset dELTA _LEN _TRAILB aT8 aT); wp; skip => &hr [#] Est -> -> -> -> -> Ha0 Ha1 Hl0 Hl1 Ho0 Ho1 Ht0 Ht1 -> Ec Ec1 [d l t a w] /= R.
  have E1 : 0 <= _at - 8 * (_at %/ 8) < 8 by smt(divz_eq modz_ge0).
  have B := asubread_u64_bits8 _buf _off w (8 * (_at %/ 8)) _at 0 _len _tb a d l t _ _ _ _ _ _ R; 1..6: smt().
  move: R; rewrite /asubread /srincr /srfnsh E1 /= (: min (max 0 _len) (8 * (_at %/ 8) + 8 - _at) = 8 * (_at %/ 8) + 8 - _at) 1:/# (: _at + _len < 8 * (_at %/ 8) + 8 = false) 1:/# /= => [#] _ -> -> -> ->.
  rewrite (: _at + (8 * (_at %/ 8) + 8 - _at) + b2i false = 8 * (_at %/ 8) + 8) 1:/# (: st{hr} = xabs _st _at L _at) 1:Est 1:xabs0 // upd64_xabs 1:/#.
  by move=> r Hr; rewrite B.
  smt().
seq 1 : (st = xabs _st _at L (aT + 8 * (_LEN %/ 8)) /\ offset + dELTA = _off + (aT - _at) + 8 * (_LEN %/ 8) /\ 0 <= offset /\ 0 <= dELTA /\ aT %% 8 = 0 /\ _at <= aT <= _at + _len /\ _LEN = _len - (aT - _at) /\ _TRAILB = _tb /\ buf = _buf /\ 0 <= _at <= 200 /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb <> 0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256).
+ if.
  + seq 3 : (st = xabs _st _at L (aT + 32 * (_LEN %/ 32)) /\ dELTA = aT - _at + 32 * (_LEN %/ 32) /\ offset = _off /\ aT %% 8 = 0 /\ _at <= aT <= _at + _len /\ _LEN = _len - (aT - _at) /\ _TRAILB = _tb /\ buf = _buf /\ 0 <= _at <= 200 /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb <> 0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256).
    + while (st = xabs _st _at L (aT + 32 * i) /\ dELTA = aT - _at + 32 * i /\ 0 <= i <= inc /\ inc = _LEN %/ 32 /\ offset = _off /\ aT %% 8 = 0 /\ _at <= aT <= _at + _len /\ _LEN = _len - (aT - _at) /\ _TRAILB = _tb /\ buf = _buf /\ 0 <= _at <= 200 /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb <> 0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256).
      + wp; skip => &hr [#] Est Ed Hi0 Hi1 Einc -> Ha8 Ha0 Ha1 El -> -> H0 H1 H2 H3 H4 H5 H6 H7 H8 Hc /=.
        have Hk : aT{hr} + 32 * i{hr} + 32 <= _at + _len by smt(divz_eq modz_ge0).
        rewrite Est upd256_xabs 1:/#.
        move=> r Hr; rewrite wget256_bits8 // 1:/# ifT 1:/# /L Lget // ifT 1:/#.
        by rewrite Ed; congr; ring.
        by rewrite /Hc (: aT{hr} + 32 * (i{hr} + 1) = aT{hr} + 32 * i{hr} + 32) 1:/#; smt().
      + by auto => /> &hr *; smt(divz_ge0).
    seq 1 : (st = xabs _st _at L (aT + 16 * (_LEN %/ 16)) /\ dELTA = aT - _at + 16 * (_LEN %/ 16) /\ offset = _off /\ aT %% 8 = 0 /\ _at <= aT <= _at + _len /\ _LEN = _len - (aT - _at) /\ _TRAILB = _tb /\ buf = _buf /\ 0 <= _at <= 200 /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb <> 0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256).
    + if; last by skip => &hr [#] -> -> -> *; smt().
      wp; skip => &hr [#] Est Ed -> Ha8 Ha0 Ha1 El -> -> H0 H1 H2 H3 H4 H5 H6 H7 Hc /=.
      have E16 : 16 * (_LEN{hr} %/ 16) = _LEN{hr} %/ 32 * 32 + 16 by smt(divz_eq modz_ge0 ltz_pmod).
      have Hk : aT{hr} + _LEN{hr} %/ 32 * 32 + 16 <= _at + _len by smt(divz_eq modz_ge0 ltz_pmod).
      rewrite Est upd128_xabs 1:/#.
      move=> r Hr; rewrite wget128_bits8 // 1:/# ifT 1:/# /L Lget // ifT 1:/#; rewrite Ed; congr; ring.
      by rewrite E16 -addzA; smt().
    if; last by skip => &hr [#] -> -> -> *; smt().
    wp; skip => &hr [#] Est Ed -> Ha8 Ha0 Ha1 El -> -> H0 H1 H2 H3 H4 H5 H6 H7 Hc /=.
    have E8 : 8 * (_LEN{hr} %/ 8) = _LEN{hr} %/ 16 * 16 + 8 by smt(divz_eq modz_ge0 ltz_pmod).
    have Hk : aT{hr} + _LEN{hr} %/ 16 * 16 + 8 <= _at + _len by smt(divz_eq modz_ge0 ltz_pmod).
    rewrite Est upd64_xabs 1:/#.
    move=> r Hr; rewrite wget64_bits8 // 1:/# ifT 1:/# /L Lget // ifT 1:/#; rewrite Ed; congr; ring.
    by rewrite E8 -addzA; smt(divz_ge0).
  while (st = xabs _st _at L (8 * at) /\ offset = _off + 8 * at - _at /\ dELTA = 0 /\ aT %/ 8 <= at <= aT %/ 8 + _LEN %/ 8 /\ aT %% 8 = 0 /\ _at <= aT <= _at + _len /\ _LEN = _len - (aT - _at) /\ _TRAILB = _tb /\ buf = _buf /\ 0 <= _at <= 200 /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb <> 0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256).
  + wp; skip => &hr [#] Est Eo -> Hat0 Hat1 Ha8 Ha0 Ha1 El -> -> H0 H1 H2 H3 H4 H5 H6 H7 Hc /=.
    have Hk : 8 * at{hr} + 8 <= _at + _len by smt(divz_eq modz_ge0).
    rewrite Est updw_xabs 1:/#.
    move=> r Hr; rewrite wget64_bits8 // 1:/# /L Lget // ifT 1:/#; rewrite Eo; congr; ring.
    by rewrite (: 8 * (at{hr} + 1) = 8 * at{hr} + 8) 1:/#; smt().
  auto => /> &hr Ha8 Ha0 Ha1 H0 H1 H2 H3 H4 H5 H6 H7 _; have Ea : 8 * (aT{hr} %/ 8) = aT{hr} by smt(divz_eq).
  rewrite Ea /=; split; first smt(divz_ge0).
  move=> at0 C1 C2 C3; have -> : at0 = aT{hr} %/ 8 + (_len - (aT{hr} - _at)) %/ 8 by smt().
  by rewrite mulzDr Ea; smt(divz_ge0).
seq 2 : (st = xabs _st _at L aT /\ aT %% 8 = 0 /\ _at <= aT <= _at + _len /\ offset + dELTA = _off + (aT - _at) /\ 0 <= offset /\ 0 <= dELTA /\ _LEN = _len - (aT - _at) /\ 0 <= _LEN < 8 /\ _TRAILB = _tb /\ buf = _buf /\ 0 <= _at <= 200 /\ 0 <= _len /\ _at + _len <= 200 - b2i (_tb <> 0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256).
+ auto => /> &hr *; smt(divz_eq modz_ge0 ltz_pmod).
if; last first.
+ wp; skip => &hr [#] -> Ha8 Ha0 Ha1 Eo _ _ El Hl0 Hl1 Et _ H0 H1 H2 H3 H4 H5 H6 H7 Hc /=.
  have SL : size L = _len + b2i (_tb <> 0) by rewrite /L size_cat size_sub //; case: (_tb <> 0).
  have Etb : _tb = 0 by smt().
  by rewrite -/L xabs_addstate_at 1:/# SL; smt().
wp; ecall (a_ilen_read_upto8_at_h buf offset dELTA _LEN _TRAILB aT aT); wp; skip => &hr [#] Est Ha8 Ha0 Ha1 Eo Ho Hd El Hl0 Hl1 Et Eb H0 H1 H2 H3 H4 H5 H6 H7 Hc [d l t a w] /= R.
move: R Hc; rewrite Et Eb => R Hc; have SL : size L = _len + b2i (_tb <> 0) by rewrite /L size_cat size_sub //; case: (_tb <> 0).
have B := asubread_u64_bits8 _buf offset{hr} w aT{hr} aT{hr} dELTA{hr} _LEN{hr} _tb a d l t _ _ _ _ _ _ R; 1..6: smt().
rewrite -/L Est upd64_xabs 1:/#.
+ move=> r Hr; rewrite B // (: aT{hr} <= aT{hr} + r) 1:/# /= /L !Lget 1,2:/# (: aT{hr} + r - aT{hr} = r) 1:/# Eo El.
  rewrite (: _off + (aT{hr} + r - _at) = _off + (aT{hr} - _at) + r) 1:/# (: (0 <= aT{hr} + r - _at < _len) = (0 <= r < _len - (aT{hr} - _at))) 1:/# (: (aT{hr} + r - _at = _len) = (r = _len - (aT{hr} - _at))) 1:/#.
  done.
rewrite xabs_addstate_at 1:/#; have S8 : size (u64bytes w) = 8 by rewrite /u64bytes size_to_list.
move: R; rewrite /asubread S8 /srincr /srfnsh (: (0 <= aT{hr} - aT{hr} < 8) = true) 1:/# /= (: min (max 0 _LEN{hr}) (aT{hr} + 8 - aT{hr}) = _LEN{hr}) 1:/# (: (aT{hr} + _LEN{hr} < aT{hr} + 8) = true) 1:/# /= => [#] _ -> -> _ _.
by rewrite SL Hl0 /=; smt().
qed.

phoare addstate_ph _st _at _buf _off _len _tb:
 [ MM.__addstate
   : st=_st /\ aT=_at /\ buf=_buf /\ offset=_off /\ _LEN=_len /\ _TRAILB=_tb
   /\ 0 <= _at <= 200
   /\ 0 <= _len
   /\ _at + _len <= 200 - b2i (_tb<>0)
   /\ 0 <= offset /\ offset + _len <= _ASIZE
   /\ 0 <= _tb < 256
   ==> let l = sub _buf _off _len ++ if _tb <> 0 then [W8.of_int _tb] else []
       in res.`1 = addstate_at _st _at l
       /\ res.`2 = _at + size l
       /\ res.`3 = _off + _len] = 1%r.
proof.
by conseq addstate_ll (addstate_h _st _at _buf _off _len _tb).
qed.

lemma absorb_ll: islossless MM.__absorb.
proof.
proc; simplify.
seq 4: true => //.
 call addstate_ll.
 sp 2; if => //.
 wp; while true (iTERS-i).
  move=> z; auto.
  call keccakf1600_ll.
  call addstate_ll.
  by auto => /#.
 wp; call keccakf1600_ll.
 wp; call addstate_ll.
 by auto => /#.
if => //.
by call addratebit_ll.
qed.


hoare absorb_h _l _buf _tb _r8:
 MM.__absorb
 : aT=size _l %% _r8 /\ buf=_buf /\ _RATE8=_r8 /\ _TRAILB=_tb
 /\ 0 <= _tb < 256
 /\ pabsorb_spec_ref _r8 _l st
 ==> if _tb <> 0
     then res.`1 = ABSORB1600 (W8.of_int _tb) _r8 (_l ++ to_list _buf)
     else pabsorb_spec_ref _r8 (_l ++ to_list _buf) res.`1
       /\ res.`2 = (size _l + _ASIZE) %% _r8.
proof.
proc => /=; have ?:= _ASIZE_u64; have ?:= _ASIZE_ge0; pose _at := size _l %% _r8; pose niters := (_at + _ASIZE) %/ _r8; pose lastlen := if _r8 <= _at + _ASIZE then (_at + _ASIZE) %% _r8 else _ASIZE; pose lastpos := niters * _r8 - _at.
seq 3: (buf=_buf /\ _RATE8=_r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256 /\ pabsorb_spec_ref _r8 (_l ++ sub _buf 0 lastpos) st /\ offset = _ASIZE - lastlen /\ _LEN = lastlen /\ aT = if _RATE8 <= _at + _ASIZE then 0 else _at).
+ sp; if => //; last first.
  + auto => |> *; rewrite sub0' ?cats0; [by rewrite /lastpos /niters divz_small 1:/# /= /# | smt()].
  wp; while (buf=_buf /\ _RATE8 = _r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256 /\ iTERS = (size _l %% _r8 + _ASIZE) %/ _r8 - 1 /\ offset = (i+1)*_r8 - size _l %% _r8 /\ 0 <= i <= iTERS /\ pabsorb_spec_ref _r8 (_l ++ sub _buf 0 ((i+1)*_r8 - size _l %% _r8)) st).
  + wp; ecall (keccakf1600_h st); ecall (addstate_h st 0 buf offset _RATE8 0); auto => |> &m Htb0 Htb1 Hi0 Hi1.
    rewrite {1}/pabsorb_spec_ref => [[Hr8]]; rewrite chunkremains_nil 1:/#.
    + rewrite size_cat size_sub 1:/# addzA (addzC (size _l)) -addzA; rewrite {1}(divz_eq (size _l) _r8) -addzA /= -mulzDl dvdzP; by exists (i{m} + 1 + size _l %/ _r8).
    rewrite bytes2state0 addstateC addstate_st0 => Est Hb; rewrite !b2i0 /=; split.
    + split; first smt().
      split; first smt().
      have M0 : 0 <= i{m} * _r8 by apply mulr_ge0; smt().
      split; first smt().
      rewrite (:(i{m} + 1) * _r8 - size _l %% _r8 + _r8 <= _ASIZE = (i{m}+2)*_r8<=size _l%%_r8+_ASIZE) 1:/#.
      have Hb': i{m}+2 <= (size _l %% _r8 + _ASIZE) %/ _r8 by smt().
      apply (ler_trans ((size _l %% _r8 + _ASIZE) %/ _r8 * _r8)); [by apply ler_wpmul2r; smt() | by apply lez_floor; smt()].
    move=> _ _ _ _ [st' at' off'] /= Est' _ Eoff'; split; first smt().
    split; first smt().
    rewrite /pabsorb_spec_ref; split; first smt().
    rewrite chunkremains_nil 1:/#.
    + rewrite size_cat size_sub 1:/# addzA (addzC (size _l)) -addzA; rewrite {1}(divz_eq (size _l) _r8) -addzA /= -mulzDl dvdzP; by exists (i{m} + 2 + size _l %/ _r8).
    rewrite bytes2state0 addstateC addstate_st0 (sub_split ((i{m} + 1) * _r8 - size _l %% _r8)) 1:/# catA BitEncoding.BitChunking.chunk_cat /=.
    + rewrite size_cat size_sub 1:/# addzA (addzC (size _l)) -addzA; rewrite {1}(divz_eq (size _l) _r8) -addzA /= -mulzDl dvdzP; by exists (i{m} + 1 + size _l %/ _r8).
    rewrite (: (i{m} + 2) * _r8 - size _l %% _r8 - ((i{m} + 1) * _r8 - size _l %% _r8) = _r8) 1:/# (chunk_size _ (sub _buf _ _)) 1:/#; first by rewrite size_sub /#.
    rewrite cats1 stateabsorb_iblocks_rcons -Est Est' addstate_atE //=; first by rewrite cats0 size_sub /#.
    by rewrite nseq0 /= cats0.
  wp; ecall (keccakf1600_h st); wp; ecall (addstate_h st aT buf offset (_RATE8 - aT) 0); auto => |> &m.
  rewrite /pabsorb_spec_ref => ?? [Hr8 Est] Hc; split; first smt(modz_ge0 ltz_pmod).
  move=> _ _ _ _ _ [st' at' len'] /= Est' _ _; split.
  + split; first by rewrite (:_ASIZE - (_r8 - size _l %% _r8) = size _l %% _r8 + _ASIZE + (-1)*_r8) 1:/# divzMDr /#.
    split; first smt(divz_ge0).
    split; first smt().
    rewrite chunkremains_nil 1:/#.
    + rewrite size_cat size_sub 1:/# addzA (addzC (size _l)) -addzA; rewrite {1}(divz_eq (size _l) _r8) -addzA /= -{2}(mul1z _r8) -mulzDl dvdzP; by exists (1 + size _l %/ _r8).
    rewrite bytes2state0 addstateC addstate_st0 chunk_cat' 1:/# (chunk_size _ (_++_)) 1:/#; first by rewrite size_cat size_chunkremains size_sub /#.
    rewrite cats1 stateabsorb_iblocks_rcons Est' addstate_atE; [smt(modz_ge0) | rewrite cats0 size_sub; smt(modz_ge0 ltz_pmod) | ].
    by rewrite Est /stateabsorb -addstateA cats0 (bytes2state_cat (chunkremains _r8 _l)) size_chunkremains.
  move=> i st0' C1 E0 Hi0 Hi1 [_ Est0]; have ->: i = (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 by smt().
  have E: (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 = (size _l %% _r8 + _ASIZE) %/ _r8 - 1 by rewrite (: _ASIZE - (_r8 - size _l %% _r8) = size _l %% _r8 + _ASIZE + (-1)*_r8) 1:/# divzMDr /#.
  have Lp : ((_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 + 1) * _r8 - size _l %% _r8 = lastpos by rewrite /lastpos /niters /_at E /=.
  have Ei : i = (_ASIZE - (_r8 - size _l %% _r8)) %/ _r8 by smt().
  rewrite Lp; split; first by rewrite Est0 Ei Lp; smt().
  split; first by rewrite /lastpos /lastlen ifT 1:/# /niters /_at; smt(divz_eq).
  split; first by rewrite /lastlen ifT 1:/# /_at (: _ASIZE - (_r8 - size _l %% _r8) = _ASIZE + size _l %% _r8 + (-1)*_r8) 1:/# modzMDr /#.
  by rewrite ifT /#.
case: (_TRAILB<>0).
+ rcondt 2; first by call (:true ==> true) => //.
  ecall (addratebit_h _RATE8 st); ecall (addstate_h st aT buf offset _LEN _TRAILB); auto => |> &m Htb0 Htb1 H Ht.
  have [Hr0 Hr1] : 0 < _r8 <= 200 by case: H.
  have HA : 0 <= _at < _r8 by smt(modz_ge0 ltz_pmod).
  have HL : 0 <= lastlen <= _ASIZE /\ (if _r8 <= _at + _ASIZE then 0 else _at) + lastlen < _r8.
  + rewrite /lastlen; case: (_r8 <= _at + _ASIZE) => C /=; last smt().
    have M1 := modz_ge0 (_at + _ASIZE) _r8 _; first smt().
    have M2 := ltz_pmod (_at + _ASIZE) _r8 _; first smt().
    case: (_ASIZE < _r8) => C2; last smt().
    by rewrite (: _at + _ASIZE = (_at + _ASIZE - _r8) + _r8) 1:/# modzDr modz_small /#.
  split; first smt().
  move=> _ _ _ _ _ _ [st' at' off'] /= -> _ _; move: H; rewrite /pabsorb_spec_ref => [[_ ->]].
  rewrite addstate_atE; [smt() | rewrite size_cat size_sub /=; smt() | ].
  rewrite /ABSORB1600 /stateabsorb_last /stateabsorb -cats1 -addstateA; congr; congr; first by rewrite chunk_cat_buf 1:// /lastpos /niters.
  rewrite (chunkremains_cat_buf _r8 _l _buf (W8.of_int _tb)) //=.
  by rewrite -catA /lastpos /niters /lastlen /_at.
rcondf 2; first by call (:true ==> true) => //.
ecall (addstate_h st aT buf offset _LEN _TRAILB); auto => |> &m.
move=> H; have [Hr0 Hr1] : 0 < _r8 <= 200 by case: H.
have HA : 0 <= _at < _r8 by smt(modz_ge0 ltz_pmod).
have HL : 0 <= lastlen <= _ASIZE /\ (if _r8 <= _at + _ASIZE then 0 else _at) + lastlen < _r8.
+ rewrite /lastlen; case: (_r8 <= _at + _ASIZE) => C /=; last smt().
  have M1 := modz_ge0 (_at + _ASIZE) _r8 _; first smt().
  have M2 := ltz_pmod (_at + _ASIZE) _r8 _; first smt().
  case: (_ASIZE < _r8) => C2; last smt().
  by rewrite (: _at + _ASIZE = (_at + _ASIZE - _r8) + _r8) 1:/# modzDr modz_small /#.
split; first smt().
move=> _ _ _ _ _ _ [st' at' off'] /= -> -> _; move: H; rewrite /pabsorb_spec_ref => [[_ ->]]; split.
+ split; first smt().
  rewrite addstate_atE; [smt() | rewrite size_cat size_sub /=; smt() | ].
  rewrite -addstateA; congr; first by rewrite chunk_cat_buf 1:// /lastpos /niters.
  rewrite cats0 -(bytes2state_zext 1 (chunkremains _r8 (_l ++ to_list _buf))) nseq1 (chunkremains_cat_buf _r8 _l _buf W8.zero) //= -catA.
  by rewrite catA -(nseq1 W8.zero) bytes2state_zext /lastpos /niters /lastlen /_at.
rewrite cats0 size_sub 1:/# /lastlen /_at; case: (_r8 <= size _l %% _r8 + _ASIZE) => C /=; first by rewrite modzDml.
rewrite -(modzDml (size _l) _ASIZE _r8) (modz_small (size _l %% _r8 + _ASIZE) _r8) //; smt(modz_ge0).
qed.

phoare absorb_ph _l _buf _tb _r8:
 [ MM.__absorb
 : aT=size _l %% _r8 /\ buf=_buf /\ _RATE8=_r8 /\ _TRAILB=_tb
 /\ 0 <= _tb < 256
 /\ pabsorb_spec_ref _r8 _l st
 ==> if _tb <> 0
     then res.`1 = ABSORB1600 (W8.of_int _tb) _r8 (_l ++ to_list _buf)
     else pabsorb_spec_ref _r8 (_l ++ to_list _buf) res.`1
       /\ res.`2 = (size _l + _ASIZE) %% _r8
 ] = 1%r.
proof.
by conseq absorb_ll (absorb_h _l _buf _tb _r8); smt(ge0_size).
qed.

(*
   ONE-SHOT (FIXED-SIZE) MEMORY SQUEEZE
   ====================================
*)

lemma dumpstate_ll: islossless MM.__dumpstate.
proof.
(* This proof script is independent of selected `KECCAK_FEATURES` *)
proc => /=.
seq 2: true => //; first by inline*; auto.
if => //.
 seq 3: true => //; last by islossless.
 wp; while true (inc - j).
  by move=> z; auto => /#.
 by auto => /#.
seq 2: true => //; last by islossless.
while true (_LEN %/ 8 - i).
 by move=> z; auto => /#.
by auto => /#.
qed.

hoare dumpstate_h _buf _off _len _st:
 MM.__dumpstate
 : buf=_buf /\ offset=_off /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _off + _len <= _ASIZE
 ==> res.`1 = A.fill (fun i=>(stbytes _st).[i-_off]) _off _len _buf
  /\ res.`2 = _off + _len.
proof.
proc => /=; seq 3 : (buf = A.fill (fun i=>(stbytes _st).[i-_off]) _off (offset + dELTA - _off) _buf /\ offset + dELTA = _off + 8 * (_len %/ 8) /\ 0 <= offset - _off /\ 0 <= dELTA /\ st = _st /\ _LEN = _len /\ 0 <= _len <= 200 /\ _off + _len <= _ASIZE).
+ seq 2 : (#pre /\ dELTA = 0); first by inline*; auto.
  if; last first.
  + while (buf = A.fill (fun i=>(stbytes _st).[i-_off]) _off (8 * i) _buf /\ offset = _off + 8 * i /\ dELTA = 0 /\ 0 <= i <= _len %/ 8 /\ st = _st /\ _LEN = _len /\ 0 <= _len <= 200 /\ _off + _len <= _ASIZE).
    + wp; skip => &hr [#] -> -> -> Hi0 Hi1 -> -> H0 H1 Hoff Hc /=.
      have /= -> := a_set64_fill (A.fill (fun i=>(stbytes _st).[i-_off]) _off (8 * i{hr}) _buf) (_off + 8 * i{hr}) _st.[i{hr}]; split; last by smt().
      rewrite (: 8 * (i{hr} + 1) = 8 * i{hr} + 8) 1:/#; apply rdmp_step => // [/#|r Hr /=]; rewrite stbytes_get 1:/# (: _off + 8 * i{hr} + r - (_off + 8 * i{hr}) = r) 1:/# (: (8 * i{hr} + r) %/ 8 = i{hr}) 1:/# (: (8 * i{hr} + r) %% 8 = r) 1:/#.
      done.
    + auto => />.
      move=> &m H0 H1 Hoff _; split; first by split; [rewrite A.fillE; apply A.tP => k Hk; rewrite A.initiE //= /# | smt()].
      by move=> i0 Hc Hi0 Hi1; rewrite (: _off + 8 * i0 - _off = 8 * i0) 1:/#; smt().
  seq 3 : (buf = A.fill (fun i=>(stbytes _st).[i-_off]) _off dELTA _buf /\ dELTA = 32 * (_len %/ 32) /\ offset = _off /\ st = _st /\ _LEN = _len /\ 0 <= _len <= 200 /\ _off + _len <= _ASIZE).
  + while (buf = A.fill (fun i=>(stbytes _st).[i-_off]) _off dELTA _buf /\ dELTA = 32 * j /\ 0 <= j <= inc /\ inc = _len %/ 32 /\ offset = _off /\ st = _st /\ _LEN = _len /\ 0 <= _len <= 200 /\ _off + _len <= _ASIZE).
    + wp; skip => &hr [#] -> -> Hj0 Hj1 -> -> -> -> H0 H1 Hoff Hc /=.
      have /= -> := a_set256_fill (A.fill (fun i=>(stbytes _st).[i-_off]) _off (32 * j{hr}) _buf) (_off + 32 * j{hr}) (WArray200.get256 (stbytes _st) j{hr}); split; last by smt().
      apply rdmp_step => // [/#|r Hr /=]; rewrite get256d_bits8 // (: _off + 32 * j{hr} + r - (_off + 32 * j{hr}) = r) 1:/#.
      done.
      smt().
      done.
    + auto => />.
      move=> &m H0 H1 Hoff _.
      split; last by smt().
      split; last by smt().
      by rewrite A.fillE; apply A.tP => k Hk; rewrite A.initiE //= /#.
  seq 1 : (buf = A.fill (fun i=>(stbytes _st).[i-_off]) _off dELTA _buf /\ dELTA = 16 * (_len %/ 16) /\ offset = _off /\ st = _st /\ _LEN = _len /\ 0 <= _len <= 200 /\ _off + _len <= _ASIZE).
  + if; last by skip => /> *; smt().
    wp; skip => &hr [#] -> -> -> -> -> H0 H1 Hoff Hc /=.
    have /= -> := a_set128_fill (A.fill (fun i=>(stbytes _st).[i-_off]) _off (32 * (_len %/ 32)) _buf) (_off + 32 * (_len %/ 32)) (WArray200.get128_direct (stbytes _st) (_len %/ 32 * 32)); split; last by smt().
    apply rdmp_step => // [/#|r Hr /=].
    by rewrite (: _off + 32 * (_len %/ 32) + r - (_off + 32 * (_len %/ 32)) = r) 1:/# get128d_bits8 // /#.
  if; last by skip => /> *; smt().
  wp; skip => &hr [#] -> -> -> -> -> H0 H1 Hoff Hc /=.
  have /= -> := a_set64_fill (A.fill (fun i=>(stbytes _st).[i-_off]) _off (16 * (_len %/ 16)) _buf) (_off + 16 * (_len %/ 16)) (WArray200.get64_direct (stbytes _st) (_len %/ 16 * 16)); split; last by smt().
  rewrite (: _off + (16 * (_len %/ 16) + 8) - _off = 16 * (_len %/ 16) + 8) 1:/#; apply rdmp_step => // [/#|r Hr /=].
  by rewrite (: _off + 16 * (_len %/ 16) + r - (_off + 16 * (_len %/ 16)) = r) 1:/# get64d_bits8 // /#.
seq 1 : (buf = A.fill (fun i=>(stbytes _st).[i-_off]) _off _len _buf /\ offset + dELTA = _off + _len); last by auto.
if; last by skip => &hr [#] -> Ed Ho Hd _ -> H0 H1 Hoff Hc; rewrite Ed (: 8 * (_len %/ 8) = _len) 1:/#; smt().
ecall (a_ilen_write_upto8_h buf offset dELTA (_LEN %% 8) t); wp; skip => &hr [#] Hb Ed Ho Hd Es -> H0 H1 Hoff Hc [b' d' z] /= R.
have E : offset{hr} + dELTA{hr} - _off = 8 * (_len %/ 8) by smt().
move: R; rewrite Hb E Es => /(asubwrite_shift _ _ _ _ _ _ _ _ (_off - offset{hr})); rewrite (: offset{hr} + (_off - offset{hr}) = _off) 1:/# (: dELTA{hr} - (_off - offset{hr}) = 8 * (_len %/ 8)) 1:/# => R.
have := asubwrite_fill_step _ _ _ _ _ _ _ _ _ _ _ R.
+ smt().
+ have S8 : size (u64bytes _st.[_len %/ 8]) = 8 by rewrite /u64bytes size_to_list.
  move=> k; rewrite S8 => Hk /=; rewrite get_u64bytes stbytes_get 1:/# (: _off + 8 * (_len %/ 8) + k - _off = k + (_len %/ 8) * 8) 1:/#.
  by rewrite divzMDr // modzMDr (divz_small k 8) 1:/# (modz_small k 8) 1:/#.
have S8 : size (u64bytes _st.[_len %/ 8]) = 8 by rewrite /u64bytes size_to_list.
by rewrite S8 => [#] -> Ed' _; rewrite (: d' - (_off - offset{hr}) = _len) 1:/#; smt().
qed.

phoare dumpstate_ph _buf _off _len _st:
 [ MM.__dumpstate
 : buf=_buf /\ offset=_off /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _off + _len <= _ASIZE
 ==> res.`1 = A.fill (fun i=>(stbytes _st).[i-_off]) _off _len _buf
  /\ res.`2 = _off + _len
 ] = 1%r.
proof.
by conseq dumpstate_ll (dumpstate_h _buf _off _len _st).
qed.

lemma squeeze_ll: islossless MM.__squeeze.
proof.
proc; simplify.
seq 3: true => //.
 while true (_ASIZE %/ _RATE8 - i).
  move => z.
  call dumpstate_ll.
  call keccakf1600_ll.
  by auto => /#.
 by auto => /#.
if => //.
call dumpstate_ll.
call keccakf1600_ll.
by auto => /#.
qed.

hoare squeeze_h _buf _st _r8:
 MM.__squeeze
 : buf=_buf /\ st=_st /\ _RATE8=_r8
 /\ 0 < _r8 <= 200
 ==> res.`1 = st_i _st ((_ASIZE-1) %/ _r8 + 1)
     /\ to_list res.`2 = (SQUEEZE1600 _r8 _ASIZE _st).
proof.
proc; have ?:= _ASIZE_ge0; seq 3 : (offset = i * _r8 /\ i = _ASIZE %/ _r8 /\ st = st_i _st i /\ buf = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE _st).[j]) 0 (i * _r8) _buf /\ _RATE8 = _r8 /\ 0 < _r8 <= 200).
+ while (0 <= i <= _ASIZE %/ _r8 /\ offset = i * _r8 /\ st = st_i _st i /\ buf = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE _st).[j]) 0 (i * _r8) _buf /\ _RATE8 = _r8 /\ 0 < _r8 <= 200).
  + ecall (dumpstate_h buf offset _RATE8 st); ecall (keccakf1600_h st); wp; skip => &hr [#] Hi0 Hi1 -> -> -> -> Hr0 Hr1 Hc /=.
    move=> _ ->; have -> : keccak_f1600_op (st_i _st i{hr}) = st_i _st (i{hr} + 1) by rewrite /st_i iterS.
    have Hb : (i{hr} + 1) * _r8 <= _ASIZE by apply (ler_trans (_ASIZE %/ _r8 * _r8)); [by apply ler_wpmul2r; smt() | by apply lez_floor; smt()].
    split; first smt().
    move=> _ r [#] -> ->; rewrite (: (i{hr} + 1) * _r8 = i{hr} * _r8 + _r8) 1:/#; have /= -> // := rsq_step_len _st _r8 _ASIZE i{hr} _r8 _buf; smt().
  auto => /> Hr0 Hr1.
  split; last smt().
  by rewrite /st_i iter0 //= A.fillE; split; [smt(divz_ge0) | apply A.tP => j Hj; rewrite A.initiE //= /#].
have FL : forall (b: W8.t A.t), A.fill (nth W8.zero (SQUEEZE1600 _r8 _ASIZE _st)) 0 _ASIZE b = A.of_list W8.zero (SQUEEZE1600 _r8 _ASIZE _st) by move=> b; rewrite A.fillE; apply A.tP => j Hj; rewrite A.initiE //= A.get_of_list // ifT /#.
if; last first.
+ skip => &hr [#] _ Ei Es Eb Er Hr0 Hr1 Hl /=; rewrite Es Eb Ei.
  have Ea : _ASIZE %/ _r8 * _r8 = _ASIZE by smt(divz_eq modz_ge0).
  have Ei' : (_ASIZE - 1) %/ _r8 + 1 = _ASIZE %/ _r8 by rewrite -{1}Ea (: _ASIZE %/ _r8 * _r8 - 1 = _ASIZE %/ _r8 * _r8 + (-1)) 1:/# divzMDl 1:/#; smt().
  by rewrite Ea Ei' /= FL A.of_listK // size_SQUEEZE1600 /#.
ecall (dumpstate_h buf offset (_ASIZE %% _RATE8) st); ecall (keccakf1600_h st); skip => &hr [#] -> -> -> -> -> Hr0 Hr1 Hl /=.
move=> _ ->; have -> : keccak_f1600_op (st_i _st (_ASIZE %/ _r8)) = st_i _st (_ASIZE %/ _r8 + 1) by rewrite /st_i iterS // divz_ge0.
have Ea : _ASIZE %/ _r8 * _r8 + _ASIZE %% _r8 = _ASIZE by smt(divz_eq).
split; first smt(modz_ge0 ltz_pmod).
move=> _ r [#] -> _.
have Ei : (_ASIZE - 1) %/ _r8 = _ASIZE %/ _r8 by rewrite -{1}Ea (: _ASIZE %/ _r8 * _r8 + _ASIZE %% _r8 - 1 = _ASIZE %/ _r8 * _r8 + (_ASIZE %% _r8 - 1)) 1:/# divzMDl 1:/# (divz_small (_ASIZE %% _r8 - 1) _r8); smt(ltz_pmod).
rewrite Ei /=; have /= -> := rsq_step_len _st _r8 _ASIZE (_ASIZE %/ _r8) (_ASIZE %% _r8) _buf _ _ _ _; 1..3: smt(divz_ge0 modz_ge0 ltz_pmod).
+ by rewrite Ea.
by rewrite Ea FL A.of_listK // size_SQUEEZE1600 /#.
qed.

phoare squeeze_ph _buf _st _r8:
 [ MM.__squeeze
 : buf=_buf /\ st=_st /\ _RATE8=_r8
 /\ 0 < _r8 <= 200
 ==> res.`1 = st_i _st ((_ASIZE-1) %/ _r8 + 1)
     /\ to_list res.`2 = (SQUEEZE1600 _r8 _ASIZE _st)
 ] = 1%r.
proof.
by conseq squeeze_ll (squeeze_h _buf _st _r8).
qed.

end KeccakArrayRef.
