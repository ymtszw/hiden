#!/usr/bin/env bash

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

# Bash specific settings

export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
source "$HOME/.rbenv/completions/rbenv.bash"
source "/usr/local/etc/completion-ruby/completion-ruby-all"
source "/usr/local/etc/pip-bash-completion/pip"
complete -C "/usr/local/bin/aws_completer" aws

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=100000
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
shopt -s autocd # need Bash4.0
shopt -s cdspell
shopt -s dotglob
shopt -s extglob
shopt -s globstar # need Bash4.0
shopt -s histappend

# Bash prompt
export PS1="\[\e[1;4m\][\t]\[\e[0m\][\u@\h \w]\[\e[0m\]\n\[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Completions

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
__git_complete gmerg _git_merge
__git_complete gerge _git_merge
__git_complete guash _git_merge
__git_complete gommit _git_commit
__git_complete gbase _git_rebase
__git_complete gadd _git_add
__git_complete gpick _git_cherry_pick
__git_complete grev _git_diff

# Importing shared settings

source "$HOME/dotfile/shrc.sh"
