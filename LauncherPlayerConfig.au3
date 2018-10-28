#include-once

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Viskar

 Script Function:
	Player Configuration

#ce ----------------------------------------------------------------------------

#include <File.au3>
#include <FileConstants.au3>

Global Const $PLAYER_1 = 0
Global Const $PLAYER_2 = 1
Global Const $NUM_PLAYERS = 2

Global Const $ID_UP = 0
Global Const $ID_DOWN = 1
Global Const $ID_LEFT = 2
Global Const $ID_RIGHT = 3
Global Const $ID_START = 4
Global Const $ID_A = 5
Global Const $ID_B = 6
Global Const $ID_C = 7
Global Const $ID_D = 8
Global Const $ID_QA = 9
Global Const $ID_AB = 10  ; Optional
Global Const $ID_FN1 = 11 ; Optional
Global Const $ID_FN2 = 12 ; Optional

Global Const $NUM_BINDINGS = $ID_FN2 + 1
Global Const $REQUIRED_BINDINGS = $ID_QA + 1

; Writes the button config file
Func LauncherPlayerConfig_Save($keyConfigPath)
   Local $hFileOpen = FileOpen($keyConfigPath, $FO_OVERWRITE)
   FileWrite($hFileOpen, "[KeyConfig]" & @CRLF)
   if $noKeyboard == 1 Then
	  FileWrite($hFileOpen, "NoKeyboard= 1" & @CRLF)
   Else
	  FileWrite($hFileOpen, "NoKeyboard= 0" & @CRLF)
   EndIf
   ; P1
   If $done[0] Then
	  FileWrite($hFileOpen, "P0_Num= " & DIOrder(DIINdex($playerStick[$PLAYER_1])) & @CRLF)
	  FileWrite($hFileOpen, "P0_Name=" &  DIName(DIINdex($playerStick[$PLAYER_1])) & @CRLF)
	  FileWrite($hFileOpen, "P0_Val00= " & $bindings[$PLAYER_1][$ID_UP] & @CRLF) ; up
	  FileWrite($hFileOpen, "P0_Val01= " & $bindings[$PLAYER_1][$ID_DOWN] & @CRLF) ; down
	  FileWrite($hFileOpen, "P0_Val02= " & $bindings[$PLAYER_1][$ID_LEFT] & @CRLF) ; left
	  FileWrite($hFileOpen, "P0_Val03= " & $bindings[$PLAYER_1][$ID_RIGHT] & @CRLF) ; right
	  FileWrite($hFileOpen, "P0_Val04= " & $bindings[$PLAYER_1][$ID_START] & @CRLF) ; start
	  FileWrite($hFileOpen, "P0_Val05= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val06= " & $bindings[$PLAYER_1][$ID_D] & @CRLF) ; D
	  FileWrite($hFileOpen, "P0_Val07= " & $bindings[$PLAYER_1][$ID_C] & @CRLF) ; C
	  FileWrite($hFileOpen, "P0_Val08= " & $bindings[$PLAYER_1][$ID_A] & @CRLF) ; A
	  FileWrite($hFileOpen, "P0_Val09= " & $bindings[$PLAYER_1][$ID_B] & @CRLF) ; B
	  FileWrite($hFileOpen, "P0_Val10= " & $bindings[$PLAYER_1][$ID_AB] & @CRLF) ; A+B
	  FileWrite($hFileOpen, "P0_Val11= " & $bindings[$PLAYER_1][$ID_QA] & @CRLF) ; QA
	  FileWrite($hFileOpen, "P0_Val12= " & $bindings[$PLAYER_1][$ID_FN1] & @CRLF) ; FN1
	  FileWrite($hFileOpen, "P0_Val13= " & $bindings[$PLAYER_1][$ID_FN2] & @CRLF) ; FN2
	  FileWrite($hFileOpen, "P0_Val14= " & $bindings[$PLAYER_1][$ID_A] & @CRLF) ; Confirm
	  FileWrite($hFileOpen, "P0_Val15= " & $bindings[$PLAYER_1][$ID_B] & @CRLF) ; Cancel
	  FileWrite($hFileOpen, "P0_Val16= 17" & @CRLF) ; up
	  FileWrite($hFileOpen, "P0_Val17= 18" & @CRLF) ; down
	  FileWrite($hFileOpen, "P0_Val18= 19" & @CRLF) ; left
	  FileWrite($hFileOpen, "P0_Val19= 20" & @CRLF) ; right
	  FileWrite($hFileOpen, "P0_Val20= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val21= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val22= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val23= 0" & @CRLF) ; --
   Else
	  FileWrite($hFileOpen, "P0_Num= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Name= " & @CRLF)
	  FileWrite($hFileOpen, "P0_Val00= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val01= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val02= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val03= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val04= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val05= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val06= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val07= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val08= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val09= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val10= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val11= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val12= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val13= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val14= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val15= 0" & @CRLF)
	  FileWrite($hFileOpen, "P0_Val16= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val17= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val18= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val19= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val20= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val21= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val22= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P0_Val23= 0" & @CRLF) ; --
   EndIf
   ; P2
   if $done[1]  Then
	  FileWrite($hFileOpen, "P1_Num= " & DIOrder(DIIndex($playerStick[$PLAYER_2])) & @CRLF)
	  FileWrite($hFileOpen, "P1_Name=" &  DIName(DIIndex($playerStick[$PLAYER_2])) & @CRLF)
	  FileWrite($hFileOpen, "P1_Val00= " & $bindings[$PLAYER_2][$ID_UP] & @CRLF) ; up
	  FileWrite($hFileOpen, "P1_Val01= " & $bindings[$PLAYER_2][$ID_DOWN] & @CRLF) ; down
	  FileWrite($hFileOpen, "P1_Val02= " & $bindings[$PLAYER_2][$ID_LEFT] & @CRLF) ; left
	  FileWrite($hFileOpen, "P1_Val03= " & $bindings[$PLAYER_2][$ID_RIGHT] & @CRLF) ; right
	  FileWrite($hFileOpen, "P1_Val04= " & $bindings[$PLAYER_2][$ID_START] & @CRLF) ; start
	  FileWrite($hFileOpen, "P1_Val05= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val06= " & $bindings[$PLAYER_2][$ID_D] & @CRLF) ; D
	  FileWrite($hFileOpen, "P1_Val07= " & $bindings[$PLAYER_2][$ID_C] & @CRLF) ; C
	  FileWrite($hFileOpen, "P1_Val08= " & $bindings[$PLAYER_2][$ID_A] & @CRLF) ; A
	  FileWrite($hFileOpen, "P1_Val09= " & $bindings[$PLAYER_2][$ID_B] & @CRLF) ; B
	  FileWrite($hFileOpen, "P1_Val10= " & $bindings[$PLAYER_2][$ID_AB] & @CRLF) ; A+B
	  FileWrite($hFileOpen, "P1_Val11= " & $bindings[$PLAYER_2][$ID_QA] & @CRLF) ; QA
	  FileWrite($hFileOpen, "P1_Val12= " & $bindings[$PLAYER_2][$ID_FN1] & @CRLF) ; FN1
	  FileWrite($hFileOpen, "P1_Val13= " & $bindings[$PLAYER_2][$ID_FN2] & @CRLF) ; FN2
	  FileWrite($hFileOpen, "P1_Val14= " & $bindings[$PLAYER_2][$ID_A] & @CRLF) ; A
	  FileWrite($hFileOpen, "P1_Val15= " & $bindings[$PLAYER_2][$ID_B] & @CRLF) ; B
	  FileWrite($hFileOpen, "P1_Val16= 17" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val17= 18" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val18= 19" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val19= 20" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val20= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val21= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val22= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val23= 0" & @CRLF) ; --
   Else
	  FileWrite($hFileOpen, "P1_Num= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Name= " & @CRLF)
	  FileWrite($hFileOpen, "P1_Val00= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val01= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val02= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val03= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val04= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val05= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val06= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val07= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val08= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val09= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val10= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val11= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val12= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val13= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val14= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val15= 0" & @CRLF)
	  FileWrite($hFileOpen, "P1_Val16= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val17= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val18= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val19= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val20= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val21= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val22= 0" & @CRLF) ; --
	  FileWrite($hFileOpen, "P1_Val23= 0" & @CRLF) ; --
   EndIf
   ; P3
   FileWrite($hFileOpen, "P2_Num= 0" & @CRLF)
   FileWrite($hFileOpen, "P2_Name=" & @CRLF)
   FileWrite($hFileOpen, "P2_Val00= 0" & @CRLF) ; up
   FileWrite($hFileOpen, "P2_Val01= 0" & @CRLF) ; down
   FileWrite($hFileOpen, "P2_Val02= 0" & @CRLF) ; left
   FileWrite($hFileOpen, "P2_Val03= 0" & @CRLF) ; right
   FileWrite($hFileOpen, "P2_Val04= 0" & @CRLF) ; start
   FileWrite($hFileOpen, "P2_Val05= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val06= 0" & @CRLF) ; D
   FileWrite($hFileOpen, "P2_Val07= 0" & @CRLF) ; C
   FileWrite($hFileOpen, "P2_Val08= 0" & @CRLF) ; A
   FileWrite($hFileOpen, "P2_Val09= 0" & @CRLF) ; B
   FileWrite($hFileOpen, "P2_Val10= 0" & @CRLF) ; A+B
   FileWrite($hFileOpen, "P2_Val11= 0" & @CRLF) ; QA
   FileWrite($hFileOpen, "P2_Val12= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val13= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val14= 0" & @CRLF) ; A
   FileWrite($hFileOpen, "P2_Val15= 0" & @CRLF) ; B
   FileWrite($hFileOpen, "P2_Val16= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val17= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val18= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val19= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val20= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val21= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val22= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P2_Val23= 0" & @CRLF) ; --
   ; P4
   FileWrite($hFileOpen, "P3_Num= 0" & @CRLF)
   FileWrite($hFileOpen, "P3_Name=" & @CRLF)
   FileWrite($hFileOpen, "P3_Val00= 0" & @CRLF) ; up
   FileWrite($hFileOpen, "P3_Val01= 0" & @CRLF) ; down
   FileWrite($hFileOpen, "P3_Val02= 0" & @CRLF) ; left
   FileWrite($hFileOpen, "P3_Val03= 0" & @CRLF) ; right
   FileWrite($hFileOpen, "P3_Val04= 0" & @CRLF) ; start
   FileWrite($hFileOpen, "P3_Val05= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val06= 0" & @CRLF) ; D
   FileWrite($hFileOpen, "P3_Val07= 0" & @CRLF) ; C
   FileWrite($hFileOpen, "P3_Val08= 0" & @CRLF) ; A
   FileWrite($hFileOpen, "P3_Val09= 0" & @CRLF) ; B
   FileWrite($hFileOpen, "P3_Val10= 0" & @CRLF) ; A+B
   FileWrite($hFileOpen, "P3_Val11= 0" & @CRLF) ; QA
   FileWrite($hFileOpen, "P3_Val12= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val13= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val14= 0" & @CRLF) ; A
   FileWrite($hFileOpen, "P3_Val15= 0" & @CRLF) ; B
   FileWrite($hFileOpen, "P3_Val16= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val17= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val18= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val19= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val20= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val21= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val22= 0" & @CRLF) ; --
   FileWrite($hFileOpen, "P3_Val23= 0" & @CRLF) ; --
   ; close
   FileClose($hFileOpen)
EndFunc