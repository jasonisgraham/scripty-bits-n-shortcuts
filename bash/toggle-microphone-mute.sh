#!/bin/bash

function toggle-microphone-mute {
    msg=
    if [ "$(amixer set Capture toggle | grep '\[on\]')" ]; then
        msg="microphone is HOT"
    else
        msg="microphone is OFF"
    fi
    notify-send "$msg"
}

toggle-microphone-mute
