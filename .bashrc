#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# https://github.com/fotinakis/bashrc/blob/master/git-autocomplete.sh
# security {
umask 022

alias rm='rm'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
# }

alias ls='ls --color=auto'
alias la='ls -AF'
alias ll='ls -lh'
alias mk='mkdir -p'

alias ,='cd'
alias ..='cd ..'
alias ...='cd ../..'
alias sh='cd $HOME/sh'
alias src='cd $HOME/src'

editor() {
    if [ -x "$(which emacs 2>/dev/null)" ]; then
        export EDITOR='emacs -Q -nw'
    elif [ -x "$(which vim 2>/dev/null)" ]; then
        export EDITOR='vim'
    else
        export EDITOR=''
    fi
}

PS1='\u \W\$ '
