require import AllCore IntDiv List Distr DList PROM FMap Xreal StdBigop StdOrder.
from Jasmin require import JByte_array JWord.
require import Array256.

require import Parameters GFq Rq.
require import Spec65.
import MLDSA65.
import PolyLVec PolyKVec PolyMat.
import Round ZModQ Zq MLDSAParams.

require import MLDSA_RO MLDSA_ROSep MLDSA_ROSep_Hop1.
require import FMapExtra.
require import JWordExtra.

(*************** G1: SHAKE256 routed to separate random oracles ****************)

(* Setting tr re-routes the block-0 inputs that begin with tr to Hmu *)
op hit (tr : Bytes64.t) (pk : W8.t list) (mrest : (W8.t list * int, W8.t list) fmap) : bool =
     take 64 pk = Bytes64.to_list tr
  \/ exists y, y \in mrest /\ y.`2 = 0 /\ take 64 y.`1 = Bytes64.to_list tr.

(* tr is fixed by the first H_tr-shaped query, which is the one of key generation *)
module RoutedH = {
  var tr : Bytes64.t
  var trset : bool
  var bad : bool

  proc init() : unit = {
    DS5.RO2.RO.init();
    DS5.RO3.RO.init();
    DS5.RO4.RO.init();
    DS5.RO5.RO.init();
    RO_rest.RO.init();
    RO_pad.RO.init();
    tr <- witness;
    trset <- false;
    bad <- false;
  }

