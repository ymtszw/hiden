#!/usr/bin/env zsh

# Change default zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Source zim
if [[ -s ${ZIM_HOME}/init.zsh ]]; then
  source ${ZIM_HOME}/init.zsh
fi

zmodules=(directory environment git git-info history input utility meta custom \
            syntax-highlighting history-substring-search prompt completion)

# Key bindings

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Auto alias expansion

globalias() {
   zle _expand_alias
   zle expand-word
   zle self-insert
}
zle -N globalias
# space expands all aliases, including global
bindkey -M emacs " " globalias
bindkey -M viins " " globalias
# control-space to make a normal space
bindkey -M emacs "^ " magic-space
bindkey -M viins "^ " magic-space
# normal space during searches
bindkey -M isearch " " magic-space

# Completions

source /usr/local/bin/aws_zsh_completer.sh
fpath=(/usr/local/share/zsh-completions $fpath)

# Importing shared settings; overriding some aliases in zsh modules

source "$HOME/dotfile/shrc.sh"
