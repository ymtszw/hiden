#!/usr/bin/env bash
# Generic directories and useful Elixir deps
# Discard errors since warnings for nonexisting directories cannot be suppressed in Exuberant ctags
NAME=$(git rev-parse --abbrev-ref HEAD); # branch name, or "HEAD"
if [ "$NAME" == "HEAD" ] ; then
  # During rebase
  exit 0
else
  ctags --exclude=priv -R \
    app/ src/ lib/ web/ spec/ test/ script/ scripts/ core/ eal/ local/ \
    deps/antikythera/ deps/croma/ deps/plug/ deps/phoenix/ \
    2> /dev/null
fi
