#!/bin/bash

# cp target/common-business-1.0.0.jar ../../../ui/thirdparty/web/target/ui-thirdparty/WEB-INF/lib/.
# ./source/ui/admin/business/target/classes/other-sql.xml
# find . -regextype sed -iregex ".*/[a-z\-]*sql\.xml"

# split
# IFS='/'; read -a array <<< "$p"; for element in "${array[@]}"; do echo $element; done

# exclude a string regex
# echo "select sjiofjeifoej from DOG jfidofjdfoidjf select fjdisofjoidfj from CAT " | grep -oiP 'select(.(?!from))*\s+from\s+\w+' ; prints DOG, CAT

# source ~/scripty-bits-n-shortcuts/bash/reset-input-preferences.sh

function find-files-greater-than {
    local dir="${1}"
    local size="${2}"
    find "${dir}" -size +${size} -printf "%k\t%p\n"
}

## some common stuff
function useful-stuff {
    echo "find ~ -size +1G"
}

## if capslock key is toggled in a bad way
function capslock-toggle {
    xdotool key Caps_Lock
}

# BASH_FILES_DIR will be equal to the dir holding this file
BASH_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# I do not need to be bothered with the shift key
set completion-ignore-case on
set show-mode-in-prompt on
shopt -s cdspell

# colors
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

export IGNOREEOF=1
function join { local IFS="$1"; shift; echo "$*"; }

function _git_branch_name {
    git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||'
}
function _is_git_dirty {
    local show_untracked=$(git config --bool bash.showUntrackedFiles)
    local untracked=''
    if [ "$theme_display_git_untracked" = 'no' -o "$show_untracked" = 'false' ]; then
        local untracked='--untracked-files=no'
    fi
    git status -s --ignore-submodules=dirty $untracked 2>/dev/null
}

function bash_prompt {
    local _pwd_display="\w"

    if [[ "$(_git_branch_name)" ]]; then
        local git_branch=${RED}$(_git_branch_name)
        local git_info=" ${BYellow}${git_branch}${BYellow}"

        if [[ "$(_is_git_dirty)" ]]; then
            local dirty="\[$BGreen\] ✗"
            local git_info="${git_info}${dirty}"
        fi
    fi

    local _docker_host_display=
    if [[ "$DOCKER_HOST" ]]; then
        _docker_host_display=" \[$Color_Off\]\[$Cyan\]$DOCKER_HOST\[$Color_Off\]"
    fi

    if [[ "$DOCKER_MACHINE_NAME" ]]; then
        _docker_host_display="${_docker_host_display}:\[$Blue\]$DOCKER_MACHINE_NAME\[$Color_Off\]"
    fi

    export PS1="\[$BGreen\]\u \t \[$BBlue\]${_pwd_display}${_docker_host_display}\[$Color_Off\]${git_info}\n\[$Color_Off\]↪ "
}

function ps1-use-fullpath {
    export PS1="\[$BGreen\]\u \[$BBlue\]\w\[$Color_Off\]> "
}
function ps1-use-cwd-basename {
    export PS1="\[$BGreen\]\u \[$BBlue\]\W\[$Color_Off\]> "
}

PROMPT_COMMAND=bash_prompt
# ps1-use-cwd-basename
# ps1-use-cwd-basename

export EDITOR="vim"
#export EDITOR="emacs"

alias e="emacsclient"
# export EDITOR="emacsclient"

alias whomami="whoami"

alias find-file="find . -iname "
alias psg="ps aux | grep "
alias psgi="ps aux | grep -i"

