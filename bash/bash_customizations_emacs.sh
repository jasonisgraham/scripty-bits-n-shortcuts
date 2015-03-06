#!/bin/bash

function create_emacs_tags {
    ## create_emacs_tags sh,sc,cp,sql,rw ~/.emacs.d/TAGS
    local extensions=$(echo "$1" | sed 's/,/\\|/g')
    local tag_dir=$2
    find . | grep ".*\.\(${extensions}\)" | grep -v ".svn" | grep -v "~$" | xargs etags -f $tag_dir
}
