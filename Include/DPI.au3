#include-once

;; GetDPI.au3
;;
;; Get the current DPI (dots per inch) setting, and the ratio
;; between it and approximately 96 DPI.
;;
;; Author: Phillip123Adams
;; Posted: August, 17, 2005, originally developed 10/17/2004,
;; AutoIT 3.1.1.67 (but earlier v3.1.1 versions with DLLCall should work).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;~   ;; Example
;~  #include<guiconstants.au3>
;~   ;;
;~   ;; Get the current DPI.
;~  $a1 = _GetDPI()
;~  $iDPI = $a1[1]
;~  $iDPIRat = $a1[2]
;~   ;;
;~   ;; Design the GUI to show how to apply the DPI adjustment.
;~  GUICreate("Applying DPI to GUI's", 250 * $iDPIRat, 120 * $iDPIRat)
;~  $lbl = GUICtrlCreateLabel("The current DPI value is " & $iDPI &@lf& "Ratio to 96 is " & $iDPIRat &@lf&@lf& "Call function _GetDPI.  Then multiply all GUI dimensions by the returned value divided by approximately 96.0.", 10 * $iDPIRat, 5 * $iDPIRat, 220 * $iDPIRat, 80 * $iDPIRat)
;~  $btnClose = GUICtrlCreateButton("Close", 105 * $iDPIRat, 90 * $iDPIRat, 40 * $iDPIRat, 20 * $iDPIRat)
;~  GUISetState()
;~   ;;
;~  while 1
;~   $iMsg = GUIGetMsg()
;~   If $iMsg = $GUI_EVENT_CLOSE or $iMsg = $btnClose then ExitLoop
;~  WEnd
;~  Exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




Local $DPI = _getDPI()

;; Scale up
Func Scale($i)
   Return Round(($i * $DPI[1] / 96.0) + 0.4999, 0)
EndFunc

;; Scale down
Func FScale($i)
   Return ($i * 96) / $DPI[1]
EndFunc

Func _GetDPI ()
  ;; Get the current DPI (dots per inch) setting, and the ratio between it and
  ;; approximately 96 DPI.
  ;;
  ;; Retrun a 1D array of dimension 3.  Indices zero is the dimension of the array
  ;; minus one.  Indices 1 = the current DPI (an integer).  Indices 2 is the ratio
  ;; should be applied to all GUI dimensions to make the GUI automatically adjust
  ;; to suit the various DPI settings.
  ;;
  ;; Author: Phillip123Adams
  ;; Posted: August, 17, 2005, originally developed 6/04/2004,
  ;; AutoIT 3.1.1.67 (but earlier v3.1.1 versions with DLLCall should work).
  ;;
  ;; Note: The dll calls are based upon code from the AutoIt3 forum from a post
  ;; by this-is-me on Nov 23 2004, 10:29 AM under topic "@Larry, Help!"  Thanks
  ;; to this-is-me and Larry.  Prior to that, I was obtaining the current DPI
  ;; from the Registry:
  ;;    $iDPI = RegRead("HKCU\Control Panel\Desktop\WindowMetrics", "AppliedDPI")
  ;;
   Local $_a1[3]
   Local $_iDPI
   Local $_iDPIRat
   Local $_Logpixelsy = 90
   Local $_hWnd = 0
   Local $_hDC = DllCall("user32.dll", "long", "GetDC", "long", 0)
   Local $_aRet = DllCall("gdi32.dll", "long", "GetDeviceCaps", "long", $_hDC[0], "long", $_Logpixelsy)
   DllCall("user32.dll", "long", "ReleaseDC", "long", 0, "long", $_hDC)
   $_iDPI = $_aRet[0]
  ;; Set a ratio for the GUI dimensions based upon the current DPI value.
   Select
      Case $_iDPI = 0
         $_iDPI = 96
         $_iDPIRat =  94
      Case $_iDPI < 84
         $_iDPIRat =  $_iDPI / 105
      Case $_iDPI < 121
         $_iDPIRat =  $_iDPI / 96
      Case $_iDPI < 145
         $_iDPIRat =  $_iDPI / 95
      Case Else
         $_iDPIRat =  $_iDPI / 94
   EndSelect
   $_a1[0] = 2
   $_a1[1] = $_iDPI
   $_a1[2] = $_iDPIRat
  ;; Return the array
   Return $_a1
EndFunc