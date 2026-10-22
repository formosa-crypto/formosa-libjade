from Jasmin require import JByte_array.

require import BArray2048 BArray12288.

clone SubByteArray as SBArray12288_2048  with theory Asmall <= BArray2048,
                                              theory Abig <= BArray12288.
