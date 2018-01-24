MAKEFLAGS += --no-print-directory
SHELL = bash

.PHONY: all
all: check_requirements install_stuff ;

.PHONY: check_requirements
check_requirements:
ifeq ($(shell uname), Darwin)
	@# macOS detected
	@which -s curl git
else
	@echo "Only supports macOS"
	@exit 1
endif

.PHONY: install_stuff
install_stuff: brew /Applications/iTerm.app asdf fish atom vim install_fonts misc ;

.PHONY: brew
brew: /usr/local/bin/brew brew_packages ;

/usr/local/bin/brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

.PHONY: brew_packages
brew_packages:
	brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc ctags jq | true # Continue if already installed

# It will upgrade itself to the latest version, after first boot
LATEST_ITERM_ZIP = iTerm2-3_1_5.zip
/Applications/iTerm.app:
	curl -O https://iterm2.com/downloads/stable/$(LATEST_ITERM_ZIP)
	unzip -q $(LATEST_ITERM_ZIP)
	sudo mv iTerm.app /Applications/.
	rm $(LATEST_ITERM_ZIP)

.PHONY: asdf
asdf: ~/.asdf/bin/asdf ~/.config/fish/completions/asdf.fish asdf_plugins ;

~/.asdf/bin/asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.1 # Can be upgraded by git-pull

~/.config/fish/completions/asdf.fish:
	mkdir -p ~/.config/fish/completions
	ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions/asdf.fish

ASDF_WITHOUT_PATH = ~/.asdf/bin/asdf
asdf_plugins:
	@# Continue if already installed
	$(ASDF_WITHOUT_PATH) plugin-add erlang | true
	$(ASDF_WITHOUT_PATH) plugin-add elixir | true
	$(ASDF_WITHOUT_PATH) plugin-add elm | true
	$(ASDF_WITHOUT_PATH) plugin-add ruby | true
	$(ASDF_WITHOUT_PATH) plugin-add nodejs | true

.PHONY: fish
fish: /usr/local/bin/fish ~/.config/fish/functions/fisher.fish ~/.config/fish/config.fish fish_plugins ;

/usr/local/bin/fish:
	brew install fish

~/.config/fish/functions/fisher.fish:
	curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

~/.config/fish/config.fish:
	ln -s ~/hiden/config.fish ~/.config/fish/config.fish

.PHONY: fish_plugins
fish_plugins:
	fish -c "fisher fzf aws docker-completion ymtszw/theme-agnoster"

.PHONY: atom
atom: /Applications/Atom.app atom_config atom_packages_init ;

ATOM_ZIP = atom-mac.zip
/Applications/Atom.app:
	curl -Lo $(ATOM_ZIP) https://atom.io/download/mac
	unzip -q $(ATOM_ZIP)
	sudo mv Atom.app /Applications/.
	rm $(ATOM_ZIP)

.PHONY: atom_config
atom_config:
	ln -Fs ~/hiden/.atom/styles.less ~/.atom/styles.less
	ln -Fs ~/hiden/.atom/keymap.cson ~/.atom/keymap.cson
	ln -Fs ~/hiden/.atom/snippets.cson ~/.atom/snippets.cson
	ln -Fs ~/hiden/.atom/config.cson ~/.atom/config.cson

# Check the most fundamental package. If not exist, perform init install
.PHONY: atom_packages_init
atom_packages_init: ~/.atom/packages/linter ;

~/.atom/packages/linter:
	@# apm commands may need to be absolute path before first boot
	@# This is rather heavy action; better do it one by one, or create more "smart" install script
	apm install --package-file atom_packages.txt | true # Git packages won't install automatically
	apm uninstall language-elixir | true
	apm install ymtszw/language-elixir-with-croma
	apm uninstall language-elm | true
	apm install ymtszw/language-elm

# This might someday be revisited; neovim and dein.vim are gaining power today
.PHONY: vim
vim: ~/.vim/bundle/neobundle.vim ~/.vimrc ;

~/.vim/bundle/neobundle.vim:
	curl -O https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh
	./install.sh
	rm install.sh

~/.vimrc:
	ln -s ~/hiden/.vimrc ~/.vimrc

.PHONY: install_fonts
install_fonts: ~/Library/Fonts/Source\ Code\ Pro\ for\ Powerline.otf ~/Library/Fonts/migmix-2m-bold.ttf ;

~/Library/Fonts/Source\ Code\ Pro\ for\ Powerline.otf:
	git clone https://github.com/powerline/fonts
	fonts/install.sh "Source Code Pro for Powerline"
	rm -rf fonts

LATEST_MIGMIX = migmix-2m-20150712
~/Library/Fonts/migmix-2m-bold.ttf:
	curl -O http://jaist.dl.osdn.jp/mix-mplus-ipa/63544/$(LATEST_MIGMIX).zip
	unzip -q $(LATEST_MIGMIX).zip
	cp $(LATEST_MIGMIX)/migmix-2m-*.ttf ~/Library/Fonts/.
	rm -rf $(LATEST_MIGMIX)*

.PHONY: misc
misc: ~/.ctags ~/.vimrc ~/.config/git/ignore git_template ;

~/.ctags:
	ln -s ~/hiden/.ctags ~/.ctags

~/.config/git/ignore:
	mkdir -p ~/.config/git
	ln -s ~/hiden/gitignore_global ~/.config/git/ignore

.PHONY: git_template
git_template:
	git config --global core.excludesFile ~/.hiden/git
