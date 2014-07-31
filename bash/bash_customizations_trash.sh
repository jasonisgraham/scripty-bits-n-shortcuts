#!/bin/bash

# source this file if you'd like to type "trash" to move a list of files to the Trashcan
export PATH_TO_TRASH=~/.local/share/Trash/files

function trash {
    local list_verbose=
    OPTIND=1

    while getopts ":v" arg; do
	case $arg in
	    v) list_verbose=1 ;;
            *) echo "unknown argument: '$arg'.  Exiting" >&2; return 1;;
        esac
    done

    shift $((OPTIND-1))

    local cmd="mv "
    if [ "$list_verbose" ]; then
	cmd="$cmd -v"
    fi

    if [[ ! "$@" ]]; then
	echo "no files to move. Exiting" >&2
        return 1
    fi

    cmd="$cmd $@ $PATH_TO_TRASH"
    echo $cmd
    $cmd
}
