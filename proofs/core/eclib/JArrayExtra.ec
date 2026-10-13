(* -------------------------------------------------------------------- *)
require import AllCore List Ring IntDiv Distr DList.
require import StdRing StdOrder.

from Jasmin require import JArray.

(* -------------------------------------------------------------------- *)
abstract theory PAE.
  op size : int.

  clone import PolyArray as A with op size <- size.

  (* -------------------------------------------------------------------- *)
  op eqon ['a] (a1 a2 : 'a t) (base len : int) =
    forall i, base <= i < base + len => a1.[i] = a2.[i].

  (* -------------------------------------------------------------------- *)
  op eqexcept ['a] (a1 a2 : 'a t) (base len : int) =
    forall i, !(base <= i < base + len) => a1.[i] = a2.[i].

  (* -------------------------------------------------------------------- *)
  lemma fill_congr (f g : int -> 'a) (k1 k2 : int) (len1 len2 : int) (a1 a2 : 'a t) :
       k1 = k2
    => len1 = len2
    => (forall i, k1 <= i < k1 + len1 => f i = g i)
    => a1 = a2
    => fill f k1 len1 a1 = fill g k2 len2 a2.
  proof.
  by move=> <<- <<- eq <<-; apply: ext_eq=> i rgi; rewrite !filliE //#.
  qed.

  (* -------------------------------------------------------------------- *)
  lemma fill_eqexcept (f : int -> 'a) (k : int) (len : int) (a : 'a t) :
    eqexcept (fill f k len a) a k len.
  proof.
  move=> i *; case: (0 <= i < size) => *; last by rewrite !get_out.
  by rewrite filliE // ifF //#.
  qed.

  (* -------------------------------------------------------------------- *)
  lemma fill_swap ['a] (f g : int -> 'a) (k1 k2 : int) (len1 len2 : int) (a : 'a t) :
       k1 + len1 <= k2
    => fill g k1 len1 (fill f k2 len2 a) = fill f k2 len2 (fill g k1 len1 a).
  proof. by move=> *; apply/ext_eq=> i *; rewrite !filliE //#. qed.

  (* -------------------------------------------------------------------- *)
  op replace_ ['a] (a : 'a t) (base : int) (s : 'a list) =
    fill (fun i => nth witness s (i - base)) base (size s) a.

  (* -------------------------------------------------------------------- *)
  lemma replace_nil ['a] (a : 'a t) (base : int) : replace_ a base [] = a.
  proof. by apply/ext_eq=> i *; rewrite /replace_ filliE //= ifF //#. qed.

  hint simplify replace_nil.

  (* -------------------------------------------------------------------- *)
  lemma replace_eqexcept (a : 'a t) (base : int) (s : 'a list) :
    eqexcept (replace_ a base s) a base (size s).
  proof. by apply: fill_eqexcept. qed.

  (* -------------------------------------------------------------------- *)
  lemma replace_mkseq ['a] (f : int -> 'a) (a : 'a t) (base len : int) :
    replace_ a base (mkseq f len) = fill (fun i => f (i - base)) base len a.
  proof.
  apply/ext_eq=> i rgi @/replace_; rewrite !filliE //=.
  rewrite size_mkseq; case: (len < 0) => [lt0_len|/lezNgt gt0_len].
  - by rewrite !ifF //#.
  rewrite lez_maxr //; case: (base <= i < base + len) => // ?.
  by rewrite nth_mkseq 1:/#.
  qed.

  (* -------------------------------------------------------------------- *)
  lemma replace_swap ['a] (a : 'a t) (b1 b2 : int) (s1 s2 : 'a list) :
       b1 + size s1 <= b2
    => replace_ (replace_ a b2 s2) b1 s1 = replace_ (replace_ a b1 s1) b2 s2.
  proof. by move=> * @/replace_; rewrite fill_swap. qed.

  (* -------------------------------------------------------------------- *)
  lemma replaceC ['a] (a : 'a t) (b1 b2 : int) (s1 s2 : 'a list) :
       b1 + size s1 <= b2 \/ b2 + size s2 <= b1
    => replace_ (replace_ a b2 s2) b1 s1 = replace_ (replace_ a b1 s1) b2 s2.
  proof.
  case (b1 + size s1 <= b2) => [/replace_swap ->//|].
  case (b2 + size s2 <= b1) => [/replace_swap ->//|].
  done.
  qed.

  (* -------------------------------------------------------------------- *)
  lemma replace_cat ['a] (a : 'a t) (base : int) (s1 s2 : 'a list) :
    replace_ a base (s1 ++ s2) = replace_ (replace_ a base s1) (base + size s1) s2.
  proof.
  apply/ext_eq=> i *; rewrite /replace_ !filliE //=.
  by rewrite size_cat nth_cat /=; smt(size_ge0).
  qed.
  (* -------------------------------------------------------------------- *)
  (* arrays with independent entries drawn from d                         *)
  op darray ['a] (d : 'a distr) : 'a t distr = dmap (dlist d size) (of_list witness).

  lemma supp_darray ['a] (d : 'a distr) (a : 'a t) :
    a \in darray d <=> forall i, 0 <= i < size => a.[i] \in d.
  proof.
  rewrite /darray supp_dmap; split => [[l [hl ->]] i rgi | h].
  - move: hl; rewrite supp_dlist 1:ge0_size => -[hs /List.allP hall].
    by rewrite get_of_list // hall mem_nth /#.
  exists (to_list a); rewrite to_listK /= supp_dlist 1:ge0_size size_to_list /=.
  by apply/List.allP => x /mkseqP [i [rgi ->]]; apply h.
  qed.

  lemma darray_ll ['a] (d : 'a distr) : is_lossless d => is_lossless (darray d).
  proof. by move=> d_ll; apply/dmap_ll/dlist_ll. qed.

  lemma darray_uni ['a] (d : 'a distr) : is_uniform d => is_uniform (darray d).
  proof.
  move=> d_uni; apply/dmap_uni_in_inj/dlist_uni => // x y.
  rewrite !supp_dlist 1,2:ge0_size => -[hx _] [hy _] hxy.
  by rewrite -(of_listK witness x) // -(of_listK witness y) // hxy.
  qed.
end PAE.
