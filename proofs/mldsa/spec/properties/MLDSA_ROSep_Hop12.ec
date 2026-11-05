require import AllCore IntDiv List Distr DList PROM FMap.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require MLDSA_ROSep_Hop11.
require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1 MLDSA_ROSep_Hop2 MLDSA_ROSep_Hop3.
require import MLDSA_ROSep_Hop4 MLDSA_ROSep_Hop5 MLDSA_ROSep_Hop6 MLDSA_ROSep_Hop7 MLDSA_ROSep_Hop8.
require import MLDSA_ROSep_Hop9 MLDSA_ROSep_Hop10 MLDSA_ROSep_Hop11.
require import ConcreteDRing MLDSATargetFIPS Leakage.
require DS_ROM.
require Byte.

abstract theory MLDSA_ROSep_Hop12.

clone include MLDSA_ROSep_Hop11.MLDSA_ROSep_Hop11.
import Spec.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.


(*************** The target game ****************)

clone DS_ROM.DS_ROM_x5 as DST with
  type pkey    <- MP.T.PK,
  type skey    <- MP.T.SK,
  type msg     <- W8.t list,
  type sig     <- MP.T.Sig,
  type leakage <- Leakage.leakage,
  type RO1.in_t  <- (Bytes32.t * int * int) * int,
  type RO1.out_t <- W8.t,
  op   RO1.dout  <- fun _ => Byte.dB,
  type RO2.in_t  <- BytesCT.t * int,
  type RO2.out_t <- W8.t,
  op   RO2.dout  <- fun _ => Byte.dB,
  type RO3.in_t  <- MP.T.PK,
  type RO3.out_t <- Bytes64.t,
  op   RO3.dout  <- fun _ => dbytes64,
  type RO4.in_t  <- Bytes64.t * W8.t list,
  type RO4.out_t <- Bytes64.t,
  op   RO4.dout  <- fun _ => dbytes64,
  type RO5.in_t  <- DV.HL.S.sT list * Bytes64.t,
  type RO5.out_t <- BytesCT.t,
  op   RO5.dout  <- fun _ => dbytesCT.

(*************** Representations ****************)

op vec_of_l (v : polylvec) : DV.MatRq.Vectors.vector =
  DV.MatRq.Vectors.oflist (map poly2alg (LArray.to_list v)).
op l_of_vec (v : DV.MatRq.Vectors.vector) : polylvec =
  LArray.init (fun i => alg2poly (DV.MatRq.Vectors."_.[_]" v i)).

op hints_of (h : polykvec) : bool list list =
  map (fun (p : poly) => map (fun c => c <> Zq.zero) (Array256.to_list p)) (KArray.to_list h).
op poly_of_hints (hs : bool list list) : polykvec =
  KArray.init (fun i => Array256.init (fun j => if nth false (nth [] hs i) j then Zq.one else Zq.zero)).

op t1_of (t1 : polykvec) : int list list =
  map (fun (p : poly) => map asint (Array256.to_list p)) (KArray.to_list t1).
op poly_of_t1 (t1 : int list list) : polykvec =
  KArray.init (fun i => Array256.init (fun j => incoeff (nth 0 (nth [] t1 i) j))).

op w1_key (w1 : polykvec) : DV.HL.S.sT list =
  map (fun (p : poly) => DV.HL.S.insubd (map asint (Array256.to_list p))) (KArray.to_list w1).

