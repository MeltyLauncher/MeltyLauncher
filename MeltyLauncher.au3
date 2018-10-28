#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Viskar

 Script Function:
	MeltyLauncher App

#ce -------------------

; -----------------------------------------------------------------------
; General Init
; Always load config
; -----------------------------------------------------------------------

#include "LauncherConfig.au3"
LauncherConfig_Load()

; -----------------------------------------------------------------------
; If special Launch Mode:
; If the script is invoked with a single command line parameter of "1"
; then it means MBAA.exe has been launched and this background process
; should press the "Enter" button to close the MBAA config window and
; open the full game
; -----------------------------------------------------------------------

Global Const $FEATURE_HIDDEN_STAGES = 0 ; 0=Off, 1=Show option in UI Setting this to zero hard disables the Hidden Stages in UI, since it only works on the original pre-Stream PC release
#include "LauncherStages.au3"

If $CmdLine[0] == 1 AND $CmdLine[1] == "1" Then
   AutoCloseMeltyConfig()
   Exit
EndIf

; Closes the default MBAA config window by pressing {ENTER} when the screen shows up
Func AutoCloseMeltyConfig()
   ;Local $hMeltyBlood = ActivateAndSend("MELTY BLOOD", 1000, 10, "{ENTER}", 0)
   Local $hMeltyBlood = ActivateNoSend("MELTY BLOOD", 1000, 10, 0)
   If $hMeltyBlood Then
	  Sleep(1000)
	  Local $proc = WinGetProcess($hMeltyBlood)
      If $FEATURE_HIDDEN_STAGES And $hiddenStages Then
	     LauncherStages_Inject($proc)
      EndIf
	  Sleep(1000)
	  Send("{ENTER}")
	  Return $proc
   EndIf
   Return 0
EndFunc

; -----------------------------------------------------------------------
; Normal Launch Mode
; Onto the main code. This is were we actually load up the main script and GUI
; -----------------------------------------------------------------------

#include <WinApi.au3>
#include <ColorConstants.au3>
#include "LauncherPlayerConfig.au3"
#include "LauncherGUI.au3"
#include "LauncherHeaderImage.au3"
; #include "LauncherBackgroundImage.au3"
#include "LauncherDirectInput.au3"
#include "Include\NoFocusLines.au3"

_NoFocusLines_Global_Set()

; Labels for each of the buttons
Global Const $BUTTON_LABELS = [ _
   "None", _
   "(1)", _
   "(2)", _
   "(3)", _
   "(4)", _
   "(5)", _
   "(6)", _
   "(7)", _
   "(8)", _
   "(9)", _
   "(10)", _
   "(11)", _
   "(12)",  _
   "(13)", _
   "(14)", _
   "(15)", _
   "(16)", _
   "Up", _
   "Down", _
   "Left", _
   "Right", _
   "X+", _
   "X-", _
   "Y+", _
   "Y-", _
   "Z+", _
   "Z-",  _
   "Rx+",  _
   "Rx-",  _
   "Ry+",  _
   "Ry-",  _
   "Rz+",  _
   "Rz-"  _
]

; UI settings
Local Const $WINDOW_W = 600
Local Const $WINDOW_H = 520

; Global Const $BG_W = 409
; Global Const $BG_H = 140
Global Const $BG_X = 98

Local Const $PLAYER_OFFSET_X_STEP = $WINDOW_W / $NUM_PLAYERS

Local Const $CONTROLLER_H = 42
Local Const $CONTROLLER_W = 208
Local Const $CONTROLLER_Y_OFFSET = 130
Local Const $CONTROLLER_X_OFFSET = 55
Local Const $CONTROLLER_X_OFFSET_STEP = $PLAYER_OFFSET_X_STEP
Local Const $CONTROLLER_FONT = $FONT
Local Const $CONTROLLER_FONT_SIZE = $FONT_SIZE - FScale(2)

Local Const $BUTTON_LABEL_H = 31
Local Const $BUTTON_LABEL_W = 103
Local Const $BUTTON_LABEL_Y_OFFSET = $CONTROLLER_Y_OFFSET + 45 ; 45
Local Const $BUTTON_LABEL_Y_OFFSET_STEP = 20
Local Const $BUTTON_LABEL_X_OFFSET = 55
Local Const $BUTTON_LABEL_X_OFFSET_STEP = $PLAYER_OFFSET_X_STEP
Local Const $BUTTON_FONT = $FONT
Local Const $BUTTON_FONT_SIZE = $FONT_SIZE

