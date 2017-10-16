# Common settings for shells that support bashism

source "$HOME/dotfile/shrc.sh"

[ -e "$HOME/.pythonrc" ] && export PYTHONSTARTUP=~/.pythonrc

source "$HOME/.asdf/asdf.sh"
source "$HOME/.asdf/completions/asdf.bash" # Compatible for Bash/Zsh
source <(npm completion)
[ -f /Users/yumatsuzawa/.travis/travis.sh ] && source /Users/yumatsuzawa/.travis/travis.sh

[ -x "$(which colordiff)" ] && alias diff='colordiff -u'

# Aliases/Functions

alias cdu='cd ..'
alias ll='ls -lha'
alias a.='atom .'
alias cdu='cd ..'
alias cd.='cd ..'
alias cdw='cd ~/workspace'
alias cddodai='cd ~/workspace/dodai'
alias cdsolomon='cd ~/workspace/solomon'
alias gstat='git status'
alias ggrep='git grep'
alias gg='git grep'
alias gdiff='git diff'
alias gd='git diff'
alias gsumm='git --no-pager diff --stat'
alias gcomm='git commit --interactive --verbose'
alias gc='git commit --interactive --verbose'
alias gpush='git push'
alias gtree='git log --graph --all --oneline --decorate --boundary'
alias glog='git log --graph --all --oneline --decorate --boundary'
alias gl='git log --graph --all --oneline --decorate --boundary'
alias gheck='git checkout'
alias gmast='git checkout master'
alias gfetc='git fetch'
alias gipul='git pull --prune'
alias gerge='git merge'
alias guash='git merge --squash'
alias gommit='git commit'
alias gbase='git rebase'
alias gadd='git add'
alias ga='git add'
alias gpick='git cherry-pick'
alias gaddi='git add --interactive'

# review current HEAD against its merge-base (branch/diverge point) from master
grev() {
  git diff "$@" master...HEAD
}
