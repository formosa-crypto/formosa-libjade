from Jasmin require import JByte_array.

require import BArray32 BArray2560.

clone SubByteArray as SBArray2560_32  with theory Asmall <= BArray32,
                                           theory Abig <= BArray2560.
