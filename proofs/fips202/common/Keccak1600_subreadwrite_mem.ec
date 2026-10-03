require import AllCore IntDiv List StdOrder.

require import BitEncoding.
import BS2Int.
import IntOrder.

from Jasmin require import JModel_x86.
from CryptoSpecs require import Keccak1600_Spec.
from JazzEC require import Keccak1600_Jazz.

require import Keccak_bindings.
require import Keccak1600_subreadwrite.

import SLH64.
import IntOrder.

hoare m_ilen_write_upto8_h (_m: global_mem_t) _buf _len _w:
 M.__m_ilen_write_upto8
 : _m=Glob.mem /\ buf=_buf /\ lEN=_len /\ w = _w
 ==> msubwrite _m Glob.mem (u64bytes _w) _buf _len res.`1 res.`2.
proof.
proc => /=.
if => //=; last first.
 auto => /> Hlen; rewrite ler_maxl 1:/# ler_minr; first smt(size_ge0).
 by rewrite take_le0 1:/# store0.
if => //=.
 auto => /> Hlen0 Hlen1; rewrite take_oversize size_to_list 1:/#; split; last smt().
 admit (* storeW64 _m _buf _w = stores _m _buf (u64bytes _w) *).
admitted.

phoare m_ilen_write_upto8_ph (_m: global_mem_t) _buf _len _w:
 [ M.__m_ilen_write_upto8
 :  _m=Glob.mem /\ buf=_buf /\ lEN=_len /\ w = _w
 ==> msubwrite _m Glob.mem (u64bytes _w) _buf _len res.`1 res.`2
 ] = 1%r.
proof. by conseq m_ilen_write_upto8_ll (m_ilen_write_upto8_h _m _buf _len _w). qed.

hoare m_ilen_write_upto16_h (_m: global_mem_t) _buf _len _w:
 M.__m_ilen_write_upto16
 : _m=Glob.mem /\ buf=_buf /\ lEN=_len /\ w = _w
 ==> msubwrite _m Glob.mem (u128bytes _w) _buf _len res.`1 res.`2.
proof.
proc => /=.
admitted.

phoare m_ilen_write_upto16_ph (_m: global_mem_t) _buf _len _w:
 [ M.__m_ilen_write_upto16
 : _m=Glob.mem /\ buf=_buf /\ lEN=_len /\ w = _w
 ==> msubwrite _m Glob.mem (u128bytes _w) _buf _len res.`1 res.`2
 ] = 1%r.
proof. by conseq m_ilen_write_upto16_ll (m_ilen_write_upto16_h _m _buf _len _w). qed.

hoare m_ilen_write_upto32_h (_m: global_mem_t) _buf _len _w:
 M.__m_ilen_write_upto32
 : _m=Glob.mem /\ buf=_buf /\ lEN=_len /\ w = _w
 ==> msubwrite _m Glob.mem (u256bytes _w) _buf _len res.`1 res.`2.
proof.
proc => /=.
admitted.

phoare m_ilen_write_upto32_ph (_m: global_mem_t) _buf _len _w:
 [ M.__m_ilen_write_upto32
 : _m=Glob.mem /\ buf=_buf /\ lEN=_len /\ w = _w
 ==> msubwrite _m Glob.mem (u256bytes _w) _buf _len res.`1 res.`2
 ] = 1%r.
proof. by conseq m_ilen_write_upto32_ll (m_ilen_write_upto32_h _m _buf _len _w). qed.

hoare m_rlen_write_upto8_h _m _buf _w _len:
 M.__m_rlen_write_upto8
 : _m=Glob.mem /\ buf=_buf /\ len=_len /\ data = _w
 ==> Glob.mem = stores _m _buf (take _len (u64bytes _w))
     /\ res = _buf + min 8 (max 0 _len).
proof.
proc; simplify.
admitted.

phoare m_rlen_write_upto8_ph _m _buf _w _len:
 [ M.__m_rlen_write_upto8
 : _m=Glob.mem /\ buf=_buf /\ len=_len /\ data = _w
 ==> Glob.mem = stores _m _buf (take _len (u64bytes _w))
     /\ res = _buf + min 8 (max 0 _len)
 ] = 1%r.
proof. by conseq m_rlen_write_upto8_ll (m_rlen_write_upto8_h _m _buf _w _len). qed.
