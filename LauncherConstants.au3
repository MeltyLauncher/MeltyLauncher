#include-once

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Viskar

 Script Function:
	Melty & DirectInput related constants

#ce -------------------

#include <WinApi.au3>

; MBAA button IDs used in their .ini file
Global Const $BTN_NONE = 0
Global Const $BTN_1 = 1
Global Const $BTN_2 = 2
Global Const $BTN_3 = 3
Global Const $BTN_4 = 4
Global Const $BTN_5 = 5
Global Const $BTN_6 = 6
Global Const $BTN_7 = 7
Global Const $BTN_8 = 8
Global Const $BTN_9 = 9
Global Const $BTN_10 = 10
Global Const $BTN_11 = 11
Global Const $BTN_12 = 12
Global Const $BTN_13 = 13
Global Const $BTN_14 = 14
Global Const $BTN_15 = 15
Global Const $BTN_16 = 16
Global Const $POV_UP = 17
Global Const $POV_DOWN = 18
Global Const $POV_LEFT = 19
Global Const $POV_RIGHT = 20
Global Const $X_PLUS = 21
Global Const $X_MINUS = 22
Global Const $Y_PLUS = 23
Global Const $Y_MINUS = 24
Global Const $Z_PLUS = 25
Global Const $Z_MINUS = 26
Global Const $RX_PLUS = 27
Global Const $RX_MINUS = 28
Global Const $RY_PLUS = 29
Global Const $RY_MINUS = 30
Global Const $RZ_PLUS = 31
Global Const $RZ_MINUS = 32
Global Const $NUM_BUTTONS = 33

; DirectInput constants
Global Const $DISCL_EXCLUSIVE    = 0x00000001
Global Const $DISCL_NONEXCLUSIVE = 0x00000002
Global Const $DISCL_FOREGROUND   = 0x00000004
Global Const $DISCL_BACKGROUND   = 0x00000008
Global Const $DISCL_NOWINKEY     = 0x00000010

Global Const $DIDFT_OPTIONAL    = 0x80000000
Global Const $DIDFT_RELAXIS     = 0x00000001
Global Const $DIDFT_ABSAXIS     = 0x00000002
Global Const $DIDFT_AXIS        = 0x00000003
Global Const $DIDFT_BUTTON      = 0x0000000C
Global Const $DIDFT_POV         = 0x00000010
Global Const $DIDFT_ANYINSTANCE = 0x00FFFF00

Global Const $SIZE_OF_LONG = DllStructGetSize(DllStructCreate("long"))
Global Const $SIZE_OF_DWORD = DllStructGetSize(DllStructCreate("dword"))
Global Const $DIJOFS_X = 0;
Global Const $DIJOFS_Y = $DIJOFS_X + $SIZE_OF_LONG;
Global Const $DIJOFS_Z = $DIJOFS_Y + $SIZE_OF_LONG;
Global Const $DIJOFS_RX = $DIJOFS_Z + $SIZE_OF_LONG;
Global Const $DIJOFS_RY = $DIJOFS_RX + $SIZE_OF_LONG;
Global Const $DIJOFS_RZ = $DIJOFS_RY + $SIZE_OF_LONG;

Global Const $GUID_XAxis  = "{A36D02E0-C9F3-11CF-BFC7-444553540000}"
Global Const $tGUID_XAxis = _WinAPI_GUIDFromString($GUID_XAxis)

Global Const $GUID_YAxis  = "{A36D02E1-C9F3-11CF-BFC7-444553540000}"
Global Const $tGUID_YAxis = _WinAPI_GUIDFromString($GUID_YAxis)

Global Const $GUID_ZAxis  = "{A36D02E2-C9F3-11CF-BFC7-444553540000}"
Global Const $tGUID_ZAxis = _WinAPI_GUIDFromString($GUID_ZAxis)

Global Const $GUID_RxAxis = "{A36D02F4-C9F3-11CF-BFC7-444553540000}"
Global Const $tGUID_RxAxis = _WinAPI_GUIDFromString($GUID_RxAxis)

Global Const $GUID_RyAxis = "{A36D02F5-C9F3-11CF-BFC7-444553540000}"
Global Const $tGUID_RyAxis = _WinAPI_GUIDFromString($GUID_RyAxis)

Global Const $GUID_RzAxis = "{A36D02E3-C9F3-11CF-BFC7-444553540000}"
Global Const $tGUID_RzAxis = _WinAPI_GUIDFromString($GUID_RzAxis)

Global Const $GUID_Slider = "{A36D02E4-C9F3-11CF-BFC7-444553540000}"
Global Const $tGUID_Slider = _WinAPI_GUIDFromString($GUID_Slider)

Global Const $GUID_POV    = "{A36D02F2-C9F3-11CF-BFC7-444553540000}"
Global Const $tGUID_POV = _WinAPI_GUIDFromString($GUID_POV)

Global Const $GUID_BUFFER_SIZE     = "{00000000-0000-0000-0000-000000000001}"

Global Const $DIRECTINPUT_VERSION = 0x0800
Global Const $DIENUM_CONTINUE = 1
Global Const $DI8DEVCLASS_ALL = 0
Global Const $DI8DEVCLASS_GAMECTRL = 4
Global Const $DIEDFL_ATTACHEDONLY = 0x00000001

Global Const $sCLSID_DirectInput = "{25E609E4-B259-11CF-BFC7-444553540000}"
Global Const $sIID_IDirectInput8W = "{BF798031-483A-4DA2-AA99-5D64ED369700}"
Global Const $tagIDirectInput8 = "CreateDevice hresult(clsid;ptr*;ptr);" & _
        "EnumDevices hresult(dword;ptr;ptr;dword);" & _
        "GetDeviceStatus hresult(clsid);" & _
        "RunControlPanel hresult(hwnd;dword);" & _
        "Initialize hresult(handle;dword);" & _
        "FindDevice hresult(clsid;wstr;clsid*);" & _
        "EnumDevicesBySemantics hresult(wstr;ptr;ptr;ptr;dword);" & _
        "ConfigureDevices hresult(ptr;ptr;dword;ptr);"

