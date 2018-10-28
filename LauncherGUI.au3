#include-once

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Viskar

 Script Function:
	Launcher GUI helpers

#ce ----------------------------------------------------------------------------

#include "Include/DPI.au3"
#include <ColorConstants.au3>
#include <GuiButton.au3>
#include <GuiImageList.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>

; General / GUI Constants
Global Const $FONT = "Arial"
Global Const $FONT_SIZE = FScale(15)
Global Const $FONT_QUALITY = 5
Global Const $FONT_WEIGHT = 850
Global Const $FONT_STYLE = 2
Global Const $FONT_COLOR = 0xF0F0F0

; Show the GUI
Func Show()
   GUISetState(@SW_SHOW)
EndFunc

; Hide the GUI
Func Hide()
   GUISetState(@SW_HIDE)
EndFunc

; Makes a white label
Func LauncherLabelCreate($text, $left, $top, $w, $h, $fSize = -1, $fAttribute = -1, $fWeight = -1)
   If $fSize < 0 Then $fSize = $FONT_SIZE
   If $fAttribute < 0 Then $fAttribute = $FONT_STYLE
   If $fWeight < 0 Then $fWeight = $FONT_WEIGHT
   return LabelStyleWhite($text, $left, $top, $w, $h, $fSize, $fAttribute, $fWeight)
EndFunc

; Sets the text of a label
Func LauncherLabelSetData($label, $data)
   GUICtrlSetData($label, $data)
EndFunc

; Puts a highlight on that label cell. This is used to highlight the current button to bind
Func LauncherLabelHighlight($array)
   GUICtrlSetBkColor($array, 0x666666)
EndFunc

; Creates a white text label with a transparent background, and with the following parameters:
; @param text - default text for the label
; @param left - left position of the label
; @param right - right position of the label
; @param top - top position of the label
; @param w - width of the label
; @param h - height of the label
; @param fSize - font size
; @param fWeight - font weight (thickness)
Func LabelStyleWhite($text, $left, $top, $w, $h, $fSize, $fAttribute, $fWeight)
   Local $label = GUICtrlCreateLabel($text, $left + 2, $top, $w, $h)
   GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
   GUICtrlSetColor(-1, $FONT_COLOR)
   GUICtrlSetFont(-1, $fSize, $fWeight, $fAttribute, $font, $FONT_QUALITY)
   return $label
EndFunc

; Creates a black text label with a transparent background, and with the following parameters:
; @param text - default text for the label
; @param left - left position of the label
; @param right - right position of the label
; @param top - top position of the label
; @param w - width of the label
; @param h - height of the label
; @param fSize - font size
; @param fWeight - font weight (thickness)
Func LabelStyleBlack($text, $left, $top, $w, $h, $fSize, $fAttribute, $fWeight)
   Local $label = GUICtrlCreateLabel($text, $left + 2, $top, $w, $h)
   GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
   GUICtrlSetColor(-1, $COLOR_BLACK)
   GUICtrlSetFont(-1, $fSize, $fWeight, $fAttribute, $font, $FONT_QUALITY)
   return $label
EndFunc

Local $lowerRightButtonOffset = 0

Func AddLowerRightButton($text, $windowWidth, $windowHeight, $buttonWidth)
   $lowerRightButtonOffset = $lowerRightButtonOffset + $buttonWidth
   Local $newBtn = GUICtrlCreateButton($text, $windowWidth - $lowerRightButtonOffset, $windowHeight - 24, $buttonWidth, 22, $WS_CLIPSIBLINGS)
   GUICtrlSetCursor($newBtn, 0)
   GUICtrlSetBkColor($newBtn, $BTN_BG_COLOR)
   GUICtrlSetColor($newBtn, $FONT_COLOR)
   GUICtrlSetFont($newBtn, FScale(8.5))
   return $newBtn
EndFunc