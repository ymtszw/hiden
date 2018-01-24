## bashrc

Settings for Bash, includes many aliases. Source it from `.bashrc` like this:

```
source ~/dotfile/bashrc
```

Requires https://github.com/mernen/completion-ruby, https://github.com/jimeh/git-aware-prompt and rbenv. Install them, then reload your `.bashrc`.

## zshrc

```
git clone --recursive https://github.com/Eriner/zim.git ${ZDOTDIR:-${HOME}}/.zim
ln -s ~/dotfile/zshrc .zshrc
```

Expects OSX. Using [Zim](https://github.com/Eriner/zim).

## config.fish

```
ln -s ~/dotfile/config.fish ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions
ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions/asdf.fish
```

Many completions are included by default. Though aws-cli [not yet](https://github.com/aws/aws-cli/issues/1079).

## inputrc

Alternate your terminal input behavior like case-insensitive path completion. Include from `.inputrc` like this:

```perl
$include ~/dotfile/inputrc
```

Then restart your shell.

## vimrc

Source it from `.vimrc`

```
source ~/dotfile/vimrc
```

Requires https://github.com/Shougo/neobundle.vim. Install it then use vim.

## Git template

```
$ ln -s ~/dotfile/git ~/.git_template
$ git conifg --global init.templatedir '~/.git_template'
```

## Git global ignore
```
$ git config --global core.excludesfile '~/dotfile/gitignore_global'
```