  proc get(x : W8.t list * int) : W8.t list = {
    var b, o, oc, pad;
    b <- witness;
    if (trset /\ take 64 x.`1 = Bytes64.to_list tr) {
      if (x.`2 = 0) {
        o <@ DS5.RO4.RO.get(tr, drop 64 x.`1);
        b <- Bytes64.to_list o;
      } else {
        b <@ RO_rest.RO.get(x);
      }
    } else {
      if (size x.`1 = 64 + w1_bytes) {
        if (x.`2 = 0) {
          oc <@ DS5.RO5.RO.get(Bytes64.of_list (take 64 x.`1), BytesW1.of_list (drop 64 x.`1));
          pad <@ RO_pad.RO.get(x.`1);
          b <- BytesCT.to_list oc ++ pad;
        } else {
          b <@ RO_rest.RO.get(x);
        }
      } else {
        if (size x.`1 = lambda %/ 4) {
          b <@ DS5.RO2.RO.get(x);
        } else {
          if (size x.`1 = pk_bytes /\ x.`2 = 0) {
            o <@ DS5.RO3.RO.get(BytesPK.of_list x.`1);
            b <- Bytes64.to_list o;
            if (!trset) {
              bad <- hit o x.`1 RO_rest.RO.m;
              tr <- o;
              trset <- true;
            }
          } else {
            b <@ RO_rest.RO.get(x);
          }
        }
      }
    }
    return b;
  }
}.

(* The single SHAKE256 map, as seen through the routing *)
op view (trset : bool) (tr : Bytes64.t)
        (mtr : (BytesPK.t, Bytes64.t) fmap)
        (mmu : (Bytes64.t * W8.t list, Bytes64.t) fmap)
        (mct : (Bytes64.t * BytesW1.t, BytesCT.t) fmap)
        (mxc : (W8.t list * int, W8.t list) fmap)
        (mrest : (W8.t list * int, W8.t list) fmap)
        (mpad : (W8.t list, W8.t list) fmap)
        (x : W8.t list * int) : W8.t list option =
  if trset /\ take 64 x.`1 = Bytes64.to_list tr then
    (if x.`2 = 0 then omap Bytes64.to_list mmu.[(tr, drop 64 x.`1)] else mrest.[x])
  else if size x.`1 = 64 + w1_bytes then
    (if x.`2 = 0
     then omap (fun c => BytesCT.to_list c ++ oget mpad.[x.`1])
               mct.[(Bytes64.of_list (take 64 x.`1), BytesW1.of_list (drop 64 x.`1))]
     else mrest.[x])
  else if size x.`1 = lambda %/ 4 then mxc.[x]
  else if size x.`1 = pk_bytes /\ x.`2 = 0 then omap Bytes64.to_list mtr.[BytesPK.of_list x.`1]
  else mrest.[x].

op inv_view (m0 : (W8.t list * int, W8.t list) fmap) (trset : bool) (tr : Bytes64.t)
            (mtr : (BytesPK.t, Bytes64.t) fmap)
            (mmu : (Bytes64.t * W8.t list, Bytes64.t) fmap)
            (mct : (Bytes64.t * BytesW1.t, BytesCT.t) fmap)
            (mxc : (W8.t list * int, W8.t list) fmap)
            (mrest : (W8.t list * int, W8.t list) fmap)
            (mpad : (W8.t list, W8.t list) fmap) : bool =
     (forall x, m0.[x] = view trset tr mtr mmu mct mxc mrest mpad x)
  /\ (forall l, size l = 64 + w1_bytes =>
        (l \in mpad <=> (Bytes64.of_list (take 64 l), BytesW1.of_list (drop 64 l)) \in mct)).

(* Updating the map behind one routed input changes the view at that input only *)

lemma view_mu trset tr mtr (mmu : (Bytes64.t * W8.t list, Bytes64.t) fmap) mct mxc mrest mpad
              (x : W8.t list * int) (o : Bytes64.t) :
  trset => take 64 x.`1 = Bytes64.to_list tr => x.`2 = 0 =>
  forall y, view trset tr mtr mmu.[(tr, drop 64 x.`1) <- o] mct mxc mrest mpad y =
            if y = x then Some (Bytes64.to_list o)
            else view trset tr mtr mmu mct mxc mrest mpad y.
proof.
move=> ht hp h0 y; rewrite /view get_setE; case: (y = x) => [->> | hne] /=; 1: by rewrite ht hp h0.
case: (trset /\ take 64 y.`1 = Bytes64.to_list tr) => // -[_ hpy].
case: (y.`2 = 0) => // hy0; case: (drop 64 y.`1 = drop 64 x.`1) => // hd.
have heq : y = x; 2: by move: hne; rewrite heq.
by move: hpy hy0 hd hp h0; clear hne; case: y => y1 y2; case: x => x1 x2 /= hpy -> hd hp ->;
   rewrite -(cat_take_drop 64 y1) -(cat_take_drop 64 x1) hpy hp hd.
qed.

lemma view_rest trset tr mtr mmu mct mxc (mrest : (W8.t list * int, W8.t list) fmap) mpad
                (x : W8.t list * int) (v : W8.t list) :
  (forall m', view trset tr mtr mmu mct mxc m' mpad x = m'.[x]) =>
  forall y, view trset tr mtr mmu mct mxc mrest.[x <- v] mpad y =
            if y = x then Some v else view trset tr mtr mmu mct mxc mrest mpad y.
proof.
by move=> hx y; case: (y = x) => [->> | hne] /=;
   [rewrite hx get_set_sameE | rewrite /view !get_setE hne].
qed.

lemma view_xc trset tr mtr mmu mct (mxc : (W8.t list * int, W8.t list) fmap) mrest mpad
              (x : W8.t list * int) (v : W8.t list) :
  (forall m', view trset tr mtr mmu mct m' mrest mpad x = m'.[x]) =>
  forall y, view trset tr mtr mmu mct mxc.[x <- v] mrest mpad y =
            if y = x then Some v else view trset tr mtr mmu mct mxc mrest mpad y.
proof.
by move=> hx y; case: (y = x) => [->> | hne] /=;
   [rewrite hx get_set_sameE | rewrite /view !get_setE hne].
qed.

lemma view_tr trset tr (mtr : (BytesPK.t, Bytes64.t) fmap) mmu mct mxc mrest mpad
              (x : W8.t list * int) (o : Bytes64.t) :
  (forall m', view trset tr m' mmu mct mxc mrest mpad x =
              omap Bytes64.to_list m'.[BytesPK.of_list x.`1]) =>
  size x.`1 = pk_bytes => x.`2 = 0 =>
  forall y, view trset tr mtr.[BytesPK.of_list x.`1 <- o] mmu mct mxc mrest mpad y =
            if y = x then Some (Bytes64.to_list o)
            else view trset tr mtr mmu mct mxc mrest mpad y.
proof.
move=> hx hs h0 y; case: (y = x) => [->> | hne] /=; 1: by rewrite hx get_set_sameE.
by rewrite /view get_setE; smt(BytesPK.of_listK).
qed.

lemma view_ct trset tr mtr mmu (mct : (Bytes64.t * BytesW1.t, BytesCT.t) fmap) mxc mrest
              (mpad : (W8.t list, W8.t list) fmap) (x : W8.t list * int) (oc : BytesCT.t)
              (pad : W8.t list) :
  (forall mct' mpad', view trset tr mtr mmu mct' mxc mrest mpad' x =
     omap (fun c => BytesCT.to_list c ++ oget mpad'.[x.`1])
          mct'.[(Bytes64.of_list (take 64 x.`1), BytesW1.of_list (drop 64 x.`1))]) =>
  size x.`1 = 64 + w1_bytes => x.`2 = 0 =>
  forall y, view trset tr mtr mmu
                 mct.[(Bytes64.of_list (take 64 x.`1), BytesW1.of_list (drop 64 x.`1)) <- oc]
                 mxc mrest mpad.[x.`1 <- pad] y =
            if y = x then Some (BytesCT.to_list oc ++ pad)
            else view trset tr mtr mmu mct mxc mrest mpad y.
proof.
move=> hx hs h0 y; case: (y = x) => [->> | hne] /=; 1: by rewrite hx !get_set_sameE.
have hinj : forall l, size l = 64 + w1_bytes =>
              Bytes64.of_list (take 64 l) = Bytes64.of_list (take 64 x.`1) =>
              BytesW1.of_list (drop 64 l) = BytesW1.of_list (drop 64 x.`1) => l = x.`1.
+ move=> l hl h1 h2; have hw := w1_bytes_big.
  have := congr1 Bytes64.to_list _ _ h1; have := congr1 BytesW1.to_list _ _ h2.
  rewrite !BytesW1.of_listK; 1,2: by rewrite size_drop /#.
  rewrite !Bytes64.of_listK; 1,2: by rewrite size_take /#.
  by move=> e2 e1; rewrite -(cat_take_drop 64 l) e1 e2 cat_take_drop.
by rewrite /view !get_setE; smt().
qed.

(* Once tr is set, the single map and the routed maps answer every query alike *)
equiv get_set : DS2.RO1.RO.get ~ RoutedH.get :
  ={x} /\ RoutedH.trset{2} /\
  inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
           DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ RoutedH.trset{2} /\
      inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
               DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
proc; sp 0 1; if{2}.
+ if{2}; inline *; wp.
  + rnd Bytes64.of_list Bytes64.to_list; auto => &1 &2 /> htrs hv hpad hp h0.
    split => [o _ | _ rL hrL]; 1: by rewrite mu1_dbytes64.
    have hs : size rL = 64 by move: hrL; rewrite /dblock supp_dlist //; smt().
    have hk : DS2.RO1.RO.m{1}.[x{2}] =
              omap Bytes64.to_list DS5.RO4.RO.m{2}.[(RoutedH.tr{2}, drop 64 x{2}.`1)].
    + by rewrite hv /view hp h0.
    have hvu := view_mu true RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                  DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2} x{2} (Bytes64.of_list rL)
                  _ hp h0 => //.
    rewrite Bytes64.of_listK //=; split; 1: by rewrite /dbytes64 supp_dmap; exists rL.
    move=> _; split => hmu; split => hx.
    + rewrite !get_set_sameE /= Bytes64.of_listK //=.
      by move=> x1; rewrite get_setE hvu Bytes64.of_listK // -hv.
    + smt(domE).
    + by move: hx; rewrite domE hk; move: hmu; rewrite domE;
         case: (DS5.RO4.RO.m{2}.[(RoutedH.tr{2}, drop 64 x{2}.`1)]).
    by rewrite hk; move: hmu; rewrite domE;
       case: (DS5.RO4.RO.m{2}.[(RoutedH.tr{2}, drop 64 x{2}.`1)]).
  + rnd; auto => &1 &2 /> htrs hv hpad hp h0 rL hrL.
    have hk : DS2.RO1.RO.m{1}.[x{2}] = RO_rest.RO.m{2}.[x{2}] by rewrite hv /view hp h0.
    have hvu := view_rest true RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                  DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2} x{2} rL _.
    + by move=> m'; rewrite /view hp h0.
    split => hr; split => hx.
    + by rewrite !get_set_sameE /= => x1; rewrite get_setE hvu -hv.
    + by move: hx; rewrite domE hk; move: hr; rewrite domE.
    + by move: hx; rewrite domE hk; move: hr; rewrite domE.
    by rewrite hk.
if{2}; [if{2}; [inline * | ] | ].
+ swap{2} 6 -3.
  seq 1 3 : (#pre /\
             x0{2} = (Bytes64.of_list (take 64 x{2}.`1), BytesW1.of_list (drop 64 x{2}.`1)) /\
             r{1} = BytesCT.to_list r{2} ++ r0{2}).
  + sp 0 1; rndsem*{2} 0.
    rnd (fun (l : W8.t list) => (BytesCT.of_list (take (lambda %/ 4) l), drop (lambda %/ 4) l))
        (fun (p : BytesCT.t * W8.t list) => BytesCT.to_list p.`1 ++ p.`2).
    skip => &1 &2 /> *.
    have hd : dlet dbytesCT (fun (r1 : BytesCT.t) =>
                dmap (dlist W8.dword (64 - lambda %/ 4)) (fun (r0 : W8.t list) => (r1, r0))) =
              dbytesCT `*` dlist W8.dword (64 - lambda %/ 4).
    + by rewrite -(dmap_id (dbytesCT `*` _)) dmap_dprodE.
    have hdl : forall n (xs : W8.t list), 0 <= n => size xs = n =>
                 mu1 (dlist W8.dword n) xs = (1%r / 256%r) ^ n.
    + move=> n xs hn hs; rewrite dlist1E // hs /= (Bigreal.BRM.eq_bigr _ _ (fun _ => 1%r / 256%r)) /=.
      + by move=> w *; rewrite DW8.mu1_dword.
      by rewrite Bigreal.mulr_const hs.
    have hl : 0 < lambda %/ 4 <= 64 by have /= H := param_sets; smt().
    rewrite hd; split => [[c p] | hinv].
    + by move=> _ /=; rewrite take_size_cat ?BytesCT.size_to_list // drop_size_cat
                             ?BytesCT.size_to_list // BytesCT.to_listK.
    split => [[c p] hcp | _ rL hrL].
    + move: hcp; rewrite supp_dprod /= supp_dlist 1:/# => -[_ [hp _]].
      rewrite dprod1E /dbytesCT (dmap1E_can _ _ BytesCT.to_list);
        [exact BytesCT.to_listK |
         by move=> l; rewrite supp_dlist 1:/# => -[hs _]; rewrite BytesCT.of_listK | ].
      rewrite /dblock (hdl 64) // 1:size_cat 1:BytesCT.size_to_list 1:/#
              (hdl (lambda %/ 4)) 1:/# 1:BytesCT.size_to_list //
              (hdl (64 - lambda %/ 4)) 1:/# 1:// -RField.exprD_nneg 1,2:/#.
      by congr; ring.
    have hs : size rL = 64 by move: hrL; rewrite /dblock supp_dlist //; smt().
    have htk : size (take (lambda %/ 4) rL) = lambda %/ 4 by rewrite size_take /#.
    rewrite BytesCT.of_listK // cat_take_drop /= supp_dprod /= /dbytesCT supp_dmap.
    have h1 : 0 <= lambda %/ 4 by smt().
    have h2 : 0 <= 64 - lambda %/ 4 by smt().
    split; 1: exists (take (lambda %/ 4) rL) => /=.
    + by rewrite supp_dlist // htk /=; apply/List.allP => w _; apply W8.dword_fu.
    by rewrite supp_dlist // size_drop // hs /=;
       split; [smt() | apply/List.allP => w _; apply W8.dword_fu].
  auto => &1 &2 /> htrs hv hpad hnp hs h0.
  have hk : DS2.RO1.RO.m{1}.[x{2}] =
            omap (fun c => BytesCT.to_list c ++ oget RO_pad.RO.m{2}.[x{2}.`1])
                 DS5.RO5.RO.m{2}.[(Bytes64.of_list (take 64 x{2}.`1),
                                   BytesW1.of_list (drop 64 x{2}.`1))].
  + by rewrite hv /view /= hnp /= hs h0.
  have hvu := view_ct true RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2} x{2} r{2} r0{2} _ hs h0.
  + by move=> mct' mpad'; rewrite /view /= hnp /= hs h0.
  have hinj : forall l, size l = 64 + w1_bytes =>
                (Bytes64.of_list (take 64 l), BytesW1.of_list (drop 64 l)) =
                (Bytes64.of_list (take 64 x{2}.`1), BytesW1.of_list (drop 64 x{2}.`1)) =>
                l = x{2}.`1.
  + move=> l hl /= [h1 h2]; have hw := w1_bytes_big.
    have := congr1 Bytes64.to_list _ _ h1; have := congr1 BytesW1.to_list _ _ h2.
    rewrite !BytesW1.of_listK; 1,2: by rewrite size_drop /#.
    rewrite !Bytes64.of_listK; 1,2: by rewrite size_take /#.
    by move=> e2 e1; rewrite -(cat_take_drop 64 l) e1 e2 cat_take_drop.
  have hpx := hpad x{2}.`1 hs; split => hkm; split => hpm; split => hx.
  + rewrite !get_set_sameE /=; split => [x2 | l hl]; 1: by rewrite get_setE hvu -hv.
    by rewrite !mem_set; have := hpad l hl; have := hinj l hl; smt().
  + by move: hx hkm; rewrite !domE hk;
       case: (DS5.RO5.RO.m{2}.[(Bytes64.of_list (take 64 x{2}.`1),
                                BytesW1.of_list (drop 64 x{2}.`1))]).
  + by move: hpx hkm; rewrite hpm.
  + by move: hpx hkm; rewrite hpm.
  + by move: hpx hpm; rewrite hkm.
  + by move: hpx hpm; rewrite hkm.
  + by move: hx hkm; rewrite !domE hk;
       case: (DS5.RO5.RO.m{2}.[(Bytes64.of_list (take 64 x{2}.`1),
                                BytesW1.of_list (drop 64 x{2}.`1))]).
  + by move: hkm; rewrite hk domE;
       case: (DS5.RO5.RO.m{2}.[(Bytes64.of_list (take 64 x{2}.`1),
                                BytesW1.of_list (drop 64 x{2}.`1))]).
+ inline *; wp; rnd; auto => &1 &2 /> htrs hv hpad hnp hs h0 rL hrL.
  have hk : DS2.RO1.RO.m{1}.[x{2}] = RO_rest.RO.m{2}.[x{2}] by rewrite hv /view /= hnp /= hs h0.
  have hvu := view_rest true RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2} x{2} rL _.
  + by move=> m'; rewrite /view /= hnp /= hs h0.
  split => hr; split => hx;
    [ by rewrite !get_set_sameE /= => x1; rewrite get_setE hvu -hv
    | by move: hx; rewrite domE hk; move: hr; rewrite domE
    | by move: hx; rewrite domE hk; move: hr; rewrite domE
    | by rewrite hk ].
if{2}; 1: (inline *; wp; rnd; auto => &1 &2 /> htrs hv hpad hnp hs hl rL hrL).
+ have hk : DS2.RO1.RO.m{1}.[x{2}] = DS5.RO2.RO.m{2}.[x{2}] by rewrite hv /view /= hnp /= hs hl.
  have hvu := view_xc true RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2} x{2} rL _.
  + by move=> m'; rewrite /view /= hnp /= hs hl.
  split => hr; split => hx;
    [ by rewrite !get_set_sameE /= => x1; rewrite get_setE hvu -hv
    | by move: hx; rewrite domE hk; move: hr; rewrite domE
    | by move: hx; rewrite domE hk; move: hr; rewrite domE
    | by rewrite hk ].
if{2}; 1: (rcondf{2} 3;
           [ by move=> &m; inline *; auto
           | inline *; wp; rnd Bytes64.of_list Bytes64.to_list;
             auto => &1 &2 /> htrs hv hpad hnp hs hl hpk h0;
             split => [o _ | _ rL hrL]; 1: by rewrite mu1_dbytes64 ]).
+ have hs64 : size rL = 64 by move: hrL; rewrite /dblock supp_dlist //; smt().
  have hk : DS2.RO1.RO.m{1}.[x{2}] = omap Bytes64.to_list DS5.RO3.RO.m{2}.[BytesPK.of_list x{2}.`1].
  + by rewrite hv /view /= hnp /= hs hl hpk h0.
  have hvu := view_tr true RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2} x{2} (Bytes64.of_list rL)
                _ hpk h0.
  + by move=> m'; rewrite /view /= hnp /= hs hl hpk h0.
  rewrite Bytes64.of_listK //=; split; 1: by rewrite /dbytes64 supp_dmap; exists rL.
  move=> _; split => hm; split => hx;
    [ by rewrite !get_set_sameE /= Bytes64.of_listK //= => x1; rewrite get_setE hvu Bytes64.of_listK // -hv
    | by move: hx; rewrite domE hk; move: hm; rewrite domE;
         case: (DS5.RO3.RO.m{2}.[BytesPK.of_list x{2}.`1])
    | by move: hx; rewrite domE hk; move: hm; rewrite domE;
         case: (DS5.RO3.RO.m{2}.[BytesPK.of_list x{2}.`1])
    | by rewrite hk; move: hm; rewrite domE; case: (DS5.RO3.RO.m{2}.[BytesPK.of_list x{2}.`1]) ].
inline *; wp; rnd; auto => &1 &2 /> htrs hv hpad hnp hs hl hpk rL hrL.
have hk : DS2.RO1.RO.m{1}.[x{2}] = RO_rest.RO.m{2}.[x{2}] by rewrite hv /view /= hnp /= hs hl /= hpk.
have hvu := view_rest true RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
              DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2} x{2} rL _.
