(* -------------------------------------------------------------------- *)
(* A big array (AS, of size sizeS) viewed through block-sized windows   *)
(* (AB, of size sizeB): truncation/injection of the first block, and    *)
(* the generic sub/window lemmas shared by the ML-DSA samplers.         *)

require import AllCore List IntDiv StdOrder.

from Jasmin require import JUtils JArray.

(* -------------------------------------------------------------------- *)
theory PrefixArray.
  op sizeB : int.
  op sizeS : int.

  axiom le_size : sizeB <= sizeS.

  clone import PolyArray as AB with op size <- sizeB.
  clone import PolyArray as AS with op size <- sizeS.

  op truncatea'B (a : 'a AS.t) : 'a AB.t =
    AB.init (fun i => a.[i]).

  op injecta'S (a : 'a AS.t) (b : 'a AB.t) : 'a AS.t =
    AS.init (fun i => if 0 <= i < sizeB then b.[i] else a.[i]).

  lemma truncatea'BE (a : 'a AS.t) :
    AB.init (fun i => a.[i]) = truncatea'B a.
  proof. by done. qed.

  lemma injecta'SE (a : 'a AS.t) (b : 'a AB.t) :
    AS.init (fun i => if 0 <= i < sizeB then b.[i] else a.[i])
    = injecta'S a b.
  proof. by done. qed.

  (* ------------------------------------------------------------------ *)
  lemma sub0'B (a : 'a AB.t) (base : int) : AB.sub a base 0 = [].
  proof. by rewrite /sub mkseq0. qed.

  lemma sub0'S (a : 'a AS.t) (base : int) : AS.sub a base 0 = [].
  proof. by rewrite /sub mkseq0. qed.

  hint simplify sub0'B, sub0'S.

  (* ------------------------------------------------------------------ *)
  lemma sub_cat'B (a : 'a AB.t) (off len1 len2 : int) :
    0 <= len1 => 0 <= len2 =>
       AB.sub a off (len1 + len2)
     = AB.sub a off len1 ++ AB.sub a (off + len1) len2.
  proof.
  move=> ge0_1 ge0_2; rewrite /sub mkseq_add //=; congr.
  by apply eq_in_mkseq => i rgi /=; congr; ring.
  qed.

  lemma sub_cat'S (a : 'a AS.t) (off len1 len2 : int) :
    0 <= len1 => 0 <= len2 =>
       AS.sub a off (len1 + len2)
     = AS.sub a off len1 ++ AS.sub a (off + len1) len2.
  proof.
  move=> ge0_1 ge0_2; rewrite /sub mkseq_add //=; congr.
  by apply eq_in_mkseq => i rgi /=; congr; ring.
  qed.

  (* ------------------------------------------------------------------ *)
  lemma take_sub'B (a : 'a AB.t) (k n m : int) :
    0 <= n <= m =>
    take n (AB.sub a k m) = AB.sub a k n.
  proof. by move=> h; rewrite /sub take_mkseq. qed.

  lemma take_sub'S (a : 'a AS.t) (k n m : int) :
    0 <= n <= m =>
    take n (AS.sub a k m) = AS.sub a k n.
  proof. by move=> h; rewrite /sub take_mkseq. qed.

  (* ------------------------------------------------------------------ *)
  lemma sub3E'B (a : 'a AB.t) (k : int) :
    AB.sub a k 3 = [a.[k]; a.[k + 1]; a.[k + 2]].
  proof. by rewrite /sub /mkseq -iotaredE /=. qed.

  lemma sub3E'S (a : 'a AS.t) (k : int) :
    AS.sub a k 3 = [a.[k]; a.[k + 1]; a.[k + 2]].
  proof. by rewrite /sub /mkseq -iotaredE /=. qed.

  (* ------------------------------------------------------------------ *)
  lemma sub_full'B (a : 'a AB.t) :
    AB.sub a 0 sizeB = AB.to_list a.
  proof. by rewrite /sub /to_list; apply eq_in_mkseq => i rgi /=. qed.

  lemma sub_full'S (a : 'a AS.t) :
    AS.sub a 0 sizeS = AS.to_list a.
  proof. by rewrite /sub /to_list; apply eq_in_mkseq => i rgi /=. qed.

  (* ------------------------------------------------------------------ *)
  lemma sub_split'B (a : 'a AB.t) (n : int) :
    0 <= n <= sizeB =>
    AB.to_list a = AB.sub a 0 n ++ AB.sub a n (sizeB - n).
  proof.
  move=> rgn; rewrite -sub_full'B -(sub_cat'B a 0 n (sizeB - n)) ~-1:/#.
  by congr; ring.
  qed.

  lemma sub_split'S (a : 'a AS.t) (n : int) :
    0 <= n <= sizeS =>
    AS.to_list a = AS.sub a 0 n ++ AS.sub a n (sizeS - n).
  proof.
  move=> rgn; rewrite -sub_full'S -(sub_cat'S a 0 n (sizeS - n)) ~-1:/#.
  by congr; ring.
  qed.

  (* ------------------------------------------------------------------ *)
  (* writing a block into its window extends the byte prefix            *)
  lemma sub_window_catE (b : 'a AS.t) (a : 'a AB.t) (i : int) :
    0 <= sizeB /\ 0 <= i /\ i * sizeB + sizeB <= sizeS =>
    AS.sub
      (AS.init (fun j =>
         if i * sizeB <= j < i * sizeB + sizeB then a.[j - i * sizeB] else b.[j]))
      0 (sizeB * (i + 1))
    = AS.sub b 0 (sizeB * i) ++ AB.to_list a.
  proof.
  move=> rgi; apply (eq_from_nth witness).
  - rewrite AS.size_sub 1:/# size_cat AS.size_sub 1:/#.
    by rewrite AB.size_to_list /#.
  move=> j; rewrite AS.size_sub 1:/# => rgj.
  rewrite AS.nth_sub 1:/# /= AS.initiE 1:/# /=.
  rewrite nth_cat AS.size_sub 1:/#.
  case: (j < sizeB * i) => hcase.
  - by rewrite ifF 1:/# AS.nth_sub /#.
  by rewrite ifT 1:/# AB.get_to_list /#.
  qed.

  (* ------------------------------------------------------------------ *)
  lemma sub1E'B (a : 'a AB.t) (k : int) :
    AB.sub a k 1 = [a.[k]].
  proof. by rewrite /sub /mkseq -iotaredE /=. qed.

  lemma sub1E'S (a : 'a AS.t) (k : int) :
    AS.sub a k 1 = [a.[k]].
  proof. by rewrite /sub /mkseq -iotaredE /=. qed.

  (* ------------------------------------------------------------------ *)
  (* reading back the head block                                        *)
  lemma trunca_0E (a : 'a AS.t) :
    AB.init (fun i => a.[0 + i]) = truncatea'B a.
  proof.
  by rewrite -truncatea'BE; apply AB.ext_eq => i rgi; rewrite !initiE.
  qed.

  lemma trunc_inject (a : 'a AS.t) (b : 'a AB.t) :
    truncatea'B (injecta'S a b) = b.
  proof.
  apply AB.ext_eq => i rgi.
  rewrite /truncatea'B initiE //= /injecta'S initiE 1:#smt:(le_size) /=.
  by rewrite rgi.
  qed.

  (* ------------------------------------------------------------------ *)
  (* extracting a block-aligned window, and how a window write reads    *)
  (* back through it                                                    *)
  op winof (a : 'a AS.t) (r : int) : 'a AB.t =
    AB.init (fun j => a.[sizeB * r + j]).

  lemma winof_write (s : 'a AS.t) (p : 'a AB.t) (lo hi j : int) :
    0 < sizeB => 0 <= j => sizeB * j + sizeB <= sizeS =>
    hi = lo + sizeB => 0 <= lo => lo + sizeB <= sizeS => sizeB %| lo =>
    winof (AS.init (fun i => if lo <= i < hi then p.[i - lo] else s.[i])) j
    = if sizeB * j = lo then p else winof s j.
  proof.
  move=> gt0B rgj hjS -> rglo hloS hdvd.
  have [q hq] : exists q, lo = sizeB * q.
  - by exists (lo %/ sizeB); rewrite mulzC divzK 1:hdvd.
  case: (sizeB * j = lo) => [heq|ne].
  - apply AB.ext_eq => i rgi.
    rewrite /winof AB.initiE //=.
    rewrite AS.initiE 1:/# /=.
    by smt().
  apply AB.ext_eq => i rgi.
  rewrite /winof !AB.initiE //=.
  rewrite AS.initiE 1:/# /=.
  rewrite ifF //.
  have hne : j <> q by smt().
  case: (j < q) => hjq; smt(StdOrder.IntOrder.ler_pmul2l).
  qed.

end PrefixArray.
