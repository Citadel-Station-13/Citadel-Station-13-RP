// Persistent panic bunker passthrough
/datum/controller/subsystem/persistence/LoadPersistence()
	LoadPanicBunker()
	return ..()

/datum/controller/subsystem/persistence/SavePersistence()
	SavePanicBunker()
	return ..()

/datum/controller/subsystem/persistence/proc/SavePanicBunker()
	var/json_file = file(PERSISTENCE_FILE_BUNKER_PASSTHROUGH)
	var/list/file_data = list()
	file_data["data"] = GLOB.bunker_passthrough
	fdel(json_file)
	WRITE_FILE(json_file,json_encode(file_data))

/datum/controller/subsystem/persistence/proc/LoadPanicBunker()
	var/bunker_path = file(PERSISTENCE_FILE_BUNKER_PASSTHROUGH)
	if(fexists(bunker_path))
		var/list/json = json_decode(file2text(bunker_path))
		GLOB.bunker_passthrough = json["data"]
		for(var/ckey in GLOB.bunker_passthrough)
			if(daysSince(GLOB.bunker_passthrough[ckey]) >= CONFIG_GET(number/max_bunker_days))
				GLOB.bunker_passthrough -= ckey
