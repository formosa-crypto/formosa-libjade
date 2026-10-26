from Jasmin require import JByte_array.

require import BArray1024 BArray2048.

clone SubByteArray as SBArray2048_1024  with theory Asmall <= BArray1024,
                                             theory Abig <= BArray2048.