op xa_key (x : W8.t list * int) : (Bytes32.t * int * int) * int =
  ((Bytes32.of_list (take 32 x.`1), to_uint (nth W8.zero x.`1 33), to_uint (nth W8.zero x.`1 32)), x.`2).

(*************** The oracles of G11 over the oracles of the target ****************)

(* XA on inputs that are not ExpandA seeds *)
clone FullRO as RO_xr with
  type in_t  <- W8.t list * int,
  type out_t <- W8.t,
  op   dout  <- fun _ => W8.dword.

module XAw(XA : DST.POracle1) = {
  proc get(x : W8.t list * int) : W8.t = {
    var r;
    if (size x.`1 = 34) {
      r <@ XA.get(xa_key x);
    } else {
      r <@ RO_xr.RO.get(x);
    }
    return r;
  }
}.

module XCw(XC : DST.POracle2) = {
  proc get(x : W8.t list * int) : W8.t = {
    var r;
    r <@ XC.get(BytesCT.of_list x.`1, x.`2);
    return r;
  }
}.

module Htrw(Htr : DST.POracle3) = {
  proc get(p : BytesPK.t) : Bytes64.t = {
    var rho, t1, r;
    (rho, t1) <@ PkEncDec.pkDecode(p);
    r <@ Htr.get(rho, t1_of t1);
    return r;
  }
}.

module Hctw(Hct : DST.POracle5) = {
  proc get(w1 : polykvec, mu : Bytes64.t) : BytesCT.t = {
    var r;
    r <@ Hct.get(w1_key w1, mu);
    return r;
  }
}.

lemma dB_dword : Byte.dB = W8.dword.
proof. exact Byte.dB_dword. qed.

lemma highbits_shift_gen (c : int) :
  0 <= c < hb_range => highbits (2 * gamma2) (incoeff (c * (2 * gamma2))) = c.
proof.
move=> hc; have hq := hb_rangeE; have hg2 := ge2_gamma2.
have hle : c * (2 * gamma2) <= (hb_range - 1) * (2 * gamma2) by apply StdOrder.IntOrder.ler_wpmul2r; smt().
have hx : asint (incoeff (c * (2 * gamma2))) = c * (2 * gamma2) by rewrite incoeffK modz_small; smt().
rewrite /highbits /rightshift /round /lowbits hx ifF; 1: smt().
rewrite /cmod /mod_to_cmod /= modzMl /= ifT; 1: smt().
by rewrite incoeff0 ZModpRing.subr0 hx mulzK /#.
qed.

lemma highbits_shift (c : int) : 0 <= c <= 15 => highbits (2 * gamma2) (incoeff (c * (2 * gamma2))) = c.
proof. by move=> hc; apply highbits_shift_gen; smt(hb_range_cases). qed.

lemma w1_img_gen (p : poly) :
  (forall j, 0 <= j < n => asint p.[j] < hb_range) =>
  Supplementary.image (poly_highbits (2 * gamma2)) (map asint (Array256.to_list p)).
proof.
move=> hp; exists (poly2alg (Array256.map (fun c => incoeff (asint c * (2 * gamma2))) p)).
rewrite /poly_highbits; apply (eq_from_nth 0); 1: by rewrite size_mkseq size_map Array256.size_to_list.
move=> i; rewrite size_mkseq => hi.
rewrite nth_mkseq 1:/# /= (nth_map witness) ?Array256.size_to_list 1:/# Array256.get_to_list poly2algiE 1:/#
        Array256.mapiE 1:/# /= highbits_shift_gen //; smt(ge0_asint).
qed.

lemma w1_img (p : poly) :
  (forall j, 0 <= j < n => asint p.[j] <= 15) =>
  Supplementary.image (poly_highbits (2 * gamma2)) (map asint (Array256.to_list p)).
proof. by move=> hp; apply w1_img_gen => j hj; smt(hb_range_cases). qed.

lemma w1_key_nth (w : polykvec) i :
  0 <= i < kvec => nth witness (w1_key w) i = DV.HL.S.insubd (map asint (Array256.to_list w.[i])).
proof.
by move=> hi; rewrite /w1_key (nth_map witness witness (fun (p : poly) => DV.HL.S.insubd (map asint (Array256.to_list p))))
             ?KArray.size_to_list // KArray.get_to_list.
qed.

lemma w1_key_inj (w w' : polykvec) : w1rng w => w1rng w' => w1_key w = w1_key w' => w = w'.
proof.
move=> hw hw' heq; apply KArray.ext_eq => i hi.
have h : nth witness (w1_key w) i = nth witness (w1_key w') i by rewrite heq.
move: h; rewrite !w1_key_nth // => /(congr1 DV.HL.S.val); rewrite !DV.HL.S.insubdK.
+ by apply w1_img_gen => j hj; exact: hw i j hi hj.
+ by apply w1_img_gen => j hj; exact: hw' i j hi hj.
move=> h2; apply Array256.ext_eq => j hj.
have : nth 0 (map asint (Array256.to_list w.[i])) j = nth 0 (map asint (Array256.to_list w'.[i])) j by rewrite h2.
rewrite (nth_map witness 0 asint) ?Array256.size_to_list // (nth_map witness 0 asint) ?Array256.size_to_list //
        !Array256.get_to_list.
by apply asint_inj.
qed.

lemma xa_key_inj (x y : W8.t list * int) :
  size x.`1 = 34 => size y.`1 = 34 => xa_key x = xa_key y => x = y.
proof.
case: x => x1 x2; case: y => y1 y2 /= hx hy; rewrite /xa_key /=.
move=> -[[h1 [h2 h3]] ->] /=.
apply (eq_from_nth W8.zero); 1: by rewrite hx hy.
move=> i; rewrite hx => hi.
case: (i < 32) => hi32.
+ have := congr1 Bytes32.to_list _ _ h1; rewrite !Bytes32.of_listK ?size_take ?hx ?hy // => ht.
  by rewrite -(nth_take W8.zero 32) // ht nth_take.
have [->|->] : i = 32 \/ i = 33 by smt().
+ by rewrite -(W8.to_uintK (nth W8.zero x1 32)) h3 W8.to_uintK.
by rewrite -(W8.to_uintK (nth W8.zero x1 33)) h2 W8.to_uintK.
qed.

op pk_t1 (p : BytesPK.t) : polykvec =
  KArray.init (fun i => SimpleBitUnpack (take ((n * (q_bits - d)) %/ 8)
                          (drop (((n * (q_bits - d)) %/ 8) * i + 32) (BytesPK.to_list p))) (2 ^ (q_bits - d) - 1)).

op pk_dec (p : BytesPK.t) : MP.T.PK = (Bytes32.of_list (take 32 (BytesPK.to_list p)), t1_of (pk_t1 p)).

op pk_enc (pk : MP.T.PK) : BytesPK.t =
  BytesPK.of_list (Bytes32.to_list pk.`1 ++
                   flatten (map (fun p => SimpleBitPack p (2 ^ (q_bits - d) - 1)) (KArray.to_list (poly_of_t1 pk.`2)))).

lemma t1_ofK (t : polykvec) : poly_of_t1 (t1_of t) = t.
proof.
apply KArray.ext_eq => i hi; apply Array256.ext_eq => j hj.
rewrite /poly_of_t1 /t1_of KArray.initiE // Array256.initiE //= (nth_map witness) ?KArray.size_to_list //
        KArray.get_to_list (nth_map witness) ?Array256.size_to_list // Array256.get_to_list.
by rewrite asintK.
qed.

lemma pk_encK (p : BytesPK.t) : pk_enc (pk_dec p) = p.
proof.
rewrite /pk_enc /pk_dec /= t1_ofK.
have /= H := param_sets.
have hsz : size (BytesPK.to_list p) = 32 + 320 * kvec by rewrite BytesPK.size_to_list; smt().
have hb : RealExp.ilog 2 1023 + 1 = 10 by rewrite (_ : RealExp.ilog 2 1023 = 9) // RealExp.ilog_eq.
rewrite Bytes32.of_listK; 1: by rewrite size_take // hsz; smt(gt0_k).
have -> : map (fun (p0 : poly) => SimpleBitPack p0 1023) (KArray.to_list (pk_t1 p)) =
          BitEncoding.BitChunking.chunk 320 (drop 32 (BytesPK.to_list p)).
+ apply (eq_from_nth []).
  - by rewrite size_map KArray.size_to_list BitEncoding.BitChunking.size_chunk // size_drop // hsz; smt(gt0_k).
  move=> i; rewrite size_map KArray.size_to_list => hi.
  rewrite (nth_map witness [] (fun (p0 : poly) => SimpleBitPack p0 1023)) ?KArray.size_to_list //
          KArray.get_to_list /pk_t1 KArray.initiE //=.
  rewrite /BitEncoding.BitChunking.chunk nth_mkseq; 1: by rewrite size_drop // hsz; smt().
  rewrite /= drop_drop 1,2:/#.
  by apply SimpleBitUnpackK => //; rewrite ?hb // size_take // size_drop 1:/# hsz; smt().
rewrite BitEncoding.BitChunking.chunkK // ?size_drop // ?hsz.
+ by rewrite (_ : max 0 (32 + 320 * kvec - 32) = 320 * kvec); [smt(gt0_k) | apply dvdz_mulr].
by rewrite cat_take_drop BytesPK.to_listK.
qed.

lemma pk_dec_inj (p p' : BytesPK.t) : pk_dec p = pk_dec p' => p = p'.
proof. by move=> h; rewrite -(pk_encK p) -(pk_encK p') h. qed.

(*************** G11 and G12 ****************)

op rel_xa (m5 : (W8.t list * int, W8.t) fmap) (mt : ((Bytes32.t * int * int) * int, W8.t) fmap)
          (mr : (W8.t list * int, W8.t) fmap) : bool =
  forall x, m5.[x] = if size x.`1 = 34 then mt.[xa_key x] else mr.[x].

equiv xa_get_w : DS5.RO1.RO.get ~ XAw(DST.RO1.RO).get :
  ={x} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}
  ==> ={res} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}.
proof.
proc; inline *; if{2}.
+ wp; rnd; auto => />.
  move=> &1 &2 hr hs; rewrite dB_dword /= => rL _.
  have he := hr x{2}; rewrite hs /= in he.
  split; 1: exact W8.dword_fu.
  move=> _; split => hin; split => hin'.
  - rewrite !get_set_sameE /= => y; rewrite !get_setE; case: (y = x{2}) => [->|hne] /=; 1: by rewrite hs.
    case: (size y.`1 = 34) => hy /=; 2: by have := hr y; rewrite hy.
    have hk : xa_key y <> xa_key x{2} by smt(xa_key_inj).
    rewrite hk /=.
    by have := hr y; rewrite hy.
  - smt(domE).
  - smt(domE).
  by rewrite he.
wp; rnd; auto => /> &1 &2 hr hs rL _.
have he := hr x{2}; rewrite hs /= in he.
split => hin; split => hin'.
- rewrite !get_set_sameE /= => y; rewrite !get_setE; case: (y = x{2}) => [->|hne] /=; 1: by rewrite hs.
  by have := hr y.
- smt(domE).
- smt(domE).
by rewrite he.
qed.

op rel_xc (m5 : (W8.t list * int, W8.t) fmap) (mt : (BytesCT.t * int, W8.t) fmap) : bool =
  forall x, m5.[x] = if size x.`1 = lambda %/ 4 then mt.[(BytesCT.of_list x.`1, x.`2)] else None.

equiv xc_get : RO_xc.RO.get ~ XCw(DST.RO2.RO).get :
  ={x} /\ size x{1}.`1 = lambda %/ 4 /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}
  ==> ={res} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}.
proof.
proc; inline *; wp; rnd; auto => />.
move=> &1 &2 hs hr; rewrite dB_dword /= => rL _.
have he := hr x{2}; rewrite hs /= in he.
split; 1: exact W8.dword_fu.
move=> _; split => hin; split => hin'.
- rewrite !get_set_sameE /= => y; rewrite !get_setE; case: (y = x{2}) => [->|hne] /=; 1: by rewrite hs.
  case: (size y.`1 = lambda %/ 4) => hy /=; 2: by have := hr y; rewrite hy.
  have hk : (BytesCT.of_list y.`1, y.`2) <> (BytesCT.of_list x{2}.`1, x{2}.`2) by smt(BytesCT.of_listK).
  rewrite ifF; 1: smt().
  by have := hr y; rewrite hy.
- smt(domE).
- smt(domE).
by rewrite he.
qed.

op rel_tr (m5 : (BytesPK.t, Bytes64.t) fmap) (mt : (MP.T.PK, Bytes64.t) fmap) : bool =
  forall p, m5.[p] = mt.[pk_dec p].

equiv tr_get : DS5.RO3.RO.get ~ Htrw(DST.RO3.RO).get :
  x{1} = p{2} /\ rel_tr DS5.RO3.RO.m{1} DST.RO3.RO.m{2}
  ==> ={res} /\ rel_tr DS5.RO3.RO.m{1} DST.RO3.RO.m{2}.
proof.
proc.
seq 0 1 : (x{1} = p{2} /\ (rho, t1_of t1){2} = pk_dec p{2} /\ rel_tr DS5.RO3.RO.m{1} DST.RO3.RO.m{2}).
+ by ecall{2} (pkDecode_corr p{2}); auto => /> &1 &2 _ r -> ->.
inline *; wp; rnd; auto => />.
move=> &1 &2 ht hr rL _.
have hk : (Bytes32.of_list (take 32 (BytesPK.to_list p{2})), t1_of t1{2}) = pk_dec p{2} by rewrite /pk_dec /= -ht.
rewrite !hk.
have he := hr p{2}.
split => hin; split => hin'.
- rewrite !get_set_sameE /= => y; rewrite !get_setE; case: (y = p{2}) => [-> //|hne].
  rewrite ifF; 1: smt(pk_dec_inj).
  exact hr.
- smt(domE).
- smt(domE).
by rewrite he.
qed.

op rel_ct (m5 : (polykvec * Bytes64.t, BytesCT.t) fmap) (mt : (DV.HL.S.sT list * Bytes64.t, BytesCT.t) fmap) : bool =
  forall w1 mu, w1rng w1 => m5.[(w1, mu)] = mt.[(w1_key w1, mu)].

equiv ct_get : DS10.RO5.RO.get ~ Hctw(DST.RO5.RO).get :
  x{1} = (w1{2}, mu{2}) /\ w1rng w1{2} /\ rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}
  ==> ={res} /\ rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}.
proof.
proc; inline *; wp; rnd; auto => /> &1 &2 hw hr rL _.
have he := hr w1{2} mu{2} hw.
split => hin; split => hin'.
- rewrite !get_set_sameE /= => w m hw'; rewrite !get_setE.
  case: (w = w1{2} /\ m = mu{2}) => [[-> ->] /= // | hne].
  have hk : w1_key w <> w1_key w1{2} \/ m <> mu{2} by smt(w1_key_inj).
  rewrite ifF; 1: smt().
  rewrite ifF; 1: smt().
  by apply hr.
- smt(domE).
- smt(domE).
by rewrite he.
qed.

equiv xofa_next : XOFA_O(DS5.RO1.RO).next ~ XOFA_O(XAw(DST.RO1.RO)).next :
  ={glob XOFA_O} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}
  ==> ={res, glob XOFA_O} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}.
proof. by proc; wp; call xa_get_w; wp; call xa_get_w; wp; call xa_get_w; auto. qed.

equiv expandA_eq : ExpandA(XOFA_O(DS5.RO1.RO)).sample ~ ExpandA(XOFA_O(XAw(DST.RO1.RO))).sample :
  ={rho, glob XOFA_O} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}
  ==> ={res, glob XOFA_O} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}.
proof.
proc; while (={r, aa, rho, glob XOFA_O} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}); 2: by auto.
wp; while (={r, s, aa, rho, glob XOFA_O} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}); 2: by auto.
wp; call (: ={glob XOFA_O} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}); 2: by auto.
while (={j, c, glob XOFA_O} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2}); 1: by wp; call xofa_next; auto.
by inline *; auto.
qed.

