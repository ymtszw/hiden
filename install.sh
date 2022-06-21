#!/usr/bin/env bash
set -euo pipefail

#
# devcontainer個人カスタマイズ用スクリプト
#
#
# Usage:
#
# * VSCodeのホスト側User設定で: Remote > Containers > Dotfilesに属する3項目を設定しておく
# * devcontainerに対応している作業対象のrepositoryをcloneし、"Reopen in Container"する
# * 詳しくは公式doc参照
#   * https://code.visualstudio.com/docs/remote/containers#_personalizing-with-dotfile-repositories
#
#
# Tips:
#
# * [追加VSCode拡張] devcontainer内部でこのスクリプトが実行されるのだが、VSCode側での実行順序の都合上、
#   `code` CLIがこのスクリプトから利用できない模様（2022/06現在）
#   * `code --install-extension`で好みのVSCode拡張をインストールしたかったが…
#   * 結局、devcontainer立ち上げ完了後、ターミナルから手動で`cd ~/hiden; make vscode_extensions`している
# * [Fishプラグイン] fishermanをインストールするところまではできるのだが、（`make ~/.config/fish/functions/fisher.fish`参照）
#   なぜか`fish -c "fisher install ..."`と実際にfishermanを`fish -c`経由で呼び出しても成功しない
#   * そこそこ掘ったのだが今のところ原因不明なので、こちらも手動で`cd ~/hiden; make fish_plugins`している
# * [Gitで使うSSH秘密鍵] 予めホスト側のssh-agentで`ssh-add ~/.ssh/id_ecdsa`のように追加しておいてからdevcontainerを立ち上げれば、
#   VSCodeがその秘密鍵をdevcontainerに持ち込んでくれるので、SSHプロトコルでそのままgitを利用できる
#   * 一方、Windowsホストの場合など、ホスト側でssh-agentが使いづらいときはHTTPSプロトコルでgitを利用したほうが良い
#   * git remoteとしてHTTPS URLが使用されている場合、VSCodeが管理する認証状態がdevcontainer内からのgit操作にも適用されるため
#     * GitHubのrepositoryは少なくともこれに対応しているが、GitLab/BitBucketは不明（試してない and 調べてない）
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
  if ! which sudo; then
    # 非rootでsudoもなければ好きなツールを自前でインストールする権限が足りないのでdevcontainerの管理者と相談
    echo "sudo missing!!! Request devcontainer owner to include sudo in the image and grant password-less sudoer privilege!"
    exit 1
  fi
fi

# devcontainerはだいたいDebian/Ubuntuベースであると期待し、以下決め打ちでaptを使う
# 複数のLinux distributionに対応したければ……頑張れ！
$SUDO apt update

# もともと個人的にMakefileで作成していた環境構築スクリプトを流用しているので、make必須
if ! which make; then
  $SUDO apt install -y make
fi

# 流石にcurlは最初から入っているdevcontainerが多いと思うが、念の為。自前ツールをインストールするときにもcurlを使うことは多い
if ! which curl; then
  $SUDO apt install -y curl
fi

if ! which fish; then
  # 単にapt installすると古いバージョンのfishが降ってくることがある（というか大抵はそう）
  # 厳密にやるならDebian/Ubuntuのバージョンごとに最新のリポジトリを引っ張ってきて登録し、apt updateしてからインストールする必要がある
  # 判定ロジックが面倒なので、チームのdevcontainer自体に予め最新のfishをインストールしてもらうよう掛け合ったほうが早いかも
  $SUDO apt install -y fish
fi

# fish config
if [ -f ~/.config/fish/config.fish ]; then
  rm ~/.config/fish/config.fish
fi
make ~/.config/fish/config.fish
make ~/.config/fish/functions/fisher.fish
make fish_plugins
$SUDO chsh -s "$(which fish)" "$USER"

# vim config
make vim

echo "Done!"
