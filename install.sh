#!/usr/bin/env bash
set -euo pipefail

#
# devcontainer個人カスタマイズスクリプト
#

if [ "$REMOTE_CONTAINERS" != "true" ]; then
  echo "This script is meant to be used inside VSCode devcontainer!"
  exit 1
fi

if ! which make; then
  # makeは流石に入っててくれないと困る
  echo "make missing!!! Request devcontainer owner to include make in the image."
  exit 1
fi

if which fish; then
  # fishがoptional featureでインストールされてるときの設定
  sudo chsh -s "$(which fish)" "$USER"
  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
  ln -s ~/hiden/config.fish ~/.config/fish/config.fish
  make fish_plugins
fi
