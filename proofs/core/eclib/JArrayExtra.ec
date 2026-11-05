(* -------------------------------------------------------------------- *)
require import AllCore List Ring IntDiv Distr DList.
require import StdRing StdOrder.
require MinMaxSimplify.

from Jasmin require import JArray JWord JWord_array.

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

  (* the size may be negative: dlist then gives the empty list *)
  lemma dlist_size ['a] (d : 'a distr) : dlist d size = dlist d (max 0 size).
  proof. rewrite /max; case: (0 < size) => // h; rewrite !dlist0 // /#. qed.

  lemma supp_darray ['a] (d : 'a distr) (a : 'a t) :
    a \in darray d <=> forall i, 0 <= i < size => a.[i] \in d.
  proof.
  rewrite /darray dlist_size supp_dmap; split => [[l [hl ->]] i rgi | h].
  - move: hl; rewrite supp_dlist 1:/# => -[hs /List.allP hall].
    by rewrite get_of_list // hall mem_nth /#.
  exists (to_list a); rewrite to_listK /= supp_dlist 1:/# size_to_list /=.
  by apply/List.allP => x /mkseqP [i [rgi ->]]; apply h.
  qed.

  lemma darray_ll ['a] (d : 'a distr) : is_lossless d => is_lossless (darray d).
  proof. by move=> d_ll; apply/dmap_ll/dlist_ll. qed.

  lemma darray_uni ['a] (d : 'a distr) : is_uniform d => is_uniform (darray d).
  proof.
  move=> d_uni; rewrite /darray dlist_size.
  apply/dmap_uni_in_inj/dlist_uni => // x y.
  rewrite !supp_dlist 1,2:/# => -[hx _] [hy _] hxy.
  case: (0 <= size) => hs.
  - by rewrite -(of_listK witness x) 1:/# -(of_listK witness y) 1:/# hxy.
  by move: hx hy; rewrite (_ : max 0 size = 0) 1:/# !size_eq0 => -> ->.
  qed.
end PAE.

(* -------------------------------------------------------------------- *)
(* The 32-bit and 256-bit views of a byte array written by init32.       *)
abstract theory WAE.
  op size : int.

  clone import WArray as A with op size <- size.

  lemma get32_init32 (f : int -> W32.t) (i : int) :
    0 <= i => 4 * i + 4 <= size =>
    get32 (init32 f) i = f i.
  proof.
  move => Hi0 Hi1.
  rewrite /get32_direct /init32 /W4u8.pack4_t /=.
  apply W32.wordP => k kb.
  rewrite W32.initiE 1:/# /= W4u8.Pack.initiE 1:/# /=.
  rewrite A.initiE 1:/# /=.
  rewrite (_: (4 * i + k %/ 8) %/ 4 = i) 1:/#.
  rewrite (_: (4 * i + k %/ 8) %% 4 = k %/ 8) 1:/#.
  by rewrite W4u8.get_bits8 1:/# /#.
  qed.

  lemma get32_set256_direct_eq (t : A.t) (j i : int) (w : W256.t) :
    0 <= j =>
    j + 32 <= size =>
    j %% 4 = 0 =>
    0 <= i =>
    4 * i + 4 <= size =>
    get32 (set256_direct t j w) i =
    if j %/ 4 <= i < j %/ 4 + 8
    then w \bits32 (i - j %/ 4)
    else get32 t i.
  proof.
  move => Hj_lo Hj_hi Hj_mod Hi0 Hi1.
  rewrite /get32_direct /=.
  apply W32.wordP => k kb.
  rewrite /W4u8.pack4_t W32.initiE 1:/# /= W4u8.Pack.initiE 1:/# /=.
  rewrite /set256_direct A.initiE 1:/# /=.
  case (j %/ 4 <= i < j %/ 4 + 8) => Hi_region.
  + rewrite (_: j <= 4 * i + k %/ 8 < j + 32) 1:/# /=.
    rewrite /W8u32.(\bits32) /W32u8.(\bits8) W32.initiE 1:/# /= W8.initiE 1:/# /=.
    congr; smt().
  rewrite (_: !(j <= 4 * i + k %/ 8 < j + 32)) 1:/# /=.
  rewrite /get32_direct /W4u8.pack4_t.
  by rewrite W32.initiE 1:/# /= W4u8.Pack.initiE 1:/#.
  qed.

  lemma get256_direct_init32_bits32 (f : int -> W32.t) (j k : int) :
    0 <= j =>
    j + 32 <= size =>
    j %% 4 = 0 =>
    0 <= k < 8 =>
    (get256_direct (init32 f) j) \bits32 k = f (j %/ 4 + k).
  proof.
  move => Hj_lo Hj_hi Hj_mod Hk.
  rewrite /get256_direct /W8u32.(\bits32) /=.
  apply W32.wordP => b bb.
  rewrite W32.initiE 1:/# /= pack32wE 1:/# W32u8.Pack.initiE 1:/# /=.
  rewrite /init32 A.initiE 1:/# /=.
  rewrite (_: (j + (k * 32 + b) %/ 8) %/ 4 = j %/ 4 + k) 1:/#.
  rewrite (_: (j + (k * 32 + b) %/ 8) %% 4 = b %/ 8) 1:/#.
  rewrite (_: (k * 32 + b) %% 8 = b %% 8) 1:/#.
  by rewrite W4u8.get_bits8 1:/# /#.
  qed.

  (* the 16-bit lanes, at any even offset *)
  lemma get256_direct_bits16 (t : A.t) (j k : int) : 0 <= k < 16 => j %% 2 = 0 =>
    get256_direct t j \bits16 k = get16 t (j %/ 2 + k).
  proof.
  move=> hk hj; rewrite get256E get16E; apply W16.wordP => b hb.
  rewrite bits16iE // pack32wE 1:/# W32u8.Pack.initiE 1:/# /=.
  rewrite W2u8.pack2wE // W2u8.Pack.initiE 1:/# /=.
  by rewrite (_ : j + (k * 16 + b) %/ 8 = 2 * (j %/ 2 + k) + b %/ 8) 1:/#
             (_ : (k * 16 + b) %% 8 = b %% 8) 1:/#.
  qed.

  lemma get16_set256_direct (t : A.t) (j i : int) (w : W256.t) :
    0 <= j => j + 32 <= size => j %% 2 = 0 =>
    get16 (set256_direct t j w) i =
    if j %/ 2 <= i < j %/ 2 + 16 then w \bits16 (i - j %/ 2) else get16 t i.
  proof.
  move=> hj0 hj1 hj; rewrite set256E !get16E; apply W16.wordP => b hb.
  rewrite W2u8.pack2wE // W2u8.Pack.initiE 1:/# /= initE.
  case: (j %/ 2 <= i < j %/ 2 + 16) => hi.
  + rewrite ifT 1:/# /= ifT 1:/# bits16iE // bits8iE 1:/#; congr; smt().
  rewrite W2u8.pack2wE // W2u8.Pack.initiE 1:/# /=.
  by case: (0 <= 2 * i + b %/ 8 < size) => hs /=; [rewrite ifF 1:/# | rewrite get_out].
  qed.

  lemma init32_get32 (f : int -> W32.t) (t : A.t) : size %% 4 = 0 =>
    (forall i, 0 <= i < size %/ 4 => f i = get32 t i) => init32 f = t.
  proof.
  move=> hs hf; apply tP => i hi; rewrite /init32 initiE //= hf 1:/#.
  rewrite get32E; apply W8.wordP => b hb.
  rewrite bits8iE // W4u8.pack4wE 1:/# W4u8.Pack.initiE 1:/# /=.
  rewrite (_ : 4 * (i %/ 4) + (i %% 4 * 8 + b) %/ 8 = i) 1:/#.
  by rewrite (_ : (i %% 4 * 8 + b) %% 8 = b) 1:/#.
  qed.
end WAE.

(* -------------------------------------------------------------------- *)
(* An array of u32 and its byte view: the 32- and 16-bit lanes of the    *)
(* 256-bit loads and stores through the byte view.                       *)
abstract theory PWAE.
  op size : int.
  op wsize : int.
  axiom wsizeE : wsize = 4 * size.

  clone import PolyArray as P with op size <- size.
  clone import WArray as W with op size <- wsize.
  clone WAE as WE with op size <- wsize, theory A <- W.

  (* the byte view of an array of u32 *)
  abbrev bytes (p : W32.t P.t) = W.init32 (fun i => p.[i]).

  (* the 16-bit lanes of an array of u32 (2 * size of them) *)
  op lane16 (p : W32.t P.t) (t : int) : W16.t = W.get16 (bytes p) t.

  lemma load_bits32 (p : W32.t P.t) (o k : int) :
    0 <= o => o + 32 <= wsize => o %% 4 = 0 => 0 <= k < 8 =>
    W.get256_direct (bytes p) o \bits32 k = p.[o %/ 4 + k].
  proof. by move=> *; rewrite WE.get256_direct_init32_bits32. qed.

  lemma load_bits16 (p : W32.t P.t) (o k : int) : o %% 2 = 0 => 0 <= k < 16 =>
    W.get256_direct (bytes p) o \bits16 k = lane16 p (o %/ 2 + k).
  proof. by move=> *; rewrite WE.get256_direct_bits16. qed.

  lemma store_get (p : W32.t P.t) (o t : int) (w : W256.t) :
    0 <= o => o + 32 <= wsize => o %% 4 = 0 => 0 <= t < size =>
    (P.init (W.get32 (W.set256_direct (bytes p) o w))).[t] =
    if o %/ 4 <= t < o %/ 4 + 8 then w \bits32 (t - o %/ 4) else p.[t].
  proof.
  move=> h0 h1 h2 ht; have hw := wsizeE.
  rewrite P.initiE //= WE.get32_set256_direct_eq 1..5:/#.
  by case: (o %/ 4 <= t < o %/ 4 + 8) => // _; rewrite WE.get32_init32 /#.
  qed.

  lemma store_lane16 (p : W32.t P.t) (o t : int) (w : W256.t) :
    0 <= o => o + 32 <= wsize => o %% 2 = 0 =>
    lane16 (P.init (W.get32 (W.set256_direct (bytes p) o w))) t =
    if o %/ 2 <= t < o %/ 2 + 16 then w \bits16 (t - o %/ 2) else lane16 p t.
  proof.
  move=> h0 h1 h2; have hw := wsizeE; rewrite /lane16.
  rewrite (WE.init32_get32 _ (W.set256_direct (bytes p) o w)) 1:/#.
  + by move=> i hi /=; rewrite P.initiE /#.
  by rewrite WE.get16_set256_direct.
  qed.
end PWAE.