Local Const $BINDING_LABEL_H = 23
Local Const $BINDING_LABEL_W = $BUTTON_LABEL_W
Local Const $BINDING_LABEL_Y_OFFSET = $BUTTON_LABEL_Y_OFFSET
Local Const $BINDING_LABEL_Y_OFFSET_STEP = $BUTTON_LABEL_Y_OFFSET_STEP
Local Const $BINDING_LABEL_X_OFFSET = $BUTTON_LABEL_X_OFFSET + 90
Local Const $BINDING_LABEL_X_OFFSET_STEP = $BUTTON_LABEL_X_OFFSET_STEP
Local Const $BINDING_FONT = $FONT
Local Const $BINDING_FONT_SIZE = $FONT_SIZE
Local Const $BINDING_FONT_STYLE = 0

Local Const $DONE_LABEL_H = 40
Local Const $DONE_LABEL_W = 300
Local Const $DONE_LABEL_X_OFFSET = ($WINDOW_W - $DONE_LABEL_W) / 2
Local Const $DONE_LABEL_Y_OFFSET = $BUTTON_LABEL_Y_OFFSET + ($NUM_BINDINGS * $BUTTON_LABEL_Y_OFFSET_STEP) + 22

Local Const $WINDOW_BG_COLOR = 0x000000
Local Const $BTN_BG_COLOR = 0x080808

Local $DEFAULT_BINDINGS[$NUM_BINDINGS]
$DEFAULT_BINDINGS[$ID_UP]    = -1
$DEFAULT_BINDINGS[$ID_DOWN]  = -1
$DEFAULT_BINDINGS[$ID_LEFT]  = -1
$DEFAULT_BINDINGS[$ID_RIGHT] = -1
$DEFAULT_BINDINGS[$ID_START] = -1
$DEFAULT_BINDINGS[$ID_A]     = -1
$DEFAULT_BINDINGS[$ID_B]     = -1
$DEFAULT_BINDINGS[$ID_C]     = -1
$DEFAULT_BINDINGS[$ID_D]     = -1
$DEFAULT_BINDINGS[$ID_QA]    = -1
$DEFAULT_BINDINGS[$ID_AB]    = 0 ; Optional
$DEFAULT_BINDINGS[$ID_FN1]   = 0 ; Optional
$DEFAULT_BINDINGS[$ID_FN2]   = 0 ; Optional

Local $BINDING_NAME[$NUM_BINDINGS]
$BINDING_NAME[$ID_UP] = "UP"
$BINDING_NAME[$ID_DOWN] = "DOWN"
$BINDING_NAME[$ID_LEFT] = "LEFT"
$BINDING_NAME[$ID_RIGHT] = "RIGHT"
$BINDING_NAME[$ID_START] = "START"
$BINDING_NAME[$ID_A] = "A"
$BINDING_NAME[$ID_B] = "B"
$BINDING_NAME[$ID_C] = "C"
$BINDING_NAME[$ID_D] = "D"
$BINDING_NAME[$ID_QA] = "QA"
$BINDING_NAME[$ID_AB] = "A+B"
$BINDING_NAME[$ID_FN1] = "FN1"
$BINDING_NAME[$ID_FN2] = "FN2"

; The stick guid for each player
Local $playerStick[$NUM_PLAYERS]

;Whether an input is active on the device
Local $deviceButtonHeld[16]

;The next binding index to set for each player
Local $playerStatus[$NUM_PLAYERS]

; Status is set to true if no player is still in the middle of binding required buttons.
; Requires at least 1 player have buttons set (P1, P2, or both)
Local $isDone = False

; Status of each player. It indicates whether or not they are done with required button bindings
Local $done[$NUM_PLAYERS]

; What buttons each player has assigned
Local $bindings[$NUM_PLAYERS][$NUM_BINDINGS]

; GUI labels
Local $hwnd ; gui handle
Local $lblText[$NUM_PLAYERS][$NUM_BINDINGS] ; button labels
Local $lblHighlight[$NUM_PLAYERS][$NUM_BINDINGS]
Local $lblHelpText[$NUM_PLAYERS]
Local $lblBindings[$NUM_PLAYERS][$NUM_BINDINGS] ; Mapped buttons
Local $lblPressStart[$NUM_PLAYERS]
Local $btnPlayerController[$NUM_PLAYERS]
Local $lblPlayerController[$NUM_PLAYERS]
Local $btnDone ; Press space to continue

Local $btnAppLocale ;
Local $btnExit ; [ESC] Exit
Local $btnKeyboard ; Keyboard: OFF
Local $btnHiddenStages ; HiddenStages: OFF

; Set to true when the game should be launched, and then automatically set back to false until the next launch
; The {SPACE} keypress event callback is what triggers this to be set to true.
Local $complete

