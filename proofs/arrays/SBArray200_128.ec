from Jasmin require import JByte_array.

require import BArray128 BArray200.

clone SubByteArray as SBArray200_128  with theory Asmall <= BArray128,
                                           theory Abig <= BArray200.
