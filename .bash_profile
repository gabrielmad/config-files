# Perl
source ~/perl5/perlbrew/etc/bashrc
export HARNESS_PERL_SWITCHES=-MDevel::Cover

# Encoding
set meta-flag on
set input-meta on
set output-meta on
set convert-meta off

# History
export HISTCONTROL=erasedup #doesn't save duplicate lines
function hist() {
	( [ -z "$1" ] && history) || history | grep "$@"
}

# Shortcuts
alias cd..="cd .."
export LSCOLORS='Exfxcxdxcxegedabagacad'
alias webcam="sudo killall VDCAssistant"
alias l="ls -lFha"
alias ls="ls -G"
alias grep='grep --color=auto'
alias x='kill -9 0'
alias iossimulator='open /Applications/Xcode.app/Contents/Developer/Applications/iOS\ Simulator.app'


# Editors
export EDITOR='vim'
alias st='open -a "Sublime Text"'

# OS X + brew updates
alias sysupdate='sudo softwareupdate -i -a; brew update; brew upgrade'

# Git
alias gc="git checkout"
alias gco="git commit";
alias gcb="git symbolic-ref HEAD 2> /dev/null | sed -e 's,.*/\(.*\),\1,'"
alias gpb="git push -u origin $(gcb)"
alias gs="git status"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"
alias groot='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias gdiff="git diff"
gcn() {
  local branches=($(gb | grep $1 | tr -d ' |*'))
  local branch

  case ${#branches[@]} in
    0) echo "No branch matching '*$1*' criteria was found"; return;;
    1) branch=$branches
  esac

  if [[ -z $branch ]]; then
    select branch in ${branches[@]};
    do
      break
    done
  fi
  gc $branch
}

# Kubernetes
alias k='kubectl'
alias kget='k get -o wide'
alias kcontext='k config get-contexts'
alias kcc='k config current-context'
alias kuse='k config use-context'
alias kdes='k describe'
alias kci='k cluster-info'
alias kcm='k get configmap -o yaml'
klog() {
  k logs -f `kpod $1`
}
kpod() {
 kget pods | grep $1 | awk '{print $1}'
}
kcontainer() {
 kget deployments | grep $1 | awk '{print $1}'
}
kbash() {
 local pod=`kpod $1`
 local container=`kcontainer $1`
 k exec -it $pod -c $container -- /bin/bash
}

##########################
# PS1 + Git + Kubernetes #
##########################
parse_git_status() {
    local_gs=$(gs -unormal 2> /dev/null | tail -n1; exit ${PIPESTATUS[0]})
    local error=$?
    local gs=$local_gs
    ( [[ $error -ne 0 ]] && echo -e "\x1B\e[92m " ) || ( [[ $gs == *"but"* ]] && echo -e "\x1B[0;33m" ) || ( [[ $gs && $gs != *"nothing to commit"* ]] && echo -e "\x1B[0;31m" )
}

parse_git_branch() {
  local gcb=`gcb`
  [[  $gcb != "" ]] && echo $(parse_git_status)' ['$gcb']'
}

parse_kubernetes_context() {
  local kcc=`kcc`
  [[ $kcc != "" ]] && echo ' ('$kcc')'
}

export PS1='\h:\[\e[0;32m\]\W \[\e[0;0m\]\u\[\e[0;35m\]\[$(parse_kubernetes_context)\]\[\e[0;36m\]$(parse_git_branch 2>/dev/null)\[\e[0;0m\]$ '
