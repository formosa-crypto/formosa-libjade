(* The generic Mlkem_filters_bridgeT at ML-KEM-768 *)
require import AllCore.
require Mlkem_filters_bridgeT Base768.

clone export Mlkem_filters_bridgeT.Mlkem_filters_bridgeT as Mlkem_filters_bridgeI with
  theory B <- Base768.Base768.