+ by move=> m'; rewrite /view /= hnp /= hs hl /= hpk.
split => hr; split => hx;
  [ by rewrite !get_set_sameE /= => x1; rewrite get_setE hvu -hv
  | by move: hx; rewrite domE hk; move: hr; rewrite domE
  | by move: hx; rewrite domE hk; move: hr; rewrite domE
  | by rewrite hk ].
qed.

(* Before tr is set only RO_rest has been queried *)
op rest_ok (mrest : (W8.t list * int, W8.t list) fmap) : bool =
  forall y, y \in mrest =>
    size y.`1 <> 64 + w1_bytes /\ size y.`1 <> lambda %/ 4 /\ !(size y.`1 = pk_bytes /\ y.`2 = 0).

op inv_pre (m0 : (W8.t list * int, W8.t list) fmap)
           (mtr : (BytesPK.t, Bytes64.t) fmap)
           (mmu : (Bytes64.t * W8.t list, Bytes64.t) fmap)
           (mct : (Bytes64.t * BytesW1.t, BytesCT.t) fmap)
           (mxc : (W8.t list * int, W8.t list) fmap)
           (mrest : (W8.t list * int, W8.t list) fmap)
           (mpad : (W8.t list, W8.t list) fmap) : bool =
     (forall x, m0.[x] = mrest.[x])
  /\ mtr = empty /\ mmu = empty /\ mct = empty /\ mxc = empty /\ mpad = empty
  /\ rest_ok mrest.

equiv get_unset : DS2.RO1.RO.get ~ RoutedH.get :
  ={x} /\ !RoutedH.trset{2} /\
  size x{2}.`1 <> 64 + w1_bytes /\ size x{2}.`1 <> lambda %/ 4 /\
  !(size x{2}.`1 = pk_bytes /\ x{2}.`2 = 0) /\
  inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
          RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ !RoutedH.trset{2} /\
      inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
              RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
