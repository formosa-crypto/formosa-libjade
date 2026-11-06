(* -------------------------------------------------------------------- *)
(* The compression of the model, at abstract parameters. The kernels    *)
(* of the parameter sets (d_u = 10 or 11, d_v = 4 or 5) are proved by   *)
(* circuit at the sizes of their set: the dispatchers' correctness is   *)
(* a hypothesis here, realized by each set.                             *)
(* -------------------------------------------------------------------- *)
require import AllCore List Int IntDiv.
from Jasmin require import JModel_x86.
from JazzEC require import Array256.
from Spec require import GFq Rq Serialization Correctness.
require import W16extra MLKEMFCLib.
require BaseT PreludeT.

abstract theory MLKEM_compress_avx2T.

clone import BaseT.BaseT as B.
import S R.
clone import PreludeT.PreludeT as PR with theory B <- B.

import Zq.
import Array_vecn Array_polyc_bytes Array_polyvecc_pad Array_ct_bytes.

axiom poly_decompress_corr (_a : W8.t BytesPoly.t) :
  phoare [M._i_poly_decompress :
    BytesPoly.init (fun i => arg.`2.[i]) = _a ==>
    lift_array256 res = decompress_poly dv (decode_poly _a) /\
    pos_bound256_cxq res 0 256 1] = 1%r.

axiom i_poly_compress_corr (_aw : W16.t Array256.t) :
  phoare [M._i_poly_compress :
    pos_bound256_cxq a 0 256 2 /\ a = _aw ==>
    BytesPoly.init (fun i => res.`1.[i]) = encode_poly (compress_poly dv (lift_array256 _aw))]
  = 1%r.

axiom polyvec_decompress_corr (_aw : W8.t BytesCtVec.t) :
  phoare [M.__i_polyvec_decompress :
    BytesCtVec.init (fun i => rp.[i]) = _aw ==>
    pos_boundvecn_cxq res 0 vecn 1 /\
    lift_polyvec res = decompress_polyvec du (decode_vec _aw)] = 1%r.

axiom polyvec_compress_avx2_corr (_aw : W16.t Array_vecn.t) :
  phoare [M.__i_polyvec_compress :
    a = _aw /\ pos_boundvecn_cxq a 0 vecn 2 ==>
    BytesCtVec.init (fun i => res.[i]) = encode_vec (compress_polyvec du (lift_polyvec _aw))]
  = 1%r.

end MLKEM_compress_avx2T.
