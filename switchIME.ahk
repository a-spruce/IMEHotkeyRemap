#Requires AutoHotkey v2.0
; Persistent

; 设置窗口标题匹配模式，2为默认模式
; SetTitleMatchMode 2

; 设置脚本是否可以 "看见" 隐藏的窗口
DetectHiddenWindows True

/*
windows自带输入法的id,可以通过调用windows api GetKeyboardLayout来获取
微软拼音输入法 134481924
微软日文输入法 68224017
微软英文输入法 67699721
*/
IMEmap := Map(
    "zh", 134481924,
    "jp", 68224017,
    "en", 67699721
)

; 下面的代码没有起到作用，所以注释掉了
; 改为用CapsLock映射中的try-catch
; ; ^Esc 开始菜单弹窗等情况会找不到当前窗口
; hasIME(WinTitle := "A") {
;     try {
;         hWnd := WinGetID(WinTitle)
;         return 1
;     } catch Error {
;         return 0
;     }
; }

; 获取当前激活窗口所使用的IME的ID
getCurrentIMEID() {
    winID := winGetID("A")
    ThreadID := DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
    InputLocaleID := DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")
    return InputLocaleID
}

; 使用IMEID激活对应的输入法
switchIMEbyID(IMEID) {
    winTitle := WinGetTitle("A")
    PostMessage(0x50, 0, IMEID, , WinTitle)
}

; 用于判断微软拼音是否是英文模式
cnIsEnglishMode() {
    hwnd := WinExist("A")
    if (WinActive("A")) {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        cbSize := 4 + 4 + (PtrSize * 6) + 16	; DWORD*2+HWND*6+RECT
        stGTI := Buffer(cbSize, 0)
        NumPut("UInt", cbSize, stGTI.Ptr, 0)   ;   DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", "Uint", 0, "Uint", stGTI.Ptr)
            ? NumGet(stGTI.Ptr, 8 + PtrSize, "Uint") : hwnd
    }
    convMode := DllCall("SendMessage"
        , "Uint", DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hwnd)
        , "Uint", 0x0283  ;Message : WM_IME_CONTROL
        , "Int", 0x001   ;wParam  : IMC_GETCONVERSIONMODE
        , "Int", 0)      ;lParam  : 0
    return !convMode
}

;-------------------------------------------------------
; IME 入力モードセット
;   ConvMode        入力モード
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;--------------------------------------------------------
IME_SetConvMode(ConvMode) {
    hwnd := WinExist("A")
    if (WinActive("A")) {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        cbSize := 4 + 4 + (PtrSize * 6) + 16
        stGTI := Buffer(cbSize, 0)
        NumPut("Uint", cbSize, stGTI.Ptr, 0)   ;   DWORD   cbSize;
        hwnd := DllCall("GetGUIThreadInfo", "Uint", 0, "Ptr", stGTI.Ptr)
            ? NumGet(stGTI.Ptr, 8 + PtrSize, "Uint") : hwnd
    }
    return DllCall("SendMessage"
        , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hwnd)
        , "UInt", 0x0283      ;Message : WM_IME_CONTROL
        , "Int", 0x002       ;wParam  : IMC_SETCONVERSIONMODE
        , "Int", ConvMode)   ;lParam  : CONVERSIONMODE
}

; 切换CapsLock模式
ToggleCapsLock() {
    if (GetKeyState("CapsLock", "T")) {
        SetCapsLockState('Off')
    } else {
        SetCapsLockState('On')
    }
}

CapsLock::
{
    if (KeyWait("CapsLock", "T0.5")) { ; 等待 CapsLock键抬起，最长等待0.5秒
        ; 短按时切换到对应输入法的非英文模式
        if (getCurrentIMEID() == IMEmap["zh"]) {
            try {
                switchIMEbyID(IMEmap["jp"])
                Sleep(100) ; 不设置延时的话按键不起效
                Send "{LCtrl down}{CapsLock down}{CapsLock up}{LCtrl up}" ; 切到平假名输入
            } catch Error {
                ; Send "{Alt down}{LShift down}{LShift up}{Alt up}" ; API不行就通过快捷键切换，日语模式在开始菜单下这组快捷键不好用
                Send "{LWin down}{Space down}{Space Up}{Space down}{Space Up}{LWin up}" ; API不行就通过快捷键切换
                Sleep(100) ; 不设置延时的话按键不起效
                Send "{LCtrl down}{CapsLock down}{CapsLock up}{LCtrl up}" ; 切到平假名输入
            }
        }
        else if (getCurrentIMEID() == IMEmap["jp"]) {
            try {
                switchIMEbyID(IMEmap["zh"])
                Sleep(100) ; 不设置延时的话按键不起效
                if (cnIsEnglishMode()) {
                    Send "{LShift}" ; 切到中文输入
                }
            } catch Error {
                ; Send "{Alt down}{LShift down}{LShift up}{Alt up}" ; API不行就通过快捷键切换，日语模式在开始菜单下这组快捷键不好用
                Send "{LWin down}{Space down}{Space Up}{Space down}{Space Up}{LWin up}" ; 
                Sleep(100) ; 不设置延时的话按键不起效
                if (cnIsEnglishMode()) {
                    Send "{LShift}" ; 切到中文输入
                }
            }
        }
    } else {
        ; 长按时切换到大写
        ToggleCapsLock()
        KeyWait("CapsLock") ; 等待CapsLock抬起
    }
}

~LShift::
{
    if (KeyWait("LShift", "T0.12") && getCurrentIMEID() == IMEmap["jp"]) {
        Send "{vkF3sc029}"
    }
    ; 其它情况就是默认，不需要写
}
