KGB Archiver 2 beta 1 console		(c)2005-2007 Tomasz Pawlak

To compress:
	kgb2_console [-ax] [-my] [-p] archive file1 file2 file3...
To decompress:
	kgb2_console archive

 a - number of algorithm, from 0 (no compression) to 7 (best compression)
 m - number of compression mode, see table below
 p - use password

Memory usage
-----------------------------------------
-a1 -  49MB, -my option ignored (default)
-a2 -  51MB, -my option ignored
-a3 - 192MB, -my option ignored
-a4 - 335MB, -my option ignored
-a5 - 358MB, -my option ignored
-a6 -m from 0 (4MB) to 9 (1600MB)
-a7 -m from 0 (22MB) to 9 (940MB)
