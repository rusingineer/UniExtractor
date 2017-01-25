; ---------------------------------------------------------------------------
;
; Universal Extractor v1.6.1
; Author:	Jared Breland <jbreland@legroom.net>
; Homepage:	http://www.legroom.net/mysoft
; Language:	AutoIt v3.3.6.1
; License:	GNU General Public License v2 (http://www.gnu.org/copyleft/gpl.html)
; Modify by koros aka korosya aka ya158 <koros@ya.ru> http://forum.oszone.net/post-2479402-5.html
; Very Basic Script Function:
;	Extract known archive types
;	Use TrID to determine filetype
;	Use PEiD to identify executable filetypes
;
; ----------------------------------------------------------------------------
; Setup properties UniExtract.exe
#pragma compile(ExecLevel, requireAdministrator)
#pragma compile(FileDescription, Decompress and extract files from any type of archive or installer)
#pragma compile(Comments, 'Compiled with AutoIt http://www.autoitscript.com/')
#pragma compile(ProductName, Universal Extractor)
#pragma compile(CompanyName, '')
#pragma compile(FileVersion, 1.6.1.1)
#pragma compile(ProductVersion, 1.6.1)
#pragma compile(LegalCopyright, GNU General Public License v2)
#pragma compile(InternalName, "UniExtract")
#pragma compile(OriginalFilename, UniExtract.exe)
#pragma compile(LegalTrademarks, 'Jared Breland <jbreland@legroom.net>')
; Setup environment
; Установка переменных
;#notrayicon
#include "Include\Array.au3" ; _ArraySort, _ArrayAdd
#include "Include\File.au3" ; _PathFull, _FileListToArray, _TempFile
#include "Include\GUIConstantsEx.au3"
#include "Include\StaticConstants.au3"
#include "Include\ComboConstants.au3"
#include "Include\WindowsConstants.au3"
#include "Include\Date.au3" ; _DateAdd
; Create array from the registry hive 
; Создание массива с именами и значениями параметров определенной ветки реестра
; http://autoit-script.ru/index.php?topic=22713.new#new
#include "Include\_RegEnumKeyValEx.au3" ; _RegEnumKeyEx
$name = "Universal Extractor"
$website = "http://www.legroom.net/software/uniextract"
$website_rb = "http://forum.ru-board.com/topic.cgi?forum=5&bm=1&topic=20420"
$website_o = "http://forum.oszone.net/thread-295084.html"
$prefs = @scriptdir & "\UniExtract.ini"
$version = "1.6.1.1 mod "
$reg = "HKCU\Software\UniExtract"
$peidtitle = "PEiD v"
$title = $name & " v" & $version
$unicodepattern = "(?i)(?m)^[\w\Q @!§$%&/\()=?,.-:+~'Іі{[]}*#Я°^влцдьокфыпбйнуъаимтщ\E]+$"
;$msxml_down = "http://www.microsoft.com/downloads/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1&displaylang=en"
Opt("GUIOnEventMode", 1)

; Preferences
; Настройки
Global $langdir = @scriptdir & "\lang"
Global $logdir = @scriptdir & "\log"
Global $PasswordFile = @scriptdir & "\passwords.txt"
Global $height = @desktopheight/4
Global $globalprefs = 1
Global $language = "English"
Global $debugdir = @tempdir
Global $history = 0
Global $appendext = 0
Global $removetemp = 1
Global $removedupe = 1
Global $warnexecute = 1
Global $nodoswin = 0
Global $mindoswin = 1
Global $useepe = 1
Global $usedie = 1
Global $usepeid = 1
Global $savepass = 1
Global $savelog = 1
Global $savelogalways = 0
Global $time = '-' & @HOUR & '-' & @MIN & '-' & @SEC

; Global variables
; Глобальные переменные
Dim $file, $filename, $filedir, $fileext, $initoutdir, $outdir, $filetype
Dim $prompt, $packed, $return, $output, $langlist, $prefsonly
Dim $exsig, $loadplugins, $stayontop, $regpeid = 0
Dim $testinno, $testarj, $testace, $test7z, $testzip, $testie, $testhex
Dim $innofailed, $arjfailed, $acefailed, $7zfailed, $zipfailed, $iefailed, $isfailed, $packfailed, $hexfailed
Dim $oldpath
Dim $createdir, $dirmtime
Dim $exitcode = 0
Dim $consolewin = 1
Dim $hexstring, $hexstring1, $hexstring2
Dim $productname, $fileversion
Dim $keyzpaq, $ms_vcr
Dim $rescan, $extract = 1
Dim $isofile
Dim $section, $Log
Dim $UnicodeMode, $oldpath, $oldName, $oldoutdir

; Extractors
; Распаковщики
$7z = "7z.exe"
$ace = "xace.exe"
$afp = "AFPIunpack.exe"
$alz = "unalz.exe"
$arc = "arc.exe"
$aspack = "AspackDie.exe"
$aspack22 = "AspackDie22.exe"
$bootimg = "bootimg.exe"
$cdi = "cdirip.exe"
$daa = "daa2iso.exe" 															;0.1.7e
$dbx = "cmdTotal.exe dbxplug.wcx"
$dgca = "dgcac.exe"
$die = "diec.exe"
$enigma = "EnigmaVBUnpacker.exe"
$epe = "exeinfope.exe"
$expand = "expand.exe"
$unarc = "unarc.exe"
$hlp = "helpdeco.exe"
$ie = "cmdTotal.exe InstExpl.wcx"
$img = "7z.exe"
$inno = "innounp.exe"
$is3arc = "i3comp.exe"
$is3exe = "stix_d.exe"
$is6cab = "i6comp.exe"
$is5cab = "i5comp.exe"
$iscab_unshield = "unshield.exe" ; Added - sometimes supports cabs that i5/6comp don't
$isexe = "IsXunpack.exe"
$iso = "cmdTotal.exe iso.wcx"
$kgb = "kgb2_console.exe"
$lit = "clit.exe"
$lzo = "lzop.exe"
$lzx = "unlzx.exe"
$mht = "extractMHT.exe"
$mht_ct = "cmdTotal.exe MHTUnp.wcx"
$msi_ct = "cmdTotal.exe msi.wcx"
$msi_jsmsix = "jsMSIx.exe"
$msi_lessmsi = "lessmsi.exe"
$msi_msix = "MsiX.exe"
$ms_vcr = "dark.exe"
$nbh = "NBHextract.exe"
$pdfdetach = "pdfdetach.exe"
$pdfimages = "pdfimages.exe"
$pdftotext = "pdftotext.exe"
$pea = "pea.exe"
$peid = "peid.exe"
$rai = "RAIU.exe"
$rar = "unrar.exe"
$SfxSplit = "SfxSplit.exe"
$sim = "sim_unpacker.exe"
$sis = "cmdTotal.exe PDunSIS.wcx"
$sit = "Expander.exe"
$sqx = "cmdTotal.exe TotalSQX.wcx"
$swf = "swfextract.exe" 														;0.9.1
$thinstall = "Extractor.exe"
$to = "cmdTotal.exe TotalObserver.wcx"
$trid = "trid.exe"
$uharc = "UNUHARC06.EXE"
$uharc04 = "UHARC04.EXE"
$uharc02 = "UHARC02.EXE"
$uif = "uif2iso.exe" 															;0.1.7c
$upx = "upx.exe"
$uu = "uudeview.exe"
$wise_ewise = "e_wise_w.exe"
$wise_wun = "wun.exe"
$zip = "unzip.exe"
$zoo = "unzoo.exe"
$zpaq = "zpaq.exe"

; Check parameters
; Проверка параметров из UniExtract.ini  и комстроки
ReadPrefs()
AddLog()
If $cmdline[0] = 0 Then
	AddLog($name & ' ' & $version & ' ' & t('WITHOUT_COMLINE_PARAMETRS'))
	$prompt = 1
Else
	Local $icmdline
	For $i = 1 To $cmdline[0]
		$icmdline &= $cmdline[$i] & ' '
	Next
	AddLog($name & ' ' & $version & ' ' & t('COMLINE_PARAMETRS') & ' "'  & StringTrimRight($icmdline, 1) & '"')
	If $cmdline[1] = "/help" OR $cmdline[1] = "/h" OR $cmdline[1] = "/?" OR $cmdline[1] = "-h" OR $cmdline[1] = "-?" Then
		terminate("syntax")
	ElseIf $cmdline[1] = "/prefs" OR $cmdline[1] = "/p" OR $cmdline[1] = "-prefs" OR $cmdline[1] = "-p" Then
		$prefsonly = True
		GUI_Prefs()
		$finishprefs = False
		While 1
			If $finishprefs Then ExitLoop
			Sleep(10)
		WEnd
		terminate("silent")
	ElseIf $cmdline[1] = "/lang" AND $cmdline[0] = 2 OR $cmdline[1] = "/l" OR $cmdline[1] = "-lang" OR $cmdline[1] = "-l" Then
		If $cmdline[0] > 1 Then
			Local $ldir = @scriptdir
			If $cmdline[2] <> 'English' Then $ldir &= '\lang'
			If Not FileExists($ldir & '\' & $cmdline[2] & '.ini') Then terminate("invalidlangfile", $ldir & '\' & $cmdline[2] & '.ini')
			If $globalprefs Then
				$section = "UniExtract Preferences"
				IniWrite($prefs, $section, 'language', $cmdline[2])
			Else
				RegWrite($reg, 'language', 'REG_SZ', $cmdline[2])
			EndIf
			AddLog(t('LANG_INTERFACE')  & ' ' & $cmdline[2])
			terminate("silent")
		Else
			terminate("syntax")
		EndIf
	Else
		If FileExists($cmdline[1]) Then
			$file = _PathFull($cmdline[1])
			AddLog(t('FILE_PROCESSING')  & ' "' & $file & '"')
		Else
			terminate("syntax")
		EndIf
		If $cmdline[0] > 1 Then
			$outdir = $cmdline[2]
		Else
			$prompt = 1
		EndIf
	EndIf
EndIf

; If no file passed, display GUI to select file and set options
; Если файл для распаковки не задан в комстроке, то вывести GUI
If $prompt Then
	CreateGUI()
	Global $finishgui = False
	While 1
		If $finishgui Then ExitLoop
		Sleep(10)
	WEnd
EndIf

; Parse filename
; Парсинг имени файла
FilenameParse($file)

; Set full output directory
; Задание директории распаковки
If $outdir = '/sub' Then
	$outdir = $initoutdir
ElseIf StringMid($outdir, 2, 1) <> ":" Then
	If StringLeft($outdir, 1) == '\' AND StringMid($outdir, 2, 1) <> '\' Then
		$outdir = StringLeft($filedir, 2) & $outdir
	ElseIf StringLeft($outdir, 2) <> '\\' Then
		$outdir = _PathFull($filedir & '\' & $outdir)
	EndIf
EndIf
If StringRight($outdir, 1) = '\' Then $outdir = StringTrimRight($outdir, 1)
If FileExists($outdir) Then
	$datatime = @MDAY & '.' & @MON & '.' & StringRight(@YEAR, 2) & '_' & @HOUR & '-' & @MIN
	If Not StringInStr(FileGetAttrib($outdir), "D") Then
		$prompt = MsgBox(51, $title, t("WARN_FILE_EXIST", CreateArray($outdir, $outdir, $outdir, $outdir, $outdir, $datatime)))
		AddLog(t("FILE_EXIST", CreateArray($outdir, $outdir)))
		If $prompt = 2 Then $outdir = $outdir & '_' & $datatime
		If $prompt = 6 Then $outdir = $outdir & '_extracted'
		If $prompt = 7 Then $outdir = FileSelectFolder(t('EXTRACT_TO'), "", 3, $filedir)
		If @error Then	$outdir = $filedir & '\' & $filename & '_' & $datatime
	Else
		$prompt = MsgBox(51+4096, $title, t("WARN_DIR_EXIST", CreateArray($outdir, $outdir)))
		AddLog(t("DIR_EXIST", CreateArray($outdir, $outdir)))
		If $prompt = 6 Then
			$validdir = _DirRemove($outdir, 1)
			$validdir = _DirCreate($outdir)
  			If NOT $validdir Then terminate("invaliddir", $outdir)
			$createdir = True
		EndIf
		If $prompt = 7 Then $outdir = FileSelectFolder(t('EXTRACT_TO'), "", 3, $filedir)
		If @error Then	$outdir = $filedir & '\' & $filename & '_' & $datatime
	EndIf
Else
	$validdir = _DirCreate($outdir)
	If NOT $validdir Then terminate("invaliddir", $outdir)
	$createdir = True
EndIf
AddLog(t('DEST_DIR')  & ' "' & $outdir & '"')

CheckUnicode()

; Verify debug file output
; Проверка доступности директории для файла отладки
If StringRight(EnvParse($debugdir), 1) <> '\' Then $debugdir &= '\'
$debugfile = FileGetShortName(EnvParse($debugdir)) & 'uniextract' & $time & '.txt'
AddLog(t('DEBUG_FILE')  & ' "' & $debugfile & '"')
$testdebug = FileOpen($debugfile, 2)
If $testdebug == -1 Then
	MsgBox(48, $title, t('CANNOT_DEBUG', CreateArray(EnvParse($debugdir))))
	AddLog(t('CANNOT_DEBUG', CreateArray(EnvParse($debugdir))))
	AddLog(t('DEBUG_FILE')  & ' "' & $debugfile & '"')
	$debugdir = @tempdir & '\'
	$debugfile = FileGetShortName($debugdir) & 'uniextract' & $time & '.txt'
Else
	FileClose($testdebug)
	_FileDelete($debugfile)
EndIf

; Update history
; Добавление записи в историю
;WritePrefs()
If $history Then
	WriteHist('file', $file)
	WriteHist('directory', $outdir)
EndIf

; Определение состояния окна консоли (нормальное, минимизировано или свернуто)
If $mindoswin Then $consolewin = 2
If $nodoswin Then $consolewin = 0

; Set environment options for Windows NT
; Установка переменных для Windows NT
$cmd = @comspec & ' /d /c '
$output = ' 2>&1 | mtee.exe ' & $debugfile
EnvSet("path", @scriptdir & "\bin" & ';' & @scriptdir & "\bin\wix" & ';' & @scriptdir & "\bin\exeinfope" & ';' & @scriptdir & "\bin\kgb" & ';' & @scriptdir & "\bin\die" & ';' & EnvGet("path"))
AddLog(t('SET_PATH') & ' ' & EnvGet("path"))

; Check for ProductName "Microsoft Visual C++ Redistributable"
; Проверка по ProductName на Microsoft Visual C++ Redistributable
$productname = FileGetVersion($file, "ProductName")
$fileversion = FileGetVersion($file)
If $productname AND $fileversion Then AddLog(t('FILE_PROPERTIES') & ' ' & t('PRODUCT_NAME') & ' "' & $productname & '"; ' & t('FILE_VER') & ' "' & $fileversion & '"')
If StringInStr  ($productname, "Microsoft Visual C++") And StringInStr  ($productname, "Redistributable") AND StringCompare(StringLeft($fileversion, 2), 10) Then extract("ms_vcr", 'Microsoft Visual C++ Redistributable ' & t('TERM_EXECUTABLE'))
;If StringInStr  ($productname, "Adobe") And StringInStr  ($productname, "Flash") AND StringInStr  ($productname, "Player Installer") Then extract("afp", 'Adobe Flash Player ' & t('TERM_INSTALLER'))

; Extract contents from known file types
; Распаковка содержимого из файлов известных типов
;
; UniExtract uses four methods of detection (in order):
; 1. File extensions for special cases
; 2. Binary file analysis of files using TrID
; 3. Binary file analysis of PE (executable) files using PEiD
; 4. File extensions
;
; If detection fails, extraction is always attempted 7-Zip and InfoZip
; UniExtract использует четыре метода определения
; 1. По расширению файла для специальных случаев
; 2. Анализ бинарных файлов с помощью TrID
; 3. Анилиз исполняемых файлов с помощью PEiD
; 4. По расширению файлов
;
; Если определить правильный распаковщик не удаётся, то используются 7-Zip и InfoZip

; First, check for file extensions that require special actiona
; Во-первых, проверяются расширения файлов на необходимость применения специальных методов распаковки
; Compound compressed files that require multiple actions
; Вложенные архивы, для которых необходимо несколько распаковок
AddLog("------------------------------------------------------------")
AddLog(t('FIRST'))
Switch $fileext
	Case "ipk", "tbz2", "tgz", "tz", "tlz", "txz", "xar"
		extract("ctar", 'Compressed Tar ' & t('TERM_ARCHIVE'))
	
	; CD-ROM images - TrID is not reliable with these formats
	; Образы дисков CD - TrID может неправильно определять такие файлы
	Case "cdi"
		extract("cdi", 'CDI CD-ROM ' & t('TERM_IMAGE'))
	Case "uif"
		extract("uif", 'CDI CD-ROM ' & t('TERM_IMAGE'))
	Case "iso"
		extract("to", 'ISO CD-ROM ' & t('TERM_IMAGE'))
	Case "bin"
		extract("to", 'BIN CD-ROM ' & t('TERM_IMAGE'))
	Case "isz"
		extract("to", 'ISZ CD-ROM (UltraISO) ' & t('TERM_IMAGE'))
	Case "mdf"
		extract("to", 'MDF CD-ROM (Alcohol 120%) ' & t('TERM_IMAGE'))
	Case "nrg"
		extract("to", 'NRG CD-ROM (Nero Burning ROM) ' & t('TERM_IMAGE'))
	
	; Microsoft VHDs - TrID has no definition for this format
	; Образ Microsoft VHD - TrID не определяет этот формат
	Case "vhd"
		extract("7z", 'Microsoft Virtual Hard Disk ' & t('TERM_IMAGE'))
	
	;PDF
	Case "pdf"
		extract("pdf", 'PDF ' & t('TERM_EBOOK'))
	
	;PKG
	Case "pkg"
		extract("ctar", 'PKG ' & t('TERM_INSTALLER'))
	
	;DMG
	Case "dmg"
		extract("ctar", 'DMG ' & t('TERM_IMAGE'))
	
	; Second, analyze file using TrID
	; Во-торых, используется TrID
	Case Else
		AddLog(t('SECOND'))
		SplashTextOn($title, t('SCANNING_FILE'), 330, 50, -1, $height, 16)
		filescan($file)
EndSwitch


; Third, run PEiD scan if appropriate
; Determine type of .exe and extract if possible
; В-третьих, запускается PEiD для exe-шников, определяется тип и, при возможности, распаковывается
If $fileext = "exe" OR StringInStr($filetype, 'Executable', 0) Then
	AddLog()
	AddLog(t('THIRD'))
	While 1
		$rescan = 0
		; Check for known exe filetypes
		; Проверка известных типов исполняемых файлов
		$scantypes = CreateArray('epe', 'die', 'deep', 'hard', 'ext')
		For $i = 0 To UBound($scantypes)-1
			; Check with Detect-It-Easy
			; Проверка с помощью Detect-It-Easy
			If $scantypes[$i] == 'die' AND $usedie Then $tempftype = diescan($file)	
			
			; Check with Exeinfo PE
			; Проверка с помощью Exeinfo PE
			If $scantypes[$i] == 'epe' AND $useepe Then $tempftype = epescan($file)

			; Check with PEiD
			; Проверка с помощью PEiD
			; Run PEiD scan
			; Запуск PEiD	
			If $scantypes[$i] == 'hard' AND $usepeid Then $tempftype = exescan($file, $scantypes[$i])				
			If $scantypes[$i] == 'deep' OR $scantypes[$i] == 'ext' AND $usepeid Then exescan($file, $scantypes[$i])
			
			If $packed Then ExitLoop
			; Perform additional tests if necessary
			; Выполнение дополнительных тестов при необхожимости
			SplashTextOn($title, t('TERM_TESTING') & ' ' & 	t('TERM_UNKNOWN') & ' ' & t('TERM_EXECUTABLE'), 330, 80, -1, $height, 16)
			If $testinno AND NOT $innofailed Then checkInno()
			If $testace AND NOT $acefailed Then checkAce()
			If $testzip AND NOT $zipfailed Then checkZip()
			If $testie AND NOT $iefailed Then checkIE()
			If $testhex AND NOT $hexfailed Then checkhex()	
			if $test7z AND NOT $7zfailed Then check7z()
			SplashOff()
		Next
		
		; Unpack (vs. extract) packed file
		; Распаковываем, а не извлекаем из архива, запакованные exe-шники
		if $packed Then $rescan = unpack()

		if $rescan = 0 Then ExitLoop
	WEnd
		$filetype = $tempftype

	; Try 7-Zip and Unzip if all else fails
	; Пробуем распаковать с пормощью 7-Zip, если остальными распаковщиками не получилось
	If NOT $7zfailed Then check7z()
	If NOT $zipfailed Then checkZip()
	if NOT $iefailed Then checkIE()

	; Exit with unknown file type
	; Выход в с выводом информации о неизвестном типе файла
	terminate("unknownexe", $file, $filetype)
EndIf

; Fourth, use file extension if signature not recognized
; В-четвёртых, используем расширение файла для распаковки, поскольку сигнатура не распознана
AddLog()
AddLog(t('FOURTH'))
Switch $fileext
	Case "1", "lib"
		extract("is3arc", 'InstallShield 3.x ' & t('TERM_ARCHIVE'))
	
	Case "7z"
		extract("7z", '7-Zip ' & t('TERM_ARCHIVE'))
	
	Case "ace"
		extract("ace", 'ace ' & t('TERM_ARCHIVE'))
	
	Case "arc"
		extract("arc", 'ARC ' & t('TERM_ARCHIVE'))
	
	Case "arj"
		extract("7z", 'ARJ ' & t('TERM_ARCHIVE'))
	
	Case "b64" 
		extract("uu", 'Base64 ' & t('TERM_ENCODED'))
	
	Case "bz2"
		extract("bz2", 'bzip2 ' & t('TERM_COMPRESSED'))
	
	Case "cab"
		If StringInStr(FetchStdout($cmd & $7z & ' l "' & $file & '"', $filedir, @SW_HIDE), "Listing archive:", 0) Then
			extract("cab", 'Microsoft CAB ' & t('TERM_ARCHIVE'))
		Else
			extract("iscab", 'InstallShield CAB ' & t('TERM_ARCHIVE'))
		EndIf
	
	Case "chm"
		extract("chm", 'Compiled HTML ' & t('TERM_HELP'))
	
	Case "cpio"
		extract("7z", 'CPIO ' & t('TERM_ARCHIVE'))
	
	Case "dbx"
		extract("dbx", 'Outlook Express ' & t('TERM_ARCHIVE'))
	
	Case "deb"
		extract("7z", 'Debian ' & t('TERM_PackAGE'))
	
	Case "dll"
		exescan($file, 'deep')
		If $packed Then
			unpack()
		Else
			terminate("unknownexe", $file, $filetype)
		EndIf
	
	Case "gz"
		extract("gz", 'gzip ' & t('TERM_COMPRESSED'))
	
	Case "hlp"
		extract("hlp", 'Windows ' & t('TERM_HELP'))
	
	Case "imf"
		extract("cab", 'IncrediMail ' & t('TERM_ECARD'))
	
	Case "img"
		extract("img", 'Floppy ' & t('TERM_DISK') & ' ' & t('TERM_IMAGE'))
	
	Case "kgb", "kge"
		extract("kgb", 'KGB ' & t('TERM_ARCHIVE'))
	
	Case "lit"
		extract("lit", 'Microsoft LIT ' & t('TERM_EBOOK'))
	
	Case "lzh", "lha"
		extract("7z", 'LZH ' & t('TERM_COMPRESSED'))
	
	Case "lzma"
		extract("7z", 'LZMA ' & t('TERM_COMPRESSED'))
	
	Case "lzo"
		extract("lzo", 'LZO ' & t('TERM_COMPRESSED'))
	
	Case "lzx"
		extract("lzx", 'LZX ' & t('TERM_COMPRESSED'))
	
	Case "mht"
		extract("mht", 'MHTML ' & t('TERM_ARCHIVE'))
	
	Case "msi"
		extract("msi", 'Windows Installer (MSI) ' & t('TERM_PackAGE'))
	
	Case "msm"
		extract("msm", 'Windows Installer (MSM) ' & t('TERM_MERGE_MODULE'))
	
	Case "msp"
		extract("msp", 'Windows Installer (MSP) ' & t('TERM_PATCH'))
	
	Case "nbh"
		extract("nbh", 'NBH ' & t('TERM_IMAGE'))
	
	Case "pea"
		extract("pea", 'Pea ' & t('TERM_ARCHIVE'))
	
	Case "rar", "001", "cbr"
		extract("rar", 'RAR ' & t('TERM_ARCHIVE'))
	
	Case "rpm"
		extract("7z", 'RPM ' & t('TERM_PackAGE'))
	
	Case "sis"
		extract("sis", 'SymbianOS ' & t('TERM_INSTALLER'))
	
	Case "sit"
		extract("sit", 'StuffIt ' & t('TERM_ARCHIVE'))
	
	Case "sqx"
		extract("sqx", 'SQX ' & t('TERM_ARCHIVE'))
	
	Case "tar"
		extract("tar", 'Tar ' & t('TERM_ARCHIVE'))
	
	Case "uha"
		extract("uha", 'UHARC ' & t('TERM_ARCHIVE'))
	
	Case "uu", "uue", "xx", "xxe"
		extract("uu", 'UUencode ' & t('TERM_ENCODED'))
	
	Case "wim"
		extract("7z", 'WIM ' & t('TERM_IMAGE'))
	
	Case "xz"
		extract("xz", 'XZ ' & t('TERM_COMPRESSED'))
	
	Case "yenc", "ntx"
		extract("uu", 'yEnc ' & t('TERM_ENCODED'))
	
	Case "z"
		If NOT check7z() Then extract("is3arc", 'InstallShield 3.x ' & t('TERM_ARCHIVE'))
	
	Case "zip", "cbz", "jar", "xpi", "wz"
		extract("zip", 'ZIP ' & t('TERM_ARCHIVE'))
	
	Case "zoo"
		extract("zoo", 'ZOO ' & t('TERM_ARCHIVE'))
	
	Case "zpaq"
		extract("zpaq", 'ZPAQ ' & t('TERM_ARCHIVE'))
	
	; Unknown extension
	; Неизвестное расширение
	Case Else
		; Cannot determine filetype - abort
		; Невозможно определить тип файла - выход
		SplashOff()
		terminate("unknownext", $file)
EndSwitch

; -------------------------- Begin Custom Functions ---------------------------

; Parse filename
; Парсинг имени файла
Func FilenameParse($f)
	$file = _PathFull($f)
	$filedir = StringLeft($f, StringInStr($f, '\', 0, -1)-1)
	$filename = StringTrimLeft($f, StringInStr($f, '\', 0, -1))
	If StringInStr($filename, '.') Then
		$fileext = StringTrimLeft($filename, StringInStr($filename, '.', 0, -1))
		$filename = StringTrimRight($filename, StringLen($fileext)+1)
		$initoutdir = $filedir & '\' & $filename
	Else
		$fileext = ''
		$initoutdir = $filedir & '\' & $filename & '_' & t('TERM_UNPACKED')
	EndIf
EndFunc

; Check for unicode characters in path
; Проверка на юникод
Func CheckUnicode()
	If StringRegExp($file, $unicodepattern, 0) Then Return
	AddLog(t('FILE_UNICODE'))
	
	If Not StringRegExp(@TempDir, $unicodepattern, 0) Then Return AddLog(t('TEMP_UNICODE'))
	Local $new = _TempFile(@TempDir, "Unicode_", '.' & $fileext)

	SplashTextOn($title, t('MOVE_COPY_FILES') & @CRLF & t('TO', CreateArray($file, $new)), (StringLen($file)+StringLen($new)+4)*6, 80, -1, $height, 16)
	If StringLeft($file, 1) = StringLeft($new, 1) Then
		If Not _FileMove($file, $new) Then Return
		$UnicodeMode = "Move"
	Else
		If Not _FileCopy($file, $new) Then Return
		$UnicodeMode = "Copy"
	EndIf
	SplashOff()

	$oldpath = $file
	$oldName = $filename
	$oldoutdir = $outdir
	FilenameParse($new)
	$outdir = $initoutdir
	$validdir = _DirCreate($outdir)
	If NOT $validdir Then terminate("invaliddir", $outdir)
	$createdir = True
EndFunc

; Parse string for environmental variables and return expanded output
; Замена в строке переменных окружения на их значения
Func EnvParse($string)
	$arr = StringRegExp($string, "%.*%", 2)
	For $i = 0 To UBound($arr)-1
		$string = StringReplace($string, $arr[$i], EnvGet(StringReplace($arr[$i], "%", "")))
	Next
	Return $string
EndFunc

; Translate text
; Перевод текста
Func t($t, $vars = '')
	Local $ldir = @scriptdir
	If $language <> 'English' Then $ldir &= '\lang'
	$return = IniRead($ldir & '\' & $language & '.ini', 'UniExtract', $t, '')
	If $return == '' Then
		AddLog(t('NOT_TRANLATION', CreateArray($t)))
		$return = IniRead(@ScriptDir & '\English.ini', 'UniExtract', $t, '???')
		If $return = '???' Then
			AddLog(t('WARN_TRANLATION', CreateArray($t)))
			Return $t
		EndIf
	EndIf
	$return = StringReplace($return, '%n', @CRLF)
	$return = StringReplace($return, '%t', @TAB)
	For $i = 0 To UBound($vars)-1
		$return = StringReplace($return, '%s', $vars[$i], 1)
	Next
	Return $return
EndFunc

; Read preferences
; Чтение настроек из UniExtract.ini
Func ReadPrefs()
	AddLog(t('READING_FROM') & ' ' & 'UniExtract.ini')
	$section = "UniExtract Preferences"
	LoadPref("globalprefs", $globalprefs)
	LoadPref("history", $history)
	LoadPref("debugdir", $debugdir, "Ini", False)
	LoadPref("logdir", $logdir, "Ini", False)
	LoadPref("language", $language, "Ini", False)
	LoadPref("appendext", $appendext)
	LoadPref("removetemp", $removetemp)
	LoadPref("removedupe", $removedupe)
	LoadPref("warnexecute", $warnexecute)
	LoadPref("nodoswin", $nodoswin)
	LoadPref("mindoswin", $mindoswin)
	LoadPref("useepe", $useepe)
	LoadPref("usedie", $usedie)
	LoadPref("usepeid", $usepeid)
	LoadPref("savepass", $savepass)
	LoadPref("savelog", $savelog)
	LoadPref("savelogalways", $savelogalways)

	; read local preferences, if appropriate, and override global preferences
	; чтение локальных настроек и замена соответствующих глобальных установок
	If NOT $globalprefs Then
		AddLog()
		AddLog(t('READING_FROM') & ' ' &  t('REGISTRY'))
		LoadPref("history", $history, "Reg")
		LoadPref("debugdir", $debugdir, "Reg", False)
		LoadPref("logdir", $logdir, "Reg", False)
		LoadPref("language", $language, "Reg", False)
		LoadPref("appendext", $appendext, "Reg")
		LoadPref("removetemp", $removetemp, "Reg")
		LoadPref("removedupe", $removedupe, "Reg")
		LoadPref("warnexecute", $warnexecute, "Reg")
		LoadPref("nodoswin", $nodoswin, "Reg")
		LoadPref("mindoswin", $mindoswin, "Reg")
		LoadPref("useepe", $useepe, "Reg")
		LoadPref("usedie", $usedie, "Reg")
		LoadPref("usepeid", $usepeid, "Reg")
		LoadPref("savepass", $savepass, "Reg")
		LoadPref("savelog", $savelog, "Reg")
		LoadPref("savelogalways", $savelog, "Reg")

	EndIf
EndFunc

; Load single preference
; Загрузка единичной настройки
Func LoadPref($name, ByRef $value, $dest = "Ini", $int = True)
	If $dest = "Ini" Then
		Local $return = IniRead($prefs, $section, $name, "")
	Else
		Local $return = RegRead($reg, $name)
	EndIf
	If @error Or $return = "" Then
		AddLog(t('ERROR_READING_OPTION', CreateArray($name, $value)))
		Return SetError(1, "", -1)
	EndIf

	If $int Then
		$value = Int($return)
	Else
		$value = $return
	EndIf

	AddLog(t('OPTION', CreateArray($name, $value)))
EndFunc   ;==>LoadPref

; Write preferences
; Сохранение настроек
Func WritePrefs()
	AddLog()
	AddLog(t('SAVE_PREF'))
	; Only update .ini file if globalprefs enabled
	; Только обновление .ini файла, если globalprefs=1
	If $globalprefs Then
		$section = "UniExtract Preferences"
		AddLog(t('SAVING_TO') & ' ' & 'UniExtract.ini')
		SavePref("globalprefs", $globalprefs)
		SavePref("history", $history)
		SavePref("debugdir", $debugdir)
		SavePref("logdir", $logdir)
		SavePref("language", $language)
		SavePref("appendext", $appendext)
		SavePref("removetemp", $removetemp)
		SavePref("removedupe", $removedupe)
		SavePref("warnexecute", $warnexecute)
		SavePref("nodoswin", $nodoswin)
		SavePref("mindoswin", $mindoswin)
		SavePref("useepe", $useepe)
		SavePref("usedie", $usedie)
		SavePref("usepeid", $usepeid)
		SavePref("savepass", $savepass)
		SavePref("savelog", $savelog)
		SavePref("savelogalways", $savelogalways)

	; Otherwise, write local settings to registry
	; Иначе запись локальных настроек в реестр
	Else
		AddLog(t('SAVING_TO') & ' ' &  t('REGISTRY'))
		SavePref("history", $history, "Reg")
		SavePref("debugdir", $debugdir, "Reg")
		SavePref("logdir", $logdir, "Reg")
		SavePref("language", $language, "Reg")
		SavePref("appendext", $appendext, "Reg")
		SavePref("removetemp", $removetemp, "Reg")
		SavePref("removedupe", $removedupe, "Reg")
		SavePref("warnexecute", $warnexecute, "Reg")
		SavePref("nodoswin", $nodoswin, "Reg")
		SavePref("mindoswin", $mindoswin, "Reg")
		SavePref("useepe", $useepe, "Reg")
		SavePref("usedie", $usedie, "Reg")
		SavePref("usepeid", $usepeid, "Reg")
		SavePref("savepass", $savepass, "Reg")
		SavePref("savelog", $savelog, "Reg")
		SavePref("savelogalways", $savelog, "Reg")
	EndIf
EndFunc

; Save single preference
; Сохранение единичной настройки
Func SavePref($name, $value, $dest = "Ini")
	If $dest = "Ini" Then
		IniWrite($prefs, $section, $name, $value)
	Else
		RegWrite($reg, $name, 'REG_SZ', $value)
	EndIf
	AddLog(t('SAVING', CreateArray($name, $value)))
EndFunc


; Read history
; Чтение истории
Func ReadHist($field)
	Local $items

	; Read from .ini file when globalprefs enabled
	; Чтение из .ini файла, если globalprefs=1
	If $globalprefs Then
		If $field = 'file' Then
			$section = "File History"
		ElseIf $field = 'directory' Then
			$section = "Directory History"
		Else
			Return
		EndIf
		For $i = 0 To 9
			$value = IniRead($prefs, $section, $i, "")
			If $value <> "" Then $items &= '|' & $value
		Next

	; Otherwise, read from HKCU registry
	; Иначе чтение из реестра
	Else
		If $field = 'file' Then
			$key = $reg & "\File"
		ElseIf $field = 'directory' Then
			$key = $reg & "\Directory"
		Else
			Return
		EndIf
		For $i = 0 To 9
			$value = RegRead($key, $i)
			If $value <> "" Then $items &= '|' & $value
		Next
	EndIf

	; return trimmed results
	; возвращение упорядоченных результатов
	Return StringTrimLeft($items, 1)
EndFunc

; Write history
; Запись истории
Func WriteHist($field, $new)
	; Only update .ini file if globalprefs enabled
	; Только обновление .ini файла, если globalprefs=1
	If $globalprefs Then
		If $field = 'file' Then
			$section = "File History"
		ElseIf $field = 'directory' Then
			$section = "Directory History"
		Else
			Return
		EndIf
		$histarr = StringSplit(ReadHist($field), '|')
		IniWrite($prefs, $section, "0", $new)
		If $histarr[1] == "" Then Return
		For $i = 1 To $histarr[0]
			If $i > 9 Then ExitLoop
			If $histarr[$i] = $new Then
				IniDelete($prefs, $section, String($i))
				ContinueLoop
			EndIf
			IniWrite($prefs, $section, String($i), $histarr[$i])
		Next

	; Otherwise, write local settings to registry
	; Иначе запись локальных настроек в реестр
	Else
		If $field = 'file' Then
			$key = $reg & "\File"
		ElseIf $field = 'directory' Then
			$key = $reg & "\Directory"
		Else
			Return
		EndIf
		$histarr = StringSplit(ReadHist($field), '|')
		RegWrite($key, "0", "REG_SZ", $new)
		If $histarr[1] == "" Then Return
		For $i = 1 To $histarr[0]
			If $i > 9 Then ExitLoop
			If $histarr[$i] = $new Then
				RegDelete($key, String($i))
				ContinueLoop
			EndIf
			RegWrite($key, String($i), "REG_SZ", $histarr[$i])
		Next
	EndIf
EndFunc

; Scan file using TrID
; Сканирование файла при помощи TrID
Func filescan($f, $analyze = 1)
	; Run TrID and dump output
	; Запуск TrID и дампинг вывода
	$filetype = ''
	SplashTextOn($title, t('SCANNING_EXE', CreateArray('TrID')), 330, 70, -1, $height, 16)
	AddLog(t('START_FILESCAN', CreateArray($f, 'TrID')))
	$return = StringSplit(FetchStdout($cmd & $trid & ' "' & $f & '"', $filedir, @SW_HIDE, False), @CRLF, 1)

	; Parse through results and append to string
	; Парсинг результатов сканирования
	For $i = 1 To UBound($return) - 1
		If StringInStr($return[$i], "%") Or (Not $analyze And (StringInStr($return[$i], "Related URL") Or StringInStr($return[$i], "Remarks"))) Then _
			$filetype &= $return[$i] & @CRLF
	Next
	$Log &= $filetype

	; Return filetype without matching if specified
	; Возвращение типа файла, если задано "без анализа"
	If NOT $analyze Then Return $filetype

	; Match known patterns
	; Проверка на совпадение с известными паттернами
	AddLog(t('MATCH_PATTERN'))
	Select
		Case StringInStr($filetype, "7-Zip compressed archive", 0)
			extract("7z", '7-Zip ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "ACE compressed archive", 0) _
			OR StringInStr($filetype, "ACE Self-Extracting Archive", 0)
			extract("ace", t('TERM_SFX') & ' ACE ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "ALZip compressed archive")
			CheckAlz()

		Case StringInStr($filetype, "FreeArc compressed archive", 0)
			extract("freearc", 'FreeARC ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Android boot image")
			extract("bootimg", ' Android boot ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "ARC Compressed archive", 0) _
			AND NOT StringInStr($filetype, "UHARC", 0)
			extract("arc", 'ARC ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "ARJ compressed archive", 0)
			extract("7z", 'ARJ ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "bzip2 compressed archive", 0)
			extract("bz2", 'bzip2 ' & t('TERM_COMPRESSED'))

		Case StringInStr($filetype, "Microsoft Cabinet Archive", 0) _
			OR StringInStr($filetype, "IncrediMail letter/ecard", 0)
			If $fileext = "msu" Then
				extract("msu", "Windows Update (MSU) " & t('TERM_PATCH'))
			Else
				extract("cab", 'Microsoft CAB ' & t('TERM_ARCHIVE'))
			EndIf

		Case StringInStr($filetype, "(.CHM) Windows HELP File", 0)
			extract("chm", 'Compiled HTML ' & t('TERM_HELP'))

		Case StringInStr($filetype, "CPIO Archive", 0)
			extract("7z", 'CPIO ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Debian Linux Package", 0)
			extract("7z", 'Debian ' & t('TERM_PackAGE'))

		Case StringInStr($filetype, "DGCA Digital G Codec Archiver", 0)
			extract("dgca", 'DGCA ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Disk Image (Macintosh)", 0)
			extract("ctar", 'DMG ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "Gentee Installer executable", 0)
			extract("ie", 'Gentee ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "GZipped File", 0)
			extract("gz", 'gzip ' & t('TERM_COMPRESSED'))

		Case StringInStr($filetype, "(.HLP) Windows Help file", 0)
			extract("hlp", 'Windows ' & t('TERM_HELP'))

		Case StringInStr($filetype, "Generic PC disk image", 0)
			extract("img", 'Floppy ' & t('TERM_DISK') & ' ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "Google Chrome Extension", 0)
			extract("crx", 'Google Chrome Plugin/Extension ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "Inno Setup installer", 0)
			checkInno()

		Case StringInStr($filetype, "Installer VISE executable", 0)
			extract("ie", 'Installer VISE ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "InstallShield archive", 0)
			extract("is3arc", 'InstallShield 3.x ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "InstallShield compressed archive", 0)
			extract("iscab", 'InstallShield CAB ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "ISO CDImage", 0)
			extract("iso", 'CD-ROM ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "ISo Zipped format", 0)
			extract("to", 'ISZ CD-ROM (UltraISO) ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "KGB archive", 0)
			extract("kgb", 'KGB ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "LHARC/LZARK compressed archive", 0)
			extract("7z", 'LZH ' & t('TERM_COMPRESSED'))

		Case StringInStr($filetype, "lzop compressed", 0)
			extract("lzo", 'LZO ' & t('TERM_COMPRESSED'))

		Case StringInStr($filetype, "LZX Amiga compressed archive", 0)
			extract("lzx", 'LZX ' & t('TERM_COMPRESSED'))

		Case StringInStr($filetype, "Macromedia Flash Player", 0)
			extract("swf", 'Shockwave Flash ' & t('TERM_CONTAINER'))

		Case StringInStr($filetype, "Microsoft Internet Explorer Web Archive", 0)
			extract("mht", 'MHTML ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Microsoft Reader eBook", 0)
			extract("lit", 'Microsoft LIT ' & t('TERM_EBOOK'))

		Case StringInStr($filetype, "Microsoft Windows Installer merge module", 0)
			extract("msm", 'Windows Installer (MSM) ' & t('TERM_MERGE_MODULE'))

		Case StringInStr($filetype, "Microsoft Windows Installer package", 0)
			extract("msi", 'Windows Installer (MSI) ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, "Microsoft Windows Installer patch", 0)
			extract("msp", 'Windows Installer (MSP) ' & t('TERM_PATCH'))

		Case StringInStr($filetype, "(.MSU) Windows Update Package")
			extract("msu", "Windows Update (MSU) " & t('TERM_PATCH'))

		Case StringInStr($filetype, "HTC NBH ROM Image", 0)
			extract("nbh", 'NBH ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "Outlook Express E-mail folder", 0)
			extract("dbx", 'Outlook Express ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "PEA archive", 0)
			extract("pea", 'Pea ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "(.PDF) Adobe Portable Document Format", 0)
			extract("pdf", 'PDF ' & t('TERM_EBOOK'))

		Case StringInStr($filetype, "PowerISO Direct-Access-Archive", 0) Or StringInStr($filetype, "gBurner Image", 0)
			extract("daa", 'DAA/GBI ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "RAR Archive", 0)
			extract("rar", 'RAR ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "RAR Self Extracting archive", 0)
			checkZip()
			extract("rar", 'RAR ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Reflexive Arcade installer wrapper", 0)
			extract("inno", 'Reflexive Arcade ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "(.RPM) RPM Package", 0)
			extract("7z", 'RPM ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, "Setup Factory 6.x Installer", 0)
			extract("ie", 'Setup Factory ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, "StuffIT SIT compressed archive", 0)
			extract("sit", 'StuffIt ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "SymbianOS Installer", 0)
			extract("sis", 'SymbianOS ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "TAR archive", 0)
			extract("tar", 'Tar ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "UHARC compressed archive", 0)
			extract("uha", 'UHARC ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Magic ISO Universal Image Format", 0)
			extract("uif", 'UIF ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "Base64 Encoded file", 0)
			extract("uu", 'Base64 ' & t('TERM_ENCODED'))

		Case StringInStr($filetype, "Quoted-Printable Encoded file", 0)
			extract("uu", 'Quoted-Printable ' & t('TERM_ENCODED'))

		Case StringInStr($filetype, "UUencoded file", 0) _
			OR StringInStr($filetype, "XXencoded file", 0)
			extract("uu", 'UUencoded ' & t('TERM_ENCODED'))

		Case StringInStr($filetype, "yEnc Encoded file", 0)
			extract("uu", 'yEnc ' & t('TERM_ENCODED'))

		Case StringInStr($filetype, "Windows Imaging Format", 0)
			extract("7z", 'WIM ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "Wise Installer Executable", 0)
			extract("wise", 'Wise Installer ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, "xz container", 0)
			extract("xz", 'XZ ' & t('TERM_COMPRESSED'))

		Case StringInStr($filetype, "UNIX Compressed file", 0)
			extract("Z", 'LZW ' & t('TERM_COMPRESSED'))

		Case StringInStr($filetype, "ZIP compressed archive", 0) _
			OR StringInStr($filetype, "Winzip Win32 self-extracting archive", 0)
			extract("zip", 'ZIP ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Zip Self-Extracting archive", 0)
			checkInno()

		Case StringInStr($filetype, "ZOO compressed archive", 0)
			extract("zoo", 'ZOO ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "ZPAQ compressed archive", 0)
			extract("zpaq", 'ZPAQ ' & t('TERM_ARCHIVE'))

		; Forced to bottom of list due to false positives
		; В конце списка из-за ложных срабатываний
		Case StringInStr($filetype, "LZMA compressed file", 0)
			check7z()

		Case StringInStr($filetype, "InstallShield setup", 0)
			checkInstallShield()

	EndSelect
	AddLog(t('NO_MATCH'))

EndFunc

; Scan .exe file using Exeinfo PE
; Сканирование .exe файла при помощи Exeinfo PE
Func epescan($f, $analyze = 1)
	SplashTextOn($title, t('SCANNING_EXE', CreateArray("Exeinfo PE")), 330, 70, -1, $height, 16)
	; Check Exeinfo PE registry keys
	; Проверка есть ли записи о Exeinfo PE в реестре
	AddLog()
	AddLog(t('START_FILESCAN', CreateArray($f, 'Exeinfo PE')))
	Local $regpepe = False, $regArray, $regKey = "HKCU\Software\ExEi-pe"
	RegEnumVal ($regKey, 1)
	If @error Then 
		$regpepe = True
	Else
		$regArray = _RegEnumKeyEx($regKey, 2 + 128 + 256)
	EndIf

	; Set Exeinfo PE options
	; Установка настроек Exeinfo PE
	RegWrite($regKey, "ExeError", "REG_DWORD", 1)
	RegWrite($regKey, "AllwaysOnTop", "REG_DWORD", 0)
	RegWrite($regKey, "Shell_integr", "REG_DWORD", 0)
	RegWrite($regKey, "Lang", "REG_DWORD", 0)
	RegWrite($regKey, "Skin", "REG_DWORD", 0)
	RegWrite($regKey, "Scan", "REG_DWORD", 0)
	RegWrite($regKey, "Log", "REG_DWORD", 0xFFFFFFFF)
	RegWrite($regKey, "Big_GUI", "REG_DWORD", 0)
	RegWrite($regKey, "closeExEi_whenExtRun", "REG_DWORD", 0)

	; Run Exeinfo PE and dump output
	; Запуск Exeinfo PE и дампинг вывода
	AddLog(t('SCANNING_EPE_STANDART'))
	RunWait($epe & ' "' & $f & '*" /sx /lol:' & $debugfile, $filedir, @SW_HIDE)
	; Parse through results and append to string
	; Парсинг результатов сканирования
	$filetype = ''
	$infile = FileOpen($debugfile, 0)
	$filetype = FileRead($infile)
	FileClose($infile)
	$Log &= $filetype
	; Run Exeinfo PEscan with external signatures and dump output
	; Запуск Exeinfo PE с внешними сигнатурами и дампинг вывода
	AddLog(t('SCANNING_EPE_EXTERNAL'))
	RunWait($epe & ' "' & $f & '*" /se /lol:' & $debugfile, $filedir, @SW_HIDE)
	; Parse through results and append to string
	; Парсинг результатов сканирования
	$filetypeext = ''
	$infile = FileOpen($debugfile, 0)
	$filetypeext = FileRead($infile)
	FileClose($infile)
	$Log &= $filetypeext
	$filetype &= $filetypeext
	_FileDelete($debugfile)

	; Delete Exeinfo PE registry keys
	; Удаление записей о Exeinfo PE из реестра
	If $regpepe Then 
		RegDelete ($regKey)
	Else
		WriteReg($regArray)
	EndIf


	; Return filetype without matching if specified
	; Возвращение типа файла, если задано "без анализа"
	If NOT $analyze Then Return $filetype
	matchpatterns()
	$testhex = True
	Return $filetype
EndFunc

; Scan .exe file using Detect-It-Easy
; Сканирование .exe файла при помощи Detect-It-Easy
Func diescan($f, $analyze = 1)
	SplashTextOn($title, t('SCANNING_EXE', CreateArray("Detect-It-Easy")), 330, 70, -1, $height, 16)
	; Run Detect-It-Easy and dump output
	; Запуск Detect-It-Easy и дампинг вывода
	AddLog()
	AddLog(t('START_FILESCAN', CreateArray($f, 'Detect-It-Easy')))
	$filetype = FetchStdout($cmd & $die & ' "' & $f & '" -fullscan:yes', $filedir, @SW_HIDE)
	$Log &= $filetype

	; Return filetype without matching if specified
	; Возвращение типа файла, если задано "без анализа"
	If NOT $analyze Then Return $filetype
	matchpatterns()
	$testhex = True
	Return $filetype
EndFunc

; Scan .exe file using PEiD
; Сканирование .exe файла при помощи PEiD
Func exescan($f, $scantype, $analyze = 1)
	SplashTextOn($title, t('START_FILESCAN', CreateArray($f, 'PEiD')) & ' (' & $scantype & ')', 330, 60, -1, $height, 16)
	AddLog()
	AddLog(t('START_FILESCAN', CreateArray($f, 'PEiD')) & ' (' & $scantype & ')')
	; Backup existing PEiD options
	; Сохранение настроек PEiD из реестра
	RegRead("HKCU\Software\PEiD", "")
	If @error = 1 Then $regpeid = 1
	$exsig = RegRead("HKCU\Software\PEiD", "ExSig")
	$loadplugins = RegRead("HKCU\Software\PEiD", "LoadPlugins")
	$stayontop = RegRead("HKCU\Software\PEiD", "StayOnTop")

	; Set PEiD options
	; Установка настроек PEiD
	RegWrite("HKCU\Software\PEiD", "ExSig", "REG_DWORD", 1)
	RegWrite("HKCU\Software\PEiD", "LoadPlugins", "REG_DWORD", 0)
	RegWrite("HKCU\Software\PEiD", "StayOnTop", "REG_DWORD", 0)

	; Analyze file
	; Анализ файла
	$filetype = ""
	Run($peid & ' -' & $scantype & ' "' & $f & '"', @scriptdir, @SW_HIDE)
	WinWait($peidtitle)
	While ($filetype = "") OR ($filetype = "Scanning...")
		Sleep (100)
		$filetype = ControlGetText($peidtitle, "", "Edit2")
	WEnd
	WinClose($peidtitle)
	$Log &= $filetype & @CRLF

	; Restore previous PEiD options
	; Восстановление первоначальных настроек PEiD
	If $regpeid <> 1 Then
		If $exsig Then RegWrite("HKCU\Software\PEiD", "ExSig", "REG_DWORD", $exsig)
		If $loadplugins Then RegWrite("HKCU\Software\PEiD", "LoadPlugins", "REG_DWORD", $loadplugins)
		If $stayontop Then RegWrite("HKCU\Software\PEiD", "StayOnTop", "REG_DWORD", $stayontop)
	Else
		RegDelete ("HKCU\Software\PEiD")
	EndIf
	SplashOff()

	; Return filetype without matching if specified
	; Возвращение типа файла, если задано "без анализа"
	If NOT $analyze Then Return $filetype

	matchpatterns()

	If $scantype == 'ext' Then $testhex = True

	; Wait until after External scan is run before trying 7-Zip;
	; new version is too agreessive
	; Проверка 7-Zip только после проверки с помощью внешней базы сигнатур
	If NOT ($scantype == 'ext') Then $test7z = False

	Return $filetype
EndFunc

; Match known patterns
; Проверка на совпадение с известными типами файлов
Func matchpatterns()
	AddLog(t('MATCH_PATTERN'))
	Select
		Case StringInStr($filetype, "7-Zip", 0) AND NOT StringInStr($filetype, "WiX Installer", 0)
			extract("7z", t('TERM_SFX') & ' 7-Zip ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Advanced Installer", 0)
			extract("cai", 'Advanced Installer ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, ".ALZ  ALZip")
			CheckAlz()

		Case StringInStr($filetype, "Android boot image")
			extract("bootimg", ' Android boot ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "ARJ SFX", 0)
;			extract("arj", t('TERM_SFX') & ' ARJ ' & t('TERM_ARCHIVE'))
			extract("7z", t('TERM_SFX') & ' ARJ ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "DGCA", 0)
			extract("dgca", 'DGCA ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, ".dmg  Mac OS", 0)
			extract("ctar", 'DMG ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "Enigma Virtual Box")
			extract("enigma", ' Enigma Virtual Box ' & t('TERM_EXECUTABLE'))

		Case StringInStr($filetype, "Excelsior Installer", 0)
			extract("ei", 'Excelsior Installer ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "FreeArc", 0)
			extract("freearc", 'FreeArc ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Gentee Installer", 0) OR StringInStr($filetype, "CreateInstall", 0)
			extract("gentee", 'Gentee ' & t('TERM_INSTALLER'))

#comments-start
		Case StringInStr($filetype, "Ghost Installer Studio", 0)
			extract("ghost", 'Ghost Installer Studio ' & t('TERM_INSTALLER'))
#comments-end
		Case StringInStr($filetype, "Inno Setup", 0)
			checkInno()

		; Needs to be before InstallShield - Bioruebe https://github.com/Bioruebe/UniExtract2
		Case StringInStr($filetype, "InstallAware", 0)
			extract("7z", 'InstallAware ' & t('TERM_INSTALLER') & ' ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, "Installer VISE", 0) OR StringInStr($filetype, "VISE Installer", 0) OR StringInStr($filetype, "Installer - VISE", 0)
			extract("ie", 'Installer VISE ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "InstallShield", 0)
			If NOT $isfailed Then extract("isexe", 'InstallShield ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "ISZ", 0)
			extract("to", 'ISZ CD-ROM (UltraISO) ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "KGB SFX", 0)
			extract("kgb", t('TERM_SFX') & ' KGB ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, "Microsoft SFX CAB", 0) AND NOT StringInStr($filetype, "WiX Installer", 0)
			check7z()

		Case StringInStr($filetype, "Microsoft Visual C++", 0) AND NOT StringInStr($filetype, "SPx Method", 0) AND NOT StringInStr($filetype, "Custom", 0) AND NOT StringInStr($filetype, "7.0", 0) AND NOT StringInStr($filetype, "RAR SFX", 0) AND NOT StringInStr($filetype, "Setup Factory", 0) AND NOT StringInStr($filetype, "WiX Installer", 0)
			$test7z = True
			$testie = True

		Case StringInStr($filetype, "Microsoft Visual C++ 7.0", 0) AND StringInStr($filetype, "Custom", 0) AND NOT StringInStr($filetype, "Hotfix", 0)
			extract("vssfx", 'Visual C++ ' & t('TERM_SFX') & ' ' & t('TERM_INSTALLER'))

		; removed - not possible to access due to 7zip check after deep scan
		; удалено - невозможно получить доступ к проверки с помощью 7zip после глубокого сканирования
		;Case StringInStr($filetype, "Microsoft Visual C++ 7.0", 0) AND StringInStr($filetype, "Custom", 0) AND StringInStr($filetype, "Hotfix", 0)
		;	extract("vssfxhotfix", 'Visual C++ ' & t('TERM_SFX') & ' ' & t('TERM_HOTFIX'))

		Case StringInStr($filetype, "Microsoft Visual C++ 6.0", 0) AND StringInStr($filetype, "Custom", 0)
			extract("vssfxpath", 'Visual C++ ' & t('TERM_SFX') & '' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "Netopsystems FEAD Optimizer", 0)
			extract("fead", 'Netopsystems FEAD ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, "Nullsoft", 0)
			checkNSIS()

		Case StringInStr($filetype, "PowerISO Direct-Access-Archive", 0)
			extract("daa", 'DAA/GBI ' & t('TERM_IMAGE'))

		Case StringInStr($filetype, "PDF", 0)
			extract("pdf", 'PDF ' & t('TERM_EBOOK'))

		Case StringInStr($filetype, "PEtite", 0) AND NOT StringInStr($filetype, "WinAce / SFX Factory", 0)
			$testace = True

		Case StringInStr($filetype, "RAR SFX", 0) OR StringInStr($filetype, "WINRAR", 0)  AND NOT StringInStr($filetype, "WiX Installer", 0)
			extract("rar", t('TERM_SFX') & ' RAR ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Reflexive Arcade Installer", 0)
			extract("inno", 'Reflexive Arcade ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "RoboForm Installer", 0)
			extract("robo", 'RoboForm ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "Setup Factory", 0)
			extract("sf", 'Setup Factory ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Smart Install Maker")
			extract("sim", 'Smart Install Maker ' & t('TERM_INSTALLER'))

		Case StringInStr($filetype, "SPx Method", 0) OR StringInStr($filetype, "CAB SFX", 0) OR StringInStr($filetype, "Microsoft Cabinet File", 0) OR StringInStr($filetype, "Cabinet Self-Extractor", 0) AND NOT StringInStr($filetype, "WiX Installer", 0)
			extract("cab", t('TERM_SFX') & ' Microsoft CAB ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Sqx", 0) 
			extract("sqx", t('TERM_SFX') & ' SQX ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "SuperDAT", 0)
			extract("superdat", 'McAfee SuperDAT ' & t('TERM_UPDATER'))

		Case StringInStr($filetype, "SWF", 0)
			extract("swf", 'Shockwave Flash ' & t('TERM_CONTAINER'))

		Case StringInStr($filetype, "ThinyApp Packager", 0) Or StringInStr($filetype, "Thinstall", 0) Or StringInStr($filetype, "VMware ThinApp", 0)
			extract("thinstall", "ThinApp/Thinstall" & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "WinAce / SFX Factory", 0)
			extract("ace", t('TERM_SFX') & ' ACE ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "Wise", 0) OR StringInStr($filetype, "PEncrypt 4.0", 0)
			extract("wise", 'Wise Installer ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, "WiX Installer", 0)
			extract("ms_vcr", 'WiX Installer ' & t('TERM_PACKAGE'))

		Case StringInStr($filetype, "XZ compressed data")
			extract("xz", 'XZ ' & t('TERM_COMPRESSED'))

		Case StringInStr($filetype, "ZIP SFX", 0)
			extract("zip", t('TERM_SFX') & ' ZIP ' & t('TERM_ARCHIVE'))

		Case StringInStr($filetype, "upx", 0) OR StringInStr($filetype, "aspack", 0) AND NOT $packfailed
			$packed = True

		Case StringInStr($filetype, "Borland Delphi", 0) AND NOT StringInStr($filetype, "RAR SFX", 0) AND NOT StringInStr($filetype, "WinAce / SFX Factory", 0) AND NOT StringInStr($filetype, "Enigma Virtual Box")
			$testinno = True
			$testzip = True

		; Default case for non-PE executables - try 7zip and unzip
		; Использование 7zip в общем случае для не-PE exe-шников
		Case Else
			AddLog(t('NO_MATCH'))
			$test7z = True
			$testzip = True
			$testie = True
	EndSelect

EndFunc

; Determine if 7-zip can extract the file
; Определение, может ли 7-zip распаковать файл
Func check7z()
	AddLog()
	AddLog(t('TERM_TESTING') & ' 7-Zip ' & t('TERM_INSTALLER'))
	SplashTextOn($title, t('TERM_TESTING') & ' 7-Zip ' & t('TERM_INSTALLER'), 330, 50, -1, $height, 16)
	$return = FetchStdout($cmd & $7z & ' l -p "' & $file & '"', $filedir, @SW_HIDE)
	If (StringInStr($return, "Listing archive:") OR StringInStr($return, "Wrong password?")) And Not StringInStr($return, "Can not open the file as archive") Then
		; failsafe in case TrID misidentifies MS SFX hotfixes
		; безотказно работает, если TrID не распознаёт MS SFX обновления
		If StringInStr($return, "_sfx_manifest_") Then
			SplashOff()
			extract("hotfix", 'Microsoft ' & t('TERM_HOTFIX'))
		EndIf
		SplashOff()
		Switch $fileext
			Case "exe"
				extract("7z", '7-Zip ' & t('TERM_INSTALLER') & ' ' & t('TERM_PACKAGE'))
			Case "xz"
				extract("xz", 'XZ ' & t('TERM_COMPRESSED'))
			Case "z"
				extract("Z", 'LZW ' & t('TERM_COMPRESSED'))
		EndSwitch
	EndIf
	SplashOff()
	$7zfailed = True
	AddLog(t('FALSE_TESTING') & ' 7-Zip ' & t('INSTALLER'))
	Return False
EndFunc

; Determine if file is ALZip archive
; Проверка не является файл ALZip архивом
Func CheckAlz()
	AddLog()
	AddLog(t('TERM_TESTING') & ' ALZ ' & t('TERM_ARCHIVE'))
	SplashTextOn($title, t('TERM_TESTING') & ' ALZ ' & t('TERM_ARCHIVE'), 330, 50, -1, $height, 16)
	$return = FetchStdout($cmd & $alz & ' -l "' & $file & '"', $filedir, @SW_HIDE)
	If (StringInStr($return, "Listing archive:", 0) And Not StringInStr($return, "corrupted file", 0) And Not StringInStr($return, "file open error", 0)) Then
		SplashOff()
		extract("alz", 'ALZ ' & t('TERM_ARCHIVE'))
	EndIf
	AddLog(t('FALSE_TESTING') & ' ALZ ' & t('ARCHIVE'))
	Return False
EndFunc

; Determine if file is self-extracting ACE archive
; Проверка не является файл SFX ACE архивом
Func checkAce()
	AddLog()
	AddLog(t('TERM_TESTING') & ' ACE ' & t('TERM_ARCHIVE'))
	; Ace testing handled by extract function
	extract("ace", t('TERM_SFX') & ' ACE ' & t('TERM_ARCHIVE'))
	$acefailed = True
	AddLog(t('FALSE_TESTING') & ' ACE ' & t('ARCHIVE'))
	Return False
EndFunc

; Determine if InstallExplorer can extract the file
; Определение, может ли InstallExplorer распаковать файл
Func checkIE()
	AddLog()
	AddLog(t('TERM_TESTING') & ' InstallExplorer ' & t('TERM_INSTALLER'))
	SplashTextOn($title, t('TERM_TESTING') & ' InstallExplorer ' & t('TERM_INSTALLER'), 330, 65, -1, $height, 16)
	$return = StringSplit(FetchStdout($cmd & $ie & ' l "' & $file & '"', $filedir, @SW_HIDE), @CRLF)
	For $i = 1 To $return[0]
		If StringInStr($return[$i], "##") Then
			$type = StringStripWS(StringReplace(StringTrimLeft($return[$i], StringInStr($return[$i], '-> ', 0) + 2), '##', ''), 3)
			extract("ie", $type & ' ' & t('TERM_INSTALLER'))
		EndIf
	Next
	SplashOff()
	$iefailed = True
	AddLog(t('FALSE_TESTING') & ' InstallExplorer ' & t('INSTALLER'))
	Return False
EndFunc

; Determine if file is Inno Setup installer
; Проверка не является файл инсталлятором Inno Setup
Func checkInno()
	AddLog()
	AddLog(t('TERM_TESTING') & ' Inno Setup ' & t('TERM_INSTALLER'))
	SplashTextOn($title, t('TERM_TESTING') & ' Inno Setup ' & t('TERM_INSTALLER'), 330, 50, -1, $height, 16)
	$return = FetchStdout($cmd & $inno & ' "' & $file & '"', $filedir, @SW_HIDE)
	If (StringInStr($return, "Version detected:", 0) And Not (StringInStr($return, "error", 0))) _
			Or (StringInStr($return, "Signature detected:", 0) _
			And Not StringInStr($return, "not a supported version", 0)) Then
		SplashOff()
		extract("inno", 'Inno Setup ' & t('TERM_INSTALLER'))
	EndIf
	SplashOff()
	$innofailed = True
	AddLog(t('FALSE_TESTING') & ' Inno Setup ' & t('INSTALLER'))
	checkIE()
	Return False
EndFunc

; Determine if file is really an InstallShield installer (not false positive)
; Проверка не является ли файл действительно InstallShield инсталлятором (не ложное срабатывание)
Func checkInstallShield()
	AddLog()
	AddLog(t('TERM_TESTING') & ' InstallShield ' & t('TERM_INSTALLER'))
	If StringInStr(diescan($file, 1), "Smart Install Maker") Then extract("sim", 'Smart Install Maker ' & t('TERM_INSTALLER'))
	; InstallShield testing handled by extract function
	extract("isexe", 'InstallShield ' & t('TERM_INSTALLER'))
	AddLog(t('FALSE_TESTING') & ' InstallShieldp ' & t('INSTALLER'))
	Return False
EndFunc

; Determine if file is NSIS installer
; Проверка не является ли файл NSIS инсталлятором
Func checkNSIS()
	AddLog()
	AddLog(t('TERM_TESTING') & ' NSIS ' & t('TERM_INSTALLER'))
	SplashTextOn($title, t('TERM_TESTING') & ' NSIS ' & t('TERM_INSTALLER'), 330, 50, -1, $height, 16)
	$return = FetchStdout($cmd & $7z & ' l "' & $file & '"', $filedir, @SW_HIDE)
	If StringInStr($return, "Listing archive:") And Not StringInStr($return, "Can not open the file as archive") Then
		SplashOff()
		extract("7z", 'NSIS ' & t('TERM_INSTALLER'))
	EndIf
	SplashOff()
	AddLog(t('FALSE_TESTING') & ' NSIS ' & t('INSTALLER'))
	checkIE()
	Return False
EndFunc

; Determine if file is self-extracting Zip archive
; Проверка не является файл SFX Zip архивом
Func checkZip()
	AddLog()
	AddLog(t('TERM_TESTING') & ' SFX ZIP ' & t('TERM_ARCHIVE'))
	SplashTextOn($title, t('TERM_TESTING') & ' SFX ZIP ' & t('TERM_ARCHIVE'), 330, 50, -1, $height, 16)
	$return = FetchStdout($cmd & $zip & ' -l "' & $file & '"', $filedir, @SW_HIDE)
	If Not StringInStr($return, "signature not found", 0) And Not StringInStr($return, "No zipfiles found", 0)Then
		SplashOff()
		extract("zip", t('TERM_SFX') & ' ZIP ' & t('TERM_ARCHIVE'))
	EndIf
	SplashOff()
	$zipfailed = True
	AddLog(t('FALSE_TESTING') & ' SFX ZIP ' & t('ARCHIVE'))
	Return False
EndFunc

; Check file signature
; Проверка по сигнатуре
Func checkhex()
	; Check for Caphyon Advanced Installer signature
	; Проверка по сигнатуре на Caphyon Advanced Installer
	AddLog()
	AddLog(t('TERM_TESTING') & ' Caphyon Advanced Installer')
	SplashTextOn($title, t('TERM_TESTING')  & ' Caphyon Advanced Installer', 350, 80, -1, $height, 16)
	$hexstring = '0000E979FEFFFF'
	$hexstring1 = '43617068796F6E' ; Сигнатура, соответствующая слову "Caphyon"
	$hexstring2 = 	'416476616E63656420496E7374616C6C6572' ; Сигнатура, соответствующая словам "Advanced Installer"
	If _Find_HexString_In_File($file, $hexstring, 2 * 1024 * 1024) AND _Find_HexString_In_File($file, $hexstring1, 2 * 1024 * 1024) AND _Find_HexString_In_File($file, $hexstring2, 2 * 1024 * 1024) Then extract("cai", 'Caphyon Advanced Installer ' & t('TERM_EXECUTABLE'))
	SplashOff()
	AddLog(t('FALSE_TESTING') & ' Caphyon Advanced Installer')
	$hexfailed = True
	Return False
EndFunc

; Extract from known archive format
; Разархивирование архивов известных форматов
Func extract($arctype, $arcdisp)
	Global $logarcdisp = $arcdisp
	AddLog()
	AddLog(t('EXTRACTING') & ' ' & $arcdisp)
	; Display banner and create subdirectory
	; Показать баннер и создать поддиректорию
	SplashTextOn($title, t('EXTRACTING') & @CRLF & $arcdisp, 330, 90, -1, $height, 16)
	If NOT $createdir Then $consolewin = 1
	$dirmtime = FileGetTime($outdir, 0, 1)
	$initdirsize = DirGetSize($outdir)
	$tempoutdir = _TempFile($outdir, 'uni_', '')
	; Extract archive based on filetype
	; Распаковка архива, исходя из типа файла
	Switch $arctype
		Case "7z"
			; Ignore duplicates for specific files: NSIS
			; Игнорировать дубликаты для типа файлолв: NSIS
			Local $appendargs = ''
			If StringInStr($filetype, 'Nullsoft Install System', 0) Then
				$appendargs = '-aos'
			EndIf

			If StringInStr($filetype, 'Nullsoft PiMP SFX', 0) Then
				$appendargs = '-aou'
			EndIf

			Local $sPassword = Password($cmd & $7z & ' t -p "' & $file & '"', $cmd & $7z & ' t -p"%PASSWORD%" "' & $file & '"', "Encrypted = +", "Wrong password?", "Everything is Ok")
			LogRunWait($cmd & $7z & ' x ' & $appendargs & ($sPassword == ""? ' "': '-p"' & $sPassword & '" "') & $file & '"' & $output, $outdir, $consolewin)

			; Extract inner CPIO for RPMs
			; Извлечение из вложенного файла CPIO для RPM пакета Linux
			If StringInStr($filetype, '(.RPM) RPM Package', 0) AND FileExists($outdir & '\' & ($oldName? $oldName: $filename) & '.cpio') Then
				AddLog(t('EXTRACTING_CPIO'))
				LogRunWait($cmd & $7z & ' x "' & $outdir & '\' & ($oldName? $oldName: $filename) & '.cpio"' & $output, $outdir, $consolewin)
				AddLog(t('DELETE_FILE') & ' "' & $outdir & '\' & ($oldName? $oldName: $filename) & '.cpio' & '"')
				_FileDelete($outdir & '\' & ($oldName? $oldName: $filename) & '.cpio')
			EndIf

			; Extract inner tarball for DEBs
			; Извлечение из вложенного файла TAR для Debian пакета Linux
			If StringInStr($filetype, 'Debian Linux Package', 0) AND FileExists($outdir & '\data.tar') Then
				AddLog(t('EXTRACTING_DEB'))
				LogRunWait($cmd & $7z & ' x "' & $outdir & '\data.tar"' & $output, $outdir, $consolewin)
				AddLog(t('DELETE_FILE') & ' "' & $outdir & '\data.tar' & '"')
				_FileDelete($outdir & '\data.tar')
			EndIf

		Case "ace"
			AddLog(t('EXECUTING') & ' ' & $ace & ' -x "' & $file & '" "' & $outdir & '"')
			AddLog(t('RUN_OPTION', CreateArray($filedir, '1')))
			Opt("WinTitleMatchMode", 3)
			$pid = Run($ace & ' -x "' & $file & '" "' & $outdir & '"', $filedir)
			While 1
				If NOT ProcessExists($pid) Then ExitLoop
				If WinExists("Error") Then
					ProcessClose($pid)
					ExitLoop
				EndIf
				Sleep(100)
			WEnd
			AddLog(t('CANNOT_LOG', CreateArray($arcdisp)))

		Case "afp"
			;LogRunWait($cmd & $afp & ' x "' & $file & '"' & $output, $outdir, $consolewin)

		Case "alz"
			Local $sPassword = Password($cmd & $alz & ' -pwd "" "' & $file & '"', $cmd & $alz & ' -pwd "%PASSWORD%" "' & $file & '"' & $output, "invalid password", "password was not set", "unalziiiing", True)

		Case "arc"
			LogRunWait($cmd & $arc & ' x "' & $file & '"' & $output, $outdir, $consolewin)

		Case "bootimg"
			$ret = $outdir & "\" & $bootimg
			$ret2 = $outdir & '\boot.img'
			_FileCopy(@scriptdir & "\bin\" & $bootimg, $outdir)
			_FileMove($file, $ret2)
			LogRunWait($cmd & '"' & $ret & '" --unpack-bootimg' & $output, $outdir, $consolewin)
			_FileMove($ret2, $filedir & '\' & $filename & "." & $fileext)
			_FileDelete($ret)

		Case "bz2"
			LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			If FileExists($outdir & '\' & $filename) Then
				LogRunWait($cmd & $7z & ' x "' & $outdir & '\' & $filename & '"' & $output, $outdir, $consolewin)
				_FileDelete($outdir & '\' & $filename)
			EndIf

		Case "cab"
			If StringInStr($filetype, 'Type 1', 0) Then
				If $warnexecute Then Warn_Execute($filename & '.exe /q /x:"<outdir>"')
				LogRunWait('"' & $file & '" /q /x:"' & $outdir & '"' & $output, $outdir, $consolewin)
			Else
				LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			EndIf

		Case "cai"
			If $warnexecute Then Warn_Execute($filename & '.exe /extract:"<outdir>"')
			LogRunWait('"' & $file & '" /extract:"' & $outdir & '"', $outdir, $consolewin)

		Case "cdi"
			; Prompt user to continue
			; Запрос пользователя о продолжении
			SplashOff()
			$convert = MsgBox(65, $title, t('CONVERT_CDROM', CreateArray('CDI')))
			If $convert <> 1 Then
				If $createdir Then _DirRemove($outdir, 0)
				terminate("silent")
			EndIf
			SplashTextOn($title, t('EXTRACTING') & @CRLF & $arcdisp, 330, 70, -1, $height, 16)

			; Begin conversion to .iso format
			; Начало конвертации в формат .iso
			_DirCreate($tempoutdir)
			ControlSetText($title, '', 'Static1', t('EXTRACTING') & @CRLF & 'CDI CD-ROM ' & t('TERM_IMAGE') & ' (' & t('TERM_STAGE') & ' 1)')
			AddLog(t('EXTRACTING') & 'CDI CD-ROM ' & t('TERM_IMAGE') & ' (' & t('TERM_STAGE') & ' 1)')
			LogRunWait($cmd & $cdi & ' "' & $file & '" -iso' & $output, $tempoutdir, $consolewin)

			$isos = FileFindFirstFile($tempoutdir & '\*.iso')
			$isofile = $tempoutdir & '\' & FileFindNextFile($isos)
			FileClose($isos)

		Case "chm"
			LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			_FileDelete($outdir & '\#*')
			_FileDelete($outdir & '\$*')
			$dirs = FileFindFirstFile($outdir & '\*')
			If $dirs <> -1 Then
				$dir = FileFindNextFile($dirs)
				Do
					If StringLeft($dir, 1) == '#' OR StringLeft($dir, 1) == '$' Then _DirRemove($outdir & '\' & $dir,  1)
					$dir = FileFindNextFile($dirs)
				Until @error
			EndIf
			FileClose($dirs)

		Case "crx"
			LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)

		Case "ctar"
			; Get existing files in $outdir
			; Получение списка файлов из $outdir
			$oldfiles = ReturnFiles($outdir)

			; Decompress archive with 7-zip
			; Распаковка архива с помощью 7-zip
			LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)

			; Check for new files
			; Проверка новых фалов
			$handle = FileFindFirstFile($outdir & "\*")
			If NOT @error Then
				While 1
					$fname = FileFindNextFile($handle)
					If @error Then ExitLoop
					If NOT StringInStr($oldfiles, $fname) Then

						; Check for supported archive format
						; Проверка на архивы поддерживаемых форматов
						$return = FetchStdout($cmd & $7z & ' l "' & $outdir & '\' & $fname & '"', $outdir, @SW_HIDE)
						If StringInStr($return, "Listing archive:", 0) Then
							LogRunWait($cmd & $7z & ' x "' & $outdir & '\' & $fname & '"' & $output, $outdir, $consolewin)
							_FileDelete($outdir & '\' & $fname)
						EndIf
					EndIf
				WEnd
			EndIf
			FileClose($handle)

		Case "daa"
			; Prompt user to continue
			; Запрос пользователя о продолжении
			SplashOff()
			$convert = MsgBox(65, $title, t('CONVERT_CDROM', CreateArray('CDI')))
			If $convert <> 1 Then
				If $createdir Then _DirRemove($outdir, 0)
				terminate("silent")
			EndIf
			SplashTextOn($title, t('EXTRACTING') & @CRLF & $arcdisp, 330, 70, -1, $height, 16)

			; Begin conversion to .iso format
			; Начало конвертации в формат .iso
			_DirCreate($tempoutdir)
			ControlSetText($title, '', 'Static1', t('EXTRACTING') & @CRLF & 'CDI CD-ROM ' & t('TERM_IMAGE') & ' (' & t('TERM_STAGE') & ' 1)')
			AddLog(t('EXTRACTING') & 'CDI CD-ROM ' & t('TERM_IMAGE') & ' (' & t('TERM_STAGE') & ' 1)')
			$isofile = $tempoutdir & '\' & $filename & '.iso'
			LogRunWait($cmd & $daa & ' "' & $file & '" "' & $isofile & '"' & $output, $tempoutdir, $consolewin)

		Case "dgca"
			Local $sPassword = Password($cmd & $dgca & ' e "' & $file & '"', $cmd & $dgca & ' l -p%PASSWORD% "' & $file & '"', "Archive encrypted.", 0, "-------------------------")
			LogRunWait($cmd & $dgca & ' e ' & ($sPassword == ""? '"': '-p' & $sPassword & ' "') & $file & '" "' & $outdir & '"' & $output, $outdir, $consolewin)

		Case "ei"
			If $warnexecute Then Warn_Execute($filename & '.exe /batch /no-reg /no-postinstall /dest "<outdir>"')
			LogRunWait($cmd & '"' & $file & '" /batch /no-reg /no-postinstall /dest "' & $outdir & '"' & $output, $outdir, $consolewin)

		Case "enigma"
			AddLog(t('EXECUTING') & ' ' & $enigma & ' "' & $file & '"')
			AddLog(t('RUN_OPTION', CreateArray($outdir, '1')))
			Run($enigma & ' "' & $file & '"', $outdir)
			WinWait("EnigmaVBUnpacker")
			WinClose("EnigmaVBUnpacker")
			AddLog(t('CANNOT_LOG', CreateArray($arcdisp)))
			
			MoveFiles($filedir & "\%DEFAULT FOLDER%", $outdir)
			_DirRemove($filedir & "\%DEFAULT FOLDER%") 
			_FileDelete($filedir & "\" & $filename & "_unpacked.exe") 

		Case "dbx"
			LogRunWait($cmd & $dbx & ' x "' & $file & '" "' & $outdir & '\"' & $output, $filedir, $consolewin)

		Case "fead"
			If $warnexecute Then Warn_Execute($filename & '.exe /s -nos_ne -nos_o"<outdir>"')
			LogRunWait($file & ' /s -nos_ne -nos_o"' & $tempoutdir & '"' & $output, $filedir, $consolewin)
			FileSetAttrib($tempoutdir & '\*', '-R', 1)
			MoveFiles($tempoutdir, $outdir)
			_DirRemove($tempoutdir)

		Case "freearc"
			LogRunWait($cmd & $unarc & ' x "' & $file & '" -o+ -dp"' & $outdir & '"' & $output, $outdir, $consolewin)

		Case "gentee"
			$choice = MethodSelect($arctype, $arcdisp)
			If $choice == 'Gentee TC 1 (InstExpl.wcx)' Then
				LogRunWait($cmd & $ie & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			ElseIf $choice == 'Gentee TC 2 (TotalObserver.wcx)' Then 
				LogRunWait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			EndIf

#comments-start
		Case "ghost"
			$ret = $outdir & "\" & $filename & ".exe"
			FileCopy($file, $ret)

	Local $regpepe = False
	RegRead("HKCU\Software\ExEi-pe", "")
	If @error Then $regpepe = True
	; Execute Exeinfo PE
	; Запуск Exeinfo PE 
	Run($epe & ' "' & $ret & '"', $filedir, @SW_MINIMIZE)
;	RunWait($epe & ' "' & $f & '*" /s /log:' & $debugfile, $filedir, @SW_HIDE)

;			$aReturn = OpenExeInfo($ret)
	WinWait("Exeinfo PE")
	WinSetState("Exeinfo PE", "", @SW_HIDE)

			MouseMove(0, 0, 0)
			ControlClick("Exeinfo PE", "", "[CLASS:TBitBtn; INSTANCE:15]")
			ControlSend("Exeinfo PE", "", "[CLASS:TBitBtn; INSTANCE:15]", "{DOWN}{DOWN}{RIGHT}{ENTER}")

			Local $TimerStart = TimerInit()
			Local $return = ""

			While Not StringInStr($return, "file saved")
				Sleep(200)
				$return = ControlGetText("Exeinfo PE", "", "TEdit5")
				If TimerDiff($TimerStart) > 5000 Then ExitLoop
			WEnd

	WinClose("Exeinfo PE")
;			CloseExeInfo($aReturn)
	; Delete Exeinfo PE registry keys
	; Удаление записей о Exeinfo PE из реестра
	If $regpeid Then RegDelete ("HKCU\Software\ExEi-pe")

			FileMove($ret, $filedir & "\")

			$ret2 = $ret & "-ovl"
			If FileExists($ret2) Then
				RunWait($cmd & $xor & ' "' & $ret2 & '" "' & $outdir & '\' & $filename & '.cab" 0x8D' & $output, $filedir, $consolewin)
;msgbox(64,$ret,$cmd & $xor & ' "' & $ret2 & '" "' & $outdir & '\' & $filename & '.cab" 0x8D' & $output)
				FileDelete($ret2)
			Else
				Local $success = 2
			EndIf

#comments-end
		Case "gz"
			LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			If FileExists($outdir & '\' & $filename) AND StringTrimLeft($filename, StringInStr($filename, '.', 0, -1)) = "tar" Then
				;RunWait($cmd & $tar & ' x "' & $outdir & '\' & $filename & '"' & $output, $outdir)
				LogRunWait($cmd & $7z & ' x "' & $outdir & '\' & $filename & '"' & $output, $outdir, $consolewin)
				_FileDelete($outdir & '\' & $filename)
			EndIf

		Case "hlp"
			LogRunWait($cmd & $hlp & ' "' & $file & '"' & $output, $outdir, $consolewin)
			If DirGetSize($outdir) > $initdirsize Then
				_DirCreate($tempoutdir)
				LogRunWait($cmd & $hlp & ' /r /n "' & $file & '"' & $output, $tempoutdir, $consolewin)
				_FileMove($tempoutdir & '\' & $filename & '.rtf', $outdir & '\' & $filename & '_Reconstructed.rtf')
				_DirRemove($tempoutdir, 1)
			EndIf

		; failsafe in case TrID misidentifies MS SFX hotfixes
		; безотказно работает, если TrID не распознаёт MS SFX обновления
		Case "hotfix"
			If $warnexecute Then Warn_Execute($filename & '.exe /q /x:"<outdir>"')
			LogRunWait('"' & $file & '" /q /x:"' & $outdir & '"' & $output, $outdir, $consolewin)

		Case "ie"
			_DirCreate($tempoutdir)
			LogRunWait($cmd & $ie & ' x "' & $file & '" "' & $tempoutdir & '"' & $output, $filedir, $consolewin)
			; Remove duplicate files
			; Удаление дубликатов
			If $removedupe Then
				; Read list of extracted files from InstallExplorer
				; Чтение списка извлеченных файлов с помощью InstallExplorer
				Local $iefiles[1]
				$infile = FileOpen($debugfile, 0)
				$line = FileReadLine($infile, 12)
				Do
					_ArrayAdd($iefiles, StringTrimLeft($line, StringInStr($line, '-> ', 0) + 2))
					$line = FileReadLine($infile)
				Until @error

				; Read actual extracted files
				; Чтение фактически извлеченнах файлов
				$exfiles = FileSearch($tempoutdir)

				; Remove extracted files not listed by InstallExplorer
				; Удаление извлеченных файлов, не попавших в список InstallExplorer
				For $i = 1 To $exfiles[0]
					For $j = 1 To UBound($iefiles) - 1
						If $exfiles[$i] = $tempoutdir & '\' & $iefiles[$j] Then
							ContinueLoop 2
						EndIf
					Next
					_FileDelete($exfiles[$i])
				Next

				; Remove duplicate directories
				; Удаление дубликатов директорий
				For $i = 1 To $exfiles[0]
					If StringInStr(FileGetAttrib($exfiles[$i]), 'D') Then
						If DirGetSize($exfiles[$i]) == 0 Then
							_DirRemove($exfiles[$i], 1)
						EndIf
					EndIf
				Next
			EndIf

			; Append missing file extensions
			; Добавление расширений к файлам
			If $appendext Then
				AppendExtensions($tempoutdir)
			EndIf

			; Move files to output directory and remove tempdir
			; Перемещение файлов в директорию назначения и удаление временной директории
			MoveFiles($tempoutdir & '\т', $tempoutdir)
			_DirRemove($tempoutdir & '\т')
			MoveFiles($tempoutdir, $outdir)
			_DirRemove($tempoutdir)

		Case "img"
			LogRunWait($cmd & $img & ' x "' & $outdir & '\' & $filename & '"' & $output, $outdir, $consolewin)

		Case "inno"
			If StringInStr($filetype, "Reflexive Arcade", 0) Then
				_DirCreate($tempoutdir)
				LogRunWait($cmd & $rai & ' "' & $file & '" "' & $tempoutdir & '\' & $filename & '.exe"' & $output, $filedir, $consolewin)
				Local $sPassword = Password($cmd & $inno & ' -t "' & $tempoutdir & '\' & $filename & '.exe"', $cmd & 'echo %PASSWORD%|' & $inno & ' -t "' & $tempoutdir & '\' & $filename & '.exe" -p', "Type in a password", 0, "Reading slice")
				LogRunWait($cmd & $inno & ' -x -m -a ' & ($sPassword == ""? '"': '-p"' & $sPassword & '" "') & $tempoutdir & '\' & $filename & '.exe"' & $output, $outdir, $consolewin)
				_FileDelete($tempoutdir & '\' & $filename & '.exe')
				_DirRemove($tempoutdir)
			Else
				Local $sPassword = Password($cmd & $inno & ' -t "' & $file & '"', $cmd & 'echo %PASSWORD%|' & $inno & ' -t "' & $file & '" -p', "Type in a password", 0, "Reading slice")
				LogRunWait($cmd & $inno & ' -x -m -a ' & ($sPassword == ""? '"': '-p"' & $sPassword & '" "') & $file & '"' & $output, $outdir, $consolewin)

			EndIf

		Case "is3arc"
			$choice = MethodSelect($arctype, $arcdisp)

			; Extract using i3comp
			; Извлечение с помощью i3comp
			If $choice == 'i3comp' Then
				LogRunWait($cmd & $is3arc & ' "' & $file & '" *.* -d -i' & $output, $outdir, $consolewin)

			; Extract using STIX
			; Извлечение с помощью STIX
			ElseIf $choice == 'STIX' Then
				LogRunWait($cmd & $is3exe & ' ' & FileGetShortName($file) & ' ' & FileGetShortName($outdir) & $output, $filedir, $consolewin)
			EndIf

		Case "iscab"
			; Try to extract with TotalObserver
			; Пробуем распаковать с помощью TotalObserver
			If DirGetSize($outdir) <= $initdirsize Then
				; Try to extract with unshield
				; Пробуем распаковать с помощью unshield
				$return = FetchStdout($cmd & $iscab_unshield & ' l "' & $file & '"', $filedir, @SW_HIDE)
				If Not StringInStr($return, "Failed to open", 0) Then
					LogRunWait($cmd & $iscab_unshield & ' -d "' & $outdir & '" -D 3 x "' & $file &'"' & $output, $outdir, $consolewin)
				Else
					; Try i6comp, Then i5comp
					; Пробуем распаковать с помощью i6comp, затем - с помощью i5comp
					; Generate list of files to extract (workaround bug in group mode)
					; Создания списка файлов для извлечения (workaround bug in group mode)
					Local $isfiles[1]
					$line = StringSplit(FetchStdout($cmd & $is6cab & ' l -o -r -d "' & $file & '"', $filedir, @SW_HIDE), @CRLF, 1)
					For $i = 1 To $line[0]
						_ArrayAdd($isfiles, StringTrimLeft($line[$i], 49))
					Next
					; If successful, display status window and extract files
					; Если получилось, показать статусное окно и извлечь файлы
					If $isfiles[1] <> '' Then
						SplashOff()
						ISCabExtract($is6cab, $isfiles, $arcdisp)
					EndIf
                                	
					; Otherwise, attempt to extract with i5comp
					; Иначе попытка извлечь с помощью i5comp
					If $isfiles[1] == '' OR DirGetSize($outdir) <= $initdirsize Then
						$line = StringSplit(FetchStdout($cmd & $is5cab & ' l -o -r -d "' & $file & '"', $filedir, @SW_HIDE), @CRLF, 1)
						For $i = 1 To $line[0]
							_ArrayAdd($isfiles, StringTrimLeft($line[$i], 49))
						Next
                     		
						; If successful, display status window and extract files
						; Если получилось, показать статусное окно и извлечь файлы
						If $isfiles[1] <> '' Then
							SplashOff()
							ISCabExtract($is5cab, $isfiles, $arcdisp)
						EndIf
					EndIf
				EndIf
			EndIf

		Case "isexe"
			exescan($file, 'ext', 0)
			If StringInStr($filetype, "3.x", 0) Then
				; Extract 3.x SFX installer using stix
				; Извлечение из 3.x SFX инсталлятора с помощью stix
				LogRunWait($cmd & $is3exe & ' ' & FileGetShortName($file) & ' ' & FileGetShortName($outdir) & $output, $filedir, $consolewin)

			Else
				$choice = MethodSelect($arctype, $arcdisp)

				; User-specified false positive; return for additional analysis
				; Выбор пользователя - не InstallShield; возврат для дополнительного анализа
				Switch $choice
					Case 'not InstallShield'
						$isfailed = True
						Return False
                                	
					; Extract using isxunpack
					; Извлечение с помощью isxunpack
					Case 'isxunpack'
						AddLog(t('EXECUTING') & ' ' & $cmd & $isexe & ' "' & $outdir & '\' & $filename & '.' & $fileext & '"' & $output)
						AddLog(t('RUN_OPTION', CreateArray($outdir, '1')))
						_FileMove($file, $outdir)
						Run($cmd & $isexe & ' "' & $outdir & '\' & $filename & '.' & $fileext & '"' & $output, $outdir)
						WinWait(@comspec)
						WinActivate(@comspec)
						Send("{ENTER}")
						ProcessWaitClose($isexe)
						AddLogDebugfile()                                	
						_FileMove($outdir & '\' & $filename & '.' & $fileext, $filedir)
					; Extract using TotalObserver.wcx
					; Извлечение с помощью TotalObserver.wcx
					Case 'IShield TC (TotalObserver.wcx)'
						LogRunWait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
                               	
					; added - this switch works for InstallScript installers (by Amritius)
					; добавлено - ключ для InstallScript инсталляторов (автор дополнения Amritius)
					Case 'InstallScript /s /extract_all:'
						If $warnexecute Then Warn_Execute($filename & '.exe /s /extract_all:"<outdir>"')
						LogRunWait($file & ' /s /extract_all:"' & $outdir & '"' & $output, $filedir, $consolewin)
                                	
					;added - this switch works for MSI-based installers (by Amritius)
					; добавлено - ключ для инсталляторов на основе MSI (автор дополнения Amritius)
					Case 'MSI /a /s /v"/qn TARGETDIR=.."'
						If $warnexecute Then Warn_Execute($filename & '.exe /a /s /v"/qn TARGETDIR=\"<outdir>\""')
						LogRunWait($file & ' /a /s /v"/qn TARGETDIR=\"' & $outdir & '\""' & $output, $filedir, $consolewin)
                                	
					; Try to extract MSI using cache switch
					; Попытка извлечения из MSI при помощи cache switch
					Case 'InstallShield /b'
						; Run installer and wait for temp files to be copied
						; Запуск инсталлятора и ожидание копирования временных файлов
						If $warnexecute Then Warn_Execute($filename & '.exe /b"<outdir>" /v"/l "<debugfile>""')
						AddLog(t('EXECUTING') & ' ' & $cmd & $isexe & ' "' & $outdir & '\' & $filename & '.' & $fileext & '"' & $output)
						AddLog(t('RUN_OPTION', CreateArray($outdir, '1')))
						SplashTextOn($title, t('INIT_WAIT'), 330, 70, -1, $height, 16)
						Run('"' & $file & '" /b"' & $tempoutdir & '" /v"/l "' & $debugfile & '""', $filedir)
                            	
						; Wait for matching windows for up to 20 seconds (40 * .5)
						; Ожидание окна с информацией об удачном извлечении до 20 секунд (40 * 0.5сек)
						Opt("WinTitleMatchMode", 4)
						Local $success
						For $i = 1 To 40
							If NOT WinExists("classname=MsiDialogCloseClass") Then
								Sleep(500)
							Else
								; Search temp directory for MSI support and copy to tempoutdir
								; Поиск временной директории для MSI и копирование в  tempoutdir
								$msihandle = FileFindFirstFile($tempoutdir & "\*.msi")
								If NOT @error Then
									While 1
										$msiname = FileFindNextFile($msihandle)
										If @error Then ExitLoop
										$tsearch = FileSearch(EnvGet("temp") & "\" & $msiname)
										If NOT @error Then
											$isdir = StringLeft($tsearch[1], StringInStr($tsearch[1], '\', 0, -1)-1)
											$ishandle = FileFindFirstFile($isdir & "\*")
											$fname = FileFindNextFile($ishandle)
											Do
												If $fname <> $msiname Then
													_FileCopy($isdir & "\" & $fname, $tempoutdir)
												EndIf
												$fname = FileFindNextFile($ishandle)
											Until @error
											FileClose($ishandle)
										EndIf
									WEnd
									FileClose($msihandle)
								EndIf
                                	
                                	
								; Move files to outdir
								; Перемещение файлов в outdir
								SplashOff()
								MsgBox(32, $title, t('INIT_COMPLETE', CreateArray(t('TERM_SUCCEEDED'))))
								AddLog(t('INIT_COMPLETE', CreateArray(t('TERM_SUCCEEDED'))))
								MoveFiles($tempoutdir, $outdir)
								_DirRemove($tempoutdir, 1)
								$success = True
								ExitLoop
							EndIf
						Next
 						AddLogDebugfile()   
                                	
						; Not a supported installer
						; Не поддерживаемый инсталлятор
						If NOT $success Then
							SplashOff()
							MsgBox(48, $title, t('INIT_COMPLETE', CreateArray(t('TERM_FAILED'))))
							AddLog(t('INIT_COMPLETE', CreateArray(t('TERM_FAILED'))))
						EndIf
				EndSwitch
			EndIf

		Case "iso"
				_DirCreate($tempoutdir)
				LogRunWait($cmd & $iso & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $tempoutdir, $consolewin)

				; Move files to output directory and remove tempdir
				; Перемещение файлов в директорию назначения и удаление временной директории
				MoveFiles($tempoutdir, $outdir)
				_DirRemove($tempoutdir)

		Case "kgb"
			LogRunWait($cmd & $kgb & ' "' & $file & '"' & $output, $outdir, $consolewin)

		Case "lit"
			LogRunWait($cmd & $lit & ' "' & $file & '" "' & $outdir & '"' & $output, $outdir, $consolewin)

		Case "lzo"
			LogRunWait($cmd & $lzo & ' -d -p"' & $outdir & '" "' & $file & '"' & $output, $filedir, $consolewin)

		Case "lzx"
			LogRunWait($cmd & $lzx & ' -x "' & $file & '"' & $output, $outdir, $consolewin)

		Case "mht"
			$choice = MethodSelect($arctype, $arcdisp)

			; Extract using ExtractMHT
			; Извлечение с помощью ExtractMHT
			Switch $choice
				Case 'ExtractMHT'
					LogRunWait($mht & ' "' & $file & '" "' & $outdir & '"' & $output, $outdir, $consolewin)
                        	
				Case 'MHT TC 1 (MHTUnp.wcx)'
					_DirCreate($tempoutdir)
					LogRunWait($cmd & $mht_ct & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $tempoutdir, $consolewin)
                        	
					; Move files to output directory and remove tempdir
					; Перемещение файлов в директорию назначения и удаление временной директории
					MoveFiles($tempoutdir, $outdir)
					_DirRemove($tempoutdir)
                        	
				Case 'MHT TC 2 (TotalObserver.wcx)' 
					LogRunWait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
                        	
			EndSwitch

		Case "msi"
			$choice = MethodSelect($arctype, $arcdisp)

			; Extract using administrative install
			; Извлечение при помощи административной установки
			Switch $choice
				Case 'MSI'
					LogRunWait('msiexec.exe /a "' & $file & '" /qb /l ' & $debugfile & ' TARGETDIR="' & $outdir & '"', $filedir, $consolewin)
					AddLogDebugfile()                                	
                        	
				; Extract with MsiX
				; Извлечение при помощи MsiX
				Case 'MsiX'
					;Local $appendargs = ''
					;If $appendext Then $appendargs = '/ext'
					Local $appendargs = $appendext? '/ext': ''
					LogRunWait($cmd & $msi_msix & ' "' & $file & '" /out "' & $outdir & '" ' & $appendargs & $output, $filedir, $consolewin)
                        	
				; Extract with JSWare Unpacker
				; Извлечение при помощи JSWare Unpacker
				Case 'JSWare Unpacker'
					;RunWait($msi_JSWare & ' "' & $file & '" "' & $debugfile & '" "' & $outdir & '" ', $filedir, $consolewin)
					LogRunWait($msi_jsmsix & ' "' & $file & '"|"' & $outdir & '"', $filedir, $consolewin, $outdir & '\MSI Unpack.log')
                        	
				; Extract with Less MSIerables (lessmsi)
				; Извлечение при помощи Less MSIerables (lessmsi)
				Case 'Less MSIerables (lessmsi)'
					If Not RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Client', 'Install') = 1 Then
						SplashOff()
						MsgBox(64, $title, t('DOTNET_FAILED', CreateArray("Less MSIerables (lessmsi)", "4.0")))
						AddLog(t('DOTNET_FAILED', CreateArray("Less MSIerables (lessmsi)", "4.0")))
						_DirRemove($tempoutdir, 1)
						If $createdir Then _DirRemove($outdir, 0)
						terminate("failed", $file, $arcdisp)
					EndIf
					LogRunWait($msi_lessmsi & ' x "' & $file & '" "' & $outdir & '\ "' & $output, $filedir, $consolewin)
                        	
				; Extract with MSI Total Commander plugin
				; Извлечение при помощи плагина MSI к Total Commander
				Case 'MSI TC 1 (msi.wcx)'
					_DirCreate($tempoutdir)
					LogRunWait($cmd & $msi_ct & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $filedir, $consolewin)
                        	
					; Extract files from extracted CABs
					; Извлечение из поддерживаемых извлечение CAB-ов
					$cabfiles = FileSearch($tempoutdir)
					For $i = 1 To $cabfiles[0]
						filescan($cabfiles[$i], 0)
						If StringInStr($filetype, "Microsoft Cabinet Archive", 0) Then
							LogRunWait($cmd & $7z & ' x "' & $cabfiles[$i] & '"', $outdir & $output, $consolewin)
							_FileDelete($cabfiles[$i])
						EndIf
					Next
                        	
					; Append missing file extensions
					; Добавление расширений к файлам
					If $appendext Then
						AppendExtensions($tempoutdir)
					EndIf
                        	
					; Move files to output directory and remove tempdir
					; Перемещение файлов в директорию назначения и удаление временной директории
					MoveFiles($tempoutdir, $outdir)
					_DirRemove($tempoutdir)
                        	
				Case 'MSI TC 2 (InstExpl.wcx)' 
					LogRunWait($cmd & $ie & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
                        	
				Case 'MSI TC 3 (TotalObserver.wcx)' 
					LogRunWait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			EndSwitch

		Case "msm"
			;Local $appendargs = ''
			;If $appendext Then $appendargs = '/ext'
			Local $appendargs = $appendext? '/ext': ''
			LogRunWait($cmd & $msi_msix & ' "' & $file & '" /out "' & $outdir & '" ' & $appendargs & $output, $filedir, $consolewin)

		Case "msp"
			$choice = MethodSelect($arctype, $arcdisp)

			; Extract using TC MSI
			; Извлечение при помощи TC MSI
			_DirCreate($tempoutdir)
			Switch $choice
				Case 'MSI TC Packer'
					LogRunWait($cmd & $msi_ct & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $filedir, $consolewin)
                        	
				; Extract with MsiX
				; Извлечение при помощи MsiX
				Case 'MsiX'
					LogRunWait($cmd & $msi_msix & ' "' & $file & '" /out "' & $tempoutdir & '"' & $output, $filedir, $consolewin)
                        	
				; Extract using 7-Zip
				; Извлечение при помощи 7-Zip
				Case '7-Zip'
					LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			EndSwitch

			; Regardless of method, extract files from extracted CABs
			; Извлечение из поддерживаемых извлечение независимо от метода CABs
			$cabfiles = FileSearch($tempoutdir)
			For $i = 1 To $cabfiles[0]
				filescan($cabfiles[$i], 0)
				If StringInStr($filetype, "Microsoft Cabinet Archive", 0) Then
					LogRunWait($cmd & $7z & ' x "' & $cabfiles[$i] & '"' & $output, $outdir, $consolewin)
					_FileDelete($cabfiles[$i])
				EndIf
			Next

			; Append missing file extensions
			; Добавление расширений к файлам
			If $appendext Then
				AppendExtensions($tempoutdir)
			EndIf

			; Move files to output directory and remove tempdir
			; Перемещение файлов в директорию назначения и удаление временной директории
			MoveFiles($tempoutdir, $outdir)
			_DirRemove($tempoutdir)

		Case "msu"
			_DirCreate($tempoutdir)
			LogRunWait($cmd & $7z & ' x -aos "' & $file & '"' & $output, $tempoutdir, $consolewin)

			; Regardless of method, extract files from extracted CABs
			; Извлечение из поддерживаемых извлечение независимо от метода CABs
			$cabfiles = FileSearch($tempoutdir)
			For $i = 1 To $cabfiles[0]
				filescan($cabfiles[$i], 0)
				If StringInStr($filetype, "Microsoft Cabinet Archive", 0) Then
					LogRunWait($cmd & $expand & ' -f:* "' & $cabfiles[$i] & '" "."' & $output, $outdir, $consolewin)
					$infile = FileOpen($debugfile, 0)
					$line = FileReadLine($infile)
					Do
						If StringInStr($line, 'Error Code') OR StringInStr($line, 'Код ошибки') Then terminate("failed", $file, $arcdisp)
						$line = FileReadLine($infile)
					Until @error
					FileClose($infile)
					_FileDelete($cabfiles[$i])
				EndIf
			Next

			; Append missing file extensions
			; Добавление расширений к файлам
			If $appendext Then
				AppendExtensions($tempoutdir)
			EndIf

			; Move files to output directory and remove tempdir
			; Перемещение файлов в директорию назначения и удаление временной директории
			MoveFiles($tempoutdir, $outdir)
			_DirRemove($tempoutdir)

		Case "ms_vcr"
			If Not RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727', 'Install') = 1 Then
				SplashOff()
				MsgBox(64, $title, t('DOTNET_FAILED', CreateArray("WixTools", "2.0")))
				Addlog(t('DOTNET_FAILED', CreateArray("WixTools", "2.0")))
				_DirRemove($tempoutdir, 1)
				If $createdir Then _DirRemove($outdir, 0)
				terminate("failed", $file, $arcdisp)
			EndIf
			LogRunWait($cmd & $ms_vcr & ' -x "' & $outdir & '" "' & $file & '"' & $output, $filedir, $consolewin)

		Case "nbh"
			LogRunWait($cmd & $nbh & ' "' & $file & '"' & $output, $outdir, $consolewin)

		Case "pea"
			Local $pid, $windows, $title, $status, $peatitle
			AddLog(t('EXECUTING') & ' ' & $pea & ' UNPEA "' & $file & '" "' & $tempoutdir & '" RESETDATE SETATTR EXTRACT2DIR INTERACTIVE')
			AddLog(t('RUN_OPTION', CreateArray($filedir, $consolewin)))
			$pid = Run($pea & ' UNPEA "' & $file & '" "' & $tempoutdir & '" RESETDATE SETATTR EXTRACT2DIR INTERACTIVE', $filedir, $consolewin)
			WinWait("PEA", "", 20)
			$windows = WinList("PEA")
			For $i = 0 To $windows[0][0]
				If WinGetProcess($windows[$i][0]) == $pid Then
					$peatitle = $windows[$i][0]
				EndIf
			Next
			While ProcessExists($pid)
				$status = ControlGetText($peatitle, '', 'Button1')
				If StringLeft($status, 4) = 'Done' Then ProcessClose($pid)
				Sleep(10)
			WEnd
			MoveFiles($tempoutdir, $outdir)
			_DirRemove($tempoutdir)
			AddLog(t('CANNOT_LOG', CreateArray($arcdisp)))

		Case "pdf"
			Local $sPassword = Password($cmd & $pdfdetach & ' -list "' & $file & '"', $cmd & $pdfdetach & ' -list -opw "%PASSWORD%" -upw "%PASSWORD%" "' & $file & '"', "Incorrect password", 0, "embedded files")
			If StringLeft(FetchStdout($cmd & $pdfdetach & ' -list ' & ($sPassword == ""? '"': '-opw "' & $sPassword & '" -upw "' & $sPassword & '" "') & $file & '"', $outdir, @SW_HIDE), 1) > 0 Then
				_DirCreate($outdir & '\embedded')
				LogRunWait($cmd & $pdfdetach & ' -saveall -o "' & $outdir & ($sPassword == ""? '\embedded" "': '\embedded" -opw "' & $sPassword & '" -upw "' & $sPassword & '" "') & $file & '"' & $output, $outdir, $consolewin)
			EndIf
			_DirCreate($outdir & '\images')
			LogRunWait($cmd & $pdfimages & ' -j ' & ($sPassword == ""? '"': ' -opw "' & $sPassword & '" -upw "' & $sPassword & '" "') & $file & '" "' & $outdir & '\images\img"' & $output, $outdir, $consolewin)
			LogRunWait($cmd & $pdftotext & ' -layout' & ($sPassword == ""? ' "': ' -opw "' & $sPassword & '" -upw "' & $sPassword & '" "') & $file & '" "' & $outdir & '\' & $filename & '.txt"' & $output, $outdir, $consolewin)

		Case "rar"
			Local $sPassword = Password($cmd & $7z & ' t -p "' & $file & '"', $cmd & $7z & ' t -p"%PASSWORD%" "' & $file & '"', "Encrypted = +", "Wrong password?", "Everything is Ok")
			LogRunWait($cmd & $7z & ' x ' & ($sPassword == ""? '"': '-p"' & $sPassword & '" "') & $file & '"' & $output, $outdir, $consolewin)

		Case "robo"
			If $warnexecute Then Warn_Execute($filename & '.exe /unpack="<outdir>"')
			LogRunWait($file & ' /unpack="' & $outdir & '"', $filedir & $output, $consolewin)

		Case "sf"
			$choice = MethodSelect($arctype, $arcdisp)
			If $choice == 'SF TC 1 (InstExpl.wcx)' Then
				LogRunWait($cmd & $ie & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			ElseIf $choice == 'SF TC 2 (TotalObserver.wcx)' Then 
				LogRunWait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			EndIf

		Case "sim"
			LogRunWait($cmd & $sim & ' "' & $file & '" "' & $outdir & '"' & $output, $outdir, $consolewin)

			; Extract cab files
			; Извлекаем из cab файлов
			$ret = $outdir & "\data.cab"
			LogRunWait($cmd & $7z & ' x "' & $ret & '"' & $output, $outdir, $consolewin)
			_FileDelete($ret)

			; Restore original file names and folder structure
			$handle = FileOpen($outdir & "\installer.config", 16)
			$ret = FileRead($handle)
			FileClose($handle)
			If @error Then
				terminate("failed", $file, $arcdisp)
			Else
				Local $j = 0, $aReturn = StringSplit($ret, "00402426253034", 1)
				For $i = 1 To $aReturn[0]
					If StringLeft($aReturn[$i], 2) <> "5C" Then ContinueLoop

					$ret = StringRight($aReturn[$i], 4)
					$bNext = $ret = "0031" Or $ret = "0032"
					If Not $bNext And $i <> $aReturn[0] Then ContinueLoop

					; Get file/directory name
					$ret = StringReplace(StringSplit($aReturn[$i], "0031", 1)[1], "0032", "")
					$ret = $outdir & BinaryToString("0x" & $ret)

					; Rename files/create sub directory
					$return = $outdir & "\" & $j
					If FileExists($return) Then
						_FileMove($return, $ret, 9)
					Else
						_DirCreate($ret)
					EndIf

					; Update next file name variable
					If $bNext Then $j += 1
				Next
			EndIf

			_FileDelete($outdir & "\runtime.cab")
			_FileDelete($outdir & "\installer.config")

		Case "sis"
			LogRunWait($cmd & $sis & ' x "' & $file & '" "' & $outdir & '\"' & $output, $filedir, $consolewin)

		Case "sit"
			_DirCreate($tempoutdir)
			_FileMove($file, $tempoutdir)
			LogRunWait($sit & ' "' & $tempoutdir & '\' & $filename & '.' & $fileext & '"' & $output, $tempoutdir, $consolewin)
			_FileMove($tempoutdir & '\' & $filename & '.' & $fileext, $file)
			MoveFiles($tempoutdir & '\' & $filename, $outdir)
			_DirRemove($tempoutdir, 1)

		Case "sqx"
			LogRunWait($cmd & $sqx & ' x "' & $file & '" "' & $outdir & '\"' & $output, $filedir, $consolewin)

		Case "superdat"
			If $warnexecute Then Warn_Execute($filename & '.exe /e "<outdir>"')
			LogRunWait($file & ' /e "' & $outdir & '"', $outdir & $output, $consolewin)
			_FileMove($filedir & '\SuperDAT.log', $debugfile, 1)

		; Bioruebe https://github.com/Bioruebe/UniExtract2
		Case "swf"
			; Run swfextract to get list of contents
			; Запуск swfextract для получения списка составляющих
			Local $return = StringSplit(FetchStdout($cmd & $swf & ' "' & $file & '"', $filedir, @SW_HIDE), @CRLF)
			For $i = 2 To $return[0]
				$line = $return[$i]
				; Extract files
				; Извлечение файлов
				If StringInStr($line, "MP3 Soundstream") Then
					LogRunWait($cmd & $swf & ' -m "' & $file & '"' & $output, $outdir, $consolewin)
					If FileExists($outdir & "\output.mp3") Then _FileMove($outdir & "\output.mp3", $outdir & "\MP3 Soundstream\soundstream.mp3", 8 + 1)
				ElseIf $line <> "" Then
					$swf_arr = StringSplit(StringRegExpReplace(StringStripWS($line, 8), '(?i)\[(-\w)\]\d+(.+):(.*?)\)', "$1,$2,"), ",")
					$j = 3
					Do
						$swf_obj = StringInStr($swf_arr[$j], "-")
						If $swf_obj Then
							For $k = StringMid($swf_arr[$j], 1, $swf_obj - 1) To StringMid($swf_arr[$j], $swf_obj + 1)
								_ArrayAdd($swf_arr, $k)
							Next
							$swf_arr[0] = UBound($swf_arr) - 1
						Else
							; Set output file name
							; Задание имени выходного файла
							$swf_arr[$j] = StringStripWS($swf_arr[$j], 1) 
							$fname = $swf_arr[$j] 
							If $swf_arr[2] = "Sound"  Or $swf_arr[2] = "Embedded MP3s" Then
								$fname &= ".mp3"
							ElseIf $swf_arr[2] = "PNGs" Then
								$fname &= ".png"
							ElseIf $swf_arr[2] = "JPEGs" Then
								$fname &= ".jpg"
							Else
								$fname &= ".swf"
							EndIf
							LogRunWait($cmd & $swf & " " & $swf_arr[1] & " " & $swf_arr[$j] & ' -o ' & $fname & ' "' & $file & '"', $outdir, $consolewin) 
							_FileMove($outdir & "\" & $fname, $outdir & "\" & $swf_arr[2] & "\", 8 + 1)
						EndIf
						$j += 1
					Until $j = $swf_arr[0] + 1
				EndIf
			Next

		Case "tar"
			If $fileext = "tar" Then
				LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			Else
				LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
				LogRunWait($cmd & $7z & ' x "' & $outdir & '\' & $filename & '.tar"' & $output, $outdir, $consolewin)
				_FileDelete($outdir & '\' & $filename & '.tar')
			EndIf

		; Bioruebe https://github.com/Bioruebe/UniExtract2
		Case "thinstall"
			If $warnexecute Then Warn_Execute($file)
			AddLog(t('EXECUTING') & ' ' & $file)
			AddLog(t('RUN_OPTION', CreateArray($filedir, '1')))
			$pid = Run($file, $filedir)
			Do
				Sleep(100)
			Until ProcessExists($pid)
			Sleep(1000)
			$aProcessList = ProcessList($filename & '.exe')
			$pid = $aProcessList[1][1]
			AddLog(t('EXECUTING') & ' ' & $thinstall)
			Run($thinstall)
			WinWait("h4sh3m Virtual Apps Dependency Extractor")
			WinActivate("h4sh3m Virtual Apps Dependency Extractor")
			ControlSetText("h4sh3m Virtual Apps Dependency Extractor", "", "TEdit1", $pid)
			ControlClick("h4sh3m Virtual Apps Dependency Extractor", "", "TBitBtn3")
			WinWait("h4sh3m Virtual App's Extractor", "", 60)
			WinActivate("h4sh3m Virtual App's Extractor")
			ControlSetText("h4sh3m Virtual App's Extractor", "", "TEdit1", $outdir)
			ControlClick("h4sh3m Virtual App's Extractor", "", "TBitBtn1")
			WinWait("Done")
			ControlClick("Done", "", "Button1")
			WinClose("h4sh3m Virtual Apps Dependency Extractor")
			Sleep(1000)
			ProcessClose($pid)
			AddLog(t('CANNOT_LOG', CreateArray($arcdisp)))

		Case "to"
			LogRunWait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)

		Case "uha"
			LogRunWait($cmd & $uharc & ' x -t"' & $outdir & '" "' & $file & '"' & $output, $outdir, $consolewin)
			If DirGetSize($outdir) <= $initdirsize Then
				$error = FileReadLine($debugfile, 6)
				If StringInStr($error, "use UHARC version", 0) Then
					$version = StringTrimLeft($error, StringInStr($error, ' ', 0, -1))
					If $version == '0.4' Then
						LogRunWait($cmd & $uharc04 & ' x -t"' & $outdir & '" "' & $file & '"' & $output, $outdir, $consolewin)
					ElseIf $version == '0.2' Then
 						If FileExists(@scriptdir & "\bin\" & $uharc02) Then LogRunWait($cmd & $uharc02 & ' x -t' & FileGetShortName($outdir) & ' ' & FileGetShortName($file) & $output, $outdir, $consolewin)
					EndIf
				EndIf
			EndIf

		Case "uif"
			; Prompt user to continue
			; Запрос пользователя о продолжении
			SplashOff()
			$convert = MsgBox(65, $title, t('CONVERT_CDROM', CreateArray('CDI')))
			If $convert <> 1 Then
				If $createdir Then _DirRemove($outdir, 0)
				terminate("silent")
			EndIf
			SplashTextOn($title, t('EXTRACTING') & @CRLF & $arcdisp, 330, 70, -1, $height, 16)

			; Begin conversion to .iso format
			; Начало конвертации в формат .iso
			_DirCreate($tempoutdir)
			ControlSetText($title, '', 'Static1', t('EXTRACTING') & @CRLF & 'CDI CD-ROM ' & t('TERM_IMAGE') & ' (' & t('TERM_STAGE') & ' 1)')
			AddLog(t('EXTRACTING') & 'CDI CD-ROM ' & t('TERM_IMAGE') & ' (' & t('TERM_STAGE') & ' 1)')
			$isofile = $tempoutdir & '\' & $filename & '.iso'
			LogRunWait($cmd & $uif & ' "' & $file & '" "' & $isofile & '"' & $output, $tempoutdir, $consolewin)

		Case "uu"
			LogRunWait($cmd & $uu & ' -p "' & $outdir & '" -i "' & $file & '"' & $output, $filedir, $consolewin)

		Case "vssfx"
			If $warnexecute Then Warn_Execute($filename & '.exe /extract')
			_FileMove($file, $outdir)
			LogRunWait($outdir & '\' & $filename & '.' & $fileext & ' /extract', $outdir, $consolewin)
			_FileMove($outdir & '\' & $filename & '.' & $fileext, $filedir)

		Case "vssfxpath"
			If $warnexecute Then Warn_Execute($filename & '.exe /extract:"<outdir>" /quiet')
			LogRunWait($file & ' /extract:"' & $outdir & '" /quiet', $outdir, $consolewin)

		Case "wise"
			$choice = MethodSelect($arctype, $arcdisp)

			; Extract with E_WISE
			; Извлечение с помощью E_WISE
			Switch $choice
				Case 'E_Wise'
					LogRunWait($cmd & $wise_ewise & ' "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
					If DirGetSize($outdir) > $initdirsize Then
						LogRunWait($cmd & '00000000.BAT' & $output, $outdir, $consolewin)
						_FileDelete($outdir & '\00000000.BAT')
					EndIf
                        	
				; Extract with WUN
				; Извлечение с помощью WUN
				Case 'WUN'
					LogRunWait($cmd & $wise_wun & ' "' & $filename & '" "' & $tempoutdir & '"', $filedir, $consolewin)
					If $removetemp Then
						_FileDelete($tempoutdir & "\INST0*")
						_FileDelete($tempoutdir & "\WISE0*")
					Else
						_FileMove($tempoutdir & "\INST0*", $outdir)
						_FileMove($tempoutdir & "\WISE0*", $outdir)
					EndIf
					MoveFiles($tempoutdir, $outdir)
					_DirRemove($tempoutdir)
                        	
				; Extract with TotalObserver.wcx
				; Извлечение с помощью TotalObserver.wcx
				Case 'Wise TC (TotalObserver.wcx)' 
					LogRunWait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
                        	
				; Extract using the /x switch
				; Извлечение с исполькованием ключа /x
				Case 'Wise Installer /x'
					If $warnexecute Then Warn_Execute($filename & '.exe /x <outdir>')
					LogRunWait($file & ' /x ' & $outdir, $filedir, $consolewin)
                        	
				; Attempt to extract MSI
				; Попытка извлечьt MSI
				Case 'Wise MSI' 
                        	
					; Prompt to continue
					; Запрос о продолжении
					SplashOff()
					$continue = MsgBox(65, $title, t('WISE_MSI_PROMPT', CreateArray($name)))
					If $continue <> 1 Then
						If $createdir Then _DirRemove($outdir, 0)
						terminate("silent")
					EndIf
                        	
					; First, check for any files that are already in extraction dir
					; Проверка в начале нет ли каких=нибудь файлов в директории извлечения
					If $warnexecute Then Warn_Execute($filename & '.exe /?')
					SplashTextOn($title, t('EXTRACTING') & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
					$oldfiles = ReturnFiles(@commonfilesdir & "\Wise Installation Wizard")
                        
					; Run installer
					; Запуск инсталлятора
					Opt("WinTitleMatchMode", 3)
					AddLog(t('EXECUTING') & ' ' & $file & ' /?')
					AddLog(t('RUN_OPTION', CreateArray($filedir, '1')))
					$pid = Run($file & ' /?', $filedir)
					While 1
						Sleep(10)
						If WinExists("Windows Installer") Then
							WinSetState("Windows Installer", '', @SW_HIDE)
							ExitLoop
						Else
							If NOT ProcessExists($pid) Then ExitLoop
						EndIf
					WEnd
                        	
					; Move new files
					; Перемещение новых файлов
					MoveFiles(@commonfilesdir & "\Wise Installation Wizard", $outdir, 0, $oldfiles)
					_DirRemove(@commonfilesdir & "\Wise Installation Wizard", 0)
					WinClose("Windows Installer")
					AddLog(t('CANNOT_LOG', CreateArray($arcdisp)))
                        	
				; Extract using unzip, falling back to 7-Zip
				; Извлечение при помощи unzip, при ошибке - возврат к 7-Zip
				Case 'Unzip'
					$return = LogRunWait($cmd & $zip & ' -x "' & $file & '"' & $output, $outdir, $consolewin)
					If $return <> 0 Then
						LogRunWait($cmd & $7z & ' x "' & $file & '"', $outdir & $output, $consolewin)
					EndIf
			EndSwitch

			; Append missing file extensions
			; Добавление расширений к файлам
			If $appendext Then
				AppendExtensions($outdir)
			EndIf

		Case "xz"
			LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			If FileExists($outdir & '\' & $filename) AND StringTrimLeft($filename, StringInStr($filename, '.', 0, -1)) = "tar" Then
				LogRunWait($cmd & $7z & ' x "' & $outdir & '\' & $filename & '"' & $output, $outdir, $consolewin)
				_FileDelete($outdir & '\' & $filename)
			EndIf

		Case "Z"
			LogRunWait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			If FileExists($outdir & '\' & $filename) AND StringTrimLeft($filename, StringInStr($filename, '.', 0, -1)) = "tar" Then
				LogRunWait($cmd & $7z & ' x "' & $outdir & '\' & $filename & '"' & $output, $outdir, $consolewin)
				_FileDelete($outdir & '\' & $filename)
			EndIf

		Case "zip"
			Local $sPassword = Password($cmd & $zip & ' -t -P "" "' & $file & '"', $cmd & $zip & ' -t -P "%PASSWORD%" "' & $file & '"', "because of incorrect password", 0, "No errors")
			$return = LogRunWait($cmd & $zip & ' -x ' & ($sPassword == ""? '"': '-P "' & $sPassword & '" "') & $file & '"' & $output, $outdir, $consolewin)

			If $return > 1 Then
				LogRunWait($cmd & $7z & ' x ' & ($sPassword == ""? '"': '-p"' & $sPassword & '" "') & $file & '"' & $output, $outdir, $consolewin)
			EndIf

		Case "zoo"
			_DirCreate($tempoutdir)
			_FileMove($file, $tempoutdir)
			LogRunWait($cmd & $zoo & ' -x -o ' & FileGetShortName($filename & '.' & $fileext) & $output, $tempoutdir, $consolewin)
			_FileMove($tempoutdir & '\' & $filename & '.' & $fileext, $file)
			MoveFiles($tempoutdir, $outdir)
			_DirRemove($tempoutdir)

		Case "zpaq"
			Local $sPassword = Password($cmd & $zpaq & ' l "' & $file & '"', $cmd & $zpaq & ' l "' & $file & '" -key "%PASSWORD%"', "password incorrect", 0, "all OK")
			LogRunWait($cmd & $zpaq & ' x "' & $file & '" -to "' & $outdir & ($sPassword == ""? '"': '" -key "' & $sPassword & '"') & $output, $outdir, $consolewin)
	EndSwitch

	; Exit if conversion to .iso failed
	; Выход, если конвертация в .iso не удалась
	If $isofile AND NOT FileExists($isofile) Then
		SplashOff()
		MsgBox(64, $title, t('CONVERT_CDROM_STAGE1_FAILED'))
		AddLog(t('CONVERT_CDROM_STAGE1_FAILED'))
		_DirRemove($tempoutdir, 1)
		If $createdir Then _DirRemove($outdir, 0)
		terminate("failed", $file, $arcdisp)

	; Otherwise, begin extraction from .iso
	; Иначе - извлечение из .iso
	ElseIf FileExists($isofile) Then
		ControlSetText($title, '', 'Static1', t('EXTRACTING') & 'CDI CD-ROM ' & t('TERM_IMAGE') & ' (' & t('TERM_STAGE') & ' 2)')
		AddLog(t('EXTRACTING') & @CRLF & 'CDI CD-ROM ' & t('TERM_IMAGE') & ' (' & t('TERM_STAGE') & ' 2)')
		LogRunWait($cmd & $7z & ' x "' & $isofile & '"' & $output, $outdir, $consolewin)

		; Prompt to keep .iso if extraction failed
		; Запрос на сохранение .iso, если извлечение не удалось
		If DirGetSize($outdir) <= $initdirsize Then
			$image = MsgBox(52, $title, t('CONVERT_CDROM_STAGE2_FAILED', CreateArray('CDI')))
			If $image == 7 Then _DirRemove($tempoutdir, 1)
			If $createdir Then _DirRemove($outdir, 0)
			terminate("silent")

		; Otherwise, delete .iso
		; Иначе удаление .iso
		Else
			_DirRemove($tempoutdir, 1)
			If $createdir Then _DirRemove($outdir, 0)
		EndIf
	EndIf

	; If SFX-archive then extract config file and sfx-module
	; Если SFX-архив, то извлечь файл конфигурации и sfx-модуль
	AddLog(t('EXTRACTING_7ZIP'))
	AddLog(t('EXECUTING') & ' ' & $cmd & $SfxSplit & ' "' & $file & '" -b -c "' & $outdir & '\!!!_' & $filename & '_config.txt"' & ' -m "' & $outdir & '\!!!_' & $filename & '.sfx"')
	AddLog(t('RUN_OPTION', CreateArray($filedir, '0')))
	RunWait($cmd & $SfxSplit & ' "' & $file & '" -b -c "' & $outdir & '\!!!_' & $filename & '_config.txt"' & ' -m "' & $outdir & '\!!!_' & $filename & '.sfx"', "", @SW_HIDE)

	; Check for successful output
	; Проверка правильности вывода
	SplashOff()
	If $createdir Then
		If DirGetSize($outdir) <= $initdirsize Then
			If $createdir Then _DirRemove($outdir, 0)
			If $arctype == "ace" AND $fileext = "exe" Then Return False
			terminate("failed", $file, $arcdisp)
		EndIf
	Else
		;MsgBox(0, 'Test', "new = " & FileGetTime($outdir, 0, 1) & @CRLF & "old   = " & $dirmtime)
		If FileGetTime($outdir, 0, 1) == $dirmtime Then
			terminate("failed", $file, $arcdisp)
		EndIf
	EndIf
	terminate("success", "", $arctype)
EndFunc

; Unpack packed executable
; Распаковка упакованных исполняемых файлов
Func unpack()
	$packed = 0
	Local $packer
	If StringInStr($filetype, "UPX", 0) OR $fileext = "dll" Then
		$packer = "UPX"
	ElseIf StringInStr($filetype, "ASPack", 0) Then
		$packer = "ASPack"
	EndIf
	Addlog(t('UNPACK', CreateArray($packer)))
	; unpack file
	; распаковка файлов
	If $packer == "UPX" Then
		LogRunWait($cmd & $upx & ' -d -k "' & $file & '"' & $output, $filedir, $consolewin)
		$tempext = StringTrimRight($fileext, 1) & '~'
		If FileExists($filedir & "\" & $filename & "." & $tempext) Then
			_FileMove($filedir & "\" & $filename & "." & $tempext, $filedir & "\" & $filename & "_orig" & "." & $fileext)
			Return 1
		Else
			If StringInStr(FileReadLine($debugfile, 7) , "CantUnpackException", 0) Then
				$packfailed = True
				Return 1
			EndIf
			terminate("unpackfailed")
		EndIf
	ElseIf $packer == "ASPack" Then
		$choice = MethodSelect("ASPack", "ASPack " & t('TERM_PackAGE'))
		If $choice == "AspackDie 2.2" Then $aspack = $aspack22
		_FileMove($file, $filedir & "\" & $filename & "_orig" & "." & $fileext)
		LogRunWait($cmd & $aspack & ' "' & $filedir & "\" & $filename & "_orig" & "." & $fileext & '" "' & $file & '" /NO_PROMPT' & $output, $filedir, $consolewin)
		If FileExists($file) Then
			Return 1
		Else
			_FileMove($filedir & "\" & $filename & "_orig" & "." & $fileext, $file)
			terminate("unpackfailed")
		EndIf
	EndIf
	Return
EndFunc

; Return list of files and directories in directory as a pipe-delimited string
; Возвращает список файлов и поддиректорий в директории, разделённых |
Func ReturnFiles($dir)
	Local $handle, $files, $fname
	$handle = FileFindFirstFile($dir & "\*")
	If NOT @error Then
		While 1
			$fname = FileFindNextFile($handle)
			If @error Then ExitLoop
			$files &= $fname & '|'
		WEnd
		StringTrimRight($files, 1)
		FileClose($handle)
	Else
		SetError(1)
		Return
	EndIf
	Return $files
EndFunc

; Copy files with logging
; Копирование файлов с логгированием
Func _FileCopy($source, $dest, $flag = 0)
	If FileCopy($source, $dest, $flag) Then
		AddLog(t('COPY_FILES', CreateArray($source, $dest)))
		Return 1
	Else
		AddLog(t('FAILED_COPY',  CreateArray($source, $dest)))
		Return 0
	EndIf
EndFunc

; Move files with logging
; Перемещение файлов с логгированием
Func _FileMove($source, $dest, $flag = 0)
	If FileMove($source, $dest, $flag) Then
		AddLog(t('MOVE_FILES', CreateArray($source, $dest)))
		Return 1
	Else
		AddLog(t('FAILED_MOVE',  CreateArray($source, $dest)))
		Return 0
	EndIf
EndFunc

; Move directories with logging
; Перемещение папок с логгированием
Func _DirMove($source, $dest, $flag = 0)
	If DirMove ($source, $dest, $flag) Then
		AddLog(t('MOVE_FILES', CreateArray($source, $dest)))
		Return 1
	Else
		AddLog(t('FAILED_MOVE',  CreateArray($source, $dest)))
		Return 0
	EndIf
EndFunc

; Remove directories with logging
; Удаление папок с логгированием
Func _DirRemove($source, $flag = 0)
	If FileExists($source) Then
		If DirRemove ($source, $flag) Then
			AddLog(t('DEL_FILES', CreateArray($source)))
			Return 1
		Else
			AddLog(t('FAILED_DEL',  CreateArray($source)))
			Return 0
		EndIf
	EndIf
EndFunc

; Create directories with logging
; Создание папок с логгированием
Func _DirCreate($source)
	If DirCreate ($source) Then
		AddLog(t('DIR_CREATE', CreateArray($source)))
		Return 1
	Else
		AddLog(t('FAILED_CREATE',  CreateArray($source)))
		Return 0
	EndIf
EndFunc

; Delete files with logging
; Удаление файлов с логгированием
Func _FileDelete($source)
	If FileExists($source) Then
		If FileDelete($source) Then
			AddLog(t('DEL_FILES', CreateArray($source)))
			Return 1
		Else
			AddLog(t('FAILED_DEL',  CreateArray($source)))
			Return 0
		EndIf
	EndIf
EndFunc

; Move all files and subdirectories from one directory to another
; $force is an integer that specifies whether or not to replace existing files
; $omit is a string that includes files to be excluded from move
; Перемещение всех файлов и директорий из одной директории в другую
; $force - число, которое определяет заменять или нет существующие файлы
; $omit - с строка со списком файлов, которые не надо перемещать
Func MoveFiles($source, $dest, $force = 0, $omit = '')
	Local $handle, $fname
	DirCreate($dest)
	$handle = FileFindFirstFile($source & "\*")
	If NOT @error Then
		While 1
			$fname = FileFindNextFile($handle)
			If @error Then
				ExitLoop
			ElseIf StringInStr($omit, $fname) Then
				ContinueLoop
			Else
				If StringInStr(FileGetAttrib($source & '\' & $fname), 'D') Then
					If Not _DirMove($source & '\' & $fname, $dest, 1) Then AddLog(t('FAILED_MOVE',  CreateArray($source & '\' & $fname, $dest))
				Else
					If Not _FileMove($source & '\' & $fname, $dest, $force) Then AddLog(t('FAILED_MOVE',  CreateArray($source & '\' & $fname, $dest))
				EndIf
			EndIf
		WEnd
		FileClose($handle)
		AddLog(t('MOVE_FILES', CreateArray($source, $dest)))
	Else
		SetError(1)
		Return
	EndIf
EndFunc

; Extract contents of InstallShield cabs file-by-file
; Извлечение из InstallShield cabs пофайлово
Func ISCabExtract($iscab, $files, $subtitle)
	ProgressOn($title, $subtitle, '', -1, $height, 16)
	For $i = 1 To UBound($files)-1
		ProgressSet(Round($i/(UBound($files)-1), 2)*100, 'Extracting: ' & $files[$i])
		LogRunWait($cmd & $iscab & ' x -r -d -f "' & $file & '" "' & $files[$i] & '"' & $output, $outdir, $consolewin)
	Next
	ProgressOff()
EndFunc

; Append missing file extensions using TrID
; Добавление расширений к файлам при помощи TrID
Func AppendExtensions($dir)
	AddLog(t('APPEND_EXTENSIONS', CreateArray($dir)))
	Local $files
	$files = FileSearch($dir)
	If $files[1] <> '' Then
		For $i = 1 To $files[0]
			If NOT StringInStr(FileGetAttrib($files[$i]), 'D') Then
				$filename = StringTrimLeft($files[$i], StringInStr($files[$i], '\', 0, -1))
				If NOT StringInStr($filename, '.') _
					OR StringLeft($filename, 7) = 'Binary.' _
					OR StringRight($filename, 4) = '.bin' Then
					LogRunWait($cmd & $trid & ' "' & $files[$i] & '" -ae' & $output, $dir, $consolewin)
				EndIf
			EndIf
		Next
	EndIf
EndFunc

; Recursively search for given pattern
; code by w0uter (http://www.autoitscript.com/forum/index.php?showtopic=16421)
; Рекурсивный поиск
Func FileSearch($s_Mask = '', $i_Recurse = 1)
	Local $s_Buf = ''
	If $i_Recurse Then
		Local $s_Command = ' /c dir /B /S "'
	Else
		Local $s_Command = ' /c dir /B "'
	EndIf
	$i_Pid = Run(@ComSpec & $s_Command & $s_Mask & '"', @WorkingDir, @SW_HIDE, 2+4)
	While NOT @error
		$s_Buf &= StdoutRead($i_Pid)
	WEnd
	$s_Buf = StringSplit(StringTrimRight(StringOEM2ANSI($s_Buf), 2), @CRLF, 1)
	ProcessClose($i_Pid)
	If UBound($s_Buf) = 2 AND $s_Buf[1] = '' Then SetError(1)
	Return $s_Buf
EndFunc

; http://forum.oszone.net/post-797573-500.html
Func StringOEM2ANSI($strText)
    Local $buf = DllStructCreate("char["& StringLen($strText)+1 &"]")
    Local $ret = DllCall("User32.dll", "int", "OemToChar", "str", $strText, "ptr", DllStructGetPtr($buf))
    If Not(IsArray($ret)) Then Return SetError(1, 0, '') ; ошибка DLL
    If $ret[0]=0 Then Return SetError(2, $ret[0], '') ; ошибка функции
    Return DllStructGetData($buf, 1)
EndFunc  ;==> _StringOEM2ANSI

; Search %path% for passed executable
; Определение переменной %path% передаче исполняемому файлу
Func PathSearch($file)
	; Search DOS path directories
	; Определение DOS директорий
	$dir = StringSplit(EnvGet("path"), ';')
	ReDim $dir[$dir[0]+1]
	$dir[$dir[0]] = @scriptdir
	For $i = 1 To $dir[0]
		$exefiles = FileFindFirstFile($dir[$i] & "\*.exe")
		If $exefiles == -1 Then ContinueLoop
		$exename = FileFindNextFile($exefiles)
		Do
			If $exename = $file Then
				FileClose($exefiles)
				Return _PathFull($dir[$i] & '\' & $exename)
			EndIf
			$exename = FileFindNextFile($exefiles)
		Until @error
		FileClose($exefiles)
	Next

	Return False
EndFunc

; Handle program termination with appropriate error message
; Прерывание работы программы в ручную с выводом соответствующего сообщения об ошибке
Func terminate($status, $fname = '', $id = '')
	Local $addname = $status
	; Display error message if file could not be extracted
	; Вывод сообщения об ошибке, если файл не может быть распакован

	If FileExists($filedir & "\" & $filename & "_orig" & "." & $fileext) Then
		FileMove($file, $outdir & "\" & $filename & "_" & t('TERM_UNPackED') & "." & $fileext, 8)
		FileMove($filedir & "\" & $filename & "_orig" & "." & $fileext, $file, 1)
	EndIf

	; Rename unicode file
	If $UnicodeMode Then
		AddLog(t('UNICODE_BACK'))
		SplashTextOn($title, t('MOVE_COPY_FILES') & @CRLF & t('TO', CreateArray($file, $oldpath)), (StringLen($file)+StringLen($oldpath)+4)*6, 80, -1, $height, 16)
		If $UnicodeMode = "Move" Then
			_FileMove($file, $oldpath, 1)
		Else
			_FileDelete($file)
		EndIf
		SplashTextOn($title, t('MOVE_COPY_FILES') & @CRLF & t('TO', CreateArray($outdir, $oldoutdir)), (StringLen($outdir)+StringLen($oldoutdir)+4)*6, 80, -1, $height, 16)
		MoveFiles($outdir, $oldoutdir)
		If Not @error Then _DirRemove($outdir)
		SplashOff()

		$outdir = $oldoutdir
		$file = $oldpath
		$fileunicode = StringSplit(ReturnFiles($outdir),'|')
		For $i = 1 To $fileunicode[0]
			If StringInStr($fileunicode[$i], $filename) Then _Filemove($outdir & '\' & $fileunicode[$i], StringReplace($outdir & '\' & $fileunicode[$i], $filename, $oldName))
		Next
	EndIf
	If $file Then FilenameParse($file)

	Switch $status
		; Display usage information and exit
		; Вывод справки и выход
		Case "syntax"
			$syntax = t('HELP_SUMMARY')
			$syntax &= t('HELP_SYNTAX', CreateArray(@scriptname))
			$syntax &= t('HELP_ARGUMENTS')
			$syntax &= t('HELP_HELP')
			$syntax &= t('HELP_PREFS')
			$syntax &= t('HELP_LANG')
			$syntax &= t('HELP_FILENAME')
			$syntax &= t('HELP_DESTINATION')
			$syntax &= t('HELP_SUB', CreateArray($name))
			$syntax &= t('HELP_EXAMPLE1')
			$syntax &= t('HELP_EXAMPLE2', CreateArray(@scriptname))
			$syntax &= t('HELP_NOARGS', CreateArray($name))
			MsgBox(48, $title, $syntax)
			If Not $savelogalways Then $Log = ''
			$exitcode = 0

		; Debug file is not writable
		; Невозможно записать файл отладки
		Case "debug"
			MsgBox(48, $title, t('CANNOT_DEBUG', CreateArray($fname, $name)))
			AddLog(t('CANNOT_DEBUG', CreateArray($fname, $name)))
			If Not $savelogalways Then $Log = ''	
			$exitcode = 2

		; Display error information and exit
		; Отображение информации об ошибке и выход
		Case "unknownexe"
			$prompt = MsgBox(305, $title, t('CANNOT_EXTRACT', CreateArray($file, $id)))
			AddLog(t('CANNOT_EXTRACT', CreateArray($file, $id)))
			If $prompt == 1 Then
				Run($peid & ' "' & $file & '"', $filedir)
				WinWait($peidtitle)
				WinActivate($peidtitle)
			EndIf
			$exitcode = 3
		Case "unknownext"
			MsgBox(48, $title, t('UNKNOWN_EXT', CreateArray($file)))
			AddLog(t('UNKNOWN_EXT', CreateArray($file)))
			$exitcode = 4
		Case "invaliddir"
			MsgBox(48, $title, t('INVALID_DIR', CreateArray($fname)))
			AddLog(t('INVALID_DIR', CreateArray($fname)))
			$exitcode = 5
		Case "invalidpas"
			MsgBox(48, $title, t('INVALID_PASSWORD', CreateArray($file)))
			AddLog(t('INVALID_PASSWORD', CreateArray($file)))
			$exitcode = 6
		Case "invalidlangfile"
			MsgBox(48, $title, t('INVALID_LANGFILE', CreateArray($fname)))
			AddLog(t('INVALID_LANGFILE', CreateArray($fname)))
			If Not $savelogalways Then $Log = ''
			$exitcode = 7
		; Display failed attempt information and exit
		; Отображение информации о неудачной распаковке и выход
		Case "unpackfailed"
			Addlog(t('UNPACK_FAILE', CreateArray($file)))
			$prompt = MsgBox(305, $title, t('UNPACK_FAILED', CreateArray($file, FileGetLongName($debugfile))))
			If $prompt == 1 Then
				If $savelog Then 
					ShellExecute(CreateLog($status))
	
				Else
					ShellExecute(CreateLog('', $debugfile))
				EndIf
				$Log = ''
			EndIf
			$exitcode = 1
		; Display failed attempt information and exit
		; Отображение информации о неудачной распаковке и выход
		Case "failed"
			AddLog(t('EXTRACT_FAILE', CreateArray($file, $id)))
			$prompt = MsgBox(305, $title, t('EXTRACT_FAILED', CreateArray($file, $id, FileGetLongName($debugfile))))
			If $prompt == 1 Then
				If $savelog Then 
					ShellExecute(CreateLog($status))
	
				Else
					ShellExecute(CreateLog('', $debugfile))
				EndIf
				$Log = ''
			EndIf
			$exitcode = 1

		; Exit successfully
		; Выход с случае удачной распаковки
		Case "success"
			_FileDelete($debugfile)
			AddLog(t('EXTRACT_SUCCESS'))
			$status = $id
			$exitcode = 0
		; Exit silently
		; Выход без сообщений
		Case "silent"
			If Not $savelogalways Then $Log = ''
			$exitcode = 0
	EndSwitch

	If $Log AND $savelog Then CreateLog($status)
	Exit $exitcode
EndFunc

; Function to prompt user for choice of extraction method
; Вывод пользователю окна с возможностью выбора из нескольких методов
Func MethodSelect($format, $splashdisp)
	SplashOff()
	$base_height = 130
	$base_radio = 100
	$url = 'dummy'
	Switch $format
	Case 'wise'
		$select_type = 'Wise Installer'
		Dim $method[6][2], $select[6]
		$method[0][0] = 'E_Wise'
		$method[0][1] = 'METHOD_UNPackER_RADIO'
		$method[1][0] = 'WUN'
		$method[1][1] = 'METHOD_UNPackER_RADIO'
		$method[2][0] = 'Wise TC (TotalObserver.wcx)'
		$method[2][1] = 'METHOD_EXTRACTION_RADIO'
		$method[3][0] = 'Wise Installer /x'
		$method[3][1] = 'METHOD_SWITCH_RADIO'
		$method[4][0] = 'Wise MSI'
		$method[4][1] = 'METHOD_EXTRACTION_RADIO'
		$method[5][0] = 'Unzip'
		$method[5][1] = 'METHOD_EXTRACTION_RADIO'
	Case 'msi'
		$select_type = 'MSI Installer'
		Dim $method[7][2], $select[7]
		$method[0][0] = 'MSI'
		$method[0][1] = 'METHOD_ADMIN_RADIO'
		$method[1][0] = 'MsiX'
		$method[1][1] = 'METHOD_EXTRACTION_RADIO'
		$method[2][0] = 'MSI TC 1 (msi.wcx)'
		$method[2][1] = 'METHOD_EXTRACTION_RADIO'
		$method[3][0] = 'MSI TC 2 (InstExpl.wcx)'
		$method[3][1] = 'METHOD_EXTRACTION_RADIO'
		$method[4][0] = 'MSI TC 3 (TotalObserver.wcx)'
		$method[4][1] = 'METHOD_EXTRACTION_RADIO'
		$method[5][0] = 'JSWare Unpacker'
		$method[5][1] = 'METHOD_EXTRACTION_RADIO'
		$method[6][0] = 'Less MSIerables (lessmsi)'
		$method[6][1] = 'METHOD_EXTRACTION_RADIO'
	Case 'msp'
		$select_type = 'MSP Package'
		Dim $method[3][2], $select[3]
		$method[0][0] = 'MSI TC Packer'
		$method[0][1] = 'METHOD_EXTRACTION_RADIO'
		$method[1][0] = 'MsiX'
		$method[1][1] = 'METHOD_EXTRACTION_RADIO'
		$method[2][0] = '7-Zip'
		$method[2][1] = 'METHOD_EXTRACTION_RADIO'
	Case 'mht'
		$select_type = 'MHTML Archive'
		Dim $method[3][2], $select[3]
		$method[0][0] = 'ExtractMHT'
		$method[0][1] = 'METHOD_EXTRACTION_RADIO'
		$method[1][0] = 'MHT TC 1 (MHTUnp.wcx)'
		$method[1][1] = 'METHOD_EXTRACTION_RADIO'
		$method[2][0] = 'MHT TC 2 (TotalObserver.wcx)'
		$method[2][1] = 'METHOD_EXTRACTION_RADIO'
	Case 'is3arc'
		$select_type = 'InstallShield 3.x Archive'
		Dim $method[2][2], $select[2]
		$method[0][0] = 'i3comp'
		$method[0][1] = 'METHOD_EXTRACTION_RADIO'
		$method[1][0] = 'STIX'
		$method[1][1] = 'METHOD_EXTRACTION_RADIO'
	Case 'isexe'
		$select_type = 'InstallShield Installer'
		Dim $method[6][2], $select[6]
		$method[0][0] = 'isxunpack'
		$method[0][1] = 'METHOD_EXTRACTION_RADIO'
		$method[1][0] = 'IShield TC (TotalObserver.wcx)'
		$method[1][1] = 'METHOD_EXTRACTION_RADIO'
		$method[2][0] = 'InstallShield /b'
		$method[2][1] = 'METHOD_SWITCH_RADIO'
		$method[3][0] = 'InstallScript /s /extract_all:'
		$method[3][1] = 'METHOD_SWITCH_RADIO'
		$method[4][0] = 'MSI /a /s /v"/qn TARGETDIR=.."'
		$method[4][1] = 'METHOD_SWITCH_RADIO'
		$method[5][0] = 'not InstallShield'
		$method[5][1] = 'METHOD_NOTIS_RADIO'
	Case 'ASPack'
		$select_type = 'ASPack Packer'
		Dim $method[2][2], $select[2]
		$method[0][0] = 'AspackDie 2.12'
		$method[0][1] = 'METHOD_UNPackER_RADIO'
		$method[1][0] = 'AspackDie 2.2'
		$method[1][1] = 'METHOD_UNPackER_RADIO'
	Case 'gentee'
		$select_type = 'Gentee Installer'
		Dim $method[2][2], $select[2]
		$method[0][0] = 'Gentee TC 1 (InstExpl.wcx)'
		$method[0][1] = 'METHOD_EXTRACTION_RADIO'
		$method[1][0] = 'Gentee TC 2 (TotalObserver.wcx)'
		$method[1][1] = 'METHOD_EXTRACTION_RADIO'
	Case 'sf'
		$select_type = 'Setup Factory'
		Dim $method[2][2], $select[2]
		$method[0][0] = 'SF TC 1 (InstExpl.wcx)'
		$method[0][1] = 'METHOD_EXTRACTION_RADIO'
		$method[1][0] = 'SF TC 2 (TotalObserver.wcx)'
		$method[1][1] = 'METHOD_EXTRACTION_RADIO'
	EndSwitch

	; Create GUI and set header information
	; Создание GUI и установка заголовка информации
	Opt("GUIOnEventMode", 0)
	Local $guimethod = GUICreate($title, 360, $base_height + (UBound($method) * 20))
	$header = GUICtrlCreateLabel(t('METHOD_HEADER', CreateArray($select_type)), 5, 5, 350, 20)
	GUICtrlCreateLabel(t('METHOD_TEXT_LABEL', CreateArray($name, $select_type, $name)), 5, 25, 350, 65, $SS_LEFT)

	; Create radio selection options
	; Создание радио-кнопок выбора метода
	GUICtrlCreateGroup(t('METHOD_RADIO_LABEL'), 5, $base_radio, 245, 25 + (UBound($method) * 20))
	For $i = 0 To UBound($method)-1
		$select[$i] = GUICtrlCreateRadio(t($method[$i][1], CreateArray($method[$i][0])), 10, $base_radio + 20 + ($i * 20), 235, 20)
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Create buttons
	; Создание кнопок
	$ok = GUICtrlCreateButton(t('OK_BUT'), 265, $base_radio - 10 + (UBound($method) * 10), 80, 20)
	$cancel = GUICtrlCreateButton(t('CANCEL_BUT'), 265, $base_radio - 10 + (UBound($method) * 10) + 30, 80, 20)

	; Set properties
	; Установка свойств
	GUICtrlSetFont($header, -1, 1200)
	GUICtrlSetState($select[0], $GUI_CHECKED)
	GUICtrlSetState($ok, $GUI_DEFBUTTON)

	; Display GUI and wait for action
	; Вывести GUI и ожидать действия пользователя
	GUISetState(@SW_SHOW)
	While 1
		$action = GUIGetMsg()
		Select
			Case $action == $ok
				For $i = 0 To UBound($method)-1
					If GUICtrlRead($select[$i]) == $GUI_CHECKED Then
						GUIDelete($guimethod)
						SplashTextOn($title, t('EXTRACTING') & @CRLF & $splashdisp, 330, 70, -1, $height, 16)
						Return $method[$i][0]
					EndIf
				Next

			; Exit if Cancel clicked or window closed
			; Выход, если нажата кнопка Отмена или окно закрыто
			Case $action == $GUI_EVENT_CLOSE OR $action == $cancel
				If $createdir Then _DirRemove($outdir, 0)
				terminate("silent")
		EndSelect
	WEnd
EndFunc

; Warn user before executing files for extraction
; Предупреждение пользователь перед запуском исполняемого файла
Func Warn_Execute($command)
	$prompt = MsgBox(49+4096, $title, t('WARN_EXECUTE', CreateArray($command)))
	If $prompt <> 1 Then
		If $createdir Then _DirRemove($outdir, 0)
		terminate("silent")
	EndIf
	Return True
EndFunc

; Determine whether the archive is password protected or not, try passwords from list if necessary and prompt password
; Определение используется ли пароль в архиве, подборка пароля из списка и выдача запроса на ввод пароля
Func Password($sIsProtectedCmd, $sTestCmd, $sIsProtectedText = "encrypted", $sIsProtectedText2 = 0, $sTestText = "All OK", $iLog = False)
	; Is archive encrypted?
	; Проверка запаролен ли архив?
	Local $sPassword = ""
	Local $return = FetchStdout($sIsProtectedCmd, $outdir, @SW_HIDE)
	If Not StringInStr($return, $sIsProtectedText) And ($sIsProtectedText2 == 0 Or Not StringInStr($return, $sIsProtectedText2)) Then Return $sPassword

	; Try passwords from list
	; проверяем пароли из списка
	AddLog(t('PASSWORDS'))
	Local $handle = FileOpen($PasswordFile, 1 + 8 + 128)
	$aPasswords = FileReadToArray($PasswordFile)
	FileClose($handle)
	Local $size = UBound($aPasswords)
	If $size > 0 Then AddLog(t('TRYING_PASSWORDS', CreateArray($size)))
	For $i = 0 To $size - 1
		$istring = FetchStdout(StringReplace($sTestCmd, "%PASSWORD%", $aPasswords[$i], 1), $outdir, @SW_HIDE, False)
		If StringInStr($istring, $sTestText) Then
			$sPassword = $aPasswords[$i]
			AddLog(t('PASSWORD_FOUND', CreateArray($sPassword)))
			If $iLog Then 
				AddLog(t('EXECUTING') & ' ' & StringReplace($sTestCmd, "%PASSWORD%", $aPasswords[$i], 1))
				AddLog(t('RUN_OPTION', CreateArray($outdir, @SW_HIDE)))
				AddLog(t('LOG') & @CRLF & StringStripWS($istring, 3))
			EndIf
			Return $sPassword
		EndIf
	Next
	AddLog(t('ASKED_PASSWORD'))
	While 1
		If Not $sPassword Then $sPassword = InputBox($title, t('ASK_PASSWORD'))
		If @error = 1 Then ExitLoop
		If StringInStr(FetchStdout(StringReplace($sTestCmd, "%PASSWORD%", $sPassword, 1), $outdir, @SW_HIDE, False), $sTestText) Then
			AddLog(t('PASSWORD_FOUND', CreateArray($sPassword)))
			If $savepass Then
				AddLog(t('SAVE_PASSWORD'))
				WriteFile($PasswordFile, $sPassword, 1 + 8 + 128)
			EndIf
			If $iLog Then 
				AddLog(t('EXECUTING') & ' ' & StringReplace($sTestCmd, "%PASSWORD%", $aPasswords[$i], 1))
				AddLog(t('RUN_OPTION', CreateArray($outdir, @SW_HIDE)))
				AddLog(t('LOG') & @CRLF & StringStripWS($istring, 3))
			EndIf
			Return $sPassword
		EndIf
    		$sPassword = ""
    		Sleep(20)
	WEnd
	terminate("invalidpas")
EndFunc

Func LogRunWait($f, $sWorkingdir, $show_flag, $logfile = $debugfile)
	Local $return
	AddLog(t('EXECUTING') & ' ' & $f)
	AddLog(t('RUN_OPTION', CreateArray($sWorkingdir, $show_flag)))
	$return = RunWait($f, $sWorkingdir, $show_flag)
	AddLogDebugfile($logfile)
	Return $return
EndFunc

; Run a program and return stdout/stderr stream
; Запуск программы получение потока stdout/stderr
; Bioruebe https://github.com/Bioruebe/UniExtract2
Func FetchStdout($f, $sWorkingdir, $show_flag, $IsLog = True)
	If $IsLog Then AddLog(t('EXECUTING') & ' ' & $f)
	Local $run = 0, $return = ""
	$run = Run($f, $sWorkingdir, $show_flag, 0x8)
	Do
		Sleep(1)
		$return &= StdoutRead($run)
	Until @error
	If $IsLog Then AddLog(t('LOG') & @CRLF & StringStripWS($return, 3))
	Return $return
EndFunc

; Write line to the end of a file
; Запись строки в конец файла
Func WriteFile($f, $String, $flag = 1 + 8)
	Local $handle = FileOpen($f, $flag)
	FileWrite($handle, $String & @CRLF)
	FileClose($handle)
EndFunc

Func WriteReg($Data)
	For $i = 1 To $Data[0][0]
		RegWrite($Data[$i][0], $Data[$i][1], $Data[$i][2], $Data[$i][3])
	Next
EndFunc

Func AddLog($Data = "")
	If Not $Data = "" Then 
		Local $Output = @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC & @TAB & $Data & @CRLF
		$Log &= $Output
	Else
		$Log &= @CRLF
	EndIf
EndFunc

Func AddLogDebugfile($logfile = $debugfile)
	If FileExists($logfile) Then
		$handle = FileOpen($logfile)
		Local $deb = FileRead($handle)
		If Not StringIsSpace($deb) Then AddLog(t('LOG') & @CRLF & StringStripWS($deb, 3))
		FileClose($handle)
		_FileDelete($logfile)
	Else
		AddLog(t('CANNOT_LOG', CreateArray($logarcdisp)))

	EndIf
EndFunc

; Create array on the fly
; Code based on _CreateArray UDF, which has been deprecated
; Создание массива "на лету". Основан на _CreateArray UDF, который устарел
Func CreateArray($i0, $i1 = 0, $i2 = 0, $i3 = 0, $i4 = 0, $i5 = 0, $i6 = 0, $i7 = 0, $i8 = 0, $i9 = 0)
	Local $arr[10] = [$i0, $i1, $i2, $i3, $i4, $i5, $i6, $i7, $i8, $i9]
	ReDim $arr[@numparams]
	Return $arr
EndFunc

Func CreateLog($status, $name = '')
	If Not $name Then
		$name = $logdir & "\" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & "_"
		$name &= StringUpper($status)
		If $file <> "" Then $name &= "_" & $filename & "." & $fileext
		$name &= ".log"
	EndIf
	If FileExists($name) Then _FileDelite($name) 
	$handle = FileOpen($name, 8 + 2)
	FileWrite($handle, $Log)
	FileClose($handle)
	Return $name
EndFunc
$sFile = FileRead ($FileName)

; ------------------------ Begin GUI Control Functions ------------------------
; ------------------------             ГУЙ             ------------------------

; Build and display GUI if necessary (moved to function to allow on-the-fly language changes)
; Создание и отображение GUI при необходимости (позволяет изменять язык "на лету")
Func CreateGUI()
	; Create GUI
	; Создание GUI
	Global $guimain = GUICreate($title, -1, 135, -1, -1, $WS_OVERLAPPEDWINDOW, $WS_EX_ACCEPTFILES)
	$aPos = WinGetPos($title)

	Local $dropzone = GUICtrlCreateLabel("", 0, 0, 300, 135)

	; Menu controls
	; Создание меню
	Local $filemenu = GUICtrlCreateMenu(t('MENU_FILE_LABEL'))
	Local $quititem = GUICtrlCreateMenuItem(t('MENU_FILE_QUIT_LABEL'), $filemenu)
	Local $editmenu = GUICtrlCreateMenu(t('MENU_EDIT_LABEL'))
	Local $prefsitem = GUICtrlCreateMenuItem(t('MENU_EDIT_PREFS_LABEL'), $editmenu)
	Local $openpasitem = GUICtrlCreateMenuItem(t('MENU_OPEN_PASSWORDS_LABEL'), $editmenu)
	Local $helpmenu = GUICtrlCreateMenu(t('MENU_HELP_LABEL'))
	Local $webitem = GUICtrlCreateMenuItem(t('MENU_HELP_WEB_LABEL', CreateArray($name)), $helpmenu)
	GUICtrlCreateMenuItem("", $helpmenu) ; создаёт разделительную линию
	Local $webitem_rb = GUICtrlCreateMenuItem("Ru.Board", $helpmenu)
	Local $webitem_o = GUICtrlCreateMenuItem("OSzone.net", $helpmenu)
	GUICtrlCreateMenuItem("", $helpmenu) ; создаёт разделительную линию
	Local $aboutitem = GUICtrlCreateMenuItem(t('MENU_HELP_ABOUT_LABEL', CreateArray($name)), $helpmenu)

	; File controls
	; Создание меню Файл
	GUICtrlCreateLabel(t('MAIN_FILE_LABEL'), 5, 5, -1, 15)
	If $history Then
		Global $filecont = GUICtrlCreateCombo("", 5, 20, $aPos[2] - 55, 20)
	Else
		Global $filecont = GUICtrlCreateInput("", 5, 20, $aPos[2] - 55, 20)
	EndIf
	Local $filebut = GUICtrlCreateButton("...", $aPos[2] - 45, 20, 25, 20)

	; Directory controls
	; Создание окна выбора директорий
	GUICtrlCreateLabel(t('MAIN_DEST_DIR_LABEL'), 5, 45, -1, 15)
	If $history Then
		Global $dircont = GUICtrlCreateCombo("", 5, 60, $aPos[2] - 55, 20)
	Else
		Global $dircont = GUICtrlCreateInput("", 5, 60, $aPos[2] - 55, 20)
	EndIf
	Local $dirbut = GUICtrlCreateButton("...", $aPos[2] - 45, 60, 25, 20)

	; Buttons
	; Кнопки
	Global $ok = GUICtrlCreateButton(t('OK_BUT'), 80, 90, 80, 20)
	Local $cancel = GUICtrlCreateButton(t('CANCEL_BUT'), 190, 90, 80, 20)

	; Set properties
	; Установка свойств элементов
	GUICtrlSetBkColor($dropzone, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetState($dropzone, $GUI_DISABLE)
	GUICtrlSetState($dropzone, $GUI_DROPACCEPTED)
	GUICtrlSetState($filecont, $GUI_FOCUS)
	GUICtrlSetState($ok, $GUI_DEFBUTTON)
	If $file <> "" Then
		FilenameParse($file)
		If $history Then
			$filelist = '|' & $file & '|' & ReadHist('file')
			GUICtrlSetData($filecont, $filelist, $file)
			$dirlist = '|' & $initoutdir & '|' & ReadHist('directory')
			GUICtrlSetData($dircont, $dirlist, $initoutdir)
		Else
			GUICtrlSetData($filecont, $file)
			GUICtrlSetData($dircont, $initoutdir)
		EndIf
		GUICtrlSetState($dircont, $GUI_FOCUS)
	ElseIf $history Then
		GUICtrlSetData($filecont, ReadHist('file'))
		GUICtrlSetData($dircont, ReadHist('directory'))
	EndIf

	; Set events
	; Обработка событий элементов
	GUISetOnEvent($GUI_EVENT_DROPPED, "GUI_Drop")
	GUICtrlSetOnEvent($filebut, "GUI_File")
	GUICtrlSetOnEvent($dirbut, "GUI_Directory")
	GUICtrlSetOnEvent($prefsitem, "GUI_Prefs")
	GUICtrlSetOnEvent($openpasitem, "GUI_Password")
	GUICtrlSetOnEvent($webitem, "GUI_Website")
	GUICtrlSetOnEvent($webitem_rb, "GUI_Website_RB")
	GUICtrlSetOnEvent($webitem_o, "GUI_Website_O")
	GUICtrlSetOnEvent($aboutitem, "GUI_ABOUT")
	GUICtrlSetOnEvent($ok, "GUI_Ok")
	GUICtrlSetOnEvent($cancel, "GUI_Exit")
	GUICtrlSetOnEvent($quititem, "GUI_Exit")
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_Exit")

	; Display GUI and wait for action
	; Отобразить GUI и ждать действий пользователя
	GUISetState(@SW_SHOW)
EndFunc

; Return control width (for dynamic positioning)
; Возвращает ширину элемента (при динамическом позиционировании)
Func GetPos($gui, $control, $offset = 0)
	$location = ControlGetPos($gui, '', $control)
	If @error Then
		SetError(1, '', 0)
	Else
		Return $location[0] + $location[2] + $offset
	EndIf
EndFunc

; Return number of times a character appears in a string
; Возврашает сколько раз символ встречается в строке
Func CharCount($string, $char)
	Local $count = StringSplit($string, $char, 1)
	Return $count[0]
EndFunc

; Prompt user for file
; Окно выбора файла
Func GUI_File()
	$file = FileOpenDialog(t('OPEN_FILE'), "", t('SELECT_FILE') & " (*.*)", 1)
	If NOT @error Then
		If $history Then
			$filelist = '|' & $file & '|' & ReadHist('file')
			GUICtrlSetData($filecont, $filelist, $file)
		Else
			GUICtrlSetData($filecont, $file)
		EndIf
		If GUICtrlRead($dircont) = "" Then
			FilenameParse($file)
			If $history Then
				$dirlist = '|' & $initoutdir & '|' & ReadHist('directory')
				GUICtrlSetData($dircont, $dirlist, $initoutdir)
			Else
				GUICtrlSetData($dircont, $initoutdir)
			EndIf
		EndIf
		GUICtrlSetState($ok, $GUI_FOCUS)
	EndIf
EndFunc

; Prompt user for directory
; Окно выбора директории
Func GUI_Directory()
	If FileExists(GUICtrlRead($dircont)) Then
		$defdir = GUICtrlRead($dircont)
	ElseIf FileExists(GUICtrlRead($filecont)) Then
		$defdir = StringLeft(GUICtrlRead($filecont), StringInStr(GUICtrlRead($filecont), '\', 0, -1)-1)
	Else
		$defdir = ''
	EndIf
	$outdir = FileSelectFolder(t('EXTRACT_TO'), "", 3, $defdir)
	If NOT @error Then
		If $history Then
			$dirlist = '|' & $outdir & '|' & ReadHist('directory')
			GUICtrlSetData($dircont, $dirlist, $outdir)
		Else
			GUICtrlSetData($dircont, $outdir)
		EndIf
	EndIf
EndFunc

; Prompt user for debug file directory
; Окно выбора директории для файла отладки
Func GUI_Prefs_Debug()
	If FileExists(EnvParse(GUICtrlRead(($debugcont)))) Then
		$defdir = EnvParse(GUICtrlRead($debugcont))
	ElseIf FileExists(EnvParse($debugdir)) Then
		$defdir = EnvParse($debugdir)
	Else
		$defdir = @tempdir
	EndIf
	If StringRight($defdir, 1) == ':' Then $defdir &= '\'
	$debugdir = FileSelectFolder(t('WRITE_TO'), "", 3, $defdir)
	If NOT @error Then GUICtrlSetData($debugcont, $debugdir)
EndFunc

; Prompt user for log file directory
; Окно выбора директории для лог-файла
Func GUI_Prefs_Log()
	If FileExists(EnvParse(GUICtrlRead(($logcont)))) Then
		$defdir = EnvParse(GUICtrlRead($logcont))
	ElseIf FileExists(EnvParse($logdir)) Then
		$defdir = EnvParse($logdir)
	Else
		$defdir = @tempdir
	EndIf
	If StringRight($defdir, 1) == ':' Then $defdir &= '\'
	$logdir = FileSelectFolder(t('WRITE_TO'), "", 3, $defdir)
	If NOT @error Then GUICtrlSetData($logcont, $logdir)
EndFunc

; Exit preferences GUI if Cancel clicked or window closed
; Выход из окна Настройки при нажатии на кнопку Cancel или при закрытии окна
Func GUI_Prefs_Exit()
	GUIDelete($guiprefs)
	If $prefsonly Then
		terminate("silent")
	EndIf
EndFunc

; Exit preferences GUI if OK clicked
; Выход из окна Настройки при нажатии на кнопку OK
Func GUI_Prefs_OK()
	; universal preferences
	; общие настройки
	$redrawgui = False
	If FileExists(EnvParse(GUICtrlRead($debugcont))) AND StringInStr(FileGetAttrib(EnvParse(GUICtrlRead($debugcont))), 'D') Then
		$debugdir = GUICtrlRead($debugcont)
	Else
		MsgBox(48, $title, t('INVALID_DIR_SELECTED', CreateArray(GUICtrlRead($debugcont))))
		Return
	EndIf
	If FileExists(EnvParse(GUICtrlRead($logcont))) AND StringInStr(FileGetAttrib(EnvParse(GUICtrlRead($logcont))), 'D') Then
		$logdir = GUICtrlRead($logcont)
	Else
		_DirCreate($logdir)

		Return
	EndIf
	If GUICtrlRead($historyopt) == $GUI_CHECKED Then
		If $history == 0 Then
			$history = 1
			$redrawgui = True
		EndIf
	Else
		If $history == 1 Then
			$history = 0
			If $globalprefs Then
				IniDelete($prefs, "File History")
				IniDelete($prefs, "Directory History")
			Else
				RegDelete($reg & '\File')
				RegDelete($reg & '\Directory')
			EndIf
			$redrawgui = True
		EndIf
	EndIf
	If GUICtrlRead($nodoswinopt) == $GUI_CHECKED Then
		$nodoswin = 1
	Else
		$nodoswin = 0
	EndIf
	If GUICtrlRead($mindoswinopt) == $GUI_CHECKED Then
		$mindoswin = 1
	Else
		$mindoswin = 0
	EndIf
	If GUICtrlRead($savepassopt) == $GUI_CHECKED Then
		$savepass = 1
	Else
		$savepass = 0
	EndIf
	If GUICtrlRead($savelogopt) == $GUI_CHECKED Then
		$savelog = 1
	Else
		$savelog = 0
	EndIf
	If GUICtrlRead($savelogalwaysopt) == $GUI_CHECKED Then
		$savelogalways = 1
	Else
		$savelogalways = 0
	EndIf
	If $language <> GUICtrlRead($langselect) Then
		$language = GUICtrlRead($langselect)
		$redrawgui = True
	EndIf

	; format-specific preferences
	; специальные опции формата
	If GUICtrlRead($warnexecuteopt) == $GUI_CHECKED Then
		$warnexecute = 1
	Else
		$warnexecute = 0
	EndIf
	If GUICtrlRead($removedupeopt) == $GUI_CHECKED Then
		$removedupe = 1
	Else
		$removedupe = 0
	EndIf
	If GUICtrlRead($removetempopt) == $GUI_CHECKED Then
		$removetemp = 1
	Else
		$removetemp = 0
	EndIf
	If GUICtrlRead($appendextopt) == $GUI_CHECKED Then
		$appendext = 1
	Else
		$appendext = 0
	EndIf

	; PE-files analizators
	; Анализаторы PE-файлов
	If GUICtrlRead($useepeopt) == $GUI_CHECKED Then
		$useepe = 1
	Else
		$useepe = 0
	EndIf
	If GUICtrlRead($usedieopt) == $GUI_CHECKED Then
		$usedie = 1
	Else
		$usedie = 0
	EndIf
	If GUICtrlRead($usepeidopt) == $GUI_CHECKED Then
		$usepeid = 1
	Else
		$usepeid = 0
	EndIf

	WritePrefs()
	GUIDelete($guiprefs)
	If $prefsonly Then
		$finishprefs = True
	ElseIf $redrawgui Then
		GUIDelete($guimain)
		CreateGUI()
	EndIf
EndFunc

; Set file to extract and target directory, Then exit
; Установка файла для извлечения и директории назначения и выход
Func GUI_Ok()
	$file = EnvParse(GUICtrlRead($filecont))
	If FileExists($file) Then
		If EnvParse(GUICtrlRead($dircont)) == "" Then
			$outdir = '/sub'
		Else
			$outdir = EnvParse(GUICtrlRead($dircont))
		EndIf
		GUIDelete($guimain)
		Global $finishgui = True
	Else
		If $file == '' Then
			$file = ''
		Else
			$file &= ' ' & t('DOES_NOT_EXIST')
		EndIf
		MsgBox(48, $title, t('INVALID_FILE_SELECTED', CreateArray($file)))
		Return
	EndIf
EndFunc

; Process dropped files outside of file input box
; Обработка файла перемещенного мышью за пределы поля для ввода имени файла
Func GUI_Drop()
	If FileExists(@GUI_DragFile) Then
		$file = @GUI_DragFile
		If $history Then
			$filelist = '|' & $file & '|' & ReadHist('file')
			GUICtrlSetData($filecont, $filelist, $file)
		Else
			GUICtrlSetData($filecont, $file)
		EndIf
		If GUICtrlRead($dircont) = "" Then
			FilenameParse($file)
			If $history Then
				$dirlist = '|' & $initoutdir & '|' & ReadHist('directory')
				GUICtrlSetData($dircont, $dirlist, $initoutdir)
			Else
				GUICtrlSetData($dircont, $initoutdir)
			EndIf
		EndIf
	EndIf
EndFunc

; Build and display preferences GUI
; Создание и отображение окна Настройки
Func GUI_Prefs()
	; Read language files
	; Чтение языкового файла
	$langlist = ''
	Dim $langarr[1]
	$temp = FileFindFirstFile($langdir & '\*.ini')
	If $temp <> -1 Then
		Local $langarr = _FileListToArray($langdir, '*.ini', 1)
		FileClose($temp)
	EndIf
	$langarr[0] = 'English.ini'
	_ArraySort($langarr)
	For $i = 0 To UBound($langarr)-1
		$langlist &= StringTrimRight($langarr[$i], 4) & '|'
	Next
	$langlist = StringTrimRight($langlist, 1)

	; Create GUI
	; Создание GUI
	If $prefsonly Then
		Global $guiprefs = GUICreate(t('PREFS_TITLE_LABEL'), 270, 425)
	Else
		Global $guiprefs = GUICreate(t('PREFS_TITLE_LABEL'), 270, 425, -1, -1, -1, -1, $guimain)
	EndIf

	; Universal prefs box
	; Часть окна с общими настройками
	GUICtrlCreateGroup(t('PREFS_UNIEXTRACT_OPTS_LABEL'), 5, 0, 260, 200)

	; History option
	; История
	Global $historyopt = GUICtrlCreateCheckbox(t('PREFS_HISTORY_LABEL'), 10, 15, -1, 20)

	; Console windows controls
	; Скрытие окна консоли
	Global $nodoswinopt = GUICtrlCreateCheckbox(t('PREFS_NODOSWIN_LABEL'), 10, 35, -1, 20)

	; Minimize windows controls
	; Минимизированме окна консоли
	Global $mindoswinopt = GUICtrlCreateCheckbox(t('PREFS_MINDOSWIN_LABEL'), 10, 55, -1, 20)

	; Minimize windows controls
	; Минимизированме окна консоли
	Global $savepassopt = GUICtrlCreateCheckbox(t('PREFS_SAVEPASS_LABEL'), 10, 75, -1, 20)

	GUICtrlCreateUpdown(-1)
	GUICtrlSetLimit(-1, 30, 7)

	; Language controls
	; Выбор языка
	Local $langlabel = GUICtrlCreateLabel(t('PREFS_LANG_LABEL'), 10, 98, -1, 15)
	Local $langselectpos = GetPos($guiprefs, $langlabel, -8)
	Global $langselect = GUICtrlCreateCombo("", $langselectpos, 95, 265 - $langselectpos - 4, 20 * CharCount($langlist, '|'), $CBS_DROPDOWNLIST)

	; Debug controls
	; Отладочный файл
	Local $debuglabel = GUICtrlCreateLabel(t('PREFS_DEBUG_LABEL'), 10, 120, -1, 20)
	;Local $debugcontpos = GetPos($guiprefs, $debuglabel, -5)
	Global $debugcont = GUICtrlCreateInput($debugdir, 10, 135, 220, 20)
	Local $debugbut = GUICtrlCreateButton("...", 235, 135, 25, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Logfile controls
	; Лог-файл
	Global $savelogopt = GUICtrlCreateCheckbox(t('PREFS_LOG_LABEL'), 10, 155, -1, 20)
	GUICtrlSetOnEvent(-1, "GUI_LogLabel")
	Global $savelogalwaysopt = GUICtrlCreateCheckbox(t('PREFS_LOG_LABEL_ALWAYS'), 200, 155, -1, 20)
	Global $logcont = GUICtrlCreateInput($logdir, 10, 175, 220, 20)
	Global $logbut = GUICtrlCreateButton("...", 235, 175, 25, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Advanced Options preferences
	; Секция "Расширенные настройки"
	GUICtrlCreateGroup(t('PREFS_FORMAT_OPTS_LABEL'), 5, 205, 260, 100)
	Global $warnexecuteopt = GUICtrlCreateCheckbox(t('PREFS_WARN_EXECUTE_LABEL'), 10, 220, -1, 20)
	Global $removedupeopt = GUICtrlCreateCheckbox(t('PREFS_REMOVE_DUPE_LABEL'), 10, 240, -1, 20)
	Global $removetempopt = GUICtrlCreateCheckbox(t('PREFS_REMOVE_TEMP_LABEL'), 10, 260, -1, 20)
	Global $appendextopt = GUICtrlCreateCheckbox(t('PREFS_APPEND_EXT_LABEL'), 10, 280, -1, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; PE-files analizators
	; Анализаторы PE-файлов
	GUICtrlCreateGroup(t('PE_ANALIZATORS'), 5, 310, 260, 80)
	Global $useepeopt = GUICtrlCreateCheckbox('Exeinfo Pe', 10, 325, -1, 20)
	Global $usedieopt = GUICtrlCreateCheckbox('Detect It Easy', 10, 345, -1, 20)
	Global $usepeidopt = GUICtrlCreateCheckbox('PEiD', 10, 365, -1, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Buttons
	; Кнопки
	Local $prefsok = GUICtrlCreateButton(t('OK_BUT'), 65, 400, 60, 20)
	Local $prefscancel = GUICtrlCreateButton(t('CANCEL_BUT'), 145, 400, 60, 20)

	; Set properties
	; Установка свойств элементов
	GUICtrlSetState($prefsok, $GUI_DEFBUTTON)
	If $history Then GUICtrlSetState($historyopt, $GUI_CHECKED)
	If $nodoswin Then GUICtrlSetState($nodoswinopt, $GUI_CHECKED)
	If $mindoswin Then GUICtrlSetState($mindoswinopt, $GUI_CHECKED)
	If $savepass Then GUICtrlSetState($savepassopt, $GUI_CHECKED)
	If $savelog Then GUICtrlSetState($savelogopt, $GUI_CHECKED)
	If $savelogalways Then GUICtrlSetState($savelogalwaysopt, $GUI_CHECKED)
	If Not $savelog Then GUICtrlSetState($savelogalwaysopt, $GUI_DISABLE)
	If Not $savelog Then GUICtrlSetState($logcont, $GUI_DISABLE)
	If Not $savelog Then GUICtrlSetState($logbut, $GUI_DISABLE)
	If $warnexecute Then GUICtrlSetState($warnexecuteopt, $GUI_CHECKED)
	If $removedupe Then GUICtrlSetState($removedupeopt, $GUI_CHECKED)
	If $removetemp Then GUICtrlSetState($removetempopt, $GUI_CHECKED)
	If $appendext Then GUICtrlSetState($appendextopt, $GUI_CHECKED)
	If StringInStr($langlist, $language, 0) Then
		GUICtrlSetData($langselect, $langlist, $language)
	Else
		GUICtrlSetData($langselect, $langlist, 'English')
	EndIf
	If $useepe Then GUICtrlSetState($useepeopt, $GUI_CHECKED)
	If $usedie Then GUICtrlSetState($usedieopt, $GUI_CHECKED)
	If $usepeid Then GUICtrlSetState($usepeidopt, $GUI_CHECKED)

	; Set events
	; Обработка событий элементов
	GUICtrlSetOnEvent($debugbut, "GUI_Prefs_Debug")
	GUICtrlSetOnEvent($logbut, "GUI_Prefs_Log")
	GUICtrlSetOnEvent($prefsok, "GUI_Prefs_OK")
	GUICtrlSetOnEvent($prefscancel, "GUI_Prefs_Exit")
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_Prefs_Exit")

	; Display GUI and wait for action
	; Отобразить GUI и ждать действий пользователя
	GUISetState(@SW_SHOW)
EndFunc

Func GUI_LogLabel()
    If $savelogopt = @GUI_CTRLID Then
        If BitAND(GUICtrlRead($savelogopt), $GUI_CHECKED) Then
            GUICtrlSetState($savelogalwaysopt, $GUI_ENABLE)
            GUICtrlSetState($logcont, $GUI_ENABLE)
            GUICtrlSetState($logbut, $GUI_ENABLE)
        Else
            GUICtrlSetState($savelogalwaysopt, $GUI_DISABLE)
            GUICtrlSetState($logcont, $GUI_DISABLE)
            GUICtrlSetState($logbut, $GUI_DISABLE)
        EndIf
    EndIf
EndFunc

; Open password list file
; Открыть список паролей
Func GUI_Password()
	If Not FileExists($PasswordFile) Then
		$handle = FileOpen($PasswordFile, 1)
		FileClose($handle)
	EndIf
	ShellExecute($PasswordFile)
EndFunc

; Launch Universal Extractor website if Help menu item selected
; Открыть сайт Universal Extractor
Func GUI_Website()
	ShellExecute($website)
EndFunc

; Launch Ru.Board topic of Universal Extractor if Help menu item selected
; Открыть топик на Ru.Board об Universal Extractor
Func GUI_Website_RB()
	ShellExecute($website_rb)
EndFunc

; Launch OSzone topic of Universal Extractor if Help menu item selected
; Открыть топик на OSzone об Universal Extractor
Func GUI_Website_O()
	ShellExecute($website_o)
EndFunc

Func GUI_ABOUT()
	MsgBox(64, t('MENU_HELP_ABOUT_LABEL'), $name & " " & $version & @CRLF & "Copyright © 2005-2010 Jared Breland" & @CRLF & "Mod by koros aka ya158 (koros@ya.ru) 2013-2015")
EndFunc

; Exit if Cancel clicked or window closed
; Выход при нажатии кнопки Отмена или при закрытии окна
Func GUI_Exit()
	terminate("silent")
EndFunc

#cs
	Вернет при успехе позицию вхождения $s_HexString в файле $s_File или 0, если нет вхождения.
	При неудаче вернет 0 и флаг @error = :
	1 - нет файла $s_File;
	2 - длина $s_HexString не кратна 2;
	3 - не получилось открыть файл $s_File;
	4 - ошибка функции FileSetPos.

	Читает весь файл подряд по 300 Кб, можно поменять на нужные Вам
#ce
Func _Find_HexString_In_File($s_File, $s_HexString, $f_Size = 10 * 1024 * 1024)
	Local Const $i_Read = 300 * 1024, $__FILE_CURRENT_ = 1
	Local $i_Len, $h_File, $b_Read, $i_Pos, $i_Count, $i_Err, $Size, $c_Pos

	If Not FileExists($s_File) Then Return SetError(1, 0, 0)
	$Size = FileGetSize($s_File) - $f_Size

	If IsBinary($s_HexString) Then
		$s_HexString = Hex($s_HexString)
		Else
		$s_HexString = StringStripWS($s_HexString, 8)
	EndIf
	$i_Len = StringLen($s_HexString)
	If Mod($i_Len, 2) Then Return SetError(2, 0, 0)
	$i_Len /= 2
	$h_File = FileOpen($s_File, 16)
	If $h_File = -1 Then Return SetError(3, 0, 0)
	While 1
		$c_Pos = FileGetPos($h_File)
		If $c_Pos > $f_size AND $c_Pos < $Size Then FileSetPos($h_File, -$f_size, 2)
		$b_Read = FileRead($h_File, $i_Read)
		If @extended <= $i_Len Then ExitLoop
		$i_Pos = StringInStr($b_Read, $s_HexString, 2)
		If Mod($i_Pos, 2) Then ExitLoop
		$i_Pos = 0
		If Not FileSetPos($h_File, -$i_Len, $__FILE_CURRENT_) Then
			$i_Err = 4
			ExitLoop
		EndIf
		$i_Count += 1
	WEnd
	FileClose($h_File)
	If $i_Err Then Return SetError($i_Err, 0, 0)
	If $i_Pos Then Return Int(($i_Pos - 1) / 2 - 1 + ($i_Read - $i_Len) * $i_Count)
	Return 0
EndFunc   ;==>_Find_HexString_In_File
