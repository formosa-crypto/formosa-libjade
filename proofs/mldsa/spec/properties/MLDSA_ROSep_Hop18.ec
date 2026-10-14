require import AllCore IntDiv List Distr DList PROM FMap Xreal StdBigop StdOrder.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require import Spec65.
import MLDSA65.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.
require import MLDSA_ROSep_Hop9 MLDSA_ROSep_Hop10 MLDSA_ROSep_Hop11 MLDSA_ROSep_Hop12 MLDSA_ROSep_Hop13.
require import MLDSA_ROSep_Hop14 MLDSA_ROSep_Hop15 MLDSA_ROSep_Hop16 MLDSA_ROSep_Hop17.
require import ConcreteDRing MLDSATargetFIPS Leakage.
require DS_ROM.
import PolyReduce.
import TF.DV TF.DV.MatRq.Vectors TF.DV.MatRq.Matrices.

(*************** The reduction to the target ****************)

module B(A : DS2.Adversary)(H1 : DST.POracle1, H2 : DST.POracle2, H3 : DST.POracle3, H4 : DST.POracle4,
                            H5 : DST.POracle5, O : DST.SOracle) = {
  module O' = {
    proc sign(m : W8.t list) : BytesSig.t option * Leakage list = {
      var rs, sg, s;
      rs <@ O.sign(m);
      sg <- None;
      if (rs.`1 <> None) {
        s <@ SigEncDec.sigEncode((oget rs.`1).`1, l_of_vec (oget rs.`1).`2.`1, poly_of_hints (oget rs.`1).`2.`2);
        sg <- Some s;
      }
      return (sg, tleak rs.`2);
    }
  }

  proc forge(pk : TF.PK) : W8.t list * TF.Sig = {
    var pkb, m, s, ct, z, h;
    RO_xr.RO.init();
    pkb <@ PkEncDec.pkEncode(pk.`1, poly_of_t1 pk.`2);
    (m, s) <@ Router11(A, XAw(H1), XCw(H2), Htrw(H3), H4, Hctw(H5), O').forge(pkb);
    (ct, z, h) <@ SigEncDec.sigDecode(s);
    return (m, (ct, (vec_of_l z, if h = None then [] else hints_of (oget h))));
  }
}.

lemma tfverify_rej :
  phoare [TF.MLDSA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO).verify :
          size sig.`2.`2 <> kvec ==> !res] = 1%r.
proof.
conseq tfverify_ll (_ : size sig.`2.`2 <> kvec ==> !res) => //.
proc; call (: true); 1: by conseq />.
wp; do 4! (call (: true); 1: by conseq />).
by auto => /> /#.
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA, -DS10.EUF_CMA, -DS10.RO5.RO,
  -RO_hr.RO, -Router10, -DS11.EUF_CMA, -RO_xc.RO, -RO_xc.FRO, -Router11, -DST.RO1.RO, -DST.RO2.RO,
  -DST.RO3.RO, -DST.RO4.RO, -DST.RO5.RO, -DST.EUF_CMA, -RO_xr.RO, -G13, -Coins }.

lemma G17_B &m :
  Pr[G17(A).main() @ &m : res] =
  Pr[DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, TF.MLDSA, B(A)).main() @ &m : res].
proof.
byequiv (: ={glob A} ==> ={res}) => //.
proc.
inline{2} DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, TF.MLDSA, B(A)).A.forge.
inline{1} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G17(A).O).forge.
inline{2} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO),
                   B(A, DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO,
                     DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, TF.MLDSA, B(A)).O).O').forge.
inline{1} V16.verify KG16.keygen.
seq 22 18 : (={ct, z, h, glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO} /\
             pk2{1} = pk{2} /\ m{1} = m0{2} /\ m0{1} = m0{2} /\ G13.qs{1} = DST.EUF_CMA.qs{2}).
+ call (: true); 1: by sim.
  wp.
  call (: ={glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO,
            RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr} /\
          G13.qs{1} = DST.EUF_CMA.qs{2} /\ G13.sk{1} = DST.EUF_CMA.sk{2}).
  + proc; inline{1} Sign17.sign;
      inline{2} DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, TF.MLDSA, B(A)).O.sign.
    seq 4 4 : (={rs, glob DST.RO1.RO, glob RO_xr.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO,
                 glob DST.RO5.RO, RO_rest.RO.m, RO_pad.RO.m, RO_hr.RO.m, Router11.tr} /\
               G13.qs{1} = DST.EUF_CMA.qs{2} /\ G13.sk{1} = DST.EUF_CMA.sk{2}).
    + wp; call (: ={glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO});
        1: by sim.
      by auto.
    by sp; if => //; [wp; call (: true); [sim | auto => />] | auto => />].
  + by sim.
  + by sim.
  call (: ={glob DST.RO3.RO}); 1: by sim.
  inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init;
    inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init RO_xr.RO.init; wp.
  call (: true); 1: by sim.
  wp; call (: ={glob DST.RO1.RO, glob DST.RO3.RO} ==> ={res, glob DST.RO1.RO, glob DST.RO3.RO}); 1: by sim.
  by inline *; auto => />.
sp 1 1.
if{1}.
+ wp; call (: ={glob DST.RO1.RO, glob DST.RO2.RO, glob DST.RO3.RO, glob DST.RO4.RO, glob DST.RO5.RO}); 1: by sim.
  by auto => /> /#.
by wp; call{2} tfverify_rej; auto => />; smt(gt0_k).
qed.

(* The FIPS 204 scheme with hedged signing, against the target with the reduction B *)
lemma mldsa_euf_cma (qH qS : int) (eps : real) &m : 0 <= qH => 0 <= qS => (forall r, mu1 drnd r <= eps) =>
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  (forall (H <: DS2.POracle1 {-A, -CountH, -CountS}) (G <: DS2.POracle2 {-A, -CountH, -CountS})
          (O <: DS2.SOracle {-A, -CountH, -CountS}),
     hoare [A(CountH(H), G, CountS(O)).forge :
              CountH.c = 0 /\ CountS.c = 0 ==> CountH.c <= qH /\ CountS.c <= qS]) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS, A).main() @ &m : res] <=
  Pr[DST.EUF_CMA(DST.RO1.RO, DST.RO2.RO, DST.RO3.RO, DST.RO4.RO, DST.RO5.RO, TF.MLDSA, B(A)).main() @ &m : res] +
  (2 * (qH + qS * (1 + kappa_max)) + qS * (qS + qH + 1) + 6)%r * p512 + (3 * qH + qS + 4)%r * p256 +
  (qS * (qS - 1))%r / 2%r * eps.
proof.
move=> hqH hqS hmu A_ll A_count.
have h1 := hop1 A qH qS &m hqH hqS A_count.
have h11 := hop11 A qH qS &m hqH hqS A_ll A_count.
have h17 := hop17 A qH qS eps &m hqS hmu A_ll A_count.
rewrite (G11_G12 A &m) (G12_G13 A &m) (G13_G14 A &m) (G14_G15 A &m) (G15_G16 A &m) in h11.
rewrite -(G17_B &m).
have -> : (2 * (qH + qS * (1 + kappa_max)) + qS * (qS + qH + 1) + 6)%r * p512 =
          (qH + qS * (1 + kappa_max) + 2)%r * p512 +
          (2%r * p512 + (qH + qS * (1 + kappa_max) + 2)%r * p512 + (qS * (qS + qH + 1))%r * p512).
+ by rewrite !fromintD !fromintM; ring.
smt().
qed.

end section.
