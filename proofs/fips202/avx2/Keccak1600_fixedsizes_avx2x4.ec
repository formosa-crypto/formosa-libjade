(******************************************************************************
   Keccak1600_imem_avx2.ec:

   Correctness proof for the Keccak (fixed-sized) memory absorb/squeeze
  4-way AVX2 implementation



******************************************************************************)

require import AllCore List Int IntDiv.

from Jasmin require import JModel_x86.

from JazzEC require import Keccak1600_Jazz.

from JazzEC require import WArray200 WArray800.
from JazzEC require import Array25.

require import JWordList.
from CryptoSpecs require import FIPS202_Keccakf1600 Keccakf1600_Spec.
from CryptoSpecs require import FIPS202_SHA3_Spec Keccak1600_Spec.


require export Keccak1600_avx2x4 Keccakf1600_avx2x4.
require import Keccak1600_subreadwrite.

(*
   INCREMENTAL (FIXED-SIZE) MEMORY ABSORB
   ===================================
*)

lemma addstate_m_bcast_avx2x4_ll: islossless M.__addstate_m_bcast_avx2x4.
proof.
proc.
seq 5: true => //.
 while true (32 * (aT %/ 8 + _LEN %/ 8)-at).
  by move=> z; auto => /#.
 sp; if => //.
  by wp; call m_ilen_read_bcast_upto8_at_ll; auto => /#.
 by auto => /#.
sp; if => //.
by wp; call m_ilen_read_bcast_upto8_at_ll; auto => /#.
qed.

lemma addstate_m_avx2x4_ll: islossless M.__addstate_m_avx2x4.
proof.
proc.
seq 5: true => //.
 while true (4 * (aT %/ 8) + 4 * (_LEN %/ 8)-at).
  by move=> z; auto => /#.
 sp; if => //.
  wp; call m_ilen_read_upto8_at_ll.
  wp; call m_ilen_read_upto8_at_ll.
  wp; call m_ilen_read_upto8_at_ll.
  wp; call m_ilen_read_upto8_at_ll.
  by auto => /#.
 by auto => /#.
sp; if => //.
wp; call m_ilen_read_upto8_at_ll.
wp; call m_ilen_read_upto8_at_ll.
wp; call m_ilen_read_upto8_at_ll.
wp; call m_ilen_read_upto8_at_ll.
by auto => /#.
qed.

lemma absorb_m_bcast_avx2x4_ll: islossless M.__addstate_m_bcast_avx2x4.
proof.
proc.
seq 7: true => //.
 wp; while true (32 * (aT %/ 8 + _LEN %/ 8)-at).
  by move => z; auto => /#.
 sp; if => //.
  by wp; call m_ilen_read_bcast_upto8_at_ll; auto => /#.
 by auto => /#.
if => //.
by wp; call m_ilen_read_bcast_upto8_at_ll; auto => /#.
qed.

lemma absorb_m_avx2x4_ll: islossless M.__addstate_m_avx2x4.
proof.
proc.
seq 7: true => //.
 wp; while true (4 * (aT %/ 8) + 4 * (_LEN %/ 8)-at).
  by move => z; auto => /#.
 sp; if => //.
  wp; call m_ilen_read_upto8_at_ll.
  wp; call m_ilen_read_upto8_at_ll.
  wp; call m_ilen_read_upto8_at_ll.
  wp; call m_ilen_read_upto8_at_ll.
  by auto => /#.
 by auto => /#.
if => //.
wp; call m_ilen_read_upto8_at_ll.
wp; call m_ilen_read_upto8_at_ll.
wp; call m_ilen_read_upto8_at_ll.
wp; call m_ilen_read_upto8_at_ll.
by auto => /#.
qed.

(*
   ONE-SHOT (FIXED-SIZE) MEMORY SQUEEZE
   ====================================
*)

lemma dumpstate_m_avx2x4_ll: islossless M.__dumpstate_m_avx2x4.
proof.
proc.
seq 7: true => //.
 wp; while true (8 * (_LEN %/ 8)-i).
  by move=> z; auto => /#.
 while true (32 * (_LEN %/ 32)-i).
  by move=> z; inline*; auto => /#.
 by auto => /#.
if => //.
wp; call m_ilen_write_upto8_ll.
wp; call m_ilen_write_upto8_ll.
wp; call m_ilen_write_upto8_ll.
wp; call m_ilen_write_upto8_ll.
by auto => /#.
qed.

lemma squeeze_m_avx2x4_ll: islossless M.__squeeze_m_avx2x4.
proof.
proc.
seq 3: true => //.
 sp; if => //.
 while true (iTERS-i).
  move=> z.
  wp; call dumpstate_m_avx2x4_ll.
  wp; call keccakf1600_avx2x4_ll.
  by auto => /#. 
 by auto => /#.
if => //.
call  dumpstate_m_avx2x4_ll.
by call keccakf1600_avx2x4_ll; auto => /#.
qed.





abstract theory KeccakArrayAvx2x4.

op _ASIZE: int.

axiom _ASIZE_ge0: 0 <= _ASIZE.
axiom _ASIZE_u64: _ASIZE < W64.modulus.

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
  proc __addstate_bcast_avx2x4 (st:W256.t Array25.t, aT:int,
                                buf:W8.t A.t, offset:int, _LEN:int,
                                _TRAILB:int) : W256.t Array25.t * int * int = {
    var dELTA:int;
    var aT8:int;
    var w:W256.t;
    var at:int;
    dELTA <- 0;
    aT8 <- aT;
    aT <- (8 * (aT %/ 8));
    if (((aT8 %% 8) <> 0)) {
      (dELTA, _LEN, _TRAILB, aT8, w) <@ RW.MM.__a_ilen_read_bcast_upto8_at (
      buf, offset, dELTA, _LEN, _TRAILB, aT, aT8);
      w <- (w `^` st.[(aT %/ 8)]);
      st.[(aT %/ 8)] <- w;
      aT <- aT8;
    } else {
      
    }
    offset <- (offset + dELTA);
    at <- (32 * (aT %/ 8));
    while ((at < (32 * ((aT %/ 8) + (_LEN %/ 8))))) {
      w <-
      (VPBROADCAST_4u64
      (get64_direct (WA.init8 (fun i => buf.[i])) offset));
      offset <- (offset + 8);
      w <- (w `^` (get256_direct (WArray800.init256 (fun i => st.[i])) at));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set256_direct (WArray800.init256 (fun i => st.[i])) at w)));
      at <- (at + 32);
    }
    aT <- (aT + (8 * (_LEN %/ 8)));
    _LEN <- (_LEN %% 8);
    if (((0 < _LEN) \/ ((_TRAILB %% 256) <> 0))) {
      (dELTA, _LEN, _TRAILB, aT, w) <@ RW.MM.__a_ilen_read_bcast_upto8_at (
      buf, offset, 0, _LEN, _TRAILB, aT, aT);
      w <- (w `^` (get256_direct (WArray800.init256 (fun i => st.[i])) at));
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set256_direct (WArray800.init256 (fun i => st.[i])) at w)));
      offset <- (offset + dELTA);
    } else {
      
    }
    return (st, aT, offset);
  }
  proc __absorb_bcast_avx2x4 (st:W256.t Array25.t, aT:int,
                              buf:W8.t A.t, _TRAILB:int, _RATE8:int) : 
  W256.t Array25.t * int = {
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
      (st,  _0, offset) <@ __addstate_bcast_avx2x4 (st, aT, buf, offset,
      (_RATE8 - aT), 0);
      _LEN <- (_LEN - (_RATE8 - aT));
      aT <- 0;
      st <@ M._keccakf1600_avx2x4 (st);
      iTERS <- (_LEN %/ _RATE8);
      i <- 0;
      while ((i < iTERS)) {
        (st,  _1, offset) <@ __addstate_bcast_avx2x4 (st, 0, buf, offset,
        _RATE8, 0);
        st <@ M._keccakf1600_avx2x4 (st);
        i <- (i + 1);
      }
      _LEN <- (_LEN %% _RATE8);
    } else {
      
    }
    (st, aT,  _2) <@ __addstate_bcast_avx2x4 (st, aT, buf, offset, _LEN,
    _TRAILB);
    if ((_TRAILB <> 0)) {
      st <@ M.__addratebit_avx2x4 (st, _RATE8);
    } else {
      
    }
    return (st, aT);
  }
  proc __addstate_avx2x4 (st:W256.t Array25.t, aT:int, buf0:W8.t A.t,
                          buf1:W8.t A.t, buf2:W8.t A.t,
                          buf3:W8.t A.t, offset:int, _LEN:int,
                          _TRAILB:int) : W256.t Array25.t * int * int = {
    var dELTA:int;
    var aT8:int;
    var t0:W64.t;
    var t1:W64.t;
    var t2:W64.t;
    var t3:W64.t;
    var at:int;
    var  _0:int;
    var  _1:int;
    var  _2:int;
    var  _3:int;
    var  _4:int;
    var  _5:int;
    var  _6:int;
    var  _7:int;
    var  _8:int;
    var  _9:int;
    var  _10:int;
    var  _11:int;
    var  _12:int;
    var  _13:int;
    var  _14:int;
    var  _15:int;
    var  _16:int;
    var  _17:int;
    var  _18:int;
    var  _19:int;
    var  _20:int;
    var  _21:int;
    var  _22:int;
    var  _23:int;
    dELTA <- 0;
    aT8 <- aT;
    aT <- (8 * (aT %/ 8));
    if (((aT8 %% 8) <> 0)) {
      ( _0,  _1,  _2,  _3, t0) <@ RW.MM.__a_ilen_read_upto8_at (buf0, offset,
      dELTA, _LEN, _TRAILB, aT, aT8);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i]))
      ((4 * (aT %/ 8)) + 0)
      ((get64 (WArray800.init256 (fun i => st.[i])) ((4 * (aT %/ 8)) + 0)) `^`
      t0))));
      ( _4,  _5,  _6,  _7, t1) <@ RW.MM.__a_ilen_read_upto8_at (buf1, offset,
      dELTA, _LEN, _TRAILB, aT, aT8);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i]))
      ((4 * (aT %/ 8)) + 1)
      ((get64 (WArray800.init256 (fun i => st.[i])) ((4 * (aT %/ 8)) + 1)) `^`
      t1))));
      ( _8,  _9,  _10,  _11, t2) <@ RW.MM.__a_ilen_read_upto8_at (buf2, offset,
      dELTA, _LEN, _TRAILB, aT, aT8);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i]))
      ((4 * (aT %/ 8)) + 2)
      ((get64 (WArray800.init256 (fun i => st.[i])) ((4 * (aT %/ 8)) + 2)) `^`
      t2))));
      (dELTA, _LEN, _TRAILB, aT8, t3) <@ RW.MM.__a_ilen_read_upto8_at (buf3,
      offset, dELTA, _LEN, _TRAILB, aT, aT8);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i]))
      ((4 * (aT %/ 8)) + 3)
      ((get64 (WArray800.init256 (fun i => st.[i])) ((4 * (aT %/ 8)) + 3)) `^`
      t3))));
      aT <- aT8;
    } else {
      
    }
    offset <- (offset + dELTA);
    at <- (4 * (aT %/ 8));
    while ((at < ((4 * (aT %/ 8)) + (4 * (_LEN %/ 8))))) {
      t0 <- (get64_direct (WA.init8 (fun i => buf0.[i])) offset);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i])) (at + 0)
      ((get64 (WArray800.init256 (fun i => st.[i])) (at + 0)) `^` t0))));
      t1 <- (get64_direct (WA.init8 (fun i => buf1.[i])) offset);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i])) (at + 1)
      ((get64 (WArray800.init256 (fun i => st.[i])) (at + 1)) `^` t1))));
      t2 <- (get64_direct (WA.init8 (fun i => buf2.[i])) offset);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i])) (at + 2)
      ((get64 (WArray800.init256 (fun i => st.[i])) (at + 2)) `^` t2))));
      t3 <- (get64_direct (WA.init8 (fun i => buf3.[i])) offset);
      offset <- (offset + 8);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i])) (at + 3)
      ((get64 (WArray800.init256 (fun i => st.[i])) (at + 3)) `^` t3))));
      at <- (at + 4);
    }
    aT <- (aT + (8 * (_LEN %/ 8)));
    _LEN <- (_LEN %% 8);
    if (((0 < _LEN) \/ ((_TRAILB %% 256) <> 0))) {
      ( _12,  _13,  _14,  _15, t0) <@ RW.MM.__a_ilen_read_upto8_at (buf0, offset,
      0, _LEN, _TRAILB, aT, aT);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i])) (at + 0)
      ((get64 (WArray800.init256 (fun i => st.[i])) (at + 0)) `^` t0))));
      ( _16,  _17,  _18,  _19, t1) <@ RW.MM.__a_ilen_read_upto8_at (buf1, offset,
      0, _LEN, _TRAILB, aT, aT);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i])) (at + 1)
      ((get64 (WArray800.init256 (fun i => st.[i])) (at + 1)) `^` t1))));
      ( _20,  _21,  _22,  _23, t2) <@ RW.MM.__a_ilen_read_upto8_at (buf2, offset,
      0, _LEN, _TRAILB, aT, aT);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i])) (at + 2)
      ((get64 (WArray800.init256 (fun i => st.[i])) (at + 2)) `^` t2))));
      (dELTA, _LEN, _TRAILB, aT, t3) <@ RW.MM.__a_ilen_read_upto8_at (buf3, 
      offset, 0, _LEN, _TRAILB, aT, aT);
      st <-
      (Array25.init
      (WArray800.get256
      (WArray800.set64 (WArray800.init256 (fun i => st.[i])) (at + 3)
      ((get64 (WArray800.init256 (fun i => st.[i])) (at + 3)) `^` t3))));
      offset <- (offset + dELTA);
    } else {
      
    }
    return (st, aT, offset);
  }
  proc __absorb_avx2x4 (st:W256.t Array25.t, aT:int, buf0:W8.t A.t,
                        buf1:W8.t A.t, buf2:W8.t A.t,
                        buf3:W8.t A.t, _TRAILB:int, _RATE8:int) : 
  W256.t Array25.t * int = {
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
      (st,  _0, offset) <@ __addstate_avx2x4 (st, aT, buf0, buf1, buf2, 
      buf3, offset, (_RATE8 - aT), 0);
      _LEN <- (_LEN - (_RATE8 - aT));
      aT <- 0;
      st <@ M._keccakf1600_avx2x4 (st);
      iTERS <- (_LEN %/ _RATE8);
      i <- 0;
      while ((i < iTERS)) {
        (st,  _1, offset) <@ __addstate_avx2x4 (st, 0, buf0, buf1, buf2,
        buf3, offset, _RATE8, 0);
        st <@ M._keccakf1600_avx2x4 (st);
        i <- (i + 1);
      }
      _LEN <- (_LEN %% _RATE8);
    } else {
      
    }
    (st, aT,  _2) <@ __addstate_avx2x4 (st, aT, buf0, buf1, buf2, buf3,
    offset, _LEN, _TRAILB);
    if ((_TRAILB <> 0)) {
      st <@ M.__addratebit_avx2x4 (st, _RATE8);
    } else {
      
    }
    return (st, aT);
  }
  proc __dumpstate_avx2x4 (buf0:W8.t A.t, buf1:W8.t A.t,
                           buf2:W8.t A.t, buf3:W8.t A.t,
                           offset:int, _LEN:int, st:W256.t Array25.t) : 
  W8.t A.t * W8.t A.t * W8.t A.t * W8.t A.t * int = {
    var x0:W256.t;
    var x1:W256.t;
    var x2:W256.t;
    var x3:W256.t;
    var t0:W64.t;
    var t1:W64.t;
    var t2:W64.t;
    var t3:W64.t;
    var i:int;
    var  _0:int;
    var  _1:int;
    var  _2:int;
    var  _3:int;
    var  _4:int;
    var  _5:int;
    var  _6:int;
    var  _7:int;
    i <- 0;
    while ((i < (32 * (_LEN %/ 32)))) {
      x0 <-
      (get256_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (0 * 32)));
      x1 <-
      (get256_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (1 * 32)));
      x2 <-
      (get256_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (2 * 32)));
      x3 <-
      (get256_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (3 * 32)));
      i <- (i + 32);
      (x0, x1, x2, x3) <@ M.__4u64x4_u256x4 (x0, x1, x2, x3);
      buf0 <-
      (A.init
      (WA.get8
      (WA.set256_direct (WA.init8 (fun i_0 => buf0.[i_0]))
      offset x0)));
      buf1 <-
      (A.init
      (WA.get8
      (WA.set256_direct (WA.init8 (fun i_0 => buf1.[i_0]))
      offset x1)));
      buf2 <-
      (A.init
      (WA.get8
      (WA.set256_direct (WA.init8 (fun i_0 => buf2.[i_0]))
      offset x2)));
      buf3 <-
      (A.init
      (WA.get8
      (WA.set256_direct (WA.init8 (fun i_0 => buf3.[i_0]))
      offset x3)));
      offset <- (offset + 32);
    }
    while ((i < (8 * (_LEN %/ 8)))) {
      t0 <-
      (get64_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (0 * 8)));
      buf0 <-
      (A.init
      (WA.get8
      (WA.set64_direct (WA.init8 (fun i_0 => buf0.[i_0]))
      offset t0)));
      t1 <-
      (get64_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (1 * 8)));
      buf1 <-
      (A.init
      (WA.get8
      (WA.set64_direct (WA.init8 (fun i_0 => buf1.[i_0]))
      offset t1)));
      t2 <-
      (get64_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (2 * 8)));
      buf2 <-
      (A.init
      (WA.get8
      (WA.set64_direct (WA.init8 (fun i_0 => buf2.[i_0]))
      offset t2)));
      t3 <-
      (get64_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (3 * 8)));
      buf3 <-
      (A.init
      (WA.get8
      (WA.set64_direct (WA.init8 (fun i_0 => buf3.[i_0]))
      offset t3)));
      i <- (i + 8);
      offset <- (offset + 8);
    }
    if ((0 < (_LEN %% 8))) {
      t0 <-
      (get64_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (0 * 8)));
      (buf0,  _0,  _1) <@ RW.MM.__a_ilen_write_upto8 (buf0, offset, 0, (_LEN %% 8),
      t0);
      t1 <-
      (get64_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (1 * 8)));
      (buf1,  _2,  _3) <@ RW.MM.__a_ilen_write_upto8 (buf1, offset, 0, (_LEN %% 8),
      t1);
      t2 <-
      (get64_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (2 * 8)));
      (buf2,  _4,  _5) <@ RW.MM.__a_ilen_write_upto8 (buf2, offset, 0, (_LEN %% 8),
      t2);
      t3 <-
      (get64_direct (WArray800.init256 (fun i_0 => st.[i_0]))
      ((4 * i) + (3 * 8)));
      (buf3,  _6,  _7) <@ RW.MM.__a_ilen_write_upto8 (buf3, offset, 0, (_LEN %% 8),
      t3);
      offset <- (offset + (_LEN %% 8));
    } else {
      
    }
    return (buf0, buf1, buf2, buf3, offset);
  }
  proc __squeeze_avx2x4 (st:W256.t Array25.t, buf0:W8.t A.t,
                         buf1:W8.t A.t, buf2:W8.t A.t,
                         buf3:W8.t A.t, _RATE8:int) : W256.t Array25.t *
                                                             W8.t A.t *
                                                             W8.t A.t *
                                                             W8.t A.t *
                                                             W8.t A.t = {
    var _LEN:int;
    var iTERS:int;
    var lO:int;
    var offset:int;
    var i:int;
    offset <- 0;
    _LEN <- _ASIZE;
    iTERS <- (_LEN %/ _RATE8);
    lO <- (_LEN %% _RATE8);
    if ((0 < iTERS)) {
      i <- 0;
      while ((i < iTERS)) {
        st <@ M._keccakf1600_avx2x4 (st);
        (buf0, buf1, buf2, buf3, offset) <@ __dumpstate_avx2x4 (buf0, 
        buf1, buf2, buf3, offset, _RATE8, st);
        i <- (i + 1);
      }
    } else {
      
    }
    if ((0 < lO)) {
      st <@ M._keccakf1600_avx2x4 (st);
      (buf0, buf1, buf2, buf3, offset) <@ __dumpstate_avx2x4 (buf0, buf1,
      buf2, buf3, offset, lO, st);
    } else {
      
    }
    return (st, buf0, buf1, buf2, buf3);
  }
}.


