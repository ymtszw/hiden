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
install_stuff: brew /Applications/iTerm.app asdf fish install_fonts ;

.PHONY: brew
brew: /usr/local/bin/brew brew_packages ;

/usr/local/bin/brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

.PHONY: brew_packages
brew_packages:
	brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc | true # Continue if already installed

# It will upgrade itself to the latest version, after first boot
LATEST_ITERM = iTerm2-3_1_5.zip
/Applications/iTerm.app:
	curl -O https://iterm2.com/downloads/stable/$(LATEST_ITERM)
	unzip -q $(LATEST_ITERM)
	sudo mv iTerm.app /Applications/.
	rm $(LATEST_ITERM)

.PHONY: asdf
asdf: ~/.asdf/bin/asdf ~/.config/fish/completions/asdf.fish ;

~/.asdf/bin/asdf:
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.1 # Can be upgraded by git-pull

~/.config/fish/completions/asdf.fish:
	mkdir -p ~/.config/fish/completions
	ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions/asdf.fish

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
