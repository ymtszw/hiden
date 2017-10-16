# OS/env specific configs
if [ "$(uname)" = "Darwin" ] # OSX
then
  alias ls='ls -G'
  source /usr/local/etc/bash_completion
  [ -e /usr/local/git/contrib/completion/git-completion.bash ] && source /usr/local/git/contrib/completion/git-completion.bash
  export PATH="$HOME/.stack/programs/x86_64-osx/ghc/bin:$PATH"
else
  alias ls='ls --color=auto'
  source /etc/bash_completion
  source /usr/share/bash-completion/completions/git
fi

export PATH="/usr/local/bin/:$PATH"
export PATH="/usr/share/mongodb/mongodb-osx-x86_64-3.0.3/bin/:$PATH"
export PATH="/usr/share/play/activator-1.3.2-minimal/:$PATH"
export PATH="/usr/share/scala/scala-2.11.6/bin/:$PATH"
export PATH="/usr/share/dmd/dmd2/osx/bin/:$PATH"
export PATH="/usr/share/dub/:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.mix/escripts:$PATH"
export PATH="/opt/activator-1.3.12-minimal/bin/:$PATH"
export PATH="$HOME/bin:$PATH"

[ -d "/opt/mongo/bin" ] && export PATH="/opt/mongo/bin:$PATH"
[ -e "$HOME/.pythonrc" ] && export PYTHONSTARTUP=~/.pythonrc

export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
source "$HOME/.rbenv/completions/rbenv.bash"
source "$HOME/.asdf/asdf.sh"
source "$HOME/.asdf/completions/asdf.bash"
source "/usr/local/etc/completion-ruby/completion-ruby-all"
source "/usr/local/etc/pip-bash-completion/pip"
complete -C "/usr/local/bin/aws_completer" aws
source "$HOME/dotfile/npm-completion.bash"


# bash options
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=100000
## Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
shopt -s autocd # need Bash4.0
shopt -s cdspell
shopt -s dotglob
shopt -s extglob
shopt -s globstar # need Bash4.0
shopt -s histappend

# Erlang kernel options
export ERL_AFLAGS="-kernel shell_history enabled"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f /Users/yumatsuzawa/.travis/travis.sh ] && source /Users/yumatsuzawa/.travis/travis.sh

# aliases and completions
[ -x `which colordiff` ] && alias diff='colordiff -u'
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
alias gdiff='git diff'
alias gsumm='git --no-pager diff --stat'
alias gcomm='git commit --interactive --verbose'
alias gpush='git push'
alias gtree='git log --graph --all --oneline --decorate --boundary'
alias glog='gtree'
alias gheck='git checkout'
alias gmast='git checkout master'
alias gfetc='git fetch'
alias gfetch='gfetc'
alias gipul='git pull --prune'
alias gipull='git pull --prune'
alias gmerg='git merge'
alias gmerge='git merge'
alias gerge='git merge'
alias guash='git merge --squash'
alias gommit='git commit'
alias gbase='git rebase'
alias gadd='git add'
alias gpick='git cherry-pick'
alias gaddi='git add --interactive'
__git_complete gstat _git_stat
__git_complete ggrep _git_grep
__git_complete gdiff _git_diff
__git_complete gsumm _git_diff
__git_complete gcomm _git_commit
__git_complete gpush _git_push
__git_complete gtree _git_log
__git_complete gheck _git_checkout
__git_complete gfetc _git_fetch
__git_complete gfetch _git_fetch
__git_complete gipul _git_pull
__git_complete gipull _git_pull
__git_complete gmerg _git_merge
__git_complete gmerge _git_merge
__git_complete gerge _git_merge
__git_complete guash _git_merge
__git_complete gommit _git_commit
__git_complete gbase _git_rebase
__git_complete gadd _git_add
__git_complete gpick _git_cherry_pick

# review current HEAD against its merge-base (branch/diverge point) from master
grev() {
  git diff $@ master...HEAD
}
__git_complete grev _git_diff

# prompt
export PS1="\[\e[1;4m\][\t]\[\e[0m\][\u@\h \w]\[\e[0m\]\n\[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# less option
export LESS='-g -i -M -R -S -W -z-4 -x2'
# use less as pager
export PAGER=less
