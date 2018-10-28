#include-once

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Viskar

 Script Function:
	DirectInput8 integration for MeltyLauncher

#ce -------------------

#include <GUIConstants.au3>
#include <FileConstants.au3>
#include <WinApi.au3>
#include "LauncherConstants.au3"

Global Const $tagJoyState = "dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;byte[32]"
Local Const $tagObjectDataFormatStructures = _
		 "ptr;dword;dword;dword;" & _ ; 1
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _ ; 10
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _ ; 20
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _ ; 30
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _ ; 40
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword;" & _
		 "ptr;dword;dword;dword"

Global Const $DI_MAX_DEVICES = 16
Enum $DI_STATE, $DI_DEVICE, $DI_NAME, $DI_GUID, $DI_ORDER, $DI_X_MIN, $DI_X_MAX, $DI_Y_MIN, $DI_Y_MAX, $DI_Z_MIN, $DI_Z_MAX, $DI_RX_MIN, $DI_RX_MAX, $DI_RY_MIN, $DI_RY_MAX, $DI_RZ_MIN, $DI_RZ_MAX, $DI_PROP_COUNT ;First Element Access
Enum $DI_STATE_NONE, $DI_STATE_STALE, $DI_STATE_ACTIVE, $DI_STATE_COUNT

; Init DirectInput
Local $oIDirectInput8 = ObjCreateInterface($sCLSID_DirectInput, $sIID_IDirectInput8W, $tagIDirectInput8)
$oIDirectInput8.Initialize(_WinAPI_GetModuleHandle(0), $DIRECTINPUT_VERSION)

; properties for each device
Global $device[$DI_MAX_DEVICES][$DI_PROP_COUNT]
Global $deviceButtons[$DI_MAX_DEVICES][$NUM_BUTTONS]
Global $deviceButtonsEnabled[$DI_MAX_DEVICES][$NUM_BUTTONS]

; init defaults
For $i = 0 to $DI_MAX_DEVICES - 1
   DIRemove($i)
Next

; If iterating in callbacks, the device index
Local $tmpDevice = -1

; Remove a device by the $device array index
Func DIRemove($i)
   $device[$i][$DI_STATE] = $DI_STATE_NONE
   For $j = 1 to $DI_PROP_COUNT - 1
	   $device[$i][$j] = Null
   Next
   For $j = 0 to $NUM_BUTTONS - 1
	   $deviceButtons[$i][$j] = 0
	   $deviceButtonsEnabled[$i][$j] = 1
   Next
   ;ConsoleWrite("Removed " & $i & @CRLF)
EndFunc

; Adds a device to the first available $device array index
; @return the array index it was added to, or -1 on failure
Func DIAdd($deviceInterface, $deviceName, $deviceGuid, $deviceOrder)
   For $i = 0 to $DI_MAX_DEVICES - 1
	  If $device[$i][$DI_STATE] == $DI_STATE_NONE Then
		 $device[$i][$DI_STATE] = $DI_STATE_ACTIVE
		 $device[$i][$DI_DEVICE] = $deviceInterface
		 $device[$i][$DI_NAME] = $deviceName
		 $device[$i][$DI_GUID] = $deviceGuid
		 $device[$i][$DI_ORDER] = $deviceOrder
		 $tmpDevice = $i
		 GetRanges($deviceInterface)
		 $tmpDevice = -1
		 DIReadButton($i)
		 ;ConsoleWrite("Added " & $i & @CRLF)
		 Return $i
	  EndIf
   Next
   Return -1
EndFunc

; Lookup all the buttons/axes on the device and calibrate for their min/max ranges
; Calls the EnumObjectsCallback function
; @param oDevice - the deviceInterface instance
Func GetRanges($oDevice)
   Local $hCallback = DllCallbackRegister("EnumObjectsCallback", "bool", "ptr;ptr")
   $oDevice.EnumObjects(DllCallbackGetPtr($hCallback), 0, 0)
   DllCallbackFree($hCallback)
EndFunc

; Lookup the $device array index by the device's guid
Func DIIndex($guid)
   For $i = 0 to $DI_MAX_DEVICES - 1
	  If $device[$i][$DI_GUID] and StringCompare($device[$i][$DI_GUID], $guid) == 0 Then Return $i
   Next
   Return -1
