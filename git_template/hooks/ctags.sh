#!/bin/sh
# Generic directories and useful Elixir deps
# Discard errors since warnings for nonexisting directories cannot be suppressed in Exuberant ctags
ctags --exclude=priv -R \
  app/ src/ lib/ web/ spec/ test/ script/ scripts/ core/ eal/ local/ \
  deps/antikythera/ deps/croma/ deps/plug/ deps/phoenix/ \
  2> /dev/null

