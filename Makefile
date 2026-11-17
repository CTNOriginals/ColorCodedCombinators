-include .env
include ./.make/base.mk

FACTORIO_UDP_PORT?=34250
FACTORIO_ARGS:=--load-game $(FACTORIO_DEV_SAVE) --cache-sprite-atlas --enable-lua-udp $(FACTORIO_UDP_PORT)
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

# wgo treats "." in these patterns as a literal dot, so "[^:]*" is used for "anything"
WATCH_LUA:=^src/[^:]*.lua$$
WATCH_DATA_DIR:=^src/data/
WATCH_DATA_ENTRY:=^src/(data|settings)(-updates|-final-fixes)?.lua$$
WATCH_ASSETS:=^src/[^:]*.(json|cfg|png|ogg)$$

reload: deploy ##@run Deploy and reload the mod scripts in the running game (see src/dev.lua)
	@bash -c "printf 'ccc-reload' > /dev/udp/127.0.0.1/$(FACTORIO_UDP_PORT)"

watch: ##@run Run factorio, reload it when a runtime script changes and restart it when any other src file changes (requires wgo)
	wgo -file '$(WATCH_DATA_DIR)' -file '$(WATCH_DATA_ENTRY)' -file '$(WATCH_ASSETS)' make deploy \
		:: make run \
		:: wgo -postpone -file '$(WATCH_LUA)' -xfile '$(WATCH_DATA_DIR)' -xfile '$(WATCH_DATA_ENTRY)' make reload