equiv sib_eq : SampleInBall_B(RO_xc.RO).sample ~ SampleInBall_B(XCw(DST.RO2.RO)).sample :
  ={rho} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2} ==> ={res} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}.
proof.
proc.
while (={i, c, h, pos, leak, rho} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}).
+ wp; while (={i, j, pos, leak, rho} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}).
  - by wp; call xc_get; auto => />; rewrite BytesCT.size_to_list.
  by wp; call xc_get; auto => />; rewrite BytesCT.size_to_list.
wp; call (: ={x, len} /\ size x{1} = lambda %/ 4 /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}
            ==> ={res} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}).
+ proc; while (={r, i, x, len} /\ size x{1} = lambda %/ 4 /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}); 2: by auto.
  by wp; call xc_get; auto.
by auto => />; rewrite BytesCT.size_to_list.
qed.

equiv keygen_12 :
  MLDSA_RO_DS11(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).keygen ~
  MLDSA_RO_DS11(XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO)).keygen :
  ={glob XOFA_O} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\ rel_tr DS5.RO3.RO.m{1} DST.RO3.RO.m{2}
  ==> ={res, glob XOFA_O, RO_y.RO.m} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\
      rel_tr DS5.RO3.RO.m{1} DST.RO3.RO.m{2}.
proof.
proc; call tr_get; wp; call (: true); 1: by sim.
wp; rnd; rnd; call expandA_eq; inline RO_y.RO.init; auto.
qed.

