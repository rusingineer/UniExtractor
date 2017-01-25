
Func _arrayadd(ByRef $avarray, $vvalue)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, -1)
	Local $iubound = UBound($avarray)
	ReDim $avarray[$iubound + 1]
	$avarray[$iubound] = $vvalue
	Return $iubound
EndFunc

Func _arraybinarysearch(Const ByRef $avarray, $vvalue, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(5, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(4, 0, -1)
	Local $imid = Int(($iend + $istart) / 2)
	If $avarray[$istart] > $vvalue OR $avarray[$iend] < $vvalue Then Return SetError(2, 0, -1)
	While $istart <= $imid AND $vvalue <> $avarray[$imid]
		If $vvalue < $avarray[$imid] Then
			$iend = $imid - 1
		Else
			$istart = $imid + 1
		EndIf
		$imid = Int(($iend + $istart) / 2)
	WEnd
	If $istart > $iend Then Return SetError(3, 0, -1)
	Return $imid
EndFunc

Func _arraycombinations(ByRef $avarray, $iset, $sdelim = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $in = UBound($avarray)
	Local $ir = $iset
	Local $aidx[$ir]
	For $i = 0 To $ir - 1
		$aidx[$i] = $i
	Next
	Local $itotal = __array_combinations($in, $ir)
	Local $ileft = $itotal
	Local $aresult[$itotal + 1]
	$aresult[0] = $itotal
	Local $icount = 1
	While $ileft > 0
		__array_getnext($in, $ir, $ileft, $itotal, $aidx)
		For $i = 0 To $iset - 1
			$aresult[$icount] &= $avarray[$aidx[$i]] & $sdelim
		Next
		If $sdelim <> "" Then $aresult[$icount] = StringTrimRight($aresult[$icount], 1)
		$icount += 1
	WEnd
	Return $aresult
EndFunc

Func _arrayconcatenate(ByRef $avarraytarget, Const ByRef $avarraysource, $istart = 0)
	If NOT IsArray($avarraytarget) Then Return SetError(1, 0, 0)
	If NOT IsArray($avarraysource) Then Return SetError(2, 0, 0)
	If UBound($avarraytarget, 0) <> 1 Then
		If UBound($avarraysource, 0) <> 1 Then Return SetError(5, 0, 0)
		Return SetError(3, 0, 0)
	EndIf
	If UBound($avarraysource, 0) <> 1 Then Return SetError(4, 0, 0)
	Local $iuboundtarget = UBound($avarraytarget) - $istart, $iuboundsource = UBound($avarraysource)
	ReDim $avarraytarget[$iuboundtarget + $iuboundsource]
	For $i = $istart To $iuboundsource - 1
		$avarraytarget[$iuboundtarget + $i] = $avarraysource[$i]
	Next
	Return $iuboundtarget + $iuboundsource
EndFunc

Func _arraycreate($v_0, $v_1 = 0, $v_2 = 0, $v_3 = 0, $v_4 = 0, $v_5 = 0, $v_6 = 0, $v_7 = 0, $v_8 = 0, $v_9 = 0, $v_10 = 0, $v_11 = 0, $v_12 = 0, $v_13 = 0, $v_14 = 0, $v_15 = 0, $v_16 = 0, $v_17 = 0, $v_18 = 0, $v_19 = 0, $v_20 = 0)
	Local $av_array[21] = [$v_0, $v_1, $v_2, $v_3, $v_4, $v_5, $v_6, $v_7, $v_8, $v_9, $v_10, $v_11, $v_12, $v_13, $v_14, $v_15, $v_16, $v_17, $v_18, $v_19, $v_20]
	ReDim $av_array[@NumParams]
	Return $av_array
EndFunc

Func _arraydelete(ByRef $avarray, $ielement)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	Local $iubound = UBound($avarray, 1) - 1
	If NOT $iubound Then
		$avarray = ""
		Return 0
	EndIf
	If $ielement < 0 Then $ielement = 0
	If $ielement > $iubound Then $ielement = $iubound
	Switch UBound($avarray, 0)
		Case 1
			For $i = $ielement To $iubound - 1
				$avarray[$i] = $avarray[$i + 1]
			Next
			ReDim $avarray[$iubound]
		Case 2
			Local $isubmax = UBound($avarray, 2) - 1
			For $i = $ielement To $iubound - 1
				For $j = 0 To $isubmax
					$avarray[$i][$j] = $avarray[$i + 1][$j]
				Next
			Next
			ReDim $avarray[$iubound][$isubmax + 1]
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch
	Return $iubound
EndFunc

Func _arraydisplay(Const ByRef $avarray, $stitle = "Array: ListView Display", $iitemlimit = -1, $itranspose = 0, $sseparator = "", $sreplace = "|", $sheader = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	Local $idimension = UBound($avarray, 0), $iubound = UBound($avarray, 1) - 1, $isubmax = UBound($avarray, 2) - 1
	If $idimension > 2 Then Return SetError(2, 0, 0)
	If $sseparator = "" Then $sseparator = Chr(124)
	If _arraysearch($avarray, $sseparator, 0, 0, 0, 1) <> -1 Then
		For $x = 1 To 255
			If $x >= 32 AND $x <= 127 Then ContinueLoop
			Local $sfind = _arraysearch($avarray, Chr($x), 0, 0, 0, 1)
			If $sfind = -1 Then
				$sseparator = Chr($x)
				ExitLoop
			EndIf
		Next
	EndIf
	Local $vtmp, $ibuffer = 4094
	Local $icollimit = 250
	Local $ioneventmode = Opt("GUIOnEventMode", 0), $sdataseparatorchar = Opt("GUIDataSeparatorChar", $sseparator)
	If $isubmax < 0 Then $isubmax = 0
	If $itranspose Then
		$vtmp = $iubound
		$iubound = $isubmax
		$isubmax = $vtmp
	EndIf
	If $isubmax > $icollimit Then $isubmax = $icollimit
	If $iitemlimit < 1 Then $iitemlimit = $iubound
	If $iubound > $iitemlimit Then $iubound = $iitemlimit
	If $sheader = "" Then
		$sheader = "Row  "
		For $i = 0 To $isubmax
			$sheader &= $sseparator & "Col " & $i
		Next
	EndIf
	Local $avarraytext[$iubound + 1]
	For $i = 0 To $iubound
		$avarraytext[$i] = "[" & $i & "]"
		For $j = 0 To $isubmax
			If $idimension = 1 Then
				If $itranspose Then
					$vtmp = $avarray[$j]
				Else
					$vtmp = $avarray[$i]
				EndIf
			Else
				If $itranspose Then
					$vtmp = $avarray[$j][$i]
				Else
					$vtmp = $avarray[$i][$j]
				EndIf
			EndIf
			$vtmp = StringReplace($vtmp, $sseparator, $sreplace, 0, 1)
			If StringLen($vtmp) > $ibuffer Then $vtmp = StringLeft($vtmp, $ibuffer)
			$avarraytext[$i] &= $sseparator & $vtmp
		Next
	Next
	Local Const $_arrayconstant_gui_dockborders = 102
	Local Const $_arrayconstant_gui_dockbottom = 64
	Local Const $_arrayconstant_gui_dockheight = 512
	Local Const $_arrayconstant_gui_dockleft = 2
	Local Const $_arrayconstant_gui_dockright = 4
	Local Const $_arrayconstant_gui_event_close = -3
	Local Const $_arrayconstant_lvm_getcolumnwidth = (4096 + 29)
	Local Const $_arrayconstant_lvm_getitemcount = (4096 + 4)
	Local Const $_arrayconstant_lvm_getitemstate = (4096 + 44)
	Local Const $_arrayconstant_lvm_setextendedlistviewstyle = (4096 + 54)
	Local Const $_arrayconstant_lvs_ex_fullrowselect = 32
	Local Const $_arrayconstant_lvs_ex_gridlines = 1
	Local Const $_arrayconstant_lvs_showselalways = 8
	Local Const $_arrayconstant_ws_ex_clientedge = 512
	Local Const $_arrayconstant_ws_maximizebox = 65536
	Local Const $_arrayconstant_ws_minimizebox = 131072
	Local Const $_arrayconstant_ws_sizebox = 262144
	Local $iwidth = 640, $iheight = 480
	Local $hgui = GUICreate($stitle, $iwidth, $iheight, Default, Default, BitOR($_arrayconstant_ws_sizebox, $_arrayconstant_ws_minimizebox, $_arrayconstant_ws_maximizebox))
	Local $aiguisize = WinGetClientSize($hgui)
	Local $hlistview = GUICtrlCreateListView($sheader, 0, 0, $aiguisize[0], $aiguisize[1] - 26, $_arrayconstant_lvs_showselalways)
	Local $hcopy = GUICtrlCreateButton("Copy Selected", 3, $aiguisize[1] - 23, $aiguisize[0] - 6, 20)
	GUICtrlSetResizing($hlistview, $_arrayconstant_gui_dockborders)
	GUICtrlSetResizing($hcopy, $_arrayconstant_gui_dockleft + $_arrayconstant_gui_dockright + $_arrayconstant_gui_dockbottom + $_arrayconstant_gui_dockheight)
	GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setextendedlistviewstyle, $_arrayconstant_lvs_ex_gridlines, $_arrayconstant_lvs_ex_gridlines)
	GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setextendedlistviewstyle, $_arrayconstant_lvs_ex_fullrowselect, $_arrayconstant_lvs_ex_fullrowselect)
	GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_setextendedlistviewstyle, $_arrayconstant_ws_ex_clientedge, $_arrayconstant_ws_ex_clientedge)
	For $i = 0 To $iubound
		GUICtrlCreateListViewItem($avarraytext[$i], $hlistview)
	Next
	$iwidth = 0
	For $i = 0 To $isubmax + 1
		$iwidth += GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_getcolumnwidth, $i, 0)
	Next
	If $iwidth < 250 Then $iwidth = 230
	$iwidth += 20
	If $iwidth > @DesktopWidth Then $iwidth = @DesktopWidth - 100
	WinMove($hgui, "", (@DesktopWidth - $iwidth) / 2, Default, $iwidth)
	GUISetState(@SW_SHOW, $hgui)
	While 1
		Switch GUIGetMsg()
			Case $_arrayconstant_gui_event_close
				ExitLoop
			Case $hcopy
				Local $sclip = ""
				Local $aicuritems[1] = [0]
				For $i = 0 To GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_getitemcount, 0, 0)
					If GUICtrlSendMsg($hlistview, $_arrayconstant_lvm_getitemstate, $i, 2) Then
						$aicuritems[0] += 1
						ReDim $aicuritems[$aicuritems[0] + 1]
						$aicuritems[$aicuritems[0]] = $i
					EndIf
				Next
				If NOT $aicuritems[0] Then
					For $sitem In $avarraytext
						$sclip &= $sitem & @CRLF
					Next
				Else
					For $i = 1 To UBound($aicuritems) - 1
						$sclip &= $avarraytext[$aicuritems[$i]] & @CRLF
					Next
				EndIf
				ClipPut($sclip)
		EndSwitch
	WEnd
	GUIDelete($hgui)
	Opt("GUIOnEventMode", $ioneventmode)
	Opt("GUIDataSeparatorChar", $sdataseparatorchar)
	Return 1
EndFunc

Func _arrayfindall(Const ByRef $avarray, $vvalue, $istart = 0, $iend = 0, $icase = 0, $icompare = 0, $isubitem = 0)
	$istart = _arraysearch($avarray, $vvalue, $istart, $iend, $icase, $icompare, 1, $isubitem)
	If @error Then Return SetError(@error, 0, -1)
	Local $iindex = 0, $avresult[UBound($avarray)]
	Do
		$avresult[$iindex] = $istart
		$iindex += 1
		$istart = _arraysearch($avarray, $vvalue, $istart + 1, $iend, $icase, $icompare, 1, $isubitem)
	Until @error
	ReDim $avresult[$iindex]
	Return $avresult
EndFunc

Func _arrayinsert(ByRef $avarray, $ielement, $vvalue = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $iubound = UBound($avarray) + 1
	ReDim $avarray[$iubound]
	For $i = $iubound - 1 To $ielement + 1 Step -1
		$avarray[$i] = $avarray[$i - 1]
	Next
	$avarray[$ielement] = $vvalue
	Return $iubound
EndFunc

Func _arraymax(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	Local $iresult = _arraymaxindex($avarray, $icompnumeric, $istart, $iend)
	If @error Then Return SetError(@error, 0, "")
	Return $avarray[$iresult]
EndFunc

Func _arraymaxindex(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) OR UBound($avarray, 0) <> 1 Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, -1)
	Local $imaxindex = $istart
	If $icompnumeric Then
		For $i = $istart To $iend
			If Number($avarray[$imaxindex]) < Number($avarray[$i]) Then $imaxindex = $i
		Next
	Else
		For $i = $istart To $iend
			If $avarray[$imaxindex] < $avarray[$i] Then $imaxindex = $i
		Next
	EndIf
	Return $imaxindex
EndFunc

Func _arraymin(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	Local $iresult = _arrayminindex($avarray, $icompnumeric, $istart, $iend)
	If @error Then Return SetError(@error, 0, "")
	Return $avarray[$iresult]
EndFunc

Func _arrayminindex(Const ByRef $avarray, $icompnumeric = 0, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, -1)
	Local $iminindex = $istart
	If $icompnumeric Then
		For $i = $istart To $iend
			If Number($avarray[$iminindex]) > Number($avarray[$i]) Then $iminindex = $i
		Next
	Else
		For $i = $istart To $iend
			If $avarray[$iminindex] > $avarray[$i] Then $iminindex = $i
		Next
	EndIf
	Return $iminindex
EndFunc

Func _arraypermute(ByRef $avarray, $sdelim = "")
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $isize = UBound($avarray), $ifactorial = 1, $aidx[$isize], $aresult[1], $icount = 1
	For $i = 0 To $isize - 1
		$aidx[$i] = $i
	Next
	For $i = $isize To 1 Step -1
		$ifactorial *= $i
	Next
	ReDim $aresult[$ifactorial + 1]
	$aresult[0] = $ifactorial
	__array_exeterinternal($avarray, 0, $isize, $sdelim, $aidx, $aresult, $icount)
	Return $aresult
EndFunc

Func _arraypop(ByRef $avarray)
	If (NOT IsArray($avarray)) Then Return SetError(1, 0, "")
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, "")
	Local $iubound = UBound($avarray) - 1, $slastval = $avarray[$iubound]
	If NOT $iubound Then
		$avarray = ""
	Else
		ReDim $avarray[$iubound]
	EndIf
	Return $slastval
EndFunc

Func _arraypush(ByRef $avarray, $vvalue, $idirection = 0)
	If (NOT IsArray($avarray)) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, 0)
	Local $iubound = UBound($avarray) - 1
	If IsArray($vvalue) Then
		Local $iubounds = UBound($vvalue)
		If ($iubounds - 1) > $iubound Then Return SetError(2, 0, 0)
		If $idirection Then
			For $i = $iubound To $iubounds Step -1
				$avarray[$i] = $avarray[$i - $iubounds]
			Next
			For $i = 0 To $iubounds - 1
				$avarray[$i] = $vvalue[$i]
			Next
		Else
			For $i = 0 To $iubound - $iubounds
				$avarray[$i] = $avarray[$i + $iubounds]
			Next
			For $i = 0 To $iubounds - 1
				$avarray[$i + $iubound - $iubounds + 1] = $vvalue[$i]
			Next
		EndIf
	Else
		If $idirection Then
			For $i = $iubound To 1 Step -1
				$avarray[$i] = $avarray[$i - 1]
			Next
			$avarray[0] = $vvalue
		Else
			For $i = 0 To $iubound - 1
				$avarray[$i] = $avarray[$i + 1]
			Next
			$avarray[$iubound] = $vvalue
		EndIf
	EndIf
	Return 1
EndFunc

Func _arrayreverse(ByRef $avarray, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, 0)
	Local $vtmp, $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, 0)
	For $i = $istart To Int(($istart + $iend - 1) / 2)
		$vtmp = $avarray[$i]
		$avarray[$i] = $avarray[$iend]
		$avarray[$iend] = $vtmp
		$iend -= 1
	Next
	Return 1
EndFunc

Func _arraysearch(Const ByRef $avarray, $vvalue, $istart = 0, $iend = 0, $icase = 0, $icompare = 0, $iforward = 1, $isubitem = -1)
	If NOT IsArray($avarray) Then Return SetError(1, 0, -1)
	If UBound($avarray, 0) > 2 OR UBound($avarray, 0) < 1 Then Return SetError(2, 0, -1)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(4, 0, -1)
	Local $istep = 1
	If NOT $iforward Then
		Local $itmp = $istart
		$istart = $iend
		$iend = $itmp
		$istep = -1
	EndIf
	Local $icomptype = False
	If $icompare = 2 Then
		$icompare = 0
		$icomptype = True
	EndIf
	Switch UBound($avarray, 0)
		Case 1
			If NOT $icompare Then
				If NOT $icase Then
					For $i = $istart To $iend Step $istep
						If $icomptype AND VarGetType($avarray[$i]) <> VarGetType($vvalue) Then ContinueLoop
						If $avarray[$i] = $vvalue Then Return $i
					Next
				Else
					For $i = $istart To $iend Step $istep
						If $icomptype AND VarGetType($avarray[$i]) <> VarGetType($vvalue) Then ContinueLoop
						If $avarray[$i] == $vvalue Then Return $i
					Next
				EndIf
			Else
				For $i = $istart To $iend Step $istep
					If StringInStr($avarray[$i], $vvalue, $icase) > 0 Then Return $i
				Next
			EndIf
		Case 2
			Local $iuboundsub = UBound($avarray, 2) - 1
			If $isubitem > $iuboundsub Then $isubitem = $iuboundsub
			If $isubitem < 0 Then
				$isubitem = 0
			Else
				$iuboundsub = $isubitem
			EndIf
			For $j = $isubitem To $iuboundsub
				If NOT $icompare Then
					If NOT $icase Then
						For $i = $istart To $iend Step $istep
							If $icomptype AND VarGetType($avarray[$i][$j]) <> VarGetType($vvalue) Then ContinueLoop
							If $avarray[$i][$j] = $vvalue Then Return $i
						Next
					Else
						For $i = $istart To $iend Step $istep
							If $icomptype AND VarGetType($avarray[$i][$j]) <> VarGetType($vvalue) Then ContinueLoop
							If $avarray[$i][$j] == $vvalue Then Return $i
						Next
					EndIf
				Else
					For $i = $istart To $iend Step $istep
						If StringInStr($avarray[$i][$j], $vvalue, $icase) > 0 Then Return $i
					Next
				EndIf
			Next
		Case Else
			Return SetError(7, 0, -1)
	EndSwitch
	Return SetError(6, 0, -1)
EndFunc

Func _arraysort(ByRef $avarray, $idescending = 0, $istart = 0, $iend = 0, $isubitem = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, 0)
	Switch UBound($avarray, 0)
		Case 1
			__arrayquicksort1d($avarray, $istart, $iend)
			If $idescending Then _arrayreverse($avarray, $istart, $iend)
		Case 2
			Local $isubmax = UBound($avarray, 2) - 1
			If $isubitem > $isubmax Then Return SetError(3, 0, 0)
			If $idescending Then
				$idescending = -1
			Else
				$idescending = 1
			EndIf
			__arrayquicksort2d($avarray, $idescending, $istart, $iend, $isubitem, $isubmax)
		Case Else
			Return SetError(4, 0, 0)
	EndSwitch
	Return 1
EndFunc

Func __arrayquicksort1d(ByRef $avarray, ByRef $istart, ByRef $iend)
	If $iend <= $istart Then Return 
	Local $vtmp
	If ($iend - $istart) < 15 Then
		Local $vcur
		For $i = $istart + 1 To $iend
			$vtmp = $avarray[$i]
			If IsNumber($vtmp) Then
				For $j = $i - 1 To $istart Step -1
					$vcur = $avarray[$j]
					If ($vtmp >= $vcur AND IsNumber($vcur)) OR (NOT IsNumber($vcur) AND StringCompare($vtmp, $vcur) >= 0) Then ExitLoop
					$avarray[$j + 1] = $vcur
				Next
			Else
				For $j = $i - 1 To $istart Step -1
					If (StringCompare($vtmp, $avarray[$j]) >= 0) Then ExitLoop
					$avarray[$j + 1] = $avarray[$j]
				Next
			EndIf
			$avarray[$j + 1] = $vtmp
		Next
		Return 
	EndIf
	Local $l = $istart, $r = $iend, $vpivot = $avarray[Int(($istart + $iend) / 2)], $fnum = IsNumber($vpivot)
	Do
		If $fnum Then
			While ($avarray[$l] < $vpivot AND IsNumber($avarray[$l])) OR (NOT IsNumber($avarray[$l]) AND StringCompare($avarray[$l], $vpivot) < 0)
				$l += 1
			WEnd
			While ($avarray[$r] > $vpivot AND IsNumber($avarray[$r])) OR (NOT IsNumber($avarray[$r]) AND StringCompare($avarray[$r], $vpivot) > 0)
				$r -= 1
			WEnd
		Else
			While (StringCompare($avarray[$l], $vpivot) < 0)
				$l += 1
			WEnd
			While (StringCompare($avarray[$r], $vpivot) > 0)
				$r -= 1
			WEnd
		EndIf
		If $l <= $r Then
			$vtmp = $avarray[$l]
			$avarray[$l] = $avarray[$r]
			$avarray[$r] = $vtmp
			$l += 1
			$r -= 1
		EndIf
	Until $l > $r
	__arrayquicksort1d($avarray, $istart, $r)
	__arrayquicksort1d($avarray, $l, $iend)
EndFunc

Func __arrayquicksort2d(ByRef $avarray, ByRef $istep, ByRef $istart, ByRef $iend, ByRef $isubitem, ByRef $isubmax)
	If $iend <= $istart Then Return 
	Local $vtmp, $l = $istart, $r = $iend, $vpivot = $avarray[Int(($istart + $iend) / 2)][$isubitem], $fnum = IsNumber($vpivot)
	Do
		If $fnum Then
			While ($istep * ($avarray[$l][$isubitem] - $vpivot) < 0 AND IsNumber($avarray[$l][$isubitem])) OR (NOT IsNumber($avarray[$l][$isubitem]) AND $istep * StringCompare($avarray[$l][$isubitem], $vpivot) < 0)
				$l += 1
			WEnd
			While ($istep * ($avarray[$r][$isubitem] - $vpivot) > 0 AND IsNumber($avarray[$r][$isubitem])) OR (NOT IsNumber($avarray[$r][$isubitem]) AND $istep * StringCompare($avarray[$r][$isubitem], $vpivot) > 0)
				$r -= 1
			WEnd
		Else
			While ($istep * StringCompare($avarray[$l][$isubitem], $vpivot) < 0)
				$l += 1
			WEnd
			While ($istep * StringCompare($avarray[$r][$isubitem], $vpivot) > 0)
				$r -= 1
			WEnd
		EndIf
		If $l <= $r Then
			For $i = 0 To $isubmax
				$vtmp = $avarray[$l][$i]
				$avarray[$l][$i] = $avarray[$r][$i]
				$avarray[$r][$i] = $vtmp
			Next
			$l += 1
			$r -= 1
		EndIf
	Until $l > $r
	__arrayquicksort2d($avarray, $istep, $istart, $r, $isubitem, $isubmax)
	__arrayquicksort2d($avarray, $istep, $l, $iend, $isubitem, $isubmax)
EndFunc

Func _arrayswap(ByRef $vitem1, ByRef $vitem2)
	Local $vtmp = $vitem1
	$vitem1 = $vitem2
	$vitem2 = $vtmp
EndFunc

Func _arraytoclip(Const ByRef $avarray, $istart = 0, $iend = 0)
	Local $sresult = _arraytostring($avarray, @CR, $istart, $iend)
	If @error Then Return SetError(@error, 0, 0)
	Return ClipPut($sresult)
EndFunc

Func _arraytostring(Const ByRef $avarray, $sdelim = "|", $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, "")
	If UBound($avarray, 0) <> 1 Then Return SetError(3, 0, "")
	Local $sresult, $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(2, 0, "")
	For $i = $istart To $iend
		$sresult &= $avarray[$i] & $sdelim
	Next
	Return StringTrimRight($sresult, StringLen($sdelim))
EndFunc

Func _arraytrim(ByRef $avarray, $itrimnum, $idirection = 0, $istart = 0, $iend = 0)
	If NOT IsArray($avarray) Then Return SetError(1, 0, 0)
	If UBound($avarray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $iubound = UBound($avarray) - 1
	If $iend < 1 OR $iend > $iubound Then $iend = $iubound
	If $istart < 0 Then $istart = 0
	If $istart > $iend Then Return SetError(5, 0, 0)
	If $idirection Then
		For $i = $istart To $iend
			$avarray[$i] = StringTrimRight($avarray[$i], $itrimnum)
		Next
	Else
		For $i = $istart To $iend
			$avarray[$i] = StringTrimLeft($avarray[$i], $itrimnum)
		Next
	EndIf
	Return 1
EndFunc

Func _arrayunique($aarray, $idimension = 1, $ibase = 0, $icase = 0, $vdelim = "|")
	Local $iubounddim
	If $vdelim = "|" Then $vdelim = Chr(1)
	If NOT IsArray($aarray) Then Return SetError(1, 0, 0)
	If NOT $idimension > 0 Then
		Return SetError(3, 0, 0)
	Else
		$iubounddim = UBound($aarray, 1)
		If @error Then Return SetError(3, 0, 0)
		If $idimension > 1 Then
			Local $aarraytmp[1]
			For $i = 0 To $iubounddim - 1
				_arrayadd($aarraytmp, $aarray[$i][$idimension - 1])
			Next
			_arraydelete($aarraytmp, 0)
		Else
			If UBound($aarray, 0) = 1 Then
				Dim $aarraytmp[1]
				For $i = 0 To $iubounddim - 1
					_arrayadd($aarraytmp, $aarray[$i])
				Next
				_arraydelete($aarraytmp, 0)
			Else
				Dim $aarraytmp[1]
				For $i = 0 To $iubounddim - 1
					_arrayadd($aarraytmp, $aarray[$i][$idimension - 1])
				Next
				_arraydelete($aarraytmp, 0)
			EndIf
		EndIf
	EndIf
	Local $shold
	For $icc = $ibase To UBound($aarraytmp) - 1
		If NOT StringInStr($vdelim & $shold, $vdelim & $aarraytmp[$icc] & $vdelim, $icase) Then $shold &= $aarraytmp[$icc] & $vdelim
	Next
	If $shold Then
		$aarraytmp = StringSplit(StringTrimRight($shold, StringLen($vdelim)), $vdelim, 1)
		Return $aarraytmp
	EndIf
	Return SetError(2, 0, 0)
EndFunc

Func __array_exeterinternal(ByRef $avarray, $istart, $isize, $sdelim, ByRef $aidx, ByRef $aresult, ByRef $icount)
	If $istart == $isize - 1 Then
		For $i = 0 To $isize - 1
			$aresult[$icount] &= $avarray[$aidx[$i]] & $sdelim
		Next
		If $sdelim <> "" Then $aresult[$icount] = StringTrimRight($aresult[$icount], 1)
		$icount += 1
	Else
		Local $itemp
		For $i = $istart To $isize - 1
			$itemp = $aidx[$i]
			$aidx[$i] = $aidx[$istart]
			$aidx[$istart] = $itemp
			__array_exeterinternal($avarray, $istart + 1, $isize, $sdelim, $aidx, $aresult, $icount)
			$aidx[$istart] = $aidx[$i]
			$aidx[$i] = $itemp
		Next
	EndIf
EndFunc

Func __array_combinations($in, $ir)
	Local $i_total = 1
	For $i = $ir To 1 Step -1
		$i_total *= ($in / $i)
		$in -= 1
	Next
	Return Round($i_total)
EndFunc

Func __array_getnext($in, $ir, ByRef $ileft, $itotal, ByRef $aidx)
	If $ileft == $itotal Then
		$ileft -= 1
		Return 
	EndIf
	Local $i = $ir - 1
	While $aidx[$i] == $in - $ir + $i
		$i -= 1
	WEnd
	$aidx[$i] += 1
	For $j = $i + 1 To $ir - 1
		$aidx[$j] = $aidx[$i] + $j - $i
	Next
	$ileft -= 1
EndFunc

Global Const $fc_nooverwrite = 0
Global Const $fc_overwrite = 1
Global Const $ft_modified = 0
Global Const $ft_created = 1
Global Const $ft_accessed = 2
Global Const $fo_read = 0
Global Const $fo_append = 1
Global Const $fo_overwrite = 2
Global Const $fo_binary = 16
Global Const $fo_unicode = 32
Global Const $fo_utf16_le = 32
Global Const $fo_utf16_be = 64
Global Const $fo_utf8 = 128
Global Const $fo_utf8_nobom = 256
Global Const $eof = -1
Global Const $fd_filemustexist = 1
Global Const $fd_pathmustexist = 2
Global Const $fd_multiselect = 4
Global Const $fd_promptcreatenew = 8
Global Const $fd_promptoverwrite = 16
Global Const $create_new = 1
Global Const $create_always = 2
Global Const $open_existing = 3
Global Const $open_always = 4
Global Const $truncate_existing = 5
Global Const $invalid_set_file_pointer = -1
Global Const $file_begin = 0
Global Const $file_current = 1
Global Const $file_end = 2
Global Const $file_attribute_readonly = 1
Global Const $file_attribute_hidden = 2
Global Const $file_attribute_system = 4
Global Const $file_attribute_directory = 16
Global Const $file_attribute_archive = 32
Global Const $file_attribute_device = 64
Global Const $file_attribute_normal = 128
Global Const $file_attribute_temporary = 256
Global Const $file_attribute_sparse_file = 512
Global Const $file_attribute_reparse_point = 1024
Global Const $file_attribute_compressed = 2048
Global Const $file_attribute_offline = 4096
Global Const $file_attribute_not_content_indexed = 8192
Global Const $file_attribute_encrypted = 16384
Global Const $file_share_read = 1
Global Const $file_share_write = 2
Global Const $file_share_delete = 4
Global Const $generic_all = 268435456
Global Const $generic_execute = 536870912
Global Const $generic_write = 1073741824
Global Const $generic_read = -2147483648

Func _filecountlines($sfilepath)
	Local $hfile = FileOpen($sfilepath, $fo_read)
	If $hfile = -1 Then Return SetError(1, 0, 0)
	Local $sfilecontent = StringStripWS(FileRead($hfile), 2)
	FileClose($hfile)
	Local $atmp
	If StringInStr($sfilecontent, @LF) Then
		$atmp = StringSplit(StringStripCR($sfilecontent), @LF)
	ElseIf StringInStr($sfilecontent, @CR) Then
		$atmp = StringSplit($sfilecontent, @CR)
	Else
		If StringLen($sfilecontent) Then
			Return 1
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return $atmp[0]
EndFunc

Func _filecreate($sfilepath)
	Local $hopenfile = FileOpen($sfilepath, $fo_overwrite)
	If $hopenfile = -1 Then Return SetError(1, 0, 0)
	Local $hwritefile = FileWrite($hopenfile, "")
	FileClose($hopenfile)
	If $hwritefile = -1 Then Return SetError(2, 0, 0)
	Return 1
EndFunc

Func _filelisttoarray($spath, $sfilter = "*", $iflag = 0)
	Local $hsearch, $sfile, $sfilelist, $sdelim = "|"
	$spath = StringRegExpReplace($spath, "[\\/]+\z", "") & "\"
	If NOT FileExists($spath) Then Return SetError(1, 1, "")
	If StringRegExp($sfilter, "[\\/:><\|]|(?s)\A\s*\z") Then Return SetError(2, 2, "")
	If NOT ($iflag = 0 OR $iflag = 1 OR $iflag = 2) Then Return SetError(3, 3, "")
	$hsearch = FileFindFirstFile($spath & $sfilter)
	If @error Then Return SetError(4, 4, "")
	While 1
		$sfile = FileFindNextFile($hsearch)
		If @error Then ExitLoop
		If ($iflag + @extended = 2) Then ContinueLoop
		$sfilelist &= $sdelim & $sfile
	WEnd
	FileClose($hsearch)
	If NOT $sfilelist Then Return SetError(4, 4, "")
	Return StringSplit(StringTrimLeft($sfilelist, 1), "|")
EndFunc

Func _fileprint($s_file, $i_show = @SW_HIDE)
	Local $a_ret = DllCall("shell32.dll", "int", "ShellExecuteW", "hwnd", 0, "wstr", "print", "wstr", $s_file, "wstr", "", "wstr", "", "int", $i_show)
	If @error Then Return SetError(@error, @extended, 0)
	If $a_ret[0] <= 32 Then Return SetError(10, $a_ret[0], 0)
	Return 1
EndFunc

Func _filereadtoarray($sfilepath, ByRef $aarray)
	Local $hfile = FileOpen($sfilepath, $fo_read)
	If $hfile = -1 Then Return SetError(1, 0, 0)
	Local $afile = FileRead($hfile, FileGetSize($sfilepath))
	If StringRight($afile, 1) = @LF Then $afile = StringTrimRight($afile, 1)
	If StringRight($afile, 1) = @CR Then $afile = StringTrimRight($afile, 1)
	FileClose($hfile)
	If StringInStr($afile, @LF) Then
		$aarray = StringSplit(StringStripCR($afile), @LF)
	ElseIf StringInStr($afile, @CR) Then
		$aarray = StringSplit($afile, @CR)
	Else
		If StringLen($afile) Then
			Dim $aarray[2] = [1, $afile]
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return 1
EndFunc

Func _filewritefromarray($file, $a_array, $i_base = 0, $i_ubound = 0, $s_delim = "|")
	If NOT IsArray($a_array) Then Return SetError(2, 0, 0)
	Local $idims = UBound($a_array, 0)
	If $idims > 2 Then Return SetError(4, 0, 0)
	Local $last = UBound($a_array) - 1
	If $i_ubound < 1 OR $i_ubound > $last Then $i_ubound = $last
	If $i_base < 0 OR $i_base > $last Then $i_base = 0
	Local $hfile
	If IsString($file) Then
		$hfile = FileOpen($file, $fo_overwrite)
	Else
		$hfile = $file
	EndIf
	If $hfile = -1 Then Return SetError(1, 0, 0)
	Local $errorsav = 0
	Switch $idims
		Case 1
			For $x = $i_base To $i_ubound
				If FileWrite($hfile, $a_array[$x] & @CRLF) = 0 Then
					$errorsav = 3
					ExitLoop
				EndIf
			Next
		Case 2
			Local $s_temp
			For $x = $i_base To $i_ubound
				$s_temp = $a_array[$x][0]
				For $y = 1 To $idims
					$s_temp &= $s_delim & $a_array[$x][$y]
				Next
				If FileWrite($hfile, $s_temp & @CRLF) = 0 Then
					$errorsav = 3
					ExitLoop
				EndIf
			Next
	EndSwitch
	If IsString($file) Then FileClose($hfile)
	If $errorsav Then Return SetError($errorsav, 0, 0)
	Return 1
EndFunc

Func _filewritelog($slogpath, $slogmsg, $iflag = -1)
	Local $hopenfile = $slogpath, $iopenmode = $fo_append
	Local $sdatenow = @YEAR & "-" & @MON & "-" & @MDAY
	Local $stimenow = @HOUR & ":" & @MIN & ":" & @SEC
	Local $smsg = $sdatenow & " " & $stimenow & " : " & $slogmsg
	If $iflag <> -1 Then
		$smsg &= @CRLF & FileRead($slogpath)
		$iopenmode = $fo_overwrite
	EndIf
	If IsString($slogpath) Then
		$hopenfile = FileOpen($slogpath, $iopenmode)
		If $hopenfile = -1 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	Local $ireturn = FileWriteLine($hopenfile, $smsg)
	If IsString($slogpath) Then
		$ireturn = FileClose($hopenfile)
	EndIf
	If $ireturn <= 0 Then
		Return SetError(2, $ireturn, 0)
	EndIf
	Return $ireturn
EndFunc

Func _filewritetoline($sfile, $iline, $stext, $foverwrite = 0)
	If $iline <= 0 Then Return SetError(4, 0, 0)
	If NOT IsString($stext) Then
		$stext = String($stext)
		If $stext = "" Then Return SetError(6, 0, 0)
	EndIf
	If $foverwrite <> 0 AND $foverwrite <> 1 Then Return SetError(5, 0, 0)
	If NOT FileExists($sfile) Then Return SetError(2, 0, 0)
	Local $sread_file = FileRead($sfile)
	Local $asplit_file = StringSplit(StringStripCR($sread_file), @LF)
	If UBound($asplit_file) < $iline Then Return SetError(1, 0, 0)
	Local $iencoding = FileGetEncoding($sfile)
	Local $hfile = FileOpen($sfile, $iencoding + $fo_overwrite)
	If $hfile = -1 Then Return SetError(3, 0, 0)
	$sread_file = ""
	For $i = 1 To $asplit_file[0]
		If $i = $iline Then
			If $foverwrite = 1 Then
				If $stext <> "" Then $sread_file &= $stext & @CRLF
			Else
				$sread_file &= $stext & @CRLF & $asplit_file[$i] & @CRLF
			EndIf
		ElseIf $i < $asplit_file[0] Then
			$sread_file &= $asplit_file[$i] & @CRLF
		ElseIf $i = $asplit_file[0] Then
			$sread_file &= $asplit_file[$i]
		EndIf
	Next
	FileWrite($hfile, $sread_file)
	FileClose($hfile)
	Return 1
EndFunc

Func _pathfull($srelativepath, $sbasepath = @WorkingDir)
	If NOT $srelativepath OR $srelativepath = "." Then Return $sbasepath
	Local $sfullpath = StringReplace($srelativepath, "/", "\")
	Local Const $sfullpathconst = $sfullpath
	Local $spath
	Local $brootonly = StringLeft($sfullpath, 1) = "\" AND StringMid($sfullpath, 2, 1) <> "\"
	For $i = 1 To 2
		$spath = StringLeft($sfullpath, 2)
		If $spath = "\\" Then
			$sfullpath = StringTrimLeft($sfullpath, 2)
			Local $nserverlen = StringInStr($sfullpath, "\") - 1
			$spath = "\\" & StringLeft($sfullpath, $nserverlen)
			$sfullpath = StringTrimLeft($sfullpath, $nserverlen)
			ExitLoop
		ElseIf StringRight($spath, 1) = ":" Then
			$sfullpath = StringTrimLeft($sfullpath, 2)
			ExitLoop
		Else
			$sfullpath = $sbasepath & "\" & $sfullpath
		EndIf
	Next
	If $i = 3 Then Return ""
	If StringLeft($sfullpath, 1) <> "\" Then
		If StringLeft($sfullpathconst, 2) = StringLeft($sbasepath, 2) Then
			$sfullpath = $sbasepath & "\" & $sfullpath
		Else
			$sfullpath = "\" & $sfullpath
		EndIf
	EndIf
	Local $atemp = StringSplit($sfullpath, "\")
	Local $apathparts[$atemp[0]], $j = 0
	For $i = 2 To $atemp[0]
		If $atemp[$i] = ".." Then
			If $j Then $j -= 1
		ElseIf NOT ($atemp[$i] = "" AND $i <> $atemp[0]) AND $atemp[$i] <> "." Then
			$apathparts[$j] = $atemp[$i]
			$j += 1
		EndIf
	Next
	$sfullpath = $spath
	If NOT $brootonly Then
		For $i = 0 To $j - 1
			$sfullpath &= "\" & $apathparts[$i]
		Next
	Else
		$sfullpath &= $sfullpathconst
		If StringInStr($sfullpath, "..") Then $sfullpath = _pathfull($sfullpath)
	EndIf
	While StringInStr($sfullpath, ".\")
		$sfullpath = StringReplace($sfullpath, ".\", "\")
	WEnd
	Return $sfullpath
EndFunc

Func _pathgetrelative($sfrom, $sto)
	If StringRight($sfrom, 1) <> "\" Then $sfrom &= "\"
	If StringRight($sto, 1) <> "\" Then $sto &= "\"
	If $sfrom = $sto Then Return SetError(1, 0, StringTrimRight($sto, 1))
	Local $asfrom = StringSplit($sfrom, "\")
	Local $asto = StringSplit($sto, "\")
	If $asfrom[1] <> $asto[1] Then Return SetError(2, 0, StringTrimRight($sto, 1))
	Local $i = 2
	Local $idiff = 1
	While 1
		If $asfrom[$i] <> $asto[$i] Then
			$idiff = $i
			ExitLoop
		EndIf
		$i += 1
	WEnd
	$i = 1
	Local $srelpath = ""
	For $j = 1 To $asto[0]
		If $i >= $idiff Then
			$srelpath &= "\" & $asto[$i]
		EndIf
		$i += 1
	Next
	$srelpath = StringTrimLeft($srelpath, 1)
	$i = 1
	For $j = 1 To $asfrom[0]
		If $i > $idiff Then
			$srelpath = "..\" & $srelpath
		EndIf
		$i += 1
	Next
	If StringRight($srelpath, 1) == "\" Then $srelpath = StringTrimRight($srelpath, 1)
	Return $srelpath
EndFunc

Func _pathmake($szdrive, $szdir, $szfname, $szext)
	If StringLen($szdrive) Then
		If NOT (StringLeft($szdrive, 2) = "\\") Then $szdrive = StringLeft($szdrive, 1) & ":"
	EndIf
	If StringLen($szdir) Then
		If NOT (StringRight($szdir, 1) = "\") AND NOT (StringRight($szdir, 1) = "/") Then $szdir = $szdir & "\"
	EndIf
	If StringLen($szext) Then
		If NOT (StringLeft($szext, 1) = ".") Then $szext = "." & $szext
	EndIf
	Return $szdrive & $szdir & $szfname & $szext
EndFunc

Func _pathsplit($szpath, ByRef $szdrive, ByRef $szdir, ByRef $szfname, ByRef $szext)
	Local $drive = ""
	Local $dir = ""
	Local $fname = ""
	Local $ext = ""
	Local $pos
	Local $array[5]
	$array[0] = $szpath
	If StringMid($szpath, 2, 1) = ":" Then
		$drive = StringLeft($szpath, 2)
		$szpath = StringTrimLeft($szpath, 2)
	ElseIf StringLeft($szpath, 2) = "\\" Then
		$szpath = StringTrimLeft($szpath, 2)
		$pos = StringInStr($szpath, "\")
		If $pos = 0 Then $pos = StringInStr($szpath, "/")
		If $pos = 0 Then
			$drive = "\\" & $szpath
			$szpath = ""
		Else
			$drive = "\\" & StringLeft($szpath, $pos - 1)
			$szpath = StringTrimLeft($szpath, $pos - 1)
		EndIf
	EndIf
	Local $nposforward = StringInStr($szpath, "/", 0, -1)
	Local $nposbackward = StringInStr($szpath, "\", 0, -1)
	If $nposforward >= $nposbackward Then
		$pos = $nposforward
	Else
		$pos = $nposbackward
	EndIf
	$dir = StringLeft($szpath, $pos)
	$fname = StringRight($szpath, StringLen($szpath) - $pos)
	If StringLen($dir) = 0 Then $fname = $szpath
	$pos = StringInStr($fname, ".", 0, -1)
	If $pos Then
		$ext = StringRight($fname, StringLen($fname) - ($pos - 1))
		$fname = StringLeft($fname, $pos - 1)
	EndIf
	$szdrive = $drive
	$szdir = $dir
	$szfname = $fname
	$szext = $ext
	$array[1] = $drive
	$array[2] = $dir
	$array[3] = $fname
	$array[4] = $ext
	Return $array
EndFunc

Func _replacestringinfile($szfilename, $szsearchstring, $szreplacestring, $fcaseness = 0, $foccurance = 1)
	Local $iretval = 0
	Local $ncount, $sendswith
	If StringInStr(FileGetAttrib($szfilename), "R") Then Return SetError(6, 0, -1)
	Local $hfile = FileOpen($szfilename, $fo_read)
	If $hfile = -1 Then Return SetError(1, 0, -1)
	Local $s_totfile = FileRead($hfile, FileGetSize($szfilename))
	If StringRight($s_totfile, 2) = @CRLF Then
		$sendswith = @CRLF
	ElseIf StringRight($s_totfile, 1) = @CR Then
		$sendswith = @CR
	ElseIf StringRight($s_totfile, 1) = @LF Then
		$sendswith = @LF
	Else
		$sendswith = ""
	EndIf
	Local $afilelines = StringSplit(StringStripCR($s_totfile), @LF)
	FileClose($hfile)
	Local $iencoding = FileGetEncoding($szfilename)
	Local $hwritehandle = FileOpen($szfilename, $iencoding + $fo_overwrite)
	If $hwritehandle = -1 Then Return SetError(2, 0, -1)
	For $ncount = 1 To $afilelines[0]
		If StringInStr($afilelines[$ncount], $szsearchstring, $fcaseness) Then
			$afilelines[$ncount] = StringReplace($afilelines[$ncount], $szsearchstring, $szreplacestring, 1 - $foccurance, $fcaseness)
			$iretval = $iretval + 1
			If $foccurance = 0 Then
				$iretval = 1
				ExitLoop
			EndIf
		EndIf
	Next
	For $ncount = 1 To $afilelines[0] - 1
		If FileWriteLine($hwritehandle, $afilelines[$ncount]) = 0 Then
			FileClose($hwritehandle)
			Return SetError(3, 0, -1)
		EndIf
	Next
	If $afilelines[$ncount] <> "" Then FileWrite($hwritehandle, $afilelines[$ncount] & $sendswith)
	FileClose($hwritehandle)
	Return $iretval
EndFunc

Func _tempfile($s_directoryname = @TempDir, $s_fileprefix = "~", $s_fileextension = ".tmp", $i_randomlength = 7)
	If IsKeyword($s_fileprefix) Then $s_fileprefix = "~"
	If IsKeyword($s_fileextension) Then $s_fileextension = ".tmp"
	If IsKeyword($i_randomlength) Then $i_randomlength = 7
	If NOT FileExists($s_directoryname) Then $s_directoryname = @TempDir
	If NOT FileExists($s_directoryname) Then $s_directoryname = @ScriptDir
	If StringRight($s_directoryname, 1) <> "\" Then $s_directoryname = $s_directoryname & "\"
	Local $s_tempname
	Do
		$s_tempname = ""
		While StringLen($s_tempname) < $i_randomlength
			$s_tempname = $s_tempname & Chr(Random(97, 122, 1))
		WEnd
		$s_tempname = $s_directoryname & $s_fileprefix & $s_tempname & $s_fileextension
	Until NOT FileExists($s_tempname)
	Return $s_tempname
EndFunc

Global Const $gui_event_close = -3
Global Const $gui_event_minimize = -4
Global Const $gui_event_restore = -5
Global Const $gui_event_maximize = -6
Global Const $gui_event_primarydown = -7
Global Const $gui_event_primaryup = -8
Global Const $gui_event_secondarydown = -9
Global Const $gui_event_secondaryup = -10
Global Const $gui_event_mousemove = -11
Global Const $gui_event_resized = -12
Global Const $gui_event_dropped = -13
Global Const $gui_rundefmsg = "GUI_RUNDEFMSG"
Global Const $gui_avistop = 0
Global Const $gui_avistart = 1
Global Const $gui_aviclose = 2
Global Const $gui_checked = 1
Global Const $gui_indeterminate = 2
Global Const $gui_unchecked = 4
Global Const $gui_dropaccepted = 8
Global Const $gui_nodropaccepted = 4096
Global Const $gui_acceptfiles = $gui_dropaccepted
Global Const $gui_show = 16
Global Const $gui_hide = 32
Global Const $gui_enable = 64
Global Const $gui_disable = 128
Global Const $gui_focus = 256
Global Const $gui_nofocus = 8192
Global Const $gui_defbutton = 512
Global Const $gui_expand = 1024
Global Const $gui_ontop = 2048
Global Const $gui_fontitalic = 2
Global Const $gui_fontunder = 4
Global Const $gui_fontstrike = 8
Global Const $gui_dockauto = 1
Global Const $gui_dockleft = 2
Global Const $gui_dockright = 4
Global Const $gui_dockhcenter = 8
Global Const $gui_docktop = 32
Global Const $gui_dockbottom = 64
Global Const $gui_dockvcenter = 128
Global Const $gui_dockwidth = 256
Global Const $gui_dockheight = 512
Global Const $gui_docksize = 768
Global Const $gui_dockmenubar = 544
Global Const $gui_dockstatebar = 576
Global Const $gui_dockall = 802
Global Const $gui_dockborders = 102
Global Const $gui_gr_close = 1
Global Const $gui_gr_line = 2
Global Const $gui_gr_bezier = 4
Global Const $gui_gr_move = 6
Global Const $gui_gr_color = 8
Global Const $gui_gr_rect = 10
Global Const $gui_gr_ellipse = 12
Global Const $gui_gr_pie = 14
Global Const $gui_gr_dot = 16
Global Const $gui_gr_pixel = 18
Global Const $gui_gr_hint = 20
Global Const $gui_gr_refresh = 22
Global Const $gui_gr_pensize = 24
Global Const $gui_gr_nobkcolor = -2
Global Const $gui_bkcolor_default = -1
Global Const $gui_bkcolor_transparent = -2
Global Const $gui_bkcolor_lv_alternate = -33554432
Global Const $gui_ws_ex_parentdrag = 1048576
Global Const $ss_left = 0
Global Const $ss_center = 1
Global Const $ss_right = 2
Global Const $ss_icon = 3
Global Const $ss_blackrect = 4
Global Const $ss_grayrect = 5
Global Const $ss_whiterect = 6
Global Const $ss_blackframe = 7
Global Const $ss_grayframe = 8
Global Const $ss_whiteframe = 9
Global Const $ss_simple = 11
Global Const $ss_leftnowordwrap = 12
Global Const $ss_bitmap = 14
Global Const $ss_etchedhorz = 16
Global Const $ss_etchedvert = 17
Global Const $ss_etchedframe = 18
Global Const $ss_noprefix = 128
Global Const $ss_notify = 256
Global Const $ss_centerimage = 512
Global Const $ss_rightjust = 1024
Global Const $ss_sunken = 4096
Global Const $gui_ss_default_label = 0
Global Const $gui_ss_default_graphic = 0
Global Const $gui_ss_default_icon = $ss_notify
Global Const $gui_ss_default_pic = $ss_notify
Global Const $cb_err = -1
Global Const $cb_errattribute = -3
Global Const $cb_errrequired = -4
Global Const $cb_errspace = -2
Global Const $cb_okay = 0
Global Const $state_system_invisible = 32768
Global Const $state_system_pressed = 8
Global Const $cbs_autohscroll = 64
Global Const $cbs_disablenoscroll = 2048
Global Const $cbs_dropdown = 2
Global Const $cbs_dropdownlist = 3
Global Const $cbs_hasstrings = 512
Global Const $cbs_lowercase = 16384
Global Const $cbs_nointegralheight = 1024
Global Const $cbs_oemconvert = 128
Global Const $cbs_ownerdrawfixed = 16
Global Const $cbs_ownerdrawvariable = 32
Global Const $cbs_simple = 1
Global Const $cbs_sort = 256
Global Const $cbs_uppercase = 8192
Global Const $cbm_first = 5888
Global Const $cb_addstring = 323
Global Const $cb_deletestring = 324
Global Const $cb_dir = 325
Global Const $cb_findstring = 332
Global Const $cb_findstringexact = 344
Global Const $cb_getcomboboxinfo = 356
Global Const $cb_getcount = 326
Global Const $cb_getcuebanner = ($cbm_first + 4)
Global Const $cb_getcursel = 327
Global Const $cb_getdroppedcontrolrect = 338
Global Const $cb_getdroppedstate = 343
Global Const $cb_getdroppedwidth = 351
Global Const $cb_geteditsel = 320
Global Const $cb_getextendedui = 342
Global Const $cb_gethorizontalextent = 349
Global Const $cb_getitemdata = 336
Global Const $cb_getitemheight = 340
Global Const $cb_getlbtext = 328
Global Const $cb_getlbtextlen = 329
Global Const $cb_getlocale = 346
Global Const $cb_getminvisible = 5890
Global Const $cb_gettopindex = 347
Global Const $cb_initstorage = 353
Global Const $cb_limittext = 321
Global Const $cb_resetcontent = 331
Global Const $cb_insertstring = 330
Global Const $cb_selectstring = 333
Global Const $cb_setcuebanner = ($cbm_first + 3)
Global Const $cb_setcursel = 334
Global Const $cb_setdroppedwidth = 352
Global Const $cb_seteditsel = 322
Global Const $cb_setextendedui = 341
Global Const $cb_sethorizontalextent = 350
Global Const $cb_setitemdata = 337
Global Const $cb_setitemheight = 339
Global Const $cb_setlocale = 345
Global Const $cb_setminvisible = 5889
Global Const $cb_settopindex = 348
Global Const $cb_showdropdown = 335
Global Const $cbn_closeup = 8
Global Const $cbn_dblclk = 2
Global Const $cbn_dropdown = 7
Global Const $cbn_editchange = 5
Global Const $cbn_editupdate = 6
Global Const $cbn_errspace = (-1)
Global Const $cbn_killfocus = 4
Global Const $cbn_selchange = 1
Global Const $cbn_selendcancel = 10
Global Const $cbn_selendok = 9
Global Const $cbn_setfocus = 3
Global Const $cbes_ex_casesensitive = 16
Global Const $cbes_ex_noeditimage = 1
Global Const $cbes_ex_noeditimageindent = 2
Global Const $cbes_ex_nosizelimit = 8
Global Const $__comboboxconstant_wm_user = 1024
Global Const $cbem_deleteitem = $cb_deletestring
Global Const $cbem_getcombocontrol = ($__comboboxconstant_wm_user + 6)
Global Const $cbem_geteditcontrol = ($__comboboxconstant_wm_user + 7)
Global Const $cbem_getexstyle = ($__comboboxconstant_wm_user + 9)
Global Const $cbem_getextendedstyle = ($__comboboxconstant_wm_user + 9)
Global Const $cbem_getimagelist = ($__comboboxconstant_wm_user + 3)
Global Const $cbem_getitema = ($__comboboxconstant_wm_user + 4)
Global Const $cbem_getitemw = ($__comboboxconstant_wm_user + 13)
Global Const $cbem_getunicodeformat = 8192 + 6
Global Const $cbem_haseditchanged = ($__comboboxconstant_wm_user + 10)
Global Const $cbem_insertitema = ($__comboboxconstant_wm_user + 1)
Global Const $cbem_insertitemw = ($__comboboxconstant_wm_user + 11)
Global Const $cbem_setexstyle = ($__comboboxconstant_wm_user + 8)
Global Const $cbem_setextendedstyle = ($__comboboxconstant_wm_user + 14)
Global Const $cbem_setimagelist = ($__comboboxconstant_wm_user + 2)
Global Const $cbem_setitema = ($__comboboxconstant_wm_user + 5)
Global Const $cbem_setitemw = ($__comboboxconstant_wm_user + 12)
Global Const $cbem_setunicodeformat = 8192 + 5
Global Const $cbem_setwindowtheme = 8192 + 11
Global Const $cben_first = (-800)
Global Const $cben_last = (-830)
Global Const $cben_beginedit = ($cben_first - 4)
Global Const $cben_deleteitem = ($cben_first - 2)
Global Const $cben_dragbegina = ($cben_first - 8)
Global Const $cben_dragbeginw = ($cben_first - 9)
Global Const $cben_endedita = ($cben_first - 5)
Global Const $cben_endeditw = ($cben_first - 6)
Global Const $cben_getdispinfo = ($cben_first + 0)
Global Const $cben_getdispinfoa = ($cben_first + 0)
Global Const $cben_getdispinfow = ($cben_first - 7)
Global Const $cben_insertitem = ($cben_first - 1)
Global Const $cbeif_di_setitem = 268435456
Global Const $cbeif_image = 2
Global Const $cbeif_indent = 16
Global Const $cbeif_lparam = 32
Global Const $cbeif_overlay = 8
Global Const $cbeif_selectedimage = 4
Global Const $cbeif_text = 1
Global Const $__comboboxconstant_ws_vscroll = 2097152
Global Const $gui_ss_default_combo = BitOR($cbs_dropdown, $cbs_autohscroll, $__comboboxconstant_ws_vscroll)
Global Const $ws_tiled = 0
Global Const $ws_overlapped = 0
Global Const $ws_maximizebox = 65536
Global Const $ws_minimizebox = 131072
Global Const $ws_tabstop = 65536
Global Const $ws_group = 131072
Global Const $ws_sizebox = 262144
Global Const $ws_thickframe = 262144
Global Const $ws_sysmenu = 524288
Global Const $ws_hscroll = 1048576
Global Const $ws_vscroll = 2097152
Global Const $ws_dlgframe = 4194304
Global Const $ws_border = 8388608
Global Const $ws_caption = 12582912
Global Const $ws_overlappedwindow = 13565952
Global Const $ws_tiledwindow = 13565952
Global Const $ws_maximize = 16777216
Global Const $ws_clipchildren = 33554432
Global Const $ws_clipsiblings = 67108864
Global Const $ws_disabled = 134217728
Global Const $ws_visible = 268435456
Global Const $ws_minimize = 536870912
Global Const $ws_child = 1073741824
Global Const $ws_popup = -2147483648
Global Const $ws_popupwindow = -2138570752
Global Const $ds_modalframe = 128
Global Const $ds_setforeground = 512
Global Const $ds_contexthelp = 8192
Global Const $ws_ex_acceptfiles = 16
Global Const $ws_ex_mdichild = 64
Global Const $ws_ex_appwindow = 262144
Global Const $ws_ex_composited = 33554432
Global Const $ws_ex_clientedge = 512
Global Const $ws_ex_contexthelp = 1024
Global Const $ws_ex_dlgmodalframe = 1
Global Const $ws_ex_leftscrollbar = 16384
Global Const $ws_ex_overlappedwindow = 768
Global Const $ws_ex_right = 4096
Global Const $ws_ex_staticedge = 131072
Global Const $ws_ex_toolwindow = 128
Global Const $ws_ex_topmost = 8
Global Const $ws_ex_transparent = 32
Global Const $ws_ex_windowedge = 256
Global Const $ws_ex_layered = 524288
Global Const $ws_ex_controlparent = 65536
Global Const $ws_ex_layoutrtl = 4194304
Global Const $ws_ex_rtlreading = 8192
Global Const $wm_gettextlength = 14
Global Const $wm_gettext = 13
Global Const $wm_size = 5
Global Const $wm_sizing = 532
Global Const $wm_user = 1024
Global Const $wm_create = 1
Global Const $wm_destroy = 2
Global Const $wm_move = 3
Global Const $wm_activate = 6
Global Const $wm_setfocus = 7
Global Const $wm_killfocus = 8
Global Const $wm_enable = 10
Global Const $wm_setredraw = 11
Global Const $wm_settext = 12
Global Const $wm_paint = 15
Global Const $wm_close = 16
Global Const $wm_queryendsession = 17
Global Const $wm_quit = 18
Global Const $wm_erasebkgnd = 20
Global Const $wm_queryopen = 19
Global Const $wm_syscolorchange = 21
Global Const $wm_endsession = 22
Global Const $wm_showwindow = 24
Global Const $wm_settingchange = 26
Global Const $wm_wininichange = 26
Global Const $wm_devmodechange = 27
Global Const $wm_activateapp = 28
Global Const $wm_fontchange = 29
Global Const $wm_timechange = 30
Global Const $wm_cancelmode = 31
Global Const $wm_ime_startcomposition = 269
Global Const $wm_ime_endcomposition = 270
Global Const $wm_ime_composition = 271
Global Const $wm_ime_keylast = 271
Global Const $wm_setcursor = 32
Global Const $wm_mouseactivate = 33
Global Const $wm_childactivate = 34
Global Const $wm_queuesync = 35
Global Const $wm_getminmaxinfo = 36
Global Const $wm_painticon = 38
Global Const $wm_iconerasebkgnd = 39
Global Const $wm_nextdlgctl = 40
Global Const $wm_spoolerstatus = 42
Global Const $wm_drawitem = 43
Global Const $wm_measureitem = 44
Global Const $wm_deleteitem = 45
Global Const $wm_vkeytoitem = 46
Global Const $wm_chartoitem = 47
Global Const $wm_setfont = 48
Global Const $wm_getfont = 49
Global Const $wm_sethotkey = 50
Global Const $wm_gethotkey = 51
Global Const $wm_querydragicon = 55
Global Const $wm_compareitem = 57
Global Const $wm_getobject = 61
Global Const $wm_compacting = 65
Global Const $wm_commnotify = 68
Global Const $wm_windowposchanging = 70
Global Const $wm_windowposchanged = 71
Global Const $wm_power = 72
Global Const $wm_notify = 78
Global Const $wm_copydata = 74
Global Const $wm_canceljournal = 75
Global Const $wm_inputlangchangerequest = 80
Global Const $wm_inputlangchange = 81
Global Const $wm_tcard = 82
Global Const $wm_help = 83
Global Const $wm_userchanged = 84
Global Const $wm_notifyformat = 85
Global Const $wm_parentnotify = 528
Global Const $wm_entermenuloop = 529
Global Const $wm_exitmenuloop = 530
Global Const $wm_nextmenu = 531
Global Const $wm_capturechanged = 533
Global Const $wm_moving = 534
Global Const $wm_powerbroadcast = 536
Global Const $wm_devicechange = 537
Global Const $wm_mdicreate = 544
Global Const $wm_mdidestroy = 545
Global Const $wm_mdiactivate = 546
Global Const $wm_mdirestore = 547
Global Const $wm_mdinext = 548
Global Const $wm_mdimaximize = 549
Global Const $wm_mditile = 550
Global Const $wm_mdicascade = 551
Global Const $wm_mdiiconarrange = 552
Global Const $wm_mdigetactive = 553
Global Const $wm_mdisetmenu = 560
Global Const $wm_entersizemove = 561
Global Const $wm_exitsizemove = 562
Global Const $wm_dropfiles = 563
Global Const $wm_mdirefreshmenu = 564
Global Const $wm_ime_setcontext = 641
Global Const $wm_ime_notify = 642
Global Const $wm_ime_control = 643
Global Const $wm_ime_compositionfull = 644
Global Const $wm_ime_select = 645
Global Const $wm_ime_char = 646
Global Const $wm_ime_request = 648
Global Const $wm_ime_keydown = 656
Global Const $wm_ime_keyup = 657
Global Const $wm_ncmousehover = 672
Global Const $wm_mousehover = 673
Global Const $wm_ncmouseleave = 674
Global Const $wm_mouseleave = 675
Global Const $wm_wtssession_change = 689
Global Const $wm_tablet_first = 704
Global Const $wm_tablet_last = 735
Global Const $wm_cut = 768
Global Const $wm_copy = 769
Global Const $wm_paste = 770
Global Const $wm_clear = 771
Global Const $wm_undo = 772
Global Const $wm_paletteischanging = 784
Global Const $wm_hotkey = 786
Global Const $wm_palettechanged = 785
Global Const $wm_print = 791
Global Const $wm_printclient = 792
Global Const $wm_appcommand = 793
Global Const $wm_querynewpalette = 783
Global Const $wm_themechanged = 794
Global Const $wm_handheldfirst = 856
Global Const $wm_handheldlast = 863
Global Const $wm_afxfirst = 864
Global Const $wm_afxlast = 895
Global Const $wm_penwinfirst = 896
Global Const $wm_penwinlast = 911
Global Const $wm_contextmenu = 123
Global Const $wm_stylechanging = 124
Global Const $wm_stylechanged = 125
Global Const $wm_displaychange = 126
Global Const $wm_geticon = 127
Global Const $wm_seticon = 128
Global Const $wm_nccreate = 129
Global Const $wm_ncdestroy = 130
Global Const $wm_nccalcsize = 131
Global Const $wm_nchittest = 132
Global Const $wm_ncpaint = 133
Global Const $wm_ncactivate = 134
Global Const $wm_getdlgcode = 135
Global Const $wm_syncpaint = 136
Global Const $wm_ncmousemove = 160
Global Const $wm_nclbuttondown = 161
Global Const $wm_nclbuttonup = 162
Global Const $wm_nclbuttondblclk = 163
Global Const $wm_ncrbuttondown = 164
Global Const $wm_ncrbuttonup = 165
Global Const $wm_ncrbuttondblclk = 166
Global Const $wm_ncmbuttondown = 167
Global Const $wm_ncmbuttonup = 168
Global Const $wm_ncmbuttondblclk = 169
Global Const $wm_ncxbuttondown = 171
Global Const $wm_ncxbuttonup = 172
Global Const $wm_ncxbuttondblclk = 173
Global Const $wm_keydown = 256
Global Const $wm_keyfirst = 256
Global Const $wm_keyup = 257
Global Const $wm_char = 258
Global Const $wm_deadchar = 259
Global Const $wm_syskeydown = 260
Global Const $wm_syskeyup = 261
Global Const $wm_syschar = 262
Global Const $wm_sysdeadchar = 263
Global Const $wm_keylast = 265
Global Const $wm_unichar = 265
Global Const $wm_initdialog = 272
Global Const $wm_command = 273
Global Const $wm_syscommand = 274
Global Const $wm_timer = 275
Global Const $wm_hscroll = 276
Global Const $wm_vscroll = 277
Global Const $wm_initmenu = 278
Global Const $wm_initmenupopup = 279
Global Const $wm_menuselect = 287
Global Const $wm_menuchar = 288
Global Const $wm_enteridle = 289
Global Const $wm_menurbuttonup = 290
Global Const $wm_menudrag = 291
Global Const $wm_menugetobject = 292
Global Const $wm_uninitmenupopup = 293
Global Const $wm_menucommand = 294
Global Const $wm_changeuistate = 295
Global Const $wm_updateuistate = 296
Global Const $wm_queryuistate = 297
Global Const $wm_ctlcolormsgbox = 306
Global Const $wm_ctlcoloredit = 307
Global Const $wm_ctlcolorlistbox = 308
Global Const $wm_ctlcolorbtn = 309
Global Const $wm_ctlcolordlg = 310
Global Const $wm_ctlcolorscrollbar = 311
Global Const $wm_ctlcolorstatic = 312
Global Const $wm_ctlcolor = 25
Global Const $mn_gethmenu = 481
Global Const $wm_app = 32768
Global Const $nm_first = 0
Global Const $nm_outofmemory = $nm_first - 1
Global Const $nm_click = $nm_first - 2
Global Const $nm_dblclk = $nm_first - 3
Global Const $nm_return = $nm_first - 4
Global Const $nm_rclick = $nm_first - 5
Global Const $nm_rdblclk = $nm_first - 6
Global Const $nm_setfocus = $nm_first - 7
Global Const $nm_killfocus = $nm_first - 8
Global Const $nm_customdraw = $nm_first - 12
Global Const $nm_hover = $nm_first - 13
Global Const $nm_nchittest = $nm_first - 14
Global Const $nm_keydown = $nm_first - 15
Global Const $nm_releasedcapture = $nm_first - 16
Global Const $nm_setcursor = $nm_first - 17
Global Const $nm_char = $nm_first - 18
Global Const $nm_tooltipscreated = $nm_first - 19
Global Const $nm_ldown = $nm_first - 20
Global Const $nm_rdown = $nm_first - 21
Global Const $nm_themechanged = $nm_first - 22
Global Const $wm_mousefirst = 512
Global Const $wm_mousemove = 512
Global Const $wm_lbuttondown = 513
Global Const $wm_lbuttonup = 514
Global Const $wm_lbuttondblclk = 515
Global Const $wm_rbuttondown = 516
Global Const $wm_rbuttonup = 517
Global Const $wm_rbuttondblclk = 518
Global Const $wm_mbuttondown = 519
Global Const $wm_mbuttonup = 520
Global Const $wm_mbuttondblclk = 521
Global Const $wm_mousewheel = 522
Global Const $wm_xbuttondown = 523
Global Const $wm_xbuttonup = 524
Global Const $wm_xbuttondblclk = 525
Global Const $wm_mousehwheel = 526
Global Const $ps_solid = 0
Global Const $ps_dash = 1
Global Const $ps_dot = 2
Global Const $ps_dashdot = 3
Global Const $ps_dashdotdot = 4
Global Const $ps_null = 5
Global Const $ps_insideframe = 6
Global Const $lwa_alpha = 2
Global Const $lwa_colorkey = 1
Global Const $rgn_and = 1
Global Const $rgn_or = 2
Global Const $rgn_xor = 3
Global Const $rgn_diff = 4
Global Const $rgn_copy = 5
Global Const $errorregion = 0
Global Const $nullregion = 1
Global Const $simpleregion = 2
Global Const $complexregion = 3
Global Const $transparent = 1
Global Const $opaque = 2
Global Const $ccm_first = 8192
Global Const $ccm_getunicodeformat = ($ccm_first + 6)
Global Const $ccm_setunicodeformat = ($ccm_first + 5)
Global Const $ccm_setbkcolor = $ccm_first + 1
Global Const $ccm_setcolorscheme = $ccm_first + 2
Global Const $ccm_getcolorscheme = $ccm_first + 3
Global Const $ccm_getdroptarget = $ccm_first + 4
Global Const $ccm_setwindowtheme = $ccm_first + 11
Global Const $ga_parent = 1
Global Const $ga_root = 2
Global Const $ga_rootowner = 3
Global Const $sm_cxscreen = 0
Global Const $sm_cyscreen = 1
Global Const $sm_cxvscroll = 2
Global Const $sm_cyhscroll = 3
Global Const $sm_cycaption = 4
Global Const $sm_cxborder = 5
Global Const $sm_cyborder = 6
Global Const $sm_cxdlgframe = 7
Global Const $sm_cydlgframe = 8
Global Const $sm_cyvthumb = 9
Global Const $sm_cxhthumb = 10
Global Const $sm_cxicon = 11
Global Const $sm_cyicon = 12
Global Const $sm_cxcursor = 13
Global Const $sm_cycursor = 14
Global Const $sm_cymenu = 15
Global Const $sm_cxfullscreen = 16
Global Const $sm_cyfullscreen = 17
Global Const $sm_cykanjiwindow = 18
Global Const $sm_mousepresent = 19
Global Const $sm_cyvscroll = 20
Global Const $sm_cxhscroll = 21
Global Const $sm_debug = 22
Global Const $sm_swapbutton = 23
Global Const $sm_reserved1 = 24
Global Const $sm_reserved2 = 25
Global Const $sm_reserved3 = 26
Global Const $sm_reserved4 = 27
Global Const $sm_cxmin = 28
Global Const $sm_cymin = 29
Global Const $sm_cxsize = 30
Global Const $sm_cysize = 31
Global Const $sm_cxframe = 32
Global Const $sm_cyframe = 33
Global Const $sm_cxmintrack = 34
Global Const $sm_cymintrack = 35
Global Const $sm_cxdoubleclk = 36
Global Const $sm_cydoubleclk = 37
Global Const $sm_cxiconspacing = 38
Global Const $sm_cyiconspacing = 39
Global Const $sm_menudropalignment = 40
Global Const $sm_penwindows = 41
Global Const $sm_dbcsenabled = 42
Global Const $sm_cmousebuttons = 43
Global Const $sm_secure = 44
Global Const $sm_cxedge = 45
Global Const $sm_cyedge = 46
Global Const $sm_cxminspacing = 47
Global Const $sm_cyminspacing = 48
Global Const $sm_cxsmicon = 49
Global Const $sm_cysmicon = 50
Global Const $sm_cysmcaption = 51
Global Const $sm_cxsmsize = 52
Global Const $sm_cysmsize = 53
Global Const $sm_cxmenusize = 54
Global Const $sm_cymenusize = 55
Global Const $sm_arrange = 56
Global Const $sm_cxminimized = 57
Global Const $sm_cyminimized = 58
Global Const $sm_cxmaxtrack = 59
Global Const $sm_cymaxtrack = 60
Global Const $sm_cxmaximized = 61
Global Const $sm_cymaximized = 62
Global Const $sm_network = 63
Global Const $sm_cleanboot = 67
Global Const $sm_cxdrag = 68
Global Const $sm_cydrag = 69
Global Const $sm_showsounds = 70
Global Const $sm_cxmenucheck = 71
Global Const $sm_cymenucheck = 72
Global Const $sm_slowmachine = 73
Global Const $sm_mideastenabled = 74
Global Const $sm_mousewheelpresent = 75
Global Const $sm_xvirtualscreen = 76
Global Const $sm_yvirtualscreen = 77
Global Const $sm_cxvirtualscreen = 78
Global Const $sm_cyvirtualscreen = 79
Global Const $sm_cmonitors = 80
Global Const $sm_samedisplayformat = 81
Global Const $sm_immenabled = 82
Global Const $sm_cxfocusborder = 83
Global Const $sm_cyfocusborder = 84
Global Const $sm_tabletpc = 86
Global Const $sm_mediacenter = 87
Global Const $sm_starter = 88
Global Const $sm_serverr2 = 89
Global Const $sm_cmetrics = 90
Global Const $sm_remotesession = 4096
Global Const $sm_shuttingdown = 8192
Global Const $sm_remotecontrol = 8193
Global Const $sm_caretblinkingenabled = 8194
Global Const $blackness = 66
Global Const $captureblt = 1073741824
Global Const $dstinvert = 5570569
Global Const $mergecopy = 12583114
Global Const $mergepaint = 12255782
Global Const $nomirrorbitmap = -2147483648
Global Const $notsrccopy = 3342344
Global Const $notsrcerase = 1114278
Global Const $patcopy = 15728673
Global Const $patinvert = 5898313
Global Const $patpaint = 16452105
Global Const $srcand = 8913094
Global Const $srccopy = 13369376
Global Const $srcerase = 4457256
Global Const $srcinvert = 6684742
Global Const $srcpaint = 15597702
Global Const $whiteness = 16711778
Global Const $dt_bottom = 8
Global Const $dt_calcrect = 1024
Global Const $dt_center = 1
Global Const $dt_editcontrol = 8192
Global Const $dt_end_ellipsis = 32768
Global Const $dt_expandtabs = 64
Global Const $dt_externalleading = 512
Global Const $dt_hideprefix = 1048576
Global Const $dt_internal = 4096
Global Const $dt_left = 0
Global Const $dt_modifystring = 65536
Global Const $dt_noclip = 256
Global Const $dt_nofullwidthcharbreak = 524288
Global Const $dt_noprefix = 2048
Global Const $dt_path_ellipsis = 16384
Global Const $dt_prefixonly = 2097152
Global Const $dt_right = 2
Global Const $dt_rtlreading = 131072
Global Const $dt_singleline = 32
Global Const $dt_tabstop = 128
Global Const $dt_top = 0
Global Const $dt_vcenter = 4
Global Const $dt_wordbreak = 16
Global Const $dt_word_ellipsis = 262144
Global Const $rdw_erase = 4
Global Const $rdw_frame = 1024
Global Const $rdw_internalpaint = 2
Global Const $rdw_invalidate = 1
Global Const $rdw_noerase = 32
Global Const $rdw_noframe = 2048
Global Const $rdw_nointernalpaint = 16
Global Const $rdw_validate = 8
Global Const $rdw_erasenow = 512
Global Const $rdw_updatenow = 256
Global Const $rdw_allchildren = 128
Global Const $rdw_nochildren = 64
Global Const $wm_renderformat = 773
Global Const $wm_renderallformats = 774
Global Const $wm_destroyclipboard = 775
Global Const $wm_drawclipboard = 776
Global Const $wm_paintclipboard = 777
Global Const $wm_vscrollclipboard = 778
Global Const $wm_sizeclipboard = 779
Global Const $wm_askcbformatname = 780
Global Const $wm_changecbchain = 781
Global Const $wm_hscrollclipboard = 782
Global Const $hterror = -2
Global Const $httransparent = -1
Global Const $htnowhere = 0
Global Const $htclient = 1
Global Const $htcaption = 2
Global Const $htsysmenu = 3
Global Const $htgrowbox = 4
Global Const $htsize = $htgrowbox
Global Const $htmenu = 5
Global Const $hthscroll = 6
Global Const $htvscroll = 7
Global Const $htminbutton = 8
Global Const $htmaxbutton = 9
Global Const $htleft = 10
Global Const $htright = 11
Global Const $httop = 12
Global Const $httopleft = 13
Global Const $httopright = 14
Global Const $htbottom = 15
Global Const $htbottomleft = 16
Global Const $htbottomright = 17
Global Const $htborder = 18
Global Const $htreduce = $htminbutton
Global Const $htzoom = $htmaxbutton
Global Const $htsizefirst = $htleft
Global Const $htsizelast = $htbottomright
Global Const $htobject = 19
Global Const $htclose = 20
Global Const $hthelp = 21
Global Const $color_scrollbar = 0
Global Const $color_background = 1
Global Const $color_activecaption = 2
Global Const $color_inactivecaption = 3
Global Const $color_menu = 4
Global Const $color_window = 5
Global Const $color_windowframe = 6
Global Const $color_menutext = 7
Global Const $color_windowtext = 8
Global Const $color_captiontext = 9
Global Const $color_activeborder = 10
Global Const $color_inactiveborder = 11
Global Const $color_appworkspace = 12
Global Const $color_highlight = 13
Global Const $color_highlighttext = 14
Global Const $color_btnface = 15
Global Const $color_btnshadow = 16
Global Const $color_graytext = 17
Global Const $color_btntext = 18
Global Const $color_inactivecaptiontext = 19
Global Const $color_btnhighlight = 20
Global Const $color_3ddkshadow = 21
Global Const $color_3dlight = 22
Global Const $color_infotext = 23
Global Const $color_infobk = 24
Global Const $color_hotlight = 26
Global Const $color_gradientactivecaption = 27
Global Const $color_gradientinactivecaption = 28
Global Const $color_menuhilight = 29
Global Const $color_menubar = 30
Global Const $color_desktop = 1
Global Const $color_3dface = 15
Global Const $color_3dshadow = 16
Global Const $color_3dhighlight = 20
Global Const $color_3dhilight = 20
Global Const $color_btnhilight = 20
Global Const $hinst_commctrl = -1
Global Const $idb_std_small_color = 0
Global Const $idb_std_large_color = 1
Global Const $idb_view_small_color = 4
Global Const $idb_view_large_color = 5
Global Const $idb_hist_small_color = 8
Global Const $idb_hist_large_color = 9
Global Const $startf_forceofffeedback = 128
Global Const $startf_forceonfeedback = 64
Global Const $startf_runfullscreen = 32
Global Const $startf_usecountchars = 8
Global Const $startf_usefillattribute = 16
Global Const $startf_usehotkey = 512
Global Const $startf_useposition = 4
Global Const $startf_useshowwindow = 1
Global Const $startf_usesize = 2
Global Const $startf_usestdhandles = 256
Global Const $cdds_prepaint = 1
Global Const $cdds_postpaint = 2
Global Const $cdds_preerase = 3
Global Const $cdds_posterase = 4
Global Const $cdds_item = 65536
Global Const $cdds_itemprepaint = 65537
Global Const $cdds_itempostpaint = 65538
Global Const $cdds_itempreerase = 65539
Global Const $cdds_itemposterase = 65540
Global Const $cdds_subitem = 131072
Global Const $cdis_selected = 1
Global Const $cdis_grayed = 2
Global Const $cdis_disabled = 4
Global Const $cdis_checked = 8
Global Const $cdis_focus = 16
Global Const $cdis_default = 32
Global Const $cdis_hot = 64
Global Const $cdis_marked = 128
Global Const $cdis_indeterminate = 256
Global Const $cdis_showkeyboardcues = 512
Global Const $cdis_nearhot = 1024
Global Const $cdis_othersidehot = 2048
Global Const $cdis_drophilited = 4096
Global Const $cdrf_dodefault = 0
Global Const $cdrf_newfont = 2
Global Const $cdrf_skipdefault = 4
Global Const $cdrf_notifypostpaint = 16
Global Const $cdrf_notifyitemdraw = 32
Global Const $cdrf_notifysubitemdraw = 32
Global Const $cdrf_notifyposterase = 64
Global Const $cdrf_doerase = 8
Global Const $cdrf_skippostpaint = 256
Global Const $gui_ss_default_gui = BitOR($ws_minimizebox, $ws_caption, $ws_popup, $ws_sysmenu)
Global Const $gmem_fixed = 0
Global Const $gmem_moveable = 2
Global Const $gmem_nocompact = 16
Global Const $gmem_nodiscard = 32
Global Const $gmem_zeroinit = 64
Global Const $gmem_modify = 128
Global Const $gmem_discardable = 256
Global Const $gmem_not_banked = 4096
Global Const $gmem_share = 8192
Global Const $gmem_ddeshare = 8192
Global Const $gmem_notify = 16384
Global Const $gmem_lower = 4096
Global Const $gmem_valid_flags = 32626
Global Const $gmem_invalid_handle = 32768
Global Const $gptr = $gmem_fixed + $gmem_zeroinit
Global Const $ghnd = $gmem_moveable + $gmem_zeroinit
Global Const $mem_commit = 4096
Global Const $mem_reserve = 8192
Global Const $mem_top_down = 1048576
Global Const $mem_shared = 134217728
Global Const $page_noaccess = 1
Global Const $page_readonly = 2
Global Const $page_readwrite = 4
Global Const $page_execute = 16
Global Const $page_execute_read = 32
Global Const $page_execute_readwrite = 64
Global Const $page_guard = 256
Global Const $page_nocache = 512
Global Const $mem_decommit = 16384
Global Const $mem_release = 32768
Global Const $tagpoint = "struct;long X;long Y;endstruct"
Global Const $tagrect = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $tagsize = "struct;long X;long Y;endstruct"
Global Const $tagmargins = "int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight"
Global Const $tagfiletime = "struct;dword Lo;dword Hi;endstruct"
Global Const $tagsystemtime = "struct;word Year;word Month;word Dow;word Day;word Hour;word Minute;word Second;word MSeconds;endstruct"
Global Const $tagtime_zone_information = "struct;long Bias;wchar StdName[32];word StdDate[8];long StdBias;wchar DayName[32];word DayDate[8];long DayBias;endstruct"
Global Const $tagnmhdr = "struct;hwnd hWndFrom;uint_ptr IDFrom;INT Code;endstruct"
Global Const $tagcomboboxexitem = "uint Mask;int_ptr Item;ptr Text;int TextMax;int Image;int SelectedImage;int OverlayImage;" & "int Indent;lparam Param"
Global Const $tagnmcbedragbegin = $tagnmhdr & ";int ItemID;wchar szText[260]"
Global Const $tagnmcbeendedit = $tagnmhdr & ";bool fChanged;int NewSelection;wchar szText[260];int Why"
Global Const $tagnmcomboboxex = $tagnmhdr & ";uint Mask;int_ptr Item;ptr Text;int TextMax;int Image;" & "int SelectedImage;int OverlayImage;int Indent;lparam Param"
Global Const $tagdtprange = "word MinYear;word MinMonth;word MinDOW;word MinDay;word MinHour;word MinMinute;" & "word MinSecond;word MinMSecond;word MaxYear;word MaxMonth;word MaxDOW;word MaxDay;word MaxHour;" & "word MaxMinute;word MaxSecond;word MaxMSecond;bool MinValid;bool MaxValid"
Global Const $tagnmdatetimechange = $tagnmhdr & ";dword Flag;" & $tagsystemtime
Global Const $tagnmdatetimeformat = $tagnmhdr & ";ptr Format;" & $tagsystemtime & ";ptr pDisplay;wchar Display[64]"
Global Const $tagnmdatetimeformatquery = $tagnmhdr & ";ptr Format;struct;long SizeX;long SizeY;endstruct"
Global Const $tagnmdatetimekeydown = $tagnmhdr & ";int VirtKey;ptr Format;" & $tagsystemtime
Global Const $tagnmdatetimestring = $tagnmhdr & ";ptr UserString;" & $tagsystemtime & ";dword Flags"
Global Const $tageventlogrecord = "dword Length;dword Reserved;dword RecordNumber;dword TimeGenerated;dword TimeWritten;dword EventID;" & "word EventType;word NumStrings;word EventCategory;word ReservedFlags;dword ClosingRecordNumber;dword StringOffset;" & "dword UserSidLength;dword UserSidOffset;dword DataLength;dword DataOffset"
Global Const $taggdipbitmapdata = "uint Width;uint Height;int Stride;int Format;ptr Scan0;uint_ptr Reserved"
Global Const $taggdipencoderparam = "byte GUID[16];ulong Count;ulong Type;ptr Values"
Global Const $taggdipencoderparams = "uint Count;byte Params[1]"
Global Const $taggdiprectf = "float X;float Y;float Width;float Height"
Global Const $taggdipstartupinput = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $taggdipstartupoutput = "ptr HookProc;ptr UnhookProc"
Global Const $taggdipimagecodecinfo = "byte CLSID[16];byte FormatID[16];ptr CodecName;ptr DllName;ptr FormatDesc;ptr FileExt;" & "ptr MimeType;dword Flags;dword Version;dword SigCount;dword SigSize;ptr SigPattern;ptr SigMask"
Global Const $taggdippencoderparams = "uint Count;byte Params[1]"
Global Const $taghditem = "uint Mask;int XY;ptr Text;handle hBMP;int TextMax;int Fmt;lparam Param;int Image;int Order;uint Type;ptr pFilter;uint State"
Global Const $tagnmhddispinfo = $tagnmhdr & ";int Item;uint Mask;ptr Text;int TextMax;int Image;lparam lParam"
Global Const $tagnmhdfilterbtnclick = $tagnmhdr & ";int Item;" & $tagrect
Global Const $tagnmheader = $tagnmhdr & ";int Item;int Button;ptr pItem"
Global Const $taggetipaddress = "byte Field4;byte Field3;byte Field2;byte Field1"
Global Const $tagnmipaddress = $tagnmhdr & ";int Field;int Value"
Global Const $taglvfindinfo = "struct;uint Flags;ptr Text;lparam Param;" & $tagpoint & ";uint Direction;endstruct"
Global Const $taglvhittestinfo = $tagpoint & ";uint Flags;int Item;int SubItem;int iGroup"
Global Const $taglvitem = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
Global Const $tagnmlistview = $tagnmhdr & ";int Item;int SubItem;uint NewState;uint OldState;uint Changed;" & "struct;long ActionX;long ActionY;endstruct;lparam Param"
Global Const $tagnmlvcustomdraw = "struct;" & $tagnmhdr & ";dword dwDrawStage;handle hdc;" & $tagrect & ";dword_ptr dwItemSpec;uint uItemState;lparam lItemlParam;endstruct" & ";dword clrText;dword clrTextBk;int iSubItem;dword dwItemType;dword clrFace;int iIconEffect;" & "int iIconPhase;int iPartId;int iStateId;struct;long TextLeft;long TextTop;long TextRight;long TextBottom;endstruct;uint uAlign"
Global Const $tagnmlvdispinfo = $tagnmhdr & ";" & $taglvitem
Global Const $tagnmlvfinditem = $tagnmhdr & ";int Start;" & $taglvfindinfo
Global Const $tagnmlvgetinfotip = $tagnmhdr & ";dword Flags;ptr Text;int TextMax;int Item;int SubItem;lparam lParam"
Global Const $tagnmitemactivate = $tagnmhdr & ";int Index;int SubItem;uint NewState;uint OldState;uint Changed;" & $tagpoint & ";lparam lParam;uint KeyFlags"
Global Const $tagnmlvkeydown = "align 1;" & $tagnmhdr & ";word VKey;uint Flags"
Global Const $tagnmlvscroll = $tagnmhdr & ";int DX;int DY"
Global Const $tagmchittestinfo = "uint Size;" & $tagpoint & ";uint Hit;" & $tagsystemtime & ";" & $tagrect & ";int iOffset;int iRow;int iCol"
Global Const $tagmcmonthrange = "word MinYear;word MinMonth;word MinDOW;word MinDay;word MinHour;word MinMinute;word MinSecond;" & "word MinMSeconds;word MaxYear;word MaxMonth;word MaxDOW;word MaxDay;word MaxHour;word MaxMinute;word MaxSecond;" & "word MaxMSeconds;short Span"
Global Const $tagmcrange = "word MinYear;word MinMonth;word MinDOW;word MinDay;word MinHour;word MinMinute;word MinSecond;" & "word MinMSeconds;word MaxYear;word MaxMonth;word MaxDOW;word MaxDay;word MaxHour;word MaxMinute;word MaxSecond;" & "word MaxMSeconds;short MinSet;short MaxSet"
Global Const $tagmcselrange = "word MinYear;word MinMonth;word MinDOW;word MinDay;word MinHour;word MinMinute;word MinSecond;" & "word MinMSeconds;word MaxYear;word MaxMonth;word MaxDOW;word MaxDay;word MaxHour;word MaxMinute;word MaxSecond;" & "word MaxMSeconds"
Global Const $tagnmdaystate = $tagnmhdr & ";" & $tagsystemtime & ";int DayState;ptr pDayState"
Global Const $tagnmselchange = $tagnmhdr & ";struct;word BegYear;word BegMonth;word BegDOW;word BegDay;word BegHour;word BegMinute;word BegSecond;word BegMSeconds;endstruct;" & "struct;word EndYear;word EndMonth;word EndDOW;word EndDay;word EndHour;word EndMinute;word EndSecond;word EndMSeconds;endstruct"
Global Const $tagnmobjectnotify = $tagnmhdr & ";int Item;ptr piid;ptr pObject;long Result;dword dwFlags"
Global Const $tagnmtckeydown = "align 1;" & $tagnmhdr & ";word VKey;uint Flags"
Global Const $tagtvitem = "struct;uint Mask;handle hItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;int SelectedImage;" & "int Children;lparam Param;endstruct"
Global Const $tagtvitemex = "struct;" & $tagtvitem & ";int Integral;uint uStateEx;hwnd hwnd;int iExpandedImage;int iReserved;endstruct"
Global Const $tagnmtreeview = $tagnmhdr & ";uint Action;" & "struct;uint OldMask;handle OldhItem;uint OldState;uint OldStateMask;" & "ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;endstruct;" & "struct;uint NewMask;handle NewhItem;uint NewState;uint NewStateMask;" & "ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;endstruct;" & "struct;long PointX;long PointY;endstruct"
Global Const $tagnmtvcustomdraw = "struct;" & $tagnmhdr & ";dword DrawStage;handle HDC;" & $tagrect & ";dword_ptr ItemSpec;uint ItemState;lparam ItemParam;endstruct" & ";dword ClrText;dword ClrTextBk;int Level"
Global Const $tagnmtvdispinfo = $tagnmhdr & ";" & $tagtvitem
Global Const $tagnmtvgetinfotip = $tagnmhdr & ";ptr Text;int TextMax;handle hItem;lparam lParam"
Global Const $tagtvhittestinfo = $tagpoint & ";uint Flags;handle Item"
Global Const $tagnmtvkeydown = "align 1;" & $tagnmhdr & ";word VKey;uint Flags"
Global Const $tagnmmouse = $tagnmhdr & ";dword_ptr ItemSpec;dword_ptr ItemData;" & $tagpoint & ";lparam HitInfo"
Global Const $tagtoken_privileges = "dword Count;align 4;int64 LUID;dword Attributes"
Global Const $tagimageinfo = "handle hBitmap;handle hMask;int Unused1;int Unused2;" & $tagrect
Global Const $tagmenuinfo = "dword Size;INT Mask;dword Style;uint YMax;handle hBack;dword ContextHelpID;ulong_ptr MenuData"
Global Const $tagmenuiteminfo = "uint Size;uint Mask;uint Type;uint State;uint ID;handle SubMenu;handle BmpChecked;handle BmpUnchecked;" & "ulong_ptr ItemData;ptr TypeData;uint CCH;handle BmpItem"
Global Const $tagrebarbandinfo = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader;" & $tagrect & ";uint uChevronState"
Global Const $tagnmrebarautobreak = $tagnmhdr & ";uint uBand;uint wID;lparam lParam;uint uMsg;uint fStyleCurrent;bool fAutoBreak"
Global Const $tagnmrbautosize = $tagnmhdr & ";bool fChanged;" & "struct;long TargetLeft;long TargetTop;long TargetRight;long TargetBottom;endstruct;" & "struct;long ActualLeft;long ActualTop;long ActualRight;long ActualBottom;endstruct"
Global Const $tagnmrebar = $tagnmhdr & ";dword dwMask;uint uBand;uint fStyle;uint wID;lparam lParam"
Global Const $tagnmrebarchevron = $tagnmhdr & ";uint uBand;uint wID;lparam lParam;" & $tagrect & ";lparam lParamNM"
Global Const $tagnmrebarchildsize = $tagnmhdr & ";uint uBand;uint wID;" & "struct;long CLeft;long CTop;long CRight;long CBottom;endstruct;" & "struct;long BLeft;long BTop;long BRight;long BBottom;endstruct"
Global Const $tagcolorscheme = "dword Size;dword BtnHighlight;dword BtnShadow"
Global Const $tagnmtoolbar = $tagnmhdr & ";int iItem;" & "struct;int iBitmap;int idCommand;byte fsState;byte fsStyle;dword_ptr dwData;int_ptr iString;endstruct" & ";int cchText;ptr pszText;" & $tagrect
Global Const $tagnmtbhotitem = $tagnmhdr & ";int idOld;int idNew;dword dwFlags"
Global Const $tagtbbutton = "int Bitmap;int Command;byte State;byte Style;align;dword_ptr Param;int_ptr String"
Global Const $tagtbbuttoninfo = "uint Size;dword Mask;int Command;int Image;byte State;byte Style;word CX;dword_ptr Param;ptr Text;int TextMax"
Global Const $tagnetresource = "dword Scope;dword Type;dword DisplayType;dword Usage;ptr LocalName;ptr RemoteName;ptr Comment;ptr Provider"
Global Const $tagoverlapped = "ulong_ptr Internal;ulong_ptr InternalHigh;struct;dword Offset;dword OffsetHigh;endstruct;handle hEvent"
Global Const $tagopenfilename = "dword StructSize;hwnd hwndOwner;handle hInstance;ptr lpstrFilter;ptr lpstrCustomFilter;" & "dword nMaxCustFilter;dword nFilterIndex;ptr lpstrFile;dword nMaxFile;ptr lpstrFileTitle;dword nMaxFileTitle;" & "ptr lpstrInitialDir;ptr lpstrTitle;dword Flags;word nFileOffset;word nFileExtension;ptr lpstrDefExt;lparam lCustData;" & "ptr lpfnHook;ptr lpTemplateName;ptr pvReserved;dword dwReserved;dword FlagsEx"
Global Const $tagbitmapinfo = "struct;dword Size;long Width;long Height;word Planes;word BitCount;dword Compression;dword SizeImage;" & "long XPelsPerMeter;long YPelsPerMeter;dword ClrUsed;dword ClrImportant;endstruct;dword RGBQuad"
Global Const $tagblendfunction = "byte Op;byte Flags;byte Alpha;byte Format"
Global Const $tagguid = "ulong Data1;ushort Data2;ushort Data3;byte Data4[8]"
Global Const $tagwindowplacement = "uint length;uint flags;uint showCmd;long ptMinPosition[2];long ptMaxPosition[2];long rcNormalPosition[4]"
Global Const $tagwindowpos = "hwnd hWnd;hwnd InsertAfter;int X;int Y;int CX;int CY;uint Flags"
Global Const $tagscrollinfo = "uint cbSize;uint fMask;int nMin;int nMax;uint nPage;int nPos;int nTrackPos"
Global Const $tagscrollbarinfo = "dword cbSize;" & $tagrect & ";int dxyLineButton;int xyThumbTop;" & "int xyThumbBottom;int reserved;dword rgstate[6]"
Global Const $taglogfont = "long Height;long Width;long Escapement;long Orientation;long Weight;byte Italic;byte Underline;" & "byte Strikeout;byte CharSet;byte OutPrecision;byte ClipPrecision;byte Quality;byte PitchAndFamily;wchar FaceName[32]"
Global Const $tagkbdllhookstruct = "dword vkCode;dword scanCode;dword flags;dword time;ulong_ptr dwExtraInfo"
Global Const $tagprocess_information = "handle hProcess;handle hThread;dword ProcessID;dword ThreadID"
Global Const $tagstartupinfo = "dword Size;ptr Reserved1;ptr Desktop;ptr Title;dword X;dword Y;dword XSize;dword YSize;dword XCountChars;" & "dword YCountChars;dword FillAttribute;dword Flags;word ShowWindow;word Reserved2;ptr Reserved3;handle StdInput;" & "handle StdOutput;handle StdError"
Global Const $tagsecurity_attributes = "dword Length;ptr Descriptor;bool InheritHandle"
Global Const $tagwin32_find_data = "dword dwFileAttributes;dword ftCreationTime[2];dword ftLastAccessTime[2];dword ftLastWriteTime[2];dword nFileSizeHigh;dword nFileSizeLow;dword dwReserved0;dword dwReserved1;wchar cFileName[260];wchar cAlternateFileName[14]"
Global Const $tagtextmetric = "long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;" & "long tmAveCharWidth;long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;" & "wchar tmFirstChar;wchar tmLastChar;wchar tmDefaultChar;wchar tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & "byte tmPitchAndFamily;byte tmCharSet"
Global Const $process_terminate = 1
Global Const $process_create_thread = 2
Global Const $process_set_sessionid = 4
Global Const $process_vm_operation = 8
Global Const $process_vm_read = 16
Global Const $process_vm_write = 32
Global Const $process_dup_handle = 64
Global Const $process_create_process = 128
Global Const $process_set_quota = 256
Global Const $process_set_information = 512
Global Const $process_query_information = 1024
Global Const $process_suspend_resume = 2048
Global Const $process_all_access = 2035711
Global Const $error_no_token = 1008
Global Const $se_assignprimarytoken_name = "SeAssignPrimaryTokenPrivilege"
Global Const $se_audit_name = "SeAuditPrivilege"
Global Const $se_backup_name = "SeBackupPrivilege"
Global Const $se_change_notify_name = "SeChangeNotifyPrivilege"
Global Const $se_create_global_name = "SeCreateGlobalPrivilege"
Global Const $se_create_pagefile_name = "SeCreatePagefilePrivilege"
Global Const $se_create_permanent_name = "SeCreatePermanentPrivilege"
Global Const $se_create_token_name = "SeCreateTokenPrivilege"
Global Const $se_debug_name = "SeDebugPrivilege"
Global Const $se_enable_delegation_name = "SeEnableDelegationPrivilege"
Global Const $se_impersonate_name = "SeImpersonatePrivilege"
Global Const $se_inc_base_priority_name = "SeIncreaseBasePriorityPrivilege"
Global Const $se_increase_quota_name = "SeIncreaseQuotaPrivilege"
Global Const $se_load_driver_name = "SeLoadDriverPrivilege"
Global Const $se_lock_memory_name = "SeLockMemoryPrivilege"
Global Const $se_machine_account_name = "SeMachineAccountPrivilege"
Global Const $se_manage_volume_name = "SeManageVolumePrivilege"
Global Const $se_prof_single_process_name = "SeProfileSingleProcessPrivilege"
Global Const $se_remote_shutdown_name = "SeRemoteShutdownPrivilege"
Global Const $se_restore_name = "SeRestorePrivilege"
Global Const $se_security_name = "SeSecurityPrivilege"
Global Const $se_shutdown_name = "SeShutdownPrivilege"
Global Const $se_sync_agent_name = "SeSyncAgentPrivilege"
Global Const $se_system_environment_name = "SeSystemEnvironmentPrivilege"
Global Const $se_system_profile_name = "SeSystemProfilePrivilege"
Global Const $se_systemtime_name = "SeSystemtimePrivilege"
Global Const $se_take_ownership_name = "SeTakeOwnershipPrivilege"
Global Const $se_tcb_name = "SeTcbPrivilege"
Global Const $se_unsolicited_input_name = "SeUnsolicitedInputPrivilege"
Global Const $se_undock_name = "SeUndockPrivilege"
Global Const $se_privilege_enabled_by_default = 1
Global Const $se_privilege_enabled = 2
Global Const $se_privilege_removed = 4
Global Const $se_privilege_used_for_access = -2147483648
Global Const $se_group_mandatory = 1
Global Const $se_group_enabled_by_default = 2
Global Const $se_group_enabled = 4
Global Const $se_group_owner = 8
Global Const $se_group_use_for_deny_only = 16
Global Const $se_group_integrity = 32
Global Const $se_group_integrity_enabled = 64
Global Const $se_group_resource = 536870912
Global Const $se_group_logon_id = -1073741824
Global Enum $tokenprimary = 1, $tokenimpersonation
Global Enum $securityanonymous = 0, $securityidentification, $securityimpersonation, $securitydelegation
Global Enum $tokenuser = 1, $tokengroups, $tokenprivileges, $tokenowner, $tokenprimarygroup, $tokendefaultdacl, $tokensource, $tokentype, $tokenimpersonationlevel, $tokenstatistics, $tokenrestrictedsids, $tokensessionid, $tokengroupsandprivileges, $tokensessionreference, $tokensandboxinert, $tokenauditpolicy, $tokenorigin, $tokenelevationtype, $tokenlinkedtoken, $tokenelevation, $tokenhasrestrictions, $tokenaccessinformation, $tokenvirtualizationallowed, $tokenvirtualizationenabled, $tokenintegritylevel, $tokenuiaccess, $tokenmandatorypolicy, $tokenlogonsid
Global Const $token_assign_primary = 1
Global Const $token_duplicate = 2
Global Const $token_impersonate = 4
Global Const $token_query = 8
Global Const $token_query_source = 16
Global Const $token_adjust_privileges = 32
Global Const $token_adjust_groups = 64
Global Const $token_adjust_default = 128
Global Const $token_adjust_sessionid = 256
Global Const $token_all_access = 983551
Global Const $token_read = 131080
Global Const $token_write = 131296
Global Const $token_execute = 131072
Global Const $token_has_traverse_privilege = 1
Global Const $token_has_backup_privilege = 2
Global Const $token_has_restore_privilege = 4
Global Const $token_has_admin_group = 8
Global Const $token_is_restricted = 16
Global Const $token_session_not_referenced = 32
Global Const $token_sandbox_inert = 64
Global Const $token_has_impersonate_privilege = 128
Global Const $rights_delete = 65536
Global Const $read_control = 131072
Global Const $write_dac = 262144
Global Const $write_owner = 524288
Global Const $synchronize = 1048576
Global Const $standard_rights_required = 983040
Global Const $standard_rights_read = $read_control
Global Const $standard_rights_write = $read_control
Global Const $standard_rights_execute = $read_control
Global Const $standard_rights_all = 2031616
Global Const $specific_rights_all = 65535
Global Enum $not_used_access = 0, $grant_access, $set_access, $deny_access, $revoke_access, $set_audit_success, $set_audit_failure
Global Enum $trustee_is_unknown = 0, $trustee_is_user, $trustee_is_group, $trustee_is_domain, $trustee_is_alias, $trustee_is_well_known_group, $trustee_is_deleted, $trustee_is_invalid, $trustee_is_computer
Global Const $logon_with_profile = 1
Global Const $logon_netcredentials_only = 2
Global Enum $sidtypeuser = 1, $sidtypegroup, $sidtypedomain, $sidtypealias, $sidtypewellknowngroup, $sidtypedeletedaccount, $sidtypeinvalid, $sidtypeunknown, $sidtypecomputer, $sidtypelabel
Global Const $sid_administrators = "S-1-5-32-544"
Global Const $sid_users = "S-1-5-32-545"
Global Const $sid_guests = "S-1-5-32-546"
Global Const $sid_account_operators = "S-1-5-32-548"
Global Const $sid_server_operators = "S-1-5-32-549"
Global Const $sid_print_operators = "S-1-5-32-550"
Global Const $sid_backup_operators = "S-1-5-32-551"
Global Const $sid_replicator = "S-1-5-32-552"
Global Const $sid_owner = "S-1-3-0"
Global Const $sid_everyone = "S-1-1-0"
Global Const $sid_network = "S-1-5-2"
Global Const $sid_interactive = "S-1-5-4"
Global Const $sid_system = "S-1-5-18"
Global Const $sid_authenticated_users = "S-1-5-11"
Global Const $sid_schannel_authentication = "S-1-5-64-14"
Global Const $sid_digest_authentication = "S-1-5-64-21"
Global Const $sid_nt_service = "S-1-5-80"
Global Const $sid_untrusted_mandatory_level = "S-1-16-0"
Global Const $sid_low_mandatory_level = "S-1-16-4096"
Global Const $sid_medium_mandatory_level = "S-1-16-8192"
Global Const $sid_medium_plus_mandatory_level = "S-1-16-8448"
Global Const $sid_high_mandatory_level = "S-1-16-12288"
Global Const $sid_system_mandatory_level = "S-1-16-16384"
Global Const $sid_protected_process_mandatory_level = "S-1-16-20480"
Global Const $sid_secure_process_mandatory_level = "S-1-16-28672"
Global Const $sid_all_services = "S-1-5-80-0"

Func _winapi_getlasterror($curerr = @error, $curext = @extended)
	Local $aresult = DllCall("kernel32.dll", "dword", "GetLastError")
	Return SetError($curerr, $curext, $aresult[0])
EndFunc

Func _winapi_setlasterror($ierrcode, $curerr = @error, $curext = @extended)
	DllCall("kernel32.dll", "none", "SetLastError", "dword", $ierrcode)
	Return SetError($curerr, $curext)
EndFunc

Func _sendmessage($hwnd, $imsg, $wparam = 0, $lparam = 0, $ireturn = 0, $wparamtype = "wparam", $lparamtype = "lparam", $sreturntype = "lresult")
	Local $aresult = DllCall("user32.dll", $sreturntype, "SendMessageW", "hwnd", $hwnd, "uint", $imsg, $wparamtype, $wparam, $lparamtype, $lparam)
	If @error Then Return SetError(@error, @extended, "")
	If $ireturn >= 0 AND $ireturn <= 4 Then Return $aresult[$ireturn]
	Return $aresult
EndFunc

Func _sendmessagea($hwnd, $imsg, $wparam = 0, $lparam = 0, $ireturn = 0, $wparamtype = "wparam", $lparamtype = "lparam", $sreturntype = "lresult")
	Local $aresult = DllCall("user32.dll", $sreturntype, "SendMessageA", "hwnd", $hwnd, "uint", $imsg, $wparamtype, $wparam, $lparamtype, $lparam)
	If @error Then Return SetError(@error, @extended, "")
	If $ireturn >= 0 AND $ireturn <= 4 Then Return $aresult[$ireturn]
	Return $aresult
EndFunc

Global $__gainprocess_winapi[64][2] = [[0, 0]]
Global $__gawinlist_winapi[64][2] = [[0, 0]]
Global Const $__winapiconstant_wm_setfont = 48
Global Const $__winapiconstant_fw_normal = 400
Global Const $__winapiconstant_default_charset = 1
Global Const $__winapiconstant_out_default_precis = 0
Global Const $__winapiconstant_clip_default_precis = 0
Global Const $__winapiconstant_default_quality = 0
Global Const $__winapiconstant_format_message_allocate_buffer = 256
Global Const $__winapiconstant_format_message_from_system = 4096
Global Const $__winapiconstant_logpixelsx = 88
Global Const $__winapiconstant_logpixelsy = 90
Global Const $hgdi_error = Ptr(-1)
Global Const $invalid_handle_value = Ptr(-1)
Global Const $clr_invalid = -1
Global Const $__winapiconstant_flashw_caption = 1
Global Const $__winapiconstant_flashw_tray = 2
Global Const $__winapiconstant_flashw_timer = 4
Global Const $__winapiconstant_flashw_timernofg = 12
Global Const $__winapiconstant_gw_hwndnext = 2
Global Const $__winapiconstant_gw_child = 5
Global Const $__winapiconstant_di_mask = 1
Global Const $__winapiconstant_di_image = 2
Global Const $__winapiconstant_di_normal = 3
Global Const $__winapiconstant_di_compat = 4
Global Const $__winapiconstant_di_defaultsize = 8
Global Const $__winapiconstant_di_nomirror = 16
Global Const $__winapiconstant_display_device_attached_to_desktop = 1
Global Const $__winapiconstant_display_device_primary_device = 4
Global Const $__winapiconstant_display_device_mirroring_driver = 8
Global Const $__winapiconstant_display_device_vga_compatible = 16
Global Const $__winapiconstant_display_device_removable = 32
Global Const $__winapiconstant_display_device_modespruned = 134217728
Global Const $null_brush = 5
Global Const $null_pen = 8
Global Const $black_brush = 4
Global Const $dkgray_brush = 3
Global Const $dc_brush = 18
Global Const $gray_brush = 2
Global Const $hollow_brush = $null_brush
Global Const $ltgray_brush = 1
Global Const $white_brush = 0
Global Const $black_pen = 7
Global Const $dc_pen = 19
Global Const $white_pen = 6
Global Const $ansi_fixed_font = 11
Global Const $ansi_var_font = 12
Global Const $device_default_font = 14
Global Const $default_gui_font = 17
Global Const $oem_fixed_font = 10
Global Const $system_font = 13
Global Const $system_fixed_font = 16
Global Const $default_palette = 15
Global Const $mb_precomposed = 1
Global Const $mb_composite = 2
Global Const $mb_useglyphchars = 4
Global Const $ulw_alpha = 2
Global Const $ulw_colorkey = 1
Global Const $ulw_opaque = 4
Global Const $wh_callwndproc = 4
Global Const $wh_callwndprocret = 12
Global Const $wh_cbt = 5
Global Const $wh_debug = 9
Global Const $wh_foregroundidle = 11
Global Const $wh_getmessage = 3
Global Const $wh_journalplayback = 1
Global Const $wh_journalrecord = 0
Global Const $wh_keyboard = 2
Global Const $wh_keyboard_ll = 13
Global Const $wh_mouse = 7
Global Const $wh_mouse_ll = 14
Global Const $wh_msgfilter = -1
Global Const $wh_shell = 10
Global Const $wh_sysmsgfilter = 6
Global Const $wpf_asyncwindowplacement = 4
Global Const $wpf_restoretomaximized = 2
Global Const $wpf_setminposition = 1
Global Const $kf_extended = 256
Global Const $kf_altdown = 8192
Global Const $kf_up = 32768
Global Const $llkhf_extended = BitShift($kf_extended, 8)
Global Const $llkhf_injected = 16
Global Const $llkhf_altdown = BitShift($kf_altdown, 8)
Global Const $llkhf_up = BitShift($kf_up, 8)
Global Const $ofn_allowmultiselect = 512
Global Const $ofn_createprompt = 8192
Global Const $ofn_dontaddtorecent = 33554432
Global Const $ofn_enablehook = 32
Global Const $ofn_enableincludenotify = 4194304
Global Const $ofn_enablesizing = 8388608
Global Const $ofn_enabletemplate = 64
Global Const $ofn_enabletemplatehandle = 128
Global Const $ofn_explorer = 524288
Global Const $ofn_extensiondifferent = 1024
Global Const $ofn_filemustexist = 4096
Global Const $ofn_forceshowhidden = 268435456
Global Const $ofn_hidereadonly = 4
Global Const $ofn_longnames = 2097152
Global Const $ofn_nochangedir = 8
Global Const $ofn_nodereferencelinks = 1048576
Global Const $ofn_nolongnames = 262144
Global Const $ofn_nonetworkbutton = 131072
Global Const $ofn_noreadonlyreturn = 32768
Global Const $ofn_notestfilecreate = 65536
Global Const $ofn_novalidate = 256
Global Const $ofn_overwriteprompt = 2
Global Const $ofn_pathmustexist = 2048
Global Const $ofn_readonly = 1
Global Const $ofn_shareaware = 16384
Global Const $ofn_showhelp = 16
Global Const $ofn_ex_noplacesbar = 1
Global Const $tmpf_fixed_pitch = 1
Global Const $tmpf_vector = 2
Global Const $tmpf_truetype = 4
Global Const $tmpf_device = 8
Global Const $duplicate_close_source = 1
Global Const $duplicate_same_access = 2
Global Const $tagcursorinfo = "dword Size;dword Flags;handle hCursor;" & $tagpoint
Global Const $tagdisplay_device = "dword Size;wchar Name[32];wchar String[128];dword Flags;wchar ID[128];wchar Key[128]"
Global Const $tagflashwinfo = "uint Size;hwnd hWnd;dword Flags;uint Count;dword TimeOut"
Global Const $tagiconinfo = "bool Icon;dword XHotSpot;dword YHotSpot;handle hMask;handle hColor"
Global Const $tagmemorystatusex = "dword Length;dword MemoryLoad;" & "uint64 TotalPhys;uint64 AvailPhys;uint64 TotalPageFile;uint64 AvailPageFile;" & "uint64 TotalVirtual;uint64 AvailVirtual;uint64 AvailExtendedVirtual"

Func _winapi_attachconsole($iprocessid = -1)
	Local $aresult = DllCall("kernel32.dll", "bool", "AttachConsole", "dword", $iprocessid)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_attachthreadinput($iattach, $iattachto, $fattach)
	Local $aresult = DllCall("user32.dll", "bool", "AttachThreadInput", "dword", $iattach, "dword", $iattachto, "bool", $fattach)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_beep($ifreq = 500, $iduration = 1000)
	Local $aresult = DllCall("kernel32.dll", "bool", "Beep", "dword", $ifreq, "dword", $iduration)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_bitblt($hdestdc, $ixdest, $iydest, $iwidth, $iheight, $hsrcdc, $ixsrc, $iysrc, $irop)
	Local $aresult = DllCall("gdi32.dll", "bool", "BitBlt", "handle", $hdestdc, "int", $ixdest, "int", $iydest, "int", $iwidth, "int", $iheight, "handle", $hsrcdc, "int", $ixsrc, "int", $iysrc, "dword", $irop)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_callnexthookex($hhk, $icode, $wparam, $lparam)
	Local $aresult = DllCall("user32.dll", "lresult", "CallNextHookEx", "handle", $hhk, "int", $icode, "wparam", $wparam, "lparam", $lparam)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aresult[0]
EndFunc

Func _winapi_callwindowproc($lpprevwndfunc, $hwnd, $msg, $wparam, $lparam)
	Local $aresult = DllCall("user32.dll", "lresult", "CallWindowProc", "ptr", $lpprevwndfunc, "hwnd", $hwnd, "uint", $msg, "wparam", $wparam, "lparam", $lparam)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aresult[0]
EndFunc

Func _winapi_clienttoscreen($hwnd, ByRef $tpoint)
	DllCall("user32.dll", "bool", "ClientToScreen", "hwnd", $hwnd, "struct*", $tpoint)
	Return SetError(@error, @extended, $tpoint)
EndFunc

Func _winapi_closehandle($hobject)
	Local $aresult = DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hobject)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_combinergn($hrgndest, $hrgnsrc1, $hrgnsrc2, $icombinemode)
	Local $aresult = DllCall("gdi32.dll", "int", "CombineRgn", "handle", $hrgndest, "handle", $hrgnsrc1, "handle", $hrgnsrc2, "int", $icombinemode)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_commdlgextendederror()
	Local Const $cderr_dialogfailure = 65535
	Local Const $cderr_findresfailure = 6
	Local Const $cderr_initialization = 2
	Local Const $cderr_loadresfailure = 7
	Local Const $cderr_loadstrfailure = 5
	Local Const $cderr_lockresfailure = 8
	Local Const $cderr_memallocfailure = 9
	Local Const $cderr_memlockfailure = 10
	Local Const $cderr_nohinstance = 4
	Local Const $cderr_nohook = 11
	Local Const $cderr_notemplate = 3
	Local Const $cderr_registermsgfail = 12
	Local Const $cderr_structsize = 1
	Local Const $fnerr_buffertoosmall = 12291
	Local Const $fnerr_invalidfilename = 12290
	Local Const $fnerr_subclassfailure = 12289
	Local $aresult = DllCall("comdlg32.dll", "dword", "CommDlgExtendedError")
	If @error Then Return SetError(@error, @extended, 0)
	Switch $aresult[0]
		Case $cderr_dialogfailure
			Return SetError($aresult[0], 0, "The dialog box could not be created." & @LF & "The common dialog box function's call to the DialogBox function failed." & @LF & "For example, this error occurs if the common dialog box call specifies an invalid window handle.")
		Case $cderr_findresfailure
			Return SetError($aresult[0], 0, "The common dialog box function failed to find a specified resource.")
		Case $cderr_initialization
			Return SetError($aresult[0], 0, "The common dialog box function failed during initialization." & @LF & "This error often occurs when sufficient memory is not available.")
		Case $cderr_loadresfailure
			Return SetError($aresult[0], 0, "The common dialog box function failed to load a specified resource.")
		Case $cderr_loadstrfailure
			Return SetError($aresult[0], 0, "The common dialog box function failed to load a specified string.")
		Case $cderr_lockresfailure
			Return SetError($aresult[0], 0, "The common dialog box function failed to lock a specified resource.")
		Case $cderr_memallocfailure
			Return SetError($aresult[0], 0, "The common dialog box function was unable to allocate memory for internal structures.")
		Case $cderr_memlockfailure
			Return SetError($aresult[0], 0, "The common dialog box function was unable to lock the memory associated with a handle.")
		Case $cderr_nohinstance
			Return SetError($aresult[0], 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & "but you failed to provide a corresponding instance handle.")
		Case $cderr_nohook
			Return SetError($aresult[0], 0, "The ENABLEHOOK flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & "but you failed to provide a pointer to a corresponding hook procedure.")
		Case $cderr_notemplate
			Return SetError($aresult[0], 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & "but you failed to provide a corresponding template.")
		Case $cderr_registermsgfail
			Return SetError($aresult[0], 0, "The RegisterWindowMessage function returned an error code when it was called by the common dialog box function.")
		Case $cderr_structsize
			Return SetError($aresult[0], 0, "The lStructSize member of the initialization structure for the corresponding common dialog box is invalid")
		Case $fnerr_buffertoosmall
			Return SetError($aresult[0], 0, "The buffer pointed to by the lpstrFile member of the OPENFILENAME structure is too small for the file name specified by the user." & @LF & "The first two bytes of the lpstrFile buffer contain an integer value specifying the size, in TCHARs, required to receive the full name.")
		Case $fnerr_invalidfilename
			Return SetError($aresult[0], 0, "A file name is invalid.")
		Case $fnerr_subclassfailure
			Return SetError($aresult[0], 0, "An attempt to subclass a list box failed because sufficient memory was not available.")
	EndSwitch
	Return Hex($aresult[0])
EndFunc

Func _winapi_copyicon($hicon)
	Local $aresult = DllCall("user32.dll", "handle", "CopyIcon", "handle", $hicon)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createbitmap($iwidth, $iheight, $iplanes = 1, $ibitsperpel = 1, $pbits = 0)
	Local $aresult = DllCall("gdi32.dll", "handle", "CreateBitmap", "int", $iwidth, "int", $iheight, "uint", $iplanes, "uint", $ibitsperpel, "ptr", $pbits)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createcompatiblebitmap($hdc, $iwidth, $iheight)
	Local $aresult = DllCall("gdi32.dll", "handle", "CreateCompatibleBitmap", "handle", $hdc, "int", $iwidth, "int", $iheight)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createcompatibledc($hdc)
	Local $aresult = DllCall("gdi32.dll", "handle", "CreateCompatibleDC", "handle", $hdc)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createevent($pattributes = 0, $fmanualreset = True, $finitialstate = True, $sname = "")
	Local $snametype = "wstr"
	If $sname = "" Then
		$sname = 0
		$snametype = "ptr"
	EndIf
	Local $aresult = DllCall("kernel32.dll", "handle", "CreateEventW", "ptr", $pattributes, "bool", $fmanualreset, "bool", $finitialstate, $snametype, $sname)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createfile($sfilename, $icreation, $iaccess = 4, $ishare = 0, $iattributes = 0, $psecurity = 0)
	Local $ida = 0, $ism = 0, $icd = 0, $ifa = 0
	If BitAND($iaccess, 1) <> 0 Then $ida = BitOR($ida, $generic_execute)
	If BitAND($iaccess, 2) <> 0 Then $ida = BitOR($ida, $generic_read)
	If BitAND($iaccess, 4) <> 0 Then $ida = BitOR($ida, $generic_write)
	If BitAND($ishare, 1) <> 0 Then $ism = BitOR($ism, $file_share_delete)
	If BitAND($ishare, 2) <> 0 Then $ism = BitOR($ism, $file_share_read)
	If BitAND($ishare, 4) <> 0 Then $ism = BitOR($ism, $file_share_write)
	Switch $icreation
		Case 0
			$icd = $create_new
		Case 1
			$icd = $create_always
		Case 2
			$icd = $open_existing
		Case 3
			$icd = $open_always
		Case 4
			$icd = $truncate_existing
	EndSwitch
	If BitAND($iattributes, 1) <> 0 Then $ifa = BitOR($ifa, $file_attribute_archive)
	If BitAND($iattributes, 2) <> 0 Then $ifa = BitOR($ifa, $file_attribute_hidden)
	If BitAND($iattributes, 4) <> 0 Then $ifa = BitOR($ifa, $file_attribute_readonly)
	If BitAND($iattributes, 8) <> 0 Then $ifa = BitOR($ifa, $file_attribute_system)
	Local $aresult = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sfilename, "dword", $ida, "dword", $ism, "ptr", $psecurity, "dword", $icd, "dword", $ifa, "ptr", 0)
	If @error OR $aresult[0] = Ptr(-1) Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createfont($nheight, $nwidth, $nescape = 0, $norientn = 0, $fnweight = $__winapiconstant_fw_normal, $bitalic = False, $bunderline = False, $bstrikeout = False, $ncharset = $__winapiconstant_default_charset, $noutputprec = $__winapiconstant_out_default_precis, $nclipprec = $__winapiconstant_clip_default_precis, $nquality = $__winapiconstant_default_quality, $npitch = 0, $szface = "Arial")
	Local $aresult = DllCall("gdi32.dll", "handle", "CreateFontW", "int", $nheight, "int", $nwidth, "int", $nescape, "int", $norientn, "int", $fnweight, "dword", $bitalic, "dword", $bunderline, "dword", $bstrikeout, "dword", $ncharset, "dword", $noutputprec, "dword", $nclipprec, "dword", $nquality, "dword", $npitch, "wstr", $szface)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createfontindirect($tlogfont)
	Local $aresult = DllCall("gdi32.dll", "handle", "CreateFontIndirectW", "struct*", $tlogfont)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createpen($ipenstyle, $iwidth, $ncolor)
	Local $aresult = DllCall("gdi32.dll", "handle", "CreatePen", "int", $ipenstyle, "int", $iwidth, "dword", $ncolor)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createprocess($sappname, $scommand, $psecurity, $pthread, $finherit, $iflags, $penviron, $sdir, $pstartupinfo, $pprocess)
	Local $tcommand = 0
	Local $sappnametype = "wstr", $sdirtype = "wstr"
	If $sappname = "" Then
		$sappnametype = "ptr"
		$sappname = 0
	EndIf
	If $scommand <> "" Then
		$tcommand = DllStructCreate("wchar Text[" & 260 + 1 & "]")
		DllStructSetData($tcommand, "Text", $scommand)
	EndIf
	If $sdir = "" Then
		$sdirtype = "ptr"
		$sdir = 0
	EndIf
	Local $aresult = DllCall("kernel32.dll", "bool", "CreateProcessW", $sappnametype, $sappname, "struct*", $tcommand, "ptr", $psecurity, "ptr", $pthread, "bool", $finherit, "dword", $iflags, "ptr", $penviron, $sdirtype, $sdir, "ptr", $pstartupinfo, "ptr", $pprocess)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_createrectrgn($ileftrect, $itoprect, $irightrect, $ibottomrect)
	Local $aresult = DllCall("gdi32.dll", "handle", "CreateRectRgn", "int", $ileftrect, "int", $itoprect, "int", $irightrect, "int", $ibottomrect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createroundrectrgn($ileftrect, $itoprect, $irightrect, $ibottomrect, $iwidthellipse, $iheightellipse)
	Local $aresult = DllCall("gdi32.dll", "handle", "CreateRoundRectRgn", "int", $ileftrect, "int", $itoprect, "int", $irightrect, "int", $ibottomrect, "int", $iwidthellipse, "int", $iheightellipse)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createsolidbitmap($hwnd, $icolor, $iwidth, $iheight, $brgb = 1)
	Local $hdc = _winapi_getdc($hwnd)
	Local $hdestdc = _winapi_createcompatibledc($hdc)
	Local $hbitmap = _winapi_createcompatiblebitmap($hdc, $iwidth, $iheight)
	Local $hold = _winapi_selectobject($hdestdc, $hbitmap)
	Local $trect = DllStructCreate($tagrect)
	DllStructSetData($trect, 1, 0)
	DllStructSetData($trect, 2, 0)
	DllStructSetData($trect, 3, $iwidth)
	DllStructSetData($trect, 4, $iheight)
	If $brgb Then
		$icolor = BitOR(BitAND($icolor, 65280), BitShift(BitAND($icolor, 255), -16), BitShift(BitAND($icolor, 16711680), 16))
	EndIf
	Local $hbrush = _winapi_createsolidbrush($icolor)
	_winapi_fillrect($hdestdc, $trect, $hbrush)
	If @error Then
		_winapi_deleteobject($hbitmap)
		$hbitmap = 0
	EndIf
	_winapi_deleteobject($hbrush)
	_winapi_releasedc($hwnd, $hdc)
	_winapi_selectobject($hdestdc, $hold)
	_winapi_deletedc($hdestdc)
	If NOT $hbitmap Then Return SetError(1, 0, 0)
	Return $hbitmap
EndFunc

Func _winapi_createsolidbrush($ncolor)
	Local $aresult = DllCall("gdi32.dll", "handle", "CreateSolidBrush", "dword", $ncolor)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_createwindowex($iexstyle, $sclass, $sname, $istyle, $ix, $iy, $iwidth, $iheight, $hparent, $hmenu = 0, $hinstance = 0, $pparam = 0)
	If $hinstance = 0 Then $hinstance = _winapi_getmodulehandle("")
	Local $aresult = DllCall("user32.dll", "hwnd", "CreateWindowExW", "dword", $iexstyle, "wstr", $sclass, "wstr", $sname, "dword", $istyle, "int", $ix, "int", $iy, "int", $iwidth, "int", $iheight, "hwnd", $hparent, "handle", $hmenu, "handle", $hinstance, "ptr", $pparam)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_defwindowproc($hwnd, $imsg, $iwparam, $ilparam)
	Local $aresult = DllCall("user32.dll", "lresult", "DefWindowProc", "hwnd", $hwnd, "uint", $imsg, "wparam", $iwparam, "lparam", $ilparam)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_deletedc($hdc)
	Local $aresult = DllCall("gdi32.dll", "bool", "DeleteDC", "handle", $hdc)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_deleteobject($hobject)
	Local $aresult = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hobject)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_destroyicon($hicon)
	Local $aresult = DllCall("user32.dll", "bool", "DestroyIcon", "handle", $hicon)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_destroywindow($hwnd)
	Local $aresult = DllCall("user32.dll", "bool", "DestroyWindow", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_drawedge($hdc, $ptrrect, $nedgetype, $grfflags)
	Local $aresult = DllCall("user32.dll", "bool", "DrawEdge", "handle", $hdc, "ptr", $ptrrect, "uint", $nedgetype, "uint", $grfflags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_drawframecontrol($hdc, $ptrrect, $ntype, $nstate)
	Local $aresult = DllCall("user32.dll", "bool", "DrawFrameControl", "handle", $hdc, "ptr", $ptrrect, "uint", $ntype, "uint", $nstate)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_drawicon($hdc, $ix, $iy, $hicon)
	Local $aresult = DllCall("user32.dll", "bool", "DrawIcon", "handle", $hdc, "int", $ix, "int", $iy, "handle", $hicon)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_drawiconex($hdc, $ix, $iy, $hicon, $iwidth = 0, $iheight = 0, $istep = 0, $hbrush = 0, $iflags = 3)
	Local $ioptions
	Switch $iflags
		Case 1
			$ioptions = $__winapiconstant_di_mask
		Case 2
			$ioptions = $__winapiconstant_di_image
		Case 3
			$ioptions = $__winapiconstant_di_normal
		Case 4
			$ioptions = $__winapiconstant_di_compat
		Case 5
			$ioptions = $__winapiconstant_di_defaultsize
		Case Else
			$ioptions = $__winapiconstant_di_nomirror
	EndSwitch
	Local $aresult = DllCall("user32.dll", "bool", "DrawIconEx", "handle", $hdc, "int", $ix, "int", $iy, "handle", $hicon, "int", $iwidth, "int", $iheight, "uint", $istep, "handle", $hbrush, "uint", $ioptions)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_drawline($hdc, $ix1, $iy1, $ix2, $iy2)
	_winapi_moveto($hdc, $ix1, $iy1)
	If @error Then Return SetError(@error, @extended, False)
	_winapi_lineto($hdc, $ix2, $iy2)
	If @error Then Return SetError(@error, @extended, False)
	Return True
EndFunc

Func _winapi_drawtext($hdc, $stext, ByRef $trect, $iflags)
	Local $aresult = DllCall("user32.dll", "int", "DrawTextW", "handle", $hdc, "wstr", $stext, "int", -1, "struct*", $trect, "uint", $iflags)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_duplicatehandle($hsourceprocesshandle, $hsourcehandle, $htargetprocesshandle, $idesiredaccess, $finherithandle, $ioptions)
	Local $acall = DllCall("kernel32.dll", "bool", "DuplicateHandle", "handle", $hsourceprocesshandle, "handle", $hsourcehandle, "handle", $htargetprocesshandle, "handle*", 0, "dword", $idesiredaccess, "bool", $finherithandle, "dword", $ioptions)
	If @error OR NOT $acall[0] Then Return SetError(1, @extended, 0)
	Return $acall[4]
EndFunc

Func _winapi_enablewindow($hwnd, $fenable = True)
	Local $aresult = DllCall("user32.dll", "bool", "EnableWindow", "hwnd", $hwnd, "bool", $fenable)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_enumdisplaydevices($sdevice, $idevnum)
	Local $tname = 0, $iflags = 0, $adevice[5]
	If $sdevice <> "" Then
		$tname = DllStructCreate("wchar Text[" & StringLen($sdevice) + 1 & "]")
		DllStructSetData($tname, "Text", $sdevice)
	EndIf
	Local $tdevice = DllStructCreate($tagdisplay_device)
	Local $idevice = DllStructGetSize($tdevice)
	DllStructSetData($tdevice, "Size", $idevice)
	DllCall("user32.dll", "bool", "EnumDisplayDevicesW", "struct*", $tname, "dword", $idevnum, "struct*", $tdevice, "dword", 1)
	If @error Then Return SetError(@error, @extended, 0)
	Local $in = DllStructGetData($tdevice, "Flags")
	If BitAND($in, $__winapiconstant_display_device_attached_to_desktop) <> 0 Then $iflags = BitOR($iflags, 1)
	If BitAND($in, $__winapiconstant_display_device_primary_device) <> 0 Then $iflags = BitOR($iflags, 2)
	If BitAND($in, $__winapiconstant_display_device_mirroring_driver) <> 0 Then $iflags = BitOR($iflags, 4)
	If BitAND($in, $__winapiconstant_display_device_vga_compatible) <> 0 Then $iflags = BitOR($iflags, 8)
	If BitAND($in, $__winapiconstant_display_device_removable) <> 0 Then $iflags = BitOR($iflags, 16)
	If BitAND($in, $__winapiconstant_display_device_modespruned) <> 0 Then $iflags = BitOR($iflags, 32)
	$adevice[0] = True
	$adevice[1] = DllStructGetData($tdevice, "Name")
	$adevice[2] = DllStructGetData($tdevice, "String")
	$adevice[3] = $iflags
	$adevice[4] = DllStructGetData($tdevice, "ID")
	Return $adevice
EndFunc

Func _winapi_enumwindows($fvisible = True, $hwnd = Default)
	__winapi_enumwindowsinit()
	If $hwnd = Default Then $hwnd = _winapi_getdesktopwindow()
	__winapi_enumwindowschild($hwnd, $fvisible)
	Return $__gawinlist_winapi
EndFunc

Func __winapi_enumwindowsadd($hwnd, $sclass = "")
	If $sclass = "" Then $sclass = _winapi_getclassname($hwnd)
	$__gawinlist_winapi[0][0] += 1
	Local $icount = $__gawinlist_winapi[0][0]
	If $icount >= $__gawinlist_winapi[0][1] Then
		ReDim $__gawinlist_winapi[$icount + 64][2]
		$__gawinlist_winapi[0][1] += 64
	EndIf
	$__gawinlist_winapi[$icount][0] = $hwnd
	$__gawinlist_winapi[$icount][1] = $sclass
EndFunc

Func __winapi_enumwindowschild($hwnd, $fvisible = True)
	$hwnd = _winapi_getwindow($hwnd, $__winapiconstant_gw_child)
	While $hwnd <> 0
		If (NOT $fvisible) OR _winapi_iswindowvisible($hwnd) Then
			__winapi_enumwindowschild($hwnd, $fvisible)
			__winapi_enumwindowsadd($hwnd)
		EndIf
		$hwnd = _winapi_getwindow($hwnd, $__winapiconstant_gw_hwndnext)
	WEnd
EndFunc

Func __winapi_enumwindowsinit()
	ReDim $__gawinlist_winapi[64][2]
	$__gawinlist_winapi[0][0] = 0
	$__gawinlist_winapi[0][1] = 64
EndFunc

Func _winapi_enumwindowspopup()
	__winapi_enumwindowsinit()
	Local $hwnd = _winapi_getwindow(_winapi_getdesktopwindow(), $__winapiconstant_gw_child)
	Local $sclass
	While $hwnd <> 0
		If _winapi_iswindowvisible($hwnd) Then
			$sclass = _winapi_getclassname($hwnd)
			If $sclass = "#32768" Then
				__winapi_enumwindowsadd($hwnd)
			ElseIf $sclass = "ToolbarWindow32" Then
				__winapi_enumwindowsadd($hwnd)
			ElseIf $sclass = "ToolTips_Class32" Then
				__winapi_enumwindowsadd($hwnd)
			ElseIf $sclass = "BaseBar" Then
				__winapi_enumwindowschild($hwnd)
			EndIf
		EndIf
		$hwnd = _winapi_getwindow($hwnd, $__winapiconstant_gw_hwndnext)
	WEnd
	Return $__gawinlist_winapi
EndFunc

Func _winapi_enumwindowstop()
	__winapi_enumwindowsinit()
	Local $hwnd = _winapi_getwindow(_winapi_getdesktopwindow(), $__winapiconstant_gw_child)
	While $hwnd <> 0
		If _winapi_iswindowvisible($hwnd) Then __winapi_enumwindowsadd($hwnd)
		$hwnd = _winapi_getwindow($hwnd, $__winapiconstant_gw_hwndnext)
	WEnd
	Return $__gawinlist_winapi
EndFunc

Func _winapi_expandenvironmentstrings($sstring)
	Local $aresult = DllCall("kernel32.dll", "dword", "ExpandEnvironmentStringsW", "wstr", $sstring, "wstr", "", "dword", 4096)
	If @error Then Return SetError(@error, @extended, "")
	Return $aresult[2]
EndFunc

Func _winapi_extracticonex($sfile, $iindex, $plarge, $psmall, $iicons)
	Local $aresult = DllCall("shell32.dll", "uint", "ExtractIconExW", "wstr", $sfile, "int", $iindex, "struct*", $plarge, "struct*", $psmall, "uint", $iicons)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_fatalappexit($smessage)
	DllCall("kernel32.dll", "none", "FatalAppExitW", "uint", 0, "wstr", $smessage)
	If @error Then Return SetError(@error, @extended)
EndFunc

Func _winapi_fillrect($hdc, $ptrrect, $hbrush)
	Local $aresult
	If IsPtr($hbrush) Then
		$aresult = DllCall("user32.dll", "int", "FillRect", "handle", $hdc, "struct*", $ptrrect, "handle", $hbrush)
	Else
		$aresult = DllCall("user32.dll", "int", "FillRect", "handle", $hdc, "struct*", $ptrrect, "dword_ptr", $hbrush)
	EndIf
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_findexecutable($sfilename, $sdirectory = "")
	Local $aresult = DllCall("shell32.dll", "INT", "FindExecutableW", "wstr", $sfilename, "wstr", $sdirectory, "wstr", "")
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $aresult[3])
EndFunc

Func _winapi_findwindow($sclassname, $swindowname)
	Local $aresult = DllCall("user32.dll", "hwnd", "FindWindowW", "wstr", $sclassname, "wstr", $swindowname)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_flashwindow($hwnd, $finvert = True)
	Local $aresult = DllCall("user32.dll", "bool", "FlashWindow", "hwnd", $hwnd, "bool", $finvert)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_flashwindowex($hwnd, $iflags = 3, $icount = 3, $itimeout = 0)
	Local $tflash = DllStructCreate($tagflashwinfo)
	Local $iflash = DllStructGetSize($tflash)
	Local $imode = 0
	If BitAND($iflags, 1) <> 0 Then $imode = BitOR($imode, $__winapiconstant_flashw_caption)
	If BitAND($iflags, 2) <> 0 Then $imode = BitOR($imode, $__winapiconstant_flashw_tray)
	If BitAND($iflags, 4) <> 0 Then $imode = BitOR($imode, $__winapiconstant_flashw_timer)
	If BitAND($iflags, 8) <> 0 Then $imode = BitOR($imode, $__winapiconstant_flashw_timernofg)
	DllStructSetData($tflash, "Size", $iflash)
	DllStructSetData($tflash, "hWnd", $hwnd)
	DllStructSetData($tflash, "Flags", $imode)
	DllStructSetData($tflash, "Count", $icount)
	DllStructSetData($tflash, "Timeout", $itimeout)
	Local $aresult = DllCall("user32.dll", "bool", "FlashWindowEx", "struct*", $tflash)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_floattoint($nfloat)
	Local $tfloat = DllStructCreate("float")
	Local $tint = DllStructCreate("int", DllStructGetPtr($tfloat))
	DllStructSetData($tfloat, 1, $nfloat)
	Return DllStructGetData($tint, 1)
EndFunc

Func _winapi_flushfilebuffers($hfile)
	Local $aresult = DllCall("kernel32.dll", "bool", "FlushFileBuffers", "handle", $hfile)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_formatmessage($iflags, $psource, $imessageid, $ilanguageid, ByRef $pbuffer, $isize, $varguments)
	Local $sbuffertype = "struct*"
	If IsString($pbuffer) Then $sbuffertype = "wstr"
	Local $aresult = DllCall("Kernel32.dll", "dword", "FormatMessageW", "dword", $iflags, "ptr", $psource, "dword", $imessageid, "dword", $ilanguageid, $sbuffertype, $pbuffer, "dword", $isize, "ptr", $varguments)
	If @error Then Return SetError(@error, @extended, 0)
	If $sbuffertype = "wstr" Then $pbuffer = $aresult[5]
	Return $aresult[0]
EndFunc

Func _winapi_framerect($hdc, $ptrrect, $hbrush)
	Local $aresult = DllCall("user32.dll", "int", "FrameRect", "handle", $hdc, "ptr", $ptrrect, "handle", $hbrush)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_freelibrary($hmodule)
	Local $aresult = DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $hmodule)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_getancestor($hwnd, $iflags = 1)
	Local $aresult = DllCall("user32.dll", "hwnd", "GetAncestor", "hwnd", $hwnd, "uint", $iflags)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getasynckeystate($ikey)
	Local $aresult = DllCall("user32.dll", "short", "GetAsyncKeyState", "int", $ikey)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getbkmode($hdc)
	Local $aresult = DllCall("gdi32.dll", "int", "GetBkMode", "handle", $hdc)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getclassname($hwnd)
	If NOT IsHWnd($hwnd) Then $hwnd = GUICtrlGetHandle($hwnd)
	Local $aresult = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $hwnd, "wstr", "", "int", 4096)
	If @error Then Return SetError(@error, @extended, False)
	Return SetExtended($aresult[0], $aresult[2])
EndFunc

Func _winapi_getclientheight($hwnd)
	Local $trect = _winapi_getclientrect($hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return DllStructGetData($trect, "Bottom") - DllStructGetData($trect, "Top")
EndFunc

Func _winapi_getclientwidth($hwnd)
	Local $trect = _winapi_getclientrect($hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return DllStructGetData($trect, "Right") - DllStructGetData($trect, "Left")
EndFunc

Func _winapi_getclientrect($hwnd)
	Local $trect = DllStructCreate($tagrect)
	DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hwnd, "struct*", $trect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $trect
EndFunc

Func _winapi_getcurrentprocess()
	Local $aresult = DllCall("kernel32.dll", "handle", "GetCurrentProcess")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getcurrentprocessid()
	Local $aresult = DllCall("kernel32.dll", "dword", "GetCurrentProcessId")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getcurrentthread()
	Local $aresult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getcurrentthreadid()
	Local $aresult = DllCall("kernel32.dll", "dword", "GetCurrentThreadId")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getcursorinfo()
	Local $tcursor = DllStructCreate($tagcursorinfo)
	Local $icursor = DllStructGetSize($tcursor)
	DllStructSetData($tcursor, "Size", $icursor)
	DllCall("user32.dll", "bool", "GetCursorInfo", "struct*", $tcursor)
	If @error Then Return SetError(@error, @extended, 0)
	Local $acursor[5]
	$acursor[0] = True
	$acursor[1] = DllStructGetData($tcursor, "Flags") <> 0
	$acursor[2] = DllStructGetData($tcursor, "hCursor")
	$acursor[3] = DllStructGetData($tcursor, "X")
	$acursor[4] = DllStructGetData($tcursor, "Y")
	Return $acursor
EndFunc

Func _winapi_getdc($hwnd)
	Local $aresult = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getdesktopwindow()
	Local $aresult = DllCall("user32.dll", "hwnd", "GetDesktopWindow")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getdevicecaps($hdc, $iindex)
	Local $aresult = DllCall("gdi32.dll", "int", "GetDeviceCaps", "handle", $hdc, "int", $iindex)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getdibits($hdc, $hbmp, $istartscan, $iscanlines, $pbits, $pbi, $iusage)
	Local $aresult = DllCall("gdi32.dll", "int", "GetDIBits", "handle", $hdc, "handle", $hbmp, "uint", $istartscan, "uint", $iscanlines, "ptr", $pbits, "ptr", $pbi, "uint", $iusage)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_getdlgctrlid($hwnd)
	Local $aresult = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getdlgitem($hwnd, $iitemid)
	Local $aresult = DllCall("user32.dll", "hwnd", "GetDlgItem", "hwnd", $hwnd, "int", $iitemid)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getfocus()
	Local $aresult = DllCall("user32.dll", "hwnd", "GetFocus")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getforegroundwindow()
	Local $aresult = DllCall("user32.dll", "hwnd", "GetForegroundWindow")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getguiresources($iflag = 0, $hprocess = -1)
	If $hprocess = -1 Then $hprocess = _winapi_getcurrentprocess()
	Local $aresult = DllCall("user32.dll", "dword", "GetGuiResources", "handle", $hprocess, "dword", $iflag)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_geticoninfo($hicon)
	Local $tinfo = DllStructCreate($tagiconinfo)
	DllCall("user32.dll", "bool", "GetIconInfo", "handle", $hicon, "struct*", $tinfo)
	If @error Then Return SetError(@error, @extended, 0)
	Local $aicon[6]
	$aicon[0] = True
	$aicon[1] = DllStructGetData($tinfo, "Icon") <> 0
	$aicon[2] = DllStructGetData($tinfo, "XHotSpot")
	$aicon[3] = DllStructGetData($tinfo, "YHotSpot")
	$aicon[4] = DllStructGetData($tinfo, "hMask")
	$aicon[5] = DllStructGetData($tinfo, "hColor")
	Return $aicon
EndFunc

Func _winapi_getfilesizeex($hfile)
	Local $aresult = DllCall("kernel32.dll", "bool", "GetFileSizeEx", "handle", $hfile, "int64*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[2]
EndFunc

Func _winapi_getlasterrormessage()
	Local $tbufferptr = DllStructCreate("ptr")
	Local $ncount = _winapi_formatmessage(BitOR($__winapiconstant_format_message_allocate_buffer, $__winapiconstant_format_message_from_system), 0, _winapi_getlasterror(), 0, $tbufferptr, 0, 0)
	If @error Then Return SetError(@error, 0, "")
	Local $stext = ""
	Local $pbuffer = DllStructGetData($tbufferptr, 1)
	If $pbuffer Then
		If $ncount > 0 Then
			Local $tbuffer = DllStructCreate("wchar[" & ($ncount + 1) & "]", $pbuffer)
			$stext = DllStructGetData($tbuffer, 1)
		EndIf
		_winapi_localfree($pbuffer)
	EndIf
	Return $stext
EndFunc

Func _winapi_getlayeredwindowattributes($hwnd, ByRef $i_transcolor, ByRef $transparency, $ascolorref = False)
	$i_transcolor = -1
	$transparency = -1
	Local $aresult = DllCall("user32.dll", "bool", "GetLayeredWindowAttributes", "hwnd", $hwnd, "dword*", $i_transcolor, "byte*", $transparency, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If NOT $ascolorref Then
		$aresult[2] = Int(BinaryMid($aresult[2], 3, 1) & BinaryMid($aresult[2], 2, 1) & BinaryMid($aresult[2], 1, 1))
	EndIf
	$i_transcolor = $aresult[2]
	$transparency = $aresult[3]
	Return $aresult[4]
EndFunc

Func _winapi_getmodulehandle($smodulename)
	Local $smodulenametype = "wstr"
	If $smodulename = "" Then
		$smodulename = 0
		$smodulenametype = "ptr"
	EndIf
	Local $aresult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $smodulenametype, $smodulename)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getmousepos($ftoclient = False, $hwnd = 0)
	Local $imode = Opt("MouseCoordMode", 1)
	Local $apos = MouseGetPos()
	Opt("MouseCoordMode", $imode)
	Local $tpoint = DllStructCreate($tagpoint)
	DllStructSetData($tpoint, "X", $apos[0])
	DllStructSetData($tpoint, "Y", $apos[1])
	If $ftoclient Then
		_winapi_screentoclient($hwnd, $tpoint)
		If @error Then Return SetError(@error, @extended, 0)
	EndIf
	Return $tpoint
EndFunc

Func _winapi_getmouseposx($ftoclient = False, $hwnd = 0)
	Local $tpoint = _winapi_getmousepos($ftoclient, $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return DllStructGetData($tpoint, "X")
EndFunc

Func _winapi_getmouseposy($ftoclient = False, $hwnd = 0)
	Local $tpoint = _winapi_getmousepos($ftoclient, $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return DllStructGetData($tpoint, "Y")
EndFunc

Func _winapi_getobject($hobject, $isize, $pobject)
	Local $aresult = DllCall("gdi32.dll", "int", "GetObjectW", "handle", $hobject, "int", $isize, "ptr", $pobject)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getopenfilename($stitle = "", $sfilter = "All files (*.*)", $sinitaldir = ".", $sdefaultfile = "", $sdefaultext = "", $ifilterindex = 1, $iflags = 0, $iflagsex = 0, $hwndowner = 0)
	Local $ipathlen = 4096
	Local $inulls = 0
	Local $tofn = DllStructCreate($tagopenfilename)
	Local $afiles[1] = [0]
	Local $iflag = $iflags
	Local $asflines = StringSplit($sfilter, "|")
	Local $asfilter[$asflines[0] * 2 + 1]
	Local $istart, $ifinal, $stfilter
	$asfilter[0] = $asflines[0] * 2
	For $i = 1 To $asflines[0]
		$istart = StringInStr($asflines[$i], "(", 0, 1)
		$ifinal = StringInStr($asflines[$i], ")", 0, -1)
		$asfilter[$i * 2 - 1] = StringStripWS(StringLeft($asflines[$i], $istart - 1), 3)
		$asfilter[$i * 2] = StringStripWS(StringTrimRight(StringTrimLeft($asflines[$i], $istart), StringLen($asflines[$i]) - $ifinal + 1), 3)
		$stfilter &= "wchar[" & StringLen($asfilter[$i * 2 - 1]) + 1 & "];wchar[" & StringLen($asfilter[$i * 2]) + 1 & "];"
	Next
	Local $ttitle = DllStructCreate("wchar Title[" & StringLen($stitle) + 1 & "]")
	Local $tinitialdir = DllStructCreate("wchar InitDir[" & StringLen($sinitaldir) + 1 & "]")
	Local $tfilter = DllStructCreate($stfilter & "wchar")
	Local $tpath = DllStructCreate("wchar Path[" & $ipathlen & "]")
	Local $textn = DllStructCreate("wchar Extension[" & StringLen($sdefaultext) + 1 & "]")
	For $i = 1 To $asfilter[0]
		DllStructSetData($tfilter, $i, $asfilter[$i])
	Next
	DllStructSetData($ttitle, "Title", $stitle)
	DllStructSetData($tinitialdir, "InitDir", $sinitaldir)
	DllStructSetData($tpath, "Path", $sdefaultfile)
	DllStructSetData($textn, "Extension", $sdefaultext)
	DllStructSetData($tofn, "StructSize", DllStructGetSize($tofn))
	DllStructSetData($tofn, "hwndOwner", $hwndowner)
	DllStructSetData($tofn, "lpstrFilter", DllStructGetPtr($tfilter))
	DllStructSetData($tofn, "nFilterIndex", $ifilterindex)
	DllStructSetData($tofn, "lpstrFile", DllStructGetPtr($tpath))
	DllStructSetData($tofn, "nMaxFile", $ipathlen)
	DllStructSetData($tofn, "lpstrInitialDir", DllStructGetPtr($tinitialdir))
	DllStructSetData($tofn, "lpstrTitle", DllStructGetPtr($ttitle))
	DllStructSetData($tofn, "Flags", $iflag)
	DllStructSetData($tofn, "lpstrDefExt", DllStructGetPtr($textn))
	DllStructSetData($tofn, "FlagsEx", $iflagsex)
	DllCall("comdlg32.dll", "bool", "GetOpenFileNameW", "struct*", $tofn)
	If @error Then Return SetError(@error, @extended, $afiles)
	If BitAND($iflags, $ofn_allowmultiselect) = $ofn_allowmultiselect AND BitAND($iflags, $ofn_explorer) = $ofn_explorer Then
		For $x = 1 To $ipathlen
			If DllStructGetData($tpath, "Path", $x) = Chr(0) Then
				DllStructSetData($tpath, "Path", "|", $x)
				$inulls += 1
			Else
				$inulls = 0
			EndIf
			If $inulls = 2 Then ExitLoop
		Next
		DllStructSetData($tpath, "Path", Chr(0), $x - 1)
		$afiles = StringSplit(DllStructGetData($tpath, "Path"), "|")
		If $afiles[0] = 1 Then Return __winapi_parsefiledialogpath(DllStructGetData($tpath, "Path"))
		Return StringSplit(DllStructGetData($tpath, "Path"), "|")
	ElseIf BitAND($iflags, $ofn_allowmultiselect) = $ofn_allowmultiselect Then
		$afiles = StringSplit(DllStructGetData($tpath, "Path"), " ")
		If $afiles[0] = 1 Then Return __winapi_parsefiledialogpath(DllStructGetData($tpath, "Path"))
		Return StringSplit(StringReplace(DllStructGetData($tpath, "Path"), " ", "|"), "|")
	Else
		Return __winapi_parsefiledialogpath(DllStructGetData($tpath, "Path"))
	EndIf
EndFunc

Func _winapi_getoverlappedresult($hfile, $poverlapped, ByRef $ibytes, $fwait = False)
	Local $aresult = DllCall("kernel32.dll", "bool", "GetOverlappedResult", "handle", $hfile, "ptr", $poverlapped, "dword*", 0, "bool", $fwait)
	If @error Then Return SetError(@error, @extended, False)
	$ibytes = $aresult[3]
	Return $aresult[0]
EndFunc

Func _winapi_getparent($hwnd)
	Local $aresult = DllCall("user32.dll", "hwnd", "GetParent", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getprocessaffinitymask($hprocess)
	Local $aresult = DllCall("kernel32.dll", "bool", "GetProcessAffinityMask", "handle", $hprocess, "dword_ptr*", 0, "dword_ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Local $amask[3]
	$amask[0] = True
	$amask[1] = $aresult[2]
	$amask[2] = $aresult[3]
	Return $amask
EndFunc

Func _winapi_getsavefilename($stitle = "", $sfilter = "All files (*.*)", $sinitaldir = ".", $sdefaultfile = "", $sdefaultext = "", $ifilterindex = 1, $iflags = 0, $iflagsex = 0, $hwndowner = 0)
	Local $ipathlen = 4096
	Local $tofn = DllStructCreate($tagopenfilename)
	Local $afiles[1] = [0]
	Local $iflag = $iflags
	Local $asflines = StringSplit($sfilter, "|")
	Local $asfilter[$asflines[0] * 2 + 1]
	Local $istart, $ifinal, $stfilter
	$asfilter[0] = $asflines[0] * 2
	For $i = 1 To $asflines[0]
		$istart = StringInStr($asflines[$i], "(", 0, 1)
		$ifinal = StringInStr($asflines[$i], ")", 0, -1)
		$asfilter[$i * 2 - 1] = StringStripWS(StringLeft($asflines[$i], $istart - 1), 3)
		$asfilter[$i * 2] = StringStripWS(StringTrimRight(StringTrimLeft($asflines[$i], $istart), StringLen($asflines[$i]) - $ifinal + 1), 3)
		$stfilter &= "wchar[" & StringLen($asfilter[$i * 2 - 1]) + 1 & "];wchar[" & StringLen($asfilter[$i * 2]) + 1 & "];"
	Next
	Local $ttitle = DllStructCreate("wchar Title[" & StringLen($stitle) + 1 & "]")
	Local $tinitialdir = DllStructCreate("wchar InitDir[" & StringLen($sinitaldir) + 1 & "]")
	Local $tfilter = DllStructCreate($stfilter & "wchar")
	Local $tpath = DllStructCreate("wchar Path[" & $ipathlen & "]")
	Local $textn = DllStructCreate("wchar Extension[" & StringLen($sdefaultext) + 1 & "]")
	For $i = 1 To $asfilter[0]
		DllStructSetData($tfilter, $i, $asfilter[$i])
	Next
	DllStructSetData($ttitle, "Title", $stitle)
	DllStructSetData($tinitialdir, "InitDir", $sinitaldir)
	DllStructSetData($tpath, "Path", $sdefaultfile)
	DllStructSetData($textn, "Extension", $sdefaultext)
	DllStructSetData($tofn, "StructSize", DllStructGetSize($tofn))
	DllStructSetData($tofn, "hwndOwner", $hwndowner)
	DllStructSetData($tofn, "lpstrFilter", DllStructGetPtr($tfilter))
	DllStructSetData($tofn, "nFilterIndex", $ifilterindex)
	DllStructSetData($tofn, "lpstrFile", DllStructGetPtr($tpath))
	DllStructSetData($tofn, "nMaxFile", $ipathlen)
	DllStructSetData($tofn, "lpstrInitialDir", DllStructGetPtr($tinitialdir))
	DllStructSetData($tofn, "lpstrTitle", DllStructGetPtr($ttitle))
	DllStructSetData($tofn, "Flags", $iflag)
	DllStructSetData($tofn, "lpstrDefExt", DllStructGetPtr($textn))
	DllStructSetData($tofn, "FlagsEx", $iflagsex)
	DllCall("comdlg32.dll", "bool", "GetSaveFileNameW", "struct*", $tofn)
	If @error Then Return SetError(@error, @extended, $afiles)
	Return __winapi_parsefiledialogpath(DllStructGetData($tpath, "Path"))
EndFunc

Func _winapi_getstockobject($iobject)
	Local $aresult = DllCall("gdi32.dll", "handle", "GetStockObject", "int", $iobject)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getstdhandle($istdhandle)
	If $istdhandle < 0 OR $istdhandle > 2 Then Return SetError(2, 0, -1)
	Local Const $ahandle[3] = [-10, -11, -12]
	Local $aresult = DllCall("kernel32.dll", "handle", "GetStdHandle", "dword", $ahandle[$istdhandle])
	If @error Then Return SetError(@error, @extended, -1)
	Return $aresult[0]
EndFunc

Func _winapi_getsyscolor($iindex)
	Local $aresult = DllCall("user32.dll", "dword", "GetSysColor", "int", $iindex)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getsyscolorbrush($iindex)
	Local $aresult = DllCall("user32.dll", "handle", "GetSysColorBrush", "int", $iindex)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getsystemmetrics($iindex)
	Local $aresult = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $iindex)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_gettextextentpoint32($hdc, $stext)
	Local $tsize = DllStructCreate($tagsize)
	Local $isize = StringLen($stext)
	DllCall("gdi32.dll", "bool", "GetTextExtentPoint32W", "handle", $hdc, "wstr", $stext, "int", $isize, "struct*", $tsize)
	If @error Then Return SetError(@error, @extended, 0)
	Return $tsize
EndFunc

Func _winapi_gettextmetrics($hdc)
	Local $ttextmetric = DllStructCreate($tagtextmetric)
	Local $ret = DllCall("gdi32.dll", "bool", "GetTextMetricsW", "handle", $hdc, "struct*", $ttextmetric)
	If @error Then Return SetError(@error, @extended, 0)
	If NOT $ret[0] Then Return SetError(-1, 0, 0)
	Return $ttextmetric
EndFunc

Func _winapi_getwindow($hwnd, $icmd)
	Local $aresult = DllCall("user32.dll", "hwnd", "GetWindow", "hwnd", $hwnd, "uint", $icmd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getwindowdc($hwnd)
	Local $aresult = DllCall("user32.dll", "handle", "GetWindowDC", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getwindowheight($hwnd)
	Local $trect = _winapi_getwindowrect($hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return DllStructGetData($trect, "Bottom") - DllStructGetData($trect, "Top")
EndFunc

Func _winapi_getwindowlong($hwnd, $iindex)
	Local $sfuncname = "GetWindowLongW"
	If @AutoItX64 Then $sfuncname = "GetWindowLongPtrW"
	Local $aresult = DllCall("user32.dll", "long_ptr", $sfuncname, "hwnd", $hwnd, "int", $iindex)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getwindowplacement($hwnd)
	Local $twindowplacement = DllStructCreate($tagwindowplacement)
	DllStructSetData($twindowplacement, "length", DllStructGetSize($twindowplacement))
	DllCall("user32.dll", "bool", "GetWindowPlacement", "hwnd", $hwnd, "struct*", $twindowplacement)
	If @error Then Return SetError(@error, @extended, 0)
	Return $twindowplacement
EndFunc

Func _winapi_getwindowrect($hwnd)
	Local $trect = DllStructCreate($tagrect)
	DllCall("user32.dll", "bool", "GetWindowRect", "hwnd", $hwnd, "struct*", $trect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $trect
EndFunc

Func _winapi_getwindowrgn($hwnd, $hrgn)
	Local $aresult = DllCall("user32.dll", "int", "GetWindowRgn", "hwnd", $hwnd, "handle", $hrgn)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_getwindowtext($hwnd)
	Local $aresult = DllCall("user32.dll", "int", "GetWindowTextW", "hwnd", $hwnd, "wstr", "", "int", 4096)
	If @error Then Return SetError(@error, @extended, "")
	Return SetExtended($aresult[0], $aresult[2])
EndFunc

Func _winapi_getwindowthreadprocessid($hwnd, ByRef $ipid)
	Local $aresult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hwnd, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	$ipid = $aresult[2]
	Return $aresult[0]
EndFunc

Func _winapi_getwindowwidth($hwnd)
	Local $trect = _winapi_getwindowrect($hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return DllStructGetData($trect, "Right") - DllStructGetData($trect, "Left")
EndFunc

Func _winapi_getxyfrompoint(ByRef $tpoint, ByRef $ix, ByRef $iy)
	$ix = DllStructGetData($tpoint, "X")
	$iy = DllStructGetData($tpoint, "Y")
EndFunc

Func _winapi_globalmemorystatus()
	Local $tmem = DllStructCreate($tagmemorystatusex)
	Local $imem = DllStructGetSize($tmem)
	DllStructSetData($tmem, 1, $imem)
	DllCall("kernel32.dll", "none", "GlobalMemoryStatusEx", "ptr", $tmem)
	If @error Then Return SetError(@error, @extended, 0)
	Local $amem[7]
	$amem[0] = DllStructGetData($tmem, 2)
	$amem[1] = DllStructGetData($tmem, 3)
	$amem[2] = DllStructGetData($tmem, 4)
	$amem[3] = DllStructGetData($tmem, 5)
	$amem[4] = DllStructGetData($tmem, 6)
	$amem[5] = DllStructGetData($tmem, 7)
	$amem[6] = DllStructGetData($tmem, 8)
	Return $amem
EndFunc

Func _winapi_guidfromstring($sguid)
	Local $tguid = DllStructCreate($tagguid)
	_winapi_guidfromstringex($sguid, $tguid)
	If @error Then Return SetError(@error, @extended, 0)
	Return $tguid
EndFunc

Func _winapi_guidfromstringex($sguid, $pguid)
	Local $aresult = DllCall("ole32.dll", "long", "CLSIDFromString", "wstr", $sguid, "struct*", $pguid)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_hiword($ilong)
	Return BitShift($ilong, 16)
EndFunc

Func _winapi_inprocess($hwnd, ByRef $hlastwnd)
	If $hwnd = $hlastwnd Then Return True
	For $ii = $__gainprocess_winapi[0][0] To 1 Step -1
		If $hwnd = $__gainprocess_winapi[$ii][0] Then
			If $__gainprocess_winapi[$ii][1] Then
				$hlastwnd = $hwnd
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
	Local $iprocessid
	_winapi_getwindowthreadprocessid($hwnd, $iprocessid)
	Local $icount = $__gainprocess_winapi[0][0] + 1
	If $icount >= 64 Then $icount = 1
	$__gainprocess_winapi[0][0] = $icount
	$__gainprocess_winapi[$icount][0] = $hwnd
	$__gainprocess_winapi[$icount][1] = ($iprocessid = @AutoItPID)
	Return $__gainprocess_winapi[$icount][1]
EndFunc

Func _winapi_inttofloat($iint)
	Local $tint = DllStructCreate("int")
	Local $tfloat = DllStructCreate("float", DllStructGetPtr($tint))
	DllStructSetData($tint, 1, $iint)
	Return DllStructGetData($tfloat, 1)
EndFunc

Func _winapi_isclassname($hwnd, $sclassname)
	Local $sseparator = Opt("GUIDataSeparatorChar")
	Local $aclassname = StringSplit($sclassname, $sseparator)
	If NOT IsHWnd($hwnd) Then $hwnd = GUICtrlGetHandle($hwnd)
	Local $sclasscheck = _winapi_getclassname($hwnd)
	For $x = 1 To UBound($aclassname) - 1
		If StringUpper(StringMid($sclasscheck, 1, StringLen($aclassname[$x]))) = StringUpper($aclassname[$x]) Then Return True
	Next
	Return False
EndFunc

Func _winapi_iswindow($hwnd)
	Local $aresult = DllCall("user32.dll", "bool", "IsWindow", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_iswindowvisible($hwnd)
	Local $aresult = DllCall("user32.dll", "bool", "IsWindowVisible", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_invalidaterect($hwnd, $trect = 0, $ferase = True)
	Local $aresult = DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $hwnd, "struct*", $trect, "bool", $ferase)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_lineto($hdc, $ix, $iy)
	Local $aresult = DllCall("gdi32.dll", "bool", "LineTo", "handle", $hdc, "int", $ix, "int", $iy)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_loadbitmap($hinstance, $sbitmap)
	Local $sbitmaptype = "int"
	If IsString($sbitmap) Then $sbitmaptype = "wstr"
	Local $aresult = DllCall("user32.dll", "handle", "LoadBitmapW", "handle", $hinstance, $sbitmaptype, $sbitmap)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_loadimage($hinstance, $simage, $itype, $ixdesired, $iydesired, $iload)
	Local $aresult, $simagetype = "int"
	If IsString($simage) Then $simagetype = "wstr"
	$aresult = DllCall("user32.dll", "handle", "LoadImageW", "handle", $hinstance, $simagetype, $simage, "uint", $itype, "int", $ixdesired, "int", $iydesired, "uint", $iload)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_loadlibrary($sfilename)
	Local $aresult = DllCall("kernel32.dll", "handle", "LoadLibraryW", "wstr", $sfilename)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_loadlibraryex($sfilename, $iflags = 0)
	Local $aresult = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sfilename, "ptr", 0, "dword", $iflags)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_loadshell32icon($iiconid)
	Local $ticons = DllStructCreate("ptr Data")
	Local $iicons = _winapi_extracticonex("shell32.dll", $iiconid, 0, $ticons, 1)
	If @error Then Return SetError(@error, @extended, 0)
	If $iicons <= 0 Then Return SetError(1, 0, 0)
	Return DllStructGetData($ticons, "Data")
EndFunc

Func _winapi_loadstring($hinstance, $istringid)
	Local $aresult = DllCall("user32.dll", "int", "LoadStringW", "handle", $hinstance, "uint", $istringid, "wstr", "", "int", 4096)
	If @error Then Return SetError(@error, @extended, "")
	Return SetExtended($aresult[0], $aresult[3])
EndFunc

Func _winapi_localfree($hmem)
	Local $aresult = DllCall("kernel32.dll", "handle", "LocalFree", "handle", $hmem)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_loword($ilong)
	Return BitAND($ilong, 65535)
EndFunc

Func _winapi_makelangid($lgidprimary, $lgidsub)
	Return BitOR(BitShift($lgidsub, -10), $lgidprimary)
EndFunc

Func _winapi_makelcid($lgid, $srtid)
	Return BitOR(BitShift($srtid, -16), $lgid)
EndFunc

Func _winapi_makelong($ilo, $ihi)
	Return BitOR(BitShift($ihi, -16), BitAND($ilo, 65535))
EndFunc

Func _winapi_makeqword($lodword, $hidword)
	Local $tint64 = DllStructCreate("uint64")
	Local $tdwords = DllStructCreate("dword;dword", DllStructGetPtr($tint64))
	DllStructSetData($tdwords, 1, $lodword)
	DllStructSetData($tdwords, 2, $hidword)
	Return DllStructGetData($tint64, 1)
EndFunc

Func _winapi_messagebeep($itype = 1)
	Local $isound
	Switch $itype
		Case 1
			$isound = 0
		Case 2
			$isound = 16
		Case 3
			$isound = 32
		Case 4
			$isound = 48
		Case 5
			$isound = 64
		Case Else
			$isound = -1
	EndSwitch
	Local $aresult = DllCall("user32.dll", "bool", "MessageBeep", "uint", $isound)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_msgbox($iflags, $stitle, $stext)
	BlockInput(0)
	MsgBox($iflags, $stitle, $stext & "      ")
EndFunc

Func _winapi_mouse_event($iflags, $ix = 0, $iy = 0, $idata = 0, $iextrainfo = 0)
	DllCall("user32.dll", "none", "mouse_event", "dword", $iflags, "dword", $ix, "dword", $iy, "dword", $idata, "ulong_ptr", $iextrainfo)
	If @error Then Return SetError(@error, @extended)
EndFunc

Func _winapi_moveto($hdc, $ix, $iy)
	Local $aresult = DllCall("gdi32.dll", "bool", "MoveToEx", "handle", $hdc, "int", $ix, "int", $iy, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_movewindow($hwnd, $ix, $iy, $iwidth, $iheight, $frepaint = True)
	Local $aresult = DllCall("user32.dll", "bool", "MoveWindow", "hwnd", $hwnd, "int", $ix, "int", $iy, "int", $iwidth, "int", $iheight, "bool", $frepaint)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_muldiv($inumber, $inumerator, $idenominator)
	Local $aresult = DllCall("kernel32.dll", "int", "MulDiv", "int", $inumber, "int", $inumerator, "int", $idenominator)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aresult[0]
EndFunc

Func _winapi_multibytetowidechar($stext, $icodepage = 0, $iflags = 0, $bretstring = False)
	Local $stexttype = "str"
	If NOT IsString($stext) Then $stexttype = "struct*"
	Local $aresult = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $icodepage, "dword", $iflags, $stexttype, $stext, "int", -1, "ptr", 0, "int", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Local $iout = $aresult[0]
	Local $tout = DllStructCreate("wchar[" & $iout & "]")
	$aresult = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $icodepage, "dword", $iflags, $stexttype, $stext, "int", -1, "struct*", $tout, "int", $iout)
	If @error Then Return SetError(@error, @extended, 0)
	If $bretstring Then Return DllStructGetData($tout, 1)
	Return $tout
EndFunc

Func _winapi_multibytetowidecharex($stext, $ptext, $icodepage = 0, $iflags = 0)
	Local $aresult = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "uint", $icodepage, "dword", $iflags, "STR", $stext, "int", -1, "struct*", $ptext, "int", (StringLen($stext) + 1) * 2)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_openprocess($iaccess, $finherit, $iprocessid, $fdebugpriv = False)
	Local $aresult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iaccess, "bool", $finherit, "dword", $iprocessid)
	If @error Then Return SetError(@error, @extended, 0)
	If $aresult[0] Then Return $aresult[0]
	If NOT $fdebugpriv Then Return 0
	Local $htoken = _security__openthreadtokenex(BitOR($token_adjust_privileges, $token_query))
	If @error Then Return SetError(@error, @extended, 0)
	_security__setprivilege($htoken, "SeDebugPrivilege", True)
	Local $ierror = @error
	Local $ilasterror = @extended
	Local $iret = 0
	If NOT @error Then
		$aresult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iaccess, "bool", $finherit, "dword", $iprocessid)
		$ierror = @error
		$ilasterror = @extended
		If $aresult[0] Then $iret = $aresult[0]
		_security__setprivilege($htoken, "SeDebugPrivilege", False)
		If @error Then
			$ierror = @error
			$ilasterror = @extended
		EndIf
	EndIf
	_winapi_closehandle($htoken)
	Return SetError($ierror, $ilasterror, $iret)
EndFunc

Func __winapi_parsefiledialogpath($spath)
	Local $afiles[3]
	$afiles[0] = 2
	Local $stemp = StringMid($spath, 1, StringInStr($spath, "\", 0, -1) - 1)
	$afiles[1] = $stemp
	$afiles[2] = StringMid($spath, StringInStr($spath, "\", 0, -1) + 1)
	Return $afiles
EndFunc

Func _winapi_pathfindonpath(Const $szfile, $aextrapaths = "", Const $szpathdelimiter = @LF)
	Local $iextracount = 0
	If IsString($aextrapaths) Then
		If StringLen($aextrapaths) Then
			$aextrapaths = StringSplit($aextrapaths, $szpathdelimiter, 1 + 2)
			$iextracount = UBound($aextrapaths, 1)
		EndIf
	ElseIf IsArray($aextrapaths) Then
		$iextracount = UBound($aextrapaths)
	EndIf
	Local $tpaths, $tpathptrs
	If $iextracount Then
		Local $szstruct = ""
		For $path In $aextrapaths
			$szstruct &= "wchar[" & StringLen($path) + 1 & "];"
		Next
		$tpaths = DllStructCreate($szstruct)
		$tpathptrs = DllStructCreate("ptr[" & $iextracount + 1 & "]")
		For $i = 1 To $iextracount
			DllStructSetData($tpaths, $i, $aextrapaths[$i - 1])
			DllStructSetData($tpathptrs, 1, DllStructGetPtr($tpaths, $i), $i)
		Next
		DllStructSetData($tpathptrs, 1, Ptr(0), $iextracount + 1)
	EndIf
	Local $aresult = DllCall("shlwapi.dll", "bool", "PathFindOnPathW", "wstr", $szfile, "struct*", $tpathptrs)
	If @error Then Return SetError(@error, @extended, False)
	If $aresult[0] = 0 Then Return SetError(1, 0, $szfile)
	Return $aresult[1]
EndFunc

Func _winapi_pointfromrect(ByRef $trect, $fcenter = True)
	Local $ix1 = DllStructGetData($trect, "Left")
	Local $iy1 = DllStructGetData($trect, "Top")
	Local $ix2 = DllStructGetData($trect, "Right")
	Local $iy2 = DllStructGetData($trect, "Bottom")
	If $fcenter Then
		$ix1 = $ix1 + (($ix2 - $ix1) / 2)
		$iy1 = $iy1 + (($iy2 - $iy1) / 2)
	EndIf
	Local $tpoint = DllStructCreate($tagpoint)
	DllStructSetData($tpoint, "X", $ix1)
	DllStructSetData($tpoint, "Y", $iy1)
	Return $tpoint
EndFunc

Func _winapi_postmessage($hwnd, $imsg, $iwparam, $ilparam)
	Local $aresult = DllCall("user32.dll", "bool", "PostMessage", "hwnd", $hwnd, "uint", $imsg, "wparam", $iwparam, "lparam", $ilparam)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_primarylangid($lgid)
	Return BitAND($lgid, 1023)
EndFunc

Func _winapi_ptinrect(ByRef $trect, ByRef $tpoint)
	Local $aresult = DllCall("user32.dll", "bool", "PtInRect", "struct*", $trect, "struct", $tpoint)
	If @error Then Return SetError(1, @extended, False)
	Return NOT ($aresult[0] = 0)
EndFunc

Func _winapi_readfile($hfile, $pbuffer, $itoread, ByRef $iread, $poverlapped = 0)
	Local $aresult = DllCall("kernel32.dll", "bool", "ReadFile", "handle", $hfile, "ptr", $pbuffer, "dword", $itoread, "dword*", 0, "ptr", $poverlapped)
	If @error Then Return SetError(@error, @extended, False)
	$iread = $aresult[4]
	Return $aresult[0]
EndFunc

Func _winapi_readprocessmemory($hprocess, $pbaseaddress, $pbuffer, $isize, ByRef $iread)
	Local $aresult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $hprocess, "ptr", $pbaseaddress, "ptr", $pbuffer, "ulong_ptr", $isize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	$iread = $aresult[5]
	Return $aresult[0]
EndFunc

Func _winapi_rectisempty(ByRef $trect)
	Return (DllStructGetData($trect, "Left") = 0) AND (DllStructGetData($trect, "Top") = 0) AND (DllStructGetData($trect, "Right") = 0) AND (DllStructGetData($trect, "Bottom") = 0)
EndFunc

Func _winapi_redrawwindow($hwnd, $trect = 0, $hregion = 0, $iflags = 5)
	Local $aresult = DllCall("user32.dll", "bool", "RedrawWindow", "hwnd", $hwnd, "struct*", $trect, "handle", $hregion, "uint", $iflags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_registerwindowmessage($smessage)
	Local $aresult = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $smessage)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_releasecapture()
	Local $aresult = DllCall("user32.dll", "bool", "ReleaseCapture")
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_releasedc($hwnd, $hdc)
	Local $aresult = DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hwnd, "handle", $hdc)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_screentoclient($hwnd, ByRef $tpoint)
	Local $aresult = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $hwnd, "struct*", $tpoint)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_selectobject($hdc, $hgdiobj)
	Local $aresult = DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hdc, "handle", $hgdiobj)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setbkcolor($hdc, $icolor)
	Local $aresult = DllCall("gdi32.dll", "INT", "SetBkColor", "handle", $hdc, "dword", $icolor)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aresult[0]
EndFunc

Func _winapi_setbkmode($hdc, $ibkmode)
	Local $aresult = DllCall("gdi32.dll", "int", "SetBkMode", "handle", $hdc, "int", $ibkmode)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_setcapture($hwnd)
	Local $aresult = DllCall("user32.dll", "hwnd", "SetCapture", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_setcursor($hcursor)
	Local $aresult = DllCall("user32.dll", "handle", "SetCursor", "handle", $hcursor)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_setdefaultprinter($sprinter)
	Local $aresult = DllCall("winspool.drv", "bool", "SetDefaultPrinterW", "wstr", $sprinter)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setdibits($hdc, $hbmp, $istartscan, $iscanlines, $pbits, $pbmi, $icoloruse = 0)
	Local $aresult = DllCall("gdi32.dll", "int", "SetDIBits", "handle", $hdc, "handle", $hbmp, "uint", $istartscan, "uint", $iscanlines, "ptr", $pbits, "ptr", $pbmi, "uint", $icoloruse)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setendoffile($hfile)
	Local $aresult = DllCall("kernel32.dll", "bool", "SetEndOfFile", "handle", $hfile)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setevent($hevent)
	Local $aresult = DllCall("kernel32.dll", "bool", "SetEvent", "handle", $hevent)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setfilepointer($hfile, $ipos, $imethod = 0)
	Local $aresult = DllCall("kernel32.dll", "INT", "SetFilePointer", "handle", $hfile, "long", $ipos, "ptr", 0, "long", $imethod)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aresult[0]
EndFunc

Func _winapi_setfocus($hwnd)
	Local $aresult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_setfont($hwnd, $hfont, $fredraw = True)
	_sendmessage($hwnd, $__winapiconstant_wm_setfont, $hfont, $fredraw, 0, "hwnd")
EndFunc

Func _winapi_sethandleinformation($hobject, $imask, $iflags)
	Local $aresult = DllCall("kernel32.dll", "bool", "SetHandleInformation", "handle", $hobject, "dword", $imask, "dword", $iflags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setlayeredwindowattributes($hwnd, $i_transcolor, $transparency = 255, $dwflags = 3, $iscolorref = False)
	If $dwflags = Default OR $dwflags = "" OR $dwflags < 0 Then $dwflags = 3
	If NOT $iscolorref Then
		$i_transcolor = Int(BinaryMid($i_transcolor, 3, 1) & BinaryMid($i_transcolor, 2, 1) & BinaryMid($i_transcolor, 1, 1))
	EndIf
	Local $aresult = DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $hwnd, "dword", $i_transcolor, "byte", $transparency, "dword", $dwflags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setparent($hwndchild, $hwndparent)
	Local $aresult = DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $hwndchild, "hwnd", $hwndparent)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_setprocessaffinitymask($hprocess, $imask)
	Local $aresult = DllCall("kernel32.dll", "bool", "SetProcessAffinityMask", "handle", $hprocess, "ulong_ptr", $imask)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setsyscolors($velements, $vcolors)
	Local $isearray = IsArray($velements), $iscarray = IsArray($vcolors)
	Local $ielementnum
	If NOT $iscarray AND NOT $isearray Then
		$ielementnum = 1
	ElseIf $iscarray OR $isearray Then
		If NOT $iscarray OR NOT $isearray Then Return SetError(-1, -1, False)
		If UBound($velements) <> UBound($vcolors) Then Return SetError(-1, -1, False)
		$ielementnum = UBound($velements)
	EndIf
	Local $telements = DllStructCreate("int Element[" & $ielementnum & "]")
	Local $tcolors = DllStructCreate("dword NewColor[" & $ielementnum & "]")
	If NOT $isearray Then
		DllStructSetData($telements, "Element", $velements, 1)
	Else
		For $x = 0 To $ielementnum - 1
			DllStructSetData($telements, "Element", $velements[$x], $x + 1)
		Next
	EndIf
	If NOT $iscarray Then
		DllStructSetData($tcolors, "NewColor", $vcolors, 1)
	Else
		For $x = 0 To $ielementnum - 1
			DllStructSetData($tcolors, "NewColor", $vcolors[$x], $x + 1)
		Next
	EndIf
	Local $aresult = DllCall("user32.dll", "bool", "SetSysColors", "int", $ielementnum, "struct*", $telements, "struct*", $tcolors)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_settextcolor($hdc, $icolor)
	Local $aresult = DllCall("gdi32.dll", "INT", "SetTextColor", "handle", $hdc, "dword", $icolor)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aresult[0]
EndFunc

Func _winapi_setwindowlong($hwnd, $iindex, $ivalue)
	_winapi_setlasterror(0)
	Local $sfuncname = "SetWindowLongW"
	If @AutoItX64 Then $sfuncname = "SetWindowLongPtrW"
	Local $aresult = DllCall("user32.dll", "long_ptr", $sfuncname, "hwnd", $hwnd, "int", $iindex, "long_ptr", $ivalue)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_setwindowplacement($hwnd, $pwindowplacement)
	Local $aresult = DllCall("user32.dll", "bool", "SetWindowPlacement", "hwnd", $hwnd, "ptr", $pwindowplacement)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setwindowpos($hwnd, $hafter, $ix, $iy, $icx, $icy, $iflags)
	Local $aresult = DllCall("user32.dll", "bool", "SetWindowPos", "hwnd", $hwnd, "hwnd", $hafter, "int", $ix, "int", $iy, "int", $icx, "int", $icy, "uint", $iflags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setwindowrgn($hwnd, $hrgn, $bredraw = True)
	Local $aresult = DllCall("user32.dll", "int", "SetWindowRgn", "hwnd", $hwnd, "handle", $hrgn, "bool", $bredraw)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_setwindowshookex($idhook, $lpfn, $hmod, $dwthreadid = 0)
	Local $aresult = DllCall("user32.dll", "handle", "SetWindowsHookEx", "int", $idhook, "ptr", $lpfn, "handle", $hmod, "dword", $dwthreadid)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_setwindowtext($hwnd, $stext)
	Local $aresult = DllCall("user32.dll", "bool", "SetWindowTextW", "hwnd", $hwnd, "wstr", $stext)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_showcursor($fshow)
	Local $aresult = DllCall("user32.dll", "int", "ShowCursor", "bool", $fshow)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_showerror($stext, $fexit = True)
	_winapi_msgbox(266256, "Error", $stext)
	If $fexit Then Exit
EndFunc

Func _winapi_showmsg($stext)
	_winapi_msgbox(64 + 4096, "Information", $stext)
EndFunc

Func _winapi_showwindow($hwnd, $icmdshow = 5)
	Local $aresult = DllCall("user32.dll", "bool", "ShowWindow", "hwnd", $hwnd, "int", $icmdshow)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_stringfromguid($pguid)
	Local $aresult = DllCall("ole32.dll", "int", "StringFromGUID2", "struct*", $pguid, "wstr", "", "int", 40)
	If @error Then Return SetError(@error, @extended, "")
	Return SetExtended($aresult[0], $aresult[2])
EndFunc

Func _winapi_stringlena($vstring)
	Local $acall = DllCall("kernel32.dll", "int", "lstrlenA", "struct*", $vstring)
	If @error Then Return SetError(1, @extended, 0)
	Return $acall[0]
EndFunc

Func _winapi_stringlenw($vstring)
	Local $acall = DllCall("kernel32.dll", "int", "lstrlenW", "struct*", $vstring)
	If @error Then Return SetError(1, @extended, 0)
	Return $acall[0]
EndFunc

Func _winapi_sublangid($lgid)
	Return BitShift($lgid, 10)
EndFunc

Func _winapi_systemparametersinfo($iaction, $iparam = 0, $vparam = 0, $iwinini = 0)
	Local $aresult = DllCall("user32.dll", "bool", "SystemParametersInfoW", "uint", $iaction, "uint", $iparam, "ptr", $vparam, "uint", $iwinini)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_twipsperpixelx()
	Local $lngdc, $twipsperpixelx
	$lngdc = _winapi_getdc(0)
	$twipsperpixelx = 1440 / _winapi_getdevicecaps($lngdc, $__winapiconstant_logpixelsx)
	_winapi_releasedc(0, $lngdc)
	Return $twipsperpixelx
EndFunc

Func _winapi_twipsperpixely()
	Local $lngdc, $twipsperpixely
	$lngdc = _winapi_getdc(0)
	$twipsperpixely = 1440 / _winapi_getdevicecaps($lngdc, $__winapiconstant_logpixelsy)
	_winapi_releasedc(0, $lngdc)
	Return $twipsperpixely
EndFunc

Func _winapi_unhookwindowshookex($hhk)
	Local $aresult = DllCall("user32.dll", "bool", "UnhookWindowsHookEx", "handle", $hhk)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_updatelayeredwindow($hwnd, $hdcdest, $pptdest, $psize, $hdcsrce, $pptsrce, $irgb, $pblend, $iflags)
	Local $aresult = DllCall("user32.dll", "bool", "UpdateLayeredWindow", "hwnd", $hwnd, "handle", $hdcdest, "ptr", $pptdest, "ptr", $psize, "handle", $hdcsrce, "ptr", $pptsrce, "dword", $irgb, "ptr", $pblend, "dword", $iflags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_updatewindow($hwnd)
	Local $aresult = DllCall("user32.dll", "bool", "UpdateWindow", "hwnd", $hwnd)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_waitforinputidle($hprocess, $itimeout = -1)
	Local $aresult = DllCall("user32.dll", "dword", "WaitForInputIdle", "handle", $hprocess, "dword", $itimeout)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_waitformultipleobjects($icount, $phandles, $fwaitall = False, $itimeout = -1)
	Local $aresult = DllCall("kernel32.dll", "INT", "WaitForMultipleObjects", "dword", $icount, "ptr", $phandles, "bool", $fwaitall, "dword", $itimeout)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aresult[0]
EndFunc

Func _winapi_waitforsingleobject($hhandle, $itimeout = -1)
	Local $aresult = DllCall("kernel32.dll", "INT", "WaitForSingleObject", "handle", $hhandle, "dword", $itimeout)
	If @error Then Return SetError(@error, @extended, -1)
	Return $aresult[0]
EndFunc

Func _winapi_widechartomultibyte($punicode, $icodepage = 0, $bretstring = True)
	Local $sunicodetype = "wstr"
	If NOT IsString($punicode) Then $sunicodetype = "struct*"
	Local $aresult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $icodepage, "dword", 0, $sunicodetype, $punicode, "int", -1, "ptr", 0, "int", 0, "ptr", 0, "ptr", 0)
	If @error Then Return SetError(@error, @extended, "")
	Local $tmultibyte = DllStructCreate("char[" & $aresult[0] & "]")
	$aresult = DllCall("kernel32.dll", "int", "WideCharToMultiByte", "uint", $icodepage, "dword", 0, $sunicodetype, $punicode, "int", -1, "struct*", $tmultibyte, "int", $aresult[0], "ptr", 0, "ptr", 0)
	If @error Then Return SetError(@error, @extended, "")
	If $bretstring Then Return DllStructGetData($tmultibyte, 1)
	Return $tmultibyte
EndFunc

Func _winapi_windowfrompoint(ByRef $tpoint)
	Local $aresult = DllCall("user32.dll", "hwnd", "WindowFromPoint", "struct", $tpoint)
	If @error Then Return SetError(1, @extended, 0)
	Return $aresult[0]
EndFunc

Func _winapi_writeconsole($hconsole, $stext)
	Local $aresult = DllCall("kernel32.dll", "bool", "WriteConsoleW", "handle", $hconsole, "wstr", $stext, "dword", StringLen($stext), "dword*", 0, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _winapi_writefile($hfile, $pbuffer, $itowrite, ByRef $iwritten, $poverlapped = 0)
	Local $aresult = DllCall("kernel32.dll", "bool", "WriteFile", "handle", $hfile, "ptr", $pbuffer, "dword", $itowrite, "dword*", 0, "ptr", $poverlapped)
	If @error Then Return SetError(@error, @extended, False)
	$iwritten = $aresult[4]
	Return $aresult[0]
EndFunc

Func _winapi_writeprocessmemory($hprocess, $pbaseaddress, $pbuffer, $isize, ByRef $iwritten, $sbuffer = "ptr")
	Local $aresult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", $hprocess, "ptr", $pbaseaddress, $sbuffer, $pbuffer, "ulong_ptr", $isize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	$iwritten = $aresult[5]
	Return $aresult[0]
EndFunc

Func _security__adjusttokenprivileges($htoken, $fdisableall, $pnewstate, $ibufferlen, $pprevstate = 0, $prequired = 0)
	Local $acall = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $htoken, "bool", $fdisableall, "struct*", $pnewstate, "dword", $ibufferlen, "struct*", $pprevstate, "struct*", $prequired)
	If @error Then Return SetError(1, @extended, False)
	Return NOT ($acall[0] = 0)
EndFunc

Func _security__createprocesswithtoken($htoken, $ilogonflags, $scommandline, $icreationflags, $scurdir, $tstartupinfo, $tprocess_information)
	Local $acall = DllCall("advapi32.dll", "bool", "CreateProcessWithTokenW", "handle", $htoken, "dword", $ilogonflags, "ptr", 0, "wstr", $scommandline, "dword", $icreationflags, "struct*", 0, "wstr", $scurdir, "struct*", $tstartupinfo, "struct*", $tprocess_information)
	If @error OR NOT $acall[0] Then Return SetError(1, @extended, False)
	Return True
EndFunc

Func _security__duplicatetokenex($hexistingtoken, $idesiredaccess, $iimpersonationlevel, $itokentype)
	Local $acall = DllCall("advapi32.dll", "bool", "DuplicateTokenEx", "handle", $hexistingtoken, "dword", $idesiredaccess, "struct*", 0, "int", $iimpersonationlevel, "int", $itokentype, "handle*", 0)
	If @error OR NOT $acall[0] Then Return SetError(1, @extended, 0)
	Return $acall[6]
EndFunc

Func _security__getaccountsid($saccount, $ssystem = "")
	Local $aacct = _security__lookupaccountname($saccount, $ssystem)
	If @error Then Return SetError(@error, @extended, 0)
	If IsArray($aacct) Then Return _security__stringsidtosid($aacct[0])
	Return ""
EndFunc

Func _security__getlengthsid($psid)
	If NOT _security__isvalidsid($psid) Then Return SetError(1, @extended, 0)
	Local $acall = DllCall("advapi32.dll", "dword", "GetLengthSid", "struct*", $psid)
	If @error Then Return SetError(2, @extended, 0)
	Return $acall[0]
EndFunc

Func _security__gettokeninformation($htoken, $iclass)
	Local $acall = DllCall("advapi32.dll", "bool", "GetTokenInformation", "handle", $htoken, "int", $iclass, "struct*", 0, "dword", 0, "dword*", 0)
	If @error OR NOT $acall[5] Then Return SetError(1, @extended, 0)
	Local $ilen = $acall[5]
	Local $tbuffer = DllStructCreate("byte[" & $ilen & "]")
	$acall = DllCall("advapi32.dll", "bool", "GetTokenInformation", "handle", $htoken, "int", $iclass, "struct*", $tbuffer, "dword", DllStructGetSize($tbuffer), "dword*", 0)
	If @error OR NOT $acall[0] Then Return SetError(2, @extended, 0)
	Return $tbuffer
EndFunc

Func _security__impersonateself($ilevel = $securityimpersonation)
	Local $acall = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $ilevel)
	If @error Then Return SetError(1, @extended, False)
	Return NOT ($acall[0] = 0)
EndFunc

Func _security__isvalidsid($psid)
	Local $acall = DllCall("advapi32.dll", "bool", "IsValidSid", "struct*", $psid)
	If @error Then Return SetError(1, @extended, False)
	Return NOT ($acall[0] = 0)
EndFunc

Func _security__lookupaccountname($saccount, $ssystem = "")
	Local $tdata = DllStructCreate("byte SID[256]")
	Local $acall = DllCall("advapi32.dll", "bool", "LookupAccountNameW", "wstr", $ssystem, "wstr", $saccount, "struct*", $tdata, "dword*", DllStructGetSize($tdata), "wstr", "", "dword*", DllStructGetSize($tdata), "int*", 0)
	If @error OR NOT $acall[0] Then Return SetError(1, @extended, 0)
	Local $aacct[3]
	$aacct[0] = _security__sidtostringsid(DllStructGetPtr($tdata, "SID"))
	$aacct[1] = $acall[5]
	$aacct[2] = $acall[7]
	Return $aacct
EndFunc

Func _security__lookupaccountsid($vsid, $ssystem = "")
	Local $psid, $aacct[3]
	If IsString($vsid) Then
		$psid = _security__stringsidtosid($vsid)
	Else
		$psid = $vsid
	EndIf
	If NOT _security__isvalidsid($psid) Then Return SetError(1, @extended, 0)
	Local $typesystem = "ptr"
	If $ssystem Then $typesystem = "wstr"
	Local $acall = DllCall("advapi32.dll", "bool", "LookupAccountSidW", $typesystem, $ssystem, "struct*", $psid, "wstr", "", "dword*", 65536, "wstr", "", "dword*", 65536, "int*", 0)
	If @error OR NOT $acall[0] Then Return SetError(2, @extended, 0)
	Local $aacct[3]
	$aacct[0] = $acall[3]
	$aacct[1] = $acall[5]
	$aacct[2] = $acall[7]
	Return $aacct
EndFunc

Func _security__lookupprivilegevalue($ssystem, $sname)
	Local $acall = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $ssystem, "wstr", $sname, "int64*", 0)
	If @error OR NOT $acall[0] Then Return SetError(1, @extended, 0)
	Return $acall[3]
EndFunc

Func _security__openprocesstoken($hprocess, $iaccess)
	Local $acall = DllCall("advapi32.dll", "bool", "OpenProcessToken", "handle", $hprocess, "dword", $iaccess, "handle*", 0)
	If @error OR NOT $acall[0] Then Return SetError(1, @extended, 0)
	Return $acall[3]
EndFunc

Func _security__openthreadtoken($iaccess, $hthread = 0, $fopenasself = False)
	If $hthread = 0 Then $hthread = _winapi_getcurrentthread()
	If @error Then Return SetError(1, @extended, 0)
	Local $acall = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hthread, "dword", $iaccess, "bool", $fopenasself, "handle*", 0)
	If @error OR NOT $acall[0] Then Return SetError(2, @extended, 0)
	Return $acall[4]
EndFunc

Func _security__openthreadtokenex($iaccess, $hthread = 0, $fopenasself = False)
	Local $htoken = _security__openthreadtoken($iaccess, $hthread, $fopenasself)
	If $htoken = 0 Then
		If _winapi_getlasterror() <> $error_no_token Then Return SetError(3, _winapi_getlasterror(), 0)
		If NOT _security__impersonateself() Then Return SetError(1, _winapi_getlasterror(), 0)
		$htoken = _security__openthreadtoken($iaccess, $hthread, $fopenasself)
		If $htoken = 0 Then Return SetError(2, _winapi_getlasterror(), 0)
	EndIf
	Return $htoken
EndFunc

Func _security__setprivilege($htoken, $sprivilege, $fenable)
	Local $iluid = _security__lookupprivilegevalue("", $sprivilege)
	If $iluid = 0 Then Return SetError(1, @extended, False)
	Local $tcurrstate = DllStructCreate($tagtoken_privileges)
	Local $icurrstate = DllStructGetSize($tcurrstate)
	Local $tprevstate = DllStructCreate($tagtoken_privileges)
	Local $iprevstate = DllStructGetSize($tprevstate)
	Local $trequired = DllStructCreate("int Data")
	DllStructSetData($tcurrstate, "Count", 1)
	DllStructSetData($tcurrstate, "LUID", $iluid)
	If NOT _security__adjusttokenprivileges($htoken, False, $tcurrstate, $icurrstate, $tprevstate, $trequired) Then Return SetError(2, @error, False)
	DllStructSetData($tprevstate, "Count", 1)
	DllStructSetData($tprevstate, "LUID", $iluid)
	Local $iattributes = DllStructGetData($tprevstate, "Attributes")
	If $fenable Then
		$iattributes = BitOR($iattributes, $se_privilege_enabled)
	Else
		$iattributes = BitAND($iattributes, BitNOT($se_privilege_enabled))
	EndIf
	DllStructSetData($tprevstate, "Attributes", $iattributes)
	If NOT _security__adjusttokenprivileges($htoken, False, $tprevstate, $iprevstate, $tcurrstate, $trequired) Then Return SetError(3, @error, False)
	Return True
EndFunc

Func _security__settokeninformation($htoken, $itokeninformation, $vtokeninformation, $itokeninformationlength)
	Local $acall = DllCall("advapi32.dll", "bool", "SetTokenInformation", "handle", $htoken, "int", $itokeninformation, "struct*", $vtokeninformation, "dword", $itokeninformationlength)
	If @error OR NOT $acall[0] Then Return SetError(1, @extended, False)
	Return True
EndFunc

Func _security__sidtostringsid($psid)
	If NOT _security__isvalidsid($psid) Then Return SetError(1, 0, "")
	Local $acall = DllCall("advapi32.dll", "bool", "ConvertSidToStringSidW", "struct*", $psid, "ptr*", 0)
	If @error OR NOT $acall[0] Then Return SetError(2, @extended, "")
	Local $pstringsid = $acall[2]
	Local $ssid = DllStructGetData(DllStructCreate("wchar Text[" & _winapi_stringlenw($pstringsid) + 1 & "]", $pstringsid), "Text")
	_winapi_localfree($pstringsid)
	Return $ssid
EndFunc

Func _security__sidtypestr($itype)
	Switch $itype
		Case $sidtypeuser
			Return "User"
		Case $sidtypegroup
			Return "Group"
		Case $sidtypedomain
			Return "Domain"
		Case $sidtypealias
			Return "Alias"
		Case $sidtypewellknowngroup
			Return "Well Known Group"
		Case $sidtypedeletedaccount
			Return "Deleted Account"
		Case $sidtypeinvalid
			Return "Invalid"
		Case $sidtypeunknown
			Return "Unknown Type"
		Case $sidtypecomputer
			Return "Computer"
		Case $sidtypelabel
			Return "A mandatory integrity label SID"
		Case Else
			Return "Unknown SID Type"
	EndSwitch
EndFunc

Func _security__stringsidtosid($ssid)
	Local $acall = DllCall("advapi32.dll", "bool", "ConvertStringSidToSidW", "wstr", $ssid, "ptr*", 0)
	If @error OR NOT $acall[0] Then Return SetError(1, @extended, 0)
	Local $psid = $acall[2]
	Local $tbuffer = DllStructCreate("byte Data[" & _security__getlengthsid($psid) & "]", $psid)
	Local $tsid = DllStructCreate("byte Data[" & DllStructGetSize($tbuffer) & "]")
	DllStructSetData($tsid, "Data", DllStructGetData($tbuffer, "Data"))
	_winapi_localfree($psid)
	Return $tsid
EndFunc

Global Const $tagmemmap = "handle hProc;ulong_ptr Size;ptr Mem"

Func _memfree(ByRef $tmemmap)
	Local $pmemory = DllStructGetData($tmemmap, "Mem")
	Local $hprocess = DllStructGetData($tmemmap, "hProc")
	Local $bresult = _memvirtualfreeex($hprocess, $pmemory, 0, $mem_release)
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hprocess)
	If @error Then Return SetError(@error, @extended, False)
	Return $bresult
EndFunc

Func _memglobalalloc($ibytes, $iflags = 0)
	Local $aresult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $iflags, "ulong_ptr", $ibytes)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _memglobalfree($hmem)
	Local $aresult = DllCall("kernel32.dll", "ptr", "GlobalFree", "handle", $hmem)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _memgloballock($hmem)
	Local $aresult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hmem)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _memglobalsize($hmem)
	Local $aresult = DllCall("kernel32.dll", "ulong_ptr", "GlobalSize", "handle", $hmem)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _memglobalunlock($hmem)
	Local $aresult = DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hmem)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _meminit($hwnd, $isize, ByRef $tmemmap)
	Local $aresult = DllCall("User32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hwnd, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Local $iprocessid = $aresult[2]
	If $iprocessid = 0 Then Return SetError(1, 0, 0)
	Local $iaccess = BitOR($process_vm_operation, $process_vm_read, $process_vm_write)
	Local $hprocess = __mem_openprocess($iaccess, False, $iprocessid, True)
	Local $ialloc = BitOR($mem_reserve, $mem_commit)
	Local $pmemory = _memvirtualallocex($hprocess, 0, $isize, $ialloc, $page_readwrite)
	If $pmemory = 0 Then Return SetError(2, 0, 0)
	$tmemmap = DllStructCreate($tagmemmap)
	DllStructSetData($tmemmap, "hProc", $hprocess)
	DllStructSetData($tmemmap, "Size", $isize)
	DllStructSetData($tmemmap, "Mem", $pmemory)
	Return $pmemory
EndFunc

Func _memmovememory($psource, $pdest, $ilength)
	DllCall("kernel32.dll", "none", "RtlMoveMemory", "struct*", $pdest, "struct*", $psource, "ulong_ptr", $ilength)
	If @error Then Return SetError(@error, @extended)
EndFunc

Func _memread(ByRef $tmemmap, $psrce, $pdest, $isize)
	Local $aresult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($tmemmap, "hProc"), "ptr", $psrce, "struct*", $pdest, "ulong_ptr", $isize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _memwrite(ByRef $tmemmap, $psrce, $pdest = 0, $isize = 0, $ssrce = "struct*")
	If $pdest = 0 Then $pdest = DllStructGetData($tmemmap, "Mem")
	If $isize = 0 Then $isize = DllStructGetData($tmemmap, "Size")
	Local $aresult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tmemmap, "hProc"), "ptr", $pdest, $ssrce, $psrce, "ulong_ptr", $isize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _memvirtualalloc($paddress, $isize, $iallocation, $iprotect)
	Local $aresult = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", $paddress, "ulong_ptr", $isize, "dword", $iallocation, "dword", $iprotect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _memvirtualallocex($hprocess, $paddress, $isize, $iallocation, $iprotect)
	Local $aresult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hprocess, "ptr", $paddress, "ulong_ptr", $isize, "dword", $iallocation, "dword", $iprotect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _memvirtualfree($paddress, $isize, $ifreetype)
	Local $aresult = DllCall("kernel32.dll", "bool", "VirtualFree", "ptr", $paddress, "ulong_ptr", $isize, "dword", $ifreetype)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _memvirtualfreeex($hprocess, $paddress, $isize, $ifreetype)
	Local $aresult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hprocess, "ptr", $paddress, "ulong_ptr", $isize, "dword", $ifreetype)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func __mem_openprocess($iaccess, $finherit, $iprocessid, $fdebugpriv = False)
	Local $aresult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iaccess, "bool", $finherit, "dword", $iprocessid)
	If @error Then Return SetError(@error, @extended, 0)
	If $aresult[0] Then Return $aresult[0]
	If NOT $fdebugpriv Then Return 0
	Local $htoken = _security__openthreadtokenex(BitOR($token_adjust_privileges, $token_query))
	If @error Then Return SetError(@error, @extended, 0)
	_security__setprivilege($htoken, "SeDebugPrivilege", True)
	Local $ierror = @error
	Local $ilasterror = @extended
	Local $iret = 0
	If NOT @error Then
		$aresult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iaccess, "bool", $finherit, "dword", $iprocessid)
		$ierror = @error
		$ilasterror = @extended
		If $aresult[0] Then $iret = $aresult[0]
		_security__setprivilege($htoken, "SeDebugPrivilege", False)
		If @error Then
			$ierror = @error
			$ilasterror = @extended
		EndIf
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $htoken)
	Return SetError($ierror, $ilasterror, $iret)
EndFunc

Func _dateadd($stype, $ivaltoadd, $sdate)
	Local $astimepart[4]
	Local $asdatepart[4]
	Local $ijuliandate
	$stype = StringLeft($stype, 1)
	If StringInStr("D,M,Y,w,h,n,s", $stype) = 0 OR $stype = "" Then
		Return SetError(1, 0, 0)
	EndIf
	If NOT StringIsInt($ivaltoadd) Then
		Return SetError(2, 0, 0)
	EndIf
	If NOT _dateisvalid($sdate) Then
		Return SetError(3, 0, 0)
	EndIf
	_datetimesplit($sdate, $asdatepart, $astimepart)
	If $stype = "d" OR $stype = "w" Then
		If $stype = "w" Then $ivaltoadd = $ivaltoadd * 7
		$ijuliandate = _datetodayvalue($asdatepart[1], $asdatepart[2], $asdatepart[3]) + $ivaltoadd
		_dayvaluetodate($ijuliandate, $asdatepart[1], $asdatepart[2], $asdatepart[3])
	EndIf
	If $stype = "m" Then
		$asdatepart[2] = $asdatepart[2] + $ivaltoadd
		While $asdatepart[2] > 12
			$asdatepart[2] = $asdatepart[2] - 12
			$asdatepart[1] = $asdatepart[1] + 1
		WEnd
		While $asdatepart[2] < 1
			$asdatepart[2] = $asdatepart[2] + 12
			$asdatepart[1] = $asdatepart[1] - 1
		WEnd
	EndIf
	If $stype = "y" Then
		$asdatepart[1] = $asdatepart[1] + $ivaltoadd
	EndIf
	If $stype = "h" OR $stype = "n" OR $stype = "s" Then
		Local $itimeval = _timetoticks($astimepart[1], $astimepart[2], $astimepart[3]) / 1000
		If $stype = "h" Then $itimeval = $itimeval + $ivaltoadd * 3600
		If $stype = "n" Then $itimeval = $itimeval + $ivaltoadd * 60
		If $stype = "s" Then $itimeval = $itimeval + $ivaltoadd
		Local $day2add = Int($itimeval / (24 * 60 * 60))
		$itimeval = $itimeval - $day2add * 24 * 60 * 60
		If $itimeval < 0 Then
			$day2add = $day2add - 1
			$itimeval = $itimeval + 24 * 60 * 60
		EndIf
		$ijuliandate = _datetodayvalue($asdatepart[1], $asdatepart[2], $asdatepart[3]) + $day2add
		_dayvaluetodate($ijuliandate, $asdatepart[1], $asdatepart[2], $asdatepart[3])
		_tickstotime($itimeval * 1000, $astimepart[1], $astimepart[2], $astimepart[3])
	EndIf
	Local $inumdays = _daysinmonth($asdatepart[1])
	If $inumdays[$asdatepart[2]] < $asdatepart[3] Then $asdatepart[3] = $inumdays[$asdatepart[2]]
	$sdate = $asdatepart[1] & "/" & StringRight("0" & $asdatepart[2], 2) & "/" & StringRight("0" & $asdatepart[3], 2)
	If $astimepart[0] > 0 Then
		If $astimepart[0] > 2 Then
			$sdate = $sdate & " " & StringRight("0" & $astimepart[1], 2) & ":" & StringRight("0" & $astimepart[2], 2) & ":" & StringRight("0" & $astimepart[3], 2)
		Else
			$sdate = $sdate & " " & StringRight("0" & $astimepart[1], 2) & ":" & StringRight("0" & $astimepart[2], 2)
		EndIf
	EndIf
	Return ($sdate)
EndFunc

Func _datedayofweek($idaynum, $ishort = 0)
	Local Const $adayofweek[8] = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	Select 
		Case NOT StringIsInt($idaynum) OR NOT StringIsInt($ishort)
			Return SetError(1, 0, "")
		Case $idaynum < 1 OR $idaynum > 7
			Return SetError(1, 0, "")
		Case Else
			Select 
				Case $ishort = 0
					Return $adayofweek[$idaynum]
				Case $ishort = 1
					Return StringLeft($adayofweek[$idaynum], 3)
				Case Else
					Return SetError(1, 0, "")
			EndSelect
	EndSelect
EndFunc

Func _datedaysinmonth($iyear, $imonthnum)
	If __dateismonth($imonthnum) AND __dateisyear($iyear) Then
		Local $ainumdays = _daysinmonth($iyear)
		Return $ainumdays[$imonthnum]
	EndIf
	Return SetError(1, 0, 0)
EndFunc

Func _datediff($stype, $sstartdate, $senddate)
	$stype = StringLeft($stype, 1)
	If StringInStr("d,m,y,w,h,n,s", $stype) = 0 OR $stype = "" Then
		Return SetError(1, 0, 0)
	EndIf
	If NOT _dateisvalid($sstartdate) Then
		Return SetError(2, 0, 0)
	EndIf
	If NOT _dateisvalid($senddate) Then
		Return SetError(3, 0, 0)
	EndIf
	Local $asstartdatepart[4], $asstarttimepart[4], $asenddatepart[4], $asendtimepart[4]
	_datetimesplit($sstartdate, $asstartdatepart, $asstarttimepart)
	_datetimesplit($senddate, $asenddatepart, $asendtimepart)
	Local $adaysdiff = _datetodayvalue($asenddatepart[1], $asenddatepart[2], $asenddatepart[3]) - _datetodayvalue($asstartdatepart[1], $asstartdatepart[2], $asstartdatepart[3])
	Local $itimediff, $iyeardiff, $istarttimeinsecs, $iendtimeinsecs
	If $asstarttimepart[0] > 1 AND $asendtimepart[0] > 1 Then
		$istarttimeinsecs = $asstarttimepart[1] * 3600 + $asstarttimepart[2] * 60 + $asstarttimepart[3]
		$iendtimeinsecs = $asendtimepart[1] * 3600 + $asendtimepart[2] * 60 + $asendtimepart[3]
		$itimediff = $iendtimeinsecs - $istarttimeinsecs
		If $itimediff < 0 Then
			$adaysdiff = $adaysdiff - 1
			$itimediff = $itimediff + 24 * 60 * 60
		EndIf
	Else
		$itimediff = 0
	EndIf
	Select 
		Case $stype = "d"
			Return ($adaysdiff)
		Case $stype = "m"
			$iyeardiff = $asenddatepart[1] - $asstartdatepart[1]
			Local $imonthdiff = $asenddatepart[2] - $asstartdatepart[2] + $iyeardiff * 12
			If $asenddatepart[3] < $asstartdatepart[3] Then $imonthdiff = $imonthdiff - 1
			$istarttimeinsecs = $asstarttimepart[1] * 3600 + $asstarttimepart[2] * 60 + $asstarttimepart[3]
			$iendtimeinsecs = $asendtimepart[1] * 3600 + $asendtimepart[2] * 60 + $asendtimepart[3]
			$itimediff = $iendtimeinsecs - $istarttimeinsecs
			If $asenddatepart[3] = $asstartdatepart[3] AND $itimediff < 0 Then $imonthdiff = $imonthdiff - 1
			Return ($imonthdiff)
		Case $stype = "y"
			$iyeardiff = $asenddatepart[1] - $asstartdatepart[1]
			If $asenddatepart[2] < $asstartdatepart[2] Then $iyeardiff = $iyeardiff - 1
			If $asenddatepart[2] = $asstartdatepart[2] AND $asenddatepart[3] < $asstartdatepart[3] Then $iyeardiff = $iyeardiff - 1
			$istarttimeinsecs = $asstarttimepart[1] * 3600 + $asstarttimepart[2] * 60 + $asstarttimepart[3]
			$iendtimeinsecs = $asendtimepart[1] * 3600 + $asendtimepart[2] * 60 + $asendtimepart[3]
			$itimediff = $iendtimeinsecs - $istarttimeinsecs
			If $asenddatepart[2] = $asstartdatepart[2] AND $asenddatepart[3] = $asstartdatepart[3] AND $itimediff < 0 Then $iyeardiff = $iyeardiff - 1
			Return ($iyeardiff)
		Case $stype = "w"
			Return (Int($adaysdiff / 7))
		Case $stype = "h"
			Return ($adaysdiff * 24 + Int($itimediff / 3600))
		Case $stype = "n"
			Return ($adaysdiff * 24 * 60 + Int($itimediff / 60))
		Case $stype = "s"
			Return ($adaysdiff * 24 * 60 * 60 + $itimediff)
	EndSelect
EndFunc

Func _dateisleapyear($iyear)
	If StringIsInt($iyear) Then
		Select 
			Case Mod($iyear, 4) = 0 AND Mod($iyear, 100) <> 0
				Return 1
			Case Mod($iyear, 400) = 0
				Return 1
			Case Else
				Return 0
		EndSelect
	EndIf
	Return SetError(1, 0, 0)
EndFunc

Func __dateismonth($inumber)
	If StringIsInt($inumber) Then
		If $inumber >= 1 AND $inumber <= 12 Then
			Return 1
		Else
			Return 0
		EndIf
	EndIf
	Return 0
EndFunc

Func _dateisvalid($sdate)
	Local $asdatepart[4], $astimepart[4]
	Local $sdatetime = StringSplit($sdate, " T")
	If $sdatetime[0] > 0 Then $asdatepart = StringSplit($sdatetime[1], "/-.")
	If UBound($asdatepart) <> 4 Then Return (0)
	If $asdatepart[0] <> 3 Then Return (0)
	If NOT StringIsInt($asdatepart[1]) Then Return (0)
	If NOT StringIsInt($asdatepart[2]) Then Return (0)
	If NOT StringIsInt($asdatepart[3]) Then Return (0)
	$asdatepart[1] = Number($asdatepart[1])
	$asdatepart[2] = Number($asdatepart[2])
	$asdatepart[3] = Number($asdatepart[3])
	Local $inumdays = _daysinmonth($asdatepart[1])
	If $asdatepart[1] < 1000 OR $asdatepart[1] > 2999 Then Return (0)
	If $asdatepart[2] < 1 OR $asdatepart[2] > 12 Then Return (0)
	If $asdatepart[3] < 1 OR $asdatepart[3] > $inumdays[$asdatepart[2]] Then Return (0)
	If $sdatetime[0] > 1 Then
		$astimepart = StringSplit($sdatetime[2], ":")
		If UBound($astimepart) < 4 Then ReDim $astimepart[4]
	Else
		Dim $astimepart[4]
	EndIf
	If $astimepart[0] < 1 Then Return (1)
	If $astimepart[0] < 2 Then Return (0)
	If $astimepart[0] = 2 Then $astimepart[3] = "00"
	If NOT StringIsInt($astimepart[1]) Then Return (0)
	If NOT StringIsInt($astimepart[2]) Then Return (0)
	If NOT StringIsInt($astimepart[3]) Then Return (0)
	$astimepart[1] = Number($astimepart[1])
	$astimepart[2] = Number($astimepart[2])
	$astimepart[3] = Number($astimepart[3])
	If $astimepart[1] < 0 OR $astimepart[1] > 23 Then Return (0)
	If $astimepart[2] < 0 OR $astimepart[2] > 59 Then Return (0)
	If $astimepart[3] < 0 OR $astimepart[3] > 59 Then Return (0)
	Return 1
EndFunc

Func __dateisyear($inumber)
	If StringIsInt($inumber) Then
		If StringLen($inumber) = 4 Then
			Return 1
		Else
			Return 0
		EndIf
	EndIf
	Return 0
EndFunc

Func _datelastweekdaynum($iweekdaynum)
	Select 
		Case NOT StringIsInt($iweekdaynum)
			Return SetError(1, 0, 0)
		Case $iweekdaynum < 1 OR $iweekdaynum > 7
			Return SetError(1, 0, 0)
		Case Else
			Local $ilastweekdaynum
			If $iweekdaynum = 1 Then
				$ilastweekdaynum = 7
			Else
				$ilastweekdaynum = $iweekdaynum - 1
			EndIf
			Return $ilastweekdaynum
	EndSelect
EndFunc

Func _datelastmonthnum($imonthnum)
	Select 
		Case NOT StringIsInt($imonthnum)
			Return SetError(1, 0, 0)
		Case $imonthnum < 1 OR $imonthnum > 12
			Return SetError(1, 0, 0)
		Case Else
			Local $ilastmonthnum
			If $imonthnum = 1 Then
				$ilastmonthnum = 12
			Else
				$ilastmonthnum = $imonthnum - 1
			EndIf
			$ilastmonthnum = StringFormat("%02d", $ilastmonthnum)
			Return $ilastmonthnum
	EndSelect
EndFunc

Func _datelastmonthyear($imonthnum, $iyear)
	Select 
		Case NOT StringIsInt($imonthnum) OR NOT StringIsInt($iyear)
			Return SetError(1, 0, 0)
		Case $imonthnum < 1 OR $imonthnum > 12
			Return SetError(1, 0, 0)
		Case Else
			Local $ilastyear
			If $imonthnum = 1 Then
				$ilastyear = $iyear - 1
			Else
				$ilastyear = $iyear
			EndIf
			$ilastyear = StringFormat("%04d", $ilastyear)
			Return $ilastyear
	EndSelect
EndFunc

Func _datenextweekdaynum($iweekdaynum)
	Select 
		Case NOT StringIsInt($iweekdaynum)
			Return SetError(1, 0, 0)
		Case $iweekdaynum < 1 OR $iweekdaynum > 7
			Return SetError(1, 0, 0)
		Case Else
			Local $inextweekdaynum
			If $iweekdaynum = 7 Then
				$inextweekdaynum = 1
			Else
				$inextweekdaynum = $iweekdaynum + 1
			EndIf
			Return $inextweekdaynum
	EndSelect
EndFunc

Func _datenextmonthnum($imonthnum)
	Select 
		Case NOT StringIsInt($imonthnum)
			Return SetError(1, 0, 0)
		Case $imonthnum < 1 OR $imonthnum > 12
			Return SetError(1, 0, 0)
		Case Else
			Local $inextmonthnum
			If $imonthnum = 12 Then
				$inextmonthnum = 1
			Else
				$inextmonthnum = $imonthnum + 1
			EndIf
			$inextmonthnum = StringFormat("%02d", $inextmonthnum)
			Return $inextmonthnum
	EndSelect
EndFunc

Func _datenextmonthyear($imonthnum, $iyear)
	Select 
		Case NOT StringIsInt($imonthnum) OR NOT StringIsInt($iyear)
			Return SetError(1, 0, 0)
		Case $imonthnum < 1 OR $imonthnum > 12
			Return SetError(1, 0, 0)
		Case Else
			Local $inextyear
			If $imonthnum = 12 Then
				$inextyear = $iyear + 1
			Else
				$inextyear = $iyear
			EndIf
			$inextyear = StringFormat("%04d", $inextyear)
			Return $inextyear
	EndSelect
EndFunc

Func _datetimeformat($sdate, $stype)
	Local $asdatepart[4], $astimepart[4]
	Local $stempdate = "", $stemptime = ""
	Local $sam, $spm, $lngx
	If NOT _dateisvalid($sdate) Then
		Return SetError(1, 0, "")
	EndIf
	If $stype < 0 OR $stype > 5 OR NOT IsInt($stype) Then
		Return SetError(2, 0, "")
	EndIf
	_datetimesplit($sdate, $asdatepart, $astimepart)
	Switch $stype
		Case 0
			$lngx = DllCall("kernel32.dll", "int", "GetLocaleInfoW", "dword", 1024, "dword", 31, "wstr", "", "int", 255)
			If NOT @error AND $lngx[0] <> 0 Then
				$stempdate = $lngx[3]
			Else
				$stempdate = "M/d/yyyy"
			EndIf
			If $astimepart[0] > 1 Then
				$lngx = DllCall("kernel32.dll", "int", "GetLocaleInfoW", "dword", 1024, "dword", 4099, "wstr", "", "int", 255)
				If NOT @error AND $lngx[0] <> 0 Then
					$stemptime = $lngx[3]
				Else
					$stemptime = "h:mm:ss tt"
				EndIf
			EndIf
		Case 1
			$lngx = DllCall("kernel32.dll", "int", "GetLocaleInfoW", "dword", 1024, "dword", 32, "wstr", "", "int", 255)
			If NOT @error AND $lngx[0] <> 0 Then
				$stempdate = $lngx[3]
			Else
				$stempdate = "dddd, MMMM dd, yyyy"
			EndIf
		Case 2
			$lngx = DllCall("kernel32.dll", "int", "GetLocaleInfoW", "dword", 1024, "dword", 31, "wstr", "", "int", 255)
			If NOT @error AND $lngx[0] <> 0 Then
				$stempdate = $lngx[3]
			Else
				$stempdate = "M/d/yyyy"
			EndIf
		Case 3
			If $astimepart[0] > 1 Then
				$lngx = DllCall("kernel32.dll", "int", "GetLocaleInfoW", "dword", 1024, "dword", 4099, "wstr", "", "int", 255)
				If NOT @error AND $lngx[0] <> 0 Then
					$stemptime = $lngx[3]
				Else
					$stemptime = "h:mm:ss tt"
				EndIf
			EndIf
		Case 4
			If $astimepart[0] > 1 Then
				$stemptime = "hh:mm"
			EndIf
		Case 5
			If $astimepart[0] > 1 Then
				$stemptime = "hh:mm:ss"
			EndIf
	EndSwitch
	If $stempdate <> "" Then
		$lngx = DllCall("kernel32.dll", "int", "GetLocaleInfoW", "dword", 1024, "dword", 29, "wstr", "", "int", 255)
		If NOT @error AND $lngx[0] <> 0 Then
			$stempdate = StringReplace($stempdate, "/", $lngx[3])
		EndIf
		Local $iwday = _datetodayofweek($asdatepart[1], $asdatepart[2], $asdatepart[3])
		$asdatepart[3] = StringRight("0" & $asdatepart[3], 2)
		$asdatepart[2] = StringRight("0" & $asdatepart[2], 2)
		$stempdate = StringReplace($stempdate, "d", "@")
		$stempdate = StringReplace($stempdate, "m", "#")
		$stempdate = StringReplace($stempdate, "y", "&")
		$stempdate = StringReplace($stempdate, "@@@@", _datedayofweek($iwday, 0))
		$stempdate = StringReplace($stempdate, "@@@", _datedayofweek($iwday, 1))
		$stempdate = StringReplace($stempdate, "@@", $asdatepart[3])
		$stempdate = StringReplace($stempdate, "@", StringReplace(StringLeft($asdatepart[3], 1), "0", "") & StringRight($asdatepart[3], 1))
		$stempdate = StringReplace($stempdate, "####", _datetomonth($asdatepart[2], 0))
		$stempdate = StringReplace($stempdate, "###", _datetomonth($asdatepart[2], 1))
		$stempdate = StringReplace($stempdate, "##", $asdatepart[2])
		$stempdate = StringReplace($stempdate, "#", StringReplace(StringLeft($asdatepart[2], 1), "0", "") & StringRight($asdatepart[2], 1))
		$stempdate = StringReplace($stempdate, "&&&&", $asdatepart[1])
		$stempdate = StringReplace($stempdate, "&&", StringRight($asdatepart[1], 2))
	EndIf
	If $stemptime <> "" Then
		$lngx = DllCall("kernel32.dll", "int", "GetLocaleInfoW", "dword", 1024, "dword", 40, "wstr", "", "int", 255)
		If NOT @error AND $lngx[0] <> 0 Then
			$sam = $lngx[3]
		Else
			$sam = "AM"
		EndIf
		$lngx = DllCall("kernel32.dll", "int", "GetLocaleInfoW", "dword", 1024, "dword", 41, "wstr", "", "int", 255)
		If NOT @error AND $lngx[0] <> 0 Then
			$spm = $lngx[3]
		Else
			$spm = "PM"
		EndIf
		$lngx = DllCall("kernel32.dll", "int", "GetLocaleInfoW", "dword", 1024, "dword", 30, "wstr", "", "int", 255)
		If NOT @error AND $lngx[0] <> 0 Then
			$stemptime = StringReplace($stemptime, ":", $lngx[3])
		EndIf
		If StringInStr($stemptime, "tt") Then
			If $astimepart[1] < 12 Then
				$stemptime = StringReplace($stemptime, "tt", $sam)
				If $astimepart[1] = 0 Then $astimepart[1] = 12
			Else
				$stemptime = StringReplace($stemptime, "tt", $spm)
				If $astimepart[1] > 12 Then $astimepart[1] = $astimepart[1] - 12
			EndIf
		EndIf
		$astimepart[1] = StringRight("0" & $astimepart[1], 2)
		$astimepart[2] = StringRight("0" & $astimepart[2], 2)
		$astimepart[3] = StringRight("0" & $astimepart[3], 2)
		$stemptime = StringReplace($stemptime, "hh", StringFormat("%02d", $astimepart[1]))
		$stemptime = StringReplace($stemptime, "h", StringReplace(StringLeft($astimepart[1], 1), "0", "") & StringRight($astimepart[1], 1))
		$stemptime = StringReplace($stemptime, "mm", StringFormat("%02d", $astimepart[2]))
		$stemptime = StringReplace($stemptime, "ss", StringFormat("%02d", $astimepart[3]))
		$stempdate = StringStripWS($stempdate & " " & $stemptime, 3)
	EndIf
	Return $stempdate
EndFunc

Func _datetimesplit($sdate, ByRef $asdatepart, ByRef $itimepart)
	Local $sdatetime = StringSplit($sdate, " T")
	If $sdatetime[0] > 0 Then $asdatepart = StringSplit($sdatetime[1], "/-.")
	If $sdatetime[0] > 1 Then
		$itimepart = StringSplit($sdatetime[2], ":")
		If UBound($itimepart) < 4 Then ReDim $itimepart[4]
	Else
		Dim $itimepart[4]
	EndIf
	If UBound($asdatepart) < 4 Then ReDim $asdatepart[4]
	For $x = 1 To 3
		If StringIsInt($asdatepart[$x]) Then
			$asdatepart[$x] = Number($asdatepart[$x])
		Else
			$asdatepart[$x] = -1
		EndIf
		If StringIsInt($itimepart[$x]) Then
			$itimepart[$x] = Number($itimepart[$x])
		Else
			$itimepart[$x] = 0
		EndIf
	Next
	Return 1
EndFunc

Func _datetodayofweek($iyear, $imonth, $iday)
	If NOT _dateisvalid($iyear & "/" & $imonth & "/" & $iday) Then
		Return SetError(1, 0, "")
	EndIf
	Local $i_afactor = Int((14 - $imonth) / 12)
	Local $i_yfactor = $iyear - $i_afactor
	Local $i_mfactor = $imonth + (12 * $i_afactor) - 2
	Local $i_dfactor = Mod($iday + $i_yfactor + Int($i_yfactor / 4) - Int($i_yfactor / 100) + Int($i_yfactor / 400) + Int((31 * $i_mfactor) / 12), 7)
	Return ($i_dfactor + 1)
EndFunc

Func _datetodayofweekiso($iyear, $imonth, $iday)
	Local $idow = _datetodayofweek($iyear, $imonth, $iday)
	If @error Then
		Return SetError(1, 0, "")
	EndIf
	If $idow >= 2 Then Return $idow - 1
	Return 7
EndFunc

Func _datetodayvalue($iyear, $imonth, $iday)
	If NOT _dateisvalid(StringFormat("%04d/%02d/%02d", $iyear, $imonth, $iday)) Then
		Return SetError(1, 0, "")
	EndIf
	If $imonth < 3 Then
		$imonth = $imonth + 12
		$iyear = $iyear - 1
	EndIf
	Local $i_afactor = Int($iyear / 100)
	Local $i_bfactor = Int($i_afactor / 4)
	Local $i_cfactor = 2 - $i_afactor + $i_bfactor
	Local $i_efactor = Int(1461 * ($iyear + 4716) / 4)
	Local $i_ffactor = Int(153 * ($imonth + 1) / 5)
	Local $ijuliandate = $i_cfactor + $iday + $i_efactor + $i_ffactor - 1524.5
	Return ($ijuliandate)
EndFunc

Func _datetomonth($imonth, $ishort = 0)
	Local $amonthnumber[13] = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	Local $amonthnumberabbrev[13] = ["", "Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]
	Select 
		Case NOT StringIsInt($imonth)
			Return SetError(1, 0, "")
		Case $imonth < 1 OR $imonth > 12
			Return SetError(1, 0, "")
		Case Else
			Select 
				Case $ishort = 0
					Return $amonthnumber[$imonth]
				Case $ishort = 1
					Return $amonthnumberabbrev[$imonth]
				Case Else
					Return SetError(1, 0, "")
			EndSelect
	EndSelect
EndFunc

Func _dayvaluetodate($ijuliandate, ByRef $iyear, ByRef $imonth, ByRef $iday)
	If $ijuliandate < 0 OR NOT IsNumber($ijuliandate) Then
		Return SetError(1, 0, 0)
	EndIf
	Local $i_zfactor = Int($ijuliandate + 0.5)
	Local $i_wfactor = Int(($i_zfactor - 1867216.25) / 36524.25)
	Local $i_xfactor = Int($i_wfactor / 4)
	Local $i_afactor = $i_zfactor + 1 + $i_wfactor - $i_xfactor
	Local $i_bfactor = $i_afactor + 1524
	Local $i_cfactor = Int(($i_bfactor - 122.1) / 365.25)
	Local $i_dfactor = Int(365.25 * $i_cfactor)
	Local $i_efactor = Int(($i_bfactor - $i_dfactor) / 30.6001)
	Local $i_ffactor = Int(30.6001 * $i_efactor)
	$iday = $i_bfactor - $i_dfactor - $i_ffactor
	If $i_efactor - 1 < 13 Then
		$imonth = $i_efactor - 1
	Else
		$imonth = $i_efactor - 13
	EndIf
	If $imonth < 3 Then
		$iyear = $i_cfactor - 4715
	Else
		$iyear = $i_cfactor - 4716
	EndIf
	$iyear = StringFormat("%04d", $iyear)
	$imonth = StringFormat("%02d", $imonth)
	$iday = StringFormat("%02d", $iday)
	Return $iyear & "/" & $imonth & "/" & $iday
EndFunc

Func _date_juliandayno($iyear, $imonth, $iday)
	Local $sfulldate = StringFormat("%04d/%02d/%02d", $iyear, $imonth, $iday)
	If NOT _dateisvalid($sfulldate) Then
		Return SetError(1, 0, "")
	EndIf
	Local $ijday = 0
	Local $aidaysinmonth = _daysinmonth($iyear)
	For $icntr = 1 To $imonth - 1
		$ijday = $ijday + $aidaysinmonth[$icntr]
	Next
	$ijday = ($iyear * 1000) + ($ijday + $iday)
	Return $ijday
EndFunc

Func _juliantodate($ijday, $ssep = "/")
	Local $iyear = Int($ijday / 1000)
	Local $idays = Mod($ijday, 1000)
	Local $imaxdays = 365
	If _dateisleapyear($iyear) Then $imaxdays = 366
	If $idays > $imaxdays Then
		Return SetError(1, 0, "")
	EndIf
	Local $aidaysinmonth = _daysinmonth($iyear)
	Local $imonth = 1
	While $idays > $aidaysinmonth[$imonth]
		$idays = $idays - $aidaysinmonth[$imonth]
		$imonth = $imonth + 1
	WEnd
	Return StringFormat("%04d%s%02d%s%02d", $iyear, $ssep, $imonth, $ssep, $idays)
EndFunc

Func _now()
	Return (_datetimeformat(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, 0))
EndFunc

Func _nowcalc()
	Return (@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC)
EndFunc

Func _nowcalcdate()
	Return (@YEAR & "/" & @MON & "/" & @MDAY)
EndFunc

Func _nowdate()
	Return (_datetimeformat(@YEAR & "/" & @MON & "/" & @MDAY, 0))
EndFunc

Func _nowtime($stype = 3)
	If $stype < 3 OR $stype > 5 Then $stype = 3
	Return (_datetimeformat(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, $stype))
EndFunc

Func _setdate($iday, $imonth = 0, $iyear = 0)
	If $iyear = 0 Then $iyear = @YEAR
	If $imonth = 0 Then $imonth = @MON
	If NOT _dateisvalid($iyear & "/" & $imonth & "/" & $iday) Then Return 1
	Local $tsystemtime = DllStructCreate($tagsystemtime)
	DllCall("kernel32.dll", "none", "GetLocalTime", "struct*", $tsystemtime)
	If @error Then Return SetError(@error, @extended, 0)
	DllStructSetData($tsystemtime, 4, $iday)
	If $imonth > 0 Then DllStructSetData($tsystemtime, 2, $imonth)
	If $iyear > 0 Then DllStructSetData($tsystemtime, 1, $iyear)
	Local $iretval = _date_time_setlocaltime($tsystemtime)
	If @error Then Return SetError(@error, @extended, 0)
	Return Int($iretval)
EndFunc

Func _settime($ihour, $iminute, $isecond = 0)
	If $ihour < 0 OR $ihour > 23 Then Return 1
	If $iminute < 0 OR $iminute > 59 Then Return 1
	If $isecond < 0 OR $isecond > 59 Then Return 1
	Local $tsystemtime = DllStructCreate($tagsystemtime)
	DllCall("kernel32.dll", "none", "GetLocalTime", "struct*", $tsystemtime)
	If @error Then Return SetError(@error, @extended, 0)
	DllStructSetData($tsystemtime, 5, $ihour)
	DllStructSetData($tsystemtime, 6, $iminute)
	If $isecond > 0 Then DllStructSetData($tsystemtime, 7, $isecond)
	Local $iretval = _date_time_setlocaltime($tsystemtime)
	If @error Then Return SetError(@error, @extended, 0)
	Return Int($iretval)
EndFunc

Func _tickstotime($iticks, ByRef $ihours, ByRef $imins, ByRef $isecs)
	If Number($iticks) > 0 Then
		$iticks = Int($iticks / 1000)
		$ihours = Int($iticks / 3600)
		$iticks = Mod($iticks, 3600)
		$imins = Int($iticks / 60)
		$isecs = Mod($iticks, 60)
		Return 1
	ElseIf Number($iticks) = 0 Then
		$ihours = 0
		$iticks = 0
		$imins = 0
		$isecs = 0
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc

Func _timetoticks($ihours = @HOUR, $imins = @MIN, $isecs = @SEC)
	If StringIsInt($ihours) AND StringIsInt($imins) AND StringIsInt($isecs) Then
		Local $iticks = 1000 * ((3600 * $ihours) + (60 * $imins) + $isecs)
		Return $iticks
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc

Func _weeknumberiso($iyear = @YEAR, $imonth = @MON, $iday = @MDAY)
	If $iday > 31 OR $iday < 1 Then
		Return SetError(1, 0, -1)
	ElseIf $imonth > 12 OR $imonth < 1 Then
		Return SetError(1, 0, -1)
	ElseIf $iyear < 1 OR $iyear > 2999 Then
		Return SetError(1, 0, -1)
	EndIf
	Local $idow = _datetodayofweekiso($iyear, $imonth, $iday) - 1
	Local $idow0101 = _datetodayofweekiso($iyear, 1, 1) - 1
	If ($imonth = 1 AND 3 < $idow0101 AND $idow0101 < 7 - ($iday - 1)) Then
		$idow = $idow0101 - 1
		$idow0101 = _datetodayofweekiso($iyear - 1, 1, 1) - 1
		$imonth = 12
		$iday = 31
		$iyear = $iyear - 1
	ElseIf ($imonth = 12 AND 30 - ($iday - 1) < _datetodayofweekiso($iyear + 1, 1, 1) - 1 AND _datetodayofweekiso($iyear + 1, 1, 1) - 1 < 4) Then
		Return 1
	EndIf
	Return Int((_datetodayofweekiso($iyear, 1, 1) - 1 < 4) + 4 * ($imonth - 1) + (2 * ($imonth - 1) + ($iday - 1) + $idow0101 - $idow + 6) * 36 / 256)
EndFunc

Func _weeknumber($iyear = @YEAR, $imonth = @MON, $iday = @MDAY, $iweekstart = 1)
	If $iday > 31 OR $iday < 1 Then
		Return SetError(1, 0, -1)
	ElseIf $imonth > 12 OR $imonth < 1 Then
		Return SetError(1, 0, -1)
	ElseIf $iyear < 1 OR $iyear > 2999 Then
		Return SetError(1, 0, -1)
	ElseIf $iweekstart < 1 OR $iweekstart > 2 Then
		Return SetError(2, 0, -1)
	EndIf
	Local $istartweek1, $iendweek1
	Local $idow0101 = _datetodayofweekiso($iyear, 1, 1)
	Local $idate = $iyear & "/" & $imonth & "/" & $iday
	If $iweekstart = 1 Then
		If $idow0101 = 6 Then
			$istartweek1 = 0
		Else
			$istartweek1 = -1 * $idow0101 - 1
		EndIf
		$iendweek1 = $istartweek1 + 6
	Else
		$istartweek1 = $idow0101 * -1
		$iendweek1 = $istartweek1 + 6
	EndIf
	Local $istartweek1ny
	Local $iendweek1date = _dateadd("d", $iendweek1, $iyear & "/01/01")
	Local $idow0101ny = _datetodayofweekiso($iyear + 1, 1, 1)
	If $iweekstart = 1 Then
		If $idow0101ny = 6 Then
			$istartweek1ny = 0
		Else
			$istartweek1ny = -1 * $idow0101ny - 1
		EndIf
	Else
		$istartweek1ny = $idow0101ny * -1
	EndIf
	Local $istartweek1dateny = _dateadd("d", $istartweek1ny, $iyear + 1 & "/01/01")
	Local $icurrdatediff = _datediff("d", $iendweek1date, $idate) - 1
	Local $icurrdatediffny = _datediff("d", $istartweek1dateny, $idate)
	If $icurrdatediff >= 0 AND $icurrdatediffny < 0 Then Return 2 + Int($icurrdatediff / 7)
	If $icurrdatediff < 0 OR $icurrdatediffny >= 0 Then Return 1
EndFunc

Func _daysinmonth($iyear)
	Local $aidays[13] = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	If _dateisleapyear($iyear) Then $aidays[2] = 29
	Return $aidays
EndFunc

Func __date_time_clonesystemtime($psystemtime)
	Local $tsystemtime1 = DllStructCreate($tagsystemtime, $psystemtime)
	Local $tsystemtime2 = DllStructCreate($tagsystemtime)
	DllStructSetData($tsystemtime2, "Month", DllStructGetData($tsystemtime1, "Month"))
	DllStructSetData($tsystemtime2, "Day", DllStructGetData($tsystemtime1, "Day"))
	DllStructSetData($tsystemtime2, "Year", DllStructGetData($tsystemtime1, "Year"))
	DllStructSetData($tsystemtime2, "Hour", DllStructGetData($tsystemtime1, "Hour"))
	DllStructSetData($tsystemtime2, "Minute", DllStructGetData($tsystemtime1, "Minute"))
	DllStructSetData($tsystemtime2, "Second", DllStructGetData($tsystemtime1, "Second"))
	DllStructSetData($tsystemtime2, "MSeconds", DllStructGetData($tsystemtime1, "MSeconds"))
	DllStructSetData($tsystemtime2, "DOW", DllStructGetData($tsystemtime1, "DOW"))
	Return $tsystemtime2
EndFunc

Func _date_time_comparefiletime($pfiletime1, $pfiletime2)
	Local $aresult = DllCall("kernel32.dll", "long", "CompareFileTime", "ptr", $pfiletime1, "ptr", $pfiletime2)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _date_time_dosdatetimetofiletime($ifatdate, $ifattime)
	Local $ttime = DllStructCreate($tagfiletime)
	Local $aresult = DllCall("kernel32.dll", "bool", "DosDateTimeToFileTime", "word", $ifatdate, "word", $ifattime, "struct*", $ttime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $ttime)
EndFunc

Func _date_time_dosdatetoarray($idosdate)
	Local $adate[3]
	$adate[0] = BitAND($idosdate, 31)
	$adate[1] = BitAND(BitShift($idosdate, 5), 15)
	$adate[2] = BitAND(BitShift($idosdate, 9), 63) + 1980
	Return $adate
EndFunc

Func _date_time_dosdatetimetoarray($idosdate, $idostime)
	Local $adate[6]
	$adate[0] = BitAND($idosdate, 31)
	$adate[1] = BitAND(BitShift($idosdate, 5), 15)
	$adate[2] = BitAND(BitShift($idosdate, 9), 63) + 1980
	$adate[5] = BitAND($idostime, 31) * 2
	$adate[4] = BitAND(BitShift($idostime, 5), 63)
	$adate[3] = BitAND(BitShift($idostime, 11), 31)
	Return $adate
EndFunc

Func _date_time_dosdatetimetostr($idosdate, $idostime)
	Local $adate = _date_time_dosdatetimetoarray($idosdate, $idostime)
	Return StringFormat("%02d/%02d/%04d %02d:%02d:%02d", $adate[0], $adate[1], $adate[2], $adate[3], $adate[4], $adate[5])
EndFunc

Func _date_time_dosdatetostr($idosdate)
	Local $adate = _date_time_dosdatetoarray($idosdate)
	Return StringFormat("%02d/%02d/%04d", $adate[0], $adate[1], $adate[2])
EndFunc

Func _date_time_dostimetoarray($idostime)
	Local $atime[3]
	$atime[2] = BitAND($idostime, 31) * 2
	$atime[1] = BitAND(BitShift($idostime, 5), 63)
	$atime[0] = BitAND(BitShift($idostime, 11), 31)
	Return $atime
EndFunc

Func _date_time_dostimetostr($idostime)
	Local $atime = _date_time_dostimetoarray($idostime)
	Return StringFormat("%02d:%02d:%02d", $atime[0], $atime[1], $atime[2])
EndFunc

Func _date_time_encodefiletime($imonth, $iday, $iyear, $ihour = 0, $iminute = 0, $isecond = 0, $imseconds = 0)
	Local $tsystemtime = _date_time_encodesystemtime($imonth, $iday, $iyear, $ihour, $iminute, $isecond, $imseconds)
	Return _date_time_systemtimetofiletime($tsystemtime)
EndFunc

Func _date_time_encodesystemtime($imonth, $iday, $iyear, $ihour = 0, $iminute = 0, $isecond = 0, $imseconds = 0)
	Local $tsystemtime = DllStructCreate($tagsystemtime)
	DllStructSetData($tsystemtime, "Month", $imonth)
	DllStructSetData($tsystemtime, "Day", $iday)
	DllStructSetData($tsystemtime, "Year", $iyear)
	DllStructSetData($tsystemtime, "Hour", $ihour)
	DllStructSetData($tsystemtime, "Minute", $iminute)
	DllStructSetData($tsystemtime, "Second", $isecond)
	DllStructSetData($tsystemtime, "MSeconds", $imseconds)
	Return $tsystemtime
EndFunc

Func _date_time_filetimetoarray(ByRef $tfiletime)
	If ((DllStructGetData($tfiletime, 1) + DllStructGetData($tfiletime, 2)) = 0) Then Return SetError(1, 0, 0)
	Local $tsystemtime = _date_time_filetimetosystemtime($tfiletime)
	If @error Then Return SetError(@error, @extended, 0)
	Return _date_time_systemtimetoarray($tsystemtime)
EndFunc

Func _date_time_filetimetostr(ByRef $tfiletime, $bfmt = 0)
	Local $adate = _date_time_filetimetoarray($tfiletime)
	If @error Then Return SetError(@error, @extended, "")
	If $bfmt Then
		Return StringFormat("%04d/%02d/%02d %02d:%02d:%02d", $adate[2], $adate[0], $adate[1], $adate[3], $adate[4], $adate[5])
	Else
		Return StringFormat("%02d/%02d/%04d %02d:%02d:%02d", $adate[0], $adate[1], $adate[2], $adate[3], $adate[4], $adate[5])
	EndIf
EndFunc

Func _date_time_filetimetodosdatetime($pfiletime)
	Local $adate[2]
	Local $aresult = DllCall("kernel32.dll", "bool", "FileTimeToDosDateTime", "ptr", $pfiletime, "word*", 0, "word*", 0)
	If @error Then Return SetError(@error, @extended, $adate)
	$adate[0] = $aresult[2]
	$adate[1] = $aresult[3]
	Return SetExtended($aresult[0], $adate)
EndFunc

Func _date_time_filetimetolocalfiletime($pfiletime)
	Local $tlocal = DllStructCreate($tagfiletime)
	Local $aresult = DllCall("kernel32.dll", "bool", "FileTimeToLocalFileTime", "struct*", $pfiletime, "struct*", $tlocal)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $tlocal)
EndFunc

Func _date_time_filetimetosystemtime($pfiletime)
	Local $tsysttime = DllStructCreate($tagsystemtime)
	Local $aresult = DllCall("kernel32.dll", "bool", "FileTimeToSystemTime", "struct*", $pfiletime, "struct*", $tsysttime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $tsysttime)
EndFunc

Func _date_time_getfiletime($hfile)
	Local $adate[3]
	$adate[0] = DllStructCreate($tagfiletime)
	$adate[1] = DllStructCreate($tagfiletime)
	$adate[2] = DllStructCreate($tagfiletime)
	Local $aresult = DllCall("Kernel32.dll", "bool", "GetFileTime", "handle", $hfile, "struct*", $adate[0], "struct*", $adate[1], "struct*", $adate[2])
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $adate)
EndFunc

Func _date_time_getlocaltime()
	Local $tsysttime = DllStructCreate($tagsystemtime)
	DllCall("kernel32.dll", "none", "GetLocalTime", "struct*", $tsysttime)
	If @error Then Return SetError(@error, @extended, 0)
	Return $tsysttime
EndFunc

Func _date_time_getsystemtime()
	Local $tsysttime = DllStructCreate($tagsystemtime)
	DllCall("kernel32.dll", "none", "GetSystemTime", "struct*", $tsysttime)
	If @error Then Return SetError(@error, @extended, 0)
	Return $tsysttime
EndFunc

Func _date_time_getsystemtimeadjustment()
	Local $ainfo[3]
	Local $aresult = DllCall("kernel32.dll", "bool", "GetSystemTimeAdjustment", "dword*", 0, "dword*", 0, "bool*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	$ainfo[0] = $aresult[1]
	$ainfo[1] = $aresult[2]
	$ainfo[2] = $aresult[3] <> 0
	Return SetExtended($aresult[0], $ainfo)
EndFunc

Func _date_time_getsystemtimeasfiletime()
	Local $tfiletime = DllStructCreate($tagfiletime)
	DllCall("kernel32.dll", "none", "GetSystemTimeAsFileTime", "struct*", $tfiletime)
	If @error Then Return SetError(@error, @extended, 0)
	Return $tfiletime
EndFunc

Func _date_time_getsystemtimes()
	Local $ainfo[3]
	$ainfo[0] = DllStructCreate($tagfiletime)
	$ainfo[1] = DllStructCreate($tagfiletime)
	$ainfo[2] = DllStructCreate($tagfiletime)
	Local $aresult = DllCall("kernel32.dll", "bool", "GetSystemTimes", "struct*", $ainfo[0], "struct*", $ainfo[1], "struct*", $ainfo[2])
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $ainfo)
EndFunc

Func _date_time_gettickcount()
	Local $aresult = DllCall("kernel32.dll", "dword", "GetTickCount")
	If @error Then Return SetError(@error, @extended, 0)
	Return $aresult[0]
EndFunc

Func _date_time_gettimezoneinformation()
	Local $ttimezone = DllStructCreate($tagtime_zone_information)
	Local $aresult = DllCall("kernel32.dll", "dword", "GetTimeZoneInformation", "struct*", $ttimezone)
	If @error OR $aresult[0] = -1 Then Return SetError(@error, @extended, 0)
	Local $ainfo[8]
	$ainfo[0] = $aresult[0]
	$ainfo[1] = DllStructGetData($ttimezone, "Bias")
	$ainfo[2] = _winapi_widechartomultibyte(DllStructGetPtr($ttimezone, "StdName"))
	$ainfo[3] = __date_time_clonesystemtime(DllStructGetPtr($ttimezone, "StdDate"))
	$ainfo[4] = DllStructGetData($ttimezone, "StdBias")
	$ainfo[5] = _winapi_widechartomultibyte(DllStructGetPtr($ttimezone, "DayName"))
	$ainfo[6] = __date_time_clonesystemtime(DllStructGetPtr($ttimezone, "DayDate"))
	$ainfo[7] = DllStructGetData($ttimezone, "DayBias")
	Return $ainfo
EndFunc

Func _date_time_localfiletimetofiletime($plocaltime)
	Local $tfiletime = DllStructCreate($tagfiletime)
	Local $aresult = DllCall("kernel32.dll", "bool", "LocalFileTimeToFileTime", "ptr", $plocaltime, "struct*", $tfiletime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $tfiletime)
EndFunc

Func _date_time_setfiletime($hfile, $pcreatetime, $plastaccess, $plastwrite)
	Local $aresult = DllCall("kernel32.dll", "bool", "SetFileTime", "handle", $hfile, "ptr", $pcreatetime, "ptr", $plastaccess, "ptr", $plastwrite)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _date_time_setlocaltime($psystemtime)
	Local $aresult = DllCall("kernel32.dll", "bool", "SetLocalTime", "struct*", $psystemtime)
	If @error OR NOT $aresult[0] Then Return SetError(@error, @extended, False)
	$aresult = DllCall("kernel32.dll", "bool", "SetLocalTime", "struct*", $psystemtime)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _date_time_setsystemtime($psystemtime)
	Local $aresult = DllCall("kernel32.dll", "bool", "SetSystemTime", "ptr", $psystemtime)
	If @error Then Return SetError(@error, @extended, False)
	Return $aresult[0]
EndFunc

Func _date_time_setsystemtimeadjustment($iadjustment, $fdisabled)
	Local $htoken = _security__openthreadtokenex(BitOR($token_adjust_privileges, $token_query))
	If @error Then Return SetError(@error, @extended, False)
	_security__setprivilege($htoken, "SeSystemtimePrivilege", True)
	Local $ierror = @error
	Local $ilasterror = @extended
	Local $iret = False
	If NOT @error Then
		Local $aresult = DllCall("kernel32.dll", "bool", "SetSystemTimeAdjustment", "dword", $iadjustment, "bool", $fdisabled)
		If @error Then
			$ierror = @error
			$ilasterror = @extended
		ElseIf $aresult[0] Then
			$iret = True
		Else
			$ierror = 1
			$ilasterror = _winapi_getlasterror()
		EndIf
		_security__setprivilege($htoken, "SeSystemtimePrivilege", False)
		If @error Then $ierror = 2
	EndIf
	_winapi_closehandle($htoken)
	Return SetError($ierror, $ilasterror, $iret)
EndFunc

Func _date_time_settimezoneinformation($ibias, $sstdname, $tstddate, $istdbias, $sdayname, $tdaydate, $idaybias)
	Local $tstdname = _winapi_multibytetowidechar($sstdname)
	Local $tdayname = _winapi_multibytetowidechar($sdayname)
	Local $tzoneinfo = DllStructCreate($tagtime_zone_information)
	DllStructSetData($tzoneinfo, "Bias", $ibias)
	DllStructSetData($tzoneinfo, "StdName", DllStructGetData($tstdname, 1))
	_memmovememory($tstddate, DllStructGetPtr($tzoneinfo, "StdDate"), DllStructGetSize($tstddate))
	DllStructSetData($tzoneinfo, "StdBias", $istdbias)
	DllStructSetData($tzoneinfo, "DayName", DllStructGetData($tdayname, 1))
	_memmovememory($tdaydate, DllStructGetPtr($tzoneinfo, "DayDate"), DllStructGetSize($tdaydate))
	DllStructSetData($tzoneinfo, "DayBias", $idaybias)
	Local $htoken = _security__openthreadtokenex(BitOR($token_adjust_privileges, $token_query))
	If @error Then Return SetError(@error, @extended, False)
	_security__setprivilege($htoken, "SeSystemtimePrivilege", True)
	Local $ierror = @error
	Local $ilasterror = @extended
	Local $iret = False
	If NOT @error Then
		Local $aresult = DllCall("kernel32.dll", "bool", "SetTimeZoneInformation", "struct*", $tzoneinfo)
		If @error Then
			$ierror = @error
			$ilasterror = @extended
		ElseIf $aresult[0] Then
			$ilasterror = 0
			$iret = True
		Else
			$ierror = 1
			$ilasterror = _winapi_getlasterror()
		EndIf
		_security__setprivilege($htoken, "SeSystemtimePrivilege", False)
		If @error Then $ierror = 2
	EndIf
	_winapi_closehandle($htoken)
	Return SetError($ierror, $ilasterror, $iret)
EndFunc

Func _date_time_systemtimetoarray(ByRef $tsystemtime)
	Local $ainfo[8]
	$ainfo[0] = DllStructGetData($tsystemtime, "Month")
	$ainfo[1] = DllStructGetData($tsystemtime, "Day")
	$ainfo[2] = DllStructGetData($tsystemtime, "Year")
	$ainfo[3] = DllStructGetData($tsystemtime, "Hour")
	$ainfo[4] = DllStructGetData($tsystemtime, "Minute")
	$ainfo[5] = DllStructGetData($tsystemtime, "Second")
	$ainfo[6] = DllStructGetData($tsystemtime, "MSeconds")
	$ainfo[7] = DllStructGetData($tsystemtime, "DOW")
	Return $ainfo
EndFunc

Func _date_time_systemtimetodatestr(ByRef $tsystemtime, $bfmt = 0)
	Local $ainfo = _date_time_systemtimetoarray($tsystemtime)
	If @error Then Return SetError(@error, @extended, "")
	If $bfmt Then
		Return StringFormat("%04d/%02d/%02d", $ainfo[2], $ainfo[0], $ainfo[1])
	Else
		Return StringFormat("%02d/%02d/%04d", $ainfo[0], $ainfo[1], $ainfo[2])
	EndIf
EndFunc

Func _date_time_systemtimetodatetimestr(ByRef $tsystemtime, $bfmt = 0)
	Local $ainfo = _date_time_systemtimetoarray($tsystemtime)
	If @error Then Return SetError(@error, @extended, "")
	If $bfmt Then
		Return StringFormat("%04d/%02d/%02d %02d:%02d:%02d", $ainfo[2], $ainfo[0], $ainfo[1], $ainfo[3], $ainfo[4], $ainfo[5])
	Else
		Return StringFormat("%02d/%02d/%04d %02d:%02d:%02d", $ainfo[0], $ainfo[1], $ainfo[2], $ainfo[3], $ainfo[4], $ainfo[5])
	EndIf
EndFunc

Func _date_time_systemtimetofiletime($psystemtime)
	Local $tfiletime = DllStructCreate($tagfiletime)
	Local $aresult = DllCall("kernel32.dll", "bool", "SystemTimeToFileTime", "struct*", $psystemtime, "struct*", $tfiletime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $tfiletime)
EndFunc

Func _date_time_systemtimetotimestr(ByRef $tsystemtime)
	Local $ainfo = _date_time_systemtimetoarray($tsystemtime)
	Return StringFormat("%02d:%02d:%02d", $ainfo[3], $ainfo[4], $ainfo[5])
EndFunc

Func _date_time_systemtimetotzspecificlocaltime($putc, $ptimezone = 0)
	Local $tlocaltime = DllStructCreate($tagsystemtime)
	Local $aresult = DllCall("kernel32.dll", "bool", "SystemTimeToTzSpecificLocalTime", "ptr", $ptimezone, "ptr", $putc, "struct*", $tlocaltime)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $tlocaltime)
EndFunc

Func _date_time_tzspecificlocaltimetosystemtime($plocaltime, $ptimezone = 0)
	Local $tutc = DllStructCreate($tagsystemtime)
	Local $aresult = DllCall("kernel32.dll", "ptr", "TzSpecificLocalTimeToSystemTime", "ptr", $ptimezone, "ptr", $plocaltime, "struct*", $tutc)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aresult[0], $tutc)
EndFunc

#Region
	Global Const $svaluetypes[12] = ["REG_NONE", "REG_SZ", "REG_EXPAND_SZ", "REG_BINARY", "REG_DWORD", "REG_DWORD_BIG_ENDIAN", "REG_LINK", "REG_MULTI_SZ", "REG_RESOURCE_LIST", "REG_FULL_RESOURCE_DESCRIPTOR", "REG_RESOURCE_REQUIREMENTS_LIST", "REG_QWORD"]
#EndRegion

Func _regenumkeyex($keyname, $iflag = 0, $sfilter = "*", $vfilter = "*", $ivaluetypes = 0)
	If StringRegExp($sfilter, StringReplace("^\s*$|\v|\\|^\||\|\||\|$", Chr(BitAND($iflag, 64) + 28) & "\|^\||\|\||\|$", "\\\\")) Then Return SetError(1, 0, "")
	Local $indexsubkey[101] = [100], $subkeyname, $bs = "\", $skeylist, $i = 1, $skeyflag = BitAND($iflag, 1), $skeyfilter = StringReplace($sfilter, "*", "")
	If BitAND($iflag, 2) Then $skeylist = @LF & $keyname
	If NOT BitAND($iflag, 64) Then $sfilter = StringRegExpReplace(BitAND($iflag, 16) & "(?i)(", "16\(\?\i\)|\d+", "") & StringRegExpReplace(StringRegExpReplace(StringRegExpReplace(StringRegExpReplace($sfilter, "[^*?|]+", "\\Q$0\\E"), "\\E(?=\||$)", "$0\$"), "(?<=^|\|)\\Q", "^$0"), "\*+", ".*") & ")"
	While $i
		$indexsubkey[$i] += 1
		$subkeyname = RegEnumKey($keyname, $indexsubkey[$i])
		If @error Then
			$indexsubkey[$i] = 0
			$i -= 1
			$keyname = StringLeft($keyname, StringInStr($keyname, "\", 1, -1) - 1)
			ContinueLoop
		EndIf
		If $skeyfilter Then
			If StringRegExp($subkeyname, $sfilter) Then $skeylist &= @LF & $keyname & $bs & $subkeyname
		Else
			$skeylist &= @LF & $keyname & $bs & $subkeyname
		EndIf
		If $skeyflag Then ContinueLoop
		$i += 1
		If $i > $indexsubkey[0] Then
			$indexsubkey[0] += 100
			ReDim $indexsubkey[$indexsubkey[0] + 1]
		EndIf
		$keyname &= $bs & $subkeyname
	WEnd
	If NOT $skeylist Then Return SetError(2, 0, "")
	If BitAND($iflag, 128) <> 128 Then Return StringSplit(StringTrimLeft($skeylist, 1), @LF, StringReplace(BitAND($iflag, 32), "32", 2))
	$skeylist = _regenumvalex(StringSplit(StringTrimLeft($skeylist, 1), @LF), $iflag, $vfilter, $ivaluetypes)
	Return SetError(@error, 0, $skeylist)
EndFunc

Func _regenumvalex($akeylist, $iflag = 0, $sfilter = "*", $ivaluetypes = 0)
	If StringRegExp($sfilter, "\v") Then Return SetError(3, 0, "")
	If NOT IsArray($akeylist) Then $akeylist = StringSplit($akeylist, @LF)
	Local $akeyvallist[1954][4], $ikeyval = Int(BitAND($iflag, 32) = 0), $skeyval = 1953, $sregenumval, $iregenumval, $regread = BitAND($iflag, 256), $vfilter = StringReplace($sfilter, "*", "")
	If NOT BitAND($iflag, 64) Then $sfilter = StringRegExpReplace(BitAND($iflag, 16) & "(?i)(", "16\(\?\i\)|\d+", "") & StringRegExpReplace(StringRegExpReplace(StringRegExpReplace(StringRegExpReplace($sfilter, "[^*?|]+", "\\Q$0\\E"), "\\E(?=\||$)", "$0\$"), "(?<=^|\|)\\Q", "^$0"), "\*+", ".*") & ")"
	For $i = 1 To $akeylist[0]
		$iregenumval = 0
		While 1
			If $ikeyval = $skeyval Then
				If $skeyval = 3999744 Then ExitLoop
				$skeyval *= 2
				ReDim $akeyvallist[$skeyval + 1][4]
			EndIf
			$akeyvallist[$ikeyval][0] = $akeylist[$i]
			$iregenumval += 1
			$sregenumval = RegEnumVal($akeylist[$i], $iregenumval)
			If @error <> 0 Then
				If $iregenumval = 1 AND $vfilter = "" Then $ikeyval += 1
				ExitLoop
			EndIf
			$akeyvallist[$ikeyval][2] = $svaluetypes[@extended]
			If BitAND(@extended, $ivaluetypes) <> $ivaluetypes Then ContinueLoop
			If $vfilter AND NOT StringRegExp($sregenumval, $sfilter) Then ContinueLoop
			$akeyvallist[$ikeyval][1] = $sregenumval
			If $regread Then $akeyvallist[$ikeyval][3] = RegRead($akeylist[$i], $sregenumval)
			$ikeyval += 1
		WEnd
	Next
	$sregenumval = $ikeyval - Int(BitAND($iflag, 32) = 0)
	If NOT $sregenumval OR ($sregenumval = 1 AND $vfilter = "" AND $akeyvallist[$ikeyval - $sregenumval][2] = "") Then Return SetError(4, 0, "")
	ReDim $akeyvallist[$ikeyval][4]
	If NOT BitAND($iflag, 32) Then $akeyvallist[0][0] = $ikeyval - 1
	Return $akeyvallist
EndFunc

$name = "Universal Extractor"
$website = "http://www.legroom.net/software/uniextract"
$website_rb = "http://forum.ru-board.com/topic.cgi?forum=5&bm=1&topic=20420"
$website_o = "http://forum.oszone.net/thread-295084.html"
$prefs = @ScriptDir & "\UniExtract.ini"
$version = "1.6.1.2022 mod by koros"
$reg = "HKCU\Software\UniExtract"
$peidtitle = "PEiD v"
$title = $name & " v" & $version
$unicodepattern = "(?i)(?m)^[\w\Q @!§$%&/\()=?,.-:+~'Іі{[]}*#Я°^влцдьокфыпбйнуъаимтщ\E]+$"
Opt("GUIOnEventMode", 1)
Global $langdir = @ScriptDir & "\lang"
Global $logdir = @ScriptDir & "\log"
Global $passwordfile = @ScriptDir & "\passwords.txt"
Global $height = @DesktopHeight / 4
Global $globalprefs = 1
Global $language = "English"
Global $debugdir = @TempDir
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
Global $time = "-" & @HOUR & "-" & @MIN & "-" & @SEC
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
Dim $section, $log
Dim $unicodemode, $oldpath, $oldname, $oldoutdir
$7z = "7z.exe"
$ace = "xace.exe"
$afp = "AFPIunpack.exe"
$alz = "unalz.exe"
$arc = "arc.exe"
$aspack = "AspackDie.exe"
$aspack22 = "AspackDie22.exe"
$au3 = "Exe2Aut.exe"
$bootimg = "bootimg.exe"
$cdi = "cdirip.exe"
$daa = "daa2iso.exe"
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
$iscab_unshield = "unshield.exe"
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
$sfxsplit = "SfxSplit.exe"
$sim = "sim_unpacker.exe"
$sis = "cmdTotal.exe PDunSIS.wcx"
$sit = "Expander.exe"
$sqx = "cmdTotal.exe TotalSQX.wcx"
$swf = "swfextract.exe"
$thinstall = "Extractor.exe"
$to = "cmdTotal.exe TotalObserver.wcx"
$trid = "trid.exe"
$uharc = "UNUHARC06.EXE"
$uharc04 = "UHARC04.EXE"
$uharc02 = "UHARC02.EXE"
$uif = "uif2iso.exe"
$upx = "upx.exe"
$uu = "uudeview.exe"
$wise_ewise = "e_wise_w.exe"
$wise_wun = "wun.exe"
$zip = "unzip.exe"
$zoo = "unzoo.exe"
$zpaq = "zpaq.exe"
readprefs()
addlog()
If $cmdline[0] = 0 Then
	addlog($name & " " & $version & " " & t("WITHOUT_COMLINE_PARAMETRS"))
	$prompt = 1
Else
	Local $icmdline
	For $i = 1 To $cmdline[0]
		$icmdline &= $cmdline[$i] & " "
	Next
	addlog($name & " " & $version & " " & t("COMLINE_PARAMETRS") & ' "' & StringTrimRight($icmdline, 1) & '"')
	If $cmdline[1] = "/help" OR $cmdline[1] = "/h" OR $cmdline[1] = "/?" OR $cmdline[1] = "-h" OR $cmdline[1] = "-?" Then
		terminate("syntax")
	ElseIf $cmdline[1] = "/prefs" OR $cmdline[1] = "/p" OR $cmdline[1] = "-prefs" OR $cmdline[1] = "-p" Then
		$prefsonly = True
		gui_prefs()
		$finishprefs = False
		While 1
			If $finishprefs Then ExitLoop
			Sleep(10)
		WEnd
		terminate("silent")
	ElseIf $cmdline[1] = "/lang" AND $cmdline[0] = 2 OR $cmdline[1] = "/l" OR $cmdline[1] = "-lang" OR $cmdline[1] = "-l" Then
		If $cmdline[0] > 1 Then
			Local $ldir = @ScriptDir
			If $cmdline[2] <> "English" Then $ldir &= "\lang"
			If NOT FileExists($ldir & "\" & $cmdline[2] & ".ini") Then terminate("invalidlangfile", $ldir & "\" & $cmdline[2] & ".ini")
			If $globalprefs Then
				$section = "UniExtract Preferences"
				IniWrite($prefs, $section, "language", $cmdline[2])
			Else
				RegWrite($reg, "language", "REG_SZ", $cmdline[2])
			EndIf
			addlog(t("LANG_INTERFACE") & " " & $cmdline[2])
			terminate("silent")
		Else
			terminate("syntax")
		EndIf
	Else
		If FileExists($cmdline[1]) Then
			$file = _pathfull($cmdline[1])
			addlog(t("FILE_PROCESSING") & ' "' & $file & '"')
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
If $prompt Then
	creategui()
	Global $finishgui = False
	While 1
		If $finishgui Then ExitLoop
		Sleep(10)
	WEnd
EndIf
filenameparse($file)
If $outdir = "/sub" Then
	$outdir = $initoutdir
ElseIf StringMid($outdir, 2, 1) <> ":" Then
	If StringLeft($outdir, 1) == "\" AND StringMid($outdir, 2, 1) <> "\" Then
		$outdir = StringLeft($filedir, 2) & $outdir
	ElseIf StringLeft($outdir, 2) <> "\\" Then
		$outdir = _pathfull($filedir & "\" & $outdir)
	EndIf
EndIf
If StringRight($outdir, 1) = "\" Then $outdir = StringTrimRight($outdir, 1)
If FileExists($outdir) Then
	$datatime = @MDAY & "." & @MON & "." & StringRight(@YEAR, 2) & "_" & @HOUR & "-" & @MIN
	If NOT StringInStr(FileGetAttrib($outdir), "D") Then
		$prompt = MsgBox(51, $title, t("WARN_FILE_EXIST", createarray($outdir, $outdir, $outdir, $outdir, $outdir, $datatime)))
		addlog(t("FILE_EXIST", createarray($outdir, $outdir)))
		If $prompt = 2 Then $outdir = $outdir & "_" & $datatime
		If $prompt = 6 Then $outdir = $outdir & "_extracted"
		If $prompt = 7 Then $outdir = FileSelectFolder(t("EXTRACT_TO"), "", 3, $filedir)
		If @error Then $outdir = $filedir & "\" & $filename & "_" & $datatime
	Else
		$prompt = MsgBox(51 + 4096, $title, t("WARN_DIR_EXIST", createarray($outdir, $outdir)))
		addlog(t("DIR_EXIST", createarray($outdir, $outdir)))
		If $prompt = 6 Then
			$validdir = _dirremove($outdir, 1)
			$validdir = _dircreate($outdir)
			If NOT $validdir Then terminate("invaliddir", $outdir)
			$createdir = True
		EndIf
		If $prompt = 7 Then $outdir = FileSelectFolder(t("EXTRACT_TO"), "", 3, $filedir)
		If @error Then $outdir = $filedir & "\" & $filename & "_" & $datatime
	EndIf
Else
	$validdir = _dircreate($outdir)
	If NOT $validdir Then terminate("invaliddir", $outdir)
	$createdir = True
EndIf
addlog(t("DEST_DIR") & ' "' & $outdir & '"')
checkunicode()
If StringRight(envparse($debugdir), 1) <> "\" Then $debugdir &= "\"
$debugfile = FileGetShortName(envparse($debugdir)) & "uniextract" & $time & ".txt"
addlog(t("DEBUG_FILE") & ' "' & $debugfile & '"')
$testdebug = FileOpen($debugfile, 2)
If $testdebug == -1 Then
	MsgBox(48, $title, t("CANNOT_DEBUG", createarray(envparse($debugdir))))
	addlog(t("CANNOT_DEBUG", createarray(envparse($debugdir))))
	addlog(t("DEBUG_FILE") & ' "' & $debugfile & '"')
	$debugdir = @TempDir & "\"
	$debugfile = FileGetShortName($debugdir) & "uniextract" & $time & ".txt"
Else
	FileClose($testdebug)
	_filedelete($debugfile)
EndIf
If $history Then
	writehist("file", $file)
	writehist("directory", $outdir)
EndIf
If $mindoswin Then $consolewin = 2
If $nodoswin Then $consolewin = 0
$cmd = @ComSpec & " /d /c "
$output = " 2>&1 | mtee.exe " & $debugfile
EnvSet("path", @ScriptDir & "\bin" & ";" & @ScriptDir & "\bin\wix" & ";" & @ScriptDir & "\bin\exeinfope" & ";" & @ScriptDir & "\bin\kgb" & ";" & @ScriptDir & "\bin\die" & ";" & EnvGet("path"))
addlog(t("SET_PATH") & " " & EnvGet("path"))
$productname = FileGetVersion($file, "ProductName")
$fileversion = FileGetVersion($file)
If $productname AND $fileversion Then addlog(t("FILE_PROPERTIES") & " " & t("PRODUCT_NAME") & ' "' & $productname & '"; ' & t("FILE_VER") & ' "' & $fileversion & '"')
If StringInStr($productname, "Microsoft Visual C++") AND StringInStr($productname, "Redistributable") AND StringCompare(StringLeft($fileversion, 2), 10) Then extract("ms_vcr", "Microsoft Visual C++ Redistributable " & t("TERM_EXECUTABLE"))
addlog("------------------------------------------------------------")
addlog(t("FIRST"))
Switch $fileext
	Case "ipk", "tbz2", "tgz", "tz", "tlz", "txz", "xar"
		extract("ctar", "Compressed Tar " & t("TERM_ARCHIVE"))
	Case "cdi"
		extract("cdi", "CDI CD-ROM " & t("TERM_IMAGE"))
	Case "uif"
		extract("uif", "CDI CD-ROM " & t("TERM_IMAGE"))
	Case "iso"
		extract("to", "ISO CD-ROM " & t("TERM_IMAGE"))
	Case "bin"
		extract("to", "BIN CD-ROM " & t("TERM_IMAGE"))
	Case "isz"
		extract("to", "ISZ CD-ROM (UltraISO) " & t("TERM_IMAGE"))
	Case "mdf"
		extract("to", "MDF CD-ROM (Alcohol 120%) " & t("TERM_IMAGE"))
	Case "nrg"
		extract("to", "NRG CD-ROM (Nero Burning ROM) " & t("TERM_IMAGE"))
	Case "vhd"
		extract("7z", "Microsoft Virtual Hard Disk " & t("TERM_IMAGE"))
	Case "pdf"
		extract("pdf", "PDF " & t("TERM_EBOOK"))
	Case "pkg"
		extract("ctar", "PKG " & t("TERM_INSTALLER"))
	Case "dmg"
		extract("ctar", "DMG " & t("TERM_IMAGE"))
	Case Else
		addlog(t("SECOND"))
		SplashTextOn($title, t("SCANNING_FILE"), 330, 50, -1, $height, 16)
		filescan($file)
EndSwitch
If $fileext = "exe" OR StringInStr($filetype, "Executable", 0) Then
	addlog()
	addlog(t("THIRD"))
	While 1
		$rescan = 0
		$scantypes = createarray("epe", "die", "deep", "hard", "ext")
		For $i = 0 To UBound($scantypes) - 1
			If $scantypes[$i] == "die" AND $usedie Then $tempftype = diescan($file)
			If $scantypes[$i] == "epe" AND $useepe Then $tempftype = epescan($file)
			If $scantypes[$i] == "hard" AND $usepeid Then $tempftype = exescan($file, $scantypes[$i])
			If $scantypes[$i] == "deep" OR $scantypes[$i] == "ext" AND $usepeid Then exescan($file, $scantypes[$i])
			If $packed Then ExitLoop
			SplashTextOn($title, t("TERM_TESTING") & " " & t("TERM_UNKNOWN") & " " & t("TERM_EXECUTABLE"), 330, 80, -1, $height, 16)
			If $testinno AND NOT $innofailed Then checkinno()
			If $testace AND NOT $acefailed Then checkace()
			If $testzip AND NOT $zipfailed Then checkzip()
			If $testie AND NOT $iefailed Then checkie()
			If $testhex AND NOT $hexfailed Then checkhex()
			If $test7z AND NOT $7zfailed Then check7z()
			SplashOff()
		Next
		If $packed Then $rescan = unpack()
		If $rescan = 0 Then ExitLoop
	WEnd
	$filetype = $tempftype
	If NOT $7zfailed Then check7z()
	If NOT $zipfailed Then checkzip()
	If NOT $iefailed Then checkie()
	terminate("unknownexe", $file, $filetype)
EndIf
addlog()
addlog(t("FOURTH"))
Switch $fileext
	Case "1", "lib"
		extract("is3arc", "InstallShield 3.x " & t("TERM_ARCHIVE"))
	Case "7z"
		extract("7z", "7-Zip " & t("TERM_ARCHIVE"))
	Case "ace"
		extract("ace", "ace " & t("TERM_ARCHIVE"))
	Case "arc"
		extract("arc", "ARC " & t("TERM_ARCHIVE"))
	Case "arj"
		extract("7z", "ARJ " & t("TERM_ARCHIVE"))
	Case "b64"
		extract("uu", "Base64 " & t("TERM_ENCODED"))
	Case "bz2"
		extract("bz2", "bzip2 " & t("TERM_COMPRESSED"))
	Case "cab"
		If StringInStr(fetchstdout($cmd & $7z & ' l "' & $file & '"', $filedir, @SW_HIDE), "Listing archive:", 0) Then
			extract("cab", "Microsoft CAB " & t("TERM_ARCHIVE"))
		Else
			extract("iscab", "InstallShield CAB " & t("TERM_ARCHIVE"))
		EndIf
	Case "chm"
		extract("chm", "Compiled HTML " & t("TERM_HELP"))
	Case "cpio"
		extract("7z", "CPIO " & t("TERM_ARCHIVE"))
	Case "dbx"
		extract("dbx", "Outlook Express " & t("TERM_ARCHIVE"))
	Case "deb"
		extract("7z", "Debian " & t("TERM_PackAGE"))
	Case "dll"
		exescan($file, "deep")
		If $packed Then
			unpack()
		Else
			terminate("unknownexe", $file, $filetype)
		EndIf
	Case "gz"
		extract("gz", "gzip " & t("TERM_COMPRESSED"))
	Case "hlp"
		extract("hlp", "Windows " & t("TERM_HELP"))
	Case "imf"
		extract("cab", "IncrediMail " & t("TERM_ECARD"))
	Case "img"
		extract("img", "Floppy " & t("TERM_DISK") & " " & t("TERM_IMAGE"))
	Case "kgb", "kge"
		extract("kgb", "KGB " & t("TERM_ARCHIVE"))
	Case "lit"
		extract("lit", "Microsoft LIT " & t("TERM_EBOOK"))
	Case "lzh", "lha"
		extract("7z", "LZH " & t("TERM_COMPRESSED"))
	Case "lzma"
		extract("7z", "LZMA " & t("TERM_COMPRESSED"))
	Case "lzo"
		extract("lzo", "LZO " & t("TERM_COMPRESSED"))
	Case "lzx"
		extract("lzx", "LZX " & t("TERM_COMPRESSED"))
	Case "mht"
		extract("mht", "MHTML " & t("TERM_ARCHIVE"))
	Case "msi"
		extract("msi", "Windows Installer (MSI) " & t("TERM_PackAGE"))
	Case "msm"
		extract("msm", "Windows Installer (MSM) " & t("TERM_MERGE_MODULE"))
	Case "msp"
		extract("msp", "Windows Installer (MSP) " & t("TERM_PATCH"))
	Case "nbh"
		extract("nbh", "NBH " & t("TERM_IMAGE"))
	Case "pea"
		extract("pea", "Pea " & t("TERM_ARCHIVE"))
	Case "rar", "001", "cbr"
		extract("rar", "RAR " & t("TERM_ARCHIVE"))
	Case "rpm"
		extract("7z", "RPM " & t("TERM_PackAGE"))
	Case "sis"
		extract("sis", "SymbianOS " & t("TERM_INSTALLER"))
	Case "sit"
		extract("sit", "StuffIt " & t("TERM_ARCHIVE"))
	Case "sqx"
		extract("sqx", "SQX " & t("TERM_ARCHIVE"))
	Case "tar"
		extract("tar", "Tar " & t("TERM_ARCHIVE"))
	Case "uha"
		extract("uha", "UHARC " & t("TERM_ARCHIVE"))
	Case "uu", "uue", "xx", "xxe"
		extract("uu", "UUencode " & t("TERM_ENCODED"))
	Case "wim"
		extract("7z", "WIM " & t("TERM_IMAGE"))
	Case "xz"
		extract("xz", "XZ " & t("TERM_COMPRESSED"))
	Case "yenc", "ntx"
		extract("uu", "yEnc " & t("TERM_ENCODED"))
	Case "z"
		If NOT check7z() Then extract("is3arc", "InstallShield 3.x " & t("TERM_ARCHIVE"))
	Case "zip", "cbz", "jar", "xpi", "wz"
		extract("zip", "ZIP " & t("TERM_ARCHIVE"))
	Case "zoo"
		extract("zoo", "ZOO " & t("TERM_ARCHIVE"))
	Case "zpaq"
		extract("zpaq", "ZPAQ " & t("TERM_ARCHIVE"))
	Case Else
		SplashOff()
		terminate("unknownext", $file)
EndSwitch

Func filenameparse($f)
	$file = _pathfull($f)
	$filedir = StringLeft($f, StringInStr($f, "\", 0, -1) - 1)
	$filename = StringTrimLeft($f, StringInStr($f, "\", 0, -1))
	If StringInStr($filename, ".") Then
		$fileext = StringTrimLeft($filename, StringInStr($filename, ".", 0, -1))
		$filename = StringTrimRight($filename, StringLen($fileext) + 1)
		$initoutdir = $filedir & "\" & $filename
	Else
		$fileext = ""
		$initoutdir = $filedir & "\" & $filename & "_" & t("TERM_UNPACKED")
	EndIf
EndFunc

Func checkunicode()
	If StringRegExp($file, $unicodepattern, 0) Then Return 
	addlog(t("FILE_UNICODE"))
	If NOT StringRegExp(@TempDir, $unicodepattern, 0) Then Return addlog(t("TEMP_UNICODE"))
	Local $new = _tempfile(@TempDir, "Unicode_", "." & $fileext)
	SplashTextOn($title, t("MOVE_COPY_FILES") & @CRLF & t("TO", createarray($file, $new)), (StringLen($file) + StringLen($new) + 4) * 6, 80, -1, $height, 16)
	If StringLeft($file, 1) = StringLeft($new, 1) Then
		If NOT _filemove($file, $new) Then Return 
		$unicodemode = "Move"
	Else
		If NOT _filecopy($file, $new) Then Return 
		$unicodemode = "Copy"
	EndIf
	SplashOff()
	$oldpath = $file
	$oldname = $filename
	$oldoutdir = $outdir
	filenameparse($new)
	$outdir = $initoutdir
	$validdir = _dircreate($outdir)
	If NOT $validdir Then terminate("invaliddir", $outdir)
	$createdir = True
EndFunc

Func envparse($string)
	$arr = StringRegExp($string, "%.*%", 2)
	For $i = 0 To UBound($arr) - 1
		$string = StringReplace($string, $arr[$i], EnvGet(StringReplace($arr[$i], "%", "")))
	Next
	Return $string
EndFunc

Func t($t, $vars = "")
	Local $ldir = @ScriptDir
	If $language <> "English" Then $ldir &= "\lang"
	$return = IniRead($ldir & "\" & $language & ".ini", "UniExtract", $t, "")
	If $return == "" Then
		addlog(t("NOT_TRANLATION", createarray($t)))
		$return = IniRead(@ScriptDir & "\English.ini", "UniExtract", $t, "???")
		If $return = "???" Then
			addlog(t("WARN_TRANLATION", createarray($t)))
			Return $t
		EndIf
	EndIf
	$return = StringReplace($return, "%n", @CRLF)
	$return = StringReplace($return, "%t", @TAB)
	For $i = 0 To UBound($vars) - 1
		$return = StringReplace($return, "%s", $vars[$i], 1)
	Next
	Return $return
EndFunc

Func readprefs()
	addlog(t("READING_FROM") & " " & "UniExtract.ini")
	$section = "UniExtract Preferences"
	loadpref("globalprefs", $globalprefs)
	loadpref("history", $history)
	loadpref("debugdir", $debugdir, "Ini", False)
	loadpref("logdir", $logdir, "Ini", False)
	loadpref("language", $language, "Ini", False)
	loadpref("appendext", $appendext)
	loadpref("removetemp", $removetemp)
	loadpref("removedupe", $removedupe)
	loadpref("warnexecute", $warnexecute)
	loadpref("nodoswin", $nodoswin)
	loadpref("mindoswin", $mindoswin)
	loadpref("useepe", $useepe)
	loadpref("usedie", $usedie)
	loadpref("usepeid", $usepeid)
	loadpref("savepass", $savepass)
	loadpref("savelog", $savelog)
	loadpref("savelogalways", $savelogalways)
	If NOT $globalprefs Then
		addlog()
		addlog(t("READING_FROM") & " " & t("REGISTRY"))
		loadpref("history", $history, "Reg")
		loadpref("debugdir", $debugdir, "Reg", False)
		loadpref("logdir", $logdir, "Reg", False)
		loadpref("language", $language, "Reg", False)
		loadpref("appendext", $appendext, "Reg")
		loadpref("removetemp", $removetemp, "Reg")
		loadpref("removedupe", $removedupe, "Reg")
		loadpref("warnexecute", $warnexecute, "Reg")
		loadpref("nodoswin", $nodoswin, "Reg")
		loadpref("mindoswin", $mindoswin, "Reg")
		loadpref("useepe", $useepe, "Reg")
		loadpref("usedie", $usedie, "Reg")
		loadpref("usepeid", $usepeid, "Reg")
		loadpref("savepass", $savepass, "Reg")
		loadpref("savelog", $savelog, "Reg")
		loadpref("savelogalways", $savelog, "Reg")
	EndIf
EndFunc

Func loadpref($name, ByRef $value, $dest = "Ini", $int = True)
	If $dest = "Ini" Then
		Local $return = IniRead($prefs, $section, $name, "")
	Else
		Local $return = RegRead($reg, $name)
	EndIf
	If @error OR $return = "" Then
		addlog(t("ERROR_READING_OPTION", createarray($name, $value)))
		Return SetError(1, "", -1)
	EndIf
	If $int Then
		$value = Int($return)
	Else
		$value = $return
	EndIf
	addlog(t("OPTION", createarray($name, $value)))
EndFunc

Func writeprefs()
	addlog()
	addlog(t("SAVE_PREF"))
	If $globalprefs Then
		$section = "UniExtract Preferences"
		addlog(t("SAVING_TO") & " " & "UniExtract.ini")
		savepref("globalprefs", $globalprefs)
		savepref("history", $history)
		savepref("debugdir", $debugdir)
		savepref("logdir", $logdir)
		savepref("language", $language)
		savepref("appendext", $appendext)
		savepref("removetemp", $removetemp)
		savepref("removedupe", $removedupe)
		savepref("warnexecute", $warnexecute)
		savepref("nodoswin", $nodoswin)
		savepref("mindoswin", $mindoswin)
		savepref("useepe", $useepe)
		savepref("usedie", $usedie)
		savepref("usepeid", $usepeid)
		savepref("savepass", $savepass)
		savepref("savelog", $savelog)
		savepref("savelogalways", $savelogalways)
	Else
		addlog(t("SAVING_TO") & " " & t("REGISTRY"))
		savepref("history", $history, "Reg")
		savepref("debugdir", $debugdir, "Reg")
		savepref("logdir", $logdir, "Reg")
		savepref("language", $language, "Reg")
		savepref("appendext", $appendext, "Reg")
		savepref("removetemp", $removetemp, "Reg")
		savepref("removedupe", $removedupe, "Reg")
		savepref("warnexecute", $warnexecute, "Reg")
		savepref("nodoswin", $nodoswin, "Reg")
		savepref("mindoswin", $mindoswin, "Reg")
		savepref("useepe", $useepe, "Reg")
		savepref("usedie", $usedie, "Reg")
		savepref("usepeid", $usepeid, "Reg")
		savepref("savepass", $savepass, "Reg")
		savepref("savelog", $savelog, "Reg")
		savepref("savelogalways", $savelog, "Reg")
	EndIf
EndFunc

Func savepref($name, $value, $dest = "Ini")
	If $dest = "Ini" Then
		IniWrite($prefs, $section, $name, $value)
	Else
		RegWrite($reg, $name, "REG_SZ", $value)
	EndIf
	addlog(t("SAVING", createarray($name, $value)))
EndFunc

Func readhist($field)
	Local $items
	If $globalprefs Then
		If $field = "file" Then
			$section = "File History"
		ElseIf $field = "directory" Then
			$section = "Directory History"
		Else
			Return 
		EndIf
		For $i = 0 To 9
			$value = IniRead($prefs, $section, $i, "")
			If $value <> "" Then $items &= "|" & $value
		Next
	Else
		If $field = "file" Then
			$key = $reg & "\File"
		ElseIf $field = "directory" Then
			$key = $reg & "\Directory"
		Else
			Return 
		EndIf
		For $i = 0 To 9
			$value = RegRead($key, $i)
			If $value <> "" Then $items &= "|" & $value
		Next
	EndIf
	Return StringTrimLeft($items, 1)
EndFunc

Func writehist($field, $new)
	If $globalprefs Then
		If $field = "file" Then
			$section = "File History"
		ElseIf $field = "directory" Then
			$section = "Directory History"
		Else
			Return 
		EndIf
		$histarr = StringSplit(readhist($field), "|")
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
	Else
		If $field = "file" Then
			$key = $reg & "\File"
		ElseIf $field = "directory" Then
			$key = $reg & "\Directory"
		Else
			Return 
		EndIf
		$histarr = StringSplit(readhist($field), "|")
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

Func filescan($f, $analyze = 1)
	$filetype = ""
	SplashTextOn($title, t("SCANNING_EXE", createarray("TrID")), 330, 70, -1, $height, 16)
	addlog(t("START_FILESCAN", createarray($f, "TrID")))
	$return = StringSplit(fetchstdout($cmd & $trid & ' "' & $f & '"', $filedir, @SW_HIDE, False), @CRLF, 1)
	For $i = 1 To UBound($return) - 1
		If StringInStr($return[$i], "%") OR (NOT $analyze AND (StringInStr($return[$i], "Related URL") OR StringInStr($return[$i], "Remarks"))) Then $filetype &= $return[$i] & @CRLF
	Next
	$log &= $filetype
	If NOT $analyze Then Return $filetype
	addlog(t("MATCH_PATTERN"))
	Select 
		Case StringInStr($filetype, "7-Zip compressed archive", 0)
			extract("7z", "7-Zip " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "ACE compressed archive", 0) OR StringInStr($filetype, "ACE Self-Extracting Archive", 0)
			extract("ace", t("TERM_SFX") & " ACE " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "ALZip compressed archive")
			checkalz()
		Case StringInStr($filetype, "FreeArc compressed archive", 0)
			extract("freearc", "FreeARC " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Android boot image")
			extract("bootimg", " Android boot " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "ARC Compressed archive", 0) AND NOT StringInStr($filetype, "UHARC", 0)
			extract("arc", "ARC " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "ARJ compressed archive", 0)
			extract("7z", "ARJ " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "bzip2 compressed archive", 0)
			extract("bz2", "bzip2 " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "Microsoft Cabinet Archive", 0) OR StringInStr($filetype, "IncrediMail letter/ecard", 0)
			If $fileext = "msu" Then
				extract("msu", "Windows Update (MSU) " & t("TERM_PATCH"))
			Else
				extract("cab", "Microsoft CAB " & t("TERM_ARCHIVE"))
			EndIf
		Case StringInStr($filetype, "(.CHM) Windows HELP File", 0)
			extract("chm", "Compiled HTML " & t("TERM_HELP"))
		Case StringInStr($filetype, "CPIO Archive", 0)
			extract("7z", "CPIO " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Debian Linux Package", 0)
			extract("7z", "Debian " & t("TERM_PackAGE"))
		Case StringInStr($filetype, "DGCA Digital G Codec Archiver", 0)
			extract("dgca", "DGCA " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Disk Image (Macintosh)", 0)
			extract("ctar", "DMG " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "Gentee Installer executable", 0)
			extract("ie", "Gentee " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "GZipped File", 0)
			extract("gz", "gzip " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "(.HLP) Windows Help file", 0)
			extract("hlp", "Windows " & t("TERM_HELP"))
		Case StringInStr($filetype, "Generic PC disk image", 0)
			extract("img", "Floppy " & t("TERM_DISK") & " " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "Google Chrome Extension", 0)
			extract("crx", "Google Chrome Plugin/Extension " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "Inno Setup installer", 0)
			checkinno()
		Case StringInStr($filetype, "Installer VISE executable", 0)
			extract("ie", "Installer VISE " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "InstallShield archive", 0)
			extract("is3arc", "InstallShield 3.x " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "InstallShield compressed archive", 0)
			extract("iscab", "InstallShield CAB " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "ISO CDImage", 0)
			extract("iso", "CD-ROM " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "ISo Zipped format", 0)
			extract("to", "ISZ CD-ROM (UltraISO) " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "KGB archive", 0)
			extract("kgb", "KGB " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "LHARC/LZARK compressed archive", 0)
			extract("7z", "LZH " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "lzop compressed", 0)
			extract("lzo", "LZO " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "LZX Amiga compressed archive", 0)
			extract("lzx", "LZX " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "Macromedia Flash Player", 0)
			extract("swf", "Shockwave Flash " & t("TERM_CONTAINER"))
		Case StringInStr($filetype, "Microsoft Internet Explorer Web Archive", 0)
			extract("mht", "MHTML " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Microsoft Reader eBook", 0)
			extract("lit", "Microsoft LIT " & t("TERM_EBOOK"))
		Case StringInStr($filetype, "Microsoft Windows Installer merge module", 0)
			extract("msm", "Windows Installer (MSM) " & t("TERM_MERGE_MODULE"))
		Case StringInStr($filetype, "Microsoft Windows Installer package", 0)
			extract("msi", "Windows Installer (MSI) " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Microsoft Windows Installer patch", 0)
			extract("msp", "Windows Installer (MSP) " & t("TERM_PATCH"))
		Case StringInStr($filetype, "(.MSU) Windows Update Package")
			extract("msu", "Windows Update (MSU) " & t("TERM_PATCH"))
		Case StringInStr($filetype, "HTC NBH ROM Image", 0)
			extract("nbh", "NBH " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "Outlook Express E-mail folder", 0)
			extract("dbx", "Outlook Express " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "PEA archive", 0)
			extract("pea", "Pea " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "(.PDF) Adobe Portable Document Format", 0)
			extract("pdf", "PDF " & t("TERM_EBOOK"))
		Case StringInStr($filetype, "PowerISO Direct-Access-Archive", 0) OR StringInStr($filetype, "gBurner Image", 0)
			extract("daa", "DAA/GBI " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "RAR Archive", 0)
			extract("rar", "RAR " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "RAR Self Extracting archive", 0)
			checkzip()
			extract("rar", "RAR " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Reflexive Arcade installer wrapper", 0)
			extract("inno", "Reflexive Arcade " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "(.RPM) RPM Package", 0)
			extract("7z", "RPM " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Setup Factory 6.x Installer", 0)
			extract("ie", "Setup Factory " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "StuffIT SIT compressed archive", 0)
			extract("sit", "StuffIt " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "SymbianOS Installer", 0)
			extract("sis", "SymbianOS " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "TAR archive", 0)
			extract("tar", "Tar " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "UHARC compressed archive", 0)
			extract("uha", "UHARC " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Magic ISO Universal Image Format", 0)
			extract("uif", "UIF " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "Base64 Encoded file", 0)
			extract("uu", "Base64 " & t("TERM_ENCODED"))
		Case StringInStr($filetype, "Quoted-Printable Encoded file", 0)
			extract("uu", "Quoted-Printable " & t("TERM_ENCODED"))
		Case StringInStr($filetype, "UUencoded file", 0) OR StringInStr($filetype, "XXencoded file", 0)
			extract("uu", "UUencoded " & t("TERM_ENCODED"))
		Case StringInStr($filetype, "yEnc Encoded file", 0)
			extract("uu", "yEnc " & t("TERM_ENCODED"))
		Case StringInStr($filetype, "Windows Imaging Format", 0)
			extract("7z", "WIM " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "Wise Installer Executable", 0)
			extract("wise", "Wise Installer " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "xz container", 0)
			extract("xz", "XZ " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "UNIX Compressed file", 0)
			extract("Z", "LZW " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "ZIP compressed archive", 0) OR StringInStr($filetype, "Winzip Win32 self-extracting archive", 0)
			extract("zip", "ZIP " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Zip Self-Extracting archive", 0)
			checkinno()
		Case StringInStr($filetype, "ZOO compressed archive", 0)
			extract("zoo", "ZOO " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "ZPAQ compressed archive", 0)
			extract("zpaq", "ZPAQ " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "LZMA compressed file", 0)
			check7z()
		Case StringInStr($filetype, "InstallShield setup", 0)
			checkinstallshield()
	EndSelect
	addlog(t("NO_MATCH"))
EndFunc

Func epescan($f, $analyze = 1)
	SplashTextOn($title, t("SCANNING_EXE", createarray("Exeinfo PE")), 330, 70, -1, $height, 16)
	addlog()
	addlog(t("START_FILESCAN", createarray($f, "Exeinfo PE")))
	Local $regpepe = False, $regarray, $regkey = "HKCU\Software\ExEi-pe"
	RegEnumVal($regkey, 1)
	If @error Then
		$regpepe = True
	Else
		$regarray = _regenumkeyex($regkey, 2 + 128 + 256)
	EndIf
	RegWrite($regkey, "ExeError", "REG_DWORD", 1)
	RegWrite($regkey, "AllwaysOnTop", "REG_DWORD", 0)
	RegWrite($regkey, "Shell_integr", "REG_DWORD", 0)
	RegWrite($regkey, "Lang", "REG_DWORD", 0)
	RegWrite($regkey, "Skin", "REG_DWORD", 0)
	RegWrite($regkey, "Scan", "REG_DWORD", 0)
	RegWrite($regkey, "Log", "REG_DWORD", -1)
	RegWrite($regkey, "Big_GUI", "REG_DWORD", 0)
	RegWrite($regkey, "closeExEi_whenExtRun", "REG_DWORD", 0)
	addlog(t("SCANNING_EPE_STANDART"))
	RunWait($epe & ' "' & $f & '*" /sx /lol:' & $debugfile, $filedir, @SW_HIDE)
	$filetype = ""
	$infile = FileOpen($debugfile, 0)
	$filetype = FileRead($infile)
	FileClose($infile)
	$log &= $filetype
	addlog(t("SCANNING_EPE_EXTERNAL"))
	RunWait($epe & ' "' & $f & '*" /se /lol:' & $debugfile, $filedir, @SW_HIDE)
	$filetypeext = ""
	$infile = FileOpen($debugfile, 0)
	$filetypeext = FileRead($infile)
	FileClose($infile)
	$log &= $filetypeext
	$filetype &= $filetypeext
	_filedelete($debugfile)
	If $regpepe Then
		RegDelete($regkey)
	Else
		writereg($regarray)
	EndIf
	If NOT $analyze Then Return $filetype
	matchpatterns()
	$testhex = True
	Return $filetype
EndFunc

Func diescan($f, $analyze = 1)
	SplashTextOn($title, t("SCANNING_EXE", createarray("Detect-It-Easy")), 330, 70, -1, $height, 16)
	addlog()
	addlog(t("START_FILESCAN", createarray($f, "Detect-It-Easy")))
	$filetype = fetchstdout($cmd & $die & ' "' & $f & '" -fullscan:yes', $filedir, @SW_HIDE)
	$log &= $filetype
	If NOT $analyze Then Return $filetype
	matchpatterns()
	$testhex = True
	Return $filetype
EndFunc

Func exescan($f, $scantype, $analyze = 1)
	SplashTextOn($title, t("START_FILESCAN", createarray($f, "PEiD")) & " (" & $scantype & ")", 330, 60, -1, $height, 16)
	addlog()
	addlog(t("START_FILESCAN", createarray($f, "PEiD")) & " (" & $scantype & ")")
	RegRead("HKCU\Software\PEiD", "")
	If @error = 1 Then $regpeid = 1
	$exsig = RegRead("HKCU\Software\PEiD", "ExSig")
	$loadplugins = RegRead("HKCU\Software\PEiD", "LoadPlugins")
	$stayontop = RegRead("HKCU\Software\PEiD", "StayOnTop")
	RegWrite("HKCU\Software\PEiD", "ExSig", "REG_DWORD", 1)
	RegWrite("HKCU\Software\PEiD", "LoadPlugins", "REG_DWORD", 0)
	RegWrite("HKCU\Software\PEiD", "StayOnTop", "REG_DWORD", 0)
	$filetype = ""
	Run($peid & " -" & $scantype & ' "' & $f & '"', @ScriptDir, @SW_HIDE)
	WinWait($peidtitle)
	While ($filetype = "") OR ($filetype = "Scanning...")
		Sleep(100)
		$filetype = ControlGetText($peidtitle, "", "Edit2")
	WEnd
	WinClose($peidtitle)
	$log &= $filetype & @CRLF
	If $regpeid <> 1 Then
		If $exsig Then RegWrite("HKCU\Software\PEiD", "ExSig", "REG_DWORD", $exsig)
		If $loadplugins Then RegWrite("HKCU\Software\PEiD", "LoadPlugins", "REG_DWORD", $loadplugins)
		If $stayontop Then RegWrite("HKCU\Software\PEiD", "StayOnTop", "REG_DWORD", $stayontop)
	Else
		RegDelete("HKCU\Software\PEiD")
	EndIf
	SplashOff()
	If NOT $analyze Then Return $filetype
	matchpatterns()
	If $scantype == "ext" Then $testhex = True
	If NOT ($scantype == "ext") Then $test7z = False
	Return $filetype
EndFunc

Func matchpatterns()
	addlog(t("MATCH_PATTERN"))
	Select 
		Case StringInStr($filetype, "7-Zip", 0) AND NOT StringInStr($filetype, "WiX Installer", 0)
			extract("7z", t("TERM_SFX") & " 7-Zip " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Advanced Installer", 0)
			extract("cai", "Advanced Installer " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, ".ALZ  ALZip")
			checkalz()
		Case StringInStr($filetype, "Android boot image")
			extract("bootimg", " Android boot " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "ARJ SFX", 0)
			extract("7z", t("TERM_SFX") & " ARJ " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "DGCA", 0)
			extract("dgca", "DGCA " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, ".dmg  Mac OS", 0)
			extract("ctar", "DMG " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "Enigma Virtual Box")
			extract("enigma", " Enigma Virtual Box " & t("TERM_EXECUTABLE"))
		Case StringInStr($filetype, "Excelsior Installer", 0)
			extract("ei", "Excelsior Installer " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "FreeArc", 0)
			extract("freearc", "FreeArc " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Gentee Installer", 0) OR StringInStr($filetype, "CreateInstall", 0)
			extract("gentee", "Gentee " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "Inno Setup", 0)
			checkinno()
		Case StringInStr($filetype, "InstallAware", 0)
			extract("7z", "InstallAware " & t("TERM_INSTALLER") & " " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Installer VISE", 0) OR StringInStr($filetype, "VISE Installer", 0) OR StringInStr($filetype, "Installer - VISE", 0)
			extract("ie", "Installer VISE " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "InstallShield", 0)
			If NOT $isfailed Then extract("isexe", "InstallShield " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "ISZ", 0)
			extract("to", "ISZ CD-ROM (UltraISO) " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "KGB SFX", 0)
			extract("kgb", t("TERM_SFX") & " KGB " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Microsoft SFX CAB", 0) AND NOT StringInStr($filetype, "WiX Installer", 0)
			check7z()
		Case StringInStr($filetype, "Microsoft Visual C++", 0) AND NOT StringInStr($filetype, "SPx Method", 0) AND NOT StringInStr($filetype, "Custom", 0) AND NOT StringInStr($filetype, "7.0", 0) AND NOT StringInStr($filetype, "RAR SFX", 0) AND NOT StringInStr($filetype, "Setup Factory", 0) AND NOT StringInStr($filetype, "WiX Installer", 0)
			$test7z = True
			$testie = True
		Case StringInStr($filetype, "Microsoft Visual C++ 7.0", 0) AND StringInStr($filetype, "Custom", 0) AND NOT StringInStr($filetype, "Hotfix", 0)
			extract("vssfx", "Visual C++ " & t("TERM_SFX") & " " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "Microsoft Visual C++ 6.0", 0) AND StringInStr($filetype, "Custom", 0)
			extract("vssfxpath", "Visual C++ " & t("TERM_SFX") & "" & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "Netopsystems FEAD Optimizer", 0)
			extract("fead", "Netopsystems FEAD " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "Nullsoft", 0)
			checknsis()
		Case StringInStr($filetype, "PowerISO Direct-Access-Archive", 0)
			extract("daa", "DAA/GBI " & t("TERM_IMAGE"))
		Case StringInStr($filetype, "PDF", 0)
			extract("pdf", "PDF " & t("TERM_EBOOK"))
		Case StringInStr($filetype, "PEtite", 0) AND NOT StringInStr($filetype, "WinAce / SFX Factory", 0)
			$testace = True
		Case StringInStr($filetype, "RAR SFX", 0) OR StringInStr($filetype, "WINRAR", 0) AND NOT StringInStr($filetype, "WiX Installer", 0)
			extract("rar", t("TERM_SFX") & " RAR " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Reflexive Arcade Installer", 0)
			extract("inno", "Reflexive Arcade " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "RoboForm Installer", 0)
			extract("robo", "RoboForm " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "Setup Factory", 0)
			extract("sf", "Setup Factory " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Smart Install Maker")
			extract("sim", "Smart Install Maker " & t("TERM_INSTALLER"))
		Case StringInStr($filetype, "SPx Method", 0) OR StringInStr($filetype, "CAB SFX", 0) OR StringInStr($filetype, "Microsoft Cabinet File", 0) OR StringInStr($filetype, "Cabinet Self-Extractor", 0) AND NOT StringInStr($filetype, "WiX Installer", 0)
			extract("cab", t("TERM_SFX") & " Microsoft CAB " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Sqx", 0)
			extract("sqx", t("TERM_SFX") & " SQX " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "SuperDAT", 0)
			extract("superdat", "McAfee SuperDAT " & t("TERM_UPDATER"))
		Case StringInStr($filetype, "SWF", 0)
			extract("swf", "Shockwave Flash " & t("TERM_CONTAINER"))
		Case StringInStr($filetype, "ThinyApp Packager", 0) OR StringInStr($filetype, "Thinstall", 0) OR StringInStr($filetype, "VMware ThinApp", 0)
			extract("thinstall", "ThinApp/Thinstall" & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "WinAce / SFX Factory", 0)
			extract("ace", t("TERM_SFX") & " ACE " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "Wise", 0) OR StringInStr($filetype, "PEncrypt 4.0", 0)
			extract("wise", "Wise Installer " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "WiX Installer", 0)
			extract("ms_vcr", "WiX Installer " & t("TERM_PACKAGE"))
		Case StringInStr($filetype, "XZ compressed data")
			extract("xz", "XZ " & t("TERM_COMPRESSED"))
		Case StringInStr($filetype, "ZIP SFX", 0)
			extract("zip", t("TERM_SFX") & " ZIP " & t("TERM_ARCHIVE"))
		Case StringInStr($filetype, "upx", 0) OR StringInStr($filetype, "aspack", 0) AND NOT $packfailed
			$packed = True
		Case StringInStr($filetype, "Borland Delphi", 0) AND NOT StringInStr($filetype, "RAR SFX", 0) AND NOT StringInStr($filetype, "WinAce / SFX Factory", 0) AND NOT StringInStr($filetype, "Enigma Virtual Box")
			$testinno = True
			$testzip = True
		Case Else
			addlog(t("NO_MATCH"))
			$test7z = True
			$testzip = True
			$testie = True
	EndSelect
EndFunc

Func check7z()
	addlog()
	addlog(t("TERM_TESTING") & " 7-Zip " & t("TERM_INSTALLER"))
	SplashTextOn($title, t("TERM_TESTING") & " 7-Zip " & t("TERM_INSTALLER"), 330, 50, -1, $height, 16)
	$return = fetchstdout($cmd & $7z & ' l -p "' & $file & '"', $filedir, @SW_HIDE)
	If (StringInStr($return, "Listing archive:") OR StringInStr($return, "Wrong password?")) AND NOT StringInStr($return, "Can not open the file as archive") Then
		If StringInStr($return, "_sfx_manifest_") Then
			SplashOff()
			extract("hotfix", "Microsoft " & t("TERM_HOTFIX"))
		EndIf
		SplashOff()
		Switch $fileext
			Case "exe"
				extract("7z", "7-Zip " & t("TERM_INSTALLER") & " " & t("TERM_PACKAGE"))
			Case "xz"
				extract("xz", "XZ " & t("TERM_COMPRESSED"))
			Case "z"
				extract("Z", "LZW " & t("TERM_COMPRESSED"))
		EndSwitch
	EndIf
	SplashOff()
	$7zfailed = True
	addlog(t("FALSE_TESTING") & " 7-Zip " & t("INSTALLER"))
	Return False
EndFunc

Func checkalz()
	addlog()
	addlog(t("TERM_TESTING") & " ALZ " & t("TERM_ARCHIVE"))
	SplashTextOn($title, t("TERM_TESTING") & " ALZ " & t("TERM_ARCHIVE"), 330, 50, -1, $height, 16)
	$return = fetchstdout($cmd & $alz & ' -l "' & $file & '"', $filedir, @SW_HIDE)
	If (StringInStr($return, "Listing archive:", 0) AND NOT StringInStr($return, "corrupted file", 0) AND NOT StringInStr($return, "file open error", 0)) Then
		SplashOff()
		extract("alz", "ALZ " & t("TERM_ARCHIVE"))
	EndIf
	addlog(t("FALSE_TESTING") & " ALZ " & t("ARCHIVE"))
	Return False
EndFunc

Func checkace()
	addlog()
	addlog(t("TERM_TESTING") & " ACE " & t("TERM_ARCHIVE"))
	extract("ace", t("TERM_SFX") & " ACE " & t("TERM_ARCHIVE"))
	$acefailed = True
	addlog(t("FALSE_TESTING") & " ACE " & t("ARCHIVE"))
	Return False
EndFunc

Func checkie()
	addlog()
	addlog(t("TERM_TESTING") & " InstallExplorer " & t("TERM_INSTALLER"))
	SplashTextOn($title, t("TERM_TESTING") & " InstallExplorer " & t("TERM_INSTALLER"), 330, 65, -1, $height, 16)
	$return = StringSplit(fetchstdout($cmd & $ie & ' l "' & $file & '"', $filedir, @SW_HIDE), @CRLF)
	For $i = 1 To $return[0]
		If StringInStr($return[$i], "##") Then
			$type = StringStripWS(StringReplace(StringTrimLeft($return[$i], StringInStr($return[$i], "-> ", 0) + 2), "##", ""), 3)
			extract("ie", $type & " " & t("TERM_INSTALLER"))
		EndIf
	Next
	SplashOff()
	$iefailed = True
	addlog(t("FALSE_TESTING") & " InstallExplorer " & t("INSTALLER"))
	Return False
EndFunc

Func checkinno()
	addlog()
	addlog(t("TERM_TESTING") & " Inno Setup " & t("TERM_INSTALLER"))
	SplashTextOn($title, t("TERM_TESTING") & " Inno Setup " & t("TERM_INSTALLER"), 330, 50, -1, $height, 16)
	$return = fetchstdout($cmd & $inno & ' "' & $file & '"', $filedir, @SW_HIDE)
	If (StringInStr($return, "Version detected:", 0) AND NOT (StringInStr($return, "error", 0))) OR (StringInStr($return, "Signature detected:", 0) AND NOT StringInStr($return, "not a supported version", 0)) Then
		SplashOff()
		extract("inno", "Inno Setup " & t("TERM_INSTALLER"))
	EndIf
	SplashOff()
	$innofailed = True
	addlog(t("FALSE_TESTING") & " Inno Setup " & t("INSTALLER"))
	checkie()
	Return False
EndFunc

Func checkinstallshield()
	addlog()
	addlog(t("TERM_TESTING") & " InstallShield " & t("TERM_INSTALLER"))
	If StringInStr(diescan($file, 1), "Smart Install Maker") Then extract("sim", "Smart Install Maker " & t("TERM_INSTALLER"))
	extract("isexe", "InstallShield " & t("TERM_INSTALLER"))
	addlog(t("FALSE_TESTING") & " InstallShieldp " & t("INSTALLER"))
	Return False
EndFunc

Func checknsis()
	addlog()
	addlog(t("TERM_TESTING") & " NSIS " & t("TERM_INSTALLER"))
	SplashTextOn($title, t("TERM_TESTING") & " NSIS " & t("TERM_INSTALLER"), 330, 50, -1, $height, 16)
	$return = fetchstdout($cmd & $7z & ' l "' & $file & '"', $filedir, @SW_HIDE)
	If StringInStr($return, "Listing archive:") AND NOT StringInStr($return, "Can not open the file as archive") Then
		SplashOff()
		extract("7z", "NSIS " & t("TERM_INSTALLER"))
	EndIf
	SplashOff()
	addlog(t("FALSE_TESTING") & " NSIS " & t("INSTALLER"))
	checkie()
	Return False
EndFunc

Func checkzip()
	addlog()
	addlog(t("TERM_TESTING") & " SFX ZIP " & t("TERM_ARCHIVE"))
	SplashTextOn($title, t("TERM_TESTING") & " SFX ZIP " & t("TERM_ARCHIVE"), 330, 50, -1, $height, 16)
	$return = fetchstdout($cmd & $zip & ' -l "' & $file & '"', $filedir, @SW_HIDE)
	If NOT StringInStr($return, "signature not found", 0) AND NOT StringInStr($return, "No zipfiles found", 0) Then
		SplashOff()
		extract("zip", t("TERM_SFX") & " ZIP " & t("TERM_ARCHIVE"))
	EndIf
	SplashOff()
	$zipfailed = True
	addlog(t("FALSE_TESTING") & " SFX ZIP " & t("ARCHIVE"))
	Return False
EndFunc

Func checkhex()
	addlog()
	addlog(t("TERM_TESTING") & " AutoIt " & t("TERM_SCRIPT"))
	SplashTextOn($title, t("TERM_TESTING") & " AutoIt " & t("TERM_SCRIPT"), 330, 60, -1, $height, 16)
	$hexstring = "A3484BBE986C4AA9994C530A86D6487D"
	If _find_hexstring_in_file($file, $hexstring, 2 * 1024 * 1024) Then extract("au3", "AutoIt " & t("TERM_SCRIPT"))
	addlog(t("FALSE_TESTING") & " AutoIt " & t("SCRIPT"))
	addlog()
	addlog(t("TERM_TESTING") & " Caphyon Advanced Installer")
	SplashTextOn($title, t("TERM_TESTING") & " Caphyon Advanced Installer", 350, 80, -1, $height, 16)
	$hexstring = "0000E979FEFFFF"
	$hexstring1 = "43617068796F6E"
	$hexstring2 = "416476616E63656420496E7374616C6C6572"
	If _find_hexstring_in_file($file, $hexstring, 2 * 1024 * 1024) AND _find_hexstring_in_file($file, $hexstring1, 2 * 1024 * 1024) AND _find_hexstring_in_file($file, $hexstring2, 2 * 1024 * 1024) Then extract("cai", "Caphyon Advanced Installer " & t("TERM_EXECUTABLE"))
	SplashOff()
	addlog(t("FALSE_TESTING") & " Caphyon Advanced Installer")
	$hexfailed = True
	Return False
EndFunc

Func extract($arctype, $arcdisp)
	Global $logarcdisp = $arcdisp
	addlog()
	addlog(t("EXTRACTING") & " " & $arcdisp)
	SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 90, -1, $height, 16)
	If NOT $createdir Then $consolewin = 1
	$dirmtime = FileGetTime($outdir, 0, 1)
	$initdirsize = DirGetSize($outdir)
	$tempoutdir = _tempfile($outdir, "uni_", "")
	Switch $arctype
		Case "7z"
			Local $appendargs = ""
			If StringInStr($filetype, "Nullsoft Install System", 0) Then
				$appendargs = "-aos"
			EndIf
			If StringInStr($filetype, "Nullsoft PiMP SFX", 0) Then
				$appendargs = "-aou"
			EndIf
			Local $spassword = password($cmd & $7z & ' t -p "' & $file & '"', $cmd & $7z & ' t -p"%PASSWORD%" "' & $file & '"', "Encrypted = +", "Wrong password?", "Everything is Ok")
			logrunwait($cmd & $7z & " x " & $appendargs & ($spassword == "" ? ' "' : '-p"' & $spassword & '" "') & $file & '"' & $output, $outdir, $consolewin)
			If StringInStr($filetype, "(.RPM) RPM Package", 0) AND FileExists($outdir & "\" & ($oldname ? $oldname : $filename) & ".cpio") Then
				addlog(t("EXTRACTING_CPIO"))
				logrunwait($cmd & $7z & ' x "' & $outdir & "\" & ($oldname ? $oldname : $filename) & '.cpio"' & $output, $outdir, $consolewin)
				addlog(t("DELETE_FILE") & ' "' & $outdir & "\" & ($oldname ? $oldname : $filename) & ".cpio" & '"')
				_filedelete($outdir & "\" & ($oldname ? $oldname : $filename) & ".cpio")
			EndIf
			If StringInStr($filetype, "Debian Linux Package", 0) AND FileExists($outdir & "\data.tar") Then
				addlog(t("EXTRACTING_DEB"))
				logrunwait($cmd & $7z & ' x "' & $outdir & '\data.tar"' & $output, $outdir, $consolewin)
				addlog(t("DELETE_FILE") & ' "' & $outdir & "\data.tar" & '"')
				_filedelete($outdir & "\data.tar")
			EndIf
		Case "ace"
			addlog(t("EXECUTING") & " " & $ace & ' -x "' & $file & '" "' & $outdir & '"')
			addlog(t("RUN_OPTION", createarray($filedir, "1")))
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
			addlog(t("CANNOT_LOG", createarray($arcdisp)))
		Case "afp"
		Case "alz"
			Local $spassword = password($cmd & $alz & ' -pwd "" "' & $file & '"', $cmd & $alz & ' -pwd "%PASSWORD%" "' & $file & '"' & $output, "invalid password", "password was not set", "unalziiiing", True)
		Case "arc"
			logrunwait($cmd & $arc & ' x "' & $file & '"' & $output, $outdir, $consolewin)
		Case "au3"
			If $warnexecute Then warn_execute($au3 & ' -nogui -quiet "' & $filename & "." & $fileext & '"')
			If FileExists($filedir & "\" & $filename & "_orig" & "." & $fileext) Then
				_filecopy($filedir & "\" & $filename & "_orig" & "." & $fileext, $outdir, 9)
				_filemove($outdir & "\" & $filename & "_orig" & "." & $fileext, $outdir & "\" & $filename & "." & $fileext, 9)
			Else
				_filecopy($file, $outdir, 9)
			EndIf
			logrunwait($au3 & ' -nogui -quiet "' & $outdir & "\" & $filename & "." & $fileext & '"', $outdir, $consolewin)
			_filedelete($outdir & "\" & $filename & "." & $fileext)
		Case "bootimg"
			$ret = $outdir & "\" & $bootimg
			$ret2 = $outdir & "\boot.img"
			_filecopy(@ScriptDir & "\bin\" & $bootimg, $outdir)
			_filemove($file, $ret2)
			logrunwait($cmd & '"' & $ret & '" --unpack-bootimg' & $output, $outdir, $consolewin)
			_filemove($ret2, $filedir & "\" & $filename & "." & $fileext)
			_filedelete($ret)
		Case "bz2"
			logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			If FileExists($outdir & "\" & $filename) Then
				logrunwait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '"' & $output, $outdir, $consolewin)
				_filedelete($outdir & "\" & $filename)
			EndIf
		Case "cab"
			If StringInStr($filetype, "Type 1", 0) Then
				If $warnexecute Then warn_execute($filename & '.exe /q /x:"<outdir>"')
				logrunwait('"' & $file & '" /q /x:"' & $outdir & '"' & $output, $outdir, $consolewin)
			Else
				logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			EndIf
		Case "cai"
			If $warnexecute Then warn_execute($filename & '.exe /extract:"<outdir>"')
			logrunwait('"' & $file & '" /extract:"' & $outdir & '"', $outdir, $consolewin)
		Case "cdi"
			SplashOff()
			$convert = MsgBox(65, $title, t("CONVERT_CDROM", createarray("CDI")))
			If $convert <> 1 Then
				If $createdir Then _dirremove($outdir, 0)
				terminate("silent")
			EndIf
			SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
			_dircreate($tempoutdir)
			ControlSetText($title, "", "Static1", t("EXTRACTING") & @CRLF & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 1)")
			addlog(t("EXTRACTING") & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 1)")
			logrunwait($cmd & $cdi & ' "' & $file & '" -iso' & $output, $tempoutdir, $consolewin)
			$isos = FileFindFirstFile($tempoutdir & "\*.iso")
			$isofile = $tempoutdir & "\" & FileFindNextFile($isos)
			FileClose($isos)
		Case "chm"
			logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			_filedelete($outdir & "\#*")
			_filedelete($outdir & "\$*")
			$dirs = FileFindFirstFile($outdir & "\*")
			If $dirs <> -1 Then
				$dir = FileFindNextFile($dirs)
				Do
					If StringLeft($dir, 1) == "#" OR StringLeft($dir, 1) == "$" Then _dirremove($outdir & "\" & $dir, 1)
					$dir = FileFindNextFile($dirs)
				Until @error
			EndIf
			FileClose($dirs)
		Case "crx"
			logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
		Case "ctar"
			$oldfiles = returnfiles($outdir)
			logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			$handle = FileFindFirstFile($outdir & "\*")
			If NOT @error Then
				While 1
					$fname = FileFindNextFile($handle)
					If @error Then ExitLoop
					If NOT StringInStr($oldfiles, $fname) Then
						$return = fetchstdout($cmd & $7z & ' l "' & $outdir & "\" & $fname & '"', $outdir, @SW_HIDE)
						If StringInStr($return, "Listing archive:", 0) Then
							logrunwait($cmd & $7z & ' x "' & $outdir & "\" & $fname & '"' & $output, $outdir, $consolewin)
							_filedelete($outdir & "\" & $fname)
						EndIf
					EndIf
				WEnd
			EndIf
			FileClose($handle)
		Case "daa"
			SplashOff()
			$convert = MsgBox(65, $title, t("CONVERT_CDROM", createarray("CDI")))
			If $convert <> 1 Then
				If $createdir Then _dirremove($outdir, 0)
				terminate("silent")
			EndIf
			SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
			_dircreate($tempoutdir)
			ControlSetText($title, "", "Static1", t("EXTRACTING") & @CRLF & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 1)")
			addlog(t("EXTRACTING") & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 1)")
			$isofile = $tempoutdir & "\" & $filename & ".iso"
			logrunwait($cmd & $daa & ' "' & $file & '" "' & $isofile & '"' & $output, $tempoutdir, $consolewin)
		Case "dgca"
			Local $spassword = password($cmd & $dgca & ' e "' & $file & '"', $cmd & $dgca & ' l -p%PASSWORD% "' & $file & '"', "Archive encrypted.", 0, "-------------------------")
			logrunwait($cmd & $dgca & " e " & ($spassword == "" ? '"' : "-p" & $spassword & ' "') & $file & '" "' & $outdir & '"' & $output, $outdir, $consolewin)
		Case "ei"
			If $warnexecute Then warn_execute($filename & '.exe /batch /no-reg /no-postinstall /dest "<outdir>"')
			logrunwait($cmd & '"' & $file & '" /batch /no-reg /no-postinstall /dest "' & $outdir & '"' & $output, $outdir, $consolewin)
		Case "enigma"
			addlog(t("EXECUTING") & " " & $enigma & ' "' & $file & '"')
			addlog(t("RUN_OPTION", createarray($outdir, "1")))
			Run($enigma & ' "' & $file & '"', $outdir)
			WinWait("EnigmaVBUnpacker")
			WinClose("EnigmaVBUnpacker")
			addlog(t("CANNOT_LOG", createarray($arcdisp)))
			movefiles($filedir & "\%DEFAULT FOLDER%", $outdir)
			_dirremove($filedir & "\%DEFAULT FOLDER%")
			_filedelete($filedir & "\" & $filename & "_unpacked.exe")
		Case "dbx"
			logrunwait($cmd & $dbx & ' x "' & $file & '" "' & $outdir & '\"' & $output, $filedir, $consolewin)
		Case "fead"
			If $warnexecute Then warn_execute($filename & '.exe /s -nos_ne -nos_o"<outdir>"')
			logrunwait($file & ' /s -nos_ne -nos_o"' & $tempoutdir & '"' & $output, $filedir, $consolewin)
			FileSetAttrib($tempoutdir & "\*", "-R", 1)
			movefiles($tempoutdir, $outdir)
			_dirremove($tempoutdir)
		Case "freearc"
			logrunwait($cmd & $unarc & ' x "' & $file & '" -o+ -dp"' & $outdir & '"' & $output, $outdir, $consolewin)
		Case "gentee"
			$choice = methodselect($arctype, $arcdisp)
			If $choice == "Gentee TC 1 (InstExpl.wcx)" Then
				logrunwait($cmd & $ie & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			ElseIf $choice == "Gentee TC 2 (TotalObserver.wcx)" Then
				logrunwait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			EndIf
		Case "gz"
			logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			If FileExists($outdir & "\" & $filename) AND StringTrimLeft($filename, StringInStr($filename, ".", 0, -1)) = "tar" Then
				logrunwait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '"' & $output, $outdir, $consolewin)
				_filedelete($outdir & "\" & $filename)
			EndIf
		Case "hlp"
			logrunwait($cmd & $hlp & ' "' & $file & '"' & $output, $outdir, $consolewin)
			If DirGetSize($outdir) > $initdirsize Then
				_dircreate($tempoutdir)
				logrunwait($cmd & $hlp & ' /r /n "' & $file & '"' & $output, $tempoutdir, $consolewin)
				_filemove($tempoutdir & "\" & $filename & ".rtf", $outdir & "\" & $filename & "_Reconstructed.rtf")
				_dirremove($tempoutdir, 1)
			EndIf
		Case "hotfix"
			If $warnexecute Then warn_execute($filename & '.exe /q /x:"<outdir>"')
			logrunwait('"' & $file & '" /q /x:"' & $outdir & '"' & $output, $outdir, $consolewin)
		Case "ie"
			_dircreate($tempoutdir)
			logrunwait($cmd & $ie & ' x "' & $file & '" "' & $tempoutdir & '"' & $output, $filedir, $consolewin)
			If $removedupe Then
				Local $iefiles[1]
				$infile = FileOpen($debugfile, 0)
				$line = FileReadLine($infile, 12)
				Do
					_arrayadd($iefiles, StringTrimLeft($line, StringInStr($line, "-> ", 0) + 2))
					$line = FileReadLine($infile)
				Until @error
				$exfiles = filesearch($tempoutdir)
				For $i = 1 To $exfiles[0]
					For $j = 1 To UBound($iefiles) - 1
						If $exfiles[$i] = $tempoutdir & "\" & $iefiles[$j] Then
							ContinueLoop 2
						EndIf
					Next
					_filedelete($exfiles[$i])
				Next
				For $i = 1 To $exfiles[0]
					If StringInStr(FileGetAttrib($exfiles[$i]), "D") Then
						If DirGetSize($exfiles[$i]) == 0 Then
							_dirremove($exfiles[$i], 1)
						EndIf
					EndIf
				Next
			EndIf
			If $appendext Then
				appendextensions($tempoutdir)
			EndIf
			movefiles($tempoutdir & "\т", $tempoutdir)
			_dirremove($tempoutdir & "\т")
			movefiles($tempoutdir, $outdir)
			_dirremove($tempoutdir)
		Case "img"
			logrunwait($cmd & $img & ' x "' & $outdir & "\" & $filename & '"' & $output, $outdir, $consolewin)
		Case "inno"
			If StringInStr($filetype, "Reflexive Arcade", 0) Then
				_dircreate($tempoutdir)
				logrunwait($cmd & $rai & ' "' & $file & '" "' & $tempoutdir & "\" & $filename & '.exe"' & $output, $filedir, $consolewin)
				Local $spassword = password($cmd & $inno & ' -t "' & $tempoutdir & "\" & $filename & '.exe"', $cmd & "echo %PASSWORD%|" & $inno & ' -t "' & $tempoutdir & "\" & $filename & '.exe" -p', "Type in a password", 0, "Reading slice")
				logrunwait($cmd & $inno & " -x -m -a " & ($spassword == "" ? '"' : '-p"' & $spassword & '" "') & $tempoutdir & "\" & $filename & '.exe"' & $output, $outdir, $consolewin)
				_filedelete($tempoutdir & "\" & $filename & ".exe")
				_dirremove($tempoutdir)
			Else
				Local $spassword = password($cmd & $inno & ' -t "' & $file & '"', $cmd & "echo %PASSWORD%|" & $inno & ' -t "' & $file & '" -p', "Type in a password", 0, "Reading slice")
				logrunwait($cmd & $inno & " -x -m -a " & ($spassword == "" ? '"' : '-p"' & $spassword & '" "') & $file & '"' & $output, $outdir, $consolewin)
			EndIf
		Case "is3arc"
			$choice = methodselect($arctype, $arcdisp)
			If $choice == "i3comp" Then
				logrunwait($cmd & $is3arc & ' "' & $file & '" *.* -d -i' & $output, $outdir, $consolewin)
			ElseIf $choice == "STIX" Then
				logrunwait($cmd & $is3exe & " " & FileGetShortName($file) & " " & FileGetShortName($outdir) & $output, $filedir, $consolewin)
			EndIf
		Case "iscab"
			If DirGetSize($outdir) <= $initdirsize Then
				$return = fetchstdout($cmd & $iscab_unshield & ' l "' & $file & '"', $filedir, @SW_HIDE)
				If NOT StringInStr($return, "Failed to open", 0) Then
					logrunwait($cmd & $iscab_unshield & ' -d "' & $outdir & '" -D 3 x "' & $file & '"' & $output, $outdir, $consolewin)
				Else
					Local $isfiles[1]
					$line = StringSplit(fetchstdout($cmd & $is6cab & ' l -o -r -d "' & $file & '"', $filedir, @SW_HIDE), @CRLF, 1)
					For $i = 1 To $line[0]
						_arrayadd($isfiles, StringTrimLeft($line[$i], 49))
					Next
					If $isfiles[1] <> "" Then
						SplashOff()
						iscabextract($is6cab, $isfiles, $arcdisp)
					EndIf
					If $isfiles[1] == "" OR DirGetSize($outdir) <= $initdirsize Then
						$line = StringSplit(fetchstdout($cmd & $is5cab & ' l -o -r -d "' & $file & '"', $filedir, @SW_HIDE), @CRLF, 1)
						For $i = 1 To $line[0]
							_arrayadd($isfiles, StringTrimLeft($line[$i], 49))
						Next
						If $isfiles[1] <> "" Then
							SplashOff()
							iscabextract($is5cab, $isfiles, $arcdisp)
						EndIf
					EndIf
				EndIf
			EndIf
		Case "isexe"
			exescan($file, "ext", 0)
			If StringInStr($filetype, "3.x", 0) Then
				logrunwait($cmd & $is3exe & " " & FileGetShortName($file) & " " & FileGetShortName($outdir) & $output, $filedir, $consolewin)
			Else
				$choice = methodselect($arctype, $arcdisp)
				Switch $choice
					Case "not InstallShield"
						$isfailed = True
						Return False
					Case "isxunpack"
						addlog(t("EXECUTING") & " " & $cmd & $isexe & ' "' & $outdir & "\" & $filename & "." & $fileext & '"' & $output)
						addlog(t("RUN_OPTION", createarray($outdir, "1")))
						_filemove($file, $outdir)
						Run($cmd & $isexe & ' "' & $outdir & "\" & $filename & "." & $fileext & '"' & $output, $outdir)
						WinWait(@ComSpec)
						WinActivate(@ComSpec)
						Send("{ENTER}")
						ProcessWaitClose($isexe)
						addlogdebugfile()
						_filemove($outdir & "\" & $filename & "." & $fileext, $filedir)
					Case "IShield TC (TotalObserver.wcx)"
						logrunwait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
					Case "InstallScript /s /extract_all:"
						If $warnexecute Then warn_execute($filename & '.exe /s /extract_all:"<outdir>"')
						logrunwait($file & ' /s /extract_all:"' & $outdir & '"' & $output, $filedir, $consolewin)
					Case 'MSI /a /s /v"/qn TARGETDIR=.."'
						If $warnexecute Then warn_execute($filename & '.exe /a /s /v"/qn TARGETDIR=\"<outdir>\""')
						logrunwait($file & ' /a /s /v"/qn TARGETDIR=\"' & $outdir & '\""' & $output, $filedir, $consolewin)
					Case "InstallShield /b"
						If $warnexecute Then warn_execute($filename & '.exe /b"<outdir>" /v"/l "<debugfile>""')
						addlog(t("EXECUTING") & " " & $cmd & $isexe & ' "' & $outdir & "\" & $filename & "." & $fileext & '"' & $output)
						addlog(t("RUN_OPTION", createarray($outdir, "1")))
						SplashTextOn($title, t("INIT_WAIT"), 330, 70, -1, $height, 16)
						Run('"' & $file & '" /b"' & $tempoutdir & '" /v"/l "' & $debugfile & '""', $filedir)
						Opt("WinTitleMatchMode", 4)
						Local $success
						For $i = 1 To 40
							If NOT WinExists("classname=MsiDialogCloseClass") Then
								Sleep(500)
							Else
								$msihandle = FileFindFirstFile($tempoutdir & "\*.msi")
								If NOT @error Then
									While 1
										$msiname = FileFindNextFile($msihandle)
										If @error Then ExitLoop
										$tsearch = filesearch(EnvGet("temp") & "\" & $msiname)
										If NOT @error Then
											$isdir = StringLeft($tsearch[1], StringInStr($tsearch[1], "\", 0, -1) - 1)
											$ishandle = FileFindFirstFile($isdir & "\*")
											$fname = FileFindNextFile($ishandle)
											Do
												If $fname <> $msiname Then
													_filecopy($isdir & "\" & $fname, $tempoutdir)
												EndIf
												$fname = FileFindNextFile($ishandle)
											Until @error
											FileClose($ishandle)
										EndIf
									WEnd
									FileClose($msihandle)
								EndIf
								SplashOff()
								MsgBox(32, $title, t("INIT_COMPLETE", createarray(t("TERM_SUCCEEDED"))))
								addlog(t("INIT_COMPLETE", createarray(t("TERM_SUCCEEDED"))))
								movefiles($tempoutdir, $outdir)
								_dirremove($tempoutdir, 1)
								$success = True
								ExitLoop
							EndIf
						Next
						addlogdebugfile()
						If NOT $success Then
							SplashOff()
							MsgBox(48, $title, t("INIT_COMPLETE", createarray(t("TERM_FAILED"))))
							addlog(t("INIT_COMPLETE", createarray(t("TERM_FAILED"))))
						EndIf
				EndSwitch
			EndIf
		Case "iso"
			_dircreate($tempoutdir)
			logrunwait($cmd & $iso & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $tempoutdir, $consolewin)
			movefiles($tempoutdir, $outdir)
			_dirremove($tempoutdir)
		Case "kgb"
			logrunwait($cmd & $kgb & ' "' & $file & '"' & $output, $outdir, $consolewin)
		Case "lit"
			logrunwait($cmd & $lit & ' "' & $file & '" "' & $outdir & '"' & $output, $outdir, $consolewin)
		Case "lzo"
			logrunwait($cmd & $lzo & ' -d -p"' & $outdir & '" "' & $file & '"' & $output, $filedir, $consolewin)
		Case "lzx"
			logrunwait($cmd & $lzx & ' -x "' & $file & '"' & $output, $outdir, $consolewin)
		Case "mht"
			$choice = methodselect($arctype, $arcdisp)
			Switch $choice
				Case "ExtractMHT"
					logrunwait($mht & ' "' & $file & '" "' & $outdir & '"' & $output, $outdir, $consolewin)
				Case "MHT TC 1 (MHTUnp.wcx)"
					_dircreate($tempoutdir)
					logrunwait($cmd & $mht_ct & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $tempoutdir, $consolewin)
					movefiles($tempoutdir, $outdir)
					_dirremove($tempoutdir)
				Case "MHT TC 2 (TotalObserver.wcx)"
					logrunwait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			EndSwitch
		Case "msi"
			$choice = methodselect($arctype, $arcdisp)
			Switch $choice
				Case "MSI"
					logrunwait('msiexec.exe /a "' & $file & '" /qb /l ' & $debugfile & ' TARGETDIR="' & $outdir & '"', $filedir, $consolewin)
					addlogdebugfile()
				Case "MsiX"
					Local $appendargs = $appendext ? "/ext" : ""
					logrunwait($cmd & $msi_msix & ' "' & $file & '" /out "' & $outdir & '" ' & $appendargs & $output, $filedir, $consolewin)
				Case "JSWare Unpacker"
					logrunwait($msi_jsmsix & ' "' & $file & '"|"' & $outdir & '"', $filedir, $consolewin, $outdir & "\MSI Unpack.log")
				Case "Less MSIerables (lessmsi)"
					If NOT RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Client", "Install") = 1 Then
						SplashOff()
						MsgBox(64, $title, t("DOTNET_FAILED", createarray("Less MSIerables (lessmsi)", "4.0")))
						addlog(t("DOTNET_FAILED", createarray("Less MSIerables (lessmsi)", "4.0")))
						_dirremove($tempoutdir, 1)
						If $createdir Then _dirremove($outdir, 0)
						terminate("failed", $file, $arcdisp)
					EndIf
					logrunwait($msi_lessmsi & ' x "' & $file & '" "' & $outdir & '\ "' & $output, $filedir, $consolewin)
				Case "MSI TC 1 (msi.wcx)"
					_dircreate($tempoutdir)
					logrunwait($cmd & $msi_ct & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $filedir, $consolewin)
					$cabfiles = filesearch($tempoutdir)
					For $i = 1 To $cabfiles[0]
						filescan($cabfiles[$i], 0)
						If StringInStr($filetype, "Microsoft Cabinet Archive", 0) Then
							logrunwait($cmd & $7z & ' x "' & $cabfiles[$i] & '"', $outdir & $output, $consolewin)
							_filedelete($cabfiles[$i])
						EndIf
					Next
					If $appendext Then
						appendextensions($tempoutdir)
					EndIf
					movefiles($tempoutdir, $outdir)
					_dirremove($tempoutdir)
				Case "MSI TC 2 (InstExpl.wcx)"
					logrunwait($cmd & $ie & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
				Case "MSI TC 3 (TotalObserver.wcx)"
					logrunwait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			EndSwitch
		Case "msm"
			Local $appendargs = $appendext ? "/ext" : ""
			logrunwait($cmd & $msi_msix & ' "' & $file & '" /out "' & $outdir & '" ' & $appendargs & $output, $filedir, $consolewin)
		Case "msp"
			$choice = methodselect($arctype, $arcdisp)
			_dircreate($tempoutdir)
			Switch $choice
				Case "MSI TC Packer"
					logrunwait($cmd & $msi_ct & ' x "' & $file & '" "' & $tempoutdir & '\"' & $output, $filedir, $consolewin)
				Case "MsiX"
					logrunwait($cmd & $msi_msix & ' "' & $file & '" /out "' & $tempoutdir & '"' & $output, $filedir, $consolewin)
				Case "7-Zip"
					logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			EndSwitch
			$cabfiles = filesearch($tempoutdir)
			For $i = 1 To $cabfiles[0]
				filescan($cabfiles[$i], 0)
				If StringInStr($filetype, "Microsoft Cabinet Archive", 0) Then
					logrunwait($cmd & $7z & ' x "' & $cabfiles[$i] & '"' & $output, $outdir, $consolewin)
					_filedelete($cabfiles[$i])
				EndIf
			Next
			If $appendext Then
				appendextensions($tempoutdir)
			EndIf
			movefiles($tempoutdir, $outdir)
			_dirremove($tempoutdir)
		Case "msu"
			_dircreate($tempoutdir)
			logrunwait($cmd & $7z & ' x -aos "' & $file & '"' & $output, $tempoutdir, $consolewin)
			$cabfiles = filesearch($tempoutdir)
			For $i = 1 To $cabfiles[0]
				filescan($cabfiles[$i], 0)
				If StringInStr($filetype, "Microsoft Cabinet Archive", 0) Then
					logrunwait($cmd & $expand & ' -f:* "' & $cabfiles[$i] & '" "."' & $output, $outdir, $consolewin)
					$infile = FileOpen($debugfile, 0)
					$line = FileReadLine($infile)
					Do
						If StringInStr($line, "Error Code") OR StringInStr($line, "Код ошибки") Then terminate("failed", $file, $arcdisp)
						$line = FileReadLine($infile)
					Until @error
					FileClose($infile)
					_filedelete($cabfiles[$i])
				EndIf
			Next
			If $appendext Then
				appendextensions($tempoutdir)
			EndIf
			movefiles($tempoutdir, $outdir)
			_dirremove($tempoutdir)
		Case "ms_vcr"
			If NOT RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727", "Install") = 1 Then
				SplashOff()
				MsgBox(64, $title, t("DOTNET_FAILED", createarray("WixTools", "2.0")))
				addlog(t("DOTNET_FAILED", createarray("WixTools", "2.0")))
				_dirremove($tempoutdir, 1)
				If $createdir Then _dirremove($outdir, 0)
				terminate("failed", $file, $arcdisp)
			EndIf
			logrunwait($cmd & $ms_vcr & ' -x "' & $outdir & '" "' & $file & '"' & $output, $filedir, $consolewin)
		Case "nbh"
			logrunwait($cmd & $nbh & ' "' & $file & '"' & $output, $outdir, $consolewin)
		Case "pea"
			Local $pid, $windows, $title, $status, $peatitle
			addlog(t("EXECUTING") & " " & $pea & ' UNPEA "' & $file & '" "' & $tempoutdir & '" RESETDATE SETATTR EXTRACT2DIR INTERACTIVE')
			addlog(t("RUN_OPTION", createarray($filedir, $consolewin)))
			$pid = Run($pea & ' UNPEA "' & $file & '" "' & $tempoutdir & '" RESETDATE SETATTR EXTRACT2DIR INTERACTIVE', $filedir, $consolewin)
			WinWait("PEA", "", 20)
			$windows = WinList("PEA")
			For $i = 0 To $windows[0][0]
				If WinGetProcess($windows[$i][0]) == $pid Then
					$peatitle = $windows[$i][0]
				EndIf
			Next
			While ProcessExists($pid)
				$status = ControlGetText($peatitle, "", "Button1")
				If StringLeft($status, 4) = "Done" Then ProcessClose($pid)
				Sleep(10)
			WEnd
			movefiles($tempoutdir, $outdir)
			_dirremove($tempoutdir)
			addlog(t("CANNOT_LOG", createarray($arcdisp)))
		Case "pdf"
			Local $spassword = password($cmd & $pdfdetach & ' -list "' & $file & '"', $cmd & $pdfdetach & ' -list -opw "%PASSWORD%" -upw "%PASSWORD%" "' & $file & '"', "Incorrect password", 0, "embedded files")
			If StringLeft(fetchstdout($cmd & $pdfdetach & " -list " & ($spassword == "" ? '"' : '-opw "' & $spassword & '" -upw "' & $spassword & '" "') & $file & '"', $outdir, @SW_HIDE), 1) > 0 Then
				_dircreate($outdir & "\embedded")
				logrunwait($cmd & $pdfdetach & ' -saveall -o "' & $outdir & ($spassword == "" ? '\embedded" "' : '\embedded" -opw "' & $spassword & '" -upw "' & $spassword & '" "') & $file & '"' & $output, $outdir, $consolewin)
			EndIf
			_dircreate($outdir & "\images")
			logrunwait($cmd & $pdfimages & " -j " & ($spassword == "" ? '"' : ' -opw "' & $spassword & '" -upw "' & $spassword & '" "') & $file & '" "' & $outdir & '\images\img"' & $output, $outdir, $consolewin)
			logrunwait($cmd & $pdftotext & " -layout" & ($spassword == "" ? ' "' : ' -opw "' & $spassword & '" -upw "' & $spassword & '" "') & $file & '" "' & $outdir & "\" & $filename & '.txt"' & $output, $outdir, $consolewin)
		Case "rar"
			Local $spassword = password($cmd & $7z & ' t -p "' & $file & '"', $cmd & $7z & ' t -p"%PASSWORD%" "' & $file & '"', "Encrypted = +", "Wrong password?", "Everything is Ok")
			logrunwait($cmd & $7z & " x " & ($spassword == "" ? '"' : '-p"' & $spassword & '" "') & $file & '"' & $output, $outdir, $consolewin)
		Case "robo"
			If $warnexecute Then warn_execute($filename & '.exe /unpack="<outdir>"')
			logrunwait($file & ' /unpack="' & $outdir & '"', $filedir & $output, $consolewin)
		Case "sf"
			$choice = methodselect($arctype, $arcdisp)
			If $choice == "SF TC 1 (InstExpl.wcx)" Then
				logrunwait($cmd & $ie & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			ElseIf $choice == "SF TC 2 (TotalObserver.wcx)" Then
				logrunwait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
			EndIf
		Case "sim"
			logrunwait($cmd & $sim & ' "' & $file & '" "' & $outdir & '"' & $output, $outdir, $consolewin)
			$ret = $outdir & "\data.cab"
			logrunwait($cmd & $7z & ' x "' & $ret & '"' & $output, $outdir, $consolewin)
			_filedelete($ret)
			$handle = FileOpen($outdir & "\installer.config", 16)
			$ret = FileRead($handle)
			FileClose($handle)
			If @error Then
				terminate("failed", $file, $arcdisp)
			Else
				Local $j = 0, $areturn = StringSplit($ret, "00402426253034", 1)
				For $i = 1 To $areturn[0]
					If StringLeft($areturn[$i], 2) <> "5C" Then ContinueLoop
					$ret = StringRight($areturn[$i], 4)
					$bnext = $ret = "0031" OR $ret = "0032"
					If NOT $bnext AND $i <> $areturn[0] Then ContinueLoop
					$ret = StringReplace(StringSplit($areturn[$i], "0031", 1)[1], "0032", "")
					$ret = $outdir & BinaryToString("0x" & $ret)
					$return = $outdir & "\" & $j
					If FileExists($return) Then
						_filemove($return, $ret, 9)
					Else
						_dircreate($ret)
					EndIf
					If $bnext Then $j += 1
				Next
			EndIf
			_filedelete($outdir & "\runtime.cab")
			_filedelete($outdir & "\installer.config")
		Case "sis"
			logrunwait($cmd & $sis & ' x "' & $file & '" "' & $outdir & '\"' & $output, $filedir, $consolewin)
		Case "sit"
			_dircreate($tempoutdir)
			_filemove($file, $tempoutdir)
			logrunwait($sit & ' "' & $tempoutdir & "\" & $filename & "." & $fileext & '"' & $output, $tempoutdir, $consolewin)
			_filemove($tempoutdir & "\" & $filename & "." & $fileext, $file)
			movefiles($tempoutdir & "\" & $filename, $outdir)
			_dirremove($tempoutdir, 1)
		Case "sqx"
			logrunwait($cmd & $sqx & ' x "' & $file & '" "' & $outdir & '\"' & $output, $filedir, $consolewin)
		Case "superdat"
			If $warnexecute Then warn_execute($filename & '.exe /e "<outdir>"')
			logrunwait($file & ' /e "' & $outdir & '"', $outdir & $output, $consolewin)
			_filemove($filedir & "\SuperDAT.log", $debugfile, 1)
		Case "swf"
			Local $return = StringSplit(fetchstdout($cmd & $swf & ' "' & $file & '"', $filedir, @SW_HIDE), @CRLF)
			For $i = 2 To $return[0]
				$line = $return[$i]
				If StringInStr($line, "MP3 Soundstream") Then
					logrunwait($cmd & $swf & ' -m "' & $file & '"' & $output, $outdir, $consolewin)
					If FileExists($outdir & "\output.mp3") Then _filemove($outdir & "\output.mp3", $outdir & "\MP3 Soundstream\soundstream.mp3", 8 + 1)
				ElseIf $line <> "" Then
					$swf_arr = StringSplit(StringRegExpReplace(StringStripWS($line, 8), "(?i)\[(-\w)\]\d+(.+):(.*?)\)", "$1,$2,"), ",")
					$j = 3
					Do
						$swf_obj = StringInStr($swf_arr[$j], "-")
						If $swf_obj Then
							For $k = StringMid($swf_arr[$j], 1, $swf_obj - 1) To StringMid($swf_arr[$j], $swf_obj + 1)
								_arrayadd($swf_arr, $k)
							Next
							$swf_arr[0] = UBound($swf_arr) - 1
						Else
							$swf_arr[$j] = StringStripWS($swf_arr[$j], 1)
							$fname = $swf_arr[$j]
							If $swf_arr[2] = "Sound" OR $swf_arr[2] = "Embedded MP3s" Then
								$fname &= ".mp3"
							ElseIf $swf_arr[2] = "PNGs" Then
								$fname &= ".png"
							ElseIf $swf_arr[2] = "JPEGs" Then
								$fname &= ".jpg"
							Else
								$fname &= ".swf"
							EndIf
							logrunwait($cmd & $swf & " " & $swf_arr[1] & " " & $swf_arr[$j] & " -o " & $fname & ' "' & $file & '"', $outdir, $consolewin)
							_filemove($outdir & "\" & $fname, $outdir & "\" & $swf_arr[2] & "\", 8 + 1)
						EndIf
						$j += 1
					Until $j = $swf_arr[0] + 1
				EndIf
			Next
		Case "tar"
			If $fileext = "tar" Then
				logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			Else
				logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
				logrunwait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '.tar"' & $output, $outdir, $consolewin)
				_filedelete($outdir & "\" & $filename & ".tar")
			EndIf
		Case "thinstall"
			If $warnexecute Then warn_execute($file)
			addlog(t("EXECUTING") & " " & $file)
			addlog(t("RUN_OPTION", createarray($filedir, "1")))
			$pid = Run($file, $filedir)
			Do
				Sleep(100)
			Until ProcessExists($pid)
			Sleep(1000)
			$aprocesslist = ProcessList($filename & ".exe")
			$pid = $aprocesslist[1][1]
			addlog(t("EXECUTING") & " " & $thinstall)
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
			addlog(t("CANNOT_LOG", createarray($arcdisp)))
		Case "to"
			logrunwait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
		Case "uha"
			logrunwait($cmd & $uharc & ' x -t"' & $outdir & '" "' & $file & '"' & $output, $outdir, $consolewin)
			If DirGetSize($outdir) <= $initdirsize Then
				$error = FileReadLine($debugfile, 6)
				If StringInStr($error, "use UHARC version", 0) Then
					$version = StringTrimLeft($error, StringInStr($error, " ", 0, -1))
					If $version == "0.4" Then
						logrunwait($cmd & $uharc04 & ' x -t"' & $outdir & '" "' & $file & '"' & $output, $outdir, $consolewin)
					ElseIf $version == "0.2" Then
						If FileExists(@ScriptDir & "\bin\" & $uharc02) Then logrunwait($cmd & $uharc02 & " x -t" & FileGetShortName($outdir) & " " & FileGetShortName($file) & $output, $outdir, $consolewin)
					EndIf
				EndIf
			EndIf
		Case "uif"
			SplashOff()
			$convert = MsgBox(65, $title, t("CONVERT_CDROM", createarray("CDI")))
			If $convert <> 1 Then
				If $createdir Then _dirremove($outdir, 0)
				terminate("silent")
			EndIf
			SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
			_dircreate($tempoutdir)
			ControlSetText($title, "", "Static1", t("EXTRACTING") & @CRLF & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 1)")
			addlog(t("EXTRACTING") & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 1)")
			$isofile = $tempoutdir & "\" & $filename & ".iso"
			logrunwait($cmd & $uif & ' "' & $file & '" "' & $isofile & '"' & $output, $tempoutdir, $consolewin)
		Case "uu"
			logrunwait($cmd & $uu & ' -p "' & $outdir & '" -i "' & $file & '"' & $output, $filedir, $consolewin)
		Case "vssfx"
			If $warnexecute Then warn_execute($filename & ".exe /extract")
			_filemove($file, $outdir)
			logrunwait($outdir & "\" & $filename & "." & $fileext & " /extract", $outdir, $consolewin)
			_filemove($outdir & "\" & $filename & "." & $fileext, $filedir)
		Case "vssfxpath"
			If $warnexecute Then warn_execute($filename & '.exe /extract:"<outdir>" /quiet')
			logrunwait($file & ' /extract:"' & $outdir & '" /quiet', $outdir, $consolewin)
		Case "wise"
			$choice = methodselect($arctype, $arcdisp)
			Switch $choice
				Case "E_Wise"
					logrunwait($cmd & $wise_ewise & ' "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
					If DirGetSize($outdir) > $initdirsize Then
						logrunwait($cmd & "00000000.BAT" & $output, $outdir, $consolewin)
						_filedelete($outdir & "\00000000.BAT")
					EndIf
				Case "WUN"
					logrunwait($cmd & $wise_wun & ' "' & $filename & '" "' & $tempoutdir & '"', $filedir, $consolewin)
					If $removetemp Then
						_filedelete($tempoutdir & "\INST0*")
						_filedelete($tempoutdir & "\WISE0*")
					Else
						_filemove($tempoutdir & "\INST0*", $outdir)
						_filemove($tempoutdir & "\WISE0*", $outdir)
					EndIf
					movefiles($tempoutdir, $outdir)
					_dirremove($tempoutdir)
				Case "Wise TC (TotalObserver.wcx)"
					logrunwait($cmd & $to & ' x "' & $file & '" "' & $outdir & '"' & $output, $filedir, $consolewin)
				Case "Wise Installer /x"
					If $warnexecute Then warn_execute($filename & ".exe /x <outdir>")
					logrunwait($file & " /x " & $outdir, $filedir, $consolewin)
				Case "Wise MSI"
					SplashOff()
					$continue = MsgBox(65, $title, t("WISE_MSI_PROMPT", createarray($name)))
					If $continue <> 1 Then
						If $createdir Then _dirremove($outdir, 0)
						terminate("silent")
					EndIf
					If $warnexecute Then warn_execute($filename & ".exe /?")
					SplashTextOn($title, t("EXTRACTING") & @CRLF & $arcdisp, 330, 70, -1, $height, 16)
					$oldfiles = returnfiles(@CommonFilesDir & "\Wise Installation Wizard")
					Opt("WinTitleMatchMode", 3)
					addlog(t("EXECUTING") & " " & $file & " /?")
					addlog(t("RUN_OPTION", createarray($filedir, "1")))
					$pid = Run($file & " /?", $filedir)
					While 1
						Sleep(10)
						If WinExists("Windows Installer") Then
							WinSetState("Windows Installer", "", @SW_HIDE)
							ExitLoop
						Else
							If NOT ProcessExists($pid) Then ExitLoop
						EndIf
					WEnd
					movefiles(@CommonFilesDir & "\Wise Installation Wizard", $outdir, 0, $oldfiles)
					_dirremove(@CommonFilesDir & "\Wise Installation Wizard", 0)
					WinClose("Windows Installer")
					addlog(t("CANNOT_LOG", createarray($arcdisp)))
				Case "Unzip"
					$return = logrunwait($cmd & $zip & ' -x "' & $file & '"' & $output, $outdir, $consolewin)
					If $return <> 0 Then
						logrunwait($cmd & $7z & ' x "' & $file & '"', $outdir & $output, $consolewin)
					EndIf
			EndSwitch
			If $appendext Then
				appendextensions($outdir)
			EndIf
		Case "xz"
			logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			If FileExists($outdir & "\" & $filename) AND StringTrimLeft($filename, StringInStr($filename, ".", 0, -1)) = "tar" Then
				logrunwait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '"' & $output, $outdir, $consolewin)
				_filedelete($outdir & "\" & $filename)
			EndIf
		Case "Z"
			logrunwait($cmd & $7z & ' x "' & $file & '"' & $output, $outdir, $consolewin)
			If FileExists($outdir & "\" & $filename) AND StringTrimLeft($filename, StringInStr($filename, ".", 0, -1)) = "tar" Then
				logrunwait($cmd & $7z & ' x "' & $outdir & "\" & $filename & '"' & $output, $outdir, $consolewin)
				_filedelete($outdir & "\" & $filename)
			EndIf
		Case "zip"
			Local $spassword = password($cmd & $zip & ' -t -P "" "' & $file & '"', $cmd & $zip & ' -t -P "%PASSWORD%" "' & $file & '"', "because of incorrect password", 0, "No errors")
			$return = logrunwait($cmd & $zip & " -x " & ($spassword == "" ? '"' : '-P "' & $spassword & '" "') & $file & '"' & $output, $outdir, $consolewin)
			If $return > 1 Then
				logrunwait($cmd & $7z & " x " & ($spassword == "" ? '"' : '-p"' & $spassword & '" "') & $file & '"' & $output, $outdir, $consolewin)
			EndIf
		Case "zoo"
			_dircreate($tempoutdir)
			_filemove($file, $tempoutdir)
			logrunwait($cmd & $zoo & " -x -o " & FileGetShortName($filename & "." & $fileext) & $output, $tempoutdir, $consolewin)
			_filemove($tempoutdir & "\" & $filename & "." & $fileext, $file)
			movefiles($tempoutdir, $outdir)
			_dirremove($tempoutdir)
		Case "zpaq"
			Local $spassword = password($cmd & $zpaq & ' l "' & $file & '"', $cmd & $zpaq & ' l "' & $file & '" -key "%PASSWORD%"', "password incorrect", 0, "all OK")
			logrunwait($cmd & $zpaq & ' x "' & $file & '" -to "' & $outdir & ($spassword == "" ? '"' : '" -key "' & $spassword & '"') & $output, $outdir, $consolewin)
	EndSwitch
	If $isofile AND NOT FileExists($isofile) Then
		SplashOff()
		MsgBox(64, $title, t("CONVERT_CDROM_STAGE1_FAILED"))
		addlog(t("CONVERT_CDROM_STAGE1_FAILED"))
		_dirremove($tempoutdir, 1)
		If $createdir Then _dirremove($outdir, 0)
		terminate("failed", $file, $arcdisp)
	ElseIf FileExists($isofile) Then
		ControlSetText($title, "", "Static1", t("EXTRACTING") & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 2)")
		addlog(t("EXTRACTING") & @CRLF & "CDI CD-ROM " & t("TERM_IMAGE") & " (" & t("TERM_STAGE") & " 2)")
		logrunwait($cmd & $7z & ' x "' & $isofile & '"' & $output, $outdir, $consolewin)
		If DirGetSize($outdir) <= $initdirsize Then
			$image = MsgBox(52, $title, t("CONVERT_CDROM_STAGE2_FAILED", createarray("CDI")))
			If $image == 7 Then _dirremove($tempoutdir, 1)
			If $createdir Then _dirremove($outdir, 0)
			terminate("silent")
		Else
			_dirremove($tempoutdir, 1)
			If $createdir Then _dirremove($outdir, 0)
		EndIf
	EndIf
	addlog(t("EXTRACTING_7ZIP"))
	addlog(t("EXECUTING") & " " & $cmd & $sfxsplit & ' "' & $file & '" -b -c "' & $outdir & "\!!!_" & $filename & '_config.txt"' & ' -m "' & $outdir & "\!!!_" & $filename & '.sfx"')
	addlog(t("RUN_OPTION", createarray($filedir, "0")))
	RunWait($cmd & $sfxsplit & ' "' & $file & '" -b -c "' & $outdir & "\!!!_" & $filename & '_config.txt"' & ' -m "' & $outdir & "\!!!_" & $filename & '.sfx"', "", @SW_HIDE)
	SplashOff()
	If $createdir Then
		If DirGetSize($outdir) <= $initdirsize Then
			If $createdir Then _dirremove($outdir, 0)
			If $arctype == "ace" AND $fileext = "exe" Then Return False
			terminate("failed", $file, $arcdisp)
		EndIf
	Else
		If FileGetTime($outdir, 0, 1) == $dirmtime Then
			terminate("failed", $file, $arcdisp)
		EndIf
	EndIf
	terminate("success", "", $arctype)
EndFunc

Func unpack()
	$packed = 0
	Local $packer
	If StringInStr($filetype, "UPX", 0) OR $fileext = "dll" Then
		$packer = "UPX"
	ElseIf StringInStr($filetype, "ASPack", 0) Then
		$packer = "ASPack"
	EndIf
	addlog(t("UNPACK", createarray($packer)))
	If $packer == "UPX" Then
		logrunwait($cmd & $upx & ' -d -k "' & $file & '"' & $output, $filedir, $consolewin)
		$tempext = StringTrimRight($fileext, 1) & "~"
		If FileExists($filedir & "\" & $filename & "." & $tempext) Then
			_filemove($filedir & "\" & $filename & "." & $tempext, $filedir & "\" & $filename & "_orig" & "." & $fileext)
			Return 1
		Else
			If StringInStr(FileReadLine($debugfile, 7), "CantUnpackException", 0) Then
				$packfailed = True
				Return 1
			EndIf
			terminate("unpackfailed")
		EndIf
	ElseIf $packer == "ASPack" Then
		$choice = methodselect("ASPack", "ASPack " & t("TERM_PackAGE"))
		If $choice == "AspackDie 2.2" Then $aspack = $aspack22
		_filemove($file, $filedir & "\" & $filename & "_orig" & "." & $fileext)
		logrunwait($cmd & $aspack & ' "' & $filedir & "\" & $filename & "_orig" & "." & $fileext & '" "' & $file & '" /NO_PROMPT' & $output, $filedir, $consolewin)
		If FileExists($file) Then
			Return 1
		Else
			_filemove($filedir & "\" & $filename & "_orig" & "." & $fileext, $file)
			terminate("unpackfailed")
		EndIf
	EndIf
	Return 
EndFunc

Func returnfiles($dir)
	Local $handle, $files, $fname
	$handle = FileFindFirstFile($dir & "\*")
	If NOT @error Then
		While 1
			$fname = FileFindNextFile($handle)
			If @error Then ExitLoop
			$files &= $fname & "|"
		WEnd
		StringTrimRight($files, 1)
		FileClose($handle)
	Else
		SetError(1)
		Return 
	EndIf
	Return $files
EndFunc

Func _filecopy($source, $dest, $flag = 0)
	If FileCopy($source, $dest, $flag) Then
		addlog(t("COPY_FILES", createarray($source, $dest)))
		Return 1
	Else
		addlog(t("FAILED_COPY", createarray($source, $dest)))
		Return 0
	EndIf
EndFunc

Func _filemove($source, $dest, $flag = 0)
	If FileMove($source, $dest, $flag) Then
		addlog(t("MOVE_FILES", createarray($source, $dest)))
		Return 1
	Else
		addlog(t("FAILED_MOVE", createarray($source, $dest)))
		Return 0
	EndIf
EndFunc

Func _dirmove($source, $dest, $flag = 0)
	If DirMove($source, $dest, $flag) Then
		addlog(t("MOVE_FILES", createarray($source, $dest)))
		Return 1
	Else
		addlog(t("FAILED_MOVE", createarray($source, $dest)))
		Return 0
	EndIf
EndFunc

Func _dirremove($source, $flag = 0)
	If FileExists($source) Then
		If DirRemove($source, $flag) Then
			addlog(t("DEL_FILES", createarray($source)))
			Return 1
		Else
			addlog(t("FAILED_DEL", createarray($source)))
			Return 0
		EndIf
	EndIf
EndFunc

Func _dircreate($source)
	If DirCreate($source) Then
		addlog(t("DIR_CREATE", createarray($source)))
		Return 1
	Else
		addlog(t("FAILED_CREATE", createarray($source)))
		Return 0
	EndIf
EndFunc

Func _filedelete($source)
	If FileExists($source) Then
		If FileDelete($source) Then
			addlog(t("DEL_FILES", createarray($source)))
			Return 1
		Else
			addlog(t("FAILED_DEL", createarray($source)))
			Return 0
		EndIf
	EndIf
EndFunc

Func movefiles($source, $dest, $force = 0, $omit = "")
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
				If StringInStr(FileGetAttrib($source & "\" & $fname), "D") Then
					If NOT _dirmove($source & "\" & $fname, $dest, 1) Then addlog(t("FAILED_MOVE", createarray($source & "\" & $fname, $dest))
				Else
					If NOT _filemove($source & "\" & $fname, $dest, $force) Then addlog(t("FAILED_MOVE", createarray($source & "\" & $fname, $dest))
				EndIf
			EndIf
		WEnd
		FileClose($handle)
		addlog(t("MOVE_FILES", createarray($source, $dest)))
	Else
		SetError(1)
		Return 
	EndIf
EndFunc

Func iscabextract($iscab, $files, $subtitle)
	ProgressOn($title, $subtitle, "", -1, $height, 16)
	For $i = 1 To UBound($files) - 1
		ProgressSet(Round($i / (UBound($files) - 1), 2) * 100, "Extracting: " & $files[$i])
		logrunwait($cmd & $iscab & ' x -r -d -f "' & $file & '" "' & $files[$i] & '"' & $output, $outdir, $consolewin)
	Next
	ProgressOff()
EndFunc

Func appendextensions($dir)
	addlog(t("APPEND_EXTENSIONS", createarray($dir)))
	Local $files
	$files = filesearch($dir)
	If $files[1] <> "" Then
		For $i = 1 To $files[0]
			If NOT StringInStr(FileGetAttrib($files[$i]), "D") Then
				$filename = StringTrimLeft($files[$i], StringInStr($files[$i], "\", 0, -1))
				If NOT StringInStr($filename, ".") OR StringLeft($filename, 7) = "Binary." OR StringRight($filename, 4) = ".bin" Then
					logrunwait($cmd & $trid & ' "' & $files[$i] & '" -ae' & $output, $dir, $consolewin)
				EndIf
			EndIf
		Next
	EndIf
EndFunc

Func filesearch($s_mask = "", $i_recurse = 1)
	Local $s_buf = ""
	If $i_recurse Then
		Local $s_command = ' /c dir /B /S "'
	Else
		Local $s_command = ' /c dir /B "'
	EndIf
	$i_pid = Run(@ComSpec & $s_command & $s_mask & '"', @WorkingDir, @SW_HIDE, 2 + 4)
	While NOT @error
		$s_buf &= StdoutRead($i_pid)
	WEnd
	$s_buf = StringSplit(StringTrimRight(stringoem2ansi($s_buf), 2), @CRLF, 1)
	ProcessClose($i_pid)
	If UBound($s_buf) = 2 AND $s_buf[1] = "" Then SetError(1)
	Return $s_buf
EndFunc

Func stringoem2ansi($strtext)
	Local $buf = DllStructCreate("char[" & StringLen($strtext) + 1 & "]")
	Local $ret = DllCall("User32.dll", "int", "OemToChar", "str", $strtext, "ptr", DllStructGetPtr($buf))
	If NOT (IsArray($ret)) Then Return SetError(1, 0, "")
	If $ret[0] = 0 Then Return SetError(2, $ret[0], "")
	Return DllStructGetData($buf, 1)
EndFunc

Func pathsearch($file)
	$dir = StringSplit(EnvGet("path"), ";")
	ReDim $dir[$dir[0] + 1]
	$dir[$dir[0]] = @ScriptDir
	For $i = 1 To $dir[0]
		$exefiles = FileFindFirstFile($dir[$i] & "\*.exe")
		If $exefiles == -1 Then ContinueLoop
		$exename = FileFindNextFile($exefiles)
		Do
			If $exename = $file Then
				FileClose($exefiles)
				Return _pathfull($dir[$i] & "\" & $exename)
			EndIf
			$exename = FileFindNextFile($exefiles)
		Until @error
		FileClose($exefiles)
	Next
	Return False
EndFunc

Func terminate($status, $fname = "", $id = "")
	Local $addname = $status
	If FileExists($filedir & "\" & $filename & "_orig" & "." & $fileext) Then
		FileMove($file, $outdir & "\" & $filename & "_" & t("TERM_UNPackED") & "." & $fileext, 8)
		FileMove($filedir & "\" & $filename & "_orig" & "." & $fileext, $file, 1)
	EndIf
	If $unicodemode Then
		addlog(t("UNICODE_BACK"))
		SplashTextOn($title, t("MOVE_COPY_FILES") & @CRLF & t("TO", createarray($file, $oldpath)), (StringLen($file) + StringLen($oldpath) + 4) * 6, 80, -1, $height, 16)
		If $unicodemode = "Move" Then
			_filemove($file, $oldpath, 1)
		Else
			_filedelete($file)
		EndIf
		SplashTextOn($title, t("MOVE_COPY_FILES") & @CRLF & t("TO", createarray($outdir, $oldoutdir)), (StringLen($outdir) + StringLen($oldoutdir) + 4) * 6, 80, -1, $height, 16)
		movefiles($outdir, $oldoutdir)
		If NOT @error Then _dirremove($outdir)
		SplashOff()
		$outdir = $oldoutdir
		$file = $oldpath
		$fileunicode = StringSplit(returnfiles($outdir), "|")
		For $i = 1 To $fileunicode[0]
			If StringInStr($fileunicode[$i], $filename) Then _filemove($outdir & "\" & $fileunicode[$i], StringReplace($outdir & "\" & $fileunicode[$i], $filename, $oldname))
		Next
	EndIf
	If $file Then filenameparse($file)
	Switch $status
		Case "syntax"
			$syntax = t("HELP_SUMMARY")
			$syntax &= t("HELP_SYNTAX", createarray(@ScriptName))
			$syntax &= t("HELP_ARGUMENTS")
			$syntax &= t("HELP_HELP")
			$syntax &= t("HELP_PREFS")
			$syntax &= t("HELP_LANG")
			$syntax &= t("HELP_FILENAME")
			$syntax &= t("HELP_DESTINATION")
			$syntax &= t("HELP_SUB", createarray($name))
			$syntax &= t("HELP_EXAMPLE1")
			$syntax &= t("HELP_EXAMPLE2", createarray(@ScriptName))
			$syntax &= t("HELP_NOARGS", createarray($name))
			MsgBox(48, $title, $syntax)
			If NOT $savelogalways Then $log = ""
			$exitcode = 0
		Case "debug"
			MsgBox(48, $title, t("CANNOT_DEBUG", createarray($fname, $name)))
			addlog(t("CANNOT_DEBUG", createarray($fname, $name)))
			If NOT $savelogalways Then $log = ""
			$exitcode = 2
		Case "unknownexe"
			$prompt = MsgBox(305, $title, t("CANNOT_EXTRACT", createarray($file, $id)))
			addlog(t("CANNOT_EXTRACT", createarray($file, $id)))
			If $prompt == 1 Then
				Run($peid & ' "' & $file & '"', $filedir)
				WinWait($peidtitle)
				WinActivate($peidtitle)
			EndIf
			$exitcode = 3
		Case "unknownext"
			MsgBox(48, $title, t("UNKNOWN_EXT", createarray($file)))
			addlog(t("UNKNOWN_EXT", createarray($file)))
			$exitcode = 4
		Case "invaliddir"
			MsgBox(48, $title, t("INVALID_DIR", createarray($fname)))
			addlog(t("INVALID_DIR", createarray($fname)))
			$exitcode = 5
		Case "invalidpas"
			MsgBox(48, $title, t("INVALID_PASSWORD", createarray($file)))
			addlog(t("INVALID_PASSWORD", createarray($file)))
			$exitcode = 6
		Case "invalidlangfile"
			MsgBox(48, $title, t("INVALID_LANGFILE", createarray($fname)))
			addlog(t("INVALID_LANGFILE", createarray($fname)))
			If NOT $savelogalways Then $log = ""
			$exitcode = 7
		Case "unpackfailed"
			addlog(t("UNPACK_FAILE", createarray($file)))
			$prompt = MsgBox(305, $title, t("UNPACK_FAILED", createarray($file, FileGetLongName($debugfile))))
			If $prompt == 1 Then
				If $savelog Then
					ShellExecute(createlog($status))
				Else
					ShellExecute(createlog("", $debugfile))
				EndIf
				$log = ""
			EndIf
			$exitcode = 1
		Case "failed"
			addlog(t("EXTRACT_FAILE", createarray($file, $id)))
			$prompt = MsgBox(305, $title, t("EXTRACT_FAILED", createarray($file, $id, FileGetLongName($debugfile))))
			If $prompt == 1 Then
				If $savelog Then
					ShellExecute(createlog($status))
				Else
					ShellExecute(createlog("", $debugfile))
				EndIf
				$log = ""
			EndIf
			$exitcode = 1
		Case "success"
			_filedelete($debugfile)
			addlog(t("EXTRACT_SUCCESS"))
			$status = $id
			$exitcode = 0
		Case "silent"
			If NOT $savelogalways Then $log = ""
			$exitcode = 0
	EndSwitch
	If $log AND $savelog Then createlog($status)
	Exit $exitcode
EndFunc

Func methodselect($format, $splashdisp)
	SplashOff()
	$base_height = 130
	$base_radio = 100
	$url = "dummy"
	Switch $format
		Case "wise"
			$select_type = "Wise Installer"
			Dim $method[6][2], $select[6]
			$method[0][0] = "E_Wise"
			$method[0][1] = "METHOD_UNPackER_RADIO"
			$method[1][0] = "WUN"
			$method[1][1] = "METHOD_UNPackER_RADIO"
			$method[2][0] = "Wise TC (TotalObserver.wcx)"
			$method[2][1] = "METHOD_EXTRACTION_RADIO"
			$method[3][0] = "Wise Installer /x"
			$method[3][1] = "METHOD_SWITCH_RADIO"
			$method[4][0] = "Wise MSI"
			$method[4][1] = "METHOD_EXTRACTION_RADIO"
			$method[5][0] = "Unzip"
			$method[5][1] = "METHOD_EXTRACTION_RADIO"
		Case "msi"
			$select_type = "MSI Installer"
			Dim $method[7][2], $select[7]
			$method[0][0] = "MSI"
			$method[0][1] = "METHOD_ADMIN_RADIO"
			$method[1][0] = "MsiX"
			$method[1][1] = "METHOD_EXTRACTION_RADIO"
			$method[2][0] = "MSI TC 1 (msi.wcx)"
			$method[2][1] = "METHOD_EXTRACTION_RADIO"
			$method[3][0] = "MSI TC 2 (InstExpl.wcx)"
			$method[3][1] = "METHOD_EXTRACTION_RADIO"
			$method[4][0] = "MSI TC 3 (TotalObserver.wcx)"
			$method[4][1] = "METHOD_EXTRACTION_RADIO"
			$method[5][0] = "JSWare Unpacker"
			$method[5][1] = "METHOD_EXTRACTION_RADIO"
			$method[6][0] = "Less MSIerables (lessmsi)"
			$method[6][1] = "METHOD_EXTRACTION_RADIO"
		Case "msp"
			$select_type = "MSP Package"
			Dim $method[3][2], $select[3]
			$method[0][0] = "MSI TC Packer"
			$method[0][1] = "METHOD_EXTRACTION_RADIO"
			$method[1][0] = "MsiX"
			$method[1][1] = "METHOD_EXTRACTION_RADIO"
			$method[2][0] = "7-Zip"
			$method[2][1] = "METHOD_EXTRACTION_RADIO"
		Case "mht"
			$select_type = "MHTML Archive"
			Dim $method[3][2], $select[3]
			$method[0][0] = "ExtractMHT"
			$method[0][1] = "METHOD_EXTRACTION_RADIO"
			$method[1][0] = "MHT TC 1 (MHTUnp.wcx)"
			$method[1][1] = "METHOD_EXTRACTION_RADIO"
			$method[2][0] = "MHT TC 2 (TotalObserver.wcx)"
			$method[2][1] = "METHOD_EXTRACTION_RADIO"
		Case "is3arc"
			$select_type = "InstallShield 3.x Archive"
			Dim $method[2][2], $select[2]
			$method[0][0] = "i3comp"
			$method[0][1] = "METHOD_EXTRACTION_RADIO"
			$method[1][0] = "STIX"
			$method[1][1] = "METHOD_EXTRACTION_RADIO"
		Case "isexe"
			$select_type = "InstallShield Installer"
			Dim $method[6][2], $select[6]
			$method[0][0] = "isxunpack"
			$method[0][1] = "METHOD_EXTRACTION_RADIO"
			$method[1][0] = "IShield TC (TotalObserver.wcx)"
			$method[1][1] = "METHOD_EXTRACTION_RADIO"
			$method[2][0] = "InstallShield /b"
			$method[2][1] = "METHOD_SWITCH_RADIO"
			$method[3][0] = "InstallScript /s /extract_all:"
			$method[3][1] = "METHOD_SWITCH_RADIO"
			$method[4][0] = 'MSI /a /s /v"/qn TARGETDIR=.."'
			$method[4][1] = "METHOD_SWITCH_RADIO"
			$method[5][0] = "not InstallShield"
			$method[5][1] = "METHOD_NOTIS_RADIO"
		Case "ASPack"
			$select_type = "ASPack Packer"
			Dim $method[2][2], $select[2]
			$method[0][0] = "AspackDie 2.12"
			$method[0][1] = "METHOD_UNPackER_RADIO"
			$method[1][0] = "AspackDie 2.2"
			$method[1][1] = "METHOD_UNPackER_RADIO"
		Case "gentee"
			$select_type = "Gentee Installer"
			Dim $method[2][2], $select[2]
			$method[0][0] = "Gentee TC 1 (InstExpl.wcx)"
			$method[0][1] = "METHOD_EXTRACTION_RADIO"
			$method[1][0] = "Gentee TC 2 (TotalObserver.wcx)"
			$method[1][1] = "METHOD_EXTRACTION_RADIO"
		Case "sf"
			$select_type = "Setup Factory"
			Dim $method[2][2], $select[2]
			$method[0][0] = "SF TC 1 (InstExpl.wcx)"
			$method[0][1] = "METHOD_EXTRACTION_RADIO"
			$method[1][0] = "SF TC 2 (TotalObserver.wcx)"
			$method[1][1] = "METHOD_EXTRACTION_RADIO"
	EndSwitch
	Opt("GUIOnEventMode", 0)
	Local $guimethod = GUICreate($title, 360, $base_height + (UBound($method) * 20))
	$header = GUICtrlCreateLabel(t("METHOD_HEADER", createarray($select_type)), 5, 5, 350, 20)
	GUICtrlCreateLabel(t("METHOD_TEXT_LABEL", createarray($name, $select_type, $name)), 5, 25, 350, 65, $ss_left)
	GUICtrlCreateGroup(t("METHOD_RADIO_LABEL"), 5, $base_radio, 245, 25 + (UBound($method) * 20))
	For $i = 0 To UBound($method) - 1
		$select[$i] = GUICtrlCreateRadio(t($method[$i][1], createarray($method[$i][0])), 10, $base_radio + 20 + ($i * 20), 235, 20)
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$ok = GUICtrlCreateButton(t("OK_BUT"), 265, $base_radio - 10 + (UBound($method) * 10), 80, 20)
	$cancel = GUICtrlCreateButton(t("CANCEL_BUT"), 265, $base_radio - 10 + (UBound($method) * 10) + 30, 80, 20)
	GUICtrlSetFont($header, -1, 1200)
	GUICtrlSetState($select[0], $gui_checked)
	GUICtrlSetState($ok, $gui_defbutton)
	GUISetState(@SW_SHOW)
	While 1
		$action = GUIGetMsg()
		Select 
			Case $action == $ok
				For $i = 0 To UBound($method) - 1
					If GUICtrlRead($select[$i]) == $gui_checked Then
						GUIDelete($guimethod)
						SplashTextOn($title, t("EXTRACTING") & @CRLF & $splashdisp, 330, 70, -1, $height, 16)
						Return $method[$i][0]
					EndIf
				Next
			Case $action == $gui_event_close OR $action == $cancel
				If $createdir Then _dirremove($outdir, 0)
				terminate("silent")
		EndSelect
	WEnd
EndFunc

Func warn_execute($command)
	$prompt = MsgBox(49 + 4096, $title, t("WARN_EXECUTE", createarray($command)))
	If $prompt <> 1 Then
		If $createdir Then _dirremove($outdir, 0)
		terminate("silent")
	EndIf
	Return True
EndFunc

Func password($sisprotectedcmd, $stestcmd, $sisprotectedtext = "encrypted", $sisprotectedtext2 = 0, $stesttext = "All OK", $ilog = False)
	Local $spassword = ""
	Local $return = fetchstdout($sisprotectedcmd, $outdir, @SW_HIDE)
	If NOT StringInStr($return, $sisprotectedtext) AND ($sisprotectedtext2 == 0 OR NOT StringInStr($return, $sisprotectedtext2)) Then Return $spassword
	addlog(t("PASSWORDS"))
	Local $handle = FileOpen($passwordfile, 1 + 8 + 128)
	$apasswords = FILEREADTOARRAY($passwordfile)
	FileClose($handle)
	Local $size = UBound($apasswords)
	If $size > 0 Then addlog(t("TRYING_PASSWORDS", createarray($size)))
	For $i = 0 To $size - 1
		$istring = fetchstdout(StringReplace($stestcmd, "%PASSWORD%", $apasswords[$i], 1), $outdir, @SW_HIDE, False)
		If StringInStr($istring, $stesttext) Then
			$spassword = $apasswords[$i]
			addlog(t("PASSWORD_FOUND", createarray($spassword)))
			If $ilog Then
				addlog(t("EXECUTING") & " " & StringReplace($stestcmd, "%PASSWORD%", $apasswords[$i], 1))
				addlog(t("RUN_OPTION", createarray($outdir, @SW_HIDE)))
				addlog(t("LOG") & @CRLF & StringStripWS($istring, 3))
			EndIf
			Return $spassword
		EndIf
	Next
	addlog(t("ASKED_PASSWORD"))
	While 1
		If NOT $spassword Then $spassword = InputBox($title, t("ASK_PASSWORD"))
		If @error = 1 Then ExitLoop
		If StringInStr(fetchstdout(StringReplace($stestcmd, "%PASSWORD%", $spassword, 1), $outdir, @SW_HIDE, False), $stesttext) Then
			addlog(t("PASSWORD_FOUND", createarray($spassword)))
			If $savepass Then
				addlog(t("SAVE_PASSWORD"))
				writefile($passwordfile, $spassword, 1 + 8 + 128)
			EndIf
			If $ilog Then
				addlog(t("EXECUTING") & " " & StringReplace($stestcmd, "%PASSWORD%", $apasswords[$i], 1))
				addlog(t("RUN_OPTION", createarray($outdir, @SW_HIDE)))
				addlog(t("LOG") & @CRLF & StringStripWS($istring, 3))
			EndIf
			Return $spassword
		EndIf
		$spassword = ""
		Sleep(20)
	WEnd
	terminate("invalidpas")
EndFunc

Func logrunwait($f, $sworkingdir, $show_flag, $logfile = $debugfile)
	Local $return
	addlog(t("EXECUTING") & " " & $f)
	addlog(t("RUN_OPTION", createarray($sworkingdir, $show_flag)))
	$return = RunWait($f, $sworkingdir, $show_flag)
	addlogdebugfile($logfile)
	Return $return
EndFunc

Func fetchstdout($f, $sworkingdir, $show_flag, $islog = True)
	If $islog Then addlog(t("EXECUTING") & " " & $f)
	Local $run = 0, $return = ""
	$run = Run($f, $sworkingdir, $show_flag, 8)
	Do
		Sleep(1)
		$return &= StdoutRead($run)
	Until @error
	If $islog Then addlog(t("LOG") & @CRLF & StringStripWS($return, 3))
	Return $return
EndFunc

Func writefile($f, $string, $flag = 1 + 8)
	Local $handle = FileOpen($f, $flag)
	FileWrite($handle, $string & @CRLF)
	FileClose($handle)
EndFunc

Func writereg($data)
	For $i = 1 To $data[0][0]
		RegWrite($data[$i][0], $data[$i][1], $data[$i][2], $data[$i][3])
	Next
EndFunc

Func addlog($data = "")
	If NOT $data = "" Then
		Local $output = @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ":" & @MSEC & @TAB & $data & @CRLF
		$log &= $output
	Else
		$log &= @CRLF
	EndIf
EndFunc

Func addlogdebugfile($logfile = $debugfile)
	If FileExists($logfile) Then
		$handle = FileOpen($logfile)
		Local $deb = FileRead($handle)
		If NOT StringIsSpace($deb) Then addlog(t("LOG") & @CRLF & StringStripWS($deb, 3))
		FileClose($handle)
		_filedelete($logfile)
	Else
		addlog(t("CANNOT_LOG", createarray($logarcdisp)))
	EndIf
EndFunc

Func createarray($i0, $i1 = 0, $i2 = 0, $i3 = 0, $i4 = 0, $i5 = 0, $i6 = 0, $i7 = 0, $i8 = 0, $i9 = 0)
	Local $arr[10] = [$i0, $i1, $i2, $i3, $i4, $i5, $i6, $i7, $i8, $i9]
	ReDim $arr[@NumParams]
	Return $arr
EndFunc

Func createlog($status, $name = "")
	If NOT $name Then
		$name = $logdir & "\" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & "_"
		$name &= StringUpper($status)
		If $file <> "" Then $name &= "_" & $filename & "." & $fileext
		$name &= ".log"
	EndIf
	If FileExists($name) Then _filedelite($name)
	$handle = FileOpen($name, 8 + 2)
	FileWrite($handle, $log)
	FileClose($handle)
	Return $name
EndFunc

$sfile = FileRead($filename)

Func creategui()
	Global $guimain = GUICreate($title, -1, 135, -1, -1, $ws_overlappedwindow, $ws_ex_acceptfiles)
	$apos = WinGetPos($title)
	Local $dropzone = GUICtrlCreateLabel("", 0, 0, 300, 135)
	Local $filemenu = GUICtrlCreateMenu(t("MENU_FILE_LABEL"))
	Local $quititem = GUICtrlCreateMenuItem(t("MENU_FILE_QUIT_LABEL"), $filemenu)
	Local $editmenu = GUICtrlCreateMenu(t("MENU_EDIT_LABEL"))
	Local $prefsitem = GUICtrlCreateMenuItem(t("MENU_EDIT_PREFS_LABEL"), $editmenu)
	Local $openpasitem = GUICtrlCreateMenuItem(t("MENU_OPEN_PASSWORDS_LABEL"), $editmenu)
	Local $helpmenu = GUICtrlCreateMenu(t("MENU_HELP_LABEL"))
	Local $webitem = GUICtrlCreateMenuItem(t("MENU_HELP_WEB_LABEL", createarray($name)), $helpmenu)
	GUICtrlCreateMenuItem("", $helpmenu)
	Local $webitem_rb = GUICtrlCreateMenuItem("Ru.Board", $helpmenu)
	Local $webitem_o = GUICtrlCreateMenuItem("OSzone.net", $helpmenu)
	GUICtrlCreateMenuItem("", $helpmenu)
	Local $aboutitem = GUICtrlCreateMenuItem(t("MENU_HELP_ABOUT_LABEL", createarray($name)), $helpmenu)
	GUICtrlCreateLabel(t("MAIN_FILE_LABEL"), 5, 5, -1, 15)
	If $history Then
		Global $filecont = GUICtrlCreateCombo("", 5, 20, $apos[2] - 55, 20)
	Else
		Global $filecont = GUICtrlCreateInput("", 5, 20, $apos[2] - 55, 20)
	EndIf
	Local $filebut = GUICtrlCreateButton("...", $apos[2] - 45, 20, 25, 20)
	GUICtrlCreateLabel(t("MAIN_DEST_DIR_LABEL"), 5, 45, -1, 15)
	If $history Then
		Global $dircont = GUICtrlCreateCombo("", 5, 60, $apos[2] - 55, 20)
	Else
		Global $dircont = GUICtrlCreateInput("", 5, 60, $apos[2] - 55, 20)
	EndIf
	Local $dirbut = GUICtrlCreateButton("...", $apos[2] - 45, 60, 25, 20)
	Global $ok = GUICtrlCreateButton(t("OK_BUT"), 80, 90, 80, 20)
	Local $cancel = GUICtrlCreateButton(t("CANCEL_BUT"), 190, 90, 80, 20)
	GUICtrlSetBkColor($dropzone, $gui_bkcolor_transparent)
	GUICtrlSetState($dropzone, $gui_disable)
	GUICtrlSetState($dropzone, $gui_dropaccepted)
	GUICtrlSetState($filecont, $gui_focus)
	GUICtrlSetState($ok, $gui_defbutton)
	If $file <> "" Then
		filenameparse($file)
		If $history Then
			$filelist = "|" & $file & "|" & readhist("file")
			GUICtrlSetData($filecont, $filelist, $file)
			$dirlist = "|" & $initoutdir & "|" & readhist("directory")
			GUICtrlSetData($dircont, $dirlist, $initoutdir)
		Else
			GUICtrlSetData($filecont, $file)
			GUICtrlSetData($dircont, $initoutdir)
		EndIf
		GUICtrlSetState($dircont, $gui_focus)
	ElseIf $history Then
		GUICtrlSetData($filecont, readhist("file"))
		GUICtrlSetData($dircont, readhist("directory"))
	EndIf
	GUISetOnEvent($gui_event_dropped, "GUI_Drop")
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
	GUISetOnEvent($gui_event_close, "GUI_Exit")
	GUISetState(@SW_SHOW)
EndFunc

Func getpos($gui, $control, $offset = 0)
	$location = ControlGetPos($gui, "", $control)
	If @error Then
		SetError(1, "", 0)
	Else
		Return $location[0] + $location[2] + $offset
	EndIf
EndFunc

Func charcount($string, $char)
	Local $count = StringSplit($string, $char, 1)
	Return $count[0]
EndFunc

Func gui_file()
	$file = FileOpenDialog(t("OPEN_FILE"), "", t("SELECT_FILE") & " (*.*)", 1)
	If NOT @error Then
		If $history Then
			$filelist = "|" & $file & "|" & readhist("file")
			GUICtrlSetData($filecont, $filelist, $file)
		Else
			GUICtrlSetData($filecont, $file)
		EndIf
		If GUICtrlRead($dircont) = "" Then
			filenameparse($file)
			If $history Then
				$dirlist = "|" & $initoutdir & "|" & readhist("directory")
				GUICtrlSetData($dircont, $dirlist, $initoutdir)
			Else
				GUICtrlSetData($dircont, $initoutdir)
			EndIf
		EndIf
		GUICtrlSetState($ok, $gui_focus)
	EndIf
EndFunc

Func gui_directory()
	If FileExists(GUICtrlRead($dircont)) Then
		$defdir = GUICtrlRead($dircont)
	ElseIf FileExists(GUICtrlRead($filecont)) Then
		$defdir = StringLeft(GUICtrlRead($filecont), StringInStr(GUICtrlRead($filecont), "\", 0, -1) - 1)
	Else
		$defdir = ""
	EndIf
	$outdir = FileSelectFolder(t("EXTRACT_TO"), "", 3, $defdir)
	If NOT @error Then
		If $history Then
			$dirlist = "|" & $outdir & "|" & readhist("directory")
			GUICtrlSetData($dircont, $dirlist, $outdir)
		Else
			GUICtrlSetData($dircont, $outdir)
		EndIf
	EndIf
EndFunc

Func gui_prefs_debug()
	If FileExists(envparse(GUICtrlRead(($debugcont)))) Then
		$defdir = envparse(GUICtrlRead($debugcont))
	ElseIf FileExists(envparse($debugdir)) Then
		$defdir = envparse($debugdir)
	Else
		$defdir = @TempDir
	EndIf
	If StringRight($defdir, 1) == ":" Then $defdir &= "\"
	$debugdir = FileSelectFolder(t("WRITE_TO"), "", 3, $defdir)
	If NOT @error Then GUICtrlSetData($debugcont, $debugdir)
EndFunc

Func gui_prefs_log()
	If FileExists(envparse(GUICtrlRead(($logcont)))) Then
		$defdir = envparse(GUICtrlRead($logcont))
	ElseIf FileExists(envparse($logdir)) Then
		$defdir = envparse($logdir)
	Else
		$defdir = @TempDir
	EndIf
	If StringRight($defdir, 1) == ":" Then $defdir &= "\"
	$logdir = FileSelectFolder(t("WRITE_TO"), "", 3, $defdir)
	If NOT @error Then GUICtrlSetData($logcont, $logdir)
EndFunc

Func gui_prefs_exit()
	GUIDelete($guiprefs)
	If $prefsonly Then
		terminate("silent")
	EndIf
EndFunc

Func gui_prefs_ok()
	$redrawgui = False
	If FileExists(envparse(GUICtrlRead($debugcont))) AND StringInStr(FileGetAttrib(envparse(GUICtrlRead($debugcont))), "D") Then
		$debugdir = GUICtrlRead($debugcont)
	Else
		MsgBox(48, $title, t("INVALID_DIR_SELECTED", createarray(GUICtrlRead($debugcont))))
		Return 
	EndIf
	If FileExists(envparse(GUICtrlRead($logcont))) AND StringInStr(FileGetAttrib(envparse(GUICtrlRead($logcont))), "D") Then
		$logdir = GUICtrlRead($logcont)
	Else
		_dircreate($logdir)
		Return 
	EndIf
	If GUICtrlRead($historyopt) == $gui_checked Then
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
				RegDelete($reg & "\File")
				RegDelete($reg & "\Directory")
			EndIf
			$redrawgui = True
		EndIf
	EndIf
	If GUICtrlRead($nodoswinopt) == $gui_checked Then
		$nodoswin = 1
	Else
		$nodoswin = 0
	EndIf
	If GUICtrlRead($mindoswinopt) == $gui_checked Then
		$mindoswin = 1
	Else
		$mindoswin = 0
	EndIf
	If GUICtrlRead($savepassopt) == $gui_checked Then
		$savepass = 1
	Else
		$savepass = 0
	EndIf
	If GUICtrlRead($savelogopt) == $gui_checked Then
		$savelog = 1
	Else
		$savelog = 0
	EndIf
	If GUICtrlRead($savelogalwaysopt) == $gui_checked Then
		$savelogalways = 1
	Else
		$savelogalways = 0
	EndIf
	If $language <> GUICtrlRead($langselect) Then
		$language = GUICtrlRead($langselect)
		$redrawgui = True
	EndIf
	If GUICtrlRead($warnexecuteopt) == $gui_checked Then
		$warnexecute = 1
	Else
		$warnexecute = 0
	EndIf
	If GUICtrlRead($removedupeopt) == $gui_checked Then
		$removedupe = 1
	Else
		$removedupe = 0
	EndIf
	If GUICtrlRead($removetempopt) == $gui_checked Then
		$removetemp = 1
	Else
		$removetemp = 0
	EndIf
	If GUICtrlRead($appendextopt) == $gui_checked Then
		$appendext = 1
	Else
		$appendext = 0
	EndIf
	If GUICtrlRead($useepeopt) == $gui_checked Then
		$useepe = 1
	Else
		$useepe = 0
	EndIf
	If GUICtrlRead($usedieopt) == $gui_checked Then
		$usedie = 1
	Else
		$usedie = 0
	EndIf
	If GUICtrlRead($usepeidopt) == $gui_checked Then
		$usepeid = 1
	Else
		$usepeid = 0
	EndIf
	writeprefs()
	GUIDelete($guiprefs)
	If $prefsonly Then
		$finishprefs = True
	ElseIf $redrawgui Then
		GUIDelete($guimain)
		creategui()
	EndIf
EndFunc

Func gui_ok()
	$file = envparse(GUICtrlRead($filecont))
	If FileExists($file) Then
		If envparse(GUICtrlRead($dircont)) == "" Then
			$outdir = "/sub"
		Else
			$outdir = envparse(GUICtrlRead($dircont))
		EndIf
		GUIDelete($guimain)
		Global $finishgui = True
	Else
		If $file == "" Then
			$file = ""
		Else
			$file &= " " & t("DOES_NOT_EXIST")
		EndIf
		MsgBox(48, $title, t("INVALID_FILE_SELECTED", createarray($file)))
		Return 
	EndIf
EndFunc

Func gui_drop()
	If FileExists(@GUI_DragFile) Then
		$file = @GUI_DragFile
		If $history Then
			$filelist = "|" & $file & "|" & readhist("file")
			GUICtrlSetData($filecont, $filelist, $file)
		Else
			GUICtrlSetData($filecont, $file)
		EndIf
		If GUICtrlRead($dircont) = "" Then
			filenameparse($file)
			If $history Then
				$dirlist = "|" & $initoutdir & "|" & readhist("directory")
				GUICtrlSetData($dircont, $dirlist, $initoutdir)
			Else
				GUICtrlSetData($dircont, $initoutdir)
			EndIf
		EndIf
	EndIf
EndFunc

Func gui_prefs()
	$langlist = ""
	Dim $langarr[1]
	$temp = FileFindFirstFile($langdir & "\*.ini")
	If $temp <> -1 Then
		Local $langarr = _filelisttoarray($langdir, "*.ini", 1)
		FileClose($temp)
	EndIf
	$langarr[0] = "English.ini"
	_arraysort($langarr)
	For $i = 0 To UBound($langarr) - 1
		$langlist &= StringTrimRight($langarr[$i], 4) & "|"
	Next
	$langlist = StringTrimRight($langlist, 1)
	If $prefsonly Then
		Global $guiprefs = GUICreate(t("PREFS_TITLE_LABEL"), 270, 425)
	Else
		Global $guiprefs = GUICreate(t("PREFS_TITLE_LABEL"), 270, 425, -1, -1, -1, -1, $guimain)
	EndIf
	GUICtrlCreateGroup(t("PREFS_UNIEXTRACT_OPTS_LABEL"), 5, 0, 260, 200)
	Global $historyopt = GUICtrlCreateCheckbox(t("PREFS_HISTORY_LABEL"), 10, 15, -1, 20)
	Global $nodoswinopt = GUICtrlCreateCheckbox(t("PREFS_NODOSWIN_LABEL"), 10, 35, -1, 20)
	Global $mindoswinopt = GUICtrlCreateCheckbox(t("PREFS_MINDOSWIN_LABEL"), 10, 55, -1, 20)
	Global $savepassopt = GUICtrlCreateCheckbox(t("PREFS_SAVEPASS_LABEL"), 10, 75, -1, 20)
	GUICtrlCreateUpdown(-1)
	GUICtrlSetLimit(-1, 30, 7)
	Local $langlabel = GUICtrlCreateLabel(t("PREFS_LANG_LABEL"), 10, 98, -1, 15)
	Local $langselectpos = getpos($guiprefs, $langlabel, -8)
	Global $langselect = GUICtrlCreateCombo("", $langselectpos, 95, 265 - $langselectpos - 4, 20 * charcount($langlist, "|"), $cbs_dropdownlist)
	Local $debuglabel = GUICtrlCreateLabel(t("PREFS_DEBUG_LABEL"), 10, 120, -1, 20)
	Global $debugcont = GUICtrlCreateInput($debugdir, 10, 135, 220, 20)
	Local $debugbut = GUICtrlCreateButton("...", 235, 135, 25, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $savelogopt = GUICtrlCreateCheckbox(t("PREFS_LOG_LABEL"), 10, 155, -1, 20)
	GUICtrlSetOnEvent(-1, "GUI_LogLabel")
	Global $savelogalwaysopt = GUICtrlCreateCheckbox(t("PREFS_LOG_LABEL_ALWAYS"), 200, 155, -1, 20)
	Global $logcont = GUICtrlCreateInput($logdir, 10, 175, 220, 20)
	Global $logbut = GUICtrlCreateButton("...", 235, 175, 25, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup(t("PREFS_FORMAT_OPTS_LABEL"), 5, 205, 260, 100)
	Global $warnexecuteopt = GUICtrlCreateCheckbox(t("PREFS_WARN_EXECUTE_LABEL"), 10, 220, -1, 20)
	Global $removedupeopt = GUICtrlCreateCheckbox(t("PREFS_REMOVE_DUPE_LABEL"), 10, 240, -1, 20)
	Global $removetempopt = GUICtrlCreateCheckbox(t("PREFS_REMOVE_TEMP_LABEL"), 10, 260, -1, 20)
	Global $appendextopt = GUICtrlCreateCheckbox(t("PREFS_APPEND_EXT_LABEL"), 10, 280, -1, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup(t("PE_ANALIZATORS"), 5, 310, 260, 80)
	Global $useepeopt = GUICtrlCreateCheckbox("Exeinfo Pe", 10, 325, -1, 20)
	Global $usedieopt = GUICtrlCreateCheckbox("Detect It Easy", 10, 345, -1, 20)
	Global $usepeidopt = GUICtrlCreateCheckbox("PEiD", 10, 365, -1, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Local $prefsok = GUICtrlCreateButton(t("OK_BUT"), 65, 400, 60, 20)
	Local $prefscancel = GUICtrlCreateButton(t("CANCEL_BUT"), 145, 400, 60, 20)
	GUICtrlSetState($prefsok, $gui_defbutton)
	If $history Then GUICtrlSetState($historyopt, $gui_checked)
	If $nodoswin Then GUICtrlSetState($nodoswinopt, $gui_checked)
	If $mindoswin Then GUICtrlSetState($mindoswinopt, $gui_checked)
	If $savepass Then GUICtrlSetState($savepassopt, $gui_checked)
	If $savelog Then GUICtrlSetState($savelogopt, $gui_checked)
	If $savelogalways Then GUICtrlSetState($savelogalwaysopt, $gui_checked)
	If NOT $savelog Then GUICtrlSetState($savelogalwaysopt, $gui_disable)
	If NOT $savelog Then GUICtrlSetState($logcont, $gui_disable)
	If NOT $savelog Then GUICtrlSetState($logbut, $gui_disable)
	If $warnexecute Then GUICtrlSetState($warnexecuteopt, $gui_checked)
	If $removedupe Then GUICtrlSetState($removedupeopt, $gui_checked)
	If $removetemp Then GUICtrlSetState($removetempopt, $gui_checked)
	If $appendext Then GUICtrlSetState($appendextopt, $gui_checked)
	If StringInStr($langlist, $language, 0) Then
		GUICtrlSetData($langselect, $langlist, $language)
	Else
		GUICtrlSetData($langselect, $langlist, "English")
	EndIf
	If $useepe Then GUICtrlSetState($useepeopt, $gui_checked)
	If $usedie Then GUICtrlSetState($usedieopt, $gui_checked)
	If $usepeid Then GUICtrlSetState($usepeidopt, $gui_checked)
	GUICtrlSetOnEvent($debugbut, "GUI_Prefs_Debug")
	GUICtrlSetOnEvent($logbut, "GUI_Prefs_Log")
	GUICtrlSetOnEvent($prefsok, "GUI_Prefs_OK")
	GUICtrlSetOnEvent($prefscancel, "GUI_Prefs_Exit")
	GUISetOnEvent($gui_event_close, "GUI_Prefs_Exit")
	GUISetState(@SW_SHOW)
EndFunc

Func gui_loglabel()
	If $savelogopt = @GUI_CtrlId Then
		If BitAND(GUICtrlRead($savelogopt), $gui_checked) Then
			GUICtrlSetState($savelogalwaysopt, $gui_enable)
			GUICtrlSetState($logcont, $gui_enable)
			GUICtrlSetState($logbut, $gui_enable)
		Else
			GUICtrlSetState($savelogalwaysopt, $gui_disable)
			GUICtrlSetState($logcont, $gui_disable)
			GUICtrlSetState($logbut, $gui_disable)
		EndIf
	EndIf
EndFunc

Func gui_password()
	If NOT FileExists($passwordfile) Then
		$handle = FileOpen($passwordfile, 1)
		FileClose($handle)
	EndIf
	ShellExecute($passwordfile)
EndFunc

Func gui_website()
	ShellExecute($website)
EndFunc

Func gui_website_rb()
	ShellExecute($website_rb)
EndFunc

Func gui_website_o()
	ShellExecute($website_o)
EndFunc

Func gui_about()
	MsgBox(64, t("MENU_HELP_ABOUT_LABEL"), $name & " " & $version & @CRLF & "Copyright © 2005-2010 Jared Breland" & @CRLF & "Mod by koros aka ya158 (koros@ya.ru) 2013-2015")
EndFunc

Func gui_exit()
	terminate("silent")
EndFunc

Func _find_hexstring_in_file($s_file, $s_hexstring, $f_size = 10 * 1024 * 1024)
	Local Const $i_read = 300 * 1024, $__file_current_ = 1
	Local $i_len, $h_file, $b_read, $i_pos, $i_count, $i_err, $size, $c_pos
	If NOT FileExists($s_file) Then Return SetError(1, 0, 0)
	$size = FileGetSize($s_file) - $f_size
	If IsBinary($s_hexstring) Then
		$s_hexstring = Hex($s_hexstring)
	Else
		$s_hexstring = StringStripWS($s_hexstring, 8)
	EndIf
	$i_len = StringLen($s_hexstring)
	If Mod($i_len, 2) Then Return SetError(2, 0, 0)
	$i_len /= 2
	$h_file = FileOpen($s_file, 16)
	If $h_file = -1 Then Return SetError(3, 0, 0)
	While 1
		$c_pos = FileGetPos($h_file)
		If $c_pos > $f_size AND $c_pos < $size Then FileSetPos($h_file, -$f_size, 2)
		$b_read = FileRead($h_file, $i_read)
		If @extended <= $i_len Then ExitLoop
		$i_pos = StringInStr($b_read, $s_hexstring, 2)
		If Mod($i_pos, 2) Then ExitLoop
		$i_pos = 0
		If NOT FileSetPos($h_file, -$i_len, $__file_current_) Then
			$i_err = 4
			ExitLoop
		EndIf
		$i_count += 1
	WEnd
	FileClose($h_file)
	If $i_err Then Return SetError($i_err, 0, 0)
	If $i_pos Then Return Int(($i_pos - 1) / 2 - 1 + ($i_read - $i_len) * $i_count)
	Return 0
EndFunc
