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
install_stuff: /Applications/iTerm.app ;

# It will upgrade itself to the latest version, after first boot
LATEST_ITERM = iTerm2-3_1_5.zip
/Applications/iTerm.app:
	curl -O https://iterm2.com/downloads/stable/$(LATEST_ITERM)
	unzip -q $(LATEST_ITERM)
	sudo mv iTerm.app /Applications/iTerm.app
	rm $(LATEST_ITERM)
