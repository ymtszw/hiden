#!/usr/bin/env fish

source "$HOME/.asdf/asdf.fish"
# Also copy completion file under ~/.config/fish/completions

# Aliases/Functions

abbr cdu 'cd ..'
abbr ll 'ls -lha'
abbr a. 'atom .'
abbr cdu 'cd ..'
abbr cd. 'cd ..'
abbr cdh 'cd ~/hiden'
abbr cdw 'cd ~/workspace'
abbr cdd 'cd ~/workspace/dodai'
abbr cds 'cd ~/workspace/antikythera'
abbr cda 'cd ~/workspace/antikythera'
abbr gs 'git status'
abbr gg 'git grep'
abbr gd 'git diff'
abbr gsu 'git --no-pager diff --stat'
abbr gc 'git commit --interactive --verbose'
abbr gcs 'git commit --gpg-sign --interactive --verbose'
abbr gpu 'git push'
abbr gl 'git log --graph --all --oneline --decorate --boundary'
abbr ghe 'git checkout'
abbr gma 'git checkout master'
abbr gf 'git fetch'
abbr gip 'git pull --prune'
abbr ger 'git merge'
abbr gua 'git merge --squash'
abbr gom 'git commit'
abbr goms 'git commit --gpg-sign'
abbr gba 'git rebase'
abbr ga 'git add'
abbr gai 'git add --interactive'
abbr grev 'git diff master...HEAD' # review current HEAD against its merge-base (branch/diverge point) from master
abbr gpi 'git cherry-pick'
abbr ssr 'sshrc'
abbr sed 'gsed'

function rl -d "Reload fish config"
  source "$HOME/.config/fish/config.fish"
end

function sshrc -d "sshrc with ssh like completions" --wraps "ssh"
  /usr/local/bin/sshrc $argv
end

# Import common settings

source "$HOME/hiden/shrc.sh"

# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
[ -f ~/.config/yarn/global/node_modules/tabtab/.completions/yarn.fish ]; and . ~/.config/yarn/global/node_modules/tabtab/.completions/yarn.fish