(*
   INCREMENTAL (FIXED-SIZE) MEMORY ABSORB
   ===================================
*)

lemma addstate_bcast_avx2x4_ll: islossless MM.__addstate_bcast_avx2x4.
proof.
proc.
seq 7: true => //.
 while true (32 * (aT %/ 8 + _LEN %/ 8)-at).
  by move=> z; auto => /#.
 sp; if => //.
  by wp; call a_ilen_read_bcast_upto8_at_ll; auto => /#.
 by auto => /#.
sp; if => //.
by wp; call a_ilen_read_bcast_upto8_at_ll; auto => /#.
qed.

lemma addstate_avx2x4_ll: islossless MM.__addstate_avx2x4.
proof.
proc.
seq 7: true => //.
 while true (4 * (aT %/ 8) + 4 * (_LEN %/ 8)-at).
  by move=> z; auto => /#.
 sp; if => //.
  wp; call a_ilen_read_upto8_at_ll.
  wp; call a_ilen_read_upto8_at_ll.
  wp; call a_ilen_read_upto8_at_ll.
  wp; call a_ilen_read_upto8_at_ll.
  by auto => /#.
 by auto => /#.
sp; if => //.
wp; call a_ilen_read_upto8_at_ll.
wp; call a_ilen_read_upto8_at_ll.
wp; call a_ilen_read_upto8_at_ll.
wp; call a_ilen_read_upto8_at_ll.
by auto => /#.
qed.

op asx4_lane (_s s: state) (buf: W8.t A.t) (_off _at _len _tb: int) (ws: W64.t list) (at dlt len tb: int) =
 s = addstate _s (Array25.of_list W64.zero ws)
 /\ asubread buf _off (w64L_to_bytes ws) 0 _at 0 _len _tb at dlt len tb.

op asx4_inv (_st st: state4x) (b0 b1 b2 b3: W8.t A.t) (_off _at _len _tb j at dlt len tb: int) =
 exists (ws0 ws1 ws2 ws3: W64.t list),
  size ws0 = j /\ size ws1 = j /\ size ws2 = j /\ size ws3 = j
  /\ asx4_lane (st4x_get _st 0) (st4x_get st 0) b0 _off _at _len _tb ws0 at dlt len tb
  /\ asx4_lane (st4x_get _st 1) (st4x_get st 1) b1 _off _at _len _tb ws1 at dlt len tb
  /\ asx4_lane (st4x_get _st 2) (st4x_get st 2) b2 _off _at _len _tb ws2 at dlt len tb
  /\ asx4_lane (st4x_get _st 3) (st4x_get st 3) b3 _off _at _len _tb ws3 at dlt len tb.

lemma asx4_lane_init _s buf _off _at _len _tb:
 0 <= _at =>
 asx4_lane _s _s buf _off _at _len _tb (nseq (_at %/ 8) W64.zero) _at 0 _len _tb.
proof.
move=> Hat; rewrite /asx4_lane w64L_to_bytes_nseq0 1:/#; split.
+ apply Array25.ext_eq => i Hi; rewrite /addstate /map2 initiE //= get_of_list // nth_nseq_if.
  by rewrite (_ : (if 0 <= i < _at %/ 8 then W64.zero else W64.zero) = W64.zero) 1:/# W64.xorw0.
by apply asubread0; rewrite size_nseq; smt().
qed.

lemma asx4_init _st b0 b1 b2 b3 _off _at _len _tb:
 0 <= _at =>
 asx4_inv _st _st b0 b1 b2 b3 _off _at _len _tb (_at %/ 8) _at 0 _len _tb.
proof.
move=> Hat; exists (nseq (_at %/ 8) W64.zero) (nseq (_at %/ 8) W64.zero) (nseq (_at %/ 8) W64.zero) (nseq (_at %/ 8) W64.zero).
by rewrite !size_nseq (_ : max 0 (_at %/ 8) = _at %/ 8) 1:/# /= !asx4_lane_init.
qed.

lemma asx4_lane_step _s s buf _off _at _len _tb ws at dlt len tb t at' dlt' len' tb':
 size ws < 25 =>
 asx4_lane _s s buf _off _at _len _tb ws at dlt len tb =>
 asubread buf _off (u64bytes t) (8 * size ws) at dlt len tb at' dlt' len' tb' =>
 asx4_lane _s (s.[size ws <- s.[size ws] `^` t]) buf _off _at _len _tb (rcons ws t) at' dlt' len' tb'.
proof.
move=> Hs [-> H] Ht; split; first by rewrite addstate_of_list_rcons.
rewrite -cats1 w64L_to_bytes_cat w64L_to_bytes_singl -/(u64bytes t).
apply (asubread_cat _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ H).
by rewrite size_w64L_to_bytes /=.
qed.

abbrev st4x_xor64 (st: state4x) (x: int) (t: W64.t) : state4x =
 Array25.init (WArray800.get256 (WArray800.set64 (WArray800.init256 (fun i => st.[i])) x (WArray800.get64 (WArray800.init256 (fun i => st.[i])) x `^` t))).

lemma asx4_step _st st b0 b1 b2 b3 _off _at _len _tb j at dlt len tb t0 t1 t2 t3 a0 d0 l0 e0 a1 d1 l1 e1 a2 d2 l2 e2 at' dlt' len' tb':
 0 <= j < 25 =>
 asx4_inv _st st b0 b1 b2 b3 _off _at _len _tb j at dlt len tb =>
 asubread b0 _off (u64bytes t0) (8*j) at dlt len tb a0 d0 l0 e0 =>
 asubread b1 _off (u64bytes t1) (8*j) at dlt len tb a1 d1 l1 e1 =>
 asubread b2 _off (u64bytes t2) (8*j) at dlt len tb a2 d2 l2 e2 =>
 asubread b3 _off (u64bytes t3) (8*j) at dlt len tb at' dlt' len' tb' =>
 asx4_inv _st (st4x_xor64 (st4x_xor64 (st4x_xor64 (st4x_xor64 st (4*j+0) t0) (4*j+1) t1) (4*j+2) t2) (4*j+3) t3) b0 b1 b2 b3 _off _at _len _tb (j+1) at' dlt' len' tb'.
