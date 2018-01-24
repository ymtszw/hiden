MAKEFLAGS += --no-print-directory
SHELL = bash

.PHONY: all
all: check_os ;

.PHONY: check_os
check_os:
ifeq ($(shell uname), Darwin)
	@# Do nothing
else
	@echo "Only supports macOS"
	@exit 1
endif