proc; sp 0 1; rcondf{2} 1; 1: by auto => /#.
rcondf{2} 1; 1: by auto => /#.
rcondf{2} 1; 1: by auto => /#.
rcondf{2} 1; 1: by auto => /#.
inline *; wp; rnd; auto => &1 &2 />.
move=> htrs hs hl hpk heq hro rL _; split => hr; split => hx;
  [ rewrite !get_set_sameE /=; split => [x1 | y];
      [by rewrite !get_setE heq | rewrite mem_set => -[/hro // | ->> /=]; smt()]
  | by move: hx hr; rewrite !domE heq
  | by move: hx hr; rewrite !domE heq
  | by rewrite heq ].
qed.

(* The H_tr query of key generation sets tr; bad unless the routing stays consistent *)
equiv get_tr : DS2.RO1.RO.get ~ RoutedH.get :
  ={x} /\ !RoutedH.trset{2} /\ size x{2}.`1 = pk_bytes /\ x{2}.`2 = 0 /\
  inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
          RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ RoutedH.trset{2} /\
      (!RoutedH.bad{2} =>
       inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
                DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}).
proof.
have hpkl : pk_bytes <> lambda %/ 4 by rewrite /pk_bytes; have /= H := param_sets; smt().
proc; sp 0 1; rcondf{2} 1; 1: by auto => /#.
rcondf{2} 1; 1: by auto => />; smt(pk_len_nrel).
rcondf{2} 1; 1: by auto => />; smt().
rcondt{2} 1; 1: by auto.
rcondt{2} 3; 1: by move=> &m; inline *; auto.
inline *; wp; rnd Bytes64.of_list Bytes64.to_list; auto => &1 &2 /> htrs hs h0 heq hro.
split => [o _ | _ rL hrL]; 1: by rewrite mu1_dbytes64.
have hs64 : size rL = 64 by move: hrL; rewrite /dblock supp_dlist //; smt().
have hx : x{2} \notin DS2.RO1.RO.m{1} by rewrite domE heq -domE; move: (hro x{2}); smt().
rewrite Bytes64.of_listK //= mem_empty hx /= !get_set_sameE /= Bytes64.of_listK //=.
split; 1: by rewrite /dbytes64 supp_dmap; exists rL.
move=> _ hnh; split => [y | l _]; 2: by rewrite !mem_empty.
move: hnh hro; rewrite /hit /rest_ok Bytes64.of_listK // negb_or negb_exists /= => -[hpk hrest] hro.
rewrite get_setE /view !emptyE get_setE heq /=.
rewrite Bytes64.of_listK // emptyE; case: (y = x{2}) => [->> | hne] /=.
+ by rewrite hpk /= hs h0 /= Bytes64.of_listK //; smt(pk_len_nrel).
case: (y \in RO_rest.RO.m{2}) => hy; 1: by have := hro y hy; have := hrest y; smt().
have -> : RO_rest.RO.m{2}.[y] = None by move: hy; rewrite domE.
case: (size y.`1 = 32 + 2560 * kvec %/ 8 /\ y.`2 = 0) => [[hsy hy0] | _];
  2: by case: (take 64 y.`1 = rL); case: (size y.`1 = 64 + 1024 * kvec %/ 8);
        case: (size y.`1 = lambda %/ 4).
have hne' : BytesPK.of_list y.`1 <> BytesPK.of_list x{2}.`1.
+ apply/negP => he; apply hne; have := congr1 BytesPK.to_list _ _ he.
  rewrite !BytesPK.of_listK; 1,2: smt().
  smt().
by rewrite hne' /=; case: (take 64 y.`1 = rL); case: (size y.`1 = 64 + 1024 * kvec %/ 8);
   case: (size y.`1 = lambda %/ 4).
qed.

(*************** Key generation ****************)

equiv squeeze_unset : Squeeze(DS2.RO1.RO).squeeze ~ Squeeze(RoutedH).squeeze :
  ={x, len} /\ size x{2} <> 64 + w1_bytes /\ size x{2} <> lambda %/ 4 /\ size x{2} <> pk_bytes /\
  !RoutedH.trset{2} /\
  inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
          RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ !RoutedH.trset{2} /\
      inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
              RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
proc; while (={x, len, j, r} /\ size x{2} <> 64 + w1_bytes /\ size x{2} <> lambda %/ 4 /\
             size x{2} <> pk_bytes /\ !RoutedH.trset{2} /\
             inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                     DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}); 2: by auto.
by wp; call get_unset; auto => /> /#.
qed.

equiv squeeze_tr : Squeeze(DS2.RO1.RO).squeeze ~ Squeeze(RoutedH).squeeze :
  ={x, len} /\ size x{2} = pk_bytes /\ len{2} = 64 /\ !RoutedH.trset{2} /\
  inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
          RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ RoutedH.trset{2} /\
      (!RoutedH.bad{2} =>
       inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
                DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}).
proof.
proc; unroll{1} 3; unroll{2} 3; rcondt{1} 3; 1: by auto.
rcondt{2} 3; 1: by auto.
rcondf{1} 6; 1: by move=> &m; wp; call (: true); auto.
rcondf{2} 6; 1: by move=> &m; wp; call (: true); auto.
by wp; call get_tr; auto => />.
qed.

equiv next_unset : XOFS_O(DS2.RO1.RO).next ~ XOFS_O(RoutedH).next :
  ={glob XOFS_O} /\ !RoutedH.trset{2} /\
  inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
          RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res, glob XOFS_O} /\ !RoutedH.trset{2} /\
      inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
              RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
by proc; inline ReadByte(DS2.RO1.RO).read ReadByte(RoutedH).read; wp; call get_unset; auto => />.
qed.

equiv rbp_unset : RejBoundedPoly(XOFS_O(DS2.RO1.RO)).sample ~ RejBoundedPoly(XOFS_O(RoutedH)).sample :
  ={arg, glob XOFS_O} /\ !RoutedH.trset{2} /\
  inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
          RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res, glob XOFS_O} /\ !RoutedH.trset{2} /\
      inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
              RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
proc; while (={j, a, glob XOFS_O} /\ !RoutedH.trset{2} /\
             inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                     DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2});
  [by wp; call next_unset; auto | by inline *; auto].
qed.

equiv expandS_unset : ExpandS(XOFS_O(DS2.RO1.RO)).sample ~ ExpandS(XOFS_O(RoutedH)).sample :
  ={arg, glob XOFS_O} /\ !RoutedH.trset{2} /\
  inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
          RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res, glob XOFS_O} /\ !RoutedH.trset{2} /\
      inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
              RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
proc; while (={r, rho, s1, s2, glob XOFS_O} /\ !RoutedH.trset{2} /\
             inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                     DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2});
  1: by wp; call rbp_unset; auto.
by wp; while (={r, rho, s1, s2, glob XOFS_O} /\ !RoutedH.trset{2} /\
              inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2}
                      DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2});
   [wp; call rbp_unset; auto | auto].
qed.

equiv keygen_eq : MLDSA_RO_DS(DS2.RO1.RO, DS2.RO2.RO).keygen ~ MLDSA_RO_DS(RoutedH, DS2.RO2.RO).keygen :
  ={glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O} /\ !RoutedH.trset{2} /\
  inv_pre DS2.RO1.RO.m{1} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2}
          RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res, glob DS2.RO2.RO, glob XOFA_O, glob XOFS_O} /\ RoutedH.trset{2} /\
      (!RoutedH.bad{2} =>
       inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
                DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}).
