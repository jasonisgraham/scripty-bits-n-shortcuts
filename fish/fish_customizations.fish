
#####################
# start theme stuff #
#####################
# name: RobbyRussel
#
# You can override some default options in your config.fish:
#   set -g theme_display_git_untracked no

function _git_branch_name
        echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
        set -l show_untracked (git config --bool bash.showUntrackedFiles)
        set untracked ''
        if [ "$theme_display_git_untracked" = 'no' -o "$show_untracked" = 'false' ]
                set untracked '--untracked-files=no'
        end
        echo (command git status -s --ignore-submodules=dirty $untracked ^/dev/null)
end

function fish_vi_prompt_cm --description "Displays the current mode"
        switch $fish_bind_mode
                case default
                        set_color --bold --background red white
                        echo "[N]"
                case insert
                        set_color --bold --background green white
                        echo "[I]"
                case visual
                        set_color --bold --background magenta white
                        echo "[V]"
        end
        set_color normal
end

function fish_prompt
        set -l last_status $status
        set -l cyan (set_color -o cyan)
        set -l yellow (set_color -o yellow)
        set -l red (set_color -o red)
        set -l blue (set_color -o blue)
        set -l green (set_color -o green)
        set -l normal (set_color normal)

        if test $last_status = 0
                set arrow (fish_vi_prompt_cm)
                # set arrow "$green➜ "
        else
                set arrow "$red➜ "
        end
        set -l cwd $cyan(basename (prompt_pwd))

        if [ (_git_branch_name) ]
                set -l git_branch $red(_git_branch_name)
                set git_info "$blue git:($git_branch$blue)"

                if [ (_is_git_dirty) ]
                        set -l dirty "$yellow ✗"
                        set git_info "$git_info$dirty"
                end
        end

        echo -n -s $arrow ' ' $cwd $git_info $normal ' '
end

#####################
# end theme stuff #
#####################

set fish_greeting
set -x BROWSER (which google-chrome)
set -x EDITOR "emacs"
set -x CLOJURESCRIPT_HOME ~/Programs/clojurescript/

# tell SCREEN to back off when setting TERM to "screen"
set -x TERM xterm-256color

#####################################
# aliases and alias type functions  #
#####################################
alias ls "ls -h --color=always"
alias __BASE_LS_COMMAND "ls -hBF --ignore=.svn --ignore=.git --color=always --group-directories-first"

function l; __BASE_LS_COMMAND; end
function la; __BASE_LS_COMMAND -A; end
function lah; __BASE_LS_COMMAND -Ahg; end
function ll; __BASE_LS_COMMAND -l; end
function lt; __BASE_LS_COMMAND -tAl; end

function ls-only-hidden-dirs
        set -l _dir $argv[1]
        if [ ! "$_dir" ]
                set _dir "."
        end
        __BASE_LS_COMMAND -A --color=never "$_dir" | grep '\/$' | grep '^\.' | sort -u
end

alias irb 'irb --simple-prompt'
alias rm 'rm -i'
alias mv 'mv -i'
alias cp 'cp -i'
alias df 'df -h'
alias du 'du -sh'
alias h 'history | tail'
alias c 'cd-above'
alias run-junit "java -cp .:/usr/share/java/junit4.jar org.junit.runner.JUnitCore"

# sources
alias svn-diff 'svn diff -x -w'

## autojump
. ~/.autojump/share/autojump/autojump.fish


####################################################################
# "useful" functions that are called with the binds from above
# consider these private methods.  It doesn't make a lot of sense
# to use these from the command line
###################################################################
# only display minimal xev information (keypress and keycodes)
function xev-minimal
        xev -event keyboard | grep --color -oP 'keycode.*\)'
end

# sorts single csv line asc
function sort-csv-line
        echo $argv | tr ',' '\n' | sort -u | tr '\n' ','
end

# removes all temp files given a directory
function remove-all-temp-files
        local haystack_dir=$1

        # removes all files ending with a tilde
        find $haystack_dir -name "*~"  -exec rm {} \;

        # beginnging with hash
        find $haystack_dir -name "#*" -exec rm {} \;

        # all .~ directories
        find $haystack_dir -name .~ -type d -exec rm -r {} \;
end

function __move-up-directory
        pushd . >> /dev/null
        cd ../
end

function __move-down-directory
        popd >> /dev/null
end

function cd-above
        set arg $argv[1]
        if [ ! "$arg" ]
	        ## if no arg, go home
	        cd ~
        else
                if [ -d "$arg" -o "$arg" = "-" ]
	                ## if it's already a directory that exists
	                ## or we're trying to just toggle to previous dir, do that
	                cd "$arg"
                else
	                set _dir (echo $arg | sed -r 's@[^\/]+$@@g')
	                if [ -d "$_dir" ]
		                cd $_dir
	                else
		                ## else, autojump to what $1 is
		                j $arg
	                end
                end
        end
end

##################
# start bindings #
##################

function my_vi_key_bindings
        fish_vi_key_bindings

        bind \ca beginning-of-line
        bind -M insert \ca beginning-of-line

        bind \ce end-of-line
        bind -M insert \ce end-of-line

        bind \e. history-token-search-backward
        bind -M insert \e. history-token-search-backward

        bind \el __fish_list_current_token
        bind -M insert \el __fish_list_current_token

        bind \eh __fish_man_page
        bind -M insert \eh __fish_man_page

        bind \eL accept-autosuggestion
        bind -M insert \eL accept-autosuggestion

        bind \e\< -M insert 'pushd . >> /dev/null; cd ../; commandline -f repaint'
        bind \e\< 'pushd . >> /dev/null; cd ../; commandline -f repaint'

        bind \e\> 'popd >> /dev/null; commandline -f repaint'
        bind \e\> -M insert 'popd >> /dev/null; commandline -f repaint'

        # bind '"\e!"' "\"\C-a\C-kla\C-j\""
        # bind '"\e@"' "\"\C-a\C-klt\C-j\""

        bind \ck kill-line
        bind -M insert \ck kill-line

        bind -M insert \en history-search-forward
        bind -M insert \ep history-search-backward

        bind \eS '. ~/.config/fish/config.fish'
        bind \eS -M insert '. ~/.config/fish/config.fish'
        bind \cl 'clear; commandline -f repaint'
        bind -M insert \cl 'clear; commandline -f repaint'
end

set -g fish_key_bindings my_vi_key_bindings
