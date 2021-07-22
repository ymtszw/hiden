MAKEFLAGS += --no-print-directory
SHELL = bash

.PHONY: all
all: check_requirements install_stuff ;

#
# Ensure prerequisites for executing various commands in hiden
#
.PHONY: check_requirements
check_requirements:
	@if [[ "$(abspath $(dir .))" != "$(abspath $(dir ~))" ]]; then echo "hiden must be at ~/hiden !"; exit 1; fi
	@if [[ "$(shell uname)" != "Darwin" ]]; then echo "Only supports macOS"; exit 1; fi
	@which -s curl git

#
# Install stuff!
#
.PHONY: install_stuff
install_stuff: user_bin brew asdf fish vim ssh install_fonts misc ;

### Custom scripts

.PHONY: user_bin
user_bin: ~/bin ~/bin/toggle_id ~/bin/vpn ~/bin/local_git_user ~/bin/imgcat ;

~/bin:
	mkdir -p ~/bin

~/bin/toggle_id:
	ln -Fs ~/hiden/bin/toggle_id ~/bin/toggle_id

~/bin/vpn:
	ln -Fs ~/hiden/bin/vpn ~/bin/vpn

~/bin/local_git_user:
	ln -Fs ~/hiden/bin/local_git_user ~/bin/local_git_user

~/bin/imgcat:
	ln -Fs ~/hiden/bin/imgcat ~/bin/imgcat

### Homebrew related

.PHONY: brew
brew: /usr/local/bin/brew brew_packages ;

/usr/local/bin/brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

.PHONY: brew_packages
brew_packages:
	@# Installing or upgrading already installed ones using `brew bundle`
	@# If `brew bundle`'s automatic installation of Homebrew-bundle fails, try manually git-cloning the Homebrew-bundle repository!
	brew bundle --file=~/hiden/Brewfile

### iTerm2 related

# It will upgrade itself to the latest version, after first boot
LATEST_ITERM_ZIP = iTerm2-3_1_5.zip
/Applications/iTerm.app:
	curl -O https://iterm2.com/downloads/stable/$(LATEST_ITERM_ZIP)
	unzip -q $(LATEST_ITERM_ZIP)
	sudo mv iTerm.app /Applications/.
	rm $(LATEST_ITERM_ZIP)

### asdf related

ASDF_WITHOUT_PATH = ~/.asdf/bin/asdf
.PHONY: asdf
asdf: $(ASDF_WITHOUT_PATH) ~/.config/fish/completions/asdf.fish asdf_plugins ;

$(ASDF_WITHOUT_PATH):
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.1 # Can be upgraded by git-pull

~/.config/fish/completions/asdf.fish:
	mkdir -p ~/.config/fish/completions
	ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions/asdf.fish

asdf_plugins:
	$(ASDF_WITHOUT_PATH) plugin-add erlang || $(ASDF_WITHOUT_PATH) plugin-update erlang
	$(ASDF_WITHOUT_PATH) plugin-add elixir || $(ASDF_WITHOUT_PATH) plugin-update elixir
	$(ASDF_WITHOUT_PATH) plugin-add elm || $(ASDF_WITHOUT_PATH) plugin-update elm
	$(ASDF_WITHOUT_PATH) plugin-add ruby || $(ASDF_WITHOUT_PATH) plugin-update ruby
	$(ASDF_WITHOUT_PATH) plugin-add nodejs || $(ASDF_WITHOUT_PATH) plugin-update nodejs
	bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
	$(ASDF_WITHOUT_PATH) plugin-add rust || $(ASDF_WITHOUT_PATH) plugin-update rust

### fish related

FISH = /usr/local/bin/fish
.PHONY: fish
fish: $(FISH) ~/.config/fish/functions/fisher.fish ~/.config/fish/config.fish fish_plugins set_shell ;

$(FISH):
	brew install fish

~/.config/fish/functions/fisher.fish:
	curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

~/.config/fish/config.fish:
	ln -s ~/hiden/config.fish ~/.config/fish/config.fish

.PHONY: fish_plugins
fish_plugins:
	fish -c "fisher install oh-my-fish/plugin-aws fishpkg/fish-prompt-metro"
	curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/fish/docker.fish -o ~/.config/fish/completions/docker.fish
	curl https://raw.githubusercontent.com/docker/compose/master/contrib/completion/fish/docker-compose.fish -o ~/.config/fish/completions/docker-compose.fish


.PHONY: set_shell
set_shell:
	@# Password will be prompted
	if ! grep -q "$(FISH)" /etc/shells; then echo $(FISH) | sudo tee -a /etc/shells; fi
	if [[ "$${SHELL}" != "$(FISH)" ]]; then chsh -s $(FISH); fi

### Atom editor related

.PHONY: atom
atom: /Applications/Atom.app atom_config init_atom_packages update_atom_packages install_git_packages  ;

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
.PHONY: init_atom_packages
init_atom_packages: ~/.atom/packages/linter ;

