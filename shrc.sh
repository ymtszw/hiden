# Common settings for various shells; source at last of .***shrc

# PATH

export PATH="/usr/local/bin/:$PATH"
export PATH="/usr/share/mongodb/mongodb-osx-x86_64-3.0.3/bin/:$PATH"
export PATH="/usr/share/play/activator-1.3.2-minimal/:$PATH"
export PATH="/usr/share/scala/scala-2.11.6/bin/:$PATH"
export PATH="/usr/share/dmd/dmd2/osx/bin/:$PATH"
export PATH="/usr/share/dub/:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.mix/escripts:$PATH"
export PATH="/opt/activator-1.3.12-minimal/bin/:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/bin:$PATH"
[ -d "/opt/mongo/bin" ] && export PATH="/opt/mongo/bin:$PATH"
[ -e "$HOME/.pythonrc" ] && export PYTHONSTARTUP=~/.pythonrc

# Other exports

export LESS='-g -i -M -R -S -W -z-4 -x2'
export PAGER=less
export ERL_AFLAGS="-kernel shell_history enabled"

# Sources

source "$HOME/.asdf/asdf.sh"
[ -f /Users/yumatsuzawa/.travis/travis.sh ] && source /Users/yumatsuzawa/.travis/travis.sh
source <(npm completion)

# Aliases/Functions

[ -x "$(which colordiff)" ] && alias diff='colordiff -u'
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
