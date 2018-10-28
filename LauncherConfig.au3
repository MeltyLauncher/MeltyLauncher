#include-once

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Viskar

 Script Function:
	Loading and Saving the Launcher's configuration between uses

#ce -------------------

#include <File.au3>
#include <FileConstants.au3>

Global Const $LAUNCHER_CONFIG_FOLDER = "MeltyLauncher"
Global Const $LAUNCHER_CONFIG_FILE = $LAUNCHER_CONFIG_FOLDER & "\config_v2.ini"

; config.ini data (needs to be loaded immediately)
Global $noKeyboard = 1 ; Whether MBAA should read keyboard
Global $mbaaccExe = "" ; Path to MBAA.exe
Global $mbaaccDir = "" ; MBAA.exe directory
Global $iniPath = "" ; The path to the MBAA button config ini
Global $appLocExe = "" ; AppLocale (optional)
Global $hiddenStages = 0 ; Should we use hidden stages

LauncherConfig_Load()

Func LauncherConfig_Load()
   Local $filePath = _PathFull($LAUNCHER_CONFIG_FILE, @AppDataDir)
   Local $configData = FileRead($filePath)

   If @error Then
	  ConsoleWrite("File not found " & $filePath)
   Else
	  ConsoleWrite("Opened file: " & $filePath & @CRLF)
	  Local $configLines = StringSplit($configData , @CRLF , 3)
	  For $configLine in $configLines
		 If StringLeft($configLine, 1) = '#' Or $configLine = '' Or Not StringInStr($configLine,'=') Then
			ContinueLoop
		 EndIf

		 Local $key = StringLeft($configLine,StringInStr($configLine, '=') - 1)
		 Local $value = StringTrimLeft($configLine, StringInStr($configLine, '='))

		 Switch $key
			Case "noKeyboard"
			   $noKeyboard = Number($value)
			Case "mbaaccExe"
			   $mbaaccExe = $value
			Case "appLocExe"
			   $appLocExe = $value
			Case "hiddenStages"
			   $hiddenStages = Number($value)
		 EndSwitch
	  Next
   EndIf
EndFunc

Func LauncherConfig_Save()

   ; Make directory first
   Local $folderPath = _PathFull($LAUNCHER_CONFIG_FOLDER, @AppDataDir)
   DirCreate($folderPath)

   ; Make or overwrite the config file
   Local $filePath = _PathFull($LAUNCHER_CONFIG_FILE, @AppDataDir)
   Local $fo = FileOpen($filePath, $FO_OVERWRITE)

   FileWrite($fo, "noKeyboard=" & $noKeyboard & @CRLF)
   If FileExists($mbaaccExe) Then
	  FileWrite($fo, "mbaaccExe=" & $mbaaccExe & @CRLF)
   EndIf
   If FileExists($appLocExe) Then
	  FileWrite($fo, "appLocExe=" & $appLocExe & @CRLF)
   EndIf
   FileWrite($fo, "hiddenStages=" & $hiddenStages & @CRLF)
   FileClose($fo)

   ConsoleWrite("Closed file: " & $filePath & @CRLF)
EndFunc