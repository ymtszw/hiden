MAKEFLAGS += --no-print-directory
SHELL = bash
HIDEN = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: all
all: check_requirements install_stuff ;

#
# Ensure prerequisites for executing various commands in hiden
#
.PHONY: check_requirements
check_requirements:
	@if [[ "$(shell uname)" != "Darwin" ]]; then echo "Only supports macOS"; exit 1; fi
	@which -s brew curl git

#
# Install stuff!
#
.PHONY: install_stuff
install_stuff: user_bin brew_packages fish vim ssh install_fonts misc ;

### Custom scripts

.PHONY: user_bin
user_bin: /usr/local/bin/trello-card-id /usr/local/bin/imgcat ;

/usr/local/bin/trello-card-id:
	sudo ln -Fs $(HIDEN)bin/trello-card-id /usr/local/bin/trello-card-id

/usr/local/bin/imgcat:
	sudo curl -o /usr/local/bin/imgcat -L https://iterm2.com/utilities/imgcat
	sudo chmod +x /usr/local/bin/imgcat

### Homebrew related

.PHONY: brew_packages
brew_packages:
	@# Installing or upgrading already installed ones using `brew bundle`
	@# If `brew bundle`'s automatic installation of Homebrew-bundle fails, try manually git-cloning the Homebrew-bundle repository!
	brew bundle --file=$(HIDEN)Brewfile

### fish related

.PHONY: fish
fish: fish_bin ~/.config/fish/functions/fisher.fish ~/.config/fish/config.fish ~/.config/starship.toml fish_plugins set_shell ;

.PHONY: fish_bin
fish_bin:
	brew install fish

~/.config/fish/functions/fisher.fish:
	mkdir -p ~/.config/fish/completions
	mkdir -p ~/.config/fish/functions
	curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/completions/fisher.fish > ~/.config/fish/completions/fisher.fish
	curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish > ~/.config/fish/functions/fisher.fish

~/.config/fish/config.fish:
	ln -s $(HIDEN)config.fish ~/.config/fish/config.fish

~/.config/starship.toml:
	ln -s $(HIDEN)starship.toml ~/.config/starship.toml

.PHONY: fish_plugins
fish_plugins:
	fish -c "fisher install 2m/fish-history-merge danhper/fish-ssh-agent"
	curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/fish/docker.fish -o ~/.config/fish/completions/docker.fish
	curl https://raw.githubusercontent.com/docker/compose/master/contrib/completion/fish/docker-compose.fish -o ~/.config/fish/completions/docker-compose.fish
	if which aws; then fish -c "fisher install oh-my-fish/plugin-aws"; fi
	if which gh; then gh completion -s fish > ~/.config/fish/completions/gh.fish; fi


.PHONY: set_shell
set_shell:
	@# Password will be prompted
	if ! grep -q "$(shell which fish)" /etc/shells; then echo $(shell which fish) | sudo tee -a /etc/shells; fi
	if [[ "$${SHELL}" != "$(shell which fish)" ]]; then chsh -s $(shell which fish); fi

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
	@echo "\" This file is generated by $(HIDEN)Makefile. Do not edit manually!" > ~/.vimrc
	@echo "" >> ~/.vimrc
	@cat ~/.vim_runtime/vimrcs/basic.vim >> ~/.vimrc
	@cat $(HIDEN).vimrc >> ~/.vimrc
	git config --global --replace-all core.editor vim
	if which gh; then gh config set editor vim; fi
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
	cat $(HIDEN).ssh/config_entry_point > ~/.ssh/config
	chmod 644 ~/.ssh/config

~/.sshrc:
	ln -Fs $(HIDEN).sshrc ~/.sshrc

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

### VSCode Remote Extensions

.PHONY: vscode_extensions
vscode_extensions:
	code --install-extension sleistner.vscode-fileutils
	code --install-extension wmaurer.change-case
	code --install-extension streetsidesoftware.code-spell-checker
	code --install-extension ionutvmi.path-autocomplete
	code --install-extension timonwong.shellcheck
	code --install-extension TabNine.tabnine-vscode
	code --install-extension shardulm94.trailing-spaces
	code --install-extension eamodio.gitlens
	code --install-extension GitHub.vscode-pull-request-github
	code --install-extension bmalehorn.vscode-fish

### Other dot-files

.PHONY: misc
misc: ~/.gnupg/gpg-agent.conf ~/.config/git/ignore git_config ;

~/.gnupg/gpg-agent.conf:
	mkdir -p ~/.gnupg
	ln -s $(HIDEN).gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf

~/.config/git/ignore:
	mkdir -p ~/.config/git
	ln -s $(HIDEN)gitignore_global ~/.config/git/ignore

.PHONY: git_config
git_config:
	git config --global --replace-all init.templateDir $(HIDEN)git_template
	git config --global --replace-all user.name 'Yu Matsuzawa'
	git config --global --replace-all advice.detachedHead false
	git config --global --replace-all core.quotepath false
	git config --global --replace-all pull.ff only
	@echo ""
	@echo "MUST: Set git author email with 'git config --global user.email <email>'!"
	@echo ""
