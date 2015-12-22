# dotfile

Setting files for development use.

# Usage

Clone into your home directory by:

```
$ git clone https://github.com/yumatsuzawa/dotfile.git
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

Obviously vim settings. Source it from `.vimrc`

```
source ~/dotfile/vimrc
```

Requires https://github.com/Shougo/neobundle.vim. Install it then use vim.
