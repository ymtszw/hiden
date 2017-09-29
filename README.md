# dotfile

Prepare various files for new environment.

# Usage

Clone into your home directory by:

```
$ git clone https://github.com/ymtszw/dotfile.git ~/dotfile
```

## bashrc

Settings for Bash, includes many aliases. Source it from `.bashrc` like this:

```
source ~/dotfile/bashrc
```

Requires https://github.com/mernen/completion-ruby, https://github.com/jimeh/git-aware-prompt and rbenv. Install them, then reload your `.bashrc`.

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
