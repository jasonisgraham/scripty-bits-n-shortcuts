#!/bin/bash

################################################
### - date
### -- root dir info
### -- A
### --- filepaths
### ---- 1: rel/path/to/file1
### ---- 2: rel/path/to/file2
### --- files
### ---- 1: file1
### ---- 2: file2
### -- ?, M (same as A)
### -- D
### --- filepaths
### ---- 1: rel/path/to/file1
### ---- 2: rel/path/to/file2
################################################

export SVN_LOCATIONS_TO_IGNORE="${SVN_LOCATIONS_TO_IGNORE} svn-commit.tmp"

__file_number_separator="->"

# do tab-completion stuff
complete -W "save stash list pop help init" svn-stash

usage()
{
    cat <<EOF

    usage: $0 options
    
    OPTIONS:
    save|stash [-m|--message]
	Save your local modifications to a new stash. If you wish to git a message to your stash use -m or --message to create one.  This will be displayed when doing "svn-stash list -v"

    list [-v]
	Lists all stash names, If -v option is used, stashed files & delete, add manifest details & stash message (if available) are printed
	TODO: it would be nice to do an SVN diff of the changes, yeah?

    pop
	"Merges" most recent stash on top of current working tree state.
EOF
}

################################################
### Hoping that this is the main entry point
################################################
function svn-stash {
    local _1stArg=$1

    case "$_1stArg" in
        save|stash)
            __stash-local-mods_init
            __stash-local-mods
            ;;
        list)
            __stash-local-mods_init            
            __stash-local-mods_list $(for opt in $*; do if [ "list" != $opt ]; then echo $opt; fi; done)
            ;;
        pop)
            __stash-local-mods_init
            __stash-local-mods_pop
            ;;
        init)
            __stash-local-mods_init
            ;;
        help|*)
            usage
            return 
            ;;
    esac	            
}

####################################
# pops the most recent "stash"
# double-quotes are important b/c the following two are not equivalent
## "num string"  
## num string
####################################
function __stash-local-mods_pop {
    local most_recent_dir=$(__echo-svn-stashes-dir)/$(ls -t $(__echo-svn-stashes-dir) | sed -n 1p)
    local adds_dir=$most_recent_dir/adds
    local deletes_dir=$most_recent_dir/deletes
    local untrackeds_dir=$most_recent_dir/untrackeds
    local mods_dir=$most_recent_dir/mods
    
    if [ -a $adds_dir/filepaths.list ]; then
        for filepath_list_item in $(cat $adds_dir/filepaths.list); do
            local filepath_to_be_added=$(__echo-filepath-from-filespaths-list-item "$filepath_list_item")
            local file_number=$(__echo-file-number-from-filepaths-list-item "$filepath_list_item")
            cp -nv $adds_dir/files/$file_number $filepath_to_be_added
            svn add $filepath_to_be_added
        done
    fi

    if [ -a $untrackeds_dir/filepaths.list ]; then
        for filepath_list_item in $(cat $untrackeds_dir/filepaths.list); do
            local filepath_to_be_added=$(__echo-filepath-from-filespaths-list-item "$filepath_list_item")
            local file_number=$(__echo-file-number-from-filepaths-list-item "$filepath_list_item")
            cp -nv $untrackeds_dir/files/$file_number $filepath_to_be_added
        done
    fi

    if [ -a $mods_dir/filepaths.list ]; then
        for filepath_list_item in $(cat $mods_dir/filepaths.list); do
            local filepath_to_be_added=$(__echo-filepath-from-filespaths-list-item "$filepath_list_item")
            local file_number=$(__echo-file-number-from-filepaths-list-item "$filepath_list_item")
            cp -v $mods_dir/files/$file_number $filepath_to_be_added
        done
    fi

    if [ -a $deletes_dir/filepaths.list ]; then
        for filepath_list_item in $(cat $deletes_dir/filepaths.list); do
            local filepath_to_be_deleted=$(__echo-filepath-from-filespaths-list-item "$filepath_list_item")
            svn delete $filepath_to_be_deleted
        done
    fi

    __remove-stash $most_recent_dir
}

function __remove-stash {
    local path_to_most_recent_stash=$1
    
    # just tarring up whatever's in this folder, b/c yknow, one of the developers working on this
    #  code doesn't really know what he's doing (intentially using "he" instead of "he/she" because
    #  the developer is me, Jason, and I'm pretty much a male dude).  I don't trust that developer 
    #  to just delete some directory of some changes that might not have been "correctly unstashed"
    # Creating the backups dir is here b/c it's sort of a safety net.  It could be removed when 
    #  the handsome girls and guys doing the trapese won't paint the ground red if it were removed
    local backups_dir=$(__echo-svn-stash-dir)/backups    
    mkdir -p $backups_dir

    local backup_tar_name=$(echo $path_to_most_recent_stash | grep -oP '[^\/]*$')
    local tar_cmd="tar -cf ${backups_dir}/${backup_tar_name}.tar $path_to_most_recent_stash"
    echo $tar_cmd
    $tar_cmd

    rm -rf $path_to_most_recent_stash
}

function __echo-filepath-from-filespaths-list-item {
    echo $1 | sed -E 's@^[0-9]+->@@g'
}

