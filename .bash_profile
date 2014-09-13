source ~/perl5/perlbrew/etc/bashrc
export HARNESS_PERL_SWITCHES=-MDevel::Cover
alias cd..="cd \$(\dirname \$PWD)"
export LSCOLORS='Exfxcxdxcxegedabagacad'
alias webcam="sudo killall VDCAssistant"
alias l="ls -lFha"
alias ls="ls -G"

alias gc="git checkout"
alias gco="git commit";
alias gcb="git rev-parse --abbrev-ref HEAD 2> /dev/null"
alias gpb="git push -u origin `gcb`"
alias gs="git status"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"
alias groot='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"

set meta-flag on
set input-meta on
set output-meta on
set convert-meta off

alias grep='grep --color=auto'
alias x='kill -9 0'

export EDITOR='vim'

function parse_git_status {
        local gs=`gs -unormal 2> /dev/null | tail -n1`
       ( [[ $gs == *"but"* ]] && echo -e "\x1B[0;33m" ) || ( [[ $gs != *"nothing to commit"* ]] && echo -e "\x1B[0;31m" )
}

function parse_git_branch {
        local gcb=`gcb`
        [[  $gcb != "" ]] && echo $(parse_git_status)' ['$gcb']'
}

export PS1='\h:\[\e[0;32m\]\W \[\e[0;0m\]\u\[\e[0;36m\]\[$(parse_git_branch)\]\[\e[0;0m\]$ '