proof.
proc; inline MLDSA_RO(DS2.RO1.RO, DS2.RO2.RO).keygen_derand MLDSA_RO(RoutedH, DS2.RO2.RO).keygen_derand.
wp; call (: true); 1: by sim.
wp; call squeeze_tr; call (: true); 1: by sim.
wp; call expandS_unset; call (: ={glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
by wp; call squeeze_unset; wp; rnd; auto => />.
qed.

(*************** Signing and verification ****************)

equiv squeeze_set : Squeeze(DS2.RO1.RO).squeeze ~ Squeeze(RoutedH).squeeze :
  ={x, len} /\ RoutedH.trset{2} /\
  inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
           DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ RoutedH.trset{2} /\
      inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
               DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
by proc; while (={x, len, j, r} /\ RoutedH.trset{2} /\
                inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                         DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                         RO_pad.RO.m{2});
   [wp; call get_set; auto | auto].
qed.

equiv read_set : ReadByte(DS2.RO1.RO).read ~ ReadByte(RoutedH).read :
  ={x, p} /\ RoutedH.trset{2} /\
  inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
           DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ RoutedH.trset{2} /\
      inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
               DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof. by proc; wp; call get_set; auto. qed.

equiv sib_set : SampleInBall_O(DS2.RO1.RO).sample ~ SampleInBall_O(RoutedH).sample :
  ={rho} /\ RoutedH.trset{2} /\
  inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
           DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ RoutedH.trset{2} /\
      inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
               DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
proc; while (={i, pos, h, c, leakage, rho} /\ RoutedH.trset{2} /\
             inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                      DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                      RO_pad.RO.m{2}); 2: by wp; call squeeze_set; auto.
wp; while (={i, j, pos, leakage, rho} /\ RoutedH.trset{2} /\
           inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                    DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                    RO_pad.RO.m{2}); 1: by wp; call read_set; auto.
by wp; call read_set; auto.
qed.

equiv sibro_set : SIB_RO_O(DS2.RO1.RO).get ~ SIB_RO_O(RoutedH).get :
  ={mu, w1} /\ RoutedH.trset{2} /\
  inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
           DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ RoutedH.trset{2} /\
      inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
               DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof. by proc; call sib_set; wp; call squeeze_set; auto. qed.

equiv emask_set : ExpandMask_O(DS2.RO1.RO).sample ~ ExpandMask_O(RoutedH).sample :
  ={rho, mu} /\ RoutedH.trset{2} /\
  inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
           DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res} /\ RoutedH.trset{2} /\
      inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
               DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
by proc; while (={r, s, rho, mu} /\ RoutedH.trset{2} /\
                inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                         DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                         RO_pad.RO.m{2});
   [wp; call squeeze_set; auto | auto].
qed.

equiv sign_set : MLDSA_RO(DS2.RO1.RO, DS2.RO2.RO).sign_derand ~ MLDSA_RO(RoutedH, DS2.RO2.RO).sign_derand :
  ={arg, glob DS2.RO2.RO, glob XOFA_O} /\ RoutedH.trset{2} /\
  inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
           DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res, glob DS2.RO2.RO, glob XOFA_O} /\ RoutedH.trset{2} /\
      inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
               DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
proc; seq 16 16 : (={sk, m, coins, rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp, kappa,
                     zh, ct, ctl, sigma, leakage, glob DS2.RO2.RO, glob XOFA_O} /\
                   RoutedH.trset{2} /\
                   inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                            DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                            RO_pad.RO.m{2}).
+ while (={sk, m, coins, rho, _K, tr, s1, s2, t0, s1h, s2h, t0h, _A, mu, rhopp, kappa,
           zh, ct, ctl, sigma, leakage, glob DS2.RO2.RO, glob XOFA_O} /\
         RoutedH.trset{2} /\
         inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                  DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                  RO_pad.RO.m{2}).
  + by wp; call sibro_set; wp; call emask_set; auto.
  wp; call squeeze_set; wp; call squeeze_set.
  call (: ={glob DS2.RO2.RO, glob XOFA_O}); 1: by sim.
  by wp; call (: true); [sim | auto].
if => //.
by call (: true); [sim | auto].
qed.

equiv verify_set : MLDSA_RO_DS1(DS2.RO1.RO, DS2.RO2.RO).verify ~ MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).verify :
  ={arg, glob DS2.RO2.RO, glob XOFA_O} /\ RoutedH.trset{2} /\
  inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
           DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}
  ==> ={res, MLDSA_RO_DS1.bad, glob DS2.RO2.RO, glob XOFA_O} /\ RoutedH.trset{2} /\
      inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2} DS5.RO4.RO.m{2}
               DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2} RO_pad.RO.m{2}.
proof.
proc; inline MLDSA_RO(DS2.RO1.RO, DS2.RO2.RO).verify MLDSA_RO(RoutedH, DS2.RO2.RO).verify.
wp; call squeeze_set; wp.
seq 7 7 : (={pk, m, sigma, pk0, m0, sigma0, rho, t1, ct0, z, h, w1, rb, glob DS2.RO2.RO,
             glob XOFA_O} /\ RoutedH.trset{2} /\
           inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                    DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                    RO_pad.RO.m{2}).
+ by call (: true); [sim | call (: true); [sim | auto]].
if => //.
by wp; call squeeze_set; wp; call sib_set; wp; call squeeze_set; wp; call squeeze_set;
   call (: ={glob DS2.RO2.RO, glob XOFA_O}); [sim | auto].
qed.

(* Once tr is set, the routed oracle no longer changes trset or bad *)

hoare get_keep (b : bool) : RoutedH.get :
  RoutedH.trset /\ RoutedH.bad = b ==> RoutedH.trset /\ RoutedH.bad = b.
proof.
proc; sp; if; 1: by if; inline *; auto.
if; 1: by if; inline *; auto.
if; 1: by inline *; auto.
by if; [rcondf 3; [by inline *; auto | by inline *; auto] | by inline *; auto].
qed.

hoare squeeze_keep (b : bool) : Squeeze(RoutedH).squeeze :
  RoutedH.trset /\ RoutedH.bad = b ==> RoutedH.trset /\ RoutedH.bad = b.
proof.
by proc; while (RoutedH.trset /\ RoutedH.bad = b); [wp; call (get_keep b); auto | auto].
qed.

hoare sib_keep (b : bool) : SampleInBall_O(RoutedH).sample :
  RoutedH.trset /\ RoutedH.bad = b ==> RoutedH.trset /\ RoutedH.bad = b.
proof.
proc; while (RoutedH.trset /\ RoutedH.bad = b); 2: by wp; call (squeeze_keep b); auto.
by wp; while (RoutedH.trset /\ RoutedH.bad = b);
   [inline ReadByte(RoutedH).read; wp; call (get_keep b); auto |
    inline ReadByte(RoutedH).read; wp; call (get_keep b); auto].
qed.

hoare sign_keep (b : bool) : MLDSA_RO(RoutedH, DS2.RO2.RO).sign_derand :
  RoutedH.trset /\ RoutedH.bad = b ==> RoutedH.trset /\ RoutedH.bad = b.
proof.
proc; seq 16 : (RoutedH.trset /\ RoutedH.bad = b);
  2: by if; [call (: true); [by conseq /> | auto] | auto].
while (RoutedH.trset /\ RoutedH.bad = b).
+ inline SIB_RO_O(RoutedH).get ExpandMask_O(RoutedH).sample; wp; call (sib_keep b); wp.
  call (squeeze_keep b); wp.
  by while (RoutedH.trset /\ RoutedH.bad = b); [wp; call (squeeze_keep b); auto | auto].
by wp; call (squeeze_keep b); wp; call (squeeze_keep b);
   call (: true); [by conseq /> | wp; call (: true); [by conseq /> | auto]].
qed.

hoare verify_keep (b : bool) : MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).verify :
  RoutedH.trset /\ RoutedH.bad = b ==> RoutedH.trset /\ RoutedH.bad = b.
proof.
proc; inline MLDSA_RO(RoutedH, DS2.RO2.RO).verify; wp; call (squeeze_keep b); wp.
seq 7 : (RoutedH.trset /\ RoutedH.bad = b);
  1: by call (: true); [by conseq /> | call (: true); [by conseq /> | auto]].
by if; [wp; call (squeeze_keep b); wp; call (sib_keep b); wp; call (squeeze_keep b); wp;
        call (squeeze_keep b); call (: true); [by conseq /> | auto] | auto].
qed.

lemma RoutedH_get_ll : islossless RoutedH.get.
proof.
islossless.
+ by rewrite /dbytes64; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
+ by rewrite /dbytesCT; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
by rewrite /dbytes64; apply dmap_ll; apply dlist_ll; apply W8.dword_ll.
qed.

lemma RO1_get_ll : islossless DS2.RO1.RO.get.
proof. by islossless; apply dlist_ll; apply W8.dword_ll. qed.

