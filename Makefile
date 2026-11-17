-include .env
include ./.make/base.mk

FACTORIO_ARGS:=--load-game $(FACTORIO_DEV_SAVE) --cache-sprite-atlas
PROJECT_DEST:=$(FACTORIO_MOD_DIR)/$(PROJECT_NAME)
FACTORIO_LOG?=$(FACTORIO_DIR)/factorio-current.log

run: ##@run Run factorio
	$(FACTORIO_EXE) $(FACTORIO_ARGS)

deploy: ##@run Deploy the src files to the factorio mods folder
	@echo Deploying $(PROJECT_NAME) \($(VERSION)\) to $(PROJECT_DEST)
	rm -rf "$(PROJECT_DEST)"
	mkdir -p "$(PROJECT_DEST)"
	cp -r ./src/** "$(PROJECT_DEST)"
	sed -i 's/\$$(VERSION)/$(CURRENT_VERSION_PATCH)/' "$(PROJECT_DEST)/info.json"

log: ##@run Follow the factorio log and print only the lines logged by this mod
	@tail -n +1 -F "$(FACTORIO_LOG)" 2>/dev/null | \
		awk -v info="$(PROJECT_DEST)/info.json" -f scripts/mod-log.awk

watch: ##@run Watch the src files for changes and re-deploy and run once they do (requires wgo)
	wgo -dir ./src make deploy :: make run
