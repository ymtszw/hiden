# Change default zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Source zim
if [[ -s ${ZIM_HOME}/init.zsh ]]; then
  source ${ZIM_HOME}/init.zsh
fi

zmodules=(directory environment git git-info history input utility meta custom \
            syntax-highlighting history-substring-search prompt completion)

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