EndFunc

; Gets the order that windows has given the device
; @param i - the $device array index
; @param the order of the device
Func DIOrder($i)
   return $device[$i][$DI_ORDER]
EndFunc

; Gets the max size of the $device array
Func DICount()
   return $DI_MAX_DEVICES
EndFunc

; Returns the DirectInputDevice interface
; @param i the $device array index
Func DIDevice($i)
   return $device[$i][$DI_DEVICE]
EndFunc

; Returns the device name
; @param i the $device array index to get it from
Func DIName($i)
   return $device[$i][$DI_NAME]
EndFunc

; return the device guid string
Func DIGuid($i)
   return $device[$i][$DI_GUID]
EndFunc

Func DIState($i)
   return $device[$i][$DI_STATE]
EndFunc

Func DIUnaquire()
   For $i = 0 to $DI_MAX_DEVICES - 1
	  If $device[$i][$DI_DEVICE] Then
		 $device[$i][$DI_DEVICE].Unacquire()
	  EndIf
   Next
EndFunc

Func DICalibrate($i)
   For $j = $X_PLUS to $NUM_BUTTONS - 1
	   $deviceButtonsEnabled[$i][$j] = BitXOR(1, $deviceButtons[$i][$j])
   Next
EndFunc

Func DIUncalibrate($i)
   For $j = 0 to $NUM_BUTTONS - 1
	   $deviceButtonsEnabled[$i][$j] = 1
   Next
EndFunc

; reads a button from the device by the index value
Func DIReadButton($i)

   ; Check if device exists
   If DIState($i) <> $DI_STATE_ACTIVE Then Return -1

   Local $acquire = $device[$i][$DI_DEVICE].Acquire()
   If ($acquire < 0 OR $acquire > 1) Then
	  DIRemove($i)
	  SetError($acquire)
	  return -1
   EndIf

   Local $pollStatus = $device[$i][$DI_DEVICE].Poll()
   if ($pollStatus > 1 OR $pollStatus < 0) Then
	  SetError($pollStatus)
	  return -1
   EndIf

   Local $joyState = DllStructCreate($tagJoyState)
   Local $status = $device[$i][$DI_DEVICE].GetDeviceState(DllStructGetSize($joyState), DllStructGetPtr($joystate))
   if ($status > 0 OR $status < 0) Then
	 return 0
   EndIf

   Local $button = DIMeltyButton($i, $joystate)
   Return SetExtended(@extended, $button)
EndFunc

Func DIMeltyButton($i, $joystate)

   ;ConsoleWrite("----Scan---- " & $i & @CRLF)

   ;Local $oldButtons[$NUM_BUTTONS]
   ;ConsoleWrite("Held: ")
   For $j = 0 to $NUM_BUTTONS -1
   ;  $oldButtons[$j] = $deviceButtons[$i][$j]
	  $deviceButtons[$i][$j] = 0