equiv sign_12 :
  MLDSA_RO_DS11(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).sign ~
  MLDSA_RO_DS11(XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO)).sign :
  ={sk, m, glob XOFA_O, RO_y.RO.m} /\ DS5.RO4.RO.m{1} = DST.RO4.RO.m{2} /\
  rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2} /\
  rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}
  ==> ={res, glob XOFA_O, RO_y.RO.m} /\ DS5.RO4.RO.m{1} = DST.RO4.RO.m{2} /\
      rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2} /\
      rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}.
proof.
proc.
seq 12 12 : (={coins, ct, ctl, sigma, leakage, rho, tr, s1, s2, t0, _A, mu, kappa, zh, glob XOFA_O, RO_y.RO.m} /\
             DS5.RO4.RO.m{1} = DST.RO4.RO.m{2} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\
             rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2} /\ rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}).
+ wp; call (: DS5.RO4.RO.m{1} = DST.RO4.RO.m{2}); 1: by auto.
  by call expandA_eq; auto.
seq 1 1 : (={zh, ct, sigma, leakage, glob XOFA_O, RO_y.RO.m} /\ DS5.RO4.RO.m{1} = DST.RO4.RO.m{2} /\
           rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2} /\
           rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}).
+ while (={coins, ct, ctl, sigma, leakage, s1, s2, t0, _A, mu, kappa, zh, glob XOFA_O, RO_y.RO.m} /\
         DS5.RO4.RO.m{1} = DST.RO4.RO.m{2} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\
         rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2} /\ rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}).
  - wp; call sib_eq; wp; call ct_get; wp; call (: ={RO_y.RO.m}); 1: by sim.
    by auto => /> *; apply hb_rng.
  by auto.
