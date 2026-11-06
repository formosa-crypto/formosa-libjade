from Spec require Spec1024 MLKEMSecurity.

(* The security of ML-KEM-1024: the theorem mlkem_spec_security of the
   generic theory MLKEMSecurityT (IND-CCA in the ROM), at the parameters of
   ML-KEM-1024. *)
clone MLKEMSecurity.MLKEMSecurityT as Sec1024 with
  op kvec = Spec1024.Params1024.kvec,
  op du   = Spec1024.Params1024.du,
  op dv   = Spec1024.Params1024.dv,
  op eta1 = Spec1024.Params1024.eta1,
  op eta2 = Spec1024.Params1024.eta2
proof param_sets by exact Spec1024.Params1024.param_sets,
      eta_vals by done.
