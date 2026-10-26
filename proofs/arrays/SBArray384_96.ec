from Jasmin require import JByte_array.

require import BArray96 BArray384.

clone SubByteArray as SBArray384_96  with theory Asmall <= BArray96,
                                          theory Abig <= BArray384.
