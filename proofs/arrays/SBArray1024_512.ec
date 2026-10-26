from Jasmin require import JByte_array.

require import BArray512 BArray1024.

clone SubByteArray as SBArray1024_512  with theory Asmall <= BArray512,
                                            theory Abig <= BArray1024.
