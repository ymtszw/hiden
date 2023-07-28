#!/usr/bin/env fish

# Aliases/Functions

abbr cdu 'cd ..'
abbr ll 'ls -lha'
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
abbr gdw 'git diff --color-words'
abbr gsu 'git --no-pager diff --stat'
abbr gc 'git commit --interactive --verbose'
abbr gcs 'git commit --gpg-sign --interactive --verbose'
abbr gpu 'git push'
abbr gl 'git log --graph --oneline --decorate --boundary --all'
abbr ghe 'git checkout'
abbr gma "git checkout (git-default-branch); git pull --prune"
abbr gf 'git fetch --prune --prune-tags'
abbr gip 'git pull --prune'
abbr ger 'git merge'
abbr gua 'git merge --squash'
abbr gom 'git commit'
abbr goms 'git commit --gpg-sign'
abbr gba 'git rebase'
abbr ga 'git add'
abbr gai 'git add --interactive'
abbr gap 'git add --patch'
abbr grev 'git diff origin/(git-default-branch)...HEAD' # review current HEAD against its merge-base (branch/diverge point) from master
abbr gpi 'git cherry-pick'
abbr gar 'git apply -R'
alias git-default-branch 'git rev-parse --abbrev-ref origin/HEAD | xargs -n1 basename'
abbr gdef git-default-branch
abbr ssr sshrc

function rl -d "Reload fish config"
    source "$HOME/.config/fish/config.fish"
end

function sshrc -d "sshrc with ssh like completions" --wraps ssh
    /usr/local/bin/sshrc $argv
end

function sync_history --on-event fish_preexec
    history --save
    history --merge
end

source "$HOME/hiden/shrc.sh"
