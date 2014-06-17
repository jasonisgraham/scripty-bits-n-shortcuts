#!/bin/bash

export SVN_LOCATIONS_TO_IGNORE="svn-commit.tmp"

function svn-st-ignoring-specified-locations {
    echo "Ignoring the following locations/patterns: " 
    for loc in $SVN_LOCATIONS_TO_IGNORE; do
	echo " - $loc"
    done
    echo ""
    
    local _dir="."
    if [[ "$1" ]]; then
	_dir="$1"
    fi		
    svn st $_dir | grep -vP $(echo $SVN_LOCATIONS_TO_IGNORE | sed "s/\s/|/g") | grep -oP "[^\s]+$"
}

function svn-ci-ignoring-specified-locations {
    local _ci_args=$@
    local _svn_st_result=$(svn-st-ignoring-specified-locations $@)
    
    if [[ "$_svn_st_result" ]]; then
	_ci_args=$_svn_st_result
    fi		
    
    svn ci $_ci_args
}

function svn-diff-ignoring-specified-locations {
    local _diff_args=$@
    local _svn_st_result=$(svn-st-ignoring-specified-locations $@)
    
    if [[ "$_svn_st_result" ]]; then
	_diff_args=$_svn_st_result
    fi		
    
    svn diff -x -w $_diff_args
}

function do-svn {
    local args='.'
    svn_st_arr=''
    # if 1st arg is populated, then we'll use all args
    if [[ "$1" ]]; then
	args="$@"
    fi
    local svn_cmd='svn'
    local _type
    read -n 1 -s _type
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
	"s" )	    
	    svn_cmd="$svn_cmd st"
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
	    
	    make-local-mod-tarball-name
	    local tar_cmd="tar -cvf ${LOCAL_MOD_TARBALL_NAME} ${args}"
	    echo $tar_cmd
	    $tar_cmd
	    return
	    ;;
	
	"&")
	    IFS=$
	    stat=`svn st`
	    count=0;
	    for entry in `echo $stat | cat -vte`
	    do
		svn_st_arr[$count]=$entry
		count=$(($count+1))
	    done
	    for elem_key in ${!svn_st_arr[@]}
	    do
		echo -n "$elem_key "
		echo ${svn_st_arr[$elem_key]} | grep -oP ".*$"
	    done
	    echo -e "\nSelect file number(s).  If multiple, separate by space.\n Which file(s): "
	    read _file_numbers

	    IFS=" "
	    local args_line=""	    
	    for _file_number in $_file_numbers
	    do
		args_line="${args_line} ${svn_st_arr[$_file_number]}"
	    done
	    args=`echo $args_line | grep -oP "(?<=\s)[^\s].*$"`
	    echo "$args"
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
    LOCAL_MOD_TARBALL_NAME=$(whoami)${separator}r${revision}${separator}${timestamp}.tar
}

function tar-local-mods {
    make-local-mod-tarball-name
    local tarball_name=$LOCAL_MOD_TARBALL_NAME
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
