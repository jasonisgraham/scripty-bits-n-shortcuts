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
# alt-S loads source
bind '"\eS"':"\"source ~/.bashrc\C-m\""
# alt-j moves cursor back word
bind '"\ej"':"\"\eb\""
# alt-k moves cursor forward word
bind '"\ek"':"\"\ef\""
# alt-J cuts word behind cursor
bind '"\eJ"':"\"\C-w\""
# alt-K cuts word in front of cursor
bind '"\eK"':"\"\ed\""
# alt-< Move up the directory. same as cd ../
bind '"\e<"':"\"\C-u__move-up-directory\C-m\""
# alt-> Move down the directory.
bind '"\e>"':"\"\C-u__move-down-directory\C-m\""
# alt-L same as __ls-type
bind '"\eL"':"\"\C-u__ls-type\C-m\""      
bind '"\ew"':kill-region
# case sensitive file grep
bind '"\eXf"':"\"\C-a__find-in-files \C-e . rn \C-j\""
# case insensitive file grep
bind '"\eXi"':"\"\C-a__find-in-files \C-e . rni \C-j\""
# case insensitive regex file grep, Uses Perl regex.  Encase this with some quotes
bind '"\eXr"':"\"\C-a__find-in-files \C-e . rniP \C-j\""    

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
# consider these private methods.  It doesn't make a lot of sense
# to use these from the command line
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
    elif ! [ -e ${haystack_dir} ]; then
	echo -e "haystack_dir: '${haystack_dir}' DNE"
	echo -e $usage
	return 1
    fi
    if [ -z ${grep_arguments} ]; then
	grep_arguments=rni
    fi

    local command="grep -${grep_arguments} --color ${needle} ${haystack_dir}"
    echo $command
    $command
}

function copy-files-matching-pattern-to {
    local file_match_pattern=${1}
    local destination_dir=${2}
    
    local files=$(ls | grep -P "${file_match_pattern}")
    echo $files

    mkdir -p ${destination_dir}
    
    for file in $files; do
	echo "copying file $PWD/${file} to ${destination_dir}/${file}"
	cp ${file} ${destination_dir}/.
    done
}

function copy-files-matching-pattern-contains-string-pattern-to {
    local file_match_pattern=${1}
    local destination_dir=${2}
    local string_pattern=${3}
    
    local filepaths=$(grep -rPo "${string_pattern}" | grep -P "$file_match_pattern")
    echo $filepaths

    mkdir -p ${destination_dir}
    
    for filepath in $filepaths; do
	local file=$(echo ${filepath} | grep -oP ".*(?=:${string})")
	echo "copying file $PWD/${file} to ${destination_dir}/${file}"
	cp ${file} ${destination_dir}/.
    done
}
#string="\|graham"; grep -rPo ${string} | grep -oP ".*(?=:${string})"