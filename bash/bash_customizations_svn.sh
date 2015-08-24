#!/bin/bash

unset IFS
export SVN_LOCATIONS_TO_IGNORE=$(echo ${SVN_LOCATIONS_TO_IGNORE} svn-commit.tmp | tr ' ' '\n' | sort -u | tr '\n' ' ')

alias svn-diff-side-by-side='svn --diff-cmd "diff" --extensions "-y --suppress-common-lines" diff'
alias svn-vim-diff='svn diff | vim -R -'

function __print-ignored-locations {
    echo "Ignoring the following locations/patterns: "
    for loc in $SVN_LOCATIONS_TO_IGNORE; do
	echo " - $loc"
    done
    echo ""
}

# function __define-svn-st-ignoring-specified-locations {
#     __GLOBAL_SVN_ST_IGNORING_SPECIFIED_LOCATIONS=$(svn st $_dir | grep -vP $(echo $SVN_LOCATIONS_TO_IGNORE | sed "s/\s/|/g"))
# }

function svn-st-ignoring-specified-locations {
    local _dir="."
    if [[ "$1" ]]; then
	_dir="$1"
    fi

    svn st $_dir | grep -vP $(echo $SVN_LOCATIONS_TO_IGNORE | sed "s/\s/|/g")
}

function do-svn {
    local args='.'
    svn_st_arr=''
    # if 1st arg is populated, then we'll use all args
    if [[ "$1" ]]; then
	args="$@"
    fi
    local svn_cmd='svn'

    echo "Enter: [s]tatus, [S]tatus, [d]iff, & to select files, [t]ar"
    local _type
    read -n 1 -s _type

    local stat=

    case $_type in
	"d" )
	    svn_cmd="$svn_cmd diff -x -w"
            ;;
	"c" )
	    svn_cmd="$svn_cmd ci"
	    ;;
	"u" )
	    svn_cmd="$svn_cmd up"
	    ;;
	"S" )
	    svn_cmd="$svn_cmd st"
	    ;;
        "s" )
            svn_cmd="svn-st-ignoring-specified-locations"
            ;;
	"r" )
	    svn_cmd="$svn_cmd revert "
	    ;;
	"R" )
	    svn_cmd="$svn_cmd revert -R "
	    ;;
	"i" )
	    svn_cmd="$svn_cmd info"
	    ;;
	"t" )
	    if [[ $args == "." ]]; then
		tar-local-mods
	  	return
	    fi

	    local local_MOD_TARBALL_NAME=$(make-local-mod-tarball-name)
	    local tar_cmd="tar -cvf ${local_MOD_TARBALL_NAME} ${args}"
	    echo $tar_cmd
	    $tar_cmd
	    return
	    ;;

	"&")
            unset IFS
            unset svn_st_arr
            svn_st_arr=
            # local stat_unignored_files=$(svn st | grep -vP $(echo $SVN_LOCATIONS_TO_IGNORE | sed "s/\s/|/g") | sort)
            # local stat_ignored_files=$(svn st | grep -P $(echo $SVN_LOCATIONS_TO_IGNORE | sed "s/\s/|/g") | sort)
            # echo "stat_ignored_files: ${stat_ignored_files} "
            # echo $stat_ignored_files | wc
            # echo "stat_unignored_files: ${stat_unignored_files}"
            # local stat="${stat_unignored_files}${stat_ignored_files}"
            stat=$(svn st | grep -vP $(echo $SVN_LOCATIONS_TO_IGNORE | sed "s/\s/|/g") | sort)
            # echo "stat: ${stat}"

            # local num_unignored_files=$(echo $stat_unignored_files  | awk '{print $1}' | wc -l)
            # echo $stat_unignored_files | cat -vte
            # echo -e "num_unignored_files: ${num_unignored_files}"
            # local num_ignored_files=$(echo $stat_ignored_files  | awk '{print $1}' | wc -l)

            # local print_count=0

	    IFS=$
	    # stat=`svn st`
	    count=0;

	    for entry in `echo $stat | cat -vte | sort`; do
		svn_st_arr[$count]=$entry
		count=$(($count+1))
	    done


            local color_reset='\e[0m'
            local black_text='\e[0;30m'
            local white_bg='\e[47m'
            local white_ul='\e[4;37m'
            local should_color_line=
            local hl_line_color=${white_ul} ##"$black_text$white_bg"
            local current_line_color=$hl_line_color ## $color_reset


	    for elem_key in ${!svn_st_arr[@]}; do
                # print_count=$((print_count+1))

                # if [ $print_count -eq $num_unignored_files ]; then
                #     echo -e "\n\nThe following are in \${SVN_LOCATIONS_TO_IGNORE}\n"
                # fi
                if [[ "${should_color_line}" ]]; then
                    should_color_line=
                    current_line_color=$hl_line_color
                else
                    should_color_line=1
                    current_line_color=$color_reset
                fi

		echo -ne "${current_line_color}${elem_key}\t"
                echo ${svn_st_arr[$elem_key]} | grep -oP ".*$" | awk '{print $1,  $2}'

	    done
	    echo -e "\n${color_reset}Select file number(s).  If multiple, separate by space.\n Which file(s): "
	    read _file_numbers

            if [[ ! "${_file_numbers}" || "${_file_numbers}" == "*" ]]; then
                args=$(echo $stat | awk '{print $2}')
            elif [[ "q" == "${_file_numbers}" || "Q" == "${_file_numbers}" ]]; then
                echo "exiting..."
                return
            else

	        IFS=" "
	        local args_line=""
	        for _file_number in $_file_numbers
	        do
		    args_line="${args_line} ${svn_st_arr[$_file_number]}"
	        done
	        args=`echo $args_line | grep -oP "(?<=\s)[^\s].*$"`
            fi
	    # echo "$args"
	    unset IFS
	    do-svn "$args"
	    return
	    ;;
	* )
	    svn-st-ignoring-specified-locations
	    return
    esac
    svn_cmd="$svn_cmd $args"
    echo $svn_cmd
    if [[ $_type == "R" ]]; then
	svn st $args
	echo -e "\nYou sure you wanna revert everything?"
	read -n 1 _you_sure
	if [[ $_you_sure == "y" ]]; then
	    $svn_cmd
	else
	    echo -e "\ndirtnapping\n"
	    return
	fi
    else
	$svn_cmd
    fi
}