by if => //; wp; call (: true); [by sim | auto].
qed.

equiv verify_12 :
  MLDSA_RO_DS11(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO).verify ~
  MLDSA_RO_DS11(XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO)).verify :
  ={pk, m, sigma, glob XOFA_O} /\ DS5.RO4.RO.m{1} = DST.RO4.RO.m{2} /\
  rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2} /\
  rel_tr DS5.RO3.RO.m{1} DST.RO3.RO.m{2} /\ rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}
  ==> ={res}.
proof.
proc.
seq 4 4 : (={pk, m, rho, t1, ct, z, h, rb, w1, glob XOFA_O} /\ DS5.RO4.RO.m{1} = DST.RO4.RO.m{2} /\
           rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2} /\
           rel_tr DS5.RO3.RO.m{1} DST.RO3.RO.m{2} /\ rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}).
+ by call (: true); [by sim | call (: true); [by sim | auto]].
if => //.
wp; call ct_get.
wp; call sib_eq.
call (: DS5.RO4.RO.m{1} = DST.RO4.RO.m{2}); 1: by auto.
call tr_get.
call expandA_eq.
by auto => /> *; apply uh_rng.
qed.

equiv hctroute_12 : HctRoute(DS10.RO5.RO).get ~ HctRoute(Hctw(DST.RO5.RO)).get :
  ={mu, b, RO_hr.RO.m} /\ rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}
  ==> ={res, RO_hr.RO.m} /\ rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}.