;	  If $oldButtons[$j] == 1 Then
;		 ;ConsoleWrite($j & " ")
;	  EndIf
   Next
   ;ConsoleWrite(@CRLF)

   ;ConsoleWrite("Buttons : ")
   ; Read buttons and track count in @extended
   Local $btnCount = 0
   for $j = 1 to 16
	  If DllStructGetData($joystate, 13, $j) Then
		 $deviceButtons[$i][$j] = 1
		 $btnCount = $btnCount + 1
		 ;ConsoleWrite($j & " ")
	  EndIf
   Next

   ; axes
   If $device[$i][$DI_X_MIN] <> Null Then
	  Local $step = ($device[$i][$DI_X_MAX] - $device[$i][$DI_X_MIN]) / 4
	  Local $x_min_trigger = $device[$i][$DI_X_MIN] + $step
	  Local $x_max_trigger = $device[$i][$DI_X_MAX] - $step
	  Local $x = DllStructGetData($joystate, 1)
	  If $x < $x_min_trigger Then
		 $deviceButtons[$i][$X_MINUS] = BitAND(1, $deviceButtonsEnabled[$i][$X_MINUS])
		 ;ConsoleWrite("x- ")
	  EndIf
	  If $x > $x_max_trigger Then
		 $deviceButtons[$i][$X_PLUS] =  BitAND(1, $deviceButtonsEnabled[$i][$X_PLUS])
		 ;ConsoleWrite("x+ ")
	  EndIf
   EndIf

   If $device[$i][$DI_Y_MIN] <> Null Then
	  Local $step = ($device[$i][$DI_Y_MAX] - $device[$i][$DI_Y_MIN]) / 4
	  Local $y_min_trigger = $device[$i][$DI_Y_MIN] + $step
	  Local $y_max_trigger = $device[$i][$DI_Y_MAX] - $step
	  Local $y = DllStructGetData($joystate, 2)
	  If $y < $y_min_trigger Then
		 $deviceButtons[$i][$Y_MINUS] = BitAND(1, $deviceButtonsEnabled[$i][$Y_MINUS])
		 ;ConsoleWrite("y- ")
	  EndIf
	  If $y > $y_max_trigger Then
		 $deviceButtons[$i][$Y_PLUS] = BitAND(1, $deviceButtonsEnabled[$i][$Y_PLUS])
		 ;ConsoleWrite("y+ ")
	  EndIf
   EndIf

   If $device[$i][$DI_Z_MIN] <> Null Then
	  Local $step = ($device[$i][$DI_Z_MAX] - $device[$i][$DI_Z_MIN]) / 4
	  Local $z_min_trigger = $device[$i][$DI_Z_MIN] + $step
	  Local $z_max_trigger = $device[$i][$DI_Z_MAX] - $step
	  Local $z = DllStructGetData($joystate, 3)
	  If $z < $z_min_trigger Then
		 $deviceButtons[$i][$Z_MINUS] = BitAND(1, $deviceButtonsEnabled[$i][$Z_MINUS])
		 ;ConsoleWrite("z- ")
	  EndIf
	  If $z > $z_max_trigger Then
		 $deviceButtons[$i][$Z_PLUS] = BitAND(1, $deviceButtonsEnabled[$i][$Z_PLUS])
		 ;ConsoleWrite("z+ ")
	  EndIf
   EndIf

   ; RX
   If $device[$i][$DI_RX_MIN] <> Null Then
	  Local $step = ($device[$i][$DI_RX_MAX] - $device[$i][$DI_RX_MIN]) / 4
	  Local $rx_min_trigger = $device[$i][$DI_RX_MIN] + $step
	  Local $rx_max_trigger = $device[$i][$DI_RX_MAX] - $step
	  Local $rx = DllStructGetData($joystate, 4)
	  If $rx < $rx_min_trigger Then
		 $deviceButtons[$i][$RX_MINUS] = BitAND(1, $deviceButtonsEnabled[$i][$RX_MINUS])
	  EndIf
	  If $rx > $rx_max_trigger Then
		 $deviceButtons[$i][$RX_PLUS] = BitAND(1, $deviceButtonsEnabled[$i][$RX_PLUS])
	  EndIf
   EndIf

   ; RY
   If $device[$i][$DI_RY_MIN] <> Null Then
	  Local $step = ($device[$i][$DI_RY_MAX] - $device[$i][$DI_RY_MIN]) / 4
	  Local $ry_min_trigger = $device[$i][$DI_RY_MIN] + $step
	  Local $ry_max_trigger = $device[$i][$DI_RY_MAX] - $step
	  Local $ry = DllStructGetData($joystate, 5)
	  If $ry < $ry_min_trigger Then
		 $deviceButtons[$i][$RY_MINUS] = BitAND(1, $deviceButtonsEnabled[$i][$RY_MINUS])
	  EndIf
	  If $ry > $ry_max_trigger Then
		 $deviceButtons[$i][$RY_PLUS] = BitAND(1, $deviceButtonsEnabled[$i][$RY_PLUS])
	  EndIf
   EndIf

   ; RZ
   If $device[$i][$DI_RZ_MIN] <> Null Then
	  Local $step = ($device[$i][$DI_RZ_MAX] - $device[$i][$DI_RZ_MIN]) / 4
	  Local $rz_min_trigger = $device[$i][$DI_RZ_MIN] + $step
	  Local $rz_max_trigger = $device[$i][$DI_RZ_MAX] - $step
	  Local $rz = DllStructGetData($joystate, 6)
	  ;ConsoleWrite("rz " & $rz & @CRLF)
	  If $rz < $rz_min_trigger Then
		 $deviceButtons[$i][$RZ_MINUS] = BitAND(1, $deviceButtonsEnabled[$i][$RZ_MINUS])
	  EndIf
	  If $rz > $rz_max_trigger Then
		 $deviceButtons[$i][$RZ_PLUS] = BitAND(1, $deviceButtonsEnabled[$i][$RZ_PLUS])
	  EndIf
   EndIf

   ; 7-8 sliders

   ; 9-12 POV
   For $j = 9 to 12
	  Local $pov = DIMeltyPov(DllStructGetData($joystate, $j))
	  If $pov > 0 Then
		 $deviceButtons[$i][$pov] = 1
		 ;ConsoleWrite("pov" & $pov & " ")
	  EndIf
   Next
   ;ConsoleWrite(@CRLF)

   ; Return the first new input detected
   For $j = 0 to $NUM_BUTTONS - 1
	  ;If $deviceButtons[$i][$j] == 1 AND $oldButtons[$j] == 0 Then
	  If $deviceButtons[$i][$j] == 1 Then
		 ;ConsoleWrite("Returning " & $j & @CRLF)
		 Return SetExtended($btnCount, $j)
	  EndIf
   Next

   ; no match
   return SetExtended($btnCount, $BTN_NONE)