; Load the UI components
Func Init()

   ; --------------------------------------------------------------------------
   ; GUI
   ; --------------------------------------------------------------------------

   $hwnd = GUICreate("", $WINDOW_W, $WINDOW_H, -1, -1, BitOr($WS_POPUP, $WS_BORDER), $WS_EX_COMPOSITED)
   GUISetBkColor($WINDOW_BG_COLOR)

   ; --------------------------------------------------------------------------
   ; Player Button Area
   ; --------------------------------------------------------------------------

   For $p = 0 To $NUM_PLAYERS - 1

	  For $i = 0 To $NUM_BINDINGS - 1
		 $lblText[$p][$i] = LauncherLabelCreate($BINDING_NAME[$i], 8 + $BUTTON_LABEL_X_OFFSET + ($p * $BUTTON_LABEL_X_OFFSET_STEP), $BUTTON_LABEL_Y_OFFSET + ($BUTTON_LABEL_Y_OFFSET_STEP * $i), $BUTTON_LABEL_W, $BUTTON_LABEL_H)
		 GUICtrlSetState(-1, $GUI_HIDE)

		 $lblBindings[$p][$i] = LauncherLabelCreate(getMeltyButtonText($DEFAULT_BINDINGS[$i]), $BINDING_LABEL_X_OFFSET + ($p * $BINDING_LABEL_X_OFFSET_STEP), $BINDING_LABEL_Y_OFFSET + ($BINDING_LABEL_Y_OFFSET_STEP * $i), $BINDING_LABEL_W, $BINDING_LABEL_H , $BINDING_FONT_SIZE, $BINDING_FONT_STYLE)
		 GUICtrlSetStyle(-1, $SS_CENTER)
		 GUICtrlSetState(-1, $GUI_HIDE)

		 $lblHighlight[$p][$i] = GUICtrlCreateLabel("", 2 + $BUTTON_LABEL_X_OFFSET + ($p * $BUTTON_LABEL_X_OFFSET_STEP), 2 + $BINDING_LABEL_Y_OFFSET + ($BINDING_LABEL_Y_OFFSET_STEP * $i), 193, $BINDING_LABEL_H - 4)
		 LauncherLabelHighlight(-1)
		 GUICtrlSetState(-1, $GUI_HIDE)
	  Next

	  $lblHelpText[$p] = LauncherLabelCreate("Reset: Hold [3 Buttons] or [Click]", $BUTTON_LABEL_X_OFFSET + ($p * $BUTTON_LABEL_X_OFFSET_STEP), $BUTTON_LABEL_Y_OFFSET + ($BUTTON_LABEL_Y_OFFSET_STEP * $NUM_BINDINGS) + 3, 190, $BUTTON_LABEL_H)
	  GUICtrlSetFont(-1, FScale(8), -1, -1, $FONT)
	  GUICtrlSetStyle(-1, $SS_CENTER)
	  GUICtrlSetState(-1, $GUI_HIDE)

	  $lblPressStart[$p] = GUICtrlCreateButton("(P" & ($p+1) & ") Press Start", 20 + $CONTROLLER_X_OFFSET + ($p * $CONTROLLER_X_OFFSET_STEP), 200, $CONTROLLER_W - 20, $CONTROLLER_H)
	  GUICtrlSetColor(-1, $FONT_COLOR)
	  GUICtrlSetBkColor(-1, $BTN_BG_COLOR)
	  GUICtrlSetFont(-1, FScale(14), 700, -1, $FONT, $FONT_QUALITY)
	  If Not $p == 0 Then
		 GUICtrlSetState(-1, HIDE)
	  EndIf

	  Local $x = $BUTTON_LABEL_X_OFFSET + ($p * $BUTTON_LABEL_X_OFFSET_STEP)
	  Local $y = 130; any higher clips the image
	  Local $w = 197
	  Local $h = 37

	  $lblPlayerController[$p] = GUICtrlCreateLabel("", $x + 3, $y + 6, $w - 6, $h - 6, $SS_CENTER)
	  GUICtrlSetBkColor(-1, $BTN_BG_COLOR)
	  GUICtrlSetColor(-1, $FONT_COLOR)
	  GUICtrlSetFont(-1, FScale(9), 700, $FONT_STYLE, $FONT, $FONT_QUALITY)
	  GUICtrlSetCursor(-1, 0)
	  GUICtrlSetState(-1, $GUI_HIDE)

	  ; Button
	  $btnPlayerController[$p] = GUICtrlCreateButton("", $x, $y, $w, $h + 290)
	  GUICtrlSetBkColor(-1, $BTN_BG_COLOR)
	  GUICtrlSetCursor(-1, 0)
	  GUICtrlSetState(-1, $GUI_HIDE)
   Next

   ; --------------------------------------------------------------------------
   ; Bottom-Right Controls (Exit, etc)
   ; --------------------------------------------------------------------------

   ; Exit Button
   $btnExit = AddLowerRightButton("[ESC] Exit", $WINDOW_W, $WINDOW_H, 70)

   ; Hidden Stages Button
   If $FEATURE_HIDDEN_STAGES Then
	  If $hiddenStages Then
		 $btnHiddenStages = AddLowerRightButton("Hidden Stages: ON", $WINDOW_W, $WINDOW_H, 110)
	  Else
		 $btnHiddenStages = AddLowerRightButton("Hidden Stages: OFF", $WINDOW_W, $WINDOW_H, 110)
	  EndIf
   EndIf

   ; Keyboard Toggle
   If $noKeyboard == 1 Then
	  $btnKeyboard = AddLowerRightButton("Keyboard: OFF", $WINDOW_W, $WINDOW_H, 90)
   Else
	  $btnKeyboard = AddLowerRightButton("Keyboard: ON", $WINDOW_W, $WINDOW_H, 90)
   EndIf

   ; AppLocale toggle
   If FileExists($appLocExe) Then
	  $btnAppLocale  = AddLowerRightButton("AppLocale: ON", $WINDOW_W, $WINDOW_H, 90)
   Else
	  $btnAppLocale  = AddLowerRightButton("AppLocale: OFF", $WINDOW_W, $WINDOW_H, 90)
   EndIf

   ; --------------------------------------------------------------------------
   ; 'Configuration Complete' GUI Elements
   ; --------------------------------------------------------------------------

   ; Space to exit
   $btnDone = GUICtrlCreateButton("[SPACE] Start Game", $DONE_LABEL_X_OFFSET, $DONE_LABEL_Y_OFFSET, $DONE_LABEL_W, $DONE_LABEL_H)
   GUICtrlSetCursor($btnDone, 0)
   GUICtrlSetColor($btnDone, $FONT_COLOR)
   GUICtrlSetBkColor($btnDone, $BTN_BG_COLOR)
   GUICtrlSetFont($btnDone, FScale(14), 700, -1, $FONT, $FONT_QUALITY)
   GUICtrlSetState($btnDone, $GUI_HIDE)

   ; --------------------------------------------------------------------------
   ; GUI Images (top header and background image)
   ; --------------------------------------------------------------------------

   Local $hHeaderPic = GUICtrlCreatePic("", $BG_X, 0, LauncherHeaderImage_GetWidth(), LauncherHeaderImage_GetHeight())
   LauncherHeaderImage_Apply($hHeaderPic)

   ; Disabling background image until new assets are ready
   ; Local $hBackgroundPic = GUICtrlCreatePic("", 0, $WINDOW_H - 329, $WINDOW_W, 329)
   ; LauncherBackgroundImage_Apply($hBackgroundPic)

   ; --------------------------------------------------------------------------
   ; Show GUI
   ; --------------------------------------------------------------------------

   ResetState()
   Show()

   ; Bind the {SPACE} hotkey to set "complete=true" if all players are done binding
   HotKeySet("{SPACE}", "Complete")

