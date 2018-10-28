#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Viskar

 Script Function:
	MeltyLauncher

#ce -------------------

#include "Include\NomadMemory.au3"

; Writes the memory addresses into the running MBAA.exe process to enable secret stages
; Thanks to Melty community for details.
; These values are for a pre-Steam version of the game and will not work on the Steam version.
; @param mbaaccPid - the PID for MBAA.exe
Func LauncherStages_Inject($mbaaccPid)
   Local $i_Open = _MemoryOpen($mbaaccPid)

   _MemoryWrite(0x54CEBC, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CEC0, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CEC4, $i_Open, 0x000000FF)

   _MemoryWrite(0x54CFA8, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CFAC, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CFB0, $i_Open, 0x000000FF)

   _MemoryWrite(0x54CF68, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF6C, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF70, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF74, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF78, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF7C, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF80, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF84, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF88, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF8C, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF90, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF94, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF98, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CF9C, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CFA0, $i_Open, 0x000000FF)
   _MemoryWrite(0x54CFA4, $i_Open, 0x000000FF)

   _MemoryWrite(0x7695F6, $i_Open, 0x00000035)
   _MemoryWrite(0x7695EC, $i_Open, 0x401ECCAA)

   _MemoryClose($i_Open)
EndFunc