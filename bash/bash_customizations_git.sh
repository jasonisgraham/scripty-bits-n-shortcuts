#!/bin/bash

#################################################
# Binds "do-git" to Alt+Shift+g then awaits
#  single keystroke for what to do next.
#  See usage what does what
#################################################
bind '"\eG"':"\"\C-udo-git\C-m\""

do-git-usage()
{
    cat <<EOF
    OPTIONS:
    d           git diff
    c           git commit
    <           git pull origin master
    >           git push origin master
    s           git status
    h           help

    REASON FOR EXISTING:
    Useful for someone coming from a subversion background.
    Attempts to hide all the power stuff that git offers when all you wanna do is diff, commit, status, ... etc like one would do when working with SVN
EOF
}

#################################################
# See do-git-usage
#################################################
function do-git {
    local GIT_BIN=$(which git)

    local dir='.'
    if [[ "$1" ]]; then
	      dir=$1
    fi
    local _type
    read -n 1 -s _type

    local CMD=
    case $_type in
        d ) CMD="diff" ;;
        c ) CMD="commit" ;;
        "<" )
            CMD="pull origin master"
            dir=''
            ;;
        ">" )
            CMD="push origin master"
            dir=''
            ;;
        s ) CMD="status" ;;
        h|* )
            do-git-usage
            ;;
    esac
    local git_cmd="$GIT_BIN $CMD $dir"
    echo ""
    echo $git_cmd
    $git_cmd
}

###############################################
# https://gist.github.com/michaelkirk/2596181 #
###############################################
function git-show-remote-branches {
    for k in $(git branch -r | awk '{print $1}'); do
        echo -e $(git show --pretty=format:"%Cgreen%ci %Cblue%cr\\t%Cred%cn %Creset" $k | head -n 1)\\t$k
    done | sort -r
}

function git-show-local-branches {
    for k in $(git branch -a | awk '{print $1}'); do
        echo -e $(git show --pretty=format:"%Cgreen%ci %Cblue%cr\\t %Cred%cn %Creset" $k | head -n 1)\\t$k
    done | sort -r
}
