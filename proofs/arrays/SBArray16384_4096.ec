from Jasmin require import JByte_array.

require import BArray4096 BArray16384.

clone SubByteArray as SBArray16384_4096  with theory Asmall <= BArray4096,
                                              theory Abig <= BArray16384.