EndFunc

Func DIMeltyPov($pov)
   switch $pov
   case 18000
	  return $POV_DOWN
   case 0
	  return $POV_UP
   case 9000
	  return $POV_RIGHT
   case 27000
	  return $POV_LEFT
   EndSwitch
   return $BTN_NONE
EndFunc

; True -> Sticks were changed
; False -> Sticks not changed
Local $orderCounter = 0
Func DIScanSticks()

   ; Mark sticks as dirty
   Local $activeCountBefore = 0
   For $i = 0 to $DI_MAX_DEVICES - 1
	  If $device[$i][$DI_STATE] == $DI_STATE_ACTIVE Then
		 $device[$i][$DI_STATE] = $DI_STATE_STALE
		 $activeCountBefore = $activeCountBefore + 1
	  EndIf
   Next

   $orderCounter = 0

   Local $hDILoadCallback = DllCallbackRegister("DILoadCallback", "bool", "ptr;ptr")
   $oIDirectInput8.EnumDevices($DI8DEVCLASS_GAMECTRL, DllCallbackGetPtr($hDILoadCallback), 0, $DIEDFL_ATTACHEDONLY)
   DllCallbackFree($hDILoadCallback)

   ; Remove unused sticks
   Local $activeCountAfter = 0
   Local $removedCount = 0
   For $i = 0 to $DI_MAX_DEVICES - 1
	  If $device[$i][$DI_STATE] == $DI_STATE_STALE Then
		 DIRemove($i)
		 $removedCount = $removedCount + 1
	  ElseIf $device[$i][$DI_STATE] == $DI_STATE_ACTIVE Then
		 $activeCountAfter = $activeCountAfter + 1
	  EndIf
   Next

   Return ($removedCount > 0) OR ($activeCountBefore <> $activeCountAfter)
EndFunc

