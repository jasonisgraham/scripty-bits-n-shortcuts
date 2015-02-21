#!/bin/bash

function create_emacs_tags {
    local extensions=$(echo "$1" | sed 's/,/\\|/g')
    local tag_dir=$2
    find . | grep ".*\.\(${extensions}\)" | grep -v ".svn" | grep -v "~$" | xargs etags -f $tag_dir
}
