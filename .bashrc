# ~/.bashrc

# If not running interactively, don't do anything{
[[ $- != *i* ]] && return
#}

# https://github.com/fotinakis/bashrc/blob/master/git-autocomplete.sh
# security{
umask 022

alias rm='rm'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
#}

alias ls='ls --color=auto'
alias la='ls -AF'
alias ll='ls -lh'

alias ,='cd'
alias ..='cd ..'
alias ...='cd ../..'
alias src='cd $HOME/src'
alias doc='cd $HOME/doc'
alias sh='cd $HOME/sh'

alias rmd='rm -rd'
alias mkd='mkdir -p'

# pacman access{
alias pacman='sudo pacman'
alias psyu='pacman -Syu'
alias pss='pacman -Ss'
alias pr='pacman -R'
alias msi='makepkg -si'
#}

# network{
alias myip="_myip | awk NF"
#}

# functions{
editor() {
    if [ -x "$(which emacs 2>/dev/null)" ]; then
        export EDITOR='emacs -Q -nw'
    elif [ -x "$(which vim 2>/dev/null)" ]; then
        export EDITOR='vim'
    else
        export EDITOR=''
    fi
}

conf() {
    [ -z "$EDITOR" ] && editor
    $EDITOR "$@";
}

mkcd () {
  mkdir -p -- "$1" && cd -P -- "$1"
}

_myip() {
    ip route get 1.2.3.4 | awk '{print $7}'
    #ip a | grep "inet" | awk -F " " '{print $2}' | tail -2
    dig +short myip.opendns.com @resolver1.opendns.com
}
#}

# systemd access{
if [ -x "$(which systemctl 2>/dev/null)" ]; then
    sstart() { sudo systemctl start $1.service; }
    sstop() { sudo systemctl stop $1.service; }
    senable() { sudo systemctl enable $1.sercice; }
    sdisable() { sudo systemctl disable $1.service; }
fi
#}

#${S:+"ss"}

# PS prompt{
PS1='\u \W\$ '
#}
