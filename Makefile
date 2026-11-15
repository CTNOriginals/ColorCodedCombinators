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
	cp ./src/** "$(PROJECT_DEST)"
	sed -i 's/\$$(VERSION)/$(VERSION)/' "$(PROJECT_DEST)/info.json"

log: ##@run Follow the factorio log and print only the lines logged by this mod
	@tail -n +1 -F "$(FACTORIO_LOG)" 2>/dev/null | sed -un \
		-e 's|^ *0\.000 [0-9-]* \([0-9:]*\);.*|\n\x1b[2m--- game started \1 ---\x1b[0m|p' \
		-e 's|^ *\([0-9.]*\) Script @__$(PROJECT_NAME)__/\([^:]*:[0-9]*:\)|\x1b[2m\1 \2\x1b[0m|p'

watch: ##@run Watch the src files for changes and re-deploy and run once they do (requires wgo)
	wgo -dir ./src make deploy :: make run
