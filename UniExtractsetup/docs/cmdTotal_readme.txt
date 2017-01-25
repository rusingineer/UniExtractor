Утилита для распаковки архивов из командной строки с использованием архиваторных плагинов Total Commander. Автором утилиты является Adam Blaszczyk; выложенная здесь версия является доработкой, добавляющей поддержку юникодных интерфейсов WCX-плагинов. Кроме того, были исправлены некоторые ошибки.

 Новая версия не поддерживает Win9x. Если вам требуется поддержка этой системы, используйте исходную версию 1.02, выложенную на сайте KaKeeware (http://www.kakeeware.com/i_cmdtotal.php).

;
; KaKeeware cmdTotal is yet another upgrade to IETOTALX proggie.
; http://www.kakeeware.com/i_ietotalx.php
; Development continued by Konstantin Vlasov a.k.a. CaptainFlint.
;
; This is a generic approach to make it possible to use any
; Total Commander WCX packer plugins from a command line.
;
; -- How to use? --
; From a command line, run:
;    cmdTotal [wcxPluginName] [option] [fileName] [targetDirectory]
;     where:
;       [wcxPluginName] - WCX plugin filename (path not needed if in the same directory)
;       [option] - can be:
;         l - to list the files
;         t - to test the files
;         x - to extract the files
;       [fileName] - file you want to process
;       [targetDirectory] - where to extract the files (default: _[fileName])
;
; Examples:
;     cmdTotal.exe InstExpl.wcx l WinPcap_3_1.exe             - to list the files inside the archive
;     cmdTotal.exe InstExpl.wcx x WinPcap_3_1.exe             - to extract the files inside the archive to _WinPcap_3_1.exe directory
;     cmdTotal.exe InstExpl.wcx x WinPcap_3_1.exe c:\unpacked - to extract the files inside the archive to c:\unpacked directory
;
; -- Technical note --
; There's a guard thread created at the beginning of the main routine that will kill the instance
; of cmdTotal, if the main thread haven't finished its work after 300 seconds.
;
; There's SEH handler added before calling the function that extracts the files to make sure
; we extract as many of them as possible.
;
; -- History --
;  2013-04-23 v. 2.02 - /by K.V./ further improvement of TC behavior emulation:
;                     -   a) for subdirectories calling ProcessFile(archiveHandle, PK_SKIP, NULL, NULL)
;                     -   b) always calling ProcessFile with DestPath == NULL and DestName == full target path
;  2013-04-17 v. 2.01 - /by K.V./ improved TC behavior emulation:
;                     -   a) providing ANSI ProcessDataProc to Unicode plugins too
;                     -   b) use ProcessFile with PK_SKIP for packed directories, create them ourselves
;                     - fixed destination path construction when it's omitted and archive is specified with path
;  2013-04-03 v. 2.00 - /by K.V./ added support for Unicode WCX API
;  2007-01-03 v. 1.02 - fixed handling command line arguments (just made buffers a bit longer)
;  2006-12-31 v. 1.01 - added support for SetProcessDataProc (some plugins expect callback to be set) - (thx to perchwasamara for hint on that)
;                     - fixed the way ProcessFile is called - some plugins I tested use the arguments provided, some don't
;                     - got amazed couple of times by misleading information provided in a WCX plug-in HELP file, but luckily had OllyDbg at hand :)
;  2006-12-30 v. 1.00 - first version
;
; -- Credits --
; - perchwasamara for hint on SetProcessDataProc
; - Jared B. for hint on problem with command line arguments
; - Hutch for his pieces of code I used in a proggie
; ;
; Feel free to play with the code to modify it up to your needs.
; If you happen to use my code, don't forget about creditz :-)
;
; Author: Konstantin Vlasov (c) 2013
; WWW:    http://flint-inc.ru/
; e-mail: support[]flint-inc[]ru
;
; Original work by:
; Author: Adam Blaszczyk (c) 2006/2007
; WWW:    http://www.kakeeware.com
; e-mail: adam[]kakeeware[]com
;
; ============================================================