Func DILoadCallback($pDIinstance, $pContext)

   If $pDIinstance Then
	  Local $tDIDEVICEINSTANCE = DllStructCreate("dword dwSize;" & _
		 "byte guidInstance[16];" & _
		 "byte guidProduct[16];" & _
		 "dword dwDevType;" & _
		 "wchar tszInstanceName[260];" & _
		 "byte guidFFDriver[16];" & _
		 "wchar tszProductName[260];" & _
		 "word wUsagePage;" & _
		 "word wUsage;", _
		 $pDIinstance)

	  $orderCounter = $orderCounter + 1
	  Local $pGuid = DllStructGetPtr($tDIDEVICEINSTANCE, "guidInstance")
	  Local $sGuid =  _WinAPI_StringFromGUID($pGuid)
	  Local $deviceIndex = DIIndex($sGuid)

	  If $deviceIndex >= 0 Then
		 $device[$deviceIndex][$DI_STATE] = $DI_STATE_ACTIVE
		 $device[$deviceIndex][$DI_ORDER] = $orderCounter
	  Else
		 Local $sName = DllStructGetData($tDIDEVICEINSTANCE, "tszInstanceName")
		 Local $oDevice = ObjCreateInterface($sCLSID_DirectInputDevice, $sIID_IDirectInputDevice8W, $tagIDirectInputDevice8)
		 $oDevice.Initialize(_WinAPI_GetModuleHandle(0), $DIRECTINPUT_VERSION, $pGuid)

		 Local $diJoyState2 = DllStructCreate($diJoyStateStruct)
		 Local $diObjectDataFormat = DllStructCreate("ptr;dword;dword;dword")
		 Local $objectDataFormatStructures = DllStructCreate($tagObjectDataFormatStructures)     ; 44
		 InitObjectFormat($objectDataFormatStructures)

		 Local $diDataFormat = DllStructCreate("dword;dword;dword;dword;dword;ptr")
		 DllStructSetData($diDataFormat, 1, DllStructGetSize($diDataFormat))
		 DllStructSetData($diDataFormat, 2, DllStructGetSize($diObjectDataFormat))
		 DllStructSetData($diDataFormat, 3, 0x00000001)
		 DllStructSetData($diDataFormat, 4, DllStructGetSize($diJoyState2))
		 DllStructSetData($diDataFormat, 5, DllStructGetSize($objectDataFormatStructures) / DllStructGetSize($diObjectDataFormat)) ; Num Entries (44)
		 DllStructSetData($diDataFormat, 6, DllStructGetPtr($objectDataFormatStructures))

		 Local $dataFormatStatus = $oDevice.SetDataFormat(DllStructGetPtr($diDataFormat))
		 If ($dataFormatStatus < 0 OR $dataFormatStatus > 0) Then
			MsgBox(64, "SetDataFormat", $dataFormatStatus)
		 EndIf

		 Local $coopStatus = $oDevice.SetCooperativeLevel(NULL, BitOR($DISCL_NONEXCLUSIVE, $DISCL_BACKGROUND))
		 If ($coopStatus < 0 OR $coopStatus > 0) Then
			MsgBox(64, "SetCooperativeLevel", $coopStatus)
		 EndIf

		 $deviceIndex = DIAdd($oDevice, $sName, $sGuid, $orderCounter)
	  EndIf
   EndIf
   Return 1
EndFunc

Func EnumObjectsCallback($ptr, $ref)
   If $ptr Then
	  ;dwSize, byte[16] guid, dwofs, dwType, dwFlags
	  Local $objectInstance = DllStructCreate("dword;byte[16];dword;dword;dword;wchar[260];byte[24]", $ptr)
	  If @error Then
		 ;ConsoleWrite("Error " & @error)
	  EndIf

	  Local $oDevice = $device[$tmpDevice][$DI_DEVICE]
	  Local $tGuid = DllStructCreate("int Data1;short Data2;short Data3;byte Data4[8]", DllStructGetPtr($objectInstance, 2))
	  Local $sGuid = _WinAPI_StringFromGUID($tGuid)
	  Local $sName = DllStructGetData($objectInstance, 6)
	  Local $devType = DllStructGetData($objectInstance, 4)

	  ;ConsoleWrite("" & $sGuid & " " & $sName & " " & $devType & @CRLF)

	  Switch $sGuid
	  Case $GUID_POV
		 ;ConsoleWrite("POV" & @CRLF)
	  Case $GUID_XAxis
		 Local $range = GetRange($oDevice, $devType)
		 $device[$tmpDevice][$DI_X_MIN] = $range[0]
		 $device[$tmpDevice][$DI_X_MAX] = $range[1]
	  Case $GUID_YAxis
		 Local $range = GetRange($oDevice, $devType)
		 $device[$tmpDevice][$DI_Y_MIN] = $range[0]
		 $device[$tmpDevice][$DI_Y_MAX] = $range[1]
	  Case $GUID_ZAxis
		 Local $range = GetRange($oDevice, $devType)
		 $device[$tmpDevice][$DI_Z_MIN] = $range[0]
		 $device[$tmpDevice][$DI_Z_MAX] = $range[1]
	  Case $GUID_RxAxis
		 Local $range = GetRange($oDevice, $devType)
		 $device[$tmpDevice][$DI_RX_MIN] = $range[0]
		 $device[$tmpDevice][$DI_RX_MAX] = $range[1]
	  Case $GUID_RyAxis
		 Local $range = GetRange($oDevice, $devType)
		 $device[$tmpDevice][$DI_RY_MIN] = $range[0]
		 $device[$tmpDevice][$DI_RY_MAX] = $range[1]
	  Case $GUID_RzAxis
		 Local $range = GetRange($oDevice, $devType)
		 $device[$tmpDevice][$DI_RZ_MIN] = $range[0]
		 $device[$tmpDevice][$DI_RZ_MAX] = $range[1]
	  EndSwitch

   EndIf
   Return 1