proof.
move=> Hj [ws0 ws1 ws2 ws3] [#] Hs0 Hs1 Hs2 Hs3 L0 L1 L2 L3 R0 R1 R2 R3.
have Hsz : forall (x y: W64.t), size (u64bytes x) = size (u64bytes y) by move=> x y; rewrite /u64bytes !W8u8.size_to_list.
have [#] E0a E0d E0l E0e := asubread_cnt _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (Hsz t0 t3) R0 R3.
have [#] E1a E1d E1l E1e := asubread_cnt _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (Hsz t1 t3) R1 R3.
have [#] E2a E2d E2l E2e := asubread_cnt _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ (Hsz t2 t3) R2 R3.
move: R0 R1 R2; rewrite E0a E0d E0l E0e E1a E1d E1l E1e E2a E2d E2l E2e => R0 R1 R2.
exists (rcons ws0 t0) (rcons ws1 t1) (rcons ws2 t2) (rcons ws3 t3).
rewrite !size_rcons Hs0 Hs1 Hs2 Hs3 !st4x_get_xor64 // /=.
split; first by move: (asx4_lane_step (st4x_get _st 0) (st4x_get st 0) b0 _off _at _len _tb ws0 at dlt len tb t0 at' dlt' len' tb'); rewrite Hs0; apply => //; smt().
split; first by move: (asx4_lane_step (st4x_get _st 1) (st4x_get st 1) b1 _off _at _len _tb ws1 at dlt len tb t1 at' dlt' len' tb'); rewrite Hs1; apply => //; smt().
split; first by move: (asx4_lane_step (st4x_get _st 2) (st4x_get st 2) b2 _off _at _len _tb ws2 at dlt len tb t2 at' dlt' len' tb'); rewrite Hs2; apply => //; smt().
by move: (asx4_lane_step (st4x_get _st 3) (st4x_get st 3) b3 _off _at _len _tb ws3 at dlt len tb t3 at' dlt' len' tb'); rewrite Hs3; apply => //; smt().
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

lemma asx4_step_bcast _st st buf _off _at _len _tb j at dlt len tb t at' dlt' len' tb':
 0 <= j < 25 =>
 asx4_inv _st st buf buf buf buf _off _at _len _tb j at dlt len tb =>
 asubread buf _off (u64bytes t) (8*j) at dlt len tb at' dlt' len' tb' =>
 asx4_inv _st (st.[j <- VPBROADCAST_4u64 t `^` st.[j]]) buf buf buf buf _off _at _len _tb (j+1) at' dlt' len' tb'.
proof.
move=> Hj [ws0 ws1 ws2 ws3] [#] Hs0 Hs1 Hs2 Hs3 L0 L1 L2 L3 R.
exists (rcons ws0 t) (rcons ws1 t) (rcons ws2 t) (rcons ws3 t).
rewrite !size_rcons Hs0 Hs1 Hs2 Hs3 !st4x_get_bcast //=.
split; first by move: (asx4_lane_step (st4x_get _st 0) (st4x_get st 0) buf _off _at _len _tb ws0 at dlt len tb t at' dlt' len' tb'); rewrite Hs0; apply => //; smt().
split; first by move: (asx4_lane_step (st4x_get _st 1) (st4x_get st 1) buf _off _at _len _tb ws1 at dlt len tb t at' dlt' len' tb'); rewrite Hs1; apply => //; smt().
split; first by move: (asx4_lane_step (st4x_get _st 2) (st4x_get st 2) buf _off _at _len _tb ws2 at dlt len tb t at' dlt' len' tb'); rewrite Hs2; apply => //; smt().
by move: (asx4_lane_step (st4x_get _st 3) (st4x_get st 3) buf _off _at _len _tb ws3 at dlt len tb t at' dlt' len' tb'); rewrite Hs3; apply => //; smt().
qed.

lemma asx4_final _st st b0 b1 b2 b3 _off _at _len _tb j at dlt:
 asubread_pre 0 _at _off 0 _len _tb =>
 asx4_inv _st st b0 b1 b2 b3 _off _at _len _tb j at dlt 0 0 =>
 st = addstate_avx2x4 _st (nseq _at W8.zero ++ sub b0 _off _len ++ [W8.of_int _tb])
                          (nseq _at W8.zero ++ sub b1 _off _len ++ [W8.of_int _tb])
                          (nseq _at W8.zero ++ sub b2 _off _len ++ [W8.of_int _tb])
                          (nseq _at W8.zero ++ sub b3 _off _len ++ [W8.of_int _tb])
 /\ at = _at + _len + b2i (_tb<>0)
 /\ dlt = _len.
proof.
move=> Hpre [ws0 ws1 ws2 ws3] [#] _ _ _ _ [E0 R0] [E1 R1] [E2 R2] [E3 R3].
have := asubreadP _ _ _ _ _ _ _ _ _ _ _ Hpre _ R0; first by right.
move=> [#] B0 -> -> _ _; have := asubreadP _ _ _ _ _ _ _ _ _ _ _ Hpre _ R1; first by right.
move=> [#] B1 _ _ _ _; have := asubreadP _ _ _ _ _ _ _ _ _ _ _ Hpre _ R2; first by right.
move=> [#] B2 _ _ _ _; have := asubreadP _ _ _ _ _ _ _ _ _ _ _ Hpre _ R3; first by right.
move=> [#] B3 _ _ _ _; move: B0 B1 B2 B3; rewrite !addz0 => B0 B1 B2 B3.
rewrite /= /addstate_avx2x4 B0 B1 B2 B3 !bytes2state_w64L -E0 -E1 -E2 -E3.
by rewrite -{1}(st4x_unpackK st).
qed.

hoare addstate_avx2x4_h _st _buf0 _buf1 _buf2 _buf3 _off _len _tb _at:
 MM.__addstate_avx2x4
 : st=_st /\ buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3
 /\ offset=_off /\ _LEN=_len /\ _TRAILB=_tb /\ aT=_at
 /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0)
 /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
 ==> res.`1 = addstate_avx2x4 _st (nseq _at W8.zero ++ sub _buf0 _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf1 _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf2 _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf3 _off _len ++ [W8.of_int _tb])
  /\ res.`2 = _at + _len + b2i (_tb<>0)
  /\ res.`3 = _off + _len.
proof.
proc; seq 4 : (buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3 /\ offset = _off
               /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
               /\ asx4_inv _st st buf0 buf1 buf2 buf3 _off _at _len _tb (_at %/ 8 + b2i (_at %% 8 <> 0)) aT dELTA _LEN _TRAILB
               /\ (aT %% 8 = 0 => aT %/ 8 = _at %/ 8 + b2i (_at %% 8 <> 0))
               /\ (aT %% 8 <> 0 => _LEN = 0 /\ _TRAILB = 0)
               /\ aT + _LEN + b2i (_TRAILB <> 0) = _at + _len + b2i (_tb <> 0)
               /\ dELTA + _LEN = _len /\ 0 <= _LEN /\ 0 <= _TRAILB < 256 /\ 0 <= dELTA /\ 0 <= aT).
+ sp; if.
  + wp; ecall (a_ilen_read_upto8_at_h buf3 offset dELTA _LEN _TRAILB aT aT8).
    wp; ecall (a_ilen_read_upto8_at_h buf2 offset dELTA _LEN _TRAILB aT aT8).
    wp; ecall (a_ilen_read_upto8_at_h buf1 offset dELTA _LEN _TRAILB aT aT8).
    wp; ecall (a_ilen_read_upto8_at_h buf0 offset dELTA _LEN _TRAILB aT aT8).
    skip => &hr /= [#] -> -> -> -> -> -> -> -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Hm r0 R0 r1 R1 r2 R2 r3 R3.
    have Hle : forall (b: W8.t A.t) off lw (cur at dlt len tb at' dlt' len' tb': int), asubread b off lw cur at dlt len tb at' dlt' len' tb' => len' <= len by move=> *; smt(asubread_cons).
    have Hs := asx4_step _st _st _buf0 _buf1 _buf2 _buf3 _off _at _len _tb (_at %/ 8) _at 0 _len _tb r0.`5 r1.`5 r2.`5 r3.`5 _ _ _ _ _ _ _ _ _ _ _ _ r3.`4 r3.`1 r3.`2 r3.`3 _ (asx4_init _ _ _ _ _ _ _ _ _ Hat0) R0 R1 R2 R3; first smt().
    have [#] C1 C2 C3 C4 C5 := asubread_cons _ _ _ _ _ _ _ _ _ _ _ _ R3.
    have [C6 C7] := asubread_w8 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ R3; [by rewrite /u64bytes W8u8.size_to_list | smt() | smt() | ].
    rewrite (_ : 8 * (_at %/ 8) %/ 8 = _at %/ 8) 1:/# (_ : b2i (_at %% 8 <> 0) = 1) 1:/# Hs /=.
    by have := Hle _ _ _ _ _ _ _ _ _ _ _ _ R3; smt().
  skip => &hr /= [#] -> -> -> -> -> -> -> -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Hm.
  by rewrite (_ : 8 * (_at %/ 8) = _at) 1:/# (_ : b2i (_at %% 8 <> 0) = 0) 1:/# /= asx4_init //; smt().
case: (aT %% 8 = 0); last first.
+ rcondf 3; first by auto => /> /#.
  rcondf 5; first by auto => /> /#.
  wp; skip => &hr [#] -> -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Hinv _ Hpart Hcons Hdl HL0 HT0 HT1 Hd0 Ha0 Hm /=.
  have [EL ET] := Hpart Hm; move: Hinv Hcons Hdl; rewrite EL ET /= => Hinv Hcons Hdl.
  have Hpre : asubread_pre 0 _at _off 0 _len _tb by rewrite /asubread_pre; smt().
  by have [#] -> -> -> := asx4_final _ _ _ _ _ _ _ _ _ _ _ _ _ Hpre Hinv.
seq 3 : (buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3
         /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
         /\ aT %% 8 = 0 /\ at = 4 * (aT %/ 8) + 4 * (_LEN %/ 8) /\ offset = _off + dELTA + 8 * (_LEN %/ 8)
         /\ asx4_inv _st st buf0 buf1 buf2 buf3 _off _at _len _tb (aT %/ 8 + _LEN %/ 8) (aT + 8 * (_LEN %/ 8)) (dELTA + 8 * (_LEN %/ 8)) (_LEN %% 8) _TRAILB
         /\ aT + _LEN + b2i (_TRAILB <> 0) = _at + _len + b2i (_tb <> 0)
         /\ dELTA + _LEN = _len /\ 0 <= _LEN /\ 0 <= _TRAILB < 256).
+ while (buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3
         /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
         /\ aT %% 8 = 0 /\ 4 * (aT %/ 8) <= at <= 4 * (aT %/ 8) + 4 * (_LEN %/ 8) /\ at %% 4 = 0
         /\ offset = _off + dELTA + 2 * (at - 4 * (aT %/ 8))
         /\ asx4_inv _st st buf0 buf1 buf2 buf3 _off _at _len _tb (at %/ 4) (aT + 2 * (at - 4 * (aT %/ 8))) (dELTA + 2 * (at - 4 * (aT %/ 8))) (_LEN - 2 * (at - 4 * (aT %/ 8))) _TRAILB
         /\ aT + _LEN + b2i (_TRAILB <> 0) = _at + _len + b2i (_tb <> 0)
         /\ dELTA + _LEN = _len /\ 0 <= _LEN /\ 0 <= _TRAILB < 256).
  + wp; skip => &hr [#] -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Ham Hb0 Hb1 Hm4 Hoffs Hinv Hcons Hdl HL0 HT0 HT1 Hc /=.
    have Sh0 : forall (w: W64.t), w `<<<` 0 = w by move=> w; apply W64.wordP => i Hi; rewrite W64.shlwE /#.
    have [j Ej] : exists j, at{hr} = 4 * j by exists (at{hr} %/ 4); smt().
    have EA : aT{hr} + 2 * (4 * j - 4 * (aT{hr} %/ 8)) = 8 * j by smt().
    move: Hinv; rewrite Ej (_ : 4 * j %/ 4 = j) 1:/# EA => Hinv.
    have A0 := asubread_u64 _buf0 _off (8*j) (8*j) (dELTA{hr} + 2 * (4 * j - 4 * (aT{hr} %/ 8))) (_LEN{hr} - 2 * (4 * j - 4 * (aT{hr} %/ 8))) _TRAILB{hr} _ _; 1,2: smt().
    have A1 := asubread_u64 _buf1 _off (8*j) (8*j) (dELTA{hr} + 2 * (4 * j - 4 * (aT{hr} %/ 8))) (_LEN{hr} - 2 * (4 * j - 4 * (aT{hr} %/ 8))) _TRAILB{hr} _ _; 1,2: smt().
    have A2 := asubread_u64 _buf2 _off (8*j) (8*j) (dELTA{hr} + 2 * (4 * j - 4 * (aT{hr} %/ 8))) (_LEN{hr} - 2 * (4 * j - 4 * (aT{hr} %/ 8))) _TRAILB{hr} _ _; 1,2: smt().
    have A3 := asubread_u64 _buf3 _off (8*j) (8*j) (dELTA{hr} + 2 * (4 * j - 4 * (aT{hr} %/ 8))) (_LEN{hr} - 2 * (4 * j - 4 * (aT{hr} %/ 8))) _TRAILB{hr} _ _; 1,2: smt().
    move: A0 A1 A2 A3; rewrite (_ : 8 * (8 * j - 8 * j) = 0) 1:/# !Sh0 (_ : 8 * j + 8 - 8 * j = 8) 1:/# => A0 A1 A2 A3.
    have Hs := asx4_step _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ Hinv A0 A1 A2 A3; first smt().
    have -> : offset{hr} = _off + (dELTA{hr} + 2 * (4 * j - 4 * (aT{hr} %/ 8))) by smt().
    rewrite (_ : (4 * j + 4) %/ 4 = j + 1) 1:/# (_ : aT{hr} + 2 * (4 * j + 4 - 4 * (aT{hr} %/ 8)) = 8 * j + 8) 1:/#.
    rewrite (_ : dELTA{hr} + 2 * (4 * j + 4 - 4 * (aT{hr} %/ 8)) = dELTA{hr} + 2 * (4 * j - 4 * (aT{hr} %/ 8)) + 8) 1:/#.
    rewrite (_ : _LEN{hr} - 2 * (4 * j + 4 - 4 * (aT{hr} %/ 8)) = _LEN{hr} - 2 * (4 * j - 4 * (aT{hr} %/ 8)) - 8) 1:/#.
    by move: Hs; rewrite /= => Hs; rewrite Hs /=; smt().
  wp; skip => &hr [#] -> -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Hinv Hal Hpart Hcons Hdl HL0 HT0 HT1 Hd0 Ha0 Ham /=.
  split; first by rewrite (_ : 4 * (aT{hr} %/ 8) %/ 4 = _at %/ 8 + b2i (_at %% 8 <> 0)) 1:/# Hinv /=; smt().
  move=> at0 offset0 st0 Hc [#] _ _ _ _ _ _ _ _ Hb0 Hb1 Hm4 Hoffs Hinv0 _ _ _ _ _.
  have Eat0 : at0 = 4 * (aT{hr} %/ 8) + 4 * (_LEN{hr} %/ 8) by smt().
  move: Hinv0; rewrite Eat0 (_ : (4 * (aT{hr} %/ 8) + 4 * (_LEN{hr} %/ 8)) %/ 4 = aT{hr} %/ 8 + _LEN{hr} %/ 8) 1:/#.
  rewrite (_ : 2 * (4 * (aT{hr} %/ 8) + 4 * (_LEN{hr} %/ 8) - 4 * (aT{hr} %/ 8)) = 8 * (_LEN{hr} %/ 8)) 1:/#.
  by rewrite (_ : _LEN{hr} - 8 * (_LEN{hr} %/ 8) = _LEN{hr} %% 8) 1:/# => Hinv0; rewrite Hinv0 /=; smt().
seq 2 : (buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3
         /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
         /\ aT %% 8 = 0 /\ at = 4 * (aT %/ 8) /\ 0 <= _LEN < 8 /\ 0 <= _TRAILB < 256 /\ 0 <= offset - _off
         /\ asx4_inv _st st buf0 buf1 buf2 buf3 _off _at _len _tb (aT %/ 8) aT (offset - _off) _LEN _TRAILB
         /\ aT + _LEN + b2i (_TRAILB <> 0) = _at + _len + b2i (_tb <> 0)
         /\ (offset - _off) + _LEN = _len).
+ wp; skip => &hr [#] -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Ham Eat Eoff Hinv Hcons Hdl HL0 HT0 HT1 /=.
  rewrite Eoff (_ : _off + dELTA{hr} + 8 * (_LEN{hr} %/ 8) - _off = dELTA{hr} + 8 * (_LEN{hr} %/ 8)) 1:/#.
  by rewrite (_ : (aT{hr} + 8 * (_LEN{hr} %/ 8)) %/ 8 = aT{hr} %/ 8 + _LEN{hr} %/ 8) 1:/# Hinv /=; smt().
if; last first.
+ skip => &hr [#] -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Ham Eat HL0 HL1 HT0 HT1 Hoffd Hinv Hcons Hdl Hc /=.
  have [EL ET] : _LEN{hr} = 0 /\ _TRAILB{hr} = 0 by smt().
  move: Hinv; rewrite EL ET => Hinv.
  have Hpre : asubread_pre 0 _at _off 0 _len _tb by rewrite /asubread_pre; smt().
  by have [#] -> -> Ed := asx4_final _ _ _ _ _ _ _ _ _ _ _ _ _ Hpre Hinv; smt().
wp; ecall (a_ilen_read_upto8_at_h buf3 offset 0 _LEN _TRAILB aT aT).
wp; ecall (a_ilen_read_upto8_at_h buf2 offset 0 _LEN _TRAILB aT aT).
wp; ecall (a_ilen_read_upto8_at_h buf1 offset 0 _LEN _TRAILB aT aT).
wp; ecall (a_ilen_read_upto8_at_h buf0 offset 0 _LEN _TRAILB aT aT).
skip => &hr [#] -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Ham Eat HL0 HL1 HT0 HT1 Hoffd Hinv Hcons Hdl Hc r0 R0 /= r1 R1 /= r2 R2 /= r3 R3 /=.
have [L0 T0] := asubread_w8_last _ _ _ _ _ _ _ _ _ _ _ _ _ R3; [by rewrite /u64bytes W8u8.size_to_list | smt() | ].
have Sh : forall (b: W8.t A.t) lw (a1 d1 l1 t1: int),
  asubread b offset{hr} lw aT{hr} aT{hr} 0 _LEN{hr} _TRAILB{hr} a1 d1 l1 t1 =>
  asubread b _off lw (8 * (aT{hr} %/ 8)) aT{hr} (offset{hr} - _off) _LEN{hr} _TRAILB{hr} a1 ((offset{hr} - _off) + d1) l1 t1.
+ move=> b lw a1 d1 l1 t1 H; rewrite (_ : 8 * (aT{hr} %/ 8) = aT{hr}) 1:/#; apply asubread_shift => //.
  by rewrite (_ : _off + (offset{hr} - _off) = offset{hr}) 1:/#.
have Hs := asx4_step _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ Hinv (Sh _ _ _ _ _ _ R0) (Sh _ _ _ _ _ _ R1) (Sh _ _ _ _ _ _ R2) (Sh _ _ _ _ _ _ R3); first smt().
move: Hs; rewrite L0 T0 /= => Hs.
have Hpre : asubread_pre 0 _at _off 0 _len _tb by rewrite /asubread_pre; smt().
have [#] Est Eat' Edl := asx4_final _ _ _ _ _ _ _ _ _ _ _ _ _ Hpre Hs.
by rewrite Eat /= -Est Eat'; smt().
qed.

phoare addstate_avx2x4_ph _st _buf0 _buf1 _buf2 _buf3 _off _len _tb _at:
 [ MM.__addstate_avx2x4
 : st=_st /\ buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3
 /\ offset=_off /\ _LEN=_len /\ _TRAILB=_tb /\ aT=_at
 /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0)
 /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
 ==> res.`1 = addstate_avx2x4 _st (nseq _at W8.zero ++ sub _buf0 _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf1 _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf2 _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf3 _off _len ++ [W8.of_int _tb])
  /\ res.`2 = _at + _len + b2i (_tb<>0)
  /\ res.`3 = _off + _len
 ] = 1%r.
proof. by conseq addstate_avx2x4_ll (addstate_avx2x4_h _st _buf0 _buf1 _buf2 _buf3 _off _len _tb _at). qed.

hoare addstate_bcast_avx2x4_h _st _buf _off _len _tb _at:
 MM.__addstate_bcast_avx2x4
 : st=_st /\ buf=_buf
 /\ offset=_off /\ _LEN=_len /\ _TRAILB=_tb /\ aT=_at
 /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0)
 /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
 ==> res.`1 = addstate_avx2x4 _st (nseq _at W8.zero ++ sub _buf _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf _off _len ++ [W8.of_int _tb])
  /\ res.`2 = _at + _len + b2i (_tb<>0)
  /\ res.`3 = _off + _len.
proof.
proc; seq 4 : (buf=_buf /\ offset = _off
               /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
               /\ asx4_inv _st st buf buf buf buf _off _at _len _tb (_at %/ 8 + b2i (_at %% 8 <> 0)) aT dELTA _LEN _TRAILB
               /\ (aT %% 8 = 0 => aT %/ 8 = _at %/ 8 + b2i (_at %% 8 <> 0))
               /\ (aT %% 8 <> 0 => _LEN = 0 /\ _TRAILB = 0)
               /\ aT + _LEN + b2i (_TRAILB <> 0) = _at + _len + b2i (_tb <> 0)
               /\ dELTA + _LEN = _len /\ 0 <= _LEN /\ 0 <= _TRAILB < 256 /\ 0 <= dELTA /\ 0 <= aT).
+ sp; if.
  + wp; ecall (a_ilen_read_bcast_upto8_at_h buf offset dELTA _LEN _TRAILB aT aT8).
    skip => &hr /= [#] -> -> -> -> -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Hm r [w [Ew R]].
    have Hle : forall (b: W8.t A.t) off lw (cur at dlt len tb at' dlt' len' tb': int), asubread b off lw cur at dlt len tb at' dlt' len' tb' => len' <= len by move=> *; smt(asubread_cons).
    have Hs := asx4_step_bcast _st _st _buf _off _at _len _tb (_at %/ 8) _at 0 _len _tb w r.`4 r.`1 r.`2 r.`3 _ (asx4_init _ _ _ _ _ _ _ _ _ Hat0) R; first smt().
    have [#] C1 C2 C3 C4 C5 := asubread_cons _ _ _ _ _ _ _ _ _ _ _ _ R.
    have [C6 C7] := asubread_w8 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ R; [by rewrite /u64bytes W8u8.size_to_list | smt() | smt() | ].
    rewrite Ew (_ : 8 * (_at %/ 8) %/ 8 = _at %/ 8) 1:/# (_ : b2i (_at %% 8 <> 0) = 1) 1:/# Hs /=.
    by have := Hle _ _ _ _ _ _ _ _ _ _ _ _ R; smt().
  skip => &hr /= [#] -> -> -> -> -> -> -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Hm.
  by rewrite (_ : 8 * (_at %/ 8) = _at) 1:/# (_ : b2i (_at %% 8 <> 0) = 0) 1:/# /= asx4_init //; smt().
case: (aT %% 8 = 0); last first.
+ rcondf 3; first by auto => /> /#.
  rcondf 5; first by auto => /> /#.
  wp; skip => &hr [#] -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Hinv _ Hpart Hcons Hdl HL0 HT0 HT1 Hd0 Ha0 Hm /=.
  have [EL ET] := Hpart Hm; move: Hinv Hcons Hdl; rewrite EL ET /= => Hinv Hcons Hdl.
  have Hpre : asubread_pre 0 _at _off 0 _len _tb by rewrite /asubread_pre; smt().
  by have [#] -> -> -> := asx4_final _ _ _ _ _ _ _ _ _ _ _ _ _ Hpre Hinv.
seq 3 : (buf=_buf
         /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
         /\ aT %% 8 = 0 /\ at = 32 * (aT %/ 8 + _LEN %/ 8) /\ offset = _off + dELTA + 8 * (_LEN %/ 8)
         /\ asx4_inv _st st buf buf buf buf _off _at _len _tb (aT %/ 8 + _LEN %/ 8) (aT + 8 * (_LEN %/ 8)) (dELTA + 8 * (_LEN %/ 8)) (_LEN %% 8) _TRAILB
         /\ aT + _LEN + b2i (_TRAILB <> 0) = _at + _len + b2i (_tb <> 0)
         /\ dELTA + _LEN = _len /\ 0 <= _LEN /\ 0 <= _TRAILB < 256).
+ while (buf=_buf
         /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
         /\ aT %% 8 = 0 /\ 32 * (aT %/ 8) <= at <= 32 * (aT %/ 8 + _LEN %/ 8) /\ at %% 32 = 0
         /\ offset = _off + dELTA + 8 * (at %/ 32 - aT %/ 8)
         /\ asx4_inv _st st buf buf buf buf _off _at _len _tb (at %/ 32) (aT + 8 * (at %/ 32 - aT %/ 8)) (dELTA + 8 * (at %/ 32 - aT %/ 8)) (_LEN - 8 * (at %/ 32 - aT %/ 8)) _TRAILB
         /\ aT + _LEN + b2i (_TRAILB <> 0) = _at + _len + b2i (_tb <> 0)
         /\ dELTA + _LEN = _len /\ 0 <= _LEN /\ 0 <= _TRAILB < 256).
  + wp; skip => &hr [#] -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Ham Hb0 Hb1 Hm32 Hoffs Hinv Hcons Hdl HL0 HT0 HT1 Hc /=.
    have Sh0 : forall (w: W64.t), w `<<<` 0 = w by move=> w; apply W64.wordP => i Hi; rewrite W64.shlwE /#.
    have [j Ej] : exists j, at{hr} = 32 * j by exists (at{hr} %/ 32); smt().
    have EA : aT{hr} + 8 * (j - aT{hr} %/ 8) = 8 * j by smt().
    move: Hinv; rewrite Ej (_ : 32 * j %/ 32 = j) 1:/# EA => Hinv.
    have A := asubread_u64 _buf _off (8*j) (8*j) (dELTA{hr} + 8 * (j - aT{hr} %/ 8)) (_LEN{hr} - 8 * (j - aT{hr} %/ 8)) _TRAILB{hr} _ _; 1,2: smt().
    move: A; rewrite (_ : 8 * (8 * j - 8 * j) = 0) 1:/# Sh0 (_ : 8 * j + 8 - 8 * j = 8) 1:/# => A.
    have Hs := asx4_step_bcast _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ Hinv A; first smt().
    have -> : offset{hr} = _off + (dELTA{hr} + 8 * (j - aT{hr} %/ 8)) by smt().
    rewrite st4x_set256 1:/# (_ : (32 * j + 32) %/ 32 = j + 1) 1:/# (_ : aT{hr} + 8 * (j + 1 - aT{hr} %/ 8) = 8 * j + 8) 1:/#.
    rewrite (_ : dELTA{hr} + 8 * (j + 1 - aT{hr} %/ 8) = dELTA{hr} + 8 * (j - aT{hr} %/ 8) + 8) 1:/#.
    rewrite (_ : _LEN{hr} - 8 * (j + 1 - aT{hr} %/ 8) = _LEN{hr} - 8 * (j - aT{hr} %/ 8) - 8) 1:/#.
    by rewrite Hs /=; smt().
  wp; skip => &hr [#] -> -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Hinv Hal Hpart Hcons Hdl HL0 HT0 HT1 Hd0 Ha0 Ham /=.
  split; first by rewrite (_ : 32 * (aT{hr} %/ 8) %/ 32 = aT{hr} %/ 8) 1:/# (_ : 8 * (aT{hr} %/ 8 - aT{hr} %/ 8) = 0) 1:/# /= (Hal Ham) Hinv /=; smt().
  move=> at0 offset0 st0 Hc [#] _ _ _ _ _ _ _ _ Hb0 Hb1 Hm32 Hoffs Hinv0 _ _ _ _ _.
  have Eat0 : at0 = 32 * (aT{hr} %/ 8 + _LEN{hr} %/ 8) by smt().
  move: Hinv0; rewrite Eat0 (_ : 32 * (aT{hr} %/ 8 + _LEN{hr} %/ 8) %/ 32 = aT{hr} %/ 8 + _LEN{hr} %/ 8) 1:/#.
  rewrite (_ : 8 * (aT{hr} %/ 8 + _LEN{hr} %/ 8 - aT{hr} %/ 8) = 8 * (_LEN{hr} %/ 8)) 1:/#.
  by rewrite (_ : _LEN{hr} - 8 * (_LEN{hr} %/ 8) = _LEN{hr} %% 8) 1:/# => Hinv0; rewrite Hinv0 /=; smt().
seq 2 : (buf=_buf
         /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0) /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
         /\ aT %% 8 = 0 /\ at = 32 * (aT %/ 8) /\ 0 <= _LEN < 8 /\ 0 <= _TRAILB < 256 /\ 0 <= offset - _off
         /\ asx4_inv _st st buf buf buf buf _off _at _len _tb (aT %/ 8) aT (offset - _off) _LEN _TRAILB
         /\ aT + _LEN + b2i (_TRAILB <> 0) = _at + _len + b2i (_tb <> 0)
         /\ (offset - _off) + _LEN = _len).
+ wp; skip => &hr [#] -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Ham Eat Eoff Hinv Hcons Hdl HL0 HT0 HT1 /=.
  rewrite Eoff Eat (_ : _off + dELTA{hr} + 8 * (_LEN{hr} %/ 8) - _off = dELTA{hr} + 8 * (_LEN{hr} %/ 8)) 1:/#.
  by rewrite (_ : (aT{hr} + 8 * (_LEN{hr} %/ 8)) %/ 8 = aT{hr} %/ 8 + _LEN{hr} %/ 8) 1:/# Hinv /=; smt().
if; last first.
+ skip => &hr [#] -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Ham Eat HL0 HL1 HT0 HT1 Hoffd Hinv Hcons Hdl Hc /=.
  have [EL ET] : _LEN{hr} = 0 /\ _TRAILB{hr} = 0 by smt().
  move: Hinv; rewrite EL ET => Hinv.
  have Hpre : asubread_pre 0 _at _off 0 _len _tb by rewrite /asubread_pre; smt().
  by have [#] -> -> Ed := asx4_final _ _ _ _ _ _ _ _ _ _ _ _ _ Hpre Hinv; smt().
wp; ecall (a_ilen_read_bcast_upto8_at_h buf offset 0 _LEN _TRAILB aT aT).
skip => &hr [#] -> Hat0 Hat1 Hat2 Hoff0 Hoff1 Htb0 Htb1 Ham Eat HL0 HL1 HT0 HT1 Hoffd Hinv Hcons Hdl Hc r [w [Ew R]] /=.
have [L0 T0] := asubread_w8_last _ _ _ _ _ _ _ _ _ _ _ _ _ R; [by rewrite /u64bytes W8u8.size_to_list | smt() | ].
have Sh : forall (b: W8.t A.t) lw (a1 d1 l1 t1: int),
  asubread b offset{hr} lw aT{hr} aT{hr} 0 _LEN{hr} _TRAILB{hr} a1 d1 l1 t1 =>
  asubread b _off lw (8 * (aT{hr} %/ 8)) aT{hr} (offset{hr} - _off) _LEN{hr} _TRAILB{hr} a1 ((offset{hr} - _off) + d1) l1 t1.
+ move=> b lw a1 d1 l1 t1 H; rewrite (_ : 8 * (aT{hr} %/ 8) = aT{hr}) 1:/#; apply asubread_shift => //.
  by rewrite (_ : _off + (offset{hr} - _off) = offset{hr}) 1:/#.
have Hs := asx4_step_bcast _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ Hinv (Sh _ _ _ _ _ _ R); first smt().
move: Hs; rewrite L0 T0 /= => Hs.
have Hpre : asubread_pre 0 _at _off 0 _len _tb by rewrite /asubread_pre; smt().
have [#] Est Eat' Edl := asx4_final _ _ _ _ _ _ _ _ _ _ _ _ _ Hpre Hs.
by rewrite Ew Eat st4x_set256 1:/# /= -Est Eat'; smt().
qed.

phoare addstate_bcast_avx2x4_ph _st _buf _off _len _tb _at:
 [ MM.__addstate_bcast_avx2x4
 : st=_st /\ buf=_buf
 /\ offset=_off /\ _LEN=_len /\ _TRAILB=_tb /\ aT=_at
 /\ 0 <= _at <= _at+_len <= 200 - b2i (_tb<>0)
 /\ 0 <= _off /\ _off + _len <= _ASIZE /\ 0 <= _tb < 256
 ==> res.`1 = addstate_avx2x4 _st (nseq _at W8.zero ++ sub _buf _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf _off _len ++ [W8.of_int _tb])
                                  (nseq _at W8.zero ++ sub _buf _off _len ++ [W8.of_int _tb])
  /\ res.`2 = _at + _len + b2i (_tb<>0)
  /\ res.`3 = _off + _len
 ] = 1%r.
proof. by conseq addstate_bcast_avx2x4_ll (addstate_bcast_avx2x4_h _st _buf _off _len _tb _at). qed.

lemma absorb_bcast_avx2x4_ll: islossless MM.__absorb_bcast_avx2x4.
proof.
proc.
seq 4: true => //.
 call addstate_bcast_avx2x4_ll.
 sp; if => //.
 wp; while true (iTERS-i).
  move => z.
  wp; call keccakf1600_avx2x4_ll.
  wp; call addstate_bcast_avx2x4_ll.
  by auto => /#.
 wp; call keccakf1600_avx2x4_ll.
 wp; call addstate_bcast_avx2x4_ll.
 by auto => /#.
if => //.
by call addratebit_avx2x4_ll.
qed.

lemma st4x_map_pack f (sts: state*state*state*state):
 st4x_map f (st4x_pack sts) = st4x_pack (f sts.`1, f sts.`2, f sts.`3, f sts.`4).
proof. by rewrite st4x_mapE st4x_get_pack0 st4x_get_pack1 st4x_get_pack2 st4x_get_pack3. qed.

lemma addstate_avx2x4_pack (sts: state*state*state*state) l0 l1 l2 l3:
 addstate_avx2x4 (st4x_pack sts) l0 l1 l2 l3
 = st4x_pack ( addstate sts.`1 (bytes2state l0), addstate sts.`2 (bytes2state l1)
             , addstate sts.`3 (bytes2state l2), addstate sts.`4 (bytes2state l3)).
proof. by rewrite /addstate_avx2x4 st4x_get_pack0 st4x_get_pack1 st4x_get_pack2 st4x_get_pack3. qed.

abbrev st_pabsorb (r8: int) (l: W8.t list) =
 addstate (stateabsorb_iblocks (BitEncoding.BitChunking.chunk r8 l) st0) (bytes2state (chunkremains r8 l)).

lemma st_pabsorb_block r8 (l s: W8.t list):
 0 < r8 =>
 size l %% r8 + size s = r8 =>
 keccak_f1600_op (addstate (st_pabsorb r8 l) (bytes2state (u8zeros (size l %% r8) ++ s ++ [W8.of_int 0])))
 = st_pabsorb r8 (l ++ s).
proof.
move=> Hr Hs; have Hd : r8 %| size (l ++ s) by rewrite size_cat dvdzP; exists (size l %/ r8 + 1); smt(divz_eq).
rewrite (chunkremains_nil _ _ Hr Hd) bytes2state0 (addstateC _ st0) addstate_st0 chunk_cat' 1:// (chunk_size _ (chunkremains r8 l ++ s)) 1://.
+ by rewrite size_cat size_chunkremains.
rewrite (cats1 (BitEncoding.BitChunking.chunk r8 l)) stateabsorb_iblocks_rcons /stateabsorb -addstateA; congr; congr.
by rewrite -(nseq1 W8.zero) bytes2state_zext eq_sym bytes2state_cat size_chunkremains.
qed.

lemma st_pabsorb_last_tb r8 l (buf: W8.t A.t) tb:
 0 < r8 =>
 ABSORB1600 (W8.of_int tb) r8 (l ++ to_list buf)
 = addratebit r8 (addstate (st_pabsorb r8 (l ++ sub buf 0 ((size l %% r8 + _ASIZE) %/ r8 * r8 - size l %% r8)))
                           (bytes2state (u8zeros (if r8 <= size l %% r8 + _ASIZE then 0 else size l %% r8)
                                         ++ sub buf (_ASIZE - (if r8 <= size l %% r8 + _ASIZE then (size l %% r8 + _ASIZE) %% r8 else _ASIZE))
                                                    (if r8 <= size l %% r8 + _ASIZE then (size l %% r8 + _ASIZE) %% r8 else _ASIZE)
                                         ++ [W8.of_int tb]))).
proof.
move=> Hr; rewrite /ABSORB1600 /stateabsorb_last /stateabsorb -cats1; congr; rewrite -addstateA; congr; first by congr; rewrite chunk_cat_buf.
by rewrite chunkremains_cat_buf.
qed.

lemma st_pabsorb_last0 r8 l (buf: W8.t A.t):
 0 < r8 =>
 st_pabsorb r8 (l ++ to_list buf)
 = addstate (st_pabsorb r8 (l ++ sub buf 0 ((size l %% r8 + _ASIZE) %/ r8 * r8 - size l %% r8)))
            (bytes2state (u8zeros (if r8 <= size l %% r8 + _ASIZE then 0 else size l %% r8)
                          ++ sub buf (_ASIZE - (if r8 <= size l %% r8 + _ASIZE then (size l %% r8 + _ASIZE) %% r8 else _ASIZE))
                                     (if r8 <= size l %% r8 + _ASIZE then (size l %% r8 + _ASIZE) %% r8 else _ASIZE)
                          ++ [W8.of_int 0])).
proof.
move=> Hr; rewrite -addstateA; congr; first by rewrite chunk_cat_buf.
by rewrite -chunkremains_cat_buf 1:// -(nseq1 W8.zero) bytes2state_zext.
qed.

lemma st_pabsorb_step r8 l (buf: W8.t A.t) off:
 0 < r8 => 0 <= off => off + r8 <= _ASIZE => (size l + off) %% r8 = 0 =>
 keccak_f1600_op (addstate (st_pabsorb r8 (l ++ sub buf 0 off)) (bytes2state (nseq 0 W8.zero ++ sub buf off r8 ++ [W8.of_int 0])))
 = st_pabsorb r8 (l ++ sub buf 0 (off + r8)).
proof.
move=> Hr Ho0 Ho1 Hm; have Hz : size (l ++ sub buf 0 off) %% r8 = 0 by rewrite size_cat size_sub /#.
have := st_pabsorb_block r8 (l ++ sub buf 0 off) (sub buf off r8) Hr _; first by rewrite Hz size_sub /#.
by rewrite Hz (sub_split off buf 0 (off + r8)) 1:/# /= (_ : off + r8 - off = r8) 1:/# catA.
qed.

lemma st_pabsorb_first r8 l (buf: W8.t A.t):
 0 < r8 => r8 <= size l %% r8 + _ASIZE =>
 keccak_f1600_op (addstate (st_pabsorb r8 l) (bytes2state (nseq (size l %% r8) W8.zero ++ sub buf 0 (r8 - size l %% r8) ++ [W8.of_int 0])))
 = st_pabsorb r8 (l ++ sub buf 0 (r8 - size l %% r8)).
proof. by move=> Hr Hle; apply st_pabsorb_block => //; rewrite size_sub /#. qed.

hoare absorb_bcast_avx2x4_h _l0 _l1 _l2 _l3 _st _buf _tb _r8:
 MM.__absorb_bcast_avx2x4
 : st=_st /\ buf=_buf /\ _RATE8 = _r8 /\ _TRAILB=_tb
 /\ aT = size _l0 %% _r8 /\ size _l1 = size _l0 /\ size _l2 = size _l0 /\ size _l3 = size _l0
 /\ pabsorb_spec_avx2x4 _r8 _l0 _l1 _l2 _l3 _st
 /\ 0 <= _tb < 256
 ==> if _tb <> 0
     then absorb_spec_avx2x4 _r8 _tb
            (_l0 ++ to_list _buf)
            (_l1 ++ to_list _buf)
            (_l2 ++ to_list _buf)
            (_l3 ++ to_list _buf)
            res.`1
     else pabsorb_spec_avx2x4 _r8
            (_l0 ++ to_list _buf)
            (_l1 ++ to_list _buf)
            (_l2 ++ to_list _buf)
            (_l3 ++ to_list _buf)
            res.`1
           /\ res.`2 = (size _l0 + _ASIZE) %% _r8.
proof.
proc => /=; have ?:= _ASIZE_u64; have ?:= _ASIZE_ge0.
pose _at := size _l0 %% _r8.
pose niters := (_at + _ASIZE) %/ _r8.
pose lastlen := if _r8 <= _at + _ASIZE then (_at + _ASIZE) %% _r8 else _ASIZE.
pose lastpos := niters * _r8 - _at.
seq 3: (buf=_buf /\ _RATE8=_r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256
        /\ size _l1 = size _l0 /\ size _l2 = size _l0 /\ size _l3 = size _l0
        /\ pabsorb_spec_avx2x4 _r8 (_l0 ++ sub _buf 0 lastpos) (_l1 ++ sub _buf 0 lastpos) (_l2 ++ sub _buf 0 lastpos) (_l3 ++ sub _buf 0 lastpos) st
        /\ offset = _ASIZE - lastlen /\ _LEN = lastlen
        /\ aT = if _RATE8 <= _at + _ASIZE then 0 else _at).
+ sp; if => //; last first.
  + auto => |> *; rewrite !sub0' ?cats0; first by rewrite /lastpos /niters divz_small 1:/# /= /#.
    smt().
  wp; while (buf=_buf /\ _RATE8 = _r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256
             /\ size _l1 = size _l0 /\ size _l2 = size _l0 /\ size _l3 = size _l0
             /\ iTERS = (size _l0 %% _r8 + _ASIZE) %/ _r8 - 1
             /\ offset = (i+1)*_r8 - size _l0 %% _r8
             /\ 0 <= i <= iTERS
             /\ pabsorb_spec_avx2x4 _r8 (_l0 ++ sub _buf 0 ((i+1)*_r8 - size _l0 %% _r8)) (_l1 ++ sub _buf 0 ((i+1)*_r8 - size _l0 %% _r8))
                                       (_l2 ++ sub _buf 0 ((i+1)*_r8 - size _l0 %% _r8)) (_l3 ++ sub _buf 0 ((i+1)*_r8 - size _l0 %% _r8)) st).
  + wp; ecall (keccakf1600_avx2x4_h st); ecall (addstate_bcast_avx2x4_h st buf offset _RATE8 0 0).
    skip => &hr [#] -> -> -> Htb0 Htb1 Hs1 Hs2 Hs3 Hit Hoff Hi0 Hi1 Hp Hc.
    move: Hp; rewrite /pabsorb_spec_avx2x4 /st4x_match => [#] Hr0 Hr1 _ _ _ Est; have Hb : (i{hr}+2)*_r8 <= size _l0 %% _r8 + _ASIZE.
    + have Hb': i{hr}+2 <= (size _l0 %% _r8 + _ASIZE) %/ _r8 by smt().
      apply (StdOrder.IntOrder.ler_trans ((size _l0 %% _r8 + _ASIZE) %/ _r8 * _r8)); [by apply StdOrder.IntOrder.ler_wpmul2r; smt() | by apply lez_floor; smt()].
    split; first smt().
    move=> _ [st1 a1 o1] /= [#] Est1 Ha1 Eo1 st2 ->.
    rewrite Est1 Est addstate_avx2x4_pack st4x_map_pack /=; have -> : (i{hr} + 2) * _r8 - size _l0 %% _r8 = ((i{hr} + 1) * _r8 - size _l0 %% _r8) + _r8 by ring.
    have Hat := modz_cmp (size _l0) _r8 Hr0.
    have Hir : 0 <= i{hr} * _r8 by apply StdOrder.IntOrder.mulr_ge0; [exact Hi0 | exact (StdOrder.IntOrder.ltrW _ _ Hr0)].
    have Ho0 : 0 <= (i{hr} + 1) * _r8 - size _l0 %% _r8 by rewrite mulzDl /=; smt().
    have Ho1 : (i{hr} + 1) * _r8 - size _l0 %% _r8 + _r8 <= _ASIZE by move: Hb; rewrite !mulzDl /=; smt().
    have Em : size _l0 + ((i{hr} + 1) * _r8 - size _l0 %% _r8) = (size _l0 %/ _r8 + i{hr} + 1) * _r8 by rewrite {1}(divz_eq (size _l0) _r8); ring.
    have Hm0 : (size _l0 + ((i{hr} + 1) * _r8 - size _l0 %% _r8)) %% _r8 = 0 by rewrite Em modzMl.
    rewrite Hoff !(st_pabsorb_step _ _ _ _ Hr0 Ho0 Ho1).
    + by rewrite Hm0.
    + by rewrite Hs1 Hm0.
    + by rewrite Hs2 Hm0.
    + by rewrite Hs3 Hm0.
    by rewrite Eo1 Hoff !size_cat Hs1 Hs2 Hs3 /=; smt().
  wp; ecall (keccakf1600_avx2x4_h st); wp; ecall (addstate_bcast_avx2x4_h st buf offset (_RATE8 - aT) 0 aT).
  skip => &hr [#] -> -> -> -> -> -> -> Hs1 Hs2 Hs3 Hp Htb0 Htb1 Hc.
  move: Hp; rewrite /pabsorb_spec_avx2x4 /st4x_match => [#] Hr0 Hr1 _ _ _ Est; have Hat := modz_cmp (size _l0) _r8 Hr0.
  split; first smt().
  move=> _ [st1 a1 o1] /= [#] Est1 Ha1 Eo1 st2 ->; rewrite Est1 Est addstate_avx2x4_pack st4x_map_pack /=.
  have := st_pabsorb_first _r8 _l1 _buf Hr0 _; first by rewrite Hs1.
  rewrite Hs1 => F1; have := st_pabsorb_first _r8 _l2 _buf Hr0 _; first by rewrite Hs2.
  rewrite Hs2 => F2; have := st_pabsorb_first _r8 _l3 _buf Hr0 _; first by rewrite Hs3.
  rewrite Hs3 => F3; rewrite (st_pabsorb_first _r8 _l0 _buf Hr0 Hc) F1 F2 F3 /=.
  have Ed : (_ASIZE - (_r8 - size _l0 %% _r8)) %/ _r8 = (size _l0 %% _r8 + _ASIZE) %/ _r8 - 1 by rewrite (_ : _ASIZE - (_r8 - size _l0 %% _r8) = size _l0 %% _r8 + _ASIZE + (-1)*_r8) 1:/# divzMDr /#.
  have Hn1 : 1 <= (size _l0 %% _r8 + _ASIZE) %/ _r8 by rewrite lez_divRL // /#.
  have Hlen : 0 <= _r8 - size _l0 %% _r8 by smt().
  rewrite Ed !size_cat !(A.size_sub _ _ _ Hlen) Hs1 Hs2 Hs3 /=; split; first smt().
  move=> i0 offset0 st0 Hc' [#] _ _ Eo Hi0 Hi1 _ _ _ _ _ Est0; have Ei : i0 = (size _l0 %% _r8 + _ASIZE) %/ _r8 - 1 by smt().
  have Elp : lastpos = (i0 + 1) * _r8 - size _l0 %% _r8 by rewrite /lastpos /niters /_at Ei.
  rewrite Elp -Est0 /=.
  have Ell : lastlen = (size _l0 %% _r8 + _ASIZE) %% _r8 by rewrite /lastlen /_at ifT.
  have Em2 : (_ASIZE - (_r8 - size _l0 %% _r8)) %% _r8 = (size _l0 %% _r8 + _ASIZE) %% _r8 by rewrite (_ : _ASIZE - (_r8 - size _l0 %% _r8) = size _l0 %% _r8 + _ASIZE + (-1)*_r8) 1:/# modzMDr.
  have Edq := divz_eq (size _l0 %% _r8 + _ASIZE) _r8.
  by rewrite Eo Ei Ell Em2 /= ifT 1:/#; smt().
case: (_TRAILB <> 0).
+ rcondt 2; first by call (:true ==> true) => //.
  ecall (addratebit_avx2x4_h _RATE8 st); ecall (addstate_bcast_avx2x4_h st buf offset _LEN _TRAILB aT).
  skip => &hr [#] -> -> -> Htb0 Htb1 Hs1 Hs2 Hs3 Hp -> -> -> Htb.
  move: Hp; rewrite /pabsorb_spec_avx2x4 /st4x_match => [#] Hr0 Hr1 _ _ _ Est; have Hat := modz_cmp (size _l0) _r8 Hr0; have Hll := modz_cmp (size _l0 %% _r8 + _ASIZE) _r8 Hr0.
  have Hlb : 0 <= lastlen /\ (if _r8 <= _at + _ASIZE then 0 else _at) + lastlen + 1 <= 200 /\ lastlen <= _ASIZE.
  + rewrite /lastlen /_at; case: (_r8 <= size _l0 %% _r8 + _ASIZE) => C /=.
    + have Hq2 : 1 * _r8 <= (size _l0 %% _r8 + _ASIZE) %/ _r8 * _r8 by rewrite StdOrder.IntOrder.ler_pmul2r // lez_divRL // /#.
      by have := divz_eq (size _l0 %% _r8 + _ASIZE) _r8; smt().
    smt().
  split; first by rewrite /= Htb /=; smt().
  move=> _ [st1 a1 o1] /= [#] Est1 Ha1 Eo1.
  split => [| _ st2 ->]; first smt().
  rewrite Htb /= /absorb_spec_avx2x4 /st4x_match Est1 Est addstate_avx2x4_pack st4x_map_pack /=.
  by rewrite (st_pabsorb_last_tb _r8 _l0 _buf _tb Hr0) (st_pabsorb_last_tb _r8 _l1 _buf _tb Hr0) (st_pabsorb_last_tb _r8 _l2 _buf _tb Hr0) (st_pabsorb_last_tb _r8 _l3 _buf _tb Hr0) Hs1 Hs2 Hs3 /lastpos /niters /lastlen /_at.
rcondf 2; first by call (:true ==> true) => //.
ecall (addstate_bcast_avx2x4_h st buf offset _LEN _TRAILB aT).
skip => &hr [#] -> -> -> Htb0 Htb1 Hs1 Hs2 Hs3 Hp -> -> -> Htb.
move: Hp; rewrite /pabsorb_spec_avx2x4 /st4x_match => [#] Hr0 Hr1 _ _ _ Est; have Hat := modz_cmp (size _l0) _r8 Hr0; have Hll := modz_cmp (size _l0 %% _r8 + _ASIZE) _r8 Hr0; have Etb : _tb = 0 by smt().
have Hlb : 0 <= lastlen /\ (if _r8 <= _at + _ASIZE then 0 else _at) + lastlen + 1 <= 200 /\ lastlen <= _ASIZE.
+ rewrite /lastlen /_at; case: (_r8 <= size _l0 %% _r8 + _ASIZE) => C /=.
  + have Hq2 : 1 * _r8 <= (size _l0 %% _r8 + _ASIZE) %/ _r8 * _r8 by rewrite StdOrder.IntOrder.ler_pmul2r // lez_divRL // /#.
    by have := divz_eq (size _l0 %% _r8 + _ASIZE) _r8; smt().
  smt().
split; first by rewrite /= Etb /=; smt().
move=> _ [st1 a1 o1] /= [#] Est1 Ha1 Eo1; rewrite Etb /= /st4x_match Est1 Est addstate_avx2x4_pack /=.
rewrite Etb (st_pabsorb_last0 _r8 _l0 _buf Hr0) (st_pabsorb_last0 _r8 _l1 _buf Hr0) (st_pabsorb_last0 _r8 _l2 _buf Hr0) (st_pabsorb_last0 _r8 _l3 _buf Hr0) Hs1 Hs2 Hs3 !size_cat !A.size_to_list Hs1 Hs2 Hs3 /lastpos /niters /lastlen /_at /=.
split; first smt().
by rewrite Ha1 Etb /lastlen /_at /=; case: (_r8 <= size _l0 %% _r8 + _ASIZE) => C /=; [by rewrite modzDml | by rewrite eq_sym -modzDml modz_small /#].
qed.

phoare absorb_bcast_avx2x4_ph _l0 _l1 _l2 _l3 _st _buf _tb _r8:
 [ MM.__absorb_bcast_avx2x4
 : st=_st /\ buf=_buf /\ _RATE8 = _r8 /\ _TRAILB=_tb
 /\ aT = size _l0 %% _r8 /\ size _l1 = size _l0 /\ size _l2 = size _l0 /\ size _l3 = size _l0
 /\ pabsorb_spec_avx2x4 _r8 _l0 _l1 _l2 _l3 _st
 /\ 0 <= _tb < 256
 ==> if _tb <> 0
     then absorb_spec_avx2x4 _r8 _tb
            (_l0 ++ to_list _buf)
            (_l1 ++ to_list _buf)
            (_l2 ++ to_list _buf)
            (_l3 ++ to_list _buf)
            res.`1
     else pabsorb_spec_avx2x4 _r8
            (_l0 ++ to_list _buf)
            (_l1 ++ to_list _buf)
            (_l2 ++ to_list _buf)
            (_l3 ++ to_list _buf)
            res.`1
           /\ res.`2 = (size _l0 + _ASIZE) %% _r8
  ] = 1%r.
proof.
by conseq absorb_bcast_avx2x4_ll (absorb_bcast_avx2x4_h _l0 _l1 _l2 _l3 _st _buf _tb _r8).
qed.

lemma absorb_avx2x4_ll: islossless MM.__absorb_avx2x4.
proof.
proc.
seq 4: true => //.
 call addstate_avx2x4_ll.
 sp; if => //.
 wp; while true (iTERS-i).
  move => z.
  wp; call keccakf1600_avx2x4_ll.
  call addstate_avx2x4_ll.
  by auto => /#.
 wp; call keccakf1600_avx2x4_ll.
 by wp; call addstate_avx2x4_ll; auto => /#.
if => //.
by call addratebit_avx2x4_ll.
qed.

hoare absorb_avx2x4_h _l0 _l1 _l2 _l3 _st _buf0 _buf1 _buf2 _buf3 _tb _r8:
 MM.__absorb_avx2x4
 : st=_st /\ buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3 /\
 _RATE8 = _r8 /\ _TRAILB=_tb
 /\ aT = size _l0 %% _r8 /\ size _l1 = size _l0 /\ size _l2 = size _l0 /\ size _l3 = size _l0
 /\ pabsorb_spec_avx2x4 _r8 _l0 _l1 _l2 _l3 _st
 /\ 0 <= _tb < 256
 ==> if _tb <> 0
     then absorb_spec_avx2x4 _r8 _tb
            (_l0 ++ to_list _buf0)
            (_l1 ++ to_list _buf1)
            (_l2 ++ to_list _buf2)
            (_l3 ++ to_list _buf3)
            res.`1
     else pabsorb_spec_avx2x4 _r8
            (_l0 ++ to_list _buf0)
            (_l1 ++ to_list _buf1)
            (_l2 ++ to_list _buf2)
            (_l3 ++ to_list _buf3)
            res.`1
           /\ res.`2 = (size _l0 + _ASIZE) %% _r8.
proof.
proc => /=; have ?:= _ASIZE_u64; have ?:= _ASIZE_ge0.
pose _at := size _l0 %% _r8.
pose niters := (_at + _ASIZE) %/ _r8.
pose lastlen := if _r8 <= _at + _ASIZE then (_at + _ASIZE) %% _r8 else _ASIZE.
pose lastpos := niters * _r8 - _at.
seq 3: (buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3 /\ _RATE8=_r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256
        /\ size _l1 = size _l0 /\ size _l2 = size _l0 /\ size _l3 = size _l0
        /\ pabsorb_spec_avx2x4 _r8 (_l0 ++ sub _buf0 0 lastpos) (_l1 ++ sub _buf1 0 lastpos) (_l2 ++ sub _buf2 0 lastpos) (_l3 ++ sub _buf3 0 lastpos) st
        /\ offset = _ASIZE - lastlen /\ _LEN = lastlen
        /\ aT = if _RATE8 <= _at + _ASIZE then 0 else _at).
+ sp; if => //; last first.
  + auto => |> *; rewrite !sub0' ?cats0; 1..4: by rewrite /lastpos /niters divz_small 1:/# /= /#.
    smt().
  wp; while (buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3 /\ _RATE8 = _r8 /\ _TRAILB = _tb /\ 0 <= _tb < 256
             /\ size _l1 = size _l0 /\ size _l2 = size _l0 /\ size _l3 = size _l0
             /\ iTERS = (size _l0 %% _r8 + _ASIZE) %/ _r8 - 1
             /\ offset = (i+1)*_r8 - size _l0 %% _r8
             /\ 0 <= i <= iTERS
             /\ pabsorb_spec_avx2x4 _r8 (_l0 ++ sub _buf0 0 ((i+1)*_r8 - size _l0 %% _r8)) (_l1 ++ sub _buf1 0 ((i+1)*_r8 - size _l0 %% _r8))
                                       (_l2 ++ sub _buf2 0 ((i+1)*_r8 - size _l0 %% _r8)) (_l3 ++ sub _buf3 0 ((i+1)*_r8 - size _l0 %% _r8)) st).
  + wp; ecall (keccakf1600_avx2x4_h st); ecall (addstate_avx2x4_h st buf0 buf1 buf2 buf3 offset _RATE8 0 0).
    skip => &hr [#] -> -> -> -> -> -> Htb0 Htb1 Hs1 Hs2 Hs3 Hit Hoff Hi0 Hi1 Hp Hc.
    move: Hp; rewrite /pabsorb_spec_avx2x4 /st4x_match => [#] Hr0 Hr1 _ _ _ Est; have Hb : (i{hr}+2)*_r8 <= size _l0 %% _r8 + _ASIZE.
    + have Hb': i{hr}+2 <= (size _l0 %% _r8 + _ASIZE) %/ _r8 by smt().
      apply (StdOrder.IntOrder.ler_trans ((size _l0 %% _r8 + _ASIZE) %/ _r8 * _r8)); [by apply StdOrder.IntOrder.ler_wpmul2r; smt() | by apply lez_floor; smt()].
    split; first smt().
    move=> _ [st1 a1 o1] /= [#] Est1 Ha1 Eo1 st2 ->.
    rewrite Est1 Est addstate_avx2x4_pack st4x_map_pack /=; have -> : (i{hr} + 2) * _r8 - size _l0 %% _r8 = ((i{hr} + 1) * _r8 - size _l0 %% _r8) + _r8 by ring.
    have Hat := modz_cmp (size _l0) _r8 Hr0.
    have Hir : 0 <= i{hr} * _r8 by apply StdOrder.IntOrder.mulr_ge0; [exact Hi0 | exact (StdOrder.IntOrder.ltrW _ _ Hr0)].
    have Ho0 : 0 <= (i{hr} + 1) * _r8 - size _l0 %% _r8 by rewrite mulzDl /=; smt().
    have Ho1 : (i{hr} + 1) * _r8 - size _l0 %% _r8 + _r8 <= _ASIZE by move: Hb; rewrite !mulzDl /=; smt().
    have Em : size _l0 + ((i{hr} + 1) * _r8 - size _l0 %% _r8) = (size _l0 %/ _r8 + i{hr} + 1) * _r8 by rewrite {1}(divz_eq (size _l0) _r8); ring.
    have Hm0 : (size _l0 + ((i{hr} + 1) * _r8 - size _l0 %% _r8)) %% _r8 = 0 by rewrite Em modzMl.
    rewrite Hoff !(st_pabsorb_step _ _ _ _ Hr0 Ho0 Ho1).
    + by rewrite Hm0.
    + by rewrite Hs1 Hm0.
    + by rewrite Hs2 Hm0.
    + by rewrite Hs3 Hm0.
    rewrite Eo1 Hoff !size_cat Hs1 Hs2 Hs3 /=.
    have Hl : 0 <= (i{hr} + 1) * _r8 - size _l0 %% _r8 + _r8 by smt().
    by rewrite !(A.size_sub _ _ _ Hl) /=; smt().
  wp; ecall (keccakf1600_avx2x4_h st); wp; ecall (addstate_avx2x4_h st buf0 buf1 buf2 buf3 offset (_RATE8 - aT) 0 aT).
  skip => &hr [#] -> -> -> -> -> -> -> -> -> -> Hs1 Hs2 Hs3 Hp Htb0 Htb1 Hc.
  move: Hp; rewrite /pabsorb_spec_avx2x4 /st4x_match => [#] Hr0 Hr1 _ _ _ Est; have Hat := modz_cmp (size _l0) _r8 Hr0.
  split; first smt().
  move=> _ [st1 a1 o1] /= [#] Est1 Ha1 Eo1 st2 ->; rewrite Est1 Est addstate_avx2x4_pack st4x_map_pack /=.
  have := st_pabsorb_first _r8 _l1 _buf1 Hr0 _; first by rewrite Hs1.
  rewrite Hs1 => F1; have := st_pabsorb_first _r8 _l2 _buf2 Hr0 _; first by rewrite Hs2.
  rewrite Hs2 => F2; have := st_pabsorb_first _r8 _l3 _buf3 Hr0 _; first by rewrite Hs3.
  rewrite Hs3 => F3; rewrite (st_pabsorb_first _r8 _l0 _buf0 Hr0 Hc) F1 F2 F3 /=.
  have Ed : (_ASIZE - (_r8 - size _l0 %% _r8)) %/ _r8 = (size _l0 %% _r8 + _ASIZE) %/ _r8 - 1 by rewrite (_ : _ASIZE - (_r8 - size _l0 %% _r8) = size _l0 %% _r8 + _ASIZE + (-1)*_r8) 1:/# divzMDr /#.
  have Hn1 : 1 <= (size _l0 %% _r8 + _ASIZE) %/ _r8 by rewrite lez_divRL // /#.
  have Hlen : 0 <= _r8 - size _l0 %% _r8 by smt().
  rewrite Ed !size_cat !(A.size_sub _ _ _ Hlen) Hs1 Hs2 Hs3 /=; split; first smt().
  move=> i0 offset0 st0 Hc' [#] _ _ Eo Hi0 Hi1 _ _ _ _ _ Est0; have Ei : i0 = (size _l0 %% _r8 + _ASIZE) %/ _r8 - 1 by smt().
  have Elp : lastpos = (i0 + 1) * _r8 - size _l0 %% _r8 by rewrite /lastpos /niters /_at Ei.
  have Hq : 1 * _r8 <= (size _l0 %% _r8 + _ASIZE) %/ _r8 * _r8 by rewrite StdOrder.IntOrder.ler_pmul2r.
  have Hlp : 0 <= (i0 + 1) * _r8 - size _l0 %% _r8 by rewrite Ei /=; smt().
  rewrite Elp -Est0 !(A.size_sub _ _ _ Hlp) /=.
  have Ell : lastlen = (size _l0 %% _r8 + _ASIZE) %% _r8 by rewrite /lastlen /_at ifT.
  have Em2 : (_ASIZE - (_r8 - size _l0 %% _r8)) %% _r8 = (size _l0 %% _r8 + _ASIZE) %% _r8 by rewrite (_ : _ASIZE - (_r8 - size _l0 %% _r8) = size _l0 %% _r8 + _ASIZE + (-1)*_r8) 1:/# modzMDr.
  have Edq := divz_eq (size _l0 %% _r8 + _ASIZE) _r8.
  by rewrite Eo Ei Ell Em2 /= ifT 1:/#; smt().
case: (_TRAILB <> 0).
+ rcondt 2; first by call (:true ==> true) => //.
  ecall (addratebit_avx2x4_h _RATE8 st); ecall (addstate_avx2x4_h st buf0 buf1 buf2 buf3 offset _LEN _TRAILB aT).
  skip => &hr [#] -> -> -> -> -> -> Htb0 Htb1 Hs1 Hs2 Hs3 Hp -> -> -> Htb.
  move: Hp; rewrite /pabsorb_spec_avx2x4 /st4x_match => [#] Hr0 Hr1 _ _ _ Est; have Hat := modz_cmp (size _l0) _r8 Hr0; have Hll := modz_cmp (size _l0 %% _r8 + _ASIZE) _r8 Hr0.
  have Hlb : 0 <= lastlen /\ (if _r8 <= _at + _ASIZE then 0 else _at) + lastlen + 1 <= 200 /\ lastlen <= _ASIZE.
  + rewrite /lastlen /_at; case: (_r8 <= size _l0 %% _r8 + _ASIZE) => C /=.
    + have Hq2 : 1 * _r8 <= (size _l0 %% _r8 + _ASIZE) %/ _r8 * _r8 by rewrite StdOrder.IntOrder.ler_pmul2r // lez_divRL // /#.
      by have := divz_eq (size _l0 %% _r8 + _ASIZE) _r8; smt().
    smt().
  split; first by rewrite /= Htb /=; smt().
  move=> _ [st1 a1 o1] /= [#] Est1 Ha1 Eo1.
  split => [| _ st2 ->]; first smt().
  rewrite Htb /= /absorb_spec_avx2x4 /st4x_match Est1 Est addstate_avx2x4_pack st4x_map_pack /=.
  by rewrite (st_pabsorb_last_tb _r8 _l0 _buf0 _tb Hr0) (st_pabsorb_last_tb _r8 _l1 _buf1 _tb Hr0) (st_pabsorb_last_tb _r8 _l2 _buf2 _tb Hr0) (st_pabsorb_last_tb _r8 _l3 _buf3 _tb Hr0) Hs1 Hs2 Hs3 /lastpos /niters /lastlen /_at.
rcondf 2; first by call (:true ==> true) => //.
ecall (addstate_avx2x4_h st buf0 buf1 buf2 buf3 offset _LEN _TRAILB aT).
skip => &hr [#] -> -> -> -> -> -> Htb0 Htb1 Hs1 Hs2 Hs3 Hp -> -> -> Htb.
move: Hp; rewrite /pabsorb_spec_avx2x4 /st4x_match => [#] Hr0 Hr1 _ _ _ Est; have Hat := modz_cmp (size _l0) _r8 Hr0; have Hll := modz_cmp (size _l0 %% _r8 + _ASIZE) _r8 Hr0; have Etb : _tb = 0 by smt().
have Hlb : 0 <= lastlen /\ (if _r8 <= _at + _ASIZE then 0 else _at) + lastlen + 1 <= 200 /\ lastlen <= _ASIZE.
+ rewrite /lastlen /_at; case: (_r8 <= size _l0 %% _r8 + _ASIZE) => C /=.
  + have Hq2 : 1 * _r8 <= (size _l0 %% _r8 + _ASIZE) %/ _r8 * _r8 by rewrite StdOrder.IntOrder.ler_pmul2r // lez_divRL // /#.
    by have := divz_eq (size _l0 %% _r8 + _ASIZE) _r8; smt().
  smt().
split; first by rewrite /= Etb /=; smt().
move=> _ [st1 a1 o1] /= [#] Est1 Ha1 Eo1; rewrite Etb /= /st4x_match Est1 Est addstate_avx2x4_pack /=.
rewrite Etb (st_pabsorb_last0 _r8 _l0 _buf0 Hr0) (st_pabsorb_last0 _r8 _l1 _buf1 Hr0) (st_pabsorb_last0 _r8 _l2 _buf2 Hr0) (st_pabsorb_last0 _r8 _l3 _buf3 Hr0) Hs1 Hs2 Hs3 !size_cat !A.size_to_list Hs1 Hs2 Hs3 /lastpos /niters /lastlen /_at /=.
split; first smt().
by rewrite Ha1 Etb /lastlen /_at /=; case: (_r8 <= size _l0 %% _r8 + _ASIZE) => C /=; [by rewrite modzDml | by rewrite eq_sym -modzDml modz_small /#].
qed.

phoare absorb_avx2x4_ph _l0 _l1 _l2 _l3 _st _buf0 _buf1 _buf2 _buf3 _tb _r8:
 [ MM.__absorb_avx2x4
 : st=_st /\ buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3 /\
 _RATE8 = _r8 /\ _TRAILB=_tb
 /\ aT = size _l0 %% _r8 /\ size _l1 = size _l0 /\ size _l2 = size _l0 /\ size _l3 = size _l0
 /\ pabsorb_spec_avx2x4 _r8 _l0 _l1 _l2 _l3 _st
 /\ 0 <= _tb < 256
 ==> if _tb <> 0
     then absorb_spec_avx2x4 _r8 _tb
            (_l0 ++ to_list _buf0)
            (_l1 ++ to_list _buf1)
            (_l2 ++ to_list _buf2)
            (_l3 ++ to_list _buf3)
            res.`1
     else pabsorb_spec_avx2x4 _r8
            (_l0 ++ to_list _buf0)
            (_l1 ++ to_list _buf1)
            (_l2 ++ to_list _buf2)
            (_l3 ++ to_list _buf3)
            res.`1
           /\ res.`2 = (size _l0 + _ASIZE) %% _r8
  ] = 1%r.
proof.
by conseq absorb_avx2x4_ll (absorb_avx2x4_h _l0 _l1 _l2 _l3 _st _buf0 _buf1 _buf2 _buf3 _tb _r8).
qed.

(*
   ONE-SHOT (FIXED-SIZE) MEMORY SQUEEZE
   ====================================
*)

lemma dumpstate_avx2x4_ll: islossless MM.__dumpstate_avx2x4.
proof.
proc.
seq 3: true => //.
 while true (8 * (_LEN %/ 8)-i).
  by move=> z; auto => /#.
 while true (32 * (_LEN %/ 32)-i).
  by move=> z; inline*; auto => /#.
 by auto => /#.
if => //.
wp; call a_ilen_write_upto8_ll.
wp; call a_ilen_write_upto8_ll.
wp; call a_ilen_write_upto8_ll.
wp; call a_ilen_write_upto8_ll.
by auto => /#.
qed.

lemma u4x64_transpose_bits (y0 y1 y2 y3: W256.t):
 let x0 = VPERM2I128 y0 y2 (W8.of_int 32) in
 let x1 = VPERM2I128 y1 y3 (W8.of_int 32) in
 let x2 = VPERM2I128 y0 y2 (W8.of_int 49) in
 let x3 = VPERM2I128 y1 y3 (W8.of_int 49) in
    (VPUNPCKL_4u64 x0 x1 \bits64 0 = y0 \bits64 0 /\ VPUNPCKL_4u64 x0 x1 \bits64 1 = y1 \bits64 0
  /\ VPUNPCKL_4u64 x0 x1 \bits64 2 = y2 \bits64 0 /\ VPUNPCKL_4u64 x0 x1 \bits64 3 = y3 \bits64 0)
 /\ (VPUNPCKH_4u64 x0 x1 \bits64 0 = y0 \bits64 1 /\ VPUNPCKH_4u64 x0 x1 \bits64 1 = y1 \bits64 1
  /\ VPUNPCKH_4u64 x0 x1 \bits64 2 = y2 \bits64 1 /\ VPUNPCKH_4u64 x0 x1 \bits64 3 = y3 \bits64 1)
 /\ (VPUNPCKL_4u64 x2 x3 \bits64 0 = y0 \bits64 2 /\ VPUNPCKL_4u64 x2 x3 \bits64 1 = y1 \bits64 2
  /\ VPUNPCKL_4u64 x2 x3 \bits64 2 = y2 \bits64 2 /\ VPUNPCKL_4u64 x2 x3 \bits64 3 = y3 \bits64 2)
 /\ (VPUNPCKH_4u64 x2 x3 \bits64 0 = y0 \bits64 3 /\ VPUNPCKH_4u64 x2 x3 \bits64 1 = y1 \bits64 3
  /\ VPUNPCKH_4u64 x2 x3 \bits64 2 = y2 \bits64 3 /\ VPUNPCKH_4u64 x2 x3 \bits64 3 = y3 \bits64 3).
proof. by move=> /=; circuit. qed.

hoare u4x64_transpose_spec (ys: int -> W256.t):
 M.__4u64x4_u256x4
 : y0 = ys 0 /\ y1 = ys 1 /\ y2 = ys 2 /\ y3 = ys 3
 ==> forall q, 0 <= q < 4 =>
     res.`1 \bits64 q = ys q \bits64 0 /\ res.`2 \bits64 q = ys q \bits64 1
     /\ res.`3 \bits64 q = ys q \bits64 2 /\ res.`4 \bits64 q = ys q \bits64 3.
proof.
proc; auto => /> q Hq0 Hq1; have /= H := u4x64_transpose_bits (ys 0) (ys 1) (ys 2) (ys 3).
have : q = 0 \/ q = 1 \/ q = 2 \/ q = 3 by smt().
by case => [->|[->|[->|->]]] /=; move: H => [#] *; do !split.
qed.

lemma st4x_get256_direct (st: state4x) m:
 0 <= m < 25 =>
 WArray800.get256_direct (WArray800.init256 (fun i => st.[i])) (32*m) = st.[m].
proof.
move=> Hm; apply W256.wordP => b Hb; rewrite /WArray800.get256_direct pack32E initiE 1:/# /= initiE 1:/# /=.
by rewrite /WArray800.init256 WArray800.initiE 1:/# /= bits8iE 1:/#; congr; smt().
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

lemma dump_step256 (st: state4x) l (x: W256.t) (buf: W8.t A.t) off i:
 0 <= l < 4 => 0 <= i => i %% 8 = 0 => i + 32 <= 200 =>
 (forall q, 0 <= q < 4 => x \bits64 q = st.[i %/ 8 + q] \bits64 l) =>
 A.fill (fun j => x \bits8 (j - (off + i))) (off + i) 32
        (A.fill (fun j => (stbytes (st4x_get st l)).[j - off]) off i buf)
 = A.fill (fun j => (stbytes (st4x_get st l)).[j - off]) off (i + 32) buf.
proof.
move=> Hl Hi Hi8 Hb Hx; apply fill_step => // j Hj /=.
have [r [-> Hr]] : exists r, j = off + i + r /\ 0 <= r < 32 by exists (j - off - i); smt().
rewrite (: off + i + r - (off + i) = r) 1:/# (: off + i + r - off = i + r) 1:/# stbytes_st4x // 1:/# bits8_256_bits64 // Hx 1:/#.
by rewrite (divzDl i r 8) 1:/# -modzDml Hi8.
qed.

lemma dump_step64 (st: state4x) l (t: W64.t) (buf: W8.t A.t) off i n:
 0 <= l < 4 => 0 <= i => i %% 8 = 0 => 0 <= n <= 8 => i + n <= 200 =>
 t = st.[i %/ 8] \bits64 l =>
 A.fill (fun j => t \bits8 (j - (off + i))) (off + i) n
        (A.fill (fun j => (stbytes (st4x_get st l)).[j - off]) off i buf)
 = A.fill (fun j => (stbytes (st4x_get st l)).[j - off]) off (i + n) buf.
proof.
move=> Hl Hi Hi8 Hn Hb ->; apply fill_step => // [/#|j Hj /=].
have [r [-> Hr]] : exists r, j = off + i + r /\ 0 <= r < n by exists (j - off - i); smt().
rewrite (: off + i + r - (off + i) = r) 1:/# (: off + i + r - off = i + r) 1:/# stbytes_st4x // 1:/#.
by rewrite (divzDl i r 8) 1:/# -modzDml Hi8 /= (divz_small r 8) 1:/# (modz_small r 8) 1:/#.
qed.

hoare dumpstate_avx2x4_h _buf0 _buf1 _buf2 _buf3 _off _len _st:
 MM.__dumpstate_avx2x4
 : buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3 /\ offset=_off /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _off + _len <= _ASIZE
 ==> res.`1 = A.fill (fun i=> (stbytes (st4x_get _st 0)).[i-_off]) _off _len _buf0
  /\ res.`2 = A.fill (fun i=> (stbytes (st4x_get _st 1)).[i-_off]) _off _len _buf1
  /\ res.`3 = A.fill (fun i=> (stbytes (st4x_get _st 2)).[i-_off]) _off _len _buf2
  /\ res.`4 = A.fill (fun i=> (stbytes (st4x_get _st 3)).[i-_off]) _off _len _buf3
  /\ res.`5 = _off + _len.
proof.
proc; seq 2 : (buf0 = A.fill (fun j => (stbytes (st4x_get _st 0)).[j-_off]) _off i _buf0
               /\ buf1 = A.fill (fun j => (stbytes (st4x_get _st 1)).[j-_off]) _off i _buf1
               /\ buf2 = A.fill (fun j => (stbytes (st4x_get _st 2)).[j-_off]) _off i _buf2
               /\ buf3 = A.fill (fun j => (stbytes (st4x_get _st 3)).[j-_off]) _off i _buf3
               /\ offset = _off + i /\ st = _st /\ _LEN = _len /\ 0 <= _len <= 200 /\ _off + _len <= _ASIZE
               /\ i = 32 * (_len %/ 32)).
+ while (buf0 = A.fill (fun j => (stbytes (st4x_get _st 0)).[j-_off]) _off i _buf0
         /\ buf1 = A.fill (fun j => (stbytes (st4x_get _st 1)).[j-_off]) _off i _buf1
         /\ buf2 = A.fill (fun j => (stbytes (st4x_get _st 2)).[j-_off]) _off i _buf2
         /\ buf3 = A.fill (fun j => (stbytes (st4x_get _st 3)).[j-_off]) _off i _buf3
         /\ offset = _off + i /\ st = _st /\ _LEN = _len /\ 0 <= _len <= 200 /\ _off + _len <= _ASIZE
         /\ 0 <= i <= 32 * (_len %/ 32) /\ i %% 32 = 0).
  + wp; ecall (u4x64_transpose_spec (fun q => st.[(i - 32) %/ 8 + q])); wp.
    skip => &hr [#] -> -> -> -> -> -> -> H0 H1 Hoff Hi0 Hi1 Hi32 Hc /=.
    have G : forall k, 0 <= k < 4 => WArray800.get256_direct (WArray800.init256 ("_.[_]" _st)) (4 * i{hr} + 32 * k) = _st.[i{hr} %/ 8 + k].
    + by move=> k Hk; have /= <- := st4x_get256_direct _st (i{hr} %/ 8 + k) _; [smt() | congr; smt()].
    split; first by move: (G 0 _) (G 1 _) (G 2 _) (G 3 _) => //= -> -> -> ->.
    move=> _ r Hr; have Hi8 : i{hr} %% 8 = 0 by smt().
    have L : forall l (b: W8.t A.t) (x: W256.t), 0 <= l < 4 =>
             (forall q, 0 <= q < 4 => x \bits64 q = _st.[i{hr} %/ 8 + q] \bits64 l) =>
             A.init (WA.get8 (WA.set256_direct (WA.init8 ("_.[_]" (A.fill (fun j => (stbytes (st4x_get _st l)).[j - _off]) _off i{hr} b))) (_off + i{hr}) x))
             = A.fill (fun j => (stbytes (st4x_get _st l)).[j - _off]) _off (i{hr} + 32) b.
    + move=> l b x Hl Hx; have /= -> := a_set256_fill (A.fill (fun j => (stbytes (st4x_get _st l)).[j - _off]) _off i{hr} b) (_off + i{hr}) x.
      by apply dump_step256 => //; smt().
    by rewrite (L 0) // 1:/# (L 1) // 1:/# (L 2) // 1:/# (L 3) // 1:/#; smt().
  auto => /> H0 H1 Hoff; have F0 : forall (f: int -> W8.t) (b: W8.t A.t), A.fill f _off 0 b = b.
  + by move=> f b; rewrite A.fillE; apply A.tP => j Hj; rewrite A.initiE //= /#.
  by rewrite !F0 /=; smt().
seq 1 : (buf0 = A.fill (fun j => (stbytes (st4x_get _st 0)).[j-_off]) _off i _buf0
         /\ buf1 = A.fill (fun j => (stbytes (st4x_get _st 1)).[j-_off]) _off i _buf1
         /\ buf2 = A.fill (fun j => (stbytes (st4x_get _st 2)).[j-_off]) _off i _buf2
         /\ buf3 = A.fill (fun j => (stbytes (st4x_get _st 3)).[j-_off]) _off i _buf3
         /\ offset = _off + i /\ st = _st /\ _LEN = _len /\ 0 <= _len <= 200 /\ _off + _len <= _ASIZE
         /\ i = 8 * (_len %/ 8)).
+ while (buf0 = A.fill (fun j => (stbytes (st4x_get _st 0)).[j-_off]) _off i _buf0
         /\ buf1 = A.fill (fun j => (stbytes (st4x_get _st 1)).[j-_off]) _off i _buf1
         /\ buf2 = A.fill (fun j => (stbytes (st4x_get _st 2)).[j-_off]) _off i _buf2
         /\ buf3 = A.fill (fun j => (stbytes (st4x_get _st 3)).[j-_off]) _off i _buf3
         /\ offset = _off + i /\ st = _st /\ _LEN = _len /\ 0 <= _len <= 200 /\ _off + _len <= _ASIZE
         /\ 32 * (_len %/ 32) <= i <= 8 * (_len %/ 8) /\ i %% 8 = 0).
  + wp; skip => &hr [#] -> -> -> -> -> -> -> H0 H1 Hoff Hi0 Hi1 Hi8 Hc /=.
    have G : forall k, 0 <= k < 4 => WArray800.get64_direct (WArray800.init256 ("_.[_]" _st)) (4 * i{hr} + 8 * k) = _st.[i{hr} %/ 8] \bits64 k.
    + by move=> k Hk; have /= <- := st4x_get64_direct _st (i{hr} %/ 8) k _ _; [smt() | done | congr; smt()].
    have L : forall l (b: W8.t A.t) (t: W64.t), 0 <= l < 4 => t = _st.[i{hr} %/ 8] \bits64 l =>
             A.init (WA.get8 (WA.set64_direct (WA.init8 ("_.[_]" (A.fill (fun j => (stbytes (st4x_get _st l)).[j - _off]) _off i{hr} b))) (_off + i{hr}) t))
             = A.fill (fun j => (stbytes (st4x_get _st l)).[j - _off]) _off (i{hr} + 8) b.
    + move=> l b t Hl Ht; have /= -> := a_set64_fill (A.fill (fun j => (stbytes (st4x_get _st l)).[j - _off]) _off i{hr} b) (_off + i{hr}) t.
      by apply (dump_step64 _st l t b _off i{hr} 8) => //; smt().
    move: (G 0 _) (G 1 _) (G 2 _) (G 3 _) => //= E0 E1 E2 E3.
    by rewrite (L 0 _buf0 _ _ E0) // (L 1 _buf1 _ _ E1) // (L 2 _buf2 _ _ E2) // (L 3 _buf3 _ _ E3) //; smt().
  by auto => />; smt().
if; last first.
+ auto => /> H0 H1 Hoff Hc.
  by rewrite (: 8 * (_len %/ 8) = _len) 1:/#.
wp; ecall (a_ilen_write_upto8_h buf3 offset 0 (_LEN %% 8) t3); wp; ecall (a_ilen_write_upto8_h buf2 offset 0 (_LEN %% 8) t2).
wp; ecall (a_ilen_write_upto8_h buf1 offset 0 (_LEN %% 8) t1); wp; ecall (a_ilen_write_upto8_h buf0 offset 0 (_LEN %% 8) t0).
wp; skip => &hr [#] -> -> -> -> -> -> -> H0 H1 Hoff -> Hc /= r0 R0 r1 R1 r2 R2 r3 R3.
have G : forall k, 0 <= k < 4 => WArray800.get64_direct (WArray800.init256 ("_.[_]" _st)) (4 * (8 * (_len %/ 8)) + 8 * k) = _st.[8 * (_len %/ 8) %/ 8] \bits64 k.
+ by move=> k Hk; have /= <- := st4x_get64_direct _st (8 * (_len %/ 8) %/ 8) k _ _; [smt() | done | congr; smt()].
have T : forall l (b r: W8.t A.t) (t: W64.t) d2 l2, 0 <= l < 4 => t = _st.[8 * (_len %/ 8) %/ 8] \bits64 l =>
         asubwrite (A.fill (fun j => (stbytes (st4x_get _st l)).[j - _off]) _off (8 * (_len %/ 8)) b) r (_off + 8 * (_len %/ 8)) (u64bytes t) 0 (_len %% 8) d2 l2 =>
         r = A.fill (fun j => (stbytes (st4x_get _st l)).[j - _off]) _off _len b.
+ move=> l b r t d2 l2 Hl Ht; rewrite /asubwrite => [#] -> _ _; have Hs : size (u64bytes t) = 8 by rewrite /u64bytes size_to_list.
  rewrite Hs (: min 8 (max 0 (_len %% 8)) = _len %% 8) 1:/# (: _off + 8 * (_len %/ 8) + 0 = _off + 8 * (_len %/ 8)) 1:/#.
  have -> : (fun j => (u64bytes t).[j - (_off + 8 * (_len %/ 8))]) = (fun j => t \bits8 (j - (_off + 8 * (_len %/ 8)))) by apply fun_ext => j; rewrite get_u64bytes.
  rewrite (dump_step64 _st l t b _off (8 * (_len %/ 8)) (_len %% 8)) //; 1..3: smt().
  + smt().
  by congr; smt().
move: (G 0 _) (G 1 _) (G 2 _) (G 3 _) => //= E0 E1 E2 E3.
by rewrite (T 0 _buf0 _ _ _ _ _ E0 R0) // (T 1 _buf1 _ _ _ _ _ E1 R1) // (T 2 _buf2 _ _ _ _ _ E2 R2) // (T 3 _buf3 _ _ _ _ _ E3 R3) //; smt().
qed.

phoare dumpstate_avx2x4_ph _buf0 _buf1 _buf2 _buf3 _off _len _st:
 [ MM.__dumpstate_avx2x4
 : buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3 /\ offset=_off /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _off + _len <= _ASIZE
 ==> res.`1 = A.fill (fun i=> (stbytes (st4x_get _st 0)).[i-_off]) _off _len _buf0
  /\ res.`2 = A.fill (fun i=> (stbytes (st4x_get _st 1)).[i-_off]) _off _len _buf1
  /\ res.`3 = A.fill (fun i=> (stbytes (st4x_get _st 2)).[i-_off]) _off _len _buf2
  /\ res.`4 = A.fill (fun i=> (stbytes (st4x_get _st 3)).[i-_off]) _off _len _buf3
  /\ res.`5 = _off + _len
  ] = 1%r.
proof.
by conseq dumpstate_avx2x4_ll (dumpstate_avx2x4_h _buf0 _buf1 _buf2 _buf3 _off _len _st).
qed.

lemma squeeze_avx2x4_ll: islossless MM.__squeeze_avx2x4.
proof.
proc.
seq 5: true => //.
 sp; if => //.
 while true (iTERS-i).
  move=> z.
  wp; call dumpstate_avx2x4_ll.
  wp; call keccakf1600_avx2x4_ll.
  by auto => /#. 
 by auto => /#.
if => //.
call  dumpstate_avx2x4_ll.
by call keccakf1600_avx2x4_ll; auto => /#.
qed.

lemma st4x_get_iter k (st: state4x) l:
 0 <= k => 0 <= l < 4 =>
 st4x_get (iter k keccak_f1600_x4 st) l = st_i (st4x_get st l) k.
proof.
move=> Hk Hl; elim: k Hk => [|k Hk IH]; first by rewrite /st_i !iter0.
by rewrite iterS // /keccak_f1600_x4 st4x_get_map // IH /st_i iterS.
qed.

lemma sq_step (st: state4x) l r8 i n (b: W8.t A.t):
 0 <= l < 4 => 0 < r8 <= 200 => 0 <= i => 0 <= n <= r8 => i * r8 + n <= _ASIZE =>
 A.fill (fun j => (stbytes (st4x_get (iter (i+1) keccak_f1600_x4 st) l)).[j - i * r8]) (i * r8) n
        (A.fill (fun j => (SQUEEZE1600 r8 _ASIZE (st4x_get st l)).[j]) 0 (i * r8) b)
 = A.fill (fun j => (SQUEEZE1600 r8 _ASIZE (st4x_get st l)).[j]) 0 (i * r8 + n) b.
proof.
move=> Hl Hr Hi Hn Hb.
have /= -> // := fill_step (fun j => (SQUEEZE1600 r8 _ASIZE (st4x_get st l)).[j]) (fun j => (stbytes (st4x_get (iter (i+1) keccak_f1600_x4 st) l)).[j - i * r8]) 0 (i * r8) n b; 1,2: smt().
move=> j Hj; have [t [-> Ht]] : exists t, j = i * r8 + t /\ 0 <= t < n by exists (j - i * r8); smt().
by rewrite (: i * r8 + t - i * r8 = t) 1:/# st4x_get_iter // 1:/# nth_SQUEEZE1600 // 1:/# divzMDl 1:/# (divz_small t r8) 1:/# modzMDl (modz_small t r8) 1:/#.
qed.

lemma fill_of_list (l: W8.t list) (b: W8.t A.t):
 size l = _ASIZE => A.fill (fun j => l.[j]) 0 _ASIZE b = A.of_list W8.zero l.
proof. by move=> Hs; rewrite A.fillE; apply A.tP => j Hj; rewrite A.initiE //= A.get_of_list // ifT /#. qed.

hoare squeeze_avx2x4_h _buf0 _buf1 _buf2 _buf3 _st _r8:
 MM.__squeeze_avx2x4
 : buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3
 /\ st=_st /\ _RATE8=_r8
 /\ 0 < _r8 <= 200
 ==>
    res.`1 = iter ((_ASIZE - 1) %/ _r8 + 1) keccak_f1600_x4 _st
 /\ res.`2 = of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 0))
 /\ res.`3 = of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 1))
 /\ res.`4 = of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 2))
 /\ res.`5 = of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 3)).
proof.
proc; have ?:= _ASIZE_ge0.
seq 5 : (offset = iTERS * _r8 /\ st = iter iTERS keccak_f1600_x4 _st
         /\ buf0 = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 0)).[j]) 0 (iTERS * _r8) _buf0
         /\ buf1 = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 1)).[j]) 0 (iTERS * _r8) _buf1
         /\ buf2 = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 2)).[j]) 0 (iTERS * _r8) _buf2
         /\ buf3 = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 3)).[j]) 0 (iTERS * _r8) _buf3
         /\ iTERS = _ASIZE %/ _r8 /\ lO = _ASIZE %% _r8 /\ _RATE8 = _r8 /\ 0 < _r8 <= 200).
+ sp; if; last first.
  + auto => /> Hr0 Hr1 Hn; have -> : _ASIZE %/ _r8 = 0 by smt(divz_ge0).
    have F0 : forall (f: int -> W8.t) (b: W8.t A.t), A.fill f 0 0 b = b.
    + by move=> f b; rewrite A.fillE; apply A.tP => j Hj; rewrite A.initiE //= /#.
    by rewrite iter0 // (: 0 * _r8 = 0) 1:// !F0.
  while (0 <= i <= iTERS /\ offset = i * _r8 /\ st = iter i keccak_f1600_x4 _st
         /\ buf0 = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 0)).[j]) 0 (i * _r8) _buf0
         /\ buf1 = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 1)).[j]) 0 (i * _r8) _buf1
         /\ buf2 = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 2)).[j]) 0 (i * _r8) _buf2
         /\ buf3 = A.fill (fun j => (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 3)).[j]) 0 (i * _r8) _buf3
         /\ iTERS = _ASIZE %/ _r8 /\ lO = _ASIZE %% _r8 /\ _RATE8 = _r8 /\ 0 < _r8 <= 200).
  + wp; ecall (dumpstate_avx2x4_h buf0 buf1 buf2 buf3 offset _RATE8 st); ecall (keccakf1600_avx2x4_h st).
    skip => &hr [#] Hi0 Hi1 -> -> -> -> -> -> -> -> -> Hr0 Hr1 Hc /=.
    move=> _ ->; have -> : st4x_map keccak_f1600_op (iter i{hr} keccak_f1600_x4 _st) = iter (i{hr} + 1) keccak_f1600_x4 _st by rewrite iterS.
    have Hb : (i{hr} + 1) * _r8 <= _ASIZE.
    + apply (StdOrder.IntOrder.ler_trans (_ASIZE %/ _r8 * _r8)); [by apply StdOrder.IntOrder.ler_wpmul2r; smt() | by apply lez_floor; smt()].
    split; first smt().
    move=> _ r [#] -> -> -> -> ->.
    have S : forall l (b: W8.t A.t), 0 <= l < 4 =>
             A.fill (fun j => (stbytes (st4x_get (iter (i{hr} + 1) keccak_f1600_x4 _st) l)).[j - i{hr} * _r8]) (i{hr} * _r8) _r8
                    (A.fill (nth W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l))) 0 (i{hr} * _r8) b)
             = A.fill (nth W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l))) 0 ((i{hr} + 1) * _r8) b.
    + move=> l b Hl; rewrite (: (i{hr} + 1) * _r8 = i{hr} * _r8 + _r8) 1:/#.
      by have /= -> // := sq_step _st l _r8 i{hr} _r8 b; smt().
    by rewrite !S //; smt().
  auto => /> Hr0 Hr1 Hn; have F0 : forall (f: int -> W8.t) (b: W8.t A.t), A.fill f 0 0 b = b.
  + by move=> f b; rewrite A.fillE; apply A.tP => j Hj; rewrite A.initiE //= /#.
  split; first by rewrite iter0 // !F0; smt().
  by move=> i0 H1 H2 H3; have -> : i0 = _ASIZE %/ _r8 by smt().
if; last first.
+ skip => &hr [#] _ -> -> -> -> -> -> -> _ Hr0 Hr1 Hl /=.
  have FL : forall l (b: W8.t A.t), A.fill (nth W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l))) 0 _ASIZE b
                                    = A.of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l)).
  + by move=> l b; have /= -> // := fill_of_list (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l)) b; rewrite size_SQUEEZE1600 // /#.
  have Ea : _ASIZE %/ _r8 * _r8 = _ASIZE by smt(divz_eq modz_ge0).
  have Ei : (_ASIZE - 1) %/ _r8 + 1 = _ASIZE %/ _r8.
  + by rewrite -{1}Ea (: _ASIZE %/ _r8 * _r8 - 1 = _ASIZE %/ _r8 * _r8 + (-1)) 1:/# divzMDl 1:/#; smt().
  by rewrite Ea Ei !FL.
ecall (dumpstate_avx2x4_h buf0 buf1 buf2 buf3 offset lO st); ecall (keccakf1600_avx2x4_h st).
skip => &hr [#] -> -> -> -> -> -> -> -> _ Hr0 Hr1 Hl /=.
move=> _ ->; have -> : st4x_map keccak_f1600_op (iter (_ASIZE %/ _r8) keccak_f1600_x4 _st) = iter (_ASIZE %/ _r8 + 1) keccak_f1600_x4 _st by rewrite iterS // divz_ge0.
have Ea : _ASIZE %/ _r8 * _r8 + _ASIZE %% _r8 = _ASIZE by smt(divz_eq).
split; first smt(modz_ge0 ltz_pmod).
move=> _ r [#] -> -> -> -> _.
have FL : forall l (b: W8.t A.t), A.fill (nth W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l))) 0 _ASIZE b
                                  = A.of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l)).
+ by move=> l b; have /= -> // := fill_of_list (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l)) b; rewrite size_SQUEEZE1600 // /#.
have S : forall l (b: W8.t A.t), 0 <= l < 4 =>
         A.fill (fun i0 => (stbytes (st4x_get (iter (_ASIZE %/ _r8 + 1) keccak_f1600_x4 _st) l)).[i0 - _ASIZE %/ _r8 * _r8]) (_ASIZE %/ _r8 * _r8) (_ASIZE %% _r8)
                (A.fill (nth W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l))) 0 (_ASIZE %/ _r8 * _r8) b)
         = A.of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st l)).
+ move=> l b Hl4; have /= E := sq_step _st l _r8 (_ASIZE %/ _r8) (_ASIZE %% _r8) b; rewrite E //.
  + smt(divz_ge0).
  + smt(modz_ge0 ltz_pmod).
  + by rewrite Ea.
  by rewrite Ea FL.
have Ei : (_ASIZE - 1) %/ _r8 = _ASIZE %/ _r8.
+ rewrite -{1}Ea (: _ASIZE %/ _r8 * _r8 + _ASIZE %% _r8 - 1 = _ASIZE %/ _r8 * _r8 + (_ASIZE %% _r8 - 1)) 1:/#.
  by rewrite divzMDl 1:/# (divz_small (_ASIZE %% _r8 - 1) _r8); smt(ltz_pmod).
by rewrite Ei !S.
qed.

phoare squeeze_avx2x4_ph _buf0 _buf1 _buf2 _buf3 _st _r8:
 [ MM.__squeeze_avx2x4
 : buf0=_buf0 /\ buf1=_buf1 /\ buf2=_buf2 /\ buf3=_buf3
 /\ st=_st /\ _RATE8=_r8
 /\ 0 < _r8 <= 200
 ==>
    res.`1 = iter ((_ASIZE - 1) %/ _r8 + 1) keccak_f1600_x4 _st
 /\ res.`2 = of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 0))
 /\ res.`3 = of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 1))
 /\ res.`4 = of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 2))
 /\ res.`5 = of_list W8.zero (SQUEEZE1600 _r8 _ASIZE (st4x_get _st 3))
 ] = 1%r.
proof.
by conseq squeeze_avx2x4_ll (squeeze_avx2x4_h _buf0 _buf1 _buf2 _buf3 _st _r8).
qed.

end KeccakArrayAvx2x4.


