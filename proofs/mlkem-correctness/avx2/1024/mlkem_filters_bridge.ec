(* The generic Mlkem_filters_bridgeT at ML-KEM-1024 *)
require import AllCore.
require Mlkem_filters_bridgeT Base1024.

clone export Mlkem_filters_bridgeT.Mlkem_filters_bridgeT as Mlkem_filters_bridgeI with
  theory B <- Base1024.Base1024.