EndFunc

Func GetRange($oDevice, $devType)

   Local $ret[2]

   ; size headersize obj how
   Local $tHeader = DllStructCreate("dword;dword;dword;dword")
   ; header + min max
   Local $tDIPROPRANGE = DllStructCreate("dword;dword;dword;dword;long;long")
   DllStructSetData($tDIPROPRANGE, 1, DllStructGetSize($tDIPROPRANGE))
   DllStructSetData($tDIPROPRANGE, 2, DllStructGetSize($tHeader))
   DllStructSetData($tDIPROPRANGE, 3, $devType)
   DllStructSetData($tDIPROPRANGE, 4, 2) ; DIPH_BY_ID

   $oDevice.GetProperty(4, DllStructGetPtr($tDIPROPRANGE))
   $ret[0] = DllStructGetData($tDIPROPRANGE, 5)
   $ret[1] = DllStructGetData($tDIPROPRANGE, 6)
   ;ConsoleWrite("Range: " & $ret[0] & ", " & $ret[1] & @CRLF)
   return $ret
EndFunc

Func InitObjectFormat($objectDataFormatStructures)
    addBytes($objectDataFormatStructures, 0, DllStructGetPtr($tGUID_XAxis), 0, -2130706685, 256)
	addBytes($objectDataFormatStructures, 1, DllStructGetPtr($tGUID_YAxis), 4, -2130706685, 256)
	addBytes($objectDataFormatStructures, 2, DllStructGetPtr($tGUID_ZAxis), 8, -2130706685, 256)
	addBytes($objectDataFormatStructures, 3, DllStructGetPtr($tGUID_RxAxis), 12, -2130706685, 256)
	addBytes($objectDataFormatStructures, 4, DllStructGetPtr($tGUID_RyAxis), 16, -2130706685, 256)
	addBytes($objectDataFormatStructures, 5, DllStructGetPtr($tGUID_RzAxis), 20, -2130706685, 256)
	addBytes($objectDataFormatStructures, 6, DllStructGetPtr($tGUID_Slider), 24, -2130706685, 256)
	addBytes($objectDataFormatStructures, 7, DllStructGetPtr($tGUID_Slider), 28, -2130706685, 256)
	addBytes($objectDataFormatStructures, 8, DllStructGetPtr($tGUID_POV), 32, -2130706672, 0)
	addBytes($objectDataFormatStructures, 9, DllStructGetPtr($tGUID_POV), 36, -2130706672, 0)
	addBytes($objectDataFormatStructures, 10, DllStructGetPtr($tGUID_POV), 40, -2130706672, 0)
	addBytes($objectDataFormatStructures, 11, DllStructGetPtr($tGUID_POV), 44, -2130706672, 0)
	addBytes($objectDataFormatStructures, 12, NULL, 48, -2130706676, 0)
	addBytes($objectDataFormatStructures, 13, NULL, 49, -2130706676, 0)
	addBytes($objectDataFormatStructures, 14, NULL, 50, -2130706676, 0)
	addBytes($objectDataFormatStructures, 15, NULL, 51, -2130706676, 0)
	addBytes($objectDataFormatStructures, 16, NULL, 52, -2130706676, 0)
	addBytes($objectDataFormatStructures, 17, NULL, 53, -2130706676, 0)
	addBytes($objectDataFormatStructures, 18, NULL, 54, -2130706676, 0)
	addBytes($objectDataFormatStructures, 19, NULL, 55, -2130706676, 0)
	addBytes($objectDataFormatStructures, 20, NULL, 56, -2130706676, 0)
	addBytes($objectDataFormatStructures, 21, NULL, 57, -2130706676, 0)
	addBytes($objectDataFormatStructures, 22, NULL, 58, -2130706676, 0)
	addBytes($objectDataFormatStructures, 23, NULL, 59, -2130706676, 0)
	addBytes($objectDataFormatStructures, 24, NULL, 60, -2130706676, 0)
	addBytes($objectDataFormatStructures, 25, NULL, 61, -2130706676, 0)
	addBytes($objectDataFormatStructures, 26, NULL, 62, -2130706676, 0)
	addBytes($objectDataFormatStructures, 27, NULL, 63, -2130706676, 0)
	addBytes($objectDataFormatStructures, 28, NULL, 64, -2130706676, 0)
	addBytes($objectDataFormatStructures, 29, NULL, 65, -2130706676, 0)
	addBytes($objectDataFormatStructures, 30, NULL, 66, -2130706676, 0)
	addBytes($objectDataFormatStructures, 31, NULL, 67, -2130706676, 0)
	addBytes($objectDataFormatStructures, 32, NULL, 68, -2130706676, 0)
	addBytes($objectDataFormatStructures, 33, NULL, 69, -2130706676, 0)
	addBytes($objectDataFormatStructures, 34, NULL, 70, -2130706676, 0)
	addBytes($objectDataFormatStructures, 35, NULL, 71, -2130706676, 0)
	addBytes($objectDataFormatStructures, 36, NULL, 72, -2130706676, 0)
	addBytes($objectDataFormatStructures, 37, NULL, 73, -2130706676, 0)
	addBytes($objectDataFormatStructures, 38, NULL, 74, -2130706676, 0)
	addBytes($objectDataFormatStructures, 39, NULL, 75, -2130706676, 0)
	addBytes($objectDataFormatStructures, 40, NULL, 76, -2130706676, 0)
	addBytes($objectDataFormatStructures, 41, NULL, 77, -2130706676, 0)
	addBytes($objectDataFormatStructures, 42, NULL, 78, -2130706676, 0)
	addBytes($objectDataFormatStructures, 43, NULL, 79, -2130706676, 0)
