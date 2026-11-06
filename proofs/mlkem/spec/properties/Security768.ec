from Spec require Spec768 MLKEMSecurity.

(* The security of ML-KEM-768: the theorem mlkem_spec_security of the
   generic theory MLKEMSecurityT (IND-CCA in the ROM), at the parameters of
   ML-KEM-768. *)
clone MLKEMSecurity.MLKEMSecurityT as Sec768 with
  op kvec = Spec768.Params768.kvec,
  op du   = Spec768.Params768.du,
  op dv   = Spec768.Params768.dv,
  op eta1 = Spec768.Params768.eta1,
  op eta2 = Spec768.Params768.eta2
proof param_sets by exact Spec768.Params768.param_sets,
      eta_vals by done.
