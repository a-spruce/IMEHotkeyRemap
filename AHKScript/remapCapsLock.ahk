#Requires AutoHotkey v2.0
; Persistent
; SetTitleMatchMode 2

global cnFlag := true ; true - cn, false - jp

CapsLock::
{
    if (KeyWait("CapsLock", "T0.3")) { ; 等待 CapsLock键抬起，最长等待0.3秒
        ; 短按时切换输入法
        SwitchInputMethod()
    } else {
        ; 长按时切换到大写
        ToggleCapsLock()
        KeyWait("CapsLock") ; 等待CapsLock抬起
    }
}

SwitchInputMethod() {
    global cnFlag
    if(cnFlag) { ; 当前为cn？
        Send "{Alt down}{Shift down}{9 down}{9 up}{Shift up}{Alt up}"
        cnFlag := false
    } else {
        Send "{Alt down}{Shift down}{0 down}{0 up}{Shift up}{Alt up}"
        cnFlag := true
    }
}

ToggleCapsLock(){
    if(GetKeyState("CapsLock", "T")){
        SetCapsLockState('Off')
    } else {
        SetCapsLockState('On')
    }
}

~LShift:: ; ~保留了按键的原始功能
{
    global cnFlag
    if(KeyWait("LShift", "T0.12") && !cnFlag) {
        Send "{vkF3sc029}"
    }
    ; 其它情况就是正常，所以不需要写
}