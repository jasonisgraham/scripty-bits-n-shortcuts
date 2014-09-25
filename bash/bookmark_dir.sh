#!/bin/bash

usage()
{
    cat <<EOF
    usage: $0 options

    OPTIONS:
    [help] "bookmark-dir help"
	Display usage/help

    [list] "bookmark-dir-list"
	Lists all bookmarks.  TODO: Double-tab after bookmark-dir-cd or bookmark-dir-add to do the same thing

    [cd] "bookmark-dir-cd [$idx]"
	cds to the directory found at $idx.  If $idx is omitted, cds to $_BOOKMARK_MAP_DEFAULT_KEY

    [add] "bookmark-dir-add [$idx]"
	add $PWD to $_BOOKMARK_MAP[$idx]. if $idx is omitted, uses $_BOOKMARK_MAP_DEFAULT_KEY

    TODO:
    [clear-all] "bookmark-dir-clear"
	clears everything from $_BOOKMARK_MAP

EOF
}

declare -A _BOOKMARK_MAP
_BOOKMARK_MAP_DEFAULT_KEY=0

function __bookmark-dir_print_bookmark-map {
    for key in "${!_BOOKMARK_MAP[@]}"; do
        echo -e "$key\t${_BOOKMARK_MAP["$key"]}"
    done
}

function __bookmark-dir {
    local _1stArg=$1

    case "$_1stArg" in
	'list')
     	    __bookmark-dir_print_bookmark-map
            ;;
        'cd')
            local _dest_dir_key=$_BOOKMARK_MAP_DEFAULT_KEY

            if [[ ${2-} ]]; then
                _dest_dir_key="$2"
            fi

            cd ${_BOOKMARK_MAP[$_dest_dir_key]}
            ;;
        'add')
            local _id=$_BOOKMARK_MAP_DEFAULT_KEY

            if [[ ${2-} ]]; then
                _id="$2"
            fi

            _BOOKMARK_MAP[$_id]=$PWD
            __bookmark-dir-refresh-autocomplete
            ;;

	'help'|*)
            usage
	    return
            ;;
    esac
}

function __bookmark-dir-refresh-autocomplete {
    local _complete_string=""
    for k in ${!_BOOKMARK_MAP[@]}; do
        _complete_string="$_complete_string $k"
    done
    complete -W "$_complete_string" bookmark-dir-cd
}

function bookmark-dir {
    __bookmark-dir 'add'
}

function bookmark-dir-list {
    __bookmark-dir 'list'
}

function bookmark-dir-add {
    __bookmark-dir 'add' $1
}

function bookmark-dir-cd {
    __bookmark-dir 'cd' $1
}

__bookmark-dir-refresh-autocomplete
