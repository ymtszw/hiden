#!/bin/sh
# Common settings for various shells

# PATH

export PATH="/usr/local/sbin/:$PATH"
export PATH="/usr/local/bin/:$PATH"
export PATH="$HOME/.mix/escripts:$PATH"
export PATH="$HOME/bin:$PATH"

# Other exports

export LESS='-g -i -M -R -S -W -z-4 -x2'
export PAGER=less
export ERL_AFLAGS="-kernel shell_history enabled"
