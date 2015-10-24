# dotfile

Unix environment settings for development use.

# Usage

Clone into your home directory by:

```
$ git clone https://github.com/yumatsuzawa/dotfile.git
```

## bashrc

Useful settings for Bash, includes many aliases. Source it from `.bashrc` like this:

```
source ~/dotfile/bashrc
```

Requires mernen/completion-ruby, jimeh/git-aware-prompt and rbenv. Install them, then reload your `.bashrc`.

## inputrc

Alternate your terminal input behavior like case-insensitive path completion. Include from `.inputrc` like this:

```
source ~/dotfile/inputrc
```

Then restart your shell.

## vimrc

Obviously vim settings. Source it from `.vimrc`

```
source ~/dotfile/vimrc
```

Requires https://github.com/Shougo/neobundle.vim. Install it then use vim.
