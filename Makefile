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
install_stuff: install_fonts /Applications/iTerm.app ;

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

# It will upgrade itself to the latest version, after first boot
LATEST_ITERM = iTerm2-3_1_5.zip
/Applications/iTerm.app:
	curl -O https://iterm2.com/downloads/stable/$(LATEST_ITERM)
	unzip -q $(LATEST_ITERM)
	sudo mv iTerm.app /Applications/.
	rm $(LATEST_ITERM)
