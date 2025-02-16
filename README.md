# 中英日输入法快捷键重映射 IMEHotkeyRemap (Win & Mac)

## 背景
Windows和Mac上的中英日输入法切换用起来不太顺手，于是用AHK和Karabiner写了点小脚本，对切换输入法的热键进行了重映射

## 新热键
定义了两个输入模式：中文和日文，通过CapsLock来在两模式中切换，通过左边的Shift键切换成英文

需要注意：在中文模式下，不管当前是英文还是中文输入，按Capslock都会切到日文平假名输入，反之亦然。（在我眼里这解决了Windows上很恼人的问题）

切换逻辑示意图：
```text
                                        |--------English
                                        |
                                      Shift
                                        |
                |-----------------------|--------Chinese (Default)
                |
            CapsLock
                |
                |-----------------------|--------Japanese (Default)
                                        |
                                      Shift
                                        |
                                        |--------English
```

## 文件结构
`AHKScript`路径下包含了Windows环境下的脚本
- `switchIME.ahk`安装[AHK v2](https://www.autohotkey.com/download/)后双击启动即可。
- `switchIMEAuto.ahk`加入了根据当前应用程序自动切换输入法的功能（如在终端默认切成英语），保持上次使用的输入法更符合我个人的使用习惯，所以主要使用的是它。

`Karabiner`路径下包含了Mac环境下的脚本
建设中

## 注意事项
### Windows
- 实测支持以下输入法
    - 微软中文输入法
    - 微软日语输入法
    - 搜狗中文输入法
    - 谷歌日语输入法
- 系统中最好只保留两个使用的输入法（如搜狗和微软日语）以保证最佳体验
- 建议在系统设置中开启“允许我为每个应用窗口使用不同的输入法”
    - 该设置位置在“打开系统设置 → 时间和语言 → 输入 → 高级键盘设置”中
- 设置开机自启动：在资源管理器中输入`shell:startup`并回车，将脚本本身或脚本的快捷方式放进去即可

### Mac
建设中

## Background
Being tried of switching IMEs (EN-JP-ZH) with original hotkeys on both Windows and Mac, I wrote some scripts to remap them in AHK and Karabiner.

## New hotkeys for IME switching
The remapped hotkey is intuitive for me: there are two input modes, ZH and JP, press CapsLock to toggle between the two modes, press LShift to toggle between ZH/JP and English.

**Whenever** you press CapsLock in ZH mode, it will switch to the Hiragana mode of JP, vice versa. (which I think solved an annoying problem on Windows.)

The logic of switching is show as bellow:

```text
                                        |--------English
                                        |
                                      Shift
                                        |
                |-----------------------|--------Chinese (Default)
                |
            CapsLock
                |
                |-----------------------|--------Japanese (Default)
                                        |
                                      Shift
                                        |
                                        |--------English
```

## File structure

`AHKScript` inclues all Windows scripts
- `switchIME.ahk` after installing [AHK v2](https://www.autohotkey.com/download/), double click the script to run it.
- `switchIMEAuto.ahk` can automatically switch IMEs base on the title of your active window, I made the default IME English for Windows Terminal. Add more programs to watch by adding `GroupAdd "enAppGroup", "ahk_exe [Program exe Name]"` before the loop segment.

`Karabiner` includs all Mac scripts
Under construction

## Specs and Comments
### Windows
- Support the following IMEs
    - Microsoft Simplified Chinese IME
    - Microsoft Japanese IME
    - Sougou Simplified Chinese IME
    - Google Japanese Input
- You would have better experience if you delete all unused IMEs in your OS and keep only one for Chinese, one for Japanese.
- I'd love to turn on "Let me set a different input method for each app window", but it is not mandatory.
- How to make the script start automatically：type `shell:startup` in the path of explorer and press Enter, put the script or its shortcut there.

### Mac
Under construction

Hope it helps.