EndFunc

Func ShowPlayerLabels($p)
   For $i = 0 To $NUM_BINDINGS - 1
	  GUICtrlSetState($lblText[$p][$i], $GUI_SHOW)
	  GUICtrlSetState($lblBindings[$p][$i], $GUI_SHOW)
   Next
   GUICtrlSetState($lblHighlight[$p][0], $GUI_SHOW)
   GUICtrlSetState($lblHelpText[$p], $GUI_SHOW)
   GUICtrlSetState($lblPlayerController[$p], $GUI_SHOW)
   GUICtrlSetState($btnPlayerController[$p], $GUI_SHOW)
EndFunc

Func HidePlayerLabels($p)
   For $i = 0 To $NUM_BINDINGS - 1
	  GUICtrlSetState($lblText[$p][$i], $GUI_HIDE)
	  GUICtrlSetState($lblBindings[$p][$i], $GUI_HIDE)
	  GUICtrlSetState($lblHighlight[$p][$i], $GUI_HIDE)
   Next
   GUICtrlSetState($lblHelpText[$p], $GUI_HIDE)
   GUICtrlSetState($lblPlayerController[$p], $GUI_HIDE)
   GUICtrlSetState($btnPlayerController[$p], $GUI_HIDE)
EndFunc

; Reset everything back to default
Func ResetState()
   ;unbind all bindings
   for $p = 0 To $NUM_PLAYERS - 1
	  ResetPlayer($p, False)
   Next
   For $i = 0 to 15
	  $deviceButtonHeld[$i] = True
   Next
   $isDone = False
   $complete = 0
   UpdateControllerLabels()
   UpdateDoneStatus()
