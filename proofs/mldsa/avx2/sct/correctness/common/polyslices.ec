(* -------------------------------------------------------------------- *)
(* The 256-bit reads of a polynomial by the encodings, at the offsets   *)
(* where they are slices of its 32-bit coefficients.                    *)
(* -------------------------------------------------------------------- *)
require import AllCore.
from Jasmin require import JModel_x86.
require import CircuitBindings Array256 WArray1024 XArray256.

lemma get256_polyE (p : W32.t Array256.t) (o : int) :
  get256_direct (WArray1024.init32 (fun i => p.[i])) o =
  if 0 <= o * 8 <= 7936 then BSWAS_256u32_256.sliceget p (o * 8)
  else get256_direct (WArray1024.init32 (fun i => p.[i])) o.
proof. by case: (0 <= o * 8 <= 7936) => h //; rewrite BSWAS_256u32_256_slicegetE. qed.
