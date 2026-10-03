(******************************************************************************
   avx2/Keccak1600_fixedsizes_avx2_mem.ec:

   Correctness proof for the Keccak (fixed-sized) memory squeeze
  AVX2 implementation

******************************************************************************)

require import AllCore List Int IntDiv StdOrder.

from Jasmin require import JModel_x86.

from JazzEC require import Keccak1600_Jazz.
from JazzEC require import WArray200.
from JazzEC require import Array7 Array25.

require import JWordList.
from CryptoSpecs require import FIPS202_Keccakf1600.
from CryptoSpecs require import FIPS202_SHA3_Spec Keccakf1600_Spec Keccak1600_Spec.


require import Keccak1600_avx2 Keccakf1600_avx2.
require import Keccak1600_subreadwrite Keccak1600_subreadwrite_mem.
require import Keccak1600_fixedsizes_avx2.

import IntOrder.


(*
   ONE-SHOT (FIXED-SIZE) MEMORY SQUEEZE
   ====================================
*)

lemma dumpstate_m_avx2_ll: islossless M.__dumpstate_m_avx2
 by islossless.

hoare dumpstate_m_avx2_h _mem _buf _len _st:
 M.__dumpstate_m_avx2
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (sub (stbytes (stavx2_to_st25 _st)) 0 _len)
  /\ res = _buf + _len.
proof.
proc => /=.
admitted.

phoare dumpstate_m_avx2_ph _mem _buf _len _st:
 [ M.__dumpstate_m_avx2
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (sub (stbytes (stavx2_to_st25 _st)) 0 _len)
  /\ res = _buf + _len
 ] = 1%r.
proof.
by conseq dumpstate_m_avx2_ll (dumpstate_m_avx2_h _mem _buf _len _st).
qed.

lemma squeeze_m_avx2_ll: islossless M.__squeeze_m_avx2.
proof.
proc.
seq 4: true => //.
 while true (iTERS-i).
  move=> z.
  wp; call dumpstate_m_avx2_ll.
  call keccakf1600_avx2_ll.
  by auto => /#.
 auto => /#.
if => //.
call dumpstate_m_avx2_ll.
call keccakf1600_avx2_ll.
by auto.
qed.

hoare squeeze_m_avx2_h _mem _buf _len _st _r8:
 M.__squeeze_m_avx2
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st /\ _RATE8=_r8
 /\ 0 <= _len
 /\ 0 < _r8 <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (SQUEEZE1600 _r8 _len (stavx2_to_st25 _st))
  /\ res = stavx2_from_st25 (st_i (stavx2_to_st25 _st) ((_len-1) %/ _r8 + 1)).
proof.
proc.
admitted.

phoare squeeze_m_avx2_ph _mem _buf _len _st _r8:
 [ M.__squeeze_m_avx2
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st /\ _RATE8=_r8
 /\ 0 <= _len
 /\ 0 < _r8 <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (SQUEEZE1600 _r8 _len (stavx2_to_st25 _st))
  /\ res = stavx2_from_st25 (st_i (stavx2_to_st25 _st) ((_len-1) %/ _r8 + 1))
 ] = 1%r.
proof.
by conseq squeeze_m_avx2_ll (squeeze_m_avx2_h _mem _buf _len _st _r8).
qed.