EndFunc

; Called when a player pushes 3 buttos on a controller
; It will remove their controller and bindings from their player port
; so a new device can be selected or the current device can be re-bound
; @param p - the player id $PLAYER_1 (0), $PLAYER_2 (1), ...
; @param refreshGlobalState - whether we should try to update the ui status
;         indicators like "--Press Start--" and "Press [Space] to continue"
Func ResetPlayer($p, $refreshGlobalState = True)

   Local $deviceGuid = $playerStick[$p]
   If $deviceGuid Then
	  Local $deviceIndex = DIIndex($deviceGuid)
	  If $deviceIndex >= 0 Then
		 $deviceButtonHeld[$deviceIndex] = True
	  EndIf
   EndIf

   $playerStick[$p] = Null
   $playerStatus[$p] = 0
   $done[$p] = False

   ;unbind all bindings
   for $i = 0 to $NUM_BINDINGS - 1
	  $bindings[$p][$i] = $DEFAULT_BINDINGS[$i]
   Next

   ; reset gui
   For $i = 0 To $NUM_BINDINGS - 1
	  LauncherLabelSetData($lblBindings[$p][$i], getMeltyButtonText($DEFAULT_BINDINGS[$i]))
   Next

   If $refreshGlobalState Then
	  UpdateControllerLabels()
	  UpdateDoneStatus()
   EndIf
EndFunc

; Checks if a button is pressed on the provided device.
; @param i - The device index
; @param ignoreAxes - Whether we should also check for movement in the axes and POV
; @return (-1) Three or more buttons were pressed at once, (0) no button is pressed, (>0) A new button is pressed
Func getButtonPress($i, $ignoreAxes)

   If DIState($i) <> 2 Then
	  Return -1
   EndIf

   Local $btnPressed = DIReadButton($i)
   Local $btnsHeld = @extended
   ;ConsoleWrite("Btn: " & $btnPressed & ", Held=" & $deviceButtonHeld[$i] & ", IgnoreAxes=" & $ignoreAxes & @CRLF)

   If $ignoreAxes And $btnPressed >= $POV_UP Then
	  $btnPressed = 0
   EndIf

   If ($btnPressed == -1 OR $btnsHeld >= 3) Then
	  $deviceButtonHeld[$i] = True
	  Return -1
   EndIf

   If ($btnPressed == 0) Then
	  $deviceButtonHeld[$i] = False
	  Return 0
   EndIf

   If $deviceButtonHeld[$i] Then
	  Return 0
   EndIf

   $deviceButtonHeld[$i] = True
   return $btnPressed
EndFunc

; This function is called when in the "-- Press Start --" mode for a player
; It will check if a button has been pressed on a controller. If a pressed button
; is found on a controller, it will assign that device to that player slot.
; @param p - the player ID to try and find a controller for
; @return (-1) No controller with a pressed button found.
;         (0) This player is already bound
;         (1) The player was bound to a controller
Func bindPlayer($p)

   If $playerStick[$p] Then
	  Return 0
   EndIf

   For $i = 0 To DICount() - 1
	  ; don't bind to the other player's stick
	  Local $tmpSkip = False
	  For $o = 0 to $NUM_PLAYERS - 1
		 If $playerStick[$o] AND DIIndex($playerStick[$o]) == $i Then
			$tmpSkip = True
			ExitLoop
		 EndIf
	  Next
	  If $tmpSkip Then ContinueLoop

	  Local $btnPressed = getButtonPress($i, True)
	  If ($btnPressed >= $BTN_1 And $btnPressed <= $BTN_16) Then
		 ; bound the player
		 $playerStick[$p] = DIGuid($i)
		 DICalibrate($i)
		 GUICtrlSetState($lblHighlight[$p][0], $GUI_SHOW)
		 UpdateControllerLabels()
		 UpdateDoneStatus()
		 return 1
	  EndIf
   Next
   return -1
EndFunc

; Test if the player has already bound a controller button to a previous mapping
; @param p - the player ID
; @param btn - the controller button pressed
; @param index - The end range (exclusive) of button bindings to scan through to see if the button is already used
; @return tre if that button is already bound in a previous mapping
Func IsButtonBound($p, $btn, $index)
   For $i = 0 to $index - 1
	  If $bindings[$p][$i] == $btn Then Return True
   Next
   Return False
EndFunc