(* ExpandA terminates over the random oracle (MLDSA_RO.ExpandA_ll): a byte
   is known once queried, and an unknown byte is a fresh uniform one *)
lemma expandA_ll : islossless ExpandA(XOFA_O(DS2.RO2.RO)).sample.
proof.
have RO2_get_ll : islossless DS2.RO2.RO.get by islossless; apply W8.dword_ll.
apply (ExpandA_ll DS2.RO2.RO (fun (m : (W8.t list * int, W8.t) fmap) x => x \in m) RO2_get_ll).
- move=> g0 x; proc; auto => />.
  by move=> r _; split => hx c; rewrite ?mem_set; smt().
- move=> g0 x hx; proc; rcondt 2; 1: by auto.
  wp; rnd (pred1 W8.zero); auto => />.
  by rewrite DW8.mu1_dword /= => v _ ->; rewrite get_set_sameE.
by move=> g r; apply fmap_bounded_snd.
qed.

(* SampleInBall terminates over the random oracles (MLDSA_RO.SampleInBall_ll):
   a block is known once queried, and an unknown block is a fresh uniform one *)
lemma sib_RO1_ll : islossless SampleInBall_O(DS2.RO1.RO).sample.
proof.
conseq (SampleInBall_ll DS2.RO1.RO (fun (m : (W8.t list * int, W8.t list) fmap) x => x \in m)
          predT RO1_get_ll _ _ _) => //.
- move=> g0 x _; proc; auto => />.
  by move=> r _; split => hx c; rewrite ?mem_set; smt().
- move=> g0 x k _ rgk hx; proc; rcondt 2; 1: by auto.
  wp; rnd (fun r => nth witness r k = W8.zero); auto => />.
  rewrite (mu_dblock_nth k (fun b => b = W8.zero)) // DW8.mu1_dword /=.
  by move=> v _ h; rewrite get_set_sameE.
by move=> g rho; apply fmap_bounded_snd.
qed.

(* the blocks RoutedH reads for an input of SampleInBall's length *)
op rh_known (g : glob RoutedH) (y : W8.t list * int) : bool =
  if g.`3 /\ take 64 y.`1 = Bytes64.to_list g.`2
  then (if y.`2 = 0 then (g.`2, drop 64 y.`1) \in g.`8 else y \in g.`5)
  else y \in g.`6.

lemma sib_RoutedH_ll : islossless SampleInBall_O(RoutedH).sample.
proof.
conseq (SampleInBall_ll RoutedH rh_known (fun l => size l = lambda %/ 4) RoutedH_get_ll _ _ _).
- move=> g0 x /= hx; proc; inline *; sp.
  if.
  + if.
    * auto => &hr [[[hb [hg hxx]] [htr htk]] h0] r hr'; rewrite -hg -hxx /rh_known /= htr htk h0 /=.
      move=> _; case: (r \in DS5.RO4.RO.m{hr}) => /= hm c;
        by case: (c = 0) => //= _; rewrite mem_set.
    auto => &hr [[[hb [hg hxx]] [htr htk]] h0] r _; rewrite -hg -hxx /rh_known /= htr htk /=.
    by case: (x{!hr} \in RO_rest.RO.m{hr}) => /= hm c; case: (c = 0) => //= hc; rewrite ?mem_set /#.
  rcondf 1; 1: by auto => &hr [[_ [_ ->]] _]; rewrite hx; smt(ct_len_nrel).
  rcondt 1; 1: by auto => &hr [[_ [_ ->]] _]; rewrite hx.
  auto => &hr [[hb [hg hxx]] htr] r _; rewrite -hg -hxx /rh_known /=.
  rewrite (negbTE _ htr) /=.
  by case: (x{!hr} \in DS5.RO2.RO.m{hr}) => /= hm c; rewrite ?mem_set /#.
- move=> [bad tr trset mpad mrest m2 m3 m4 m5] x k /= hx rgk; rewrite /rh_known /= => hkn.
  proc; inline *; sp.
  if.
  + if.
    * rcondt 3; 1: by auto => &hr /> htr htk h0 _ _; move: hkn; rewrite htr htk h0.
      wp; rnd (fun o => nth witness (Bytes64.to_list o) k = W8.zero); auto => />.
      move=> _ _ _; have /= -> := mu_dbytes64_nth k (fun b => b = W8.zero) rgk.
      by rewrite DW8.mu1_dword /= => v _ hv; rewrite get_set_sameE.
    rcondt 3; 1: by auto => &hr /> htr htk h0 _ _; move: hkn; rewrite htr htk h0.
    wp; rnd (fun r => nth witness r k = W8.zero); auto => />.
    move=> _ _ _; have /= -> := mu_dblock_nth k (fun b => b = W8.zero) rgk.
    by rewrite DW8.mu1_dword /= => v _ hv; rewrite get_set_sameE.
  rcondf 1; 1: by auto => &hr />; rewrite hx; smt(ct_len_nrel).
  rcondt 1; 1: by auto => &hr />; rewrite hx.
  rcondt 3; 1: by auto => &hr /> htr _ _; move: hkn; rewrite (negbTE _ htr).
  wp; rnd (fun r => nth witness r k = W8.zero); auto => />.
  move=> _; have /= -> := mu_dblock_nth k (fun b => b = W8.zero) rgk.
  by rewrite DW8.mu1_dword /= => v _ hv; rewrite get_set_sameE.
move=> [bad tr trset mpad mrest m2 m3 m4 m5] rho.
have [B1 hB1] := fmap_bounded_snd mrest rho.
have [B2 hB2] := fmap_bounded_snd m2 rho.
exists (max 1 (max B1 B2)) => c; rewrite /rh_known /=.
case: (trset /\ take 64 rho = Bytes64.to_list tr) => _ /=.
- by case: (c = 0) => [-> | _ /hB1]; smt().
by move=> /hB2; smt().
qed.

lemma sign_ll (H <: BlockOracle) :
  islossless H.get => islossless SampleInBall_O(H).sample =>
  islossless MLDSA_RO(H, DS2.RO2.RO).sign_derand.
proof.
move=> H_ll S_ll; proc; seq 16 : true => //.
+ while true (kappa_max - kappa);
    1: by move=> z; inline SIB_RO_O(H).get; wp; call S_ll; wp; call (Squeeze_ll H H_ll); wp;
          call (emask_ll H H_ll); auto => /#.
  wp; call (Squeeze_ll H H_ll); wp; call (Squeeze_ll H H_ll); call expandA_ll; wp; call (: true).
  + while true (kvec - i); 1: by move=> z; auto => /#.
    wp; while true (kvec - i); 1: by move=> z; auto => /#.
    by wp; while true (lvec - i); [by move=> z; auto => /# | auto => /#].
  by auto => /#.
if; 2: by auto.
call (: true); 2: by auto.
wp; call (: true); 2: by while true (lvec - i); [by move=> z; auto => /# | auto => /#].
by while true (kvec - i);
   [by move=> z; wp; while true (n - j); [by move=> z'; auto => /# | auto => /#] | auto => /#].
qed.

lemma verify_ll (H <: BlockOracle) :
  islossless H.get => islossless SampleInBall_O(H).sample =>
  islossless MLDSA_RO(H, DS2.RO2.RO).verify.
proof.
move=> H_ll S_ll; proc; seq 4 : true => //; last first.
+ by if => //; wp; call (Squeeze_ll H H_ll); wp; call S_ll; wp; call (Squeeze_ll H H_ll); wp;
     call (Squeeze_ll H H_ll); call expandA_ll; auto.
call (: true); 2: call (: true).
+ call (: true); 2: by while true (lvec - i); [by move=> z'; auto => /# | auto => /#].
  while true (2 * (w_hint - index) + b2i (!error)); 1: by move=> z'; auto => /#.
  wp; while true (2 * (kvec - i) + b2i (!error)).
  + move=> z'; sp; if; 1: by auto => /#.
    by wp; while true (2 * (W8.to_uint (nth witness y (w_hint + i)) - index) + b2i (!error));
       [by move=> z''; auto => /# | auto => /#].
  by auto => /#.
+ by while true (kvec - i); [by move=> z'; auto => /# | auto => /#].
by auto.
qed.

(*************** bad in key generation ****************)

(* Before the H_tr query, the long RO_rest entries all start with rho' *)
op pre_ok (rho0 : Bytes64.t) (mrest : (W8.t list * int, W8.t list) fmap) : bool =
  forall y, y \in mrest => 64 <= size y.`1 => take 64 y.`1 = Bytes64.to_list rho0.

hoare get_pre (rho0 : Bytes64.t) : RoutedH.get :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m /\
  size x.`1 <> 64 + w1_bytes /\ size x.`1 <> lambda %/ 4 /\ size x.`1 <> pk_bytes /\
  (64 <= size x.`1 => take 64 x.`1 = Bytes64.to_list rho0)
  ==> !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m.
