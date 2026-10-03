(******************************************************************************
   Keccak1600_fixedsizes_ref_mem.ec:

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
require import Keccak1600_subreadwrite Keccak1600_subreadwrite_mem.
require import Keccak1600_fixedsizes_ref.

require import StdOrder.
import IntOrder.

(*
   ONE-SHOT (FIXED-SIZE) MEMORY ABSORB
   ===================================
*)

lemma addstate_m_ll: islossless M.__addstate_m.
proof.
(* This proof script is independent of selected `KECCAK_FEATURES` *)
proc.
swap 1 1.
seq 1: true => />; 1:auto; 1:islossless; last by hoare; auto.
seq 1: #pre => //; first inline*; auto.
if => //.
 seq 3: true => />; 1,4:auto; 2: islossless.
 while true (_LEN %/ 32 - i).
  by move=> z; auto; smt().
 by auto; smt().
seq 2: true => />; 1,4:auto; 2: islossless.
while true (aT + _LEN %/ 8 *8 - at).
 by move=> z; auto; smt().
by auto => /> /#.
qed.

lemma mullR:
forall (x y z: int), (x + y) * z = x * z + y * z by smt().

hoare addstate_m_h _mem _st _at _buf _len _tb:
 M.__addstate_m
 : Glob.mem=_mem /\ st=_st /\ aT=_at /\ buf=_buf /\ _LEN=_len /\ _TRAILB=_tb
 /\ 0 <= _at <= 200
 /\ 0 <= _len
 /\ _at+_len <= 200 - b2i (_tb<>0)
 /\ _buf + _len < W64.modulus
 /\ 0 <= _tb < 256
 ==> let l = memread _mem _buf _len ++ if _tb<>0 then [W8.of_int _tb] else []
     in Glob.mem=_mem
        /\ res.`1 = addstate_at _st _at l
        /\ res.`2 = _at + size l
        /\ res.`3 = _buf + _len.
proof.
(* ADMITTED (WIP): the previous (partial) script below stepped through the
   pre-refactor proc shape; __addstate_m now starts with a __HAS_FEATURE
   call and branches between an AVX2 wide path and the former scalar path.
   To be reworked (the scalar branch should reuse most of the old script).
proc; simplify.
conseq (: Glob.mem = _mem /\
  st =
  addstate_at _st _at (memread _mem _buf _len ++ if _tb<>0 then [W8.of_int _tb]
                                                           else []) /\
  (aT = _at + _len + if _tb <> 0 then 1 else 0) /\
  buf = _buf + _len).
  by auto => />*; rewrite size_cat size_mkseq /#.
seq 4: (#[/1,6:8]pre /\
        0 <= _LEN /\
        #[/10:]pre /\
        aT = _at /\
        _LEN = (_len - if 0 < _at - _at %/ 8 * 8 < 8
                       then min (max 0 _len) (_at %/ 8 * 8 + 8 - _at)
                       else 0) /\
        st = addstate_at _st _at (memread _mem _buf (_len-_LEN)) /\
        buf = _buf + _len - _LEN).
+ sp; wp; case(aT8 %% 8 <> 0).
   rcondt 1; first by auto => /#.
   wp; ecall(m_ilen_read_upto8_at_h _buf _len _tb (_at %/ 8 * 8) _at).
   auto => /> H0 H1 H2 H3 H4 H5 H6 H7; split; first smt().
   rewrite /srspec /srpre /srincr /memread size_mkseq /u64bytes.
   rewrite H0 H5 H6 lez_maxr 1:/# /= => H8 result.
   have->: 0 <= _at %/ 8 * 8 /\ (_at %/ 8 * 8 <= _at \/
           mkseq (fun (i : int) => _mem.[_buf + i]) _len = [] /\ _tb = 0) by smt().
   rewrite implyTb ifT ..1:/# => [#] H9 H10 H11 H12 H13 H14 H15 H16 H17 H18 H19.
   rewrite H19 H16 H17 H18.
   have->: (_len - (_len - min _len (_at %/ 8 * 8 + 8 - _at))) =
            (min _len (_at %/ 8 * 8 + 8 - _at)) by smt().
   have->: _at %/ 8 * 8 + 8 - _at = 8 - _at %% 8 by smt().
   do split.
   + admit.
   + smt().
   + admit.
   + rewrite ifT /#.
   + rewrite /addstate_at /fill size_mkseq lez_maxr 1:/#.
     pose a:= _st.[8 * (_at %/ 8) %/ 8 <- _st.[8 * (_at %/ 8) %/ 8] `^` result.`5].
     rewrite eq_sym (Array25.ext_eq _ a) 2:/#  => x x_bnd.
     rewrite !initE !ifT 1:/# /= get64E /pack8_t.
     rewrite (W64.ext_eq _ a.[x]) 2:/# => x0 x0_bnd.
     rewrite /a initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/# /=.
     rewrite initE (:0 <= 8 * x + x0 %/ 8 < 200) 1:/# /=.
     admit(*
     case(x < _at) => min.
      rewrite ifF.
       rewrite lezNgt andaE negb_and /=.
       rewrite (ler_lt_trans (8 * x + x0 %/ 8)) 1:/#.
       admit.
 1:/# get_setE 1:/#. HERE!!! print IntDiv.
      have-
      rewrite ifF. print IntDiv. rewrite eq_sym. ifT 1:/#.
 ifT. 1:/# /=/(\bits8) initE ifT 1:/# /=.
    rewrite Ring.IntID.mulrC edivz_eq 1:/# dvdz_modzDl /#.*).
   + smt().
  rcondf 1; first by auto => /#.
  auto => /> *; do split; ..2:smt().
   rewrite /addstate_at /fill.
   rewrite (init_ext _ (fun (i : int) => (stbytes _st).[i])); 1: smt().
   rewrite eq_sym (Array25.ext_eq _ _st) 2:/# => x x_bnd.
   rewrite !initE !ifT 1:/# /= get64E /pack8_t.
   rewrite (W64.ext_eq _ _st.[x]) 2:/# => x0 x0_bnd.
   rewrite initE ifT 1:/# /= initE ifT 1:/# /= initE ifT 1:/#.
   rewrite initE ifT 1:/# /=/(\bits8) initE ifT 1:/# /=.
   by rewrite Ring.IntID.mulrC edivz_eq 1:/# dvdz_modzDl /#.
  smt().
seq 3: (#[/:5, 9:]pre /\
        aT = _at + (8 - _at) %% 8 + (_len - (8 - _at) %% 8) %/ 8 * 8 /\
        _LEN = _len - (8 - at) %% 8 - (_len - (8 - at) %% 8) %/ 8 * 8).
 admit.
case( _LEN <= 0 /\ _tb = 0).
 rcondf 1; first by auto => /#.
 by auto => /> &hr H0 H1 H2 H3 H4; rewrite cats0 /#.
auto => />.
 move=> &m H0 H1 H2 H3 H4.
admit(*
 rewrite cats0 /#.
case(_len %% 8 < (8 - _at) %% 8) => c1.
  have->: (_len - (8 - _at) %% 8) %/ 8 * 8 = _len %/ 8 * 8 - 8.
  + rewrite {1}(divz_eq _len 8) -Ring.IntID.addrA /#.



case((8 - _at) %% 8 = 0) => c0.
  move:
  rewrite c0 /=.


 have->:(_len - (8-at{hr})) %% 8 <= 0 = ((_len - (8-at{hr})) %% 8 = 0).
  smt(). have aux: (8 - at{hr}) %% 8 = 0. smt().
*).
admit.
qed.
*)
admitted.