; Called on each loop for each player that has a bound controller.
; Waits for the next button press and binds that button press to the next game input.
; If 3 or more buttons are held at once on the controller, then that player is reset and their controller is unbound
; @param p - the player ID
; @return True if a button was pressed and bound
Func updatePlayer($p)
   If $playerStick[$p] Then

	  ; Find the index for the controller device by passing it's guid
	  Local $deviceIndex = DIIndex($playerStick[$p])
	  If $deviceIndex < 0 Then
		 ResetPlayer($p)
		 Return False
	  EndIf

	  ; Check for a button press
	  Local $btnPressed = getButtonPress($deviceIndex, False)
	  If ($btnPressed == 0) Then
		 Return False ; No button press
	  EndIf

	  ; Check for 3 held buttons, if so reset the player
	  If ($btnPressed == -1) Then
		 ResetPlayer($p)
		 DIUncalibrate($deviceIndex)
		 Return False
	  EndIf

	  ; Find out which game input we are about to bind
	  Local $index = $playerStatus[$p]
	  Local $indexNext = Mod($index + 1, $NUM_BINDINGS)

	  ; If the player already bound this button to a previous game input,
	  ; Then bind this one to NONE instead of duplicating the binding.
	  If IsButtonBound($p, $btnPressed, $index) Then
		 $btnPressed = $BTN_NONE
	  EndIf

	  ; Update the labels for the new binding
	  LauncherLabelSetData($lblBindings[$p][$index], getMeltyButtonText($btnPressed))
	  GUICtrlSetState($lblHighlight[$p][$index], $GUI_HIDE)
	  GUICtrlSetState($lblHighlight[$p][$indexNext], $GUI_SHOW)

	  ; Sava the binding
	  $bindings[$p][$index] = $btnPressed

	  ; Check if this player has bound all require buttons
	  If ($playerStatus[$p] + 1) >= $REQUIRED_BINDINGS Then
		 $done[$p] = True
	  EndIf

	  ; Update for the next game input index to bind (rotate back to the first input if they reach the end)
	  $playerStatus[$p] = Mod($playerStatus[$p] + 1, $NUM_BINDINGS)

	  ; Check if all players are fully bound and show/hide the "Press [Space] to continue" label
	  UpdateDoneStatus()
	  Return True
   Else
	  Return False
   EndIf
EndFunc

; Updates the labels for each player depending on if they
; are bound to a controller yet
Func UpdateControllerLabels()
   Local $showPressStart = True
   For $p = 0 to $NUM_PLAYERS - 1
	  If $playerStick[$p] AND DIIndex($playerStick[$p]) >= 0 Then
		 GUICtrlSetData($lblPlayerController[$p], DIName(DIIndex($playerStick[$p])))
		 GUICtrlSetState($lblPressStart[$p], $GUI_HIDE)
		 ShowPlayerLabels($p)
	  ElseIf $showPressStart Then
		 $showPressStart = False
		 GUICtrlSetState($lblPressStart[$p], $GUI_SHOW)
		 HidePlayerLabels($p)
	  Else
		 GUICtrlSetState($lblPressStart[$p], $GUI_HIDE)
		 HidePlayerLabels($p)
	  EndIf
   Next
EndFunc

Func UpdateDoneStatus($setComplete = False)

   Local $tmpDone = False
   If $noKeyboard == 0 Then
	  $tmpDone = True
   EndIf

   For $p = 0 to $NUM_PLAYERS - 1
	  If $done[$p] Then
		 $tmpDone = True
	  EndIf
	  If (NOT $done[$p]) AND $playerStick[$p] Then
		 $tmpDone = False
		 $p = $NUM_PLAYERS ;exit loop
	  EndIf
   Next

   If ($tmpDone) Then
	  If $setComplete Then $complete = 1
	  If Not $isDone Then
		 $isDone = True
		 GUICtrlSetState($btnDone, $GUI_SHOW)
	  EndIf
   Else
	  if $isDone Then
		 $isDone = False
		 GUICtrlSetState($btnDone, $GUI_HIDE)
	  EndIf
   EndIf
EndFunc

; Gets the text string to show for the controller button
; @param btn - the controller button id (see MeltyContants)
; @return the label text to use
Func getMeltyButtonText($btn)
   if $btn < 0 Then Return ""
   return $BUTTON_LABELS[$btn]
EndFunc

Func ToggleHiddenStages()
   If $FEATURE_HIDDEN_STAGES Then
	  If $hiddenStages == 1 Then
		 $hiddenStages = 0
		 GUICtrlSetData($btnHiddenStages, "Hidden Stages: OFF")
	  Else
		 $hiddenStages = 1
		 GUICtrlSetData($btnHiddenStages, "Hidden Stages: ON")
	  EndIf
	  UpdateDoneStatus()
	  LauncherConfig_Save()
   EndIf
EndFunc