# tell SCREEN to back off when setting TERM to "screen"
# export TERM=xterm
export TERM=xterm-256color
#export GREP_OPTIONS='--color=always'
alias grep-iHrn='grep -irHn '
# with "set -o vi", \ev opens emacs for some reason
# this is a way to unbind
# set -o vi
set -o emacs
bind '"\ev"':self-insert
# # aliases
# #  human readable, all files minus . and .., append indicator, ignore backups
alias ls="ls -h --color=always"
__BASE_LS_COMMAND='ls -hBF --ignore=#* --color=always --group-directories-first'
alias l=$__BASE_LS_COMMAND
alias la="${__BASE_LS_COMMAND} -A"
alias lah="${__BASE_LS_COMMAND} -Ahg"
alias ll="${__BASE_LS_COMMAND} -Al"
alias lt="${__BASE_LS_COMMAND} -tAl"
function ls-only-hidden-dirs {
    local _dir="$1"
    l -A --color=never $_dir | grep \/$ | grep '^\.'
}

# binds
bind 'set completion-ignore-case on'
# alt-S loads source
bind '"\eS"':"\"source ~/.bashrc\C-m\""
# alt-j acts like <return>
bind '"\ej"':"\"\C-m\""
# alt-< Move up the directory. same as cd ../
bind '"\e<"':"\"\C-u__move-up-directory\C-m\""
bind '"\eL"':"\"\C-u__ls-type\C-m\""
bind '"\el"':"\"\C-ull\C-m\""
bind '"\e1"':"\"\C-a\C-kla\C-j\""
bind '"\e2"':"\"\C-a\C-klt\C-j\""

# alt-> Move down the directory.
bind '"\e>"':"\"\C-u__move-down-directory\C-m\""
bind '"\ew"':kill-region
# case sensitive file grep
bind '"\eXf"':"\"\C-a__find-in-files \C-e . rn \C-j\""
# case insensitive file grep
bind '"\eXi"':"\"\C-a__find-in-files \C-e . rni \C-j\""
# case insensitive regex file grep, Uses Perl regex.  Encase this with some quotes
bind '"\eXr"':"\"\C-a__find-in-files \C-e . rniP \C-j\""
# copy what's on terminal line to clipboard
bind '"\eX\ew"':'"\C-a echo \"\C-e\" | xclip -selection clipboard\C-j\"'
# copy whatever ctrl+y does into clipboard
bind '"\eX\ey"':'"echo \C-y | xclip -selection clipboard\C-j"'
bind '"\ep"':'"\C-p"'
bind '"\en"':'"\C-n"'


# echo "someStuff" | to-clipboard -> Ctrl+Shift+V outputs "someStuff"
alias to-clipboard="xclip -selection c"

alias irb='irb --simple-prompt'
alias rm='rm -i'
alias mv='mv -i'
# alias cp='cp -i'
alias df='df -h'
alias du='du -sh'
alias h='history | tail'
alias sr='screen -r'
alias c='cd-above'
alias run-junit="java -cp .:/usr/share/java/junit4.jar org.junit.runner.JUnitCore"

# sources
if [ -a $BASH_FILES_DIR/bash_customizations_git.sh ]; then
    source $BASH_FILES_DIR/bash_customizations_git.sh
fi

if [ -a $BASH_FILES_DIR/bash_customizations_svn.sh ]; then
    source $BASH_FILES_DIR/bash_customizations_svn.sh
    bind '"\e7"':"\"\C-udo-svn\C-m\""
fi

# THUMB BALL MOUSE ES 2 FASTO! SLOW IT DOWN
#logitech=$(xinput --list --short | grep -m1 "Logitech" | cut -f2 | cut -d= -f2) # mouse ID
#xinput --set-prop "$logitech" "Device Accel Constant Deceleration" 2 # It defaults to 1

## autojump
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh


##################################
#HISTORY_CUSTOMIZATIONS
##################################
HISTCONTROL=ignoredups:ignorespace:erasedups # don't put duplicate lines in the history.
HISTIGNORE="__move-down-directory:__move-up-directory:__ls-type:pwd:ls:cd:fg:top:source *:"
shopt -s histappend # append to the history file, don't overwrite it
# shopt -s dotglob nullglob # http://unix.stackexchange.com/questions/6393/how-do-you-move-all-files-including-hidden-from-one-directory-to-another
HISTSIZE=50000 # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=20000
# export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}"

