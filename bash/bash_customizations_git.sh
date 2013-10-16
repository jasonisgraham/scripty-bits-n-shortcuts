#!/bin/bash

function do-git {
    local GIT_BIN=$(which git)

    local dir='.'
    if [[ "$1" ]]; then
	    dir=$1
    fi
    local _type
    read -n 1 -s _type

    case $_type in
        "d" ) CMD="${GIT_BIN} diff" ;;
        "c" ) CMD="${GIT_BIN} commit" ;;
        "<" )
            CMD="${GIT_BIN} pull origin master"
            dir=''
            ;;
        ">" )
            CMD="${GIT_BIN} push origin master"
            dir=''
            ;;
        "s" ) CMD="${GIT_BIN} status" ;;
        "h" )
            do-git-usage
            return 0
            ;;
        *)  do-git s
            return 0
            ;;
    esac

    $CMD $dir
    #local full_command="$CMD $dir"
    #echo $full_command
    #$full_command
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