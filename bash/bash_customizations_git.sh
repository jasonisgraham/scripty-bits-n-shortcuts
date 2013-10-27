#!/bin/bash

function do-git {
    local GIT_BIN=git

    local dir='.'
    if [[ "$1" ]]; then
	dir=$1
    fi
    local _type
    read -n 1 -s _type

    local CMD=
    case $_type in
        "d" ) CMD="diff" ;;
        "c" ) CMD="commit" ;;
        "<" )
            CMD="pull origin master"
            dir=''
            ;;
        ">" )
            CMD="push origin master"
            dir=''
            ;;
        "s" ) CMD="status" ;;
        "h" )
            do-git-usage
            return 0
            ;;
        *)  do-git s
            return 0
            ;;
    esac

    
    ${GIT_BIN} $CMD $dir
}

function do-git-usage {
    echo "d           git diff"
    echo "c           git commit"
    echo "<           git pull origin master"
    echo ">           git push origin master"
    echo "s           git status"
    echo "h           help"
    echo "*           git status"
}

bind '"\eG"':"\"\C-udo-git\C-m\""       # start do-git