proof.
proc; sp; rcondf 1; 1: by auto => /#.
rcondf 1; 1: by auto => /#.
rcondf 1; 1: by auto => /#.
rcondf 1; 1: by auto => /#.
inline *; auto => /> &hr.
by move=> _ _ hp _ _ _ hx r0 _ _ y; rewrite mem_set => -[/hp // | ->>]; exact hx.
qed.

hoare squeeze_pre (rho0 : Bytes64.t) : Squeeze(RoutedH).squeeze :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m /\
  size x <> 64 + w1_bytes /\ size x <> lambda %/ 4 /\ size x <> pk_bytes /\
  (64 <= size x => take 64 x = Bytes64.to_list rho0)
  ==> !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m.
proof.
by proc; while (!RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\
                pre_ok rho0 RO_rest.RO.m /\ size x <> 64 + w1_bytes /\
                size x <> lambda %/ 4 /\ size x <> pk_bytes /\
                (64 <= size x => take 64 x = Bytes64.to_list rho0));
   [wp; call (get_pre rho0); auto | auto].
qed.

hoare next_pre (rho0 : Bytes64.t) : XOFS_O(RoutedH).next :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m /\
  take 64 (Bytes66.to_list XOFS_O.seed) = Bytes64.to_list rho0
  ==> !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m /\
      take 64 (Bytes66.to_list XOFS_O.seed) = Bytes64.to_list rho0.
proof.
by proc; inline ReadByte(RoutedH).read; wp; call (get_pre rho0); auto => />.
qed.

hoare rbp_pre (rho0 : Bytes64.t) : RejBoundedPoly(XOFS_O(RoutedH)).sample :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m /\
  take 64 (Bytes66.to_list rho) = Bytes64.to_list rho0
  ==> !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m.
proof.
by proc; while (!RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\
                pre_ok rho0 RO_rest.RO.m /\
                take 64 (Bytes66.to_list XOFS_O.seed) = Bytes64.to_list rho0);
   [wp; call (next_pre rho0); auto | inline *; auto].
qed.

hoare expandS_pre (rho0 : Bytes64.t) : ExpandS(XOFS_O(RoutedH)).sample :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m /\
  rho = rho0
  ==> !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m.
proof.
have hitb : forall r, size (IntegerToBytes r 2) = 2
  by move=> r; rewrite /IntegerToBytes /BitsToBytes /IntegerToBits size_take // size_map
       BitEncoding.BitChunking.size_chunk // BitEncoding.BS2Int.size_int2bs.
have hpre : forall r, take 64 (Bytes66.to_list
                        (Bytes66.of_list (Bytes64.to_list rho0 ++ IntegerToBytes r 2))) =
                      Bytes64.to_list rho0
  by move=> r; rewrite Bytes66.of_listK;
     [by rewrite size_cat Bytes64.size_to_list hitb | by rewrite take_size_cat].
proc; while (!RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\
             pre_ok rho0 RO_rest.RO.m /\ rho = rho0).
+ wp; call (rbp_pre rho0); auto => />.
  by move=> &hr *; apply hpre.
by wp; while (!RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\
              pre_ok rho0 RO_rest.RO.m /\ rho = rho0);
   [wp; call (rbp_pre rho0); auto => /> &hr *; apply hpre | auto].
qed.

(* The H_tr query sets bad if pk starts with tr or tr = rho' *)
phoare get_flip (rho0 : Bytes64.t) : [RoutedH.get :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m /\
  size x.`1 = pk_bytes /\ x.`2 = 0
  ==> RoutedH.bad] <= (2%r * p512).
proof.
have hpkl : pk_bytes <> lambda %/ 4 by rewrite /pk_bytes; have /= H := param_sets; smt().
proc; sp; rcondf 1; 1: by auto => /#.
rcondf 1; 1: by auto => />; smt(pk_len_nrel).
rcondf 1; 1: by auto => />; smt().
rcondt 1; 1: by auto.
rcondt 3; 1: by inline *; auto.
inline *; wp; rnd (fun r => hit r x.`1 RO_rest.RO.m); auto => />; 2: by rewrite /p512; smt(RealOrder.expr_ge0).
move=> &hr _ _ hp hs h0; split; last by move=> _ v _; rewrite mem_empty /= get_set_sameE.
apply (RealOrder.ler_trans
         (mu dbytes64 (fun r => r = Bytes64.of_list (take 64 x{hr}.`1) \/ r = rho0))).
+ apply mu_sub => r; rewrite /hit => -[h1 | [y [hy [_ h2]]]];
    1: by left; rewrite h1 Bytes64.to_listK.
  right; have hsz : 64 <= size y.`1
    by have := congr1 List.size _ _ h2; rewrite size_take // Bytes64.size_to_list; smt().
  by rewrite -(Bytes64.to_listK r) -h2 (hp y hy hsz) Bytes64.to_listK.
have e1 : forall a, mu dbytes64 (fun r0 => r0 = a) <= p512
  by move=> a; rewrite (mu_eq _ _ (pred1 a)) 1:/# mu1_dbytes64 mu1_dblock.
by rewrite mu_or; have := e1 (Bytes64.of_list (take 64 x{hr}.`1)); have := e1 rho0;
   smt(mu_bounded).
qed.

phoare squeeze_flip (rho0 : Bytes64.t) : [Squeeze(RoutedH).squeeze :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rho0 RO_rest.RO.m /\
  size x = pk_bytes /\ len = 64
  ==> RoutedH.bad] <= (2%r * p512).
proof.
proc; unroll 3; rcondt 3; 1: by auto.
rcondf 6; 1: by wp; call (: true); auto.
by wp; call (get_flip rho0); auto => />.
qed.

(* The H_seed query only adds short entries to RO_rest *)
hoare get_short : RoutedH.get :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\
  (forall y, y \in RO_rest.RO.m => size y.`1 < 64) /\
  size x.`1 < 64 /\ size x.`1 <> lambda %/ 4
  ==> !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\
      (forall y, y \in RO_rest.RO.m => size y.`1 < 64).