ATOM_PACKAGE_FILE = atom_packages.txt
~/.atom/packages/linter:
	make install_atom_packages:

.PHONY: install_atom_packages
install_atom_packages:
	@# apm commands may need to be absolute path before first boot
	@# This is rather heavy action; better do it one by one, or create more "smart" install script
	apm install --packages-file $(ATOM_PACKAGE_FILE)

.PHONY: install_git_packages
install_git_packages:
	@# Git packages won't install automatically; always install latest
	apm install ymtszw/language-elixir-with-croma
	apm install ymtszw/language-elm

.PHONY: dump_atom_packages
dump_atom_packages:
	@# Source information of git packages aren't dumped
	apm list --bare --installed --enabled | sed -E '/(language-el(ixir|m)|^\s*$$)/d' > $(ATOM_PACKAGE_FILE)

.PHONY: update_atom_packages
update_atom_packages: install_updated_packages prune_uninstalled_packages ;

.PHONY: install_updated_packages
install_updated_packages:
	@# Do not re-install disabled packages
	apm list --bare --installed | sed -E '/language-el(ixir|m)/d' | comm -23 $(ATOM_PACKAGE_FILE) - | xargs -n1 apm install

.PHONY: prune_uninstalled_packages
prune_uninstalled_packages:
	@# Regenerate current apm list since it could be updated by `install_updated_packages` target
	apm list --bare --installed | sed -E '/language-el(ixir|m)/d' | comm -13 $(ATOM_PACKAGE_FILE) - | sed -E 's/@.*//' | xargs -n1 apm uninstall

### Vim related

.PHONY: vim
vim: ~/.vim_runtime vim-plug force_vimrc ;

~/.vim_runtime:
	git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime

.PHONY: vim-plug
vim-plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

.PHONY: force_vimrc
force_vimrc:
	@echo "\" This file is generated by ~/hiden/Makefile. Do not edit manually!" > ~/.vimrc
	@echo "" >> ~/.vimrc
	@cat ~/.vim_runtime/vimrcs/basic.vim >> ~/.vimrc
	@cat ~/hiden/.vimrc >> ~/.vimrc
	@echo "Open vim and run :PlugInstall to finish plugin install"

### SSH related

.PHONY: ssh
ssh: force_ssh_config /usr/local/bin/sshrc ~/.sshrc ~/.sshrc.d ~/.sshrc.d/.vimrc ;

# Using patched version
/usr/local/bin/sshrc:
	curl -Lo /usr/local/bin/sshrc https://raw.githubusercontent.com/taylorskalyo/sshrc/954d34ecd4761eb91f41cda0c54434b57ef4b6a3/sshrc
	chmod +x /usr/local/bin/sshrc

.PHONY: force_ssh_config
force_ssh_config:
	cat ~/hiden/.ssh/config_entry_point > ~/.ssh/config
	chmod 644 ~/.ssh/config

~/.sshrc:
	ln -Fs ~/hiden/.sshrc ~/.sshrc

~/.sshrc.d:
	mkdir -p ~/.sshrc.d

~/.sshrc.d/.vimrc:
	ln -Fs ~/.vimrc ~/.sshrc.d/.vimrc

### Fonts

.PHONY: install_fonts
install_fonts: ~/Library/Fonts/Source\ Code\ Pro\ for\ Powerline.otf ~/Library/Fonts/migmix-2m-bold.ttf ;

~/Library/Fonts/Source\ Code\ Pro\ for\ Powerline.otf:
	git clone https://github.com/powerline/fonts
	fonts/install.sh
	@echo "Re-login after this in order to reload font settings"
	rm -rf fonts

LATEST_MIGMIX = migmix-2m-20150712
~/Library/Fonts/migmix-2m-bold.ttf:
	curl -O http://jaist.dl.osdn.jp/mix-mplus-ipa/63544/$(LATEST_MIGMIX).zip
	unzip -q $(LATEST_MIGMIX).zip
	cp $(LATEST_MIGMIX)/migmix-2m-*.ttf ~/Library/Fonts/.
	@echo "Re-login after this in order to reload font settings"
	rm -rf $(LATEST_MIGMIX)*

### Other dot-files

.PHONY: misc
misc: ~/.ctags ~/.gnupg/gpg-agent.conf ~/.config/git/ignore git_config ;

~/.ctags:
	ln -s ~/hiden/.ctags ~/.ctags

~/.gnupg/gpg-agent.conf:
	mkdir -p ~/.gnupg
	ln -s ~/hiden/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf

~/.config/git/ignore:
	mkdir -p ~/.config/git
	ln -s ~/hiden/gitignore_global ~/.config/git/ignore

.PHONY: git_config
git_config:
	git config --global --replace-all init.templateDir ~/hiden/git_template
	git config --global --replace-all core.editor vim
	git config --global --replace-all user.name 'Yu Matsuzawa'
	@echo ""
	@echo "MUST: Set git author email with 'git config --global user.email <email>'!"
	@echo ""
