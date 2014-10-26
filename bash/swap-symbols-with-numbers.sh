#!/bin/bash

function __remap-keys {
    local keycode_number_symbols="
19,0,parenright
18,9,parenleft
17,8,asterisk
16,7,ampersand
15,6,asciicircum
14,5,percent
13,4,dollar
12,3,numbersign
11,2,at
10,1,exclam
"

    local _symbol_or_number="$1"
    if [[ ! "$_symbol_or_number" ]]; then
	echo "this function shouldn't be called by anyone by functions of this file.  It's being called incorrectly"
        return 1
    fi


    for row in $keycode_number_symbols; do
        local keycode=$(echo $row | awk -F ',' '{print $1}')
	local first_arg=
        local second_arg=
        local number=$(echo $row  | awk -F ',' '{print $2}')
        local symbol=$(echo $row  | awk -F ',' '{print $3}')

        case "$_symbol_or_number" in
	    symbol|symbols)
		first_arg=$symbol
                second_arg=$number
                ;;
            number|numbers)
                first_arg=$number
                second_arg=$symbol
                ;;
            *) echo "dunno what is meant by '$1'.  exiting..."
               return 1
	       ;;
        esac

        xmodmap -e "keycode $keycode = $first_arg $second_arg"
    done
}

# do this to get the '(' char by pressing 'shift+9', and '9' by default
# FYI: this is how things are before you screwed up your shit by using this script
function set_number_row_default-numbers {
    __remap-keys number
}

# do this to get the '9' char by pressing 'shift+9', and '(' by default
function set_number_row_default-symbols {
    __remap-keys symbol
}