EndFunc

Func addBytes($struct, $i, $pGuid, $offset, $type, $flag)
   Local $structIndex = $i * 4;
   DllStructSetData($struct, $structIndex + 1, $pGuid)
   DllStructSetData($struct, $structIndex + 2, $offset)
   DllStructSetData($struct, $structIndex + 3, $type)
   DllStructSetData($struct, $structIndex + 4, $flag)
EndFunc

Func caps($i)
	  Local $tDIDEVCAPS  = DllStructCreate("DWORD dwSize;" & _
		 "DWORD dwFlags;" & _
    	 "DWORD dwDevType;" & _
    	 "DWORD dwAxes;" & _
    	 "DWORD dwButtons;" & _
    	 "DWORD dwPOVs;" & _
    	 "DWORD dwFFSamplePeriod;" & _
    	 "DWORD dwFFMinTimeResolution;" & _
    	 "DWORD dwFirmwareRevision;" & _
    	 "DWORD dwHardwareRevision;" & _
    	 "DWORD dwFFDriverVersion")
	  DllStructSetData($tDIDEVCAPS, 1, DllStructGetSize($tDIDEVCAPS))
	  Local $capsResult = $diDevice[$i].GetCapabilities(DllStructGetPtr($tDIDEVCAPS))
	  if ($capsResult < 0 OR $capsResult > 0) Then
		 MsgBox(64, ".GetCapabilities", $capsResult)
	  EndIf
	  MsgBox(64, "", DllStructGetData($tDIDEVCAPS, 1) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 2) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 3) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 4) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 5) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 6) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 7) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 8) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 9) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 10) & " " & @CRLF & _
			DllStructGetData($tDIDEVCAPS, 11))

EndFunc
