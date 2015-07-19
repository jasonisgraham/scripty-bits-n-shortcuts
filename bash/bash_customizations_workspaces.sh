#!/bin/bash

## this is here b/c easyguesture farts up when i try to make "next workspace" to M-H-l

function switch-workspace {
    # set -x
    local op="$1"
    local max_workspace_idx=$(wmctrl -d | awk '{print $1}' | sort -r | head -1)
    let max="$max_workspace_idx + 1"
    let active_workspace=$(wmctrl -d | awk '$2 == "*" {print $1}')
    let new_idx="$active_workspace $op 1"
    let wrapped_idx="($max + $new_idx % $max) % $max"
    wmctrl -s $wrapped_idx
    # set +x
}

case "$1" in
    switch-next) switch-workspace + ;;
    switch-prev) switch-workspace - ;;
    * ) echo "error" ;;
esac
