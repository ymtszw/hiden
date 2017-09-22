#!/bin/sh
# Generic directories and acs related directories
# Discard errors since warnings for nonexisting directoreis cannot be suppressed in Exuberant ctags
ctags -R \
  app/ src/ lib/ web/ spec/ test/ script/ scripts/ \
  core/ eal/ testgear/lib/ testgear/web/ deps/solomon/ deps/dodai_client_elixir/ deps/croma/ \
  2> /dev/null && echo "Tags indexed."

