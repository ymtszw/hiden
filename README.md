# hiden -- 秘伝

Bunch of my personal configurations/convenient scripts for development environments.

"秘伝" stands for "book of secret arts".

# Components

- Using [iTerm2](https://www.iterm2.com/)
    - Using [Source Code Pro for Powerline font](https://github.com/powerline/fonts)
- Using [`fish`](https://github.com/fish-shell/fish-shell)
  and [`fisherman`](https://github.com/fisherman/fisherman) package manager
    - Using [fork of theme-agnoster](https://github.com/ymtszw/theme-agnoster)
- Using [`atom`](https://atom.io/)
    - Using [MigMix 2M font](http://mix-mplus-ipa.osdn.jp/migmix/)
- Using [`asdf`](https://github.com/asdf-vm/asdf) as language versions manager
- Utilizing [`ctags`](http://ctags.sourceforge.net/)
- Utilizing [git template](https://git-scm.com/docs/git-init#_template_directory)
  and [git global ignore config (core.excludesFile)](https://git-scm.com/docs/git-config#git-config-coreexcludesFile)
- Also installs some other utility programs, has convenient scripts and Vim configurations


# Installation

```
$ git clone https://github.com/ymtszw/hiden.git ~/hiden
$ cd hiden
$ make
```

Just re-invoke `make` to pull latest changes.

Currently only supports macOS.
