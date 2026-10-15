require import AllCore IntDiv List JWordExtra.
from Jasmin require import JModel_x86.
require import Mldsa44.
require import CircuitBindings Bindings XArray32.
require import Array32 WArray32.
require import BitEncoding.
import BitChunking.

(* the 128-bit slices of a 32-byte array *)
clone BSWAS as BSWAS_32u8_128 with
      op asize   <- 32,
      op bsize   <- 8,
      op ssize   <- 128,
  theory A       <- Array32,
  theory BSA     <- BSA32,
  theory WB      <- W8  { rename "_XX" as "_8" },
  theory WEB     <- WE8,
  theory BSWB    <- BSW8,
  theory WS      <- W128  { rename "_XX" as "_128" },
  theory WES     <- WE128,
  theory BSWS    <- BSW128,
  theory BSWA    <- BSWA_32u8

  proof le_size by done.

lemma BSWAS_32u8_128_slicegetE o (p : W8.t Array32.t):
  0 <= o * 8 <= 32 * 8 - 128 =>
  get128_direct (WArray32.init8 (fun (i_0 : int) => p.[i_0])) o
  = BSWAS_32u8_128.sliceget p (o * 8).
proof.
move=> Ho; rewrite /get128_direct /pack16_t; apply W128.wordP => k kb.
have //= := BSWAS_32u8_128.BVA_asliceget_Top_CircuitBindings_BSWAS_WB_t_Top_CircuitBindings_BSWAS_WS_t_Top_CircuitBindings_BSWAS_A_t.bvaslicegetP p (o * 8) _; 1: by smt().
move=> -> //; rewrite initiE 1:/# /= initiE 1:/# /= initiE 1:/# /=.
rewrite nth_take 1,2:/# nth_drop 1,2:/# (nth_flatten false 8).
+ by rewrite allP /= => x; rewrite mapP => He; elim He; smt(W8.size_w2bits).
rewrite (nth_map witness); 1: by rewrite size_to_list; smt().
by rewrite get_to_list get_w2bits /#.
qed.

(* The comparison of the two commitment hashes of ML-DSA-44 (32 bytes). *)

lemma compare_commitment_hashes_ll : islossless M.__compare_commitment_hashes.
proof.
proc.
wp;while (0 <=  offset <= 32 /\ offset %% 16 = 0) (32 - offset); last by auto => />; smt().
auto => /> ; smt().
qed.

lemma compare_commitment_hashes_correct (_lhs _rhs : W8.t Array32.t) :
    phoare [ M.__compare_commitment_hashes :
        arg.`1 = _lhs /\ arg.`2 = _rhs
        ==>
        res = (if _lhs = _rhs then W64.of_int 0 else -W64.one)
    ] = 1%r.
proof.
have hh : hoare [ M.__compare_commitment_hashes :
    arg.`1 = _lhs /\ arg.`2 = _rhs
    ==>
    res = (if _lhs = _rhs then W64.of_int 0 else -W64.one) ].
+ proc => /=.
  proc change 2 : { lhs_bytes <- if (0 <=  offset * 8 <= 32*8-128)
                                  then BSWAS_32u8_128.sliceget lhs (offset * 8)
                                  else get128_direct (WArray32.init8 (fun i => lhs.[i])) (offset); }.
  + auto => /> &2.
    case (0 <= offset{2} * 8 <= 128); last  by auto.
    by move => ?; rewrite -BSWAS_32u8_128_slicegetE /#.
  proc change 3 : { rhs_bytes <- if (0 <=  offset * 8 <= 32*8-128)
                                  then BSWAS_32u8_128.sliceget rhs ( offset * 8)
                                  else get128_direct (WArray32.init8 (fun i => rhs.[i])) (offset); }.
  + auto => /> &2.
    case (0 <= offset{2} * 8 <= 128); last by auto.
    by move => ?; rewrite -BSWAS_32u8_128_slicegetE /#.
  proc change ^while.1 : { lhs_bytes <- if (0 <= offset * 8 <= 32*8-128)
                                         then BSWAS_32u8_128.sliceget lhs (offset * 8)
                                         else get128_direct (WArray32.init8 (fun i => lhs.[i])) (offset); }.
  + auto => /> &2.
    case (0 <= offset{2} * 8 <= 128); last by auto.
    by move => ?; rewrite -BSWAS_32u8_128_slicegetE /#.
  proc change ^while.2 : { rhs_bytes <- if (0 <= offset * 8 <= 32*8-128)
                                         then BSWAS_32u8_128.sliceget rhs (offset * 8)
                                         else get128_direct (WArray32.init8 (fun i => rhs.[i])) (offset); }.
  + auto => /> &2.
    case (0 <= offset{2} * 8 <= 128); last by auto.
    by move => ?; rewrite -BSWAS_32u8_128_slicegetE /#.
  cfold 1;unroll for ^while.
  cfold 8.
  wp 8.
  conseq (: _ ==> _lhs = _rhs <=> result = W64.of_int 65535).
  + move => &hr [<- <-] rr [Hl Hr].
    case (rr <> W64.of_int 65535); last first.
    + move => HH; rewrite Hr //=.
      move => ?; rewrite ifF 1:/# /=.
      case (lhs{hr} = rhs{hr}) => ?; 1: by
       rewrite to_uint_eq /=; smt(W64.to_uint_cmp pow2_64).
      by rewrite to_uint_eq /= to_uintN /=. 
  by circuit.
conseq compare_commitment_hashes_ll hh;smt().
qed.
