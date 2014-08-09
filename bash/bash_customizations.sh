#!/bin/bash

# cp target/common-business-1.0.0.jar ../../../ui/thirdparty/web/target/ui-thirdparty/WEB-INF/lib/.
# ./source/ui/admin/business/target/classes/other-sql.xml
# find . -regextype sed -iregex ".*/[a-z\-]*sql\.xml"

# split
# IFS='/'; read -a array <<< "$p"; for element in "${array[@]}"; do echo $element; done

# exclude a string regex
# echo "select sjiofjeifoej from DOG jfidofjdfoidjf select fjdisofjoidfj from CAT " | grep -oiP 'select(.(?!from))*\s+from\s+\w+' ; prints DOG, CAT

# BASH_FILES_DIR will be equal to the dir holding this file
BASH_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# I do not need to be bothered with the shift key
set completion-ignore-case on
set show-mode-in-prompt on

# xports
export IGNOREEOF=1
export PS1="\u \w> "
#PS1='$(echo -ne "\033[$(reset_username_background_after_N_seconds)m")\u$(echo -ne "\033[0m") \w> '
export EDITOR="emacs -nw"

# reset color of cursor to White
# echo -ne "\033]12;White\007"

# tell SCREEN to back off when setting TERM to "screen"
#export TERM=xterm

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
# open file specified by whatever is currently printed to line in emacs in cygwin. Should be a file path (DOS or unix)
# do not quote the argument!
bind '"\eXe"':'"\C-aemacs $(convert-dos-filepath-to-cygwin-filepath "\C-e")\C-j\"'
# copy what's on terminal line to clipboard
bind '"\eX\ew"':'"\C-a echo \"\C-e\" | xclip -selection clipboard\C-j\"'
# copy whatever ctrl+y does into clipboard
bind '"\eX\ey"':'"echo \C-y | xclip -selection clipboard\C-j"'
# inserts $() and moves cursor inside parens
bind '"\eX("':'"$()\C-b"'
bind '"\ep"':'"\C-p"'
bind '"\en"':'"\C-n"'

# aliases
__BASE_LS_COMMAND='ls -lhBF --ignore=#* --ignore=.git --color=always --group-directories-first'
alias l=$__BASE_LS_COMMAND
alias lst="${__BASE_LS_COMMAND} -t"
alias lss="${__BASE_LS_COMMAND} -s"
alias lsa="${__BASE_LS_COMMAND} -A"
alias lah='ls -lAh'
# echo "someStuff" | to-clipboard -> Ctrl+Shift+V outputs "someStuff"
alias to-clipboard='xclip -selection clipboard'
alias emacs='emacs -nw'
alias irb='irb --simple-prompt'
alias lah='ls -lAh'
alias rm='rm -i'
alias df='df -h'
alias du='du -sh'
alias h='history | tail'
alias sr='screen -r'

# sources
if [ -a $BASH_FILES_DIR/bash_customizations_git.sh ]; then
    source $BASH_FILES_DIR/bash_customizations_git.sh
fi

if [ -a $BASH_FILES_DIR/bash_customizations_svn.sh ]; then
    source $BASH_FILES_DIR/bash_customizations_svn.sh
    bind '"\e&"':"\"\C-udo-svn\C-m\""
fi

# THUMB BALL MOUSE ES 2 FASTO! SLOW IT DOWN
#logitech=$(xinput --list --short | grep -m1 "Logitech" | cut -f2 | cut -d= -f2) # mouse ID
#xinput --set-prop "$logitech" "Device Accel Constant Deceleration" 2 # It defaults to 1

# stupid delay on keypress too slow, dawg when coming out of "suspend".  stupid xubuntu.
xset r rate 180

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
    case $_type in
	t) # sort by modification time
            lst
	    ;;
	s) # sort by file size
	    lss
	    ;;
        [aA])
            lsa
            ;;
	*)
            l
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
    if [ -d "$1" ]; then
	cd $1
    else
	cd $(get-path-to-dir $1)
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
    usage=$(cat << FIND_IN_FILES_USAGE
  __find-in-files [needle] [grep_arguments] [haystack_dir]
FIND_IN_FILES_USAGE)

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
