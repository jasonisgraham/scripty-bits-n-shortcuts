xset r rate 200
setxkbmap -option "shift:both_shiftlock"
xmodmap ~/.Xmodmap

## if [[ "1" == "$(ps aux | grep quicktile | wc -l)" ]]; then
##     ~/bin/quicktile/quicktile.py --daemonize & >> /dev/null
##     disown %
## fi

# BASH_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# source $BASH_FILES_DIR/swap-symbols-with-numbers.sh
# set_number_row_default-symbols