function make-local-mod-tarball-name {
    local svn_info=$(svn info | grep -oP "(?<=Repository Root: svn\+ssh://).*"| sed "s/@/_/g" | sed "s@/@-@g")
    local revision=$(svn info | grep -oP "(?<=Revision:\s)\d*")
    local timestamp=$(date +%s)
    local separator=__
    echo $(whoami)${separator}r${revision}${separator}${timestamp}.tar
}


function tar-local-mods {
    local tarball_name=$(make-local-mod-tarball-name)
    local args="$*"

    for arg in $args; do
	if [[ `echo $arg | grep -oP "\.tar$"` ]]; then
	    tarball_name=$arg
	fi
    done

    local svn_st=$(svn st)
    local retval=$?
    if [ 0 -ne $retval ]; then
	echo "Exiting: svn st returned code of ${retval}"
	return $retval
    else
	local all_files=$(svn st | grep -oP "(?<=\s)\w.*\.*$")
	local previous_tarball_pattern="$(whoami)_$(hostname)__[^\s]*\d+\.tar"
	local files=""

	if [[ ! $all_files ]]; then
            echo "No local mods found."
	    return 0
	fi
	for file in $all_files; do
            if [[ ! $(echo $file | grep -oP $previous_tarball_pattern) ]]; then
		files="$files $file"
	    fi
	done

	local tar_cmd="tar -cvf $tarball_name $files"
	echo $tar_cmd

	$tar_cmd
    fi
}