Global Const $sCLSID_DirectInputDevice = "{25E609E5-B259-11CF-BFC7-444553540000}"
Global Const $sIID_IDirectInputDevice8W = "{54D41081-DC15-4833-A41B-748F73A38179}"
Global Const $tagIDirectInputDevice8 = "GetCapabilities hresult(ptr);" & _
	  "EnumObjects hresult(ptr;ptr;dword);" & _
	  "GetProperty hresult(int;ptr);" & _
	  "SetProperty hresult(int;ptr);" & _
	  "Acquire hresult();" & _
	  "Unacquire hresult();" & _
	  "GetDeviceState hresult(dword;ptr);" & _
	  "GetDeviceData hresult(dword;ptr;ptr;dword);" & _
	  "SetDataFormat hresult(ptr);" & _
	  "SetEventNotification hresult(handle);" & _
	  "SetCooperativeLevel hresult(hwnd;dword);" & _
	  "GetObjectInfo hresult(ptr;dword;dword);" & _
	  "GetDeviceInfo hresult(ptr);" & _
	  "RunControlPanel hresult(hwnd;dword);" & _
	  "Initialize hresult(hwnd;dword;clsid);" & _
	  "CreateEffect hresult(clsid;ptr;ptr*;ptr);" & _
	  "EnumEffects hresult(ptr;ptr;dword);" & _
	  "GetEffectInfo hresult(ptr;clsid);" & _
	  "GetForceFeedbackState hresult(ptr);" & _
	  "SendForceFeedbackCommand hresult(dword);" & _
	  "EnumCreatedEffectObjects hresult(ptr;ptr;dword);" & _
	  "Escape hresult(ptr);" & _
	  "Poll hresult();" & _
	  "SendDeviceData hresult(dword;ptr;ptr;ptr;dword);" & _
	  "EnumEffectsInFile hresult(ptr;ptr;ptr;dword);" & _
	  "WriteEffectToFile hresult(ptr;dword;ptr;dword);" & _
	  "BuildActionMap hresult(ptr;ptr;dword);" & _
	  "SetActionMap hresult(ptr;ptr;dword);" & _
	  "GetImageInfo hresult(ptr);"

Global Const $diJoyState2Struct = _
		 "LONG    lX;" & _ ;                     /* x-axis position              */
		 "LONG    lY;" & _ ;                   /* y-axis position              */
		 "LONG    lZ;" & _  ;                   /* z-axis position              */
    	 "LONG    lRx;" & _  ;                  /* x-axis rotation              */
    	 "LONG    lRy;" & _   ;                 /* y-axis rotation              */
    	 "LONG    lRz;" & _    ;                /* z-axis rotation              */
    	 "LONG    rglSlider[2];" & _ ;          /* extra axes positions         */
    	 "DWORD   rgdwPOV[4];" & _    ;         /* POV directions               */
    	 "BYTE    rgbButtons[128];" & _ ;       /* 128 buttons                  */
    	 "LONG    lVX;" & _              ;      /* x-axis velocity              */
    	 "LONG    lVY;" & _               ;     /* y-axis velocity              */
    	 "LONG    lVZ;" & _              ;      /* z-axis velocity              */
    	 "LONG    lVRx;" & _             ;      /* x-axis angular velocity      */
    	 "LONG    lVRy;" & _             ;      /* y-axis angular velocity      */
    	 "LONG    lVRz;" & _             ;      /* z-axis angular velocity      */
    	 "LONG    rglVSlider[2];" & _    ;      /* extra axes velocities        */
    	 "LONG    lAX;" & _              ;      /* x-axis acceleration          */
    	 "LONG    lAY;" & _              ;      /* y-axis acceleration          */
    	 "LONG    lAZ;" & _              ;      /* z-axis acceleration          */
    	 "LONG    lARx;" & _             ;      /* x-axis angular acceleration  */
    	 "LONG    lARy;" & _             ;      /* y-axis angular acceleration  */
    	 "LONG    lARz;" & _             ;      /* z-axis angular acceleration  */
    	 "LONG    rglASlider[2];" & _    ;      /* extra axes accelerations     */
    	 "LONG    lFX;" & _              ;      /* x-axis force                 */
    	 "LONG    lFY;" & _              ;      /* y-axis force                 */
    	 "LONG    lFZ;" & _              ;      /* z-axis force                 */
    	 "LONG    lFRx;" & _             ;      /* x-axis torque                */
    	 "LONG    lFRy;" & _             ;      /* y-axis torque                */
    	 "LONG    lFRz;" & _             ;      /* z-axis torque                */
    	 "LONG    rglFSlider[2]"

Global Const $diJoyStateStruct = _
		 "LONG    lX;" & _ ;                    /* x-axis position              */
		 "LONG    lY;" & _ ;                    /* y-axis position              */
		 "LONG    lZ;" & _  ;                   /* z-axis position              */
    	 "LONG    lRx;" & _  ;                  /* x-axis rotation              */
    	 "LONG    lRy;" & _   ;                 /* y-axis rotation              */
    	 "LONG    lRz;" & _    ;                /* z-axis rotation              */
    	 "LONG    rglSlider[2];" & _ ;          /* extra axes positions         */
    	 "DWORD   rgdwPOV[4];" & _    ;         /* POV directions               */
    	 "BYTE    rgbButtons[32]"