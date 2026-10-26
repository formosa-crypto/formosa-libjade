from Jasmin require import JByte_array.

require import BArray1024 BArray16384.

clone SubByteArray as SBArray16384_1024  with theory Asmall <= BArray1024,
                                              theory Abig <= BArray16384.