function __echo-file-number-from-filepaths-list-item {
    echo $1 | grep -oP ^[0-9]+
}

####################################
# This defaults to ~/.svn-stashes
# This is the location of the directory used by this "app"
# TODO: give the option of something other than this dir
####################################
function __echo-svn-stash-dir {
    echo "$HOME/.svn-stash"
}

####################################
# This is the location of the directories for each "stash"
####################################
function __echo-svn-stashes-dir {
    echo "$(__echo-svn-stash-dir)/stashes"
}

################################################
### Invoked with svn-stash list
################################################
function __stash-local-mods_list {
    local list_verbose=
    local OPTIND    
    while getopts ":v" arg; do
        case $arg in
            v)
                list_verbose=1
                ;;
        esac	
    done
    local stashes_dir="$(__echo-svn-stashes-dir)"

    if [ $list_verbose ]; then
        for d in $(ls -t $stashes_dir); do
            local stash_dir=$stashes_dir/$d
            echo "---------------------------------------------"
            echo "----------$d----------------"            
            echo "---------------------------------------------"

            echo "svn-info: $(cat $stash_dir/svn.info)"
            echo ""
            
            if [ -a $stash_dir/adds/filepaths.list ]; then
                echo "added files"
                cat $stash_dir/adds/filepaths.list
                echo ""
            fi

            if [ -a $stash_dir/untrackeds/filepaths.list ]; then
                echo "untracked files"
                cat $stash_dir/untrackeds/filepaths.list
                echo ""
            fi

            if [ -a $stash_dir/mods/filepaths.list ]; then
                echo "modified files"
                cat $stash_dir/mods/filepaths.list
                echo ""
            fi

            if [ -a $stash_dir/deletes/filepaths.list ]; then
                echo "deleted files"
                cat $stash_dir/deletes/filepaths.list
                echo ""
            fi
        done
    else
        ls -lAht $stashes_dir
    fi
}

################################################
### Invoked with svn-stash init
################################################
function __stash-local-mods_init {
    local stashes_dir="$(__echo-svn-stashes-dir)"
    mkdir -p $stashes_dir
}

################################################
### Invoked with svn-stash 
################################################
function __stash-local-mods {
    local cwd=$(pwd)
    
    # e.g. 2014-07-01_18-06-00
    local timestamp=$(date +%F_%T | sed 's@:@-@g') 
    local svn_info_filename="svn.info"
    
    # create stash directory    
    local stashes_dir="$(__echo-svn-stashes-dir)"
    mkdir -pv $stashes_dir

    # define directories    
    local stash_dir="${stashes_dir}/${timestamp}"
    mkdir -pv $stash_dir
    local adds_dir=$stash_dir/adds
    local deletes_dir=$stash_dir/deletes
    local untrackeds_dir=$stash_dir/untrackeds
    local mods_dir=$stash_dir/mods

    # create directories 
    mkdir -vp $adds_dir/files
    mkdir -vp $untrackeds_dir/files
    mkdir -v $deletes_dir
    mkdir -vp $mods_dir/files
    
    # note svn url 
    local svn_info_url=$(svn info | grep -oP "(?<=URL:\s).*$")
    echo $svn_info_url >> $stash_dir/$svn_info_filename    
    
    IFS=$
    local stat=$(svn st)
    local entry

    # 	
    local untracked_files=
    local add_count=0
    local mod_count=0
    local delete_count=0
    local untracked_count=0
    
    for entry in $(echo $stat | cat -vte)
    do
	# returns M, L, !, C, D, A, ?, or whatever        
	local stat_type=$(echo $entry | grep -oP "^[^\s]+")

        # returns everything after $stat_type & all the white space up to it
	local path_to_file=$(echo $entry | grep -oP "(?<=\s)[^\s].*$")
        
	case $stat_type in
	    [\!LC] )
		echo "stat_type of $stat_type suggests a screwed up workspace"
		echo $stat
		return 1
		;;
	    A )                
                # add current file to "add list"                
                echo "$add_count$__file_number_separator$path_to_file" >> $adds_dir/filepaths.list
                cp $path_to_file $adds_dir/files/$add_count
                add_count=$((add_count+1))
		;;
	    D )
                # add current file to "delete list"
                echo $path_to_file >> $deletes_dir/filepaths.list
		;;
            M )
                # add current file to "modified list"
                echo "$mod_count$__file_number_separator$path_to_file" >> $mods_dir/filepaths.list
                cp $path_to_file $mods_dir/files/$mod_count
                mod_count=$((mod_count+1))
                ;;
	    * )
                # add current file to "untracked list"
		echo "$untracked_count$__file_number_separator$path_to_file" >> $untrackeds_dir/filepaths.list
                cp $path_to_file $untrackeds_dir/files/$untracked_count
                untracked_files="${untracked_files} ${path_to_file}"
                untracked_count=$((untracked_count+1))
		;;
	esac
    done
    
    unset IFS
    svn revert -R $cwd
    for untracked_file in $untracked_files; do
        rm -fv $untracked_file;
    done
    for f in "$(svn st | grep '?')"; do
        rm -fv $(echo $f | sed -E 's@.\s@@g')
    done
}

