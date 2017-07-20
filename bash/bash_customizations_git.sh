#!/bin/bash

bind '"\eG"':"\"\C-ugit status .\C-m\""

alias g=git
# --format=format:%an
alias gl="git log --oneline --abbrev-commit  --graph --decorate --color"
alias gg="git grog"
alias gga="git grog-all"
alias gs="git shorty ."
alias gb="git branch"
alias gco="git commit"
alias gd="git diff"
alias gds="git diff --staged"
alias gc="git checkout"

###############################################
# https://gist.github.com/michaelkirk/2596181 #
###############################################
function git-show-remote-branches {
    for k in $(git branch -r | awk '{print $1}'); do
        echo -e $(git show --pretty=format:"%Cgreen%ci %Cblue%cr\\t%Cred%cn %Creset" $k | head -n 1)\\t$k
    done | sort -r
}

function git-show-local-branches {
    for k in $(git branch -a | awk '{print $1}'); do
        echo -e $(git show --pretty=format:"%Cgreen%ci %Cblue%cr\\t %Cred%cn %Creset" $k | head -n 1)\\t$k
    done | sort -r
}

function git-shallow-clone {
    local repo="$1"
    local branch="$2"

    git clone $repo --branch $branch --single-branch --depth 1
}

function git-log-diff-merges {
    local path="$1"
    git log --full-diff -c --merges -p $path
}

function git-log-diff {
    local path="$1"
    git log --full-diff -c -p $path
}