####################################################################
# "useful" functions that are called with the binds from above
# consider these private methods.  It doesn't make a lot of sense
# to use these from the command line
###################################################################
# only display minimal xev information (keypress and keycodes)
function xev-minimal {
    xev -event keyboard | grep --color -oP 'keycode.*\)'
}

# sorts single csv line asc
function sort-csv-line {
    echo $1 | tr ',' '\n' | sort -u | tr '\n' ','
}

# removes all temp files given a directory
function remove-all-temp-files {
    local haystack_dir=$1

    # removes all files ending with a tilde
    find $haystack_dir -name "*~"  -exec rm {} \;

    # beginnging with hash
    find $haystack_dir -name "#*" -exec rm {} \;

    # all .~ directories
    find $haystack_dir -name .~ -type d -exec rm -r {} \;
}

function convert-dos-filepath-to-cygwin-filepath {
    _CYGWIN_FILEPATH=$(echo "$1" | sed 's@\\@/@g' | sed 's@C:@/cygdrive/c@g')
    echo ${_CYGWIN_FILEPATH}
}
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

    local _args="$*"
    case $_type in
	      t) # sort by modification time
	          lt $_args
	          ;;
	      s) # sort by file size
	          l -s $_args
	          ;;
	      [aA])
	          l -A $_args
	          ;;
	      [Xx])
	          l -X $_args
	          ;;
	      *)
	          l $_args
	          ;;
    esac
}

function apply-to-resource {
    local resources=$(find-resource $1 $2)

    if [[ ! "$resources" ]]; then
	      echo "Couldn't find resource matching $1 in haystack $2"
	      return 0
    fi
    local command_to_apply="$3"
    local args_line=""

    if [[ $(echo $resources | wc -w) -ge 2 ]]; then
	      count=0;
	      for r in $resources
	      do
	          r_arr[$count]=$r
	          count=$(($count+1))
	      done
	      for key in ${!r_arr[@]}
	      do
	          echo -n "$key "
	          echo ${r_arr[$key]}
	      done
	      echo -e "\nSelect files to run command \"$command_to_apply\" on by number(s).  If multiple, separate by space. If all, enter nothing or enter *.\n Which files(s): "
	      read _file_numbers

	      if [[ -z "$_file_numbers" ]]; then
	          _file_numbers="*"
	      fi
	      if [[ "$_file_numbers" = "*" ]]; then
	          args_line=$resources
	      else
	          for _file_number in $_file_numbers
	          do
		            args_line="${args_line} ${r_arr[$_file_number]}"
	          done
	      fi
    else
	      echo $resources
	      args_line=$resources
    fi

    if [[ ! "$command_to_apply" ]]; then
	      echo -e "\n Enter command to apply to found resource(s): "
	      read command_to_apply
	      if [[ ! "$command_to_apply" ]]; then
	          echo -e "\n Unknown command. exiting"
	          return 1
	      fi
    fi

    $command_to_apply $args_line
}

function open-resource {
    local resource_pattern="$1"
    local haystack="$2"
    apply-to-resource "$resource_pattern" "$haystack" "$EDITOR"
}

function find-resource {
    local _file_search_string=$(_wildcard-camelcase-file-search-string $1)
    local _search_result_filter_string=$(_wildcard-camelcase-file-search-result-filter-string $1)
    local _haystack_dir=${2:-"."}
    find $_haystack_dir -name $_file_search_string | grep -v target | grep -v .svn | grep -v bin | grep -v \~ | grep -P $_search_result_filter_string
}

function _wildcard-camelcase-file-search-string {
    local _begins_with_wildcard=
    if [[ $(echo $1 | grep ^*) ]]; then
	      _begins_with_wildcard="*"
    fi
    echo $_begins_with_wildcard$(echo $1 | sed -E 's/([A-Z])/*\1/g' | sed 's/^\**//g' | sed 's/\*{2}/*/g')*
}