proof.
proc; if => //.
+ by call ct_get; auto => /> &1 &2 _ [_ ->].
by call (: ={RO_hr.RO.m}); [by sim | auto].
qed.

equiv blockof_12 : BlockOf(RO_xc.RO).get ~ BlockOf(XCw(DST.RO2.RO)).get :
  ={x} /\ size x{1}.`1 = lambda %/ 4 /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}
  ==> ={res} /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}.
proof.
proc; while (={i, bs, x} /\ size x{1}.`1 = lambda %/ 4 /\ rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2}); 2: by auto.
by wp; call xc_get; auto.
qed.

(*************** G12: G11 over the oracles of the target ****************)

module G12(A : DS2.Adversary) = {
  module O = {
    proc sign(m : W8.t list) : BytesSig.t option * leakage = {
      var r;
      DS11.EUF_CMA.qs <- m :: DS11.EUF_CMA.qs;
      r <@ MLDSA_RO_DS11(XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                         Hctw(DST.RO5.RO)).sign(DS11.EUF_CMA.sk, m);
      return r;
    }
  }

  proc main() : bool = {
    var pk, m, s, b;
    DST.RO1.RO.init();
    RO_xr.RO.init();
    DST.RO2.RO.init();
    DST.RO3.RO.init();
    DST.RO4.RO.init();
    DST.RO5.RO.init();
    DS11.EUF_CMA.qs <- [];
    (pk, DS11.EUF_CMA.sk) <@ MLDSA_RO_DS11(XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                                           Hctw(DST.RO5.RO)).keygen();
    (m, s) <@ Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                       Hctw(DST.RO5.RO), O).forge(pk);
    b <@ MLDSA_RO_DS11(XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO,
                       Hctw(DST.RO5.RO)).verify(pk, m, s);
    return b /\ !(m \in DS11.EUF_CMA.qs);
  }
}.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO1.RO, -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -DS5.EUF_CMA, -RO_rest.RO,
  -RO_pad.RO, -RO_pad.FRO, -RO_seed.RO, -RO_S.RO, -RO_rhopp.RO, -RO_v.RO, -CountH, -CountS, -St5,
  -RO_lp.RO, -RO_lp.FRO, -St6, -St7, -Router, -RO_y.RO, -DS8.EUF_CMA, -DS10.EUF_CMA, -DS10.RO5.RO,
  -RO_hr.RO, -Router10, -DS11.EUF_CMA, -RO_xc.RO, -RO_xc.FRO, -Router11, -DST.RO1.RO, -DST.RO2.RO,
  -DST.RO3.RO, -DST.RO4.RO, -DST.RO5.RO, -DST.EUF_CMA, -RO_xr.RO }.

