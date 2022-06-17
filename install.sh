#!/usr/bin/env bash
set -euo pipefail

#
# devcontainer個人カスタマイズスクリプト
#

echo "Customizing devcontainer..."

if [ "$REMOTE_CONTAINERS" != "true" ]; then
  echo "This script is meant to be used inside VSCode devcontainer!"
  exit 1
fi

# このdevcontainerがrootユーザか否かチェックし、それを元にsudoを使うか分岐
echo "\$USER: $USER"
if [ "$USER" == "root" ]; then
  SUDO=""
else
  SUDO="sudo"
  if ! which "$SUDO"; then
    # 非rootでsudoもなければ好きなツールを自前でインストールする権限が足りないのでdevcontainerの管理者と相談
    echo "sudo missing!!! Request devcontainer owner to include sudo in the image and grant password-less sudoer privilege!"
    exit 1
  fi
fi

# devcontainerはだいたいDebian/Ubuntuベースであると期待し、以下決め打ちでapt-getを使う
"$SUDO" apt-get update

if ! which make; then
  "$SUDO" apt-get install -y make
fi

if ! which curl; then
  "$SUDO" apt-get install -y curl
fi

if ! which fish; then
  "$SUDO" apt-get install -y fish
fi

# fish config
if [ -f ~/.config/fish/config.fish ]; then
  rm ~/.config/fish/config.fish
fi
make ~/.config/fish/config.fish
make ~/.config/fish/functions/fisher.fish # fisherを実際に呼び出すインストールが何故かdotfilesスクリプトの中だと成功しないので、fisher installは起動後に手動でやる
make fish_plugins
"$SUDO" chsh -s "$(which fish)" "$USER"

# vim config
make vim

echo "Done!"