phoare addstate_m_ph _mem _st _at _buf _len _tb:
 [ M.__addstate_m
 : Glob.mem=_mem /\ st=_st /\ aT=_at /\ buf=_buf /\ _LEN=_len /\ _TRAILB=_tb
 /\ 0 <= _at <= 200
 /\ 0 <= _len
 /\ _at+_len <= 200 - b2i (_tb<>0)
 /\ _buf + _len < W64.modulus
 /\ 0 <= _tb < 256
 ==> let l = memread _mem _buf _len ++ if _tb<>0 then [W8.of_int _tb] else []
     in Glob.mem=_mem
        /\ res.`1 = addstate_at _st _at l
        /\ res.`2 = _at + size l
        /\ res.`3 = _buf + _len
 ] = 1%r.
proof.
by conseq addstate_m_ll (addstate_m_h _mem _st _at _buf _len _tb).
qed.

lemma absorb_m_ll: islossless M.__absorb_m.
proof.
proc; simplify.
seq 2: true => //.
 call addstate_m_ll.
 if => //.
 wp; while true (iTERS-i).
  move=> z; auto.
  call keccakf1600_ll.
  call addstate_m_ll.
  by auto => /#.
 wp; call keccakf1600_ll.
 wp; call addstate_m_ll.
 by auto => /#.
if => //.
by call addratebit_ll.
qed.

hoare absorb_m_h _l _mem _buf _len _tb _r8:
 M.__absorb_m
 : Glob.mem=_mem /\ aT=size _l %% _r8 /\ buf=_buf /\ _LEN=_len /\ _RATE8=_r8 /\ _TRAILB=_tb
 /\ pabsorb_spec_ref _r8 _l st
 /\ 0 <= _len
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = _mem
  /\ if _tb <> 0
     then res.`1 = ABSORB1600 (W8.of_int _tb) _r8 (_l ++ memread _mem _buf _len)
       /\ res.`3 = _buf + _len
     else pabsorb_spec_ref _r8 (_l ++ memread _mem _buf _len) res.`1
       /\ res.`2 = (size _l + _len) %% _r8
       /\ res.`3 = _buf + _len.
proof.
proc.
admitted.

phoare absorb_m_ph _l _mem _buf _len _tb _r8:
 [ M.__absorb_m
 : Glob.mem=_mem /\ aT=size _l %% _r8 /\ buf=_buf /\ _LEN=_len /\ _RATE8=_r8 /\ _TRAILB=_tb
 /\ pabsorb_spec_ref _r8 _l st
 /\ 0 <= _len
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = _mem
  /\ if _tb <> 0
     then res.`1 = ABSORB1600 (W8.of_int _tb) _r8 (_l ++ memread _mem _buf _len)
       /\ res.`3 = _buf + (max 0 _len)
     else pabsorb_spec_ref _r8 (_l ++ memread _mem _buf _len) res.`1
       /\ res.`2 = (size _l + _len) %% _r8
       /\ res.`3 = _buf + _len
 ] = 1%r.
proof.
by conseq absorb_m_ll (absorb_m_h _l _mem _buf _len _tb _r8) => /> /#.
qed.

(*
   ONE-SHOT (FIXED-SIZE) MEMORY SQUEEZE
   ====================================
*)

lemma dumpstate_m_ll: islossless M.__dumpstate_m.
proof.
(* This proof script is independent of selected `KECCAK_FEATURES` *)
proc => /=.
seq 1: #pre => //; first by inline*; auto.
if => //.
 seq 3: true => //.
  wp; while true (inc - j).
   by move=> z; auto => /#.
  by auto => /#.
 by islossless.
seq 2: true => //.
 while true (_LEN %/ 8 - i).
  by move=> z; auto => /#.
 by auto => /#.
by islossless.
qed.

hoare dumpstate_m_h _mem _buf _len _st:
 M.__dumpstate_m
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (sub (stbytes _st) 0 _len)
  /\ res = _buf + _len.
proof.
proc => /=.
admitted.

phoare dumpstate_m_ph _mem _buf _len _st:
 [ M.__dumpstate_m
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st
 /\ 0 <= _len <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (sub (stbytes _st) 0 _len)
  /\ res = _buf + _len
 ] = 1%r.
proof.
by conseq dumpstate_m_ll (dumpstate_m_h _mem _buf _len _st).
qed.

lemma squeeze_m_ll: islossless M.__squeeze_m.
proof.
proc; simplify.
seq 2: true => //.
 while true (_LEN %/ _RATE8 - i).
  move => z; auto => />.
  call dumpstate_m_ll.
  call keccakf1600_ll.
  by auto => /#.
 by auto => /#.
if => //.
call dumpstate_m_ll.
call keccakf1600_ll.
by auto => /#.
qed.

hoare squeeze_m_h _mem _buf _len _st _r8:
 M.__squeeze_m
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st /\ _RATE8=_r8
 /\ 0 <= _len
 /\ 0 < _r8 <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (SQUEEZE1600 _r8 _len _st)
     /\ res.`1 = st_i _st ((_len-1) %/ _r8 + 1)
     /\ res.`2 = _buf + _len.
proof.
proc.
admitted.

phoare squeeze_m_ph _mem _buf _len _st _r8:
 [ M.__squeeze_m
 : Glob.mem=_mem /\ buf=_buf /\ _LEN=_len /\ st=_st /\ _RATE8=_r8
 /\ 0 <= _len
 /\ 0 < _r8 <= 200
 /\ _buf + _len < W64.modulus
 ==> Glob.mem = stores _mem _buf (SQUEEZE1600 _r8 _len _st)
     /\ res.`1 = st_i _st ((_len-1) %/ _r8 + 1)
     /\ res.`2 = _buf + _len
 ] = 1%r.
proof.
by conseq squeeze_m_ll (squeeze_m_h _mem _buf _len _st _r8).
qed.
