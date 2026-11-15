-include .env
include ./.make/base.mk

# -- RUN --
run: ##@run Run factorio
	$(FACTORIO_EXE)
