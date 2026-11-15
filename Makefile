-include .env
include ./.make/base.mk

FACTORIO_ARGS:=--load-game $(FACTORIO_DEV_SAVE)
PROJECT_DEST:=$(FACTORIO_MOD_DIR)/$(PROJECT_NAME)

run: ##@run Run factorio
	$(FACTORIO_EXE) $(FACTORIO_ARGS)

deploy: ##@run Deploy the src files to the factorio mods folder
	@echo Deploying $(PROJECT_NAME) \($(VERSION)\) to $(PROJECT_DEST)
	rm -rf "$(PROJECT_DEST)"
	mkdir -p "$(PROJECT_DEST)"
	cp ./src/** "$(PROJECT_DEST)"
	sed -i 's/\$$(VERSION)/$(VERSION)/' "$(PROJECT_DEST)/info.json"