#############################
# Tries to cd to $1.  if fails, removes last piece of $1's path, and tries to cd there
#############################
function cdu {
    local dir="$1"
    local op=$(cd $dir 2>&1 > /dev/null)
    if [[ "$op" && $op =~ 'Not a directory' ]]; then
	      dir=$(echo $dir | sed -E 's@/[^/]+$@@g')
    fi
    cd $dir
}

###
# This turns something like HashSet.java into Hash[^A-Z]*Set.java* to prevent things like HashAttributeSet.java being returned
###
function _wildcard-camelcase-file-search-result-filter-string {
    echo $(_wildcard-camelcase-file-search-string $1 | sed 's/\*$//' | sed 's/\*/[^A-Z]*/g')
}

function str-contains {
    local _haystack=$1
    local _needle=$2
    if [[ $(echo $_haystack | grep -P $_needle) ]]; then echo 1
    fi
}

function get-path-to-dir {
    local array=""
    IFS='/'
    read -a array <<< "$1"
    local l=""
    for element in "${array[@]}"
    do
	      l=$element
    done
    unset IFS
    echo $1 | sed "s@$l@@g"
}

function cd-above {
    if [ ! "$1" ]; then
	      ## if no arg, go home
	      cd ~
    elif [ -d "$1" -o "$1" == "-" ]; then
	      ## if it's already a directory that exits
	      ## or we're trying to just toggle to previous dir, do that
	      cd "$1"
    else
	      local _dir=$(get-path-to-dir $1)
	      if [ -d "$_dir" ]; then
	          cd $_dir
	      else
	          ## else, autojump to what $1 is
	          j $1
	      fi
    fi
}

function grep-includes {
    local _args=$1
    if [[ "$2" ]]; then
	      local _includes="$2"
    else
	      local _includes=""
    fi
    if [[ $(str-contains $_args j) ]]; then
	      _includes="${_includes} --include=\"*.java\""
    fi
    if [[ $(str-contains $_args g) ]]; then
	      _includes="${_includes} --include=\"*.groovy\""
    fi
    if [[ $(str-contains $_args x) ]]; then
	      _includes="${_includes} --include=\"*.xml\""
    fi
    if [[ $(str-contains $_args s) ]]; then
	      _includes="${_includes} --include=\"*.sql\""
    fi
    if [[ $(str-contains $_args p) ]]; then
	      _includes="${_includes} --include=\"*.properties\""
    fi
    echo $_includes
}

function __find-in-files {
    usage="__find-in-files [needle] [grep_arguments] [haystack_dir]"

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

    local command="grep -${grep_arguments} --color ${needle}${haystack_dir}"
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

alias tm="tmux attach || tmux new"

function speedtest {
    local dummy_file=http://speedtest.wdc01.softlayer.com/downloads/test10.zip
    wget -O /dev/null ${dummy_file}
}

function grep-in-file-pattern {
    local _file_pattern=${1}
    local _grep_pattern=${2}

    find . -name "${_file_pattern}" -exec grep -iHn "${_grep_pattern}" {} \;
}

function update-upgrade-dist-upgrade {
    sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y
}


#xbacklight -set 50
export LEIN_FAST_TRAMPOLINE=y
export TOMCAT_HOME=~/bin/apache-tomcat

# nohup xscreensaver -no-splash > /dev/null 2>&1

alias public-ip="wget http://ipinfo.io/ip -qO -"

function date-current {
    date +"%Y-%m-%d"
}

function random-words {
    local num_wanted="$1"
    local words=$(cat /usr/share/dict/words | grep -Pv '[^\w]' | tr '[:upper:]' '[:lower:]' | awk 'length($0) > 3 && length($0) < 10')
    local num=$(echo $words | tr ' ' '\n' | wc -l)
    local sed_args=$(python -c "import random; print ' '.join(['-e '+str(random.randint(0,$num))+'p ' for i in range(0,4)])")
    echo $words | tr ' ' '\n' | sed -n $sed_args | tr '\n' ' ' | sed -e 's/\s//g'
}
