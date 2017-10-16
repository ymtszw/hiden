#!/usr/bin/env fish

source "$HOME/.asdf/asdf.fish"
# Also copy completion file under ~/.config/fish/completions

# Aliases/Functions

abbr cdu 'cd ..'
abbr ll 'ls -lha'
abbr a. 'atom .'
abbr cdu 'cd ..'
abbr cd. 'cd ..'
abbr cdw 'cd ~/workspace'
abbr cdd 'cd ~/workspace/dodai'
abbr cds 'cd ~/workspace/solomon'
abbr gs 'git status'
abbr gg 'git grep'
abbr gd 'git diff'
abbr gsumm 'git --no-pager diff --stat'
abbr gc 'git commit --interactive --verbose'
abbr gpush 'git push'
abbr glog 'git log --graph --all --oneline --decorate --boundary'
abbr gl 'git log --graph --all --oneline --decorate --boundary'
abbr gheck 'git checkout'
abbr gmast 'git checkout master'
abbr gfetc 'git fetch'
abbr gipul 'git pull --prune'
abbr gerge 'git merge'
abbr guash 'git merge --squash'
abbr gommit 'git commit'
abbr gbase 'git rebase'
abbr ga 'git add'
abbr gpick 'git cherry-pick'
abbr gaddi 'git add --interactive'
# review current HEAD against its merge-base (branch/diverge point) from master
function grev
  git diff $argv master...HEAD
end


# Import common settings

source "$HOME/dotfile/shrc.sh"
