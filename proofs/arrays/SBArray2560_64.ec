from Jasmin require import JByte_array.

require import BArray64 BArray2560.

clone SubByteArray as SBArray2560_64  with theory Asmall <= BArray64,
                                           theory Abig <= BArray2560.