lemma G11_G12 &m :
  Pr[DS11.EUF_CMA(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS11, Router11(A)).main()
       @ &m : res] =
  Pr[G12(A).main() @ &m : res].
proof.
byequiv (: ={glob A, glob XOFA_O} ==> ={res}) => //.
proc.
inline{1} DS11.EUF_CMA(DS5.RO1.RO, RO_xc.RO, DS5.RO3.RO, DS5.RO4.RO, DS10.RO5.RO, MLDSA_RO_DS11, Router11(A)).A.forge.
inline{2} Router11(A, XAw(DST.RO1.RO), XCw(DST.RO2.RO), Htrw(DST.RO3.RO), DST.RO4.RO, Hctw(DST.RO5.RO), G12(A).O).forge.
wp; call verify_12.
wp; call (: ={RO_pad.RO.m, RO_rest.RO.m, RO_hr.RO.m, glob XOFA_O, RO_y.RO.m, Router11.tr, DS11.EUF_CMA.qs,
              DS11.EUF_CMA.sk} /\
            DS5.RO4.RO.m{1} = DST.RO4.RO.m{2} /\ rel_xa DS5.RO1.RO.m{1} DST.RO1.RO.m{2} RO_xr.RO.m{2} /\
            rel_xc RO_xc.RO.m{1} DST.RO2.RO.m{2} /\ rel_tr DS5.RO3.RO.m{1} DST.RO3.RO.m{2} /\
            rel_ct DS10.RO5.RO.m{1} DST.RO5.RO.m{2}).
+ by proc; call sign_12; auto.
+ by proc*; call xa_get_w; auto.
+ proc; sp; if => //.
  - if => //.
    + by wp; call (: DS5.RO4.RO.m{1} = DST.RO4.RO.m{2}); [by auto | auto].
    by call (: ={RO_rest.RO.m}); [by sim | auto].
  if => //.
  - if => //.
    + wp; call (: ={RO_pad.RO.m}); 1: by sim.
      by wp; call hctroute_12; auto.
    by call (: ={RO_rest.RO.m}); [by sim | auto].
  if => //.
  - by call blockof_12; auto.
  if => //.
  - by wp; call tr_get; auto.
  by call (: ={RO_rest.RO.m}); [by sim | auto].
call tr_get.
inline{1} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; inline{2} RO_rest.RO.init RO_pad.RO.init RO_hr.RO.init; wp.
call keygen_12.
inline *; auto => />.
by rewrite /rel_xa /rel_tr /rel_xc /rel_ct; smt(emptyE).
qed.

end section.

end MLDSA_ROSep_Hop12.
