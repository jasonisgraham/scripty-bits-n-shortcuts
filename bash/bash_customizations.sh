#!/bin/bash

# BASH_FILES_DIR will be equal to the dir holding this file
BASH_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# I do not need to be bothered with the shift key
set completion-ignore-case on

# xports
export IGNOREEOF=1
export PS1="\u \w> "
export EDITOR='emacs -nw'

# binds
bind 'set completion-ignore-case on'
bind '"\eS"':"\"source ~/.bashrc\C-m\"" # alt-S loads source
bind '"\ej"':"\"\eb\"";                 # alt-j moves cursor back word
bind '"\ek"':"\"\ef\""                  # alt-k moves cursor forward word
bind '"\eJ"':"\"\C-w\"";                # alt-J cuts word behind cursor
bind '"\eK"':"\"\ed\""                  # alt-K cuts word in front of cursor
bind '"\e<"':"\"\C-u__move-up-directory\C-m\""       # alt-U Move up the directory. same as cd ../
bind '"\e>"':"\"\C-u__move-down-directory\C-m\""       # alt-f Move down the directory.
bind '"\eL"':"\"\C-u__ls-type\C-m\""      # alt-L same as ls
bind '"\ew"':kill-region

# grep -opts $search . searches recursively from PWD whatever string is on the prompt.  So, /some/dir> jason, then the binding, will execute "grep -rn jason ."  Doesnt work if you use single quotes
bind '"\eXf"':"\"\C-a__find-in-files \C-e . rn \C-j\""      # case sensitive
bind '"\eXi"':"\"\C-a__find-in-files \C-e . rni \C-j\""     # case insensitive
bind '"\eXr"':"\"\C-a__find-in-files \C-e . rniP \C-j\""    # case insensitive, Uses Perl regex.  Encase this with some quotes

# aliases
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'
alias lah='ls -lAh'
alias emacs='emacs -nw'
alias irb='irb --simple-prompt'
alias lah='ls -lAh'
alias rm='rm -i'
alias df='df -h'
alias du='du -sh'
alias h='history | tail'

# sources
if [ -a $BASH_FILES_DIR/bash_customizations_git.sh ]; then
    source $BASH_FILES_DIR/bash_customizations_git.sh
fi

# THUMB BALL MOUSE ES 2 FASTO! SLOW IT DOWN
logitech=$(xinput --list --short | grep -m1 "Logitech" | cut -f2 | cut -d= -f2) # mouse ID
xinput --set-prop "$logitech" "Device Accel Constant Deceleration" 2 # It defaults to 1

##################################
#HISTORY_CUSTOMIZATIONS
##################################
HISTCONTROL=ignoredups:ignorespace # don't put duplicate lines in the history.
shopt -s histappend # append to the history file, don't overwrite it
HISTSIZE=1000 # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=2000

####################################################################
# "useful" functions that are called with the binds from above
# consider these private
####################################################################
function __move-up-directory {
    pushd . >> /dev/null
    cd ../
}

function __move-down-directory {
    popd >> /dev/null
}

function __ls-type {
    local _type
    read -n 1 -s _type
    ls_cmd='ls -glhBAF --ignore=#* --ignore=.git --color=always'
    case $_type in
        "h" )
        ;;
        "t" ) # sort by modification time
            ls_cmd="$ls_cmd -t"
        ;;
        "s" ) # sort by file size
            ls_cmd="$ls_cmd -S"
        ;;
        *)
            ls_cmd="ls --color=always"
        ;;
    esac
    $ls_cmd
}

function __find-in-files {
    usage=$(cat <<FIND_IN_FILES_USAGE
__find-in-files [needle] [grep_arguments] [haystack_dir] 
FIND_IN_FILES_USAGE
)

    local needle=${1}
    local haystack_dir=${2}
    local grep_arguments=${3}

    if [ -z ${needle} ]; then
	echo "needle is not populated"
	echo -e $usage
	return 1;
    fi
    if [ -n "${4}" ]; then
	echo "there is an extra parameter at position 4: '${4}'"
	echo -e $usage
	return 1;
    fi
    if [ -z ${haystack_dir} ]; then
	haystack_dir="."
    else
	if ! [ -e ${haystack_dir} ]; then
	    echo -e "haystack_dir: '${haystack_dir}' DNE"
	    echo -e $usage
	    return 1
	fi
    fi
    if [ -z ${grep_arguments} ]; then
	grep_arguments=rni
    fi

    local command="grep -${grep_arguments} --color ${needle} ${haystack_dir}"
    echo $command
    $command
}

