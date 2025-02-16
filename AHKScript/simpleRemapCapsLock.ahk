#Requires AutoHotkey v2.0
Persistent
SetTitleMatchMode 2

CapsLock::
{
    if (KeyWait("CapsLock", "T0.3")) { ; 等待 CapsLock键抬起，最长等待0.3秒
        ; 短按时切换输入法
        Send "{Alt down}{Shift down}{Shift up}{Alt up}"
    } else {
        ; 长按时切换到大写
        if(GetKeyState("CapsLock", "T")){
            SetCapsLockState('Off')
        } else {
            SetCapsLockState('On')
        }
        KeyWait("CapsLock") ; 等待CapsLock抬起
    }
}