proof.
proc; sp; rcondf 1; 1: by auto => /#.
rcondf 1; 1: by auto => />; smt(w1_bytes_big).
rcondf 1; 1: by auto => /#.
rcondf 1; 1: by auto => />; rewrite /pk_bytes; have /= H := param_sets; smt().
by inline *; auto => /> &hr _ _ hs hx _ r0 _ _ y; rewrite mem_set => -[/hs // | ->>].
qed.

hoare squeeze_short : Squeeze(RoutedH).squeeze :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\
  (forall y, y \in RO_rest.RO.m => size y.`1 < 64) /\
  size x < 64 /\ size x <> lambda %/ 4
  ==> !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\
      (forall y, y \in RO_rest.RO.m => size y.`1 < 64).
proof.
by proc; while (!RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\
                (forall y, y \in RO_rest.RO.m => size y.`1 < 64) /\
                size x < 64 /\ size x <> lambda %/ 4);
   [wp; call get_short; auto | auto].
qed.

phoare keygen_bad : [MLDSA_RO_DS(RoutedH, DS2.RO2.RO).keygen :
  !RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ RO_rest.RO.m = empty
  ==> RoutedH.bad] <= (2%r * p512).
proof.
proc; inline MLDSA_RO(RoutedH, DS2.RO2.RO).keygen_derand.
seq 10 : (!RoutedH.trset /\ !RoutedH.bad /\ DS5.RO3.RO.m = empty /\ pre_ok rhop RO_rest.RO.m)
  1%r (2%r * p512) 0%r 1%r.
+ by conseq />.
+ by conseq (: _ ==> true) => //.
+ seq 1 : (RoutedH.bad) (2%r * p512) 1%r 1%r 0%r.
  + by conseq />.
  + by exlim rhop => r0; call (squeeze_flip r0); auto => />.
  + by conseq (: _ ==> true) => //.
  + by hoare; wp; call (: true); auto.
  by [].
+ hoare; call (: true); 1: by conseq />.
  wp; ecall (expandS_pre rhop); call (: true); 1: by conseq />.
  wp; call squeeze_short; wp; rnd; auto => />.
  by move=> &hr _ _ e _; have /= H := param_sets; smt(mem_empty).
by [].
qed.

(* tr is set by the end of key generation *)
hoare get_trset : RoutedH.get :
  RoutedH.trset \/ (size x.`1 = pk_bytes /\ x.`2 = 0) ==> RoutedH.trset.
proof.
have hpkl : pk_bytes <> lambda %/ 4 by rewrite /pk_bytes; have /= H := param_sets; smt().
proc; sp; if; 1: by if; inline *; auto.
if; 1: by if; inline *; auto => />; smt(pk_len_nrel).
if; 1: by inline *; auto => /#.
by if; inline *; auto => /#.
qed.

hoare squeeze_trset : Squeeze(RoutedH).squeeze :
  size x = pk_bytes /\ 0 < len ==> RoutedH.trset.
proof.
proc; while (0 <= j /\ (j = 0 => size x = pk_bytes) /\ (0 < j => RoutedH.trset));
  [by wp; call get_trset; auto => /# | by auto => /#].
qed.

hoare keygen_trset : MLDSA_RO_DS(RoutedH, DS2.RO2.RO).keygen : true ==> RoutedH.trset.
proof.
proc; inline MLDSA_RO(RoutedH, DS2.RO2.RO).keygen_derand; wp; call (: true); 1: by conseq />.
wp; call squeeze_trset; call (: true); 1: by conseq />.
by conseq (: _ ==> true) => //= *; rewrite BytesPK.size_to_list.
qed.

section.

declare module A <: DS2.Adversary {
  -DS2.RO1.RO, -DS2.RO2.RO, -DS2.EUF_CMA, -XOFA_O, -XOFS_O, -MLDSA_RO_DS1, -RoutedH,
  -DS5.RO2.RO, -DS5.RO3.RO, -DS5.RO4.RO, -DS5.RO5.RO, -RO_rest.RO, -RO_pad.RO }.

lemma hop2_uptobad &m :
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res \/ RoutedH.bad].
proof.
move=> A_ll.
have hS1 := sign_ll DS2.RO1.RO RO1_get_ll sib_RO1_ll.
have hS2 := sign_ll RoutedH RoutedH_get_ll sib_RoutedH_ll.
have hV1 := verify_ll DS2.RO1.RO RO1_get_ll sib_RO1_ll.
have hV2 := verify_ll RoutedH RoutedH_get_ll sib_RoutedH_ll.
byequiv (: ={glob A, glob XOFA_O, glob XOFS_O, glob MLDSA_RO_DS1} ==>
           !RoutedH.bad{2} => ={res}) => //; 2: smt().
proc.
seq 4 4 : (={glob A, glob XOFA_O, glob XOFS_O, glob DS2.RO2.RO, pk, DS2.EUF_CMA.sk,
             DS2.EUF_CMA.qs, MLDSA_RO_DS1.pkv} /\ RoutedH.trset{2} /\
           (!RoutedH.bad{2} =>
            inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                     DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                     RO_pad.RO.m{2})).
+ inline MLDSA_RO_DS1(DS2.RO1.RO, DS2.RO2.RO).keygen MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).keygen.
  wp; call keygen_eq; inline *; auto => />.
  by move=> y; rewrite mem_empty.
seq 1 1 : (={pk} /\ RoutedH.trset{2} /\
           (!RoutedH.bad{2} =>
            ={m, s, glob XOFA_O, glob DS2.RO2.RO, DS2.EUF_CMA.qs} /\
            inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                     DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                     RO_pad.RO.m{2})).
+ call (: RoutedH.bad,
          ={glob XOFA_O, glob XOFS_O, glob DS2.RO2.RO, DS2.EUF_CMA.sk, DS2.EUF_CMA.qs,
            MLDSA_RO_DS1.pkv} /\ RoutedH.trset{2} /\
          inv_view DS2.RO1.RO.m{1} RoutedH.trset{2} RoutedH.tr{2} DS5.RO3.RO.m{2}
                   DS5.RO4.RO.m{2} DS5.RO5.RO.m{2} DS5.RO2.RO.m{2} RO_rest.RO.m{2}
                   RO_pad.RO.m{2},
          RoutedH.trset{2}).
  + by move=> H1 H2 O hO h2 h1; apply (A_ll H1 H2 O).
  + by proc; inline MLDSA_RO_DS1(DS2.RO1.RO, DS2.RO2.RO).sign
                    MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).sign;
       wp; call sign_set; auto => />.
  + move=> &2 _; conseq (: true ==> true) => //; proc.
    by inline MLDSA_RO_DS1(DS2.RO1.RO, DS2.RO2.RO).sign; wp; call hS1; auto => />;
       exact drnd_ll.
  + move=> _; proc; inline MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).sign; wp.
    call (: RoutedH.bad /\ RoutedH.trset ==> RoutedH.bad /\ RoutedH.trset).
    + by conseq hS2 (sign_keep true) => /#.
    auto => />.
    by move=> &hr _ _; exact drnd_ll.
  + by proc; auto => />.
  + by move=> &2 _; conseq (: true ==> true) => //; islossless; exact W8.dword_ll.
  + by move=> _; proc; auto => /> *; exact W8.dword_ll.
  + by proc*; call get_set; auto => />.
  + by move=> &2 _; conseq RO1_get_ll.
  + by move=> _; conseq RoutedH_get_ll (get_keep true) => /#.
  by auto => /> /#.
case (RoutedH.bad{2}); last by call verify_set; auto => /> /#.
call{1} (: true ==> true); 1: by proc; wp; call Squeeze_RO1_ll; wp; call hV1; auto.
call{2} (: RoutedH.bad /\ RoutedH.trset ==> RoutedH.bad /\ RoutedH.trset).
+ by conseq (: true ==> true) (verify_keep true) => //;
     [smt() | proc; wp; call (Squeeze_ll RoutedH RoutedH_get_ll); wp; call hV2; auto].
by auto => />.
qed.

local lemma hop2_bad &m :
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : RoutedH.bad] <=
  2%r * p512.
proof.
byphoare => //; proc; seq 4 : RoutedH.bad (2%r * p512) 1%r 1%r 0%r RoutedH.trset.
+ by inline MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).keygen; wp; call keygen_trset; inline *; auto.
+ by inline MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).keygen; wp; call keygen_bad; inline *; auto.
+ by conseq (: _ ==> true) => //.
+ hoare; call (verify_keep false); call (: RoutedH.trset /\ !RoutedH.bad);
    last by auto => /#.
  + by proc; inline MLDSA_RO_DS1(RoutedH, DS2.RO2.RO).sign; wp; call (sign_keep false);
       auto => /#.
  + by proc; auto.
  + by conseq (get_keep false) => /#.
by [].
qed.

(* Hop 2: SHAKE256 is answered by the routed oracle *)
lemma hop2 &m :
  (forall (H1 <: DS2.POracle1 {-A}) (H2 <: DS2.POracle2 {-A}) (O <: DS2.SOracle {-A}),
     islossless H1.get => islossless H2.get => islossless O.sign =>
     islossless A(H1, H2, O).forge) =>
  Pr[DS2.EUF_CMA(DS2.RO1.RO, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] <=
  Pr[DS2.EUF_CMA(RoutedH, DS2.RO2.RO, MLDSA_RO_DS1, A).main() @ &m : res] + 2%r * p512.
proof.
move=> A_ll; have := hop2_uptobad &m A_ll.
by rewrite Pr[mu_or]; have := hop2_bad &m; smt(mu_bounded).
qed.

end section.
