#!/bin/bash


# keycode 105 (keysym 0xffe5, Caps_Lock)
# keycode 107 (keysym 0xff61, Print)
# keycode 108 (keysym 0xffe4, Control_R)
# keycode 10 (keysym 0x21, exclam)
# keycode 10 (keysym 0x31, 1)
# keycode 127 (keysym 0xff13, Pause)
# keycode 135 (keysym 0xff67, Menu)
# keycode 148 (keysym 0x1008ff1d, XF86Calculator)
# keycode 166 (keysym 0x1008ff26, XF86Back)
# keycode 167 (keysym 0x1008ff27, XF86Forward)
# keycode 172 (keysym 0x1008ff14, XF86AudioPlay)
# keycode 180 (keysym 0x1008ff18, XF86HomePage)
# keycode 192 (keysym 0x1008ff45, XF86Launch5)
# keycode 193 (keysym 0x1008ff46, XF86Launch6)
# keycode 194 (keysym 0x1008ff47, XF86Launch7)
# keycode 195 (keysym 0x1008ff48, XF86Launch8)
# keycode 196 (keysym 0x1008ff49, XF86Launch9)
# keycode 225 (keysym 0x1008ff1b, XF86Search)
# keycode 36 (keysym 0xff0d, Return)
# keycode 37 (keysym 0xffe3, Control_L)
# keycode 50 (keysym 0xffe1, Shift_L)
# keycode 64 (keysym 0xffe9, Alt_L)
# keycode 66 (keysym 0xffed, Hyper_L)
# keycode 78 (keysym 0xff14, Scroll_Lock)
# keycode 9 (keysym 0xff1b, Escape)

# swap " and ' characters
# xmodmap -e "keycode 48 = quotedbl apostrophe"
# xmodmap -e "keycode 48 = apostrophe quotedbl"
# xmodmap -e "keycode 173 = Katakana XF86AudioPrev"
# xmodmap -e "keycode 66 = Control_L Escape"
# xmodmap -e "keycode 148 = Caps_Lock XF86Calculator"

# xmodmap -e "remove Mod4 = Hyper_L" -e "add Mod3 = Hyper_L"
# xmodmap -e "keysym Caps_Lock = Hyper_L"
# xmodmap -e "remove lock = Caps_Lock"
# xmodmap -e "remove Mod4 = Hyper_L"
# xmodmap -e "add Mod3 = Hyper_L"
# xmodmap -e "keysym Caps_Lock = Hyper_L"

# only display minimal xev information (keypress and keycodes)
function xev-minimal {
    xev -event keyboard | grep --color -oP 'keycode.*\)'
}
