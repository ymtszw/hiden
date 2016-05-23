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
source /usr/local/etc/completion-ruby/completion-ruby-all

export PATH="/usr/share/mongodb/mongodb-osx-x86_64-3.0.3/bin/:$PATH"
export PATH="/usr/share/play/activator-1.3.2-minimal/:$PATH"
export PATH="/usr/share/scala/scala-2.11.6/bin/:$PATH"
export PATH="/usr/share/dmd/dmd2/osx/bin/:$PATH"
export PATH="/usr/share/dub/:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"

[ -d "/opt/mongo/bin" ] && export PATH="/opt/mongo/bin:$PATH"

export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
source "$HOME/.asdf/asdf.sh"
source "$HOME/.asdf/completions/asdf.bash"

# bash options
#shopt -s autocd # need Bash4.0
shopt -s cdspell
shopt -s dotglob
shopt -s extglob
#shopt -s globstar # need Bash4.0

# rbenv
eval "$(rbenv init -)"


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f /Users/yumatsuzawa/.travis/travis.sh ] && source /Users/yumatsuzawa/.travis/travis.sh

# aliases and completions
[ -e ~/bin/ssh ] && alias ssh='~/bin/ssh'
[ -x `which colordiff` ] && alias diff='colordiff -u'
alias ll='ls -lha'
alias gstat='git status'
alias ggrep='git grep'
alias gdiff='git diff'
alias gcomm='git commit --interactive --verbose'
alias gpush='git push'
alias gtree='git log --graph --all --oneline --decorate=full'
alias glog='gtree'
alias gheck='git checkout'
alias gfetc='git fetch'
alias gfetch='gfetc'
alias gipul='git pull'
alias gipull='git pull'
alias gmerg='git merge'
alias gmerge='git merge'
alias gerge='git merge'
alias guash='git merge --squash'
alias gommit='git commit'
alias gbase='git rebase'
alias gadd='git add'
alias gpick='git cherry-pick'
__git_complete gstat _git_stat
__git_complete ggrep _git_grep
__git_complete gdiff _git_diff
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

# prompt
export PS1="\[\e[1;4m\][\t]\[\e[0m\][\u@\h \w]\[\e[0m\]\n\[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
