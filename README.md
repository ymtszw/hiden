# hiden -- 秘伝

Bunch of my personal configurations/convenient scripts for development environments.

"秘伝" stands for "book of secret arts".

## Components

- Installs fonts
  - [Source Code Pro for Powerline font](https://github.com/powerline/fonts) for terminal
  - [MigMix 2M font](http://mix-mplus-ipa.osdn.jp/migmix/) for editor UI
- Using [`fish`](https://github.com/fish-shell/fish-shell)
  and [`fisherman`](https://github.com/fisherman/fisherman) package manager
- Using [`mise`](https://github.com/jdx/mise) as runtime manager
- Utilizing [git template](https://git-scm.com/docs/git-init#_template_directory)
  and [git global ignore config (core.excludesFile)](https://git-scm.com/docs/git-config#git-config-coreexcludesFile)
- Also installs some other utility programs, has convenient scripts and Vim configurations

## Installation

Currently only supports macOS.

```sh
git clone https://github.com/ymtszw/hiden.git ~/hiden
cd ~/hiden
make
```

And set "Load preferences from a custom folder or URL: ~/hiden/iterm2" in iTerm2.

Just re-invoke `make` to pull latest changes.

## SSH Configs and [sshrc]

Since OpenSSH 7.3 (which is met by latest macOS's default `/usr/bin/ssh`), `ssh_config` can `Include` other config files.

With hiden, `~/.ssh/config` file will be initialized to `Include` files matching a pattern `~/.ssh/config.*`,
so you can add any environment/machine specific `ssh_config`s in local files such as `~/.ssh/config.local`,
without contaminating them with remote `ssh_config`s.

Also, hiden installs [sshrc] to the environment, which allows transporting
various dot-files with you when you SSH to any server with `openssl` installed.

[sshrc]: https://github.com/Russell91/sshrc