Func ToggleKeyboard()
   If $noKeyboard == 1 Then
	  $noKeyboard = 0
	  GUICtrlSetData($btnKeyboard, "Keyboard: ON")
   Else
	  $noKeyboard = 1
	  GUICtrlSetData($btnKeyboard, "Keyboard: OFF")
   EndIf
   UpdateDoneStatus()
   LauncherConfig_Save()
EndFunc

Func ToggleAppLocale()
   If FileExists($appLocExe) Then
	  $appLocExe = ""
	  GUICtrlSetData($btnAppLocale, "AppLocale: OFF")
	  LauncherConfig_Save()
   Else
	  MsgBox(64, "", "Please locate the AppLoc.exe file.")
	  $appLocExe = FileOpenDialog("Select AppLoc.exe file", "", "Application (*.exe)", $FD_FILEMUSTEXIST)
	  If @error Or Not FileExists($appLocExe) Then
		 $appLocExe = ""
	  Else
		 GUICtrlSetData($btnAppLocale, "AppLocale: ON")
		 LauncherConfig_Save()
	  EndIf

	  FileChangeDir(@ScriptDir & "\") ; Reset working dir
   EndIf
EndFunc

Func Complete()
   If WinActive($hwnd) Then
	  UpdateDoneStatus(True)
   Else
	  HotKeySet("{SPACE}")
	  Send("{SPACE}")
	  HotKeySet("{SPACE}", "Complete")
   EndIf
EndFunc

Func ActivateNoSend($title, $loop, $delay, $pid)
   For $i = 0 to $loop
	  ; If the process is closed, abort
	  If $pid AND (ProcessExists($pid) == 0) Then Return False
	  ; Give the program focus and press enter
	  Local $hWindow = WinActivate($title)
	  If $hWindow Then
		 Return $hWindow
	  Else
		 Sleep($delay)
	  EndIf
   Next
   Return 0
EndFunc

; Activate/Focus the Windows process that maches the provided title and then sends a keypress
; @param title - the window title
; @param loop - number of loops to check for the title
; @param delay - the delay to wait between loops
; @param send - the key events to send when the window is found
; @param pid - (optional) if set and the process ID does not exist, this loop will exit
; @return the window handle if the window was found
Func ActivateAndSend($title, $loop, $delay, $send, $pid)
   For $i = 0 to $loop
	  ; If the process is closed, abort
	  If $pid AND (ProcessExists($pid) == 0) Then Return False
	  ; Give the program focus and press enter
	  Local $hWindow = WinActivate($title)
	  If $hWindow Then
		 Send($send)
		 Return $hWindow
	  Else
		 Sleep($delay)
	  EndIf
   Next
   Return 0
EndFunc

; General method to run MBAA and wraps it with AppLocale if provided.
; This function blocks until MBAA closes.
; @return If MBAA was successfully launched, the method blocks until
;         closed, and then returns False. Returns False if there was
;         some issue running the game.
Func RunMelty()
   If FileExists($appLocExe) Then
	  Return RunWithAppLocale()
   Else
	  Return RunDirect()
   EndIf
EndFunc

; No longer used
Func RunMeltyOld()

   Local $proc = 0

   If FileExists($appLocExe) Then
	  ; Run App Locale
	  $appLocaleProc = Run('"' & $appLocExe & '" "' & $mbaaccExe & '" "/L0411"')
	  If $appLocaleProc == 0 Then Return False
	  ; Wait for app locale popup (if there is one)
	  ActivateAndSend("Microsoft AppLocale", 200, 10, "{ENTER}", $appLocaleProc)
	  ; wait for app locale to close
	  ProcessWaitClose($appLocaleProc)
   Else
	  $proc = Run($mbaaccExe , $mbaaccDir)
	  If $proc == 0 Then Return False
   EndIf

   Local $hMeltyBlood = ActivateAndSend("MELTY BLOOD", 1000, 10, "{ENTER}", $proc)
   If $proc <= 0 Then
	  $proc = WinGetProcess($hMeltyBlood)
   EndIf

   Hide()

   Local $procWait = WaitForClose($proc)
   $complete = 0; reset flag after game close

   Show()
   If $procWait Then Return True
   Return False
EndFunc

; If using AppLocale, we need to call the AppLocale executable and pass it
; MBAA.exe path and ja_JP locale. This is slightly different than RunDirect()
; because we cannot use RunWait(..) since we do not directly open MBAA.exe and
; therefore we need to do a looping wait until the process ends
Func RunWithAppLocale()
   Local $appLocaleProc = Run('"' & $appLocExe & '" "' & $mbaaccExe & '" "/L0411"')
   If $appLocaleProc == 0 Then Return False
   ; Wait for app locale popup (if there is one)
   ActivateAndSend("Microsoft AppLocale", 200, 10, "{ENTER}", $appLocaleProc)
   ; wait for app locale to close
   ProcessWaitClose($appLocaleProc)
   Local $proc = AutoCloseMeltyConfig()
   $proc = WaitForClose($proc)
   If $proc Then Return True
   Return False
EndFunc

; Preferred and most optimized way to run MBAA
; Directly opens MBAA.exe and does a more efficient wait operation for it to close
Func RunDirect()
   Run('"' & @ScriptFullPath & '" "1"', @ScriptDir)
   RunWait($mbaaccExe , $mbaaccDir)
   If @error Then
	  ConsoleWrite("Failed running MBAA.exe" & @CRLF)
	  Return False
   EndIf
   Return True
EndFunc

; My own version of ProcessWaitClose since that seemed to be consuming
; more resources than it should on Win8
Func WaitForClose($proc)
   If ProcessExists($proc) Then
	  While ProcessExists($proc)
		 Sleep(2000)
	  WEnd
	  Return $proc
   Else
	  Return 0
   EndIf
EndFunc

Func CheckProperties()

   Local $dirty = False

   While Not FileExists($mbaaccExe)
	  $dirty = True
	  MsgBox(64, "", "Please locate the MBAA.exe file.")
	  $mbaaccExe = FileOpenDialog("Select MBAA.exe file", "", "Application (*.exe)", $FD_FILEMUSTEXIST)
	  If @error Then
		 Exit
	  EndIf
	  FileChangeDir(@ScriptDir & "\")
   WEnd

   $mbaaccDir = StringRegExpReplace($mbaaccExe, "\\[^\\]*?\.exe", "\\")
   $iniPath = $mbaaccDir & "System\_KeyConfig.ini"
   ConsoleWrite("[mbaaccDir=" & $mbaaccDir & "]" & @CRLF)
   ConsoleWrite("[iniPath=" & $iniPath & "]" & @CRLF)

   If Not FileExists($appLocExe) Then
	  $appLocExe = ""
   EndIf

   If $dirty Then
	  LauncherConfig_Save()
   EndIf
EndFunc

; Ensure settings are good
CheckProperties()

; Start up the GUI
Init()

; Start the main loop for the GUI
; Note: When MBAA.exe is launched, the main loop gets paused/blocked when it calls RunMelty()
while 1

   ; If ESC is pressed, exit the app
   Local $msg = GUIGetMSG()
   Switch ($msg)
	  Case $GUI_EVENT_CLOSE, $btnExit
		 ExitLoop
	  Case $btnKeyboard
		 ToggleKeyboard()
	  Case $btnAppLocale
		 ToggleAppLocale()
	  Case $btnHiddenStages
		 ToggleHiddenStages()
	  Case $btnDone
		 Complete()
   EndSwitch

   For $p = 0 to $NUM_PLAYERS - 1
	  If $msg == $btnPlayerController[$p] Then
		 ResetPlayer($p)
	  EndIf
   Next

   ; Check what sticks are connected
   DIScanSticks()

   ; If a stick was unplugged that was bound to a player, reset that player
   For $p = 0 to $NUM_PLAYERS - 1
	 If $playerStick[$p] AND DIIndex($playerStick[$p]) < 0 Then
		ResetPlayer($p)
	 EndIf
   Next

   ; If space button was pressed and all buttons are bound, we're ready to startup MBAA
   If ($complete > 0) Then
	  ; Make sure we stop reading DirectInput on the sticks
	  DIUnaquire()
	  ; Write the button config file
	  LauncherPlayerConfig_Save($iniPath)
	  ; Hide the GUI until MBAA is closed
	  Hide()
	  ; Launch MBAA (blocks until MBAA process is closed)
	  If RunMelty() Then
		 ;reset flag
		 $complete = 0
		 Show()
		 ContinueLoop
	  Else
		 ConsoleWrite("Something went wrong running MBAA, just close MeltyLauncher" & @CRLF)
		 Exit
	  EndIf
   EndIf

   ; Check if each player is pressing a button, and bind it
   For $p = 0 To $NUM_PLAYERS - 1
	  If $playerStick[$p] Then
		 updatePlayer($p)
	  EndIf
   Next

   ; If a player is not bound to a stick yet, check if they press a button
   For $p = 0 To $NUM_PLAYERS - 1
	  If NOT $playerStick[$p] Then
		 bindPlayer($p)
		 ExitLoop
	  EndIf
   Next

   ; Want to do the shortest sleep allowed just so we can have responsive GUI for when buttons are clicked
   Sleep(1)
WEnd

