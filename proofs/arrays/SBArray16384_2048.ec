from Jasmin require import JByte_array.

require import BArray2048 BArray16384.

clone SubByteArray as SBArray16384_2048  with theory Asmall <= BArray2048,
                                              theory Abig <= BArray16384.
