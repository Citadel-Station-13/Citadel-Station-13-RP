// Persistent panic bunker passthrough
/datum/controller/subsystem/persistence/LoadPersistence()
	LoadPanicBunker()
	return ..()

/datum/controller/subsystem/persistence/SavePersistence()
	SavePanicBunker()
	return ..()

/datum/controller/subsystem/persistence/proc/SavePanicBunker()
	var/json_file = file("data/PB_bypass.json")
	var/list/file_data = list()
	file_data["data"] = GLOB.PB_bypass
	fdel(json_file)
	WRITE_FILE(json_file,json_encode(file_data))

/datum/controller/subsystem/persistence/proc/LoadPanicBunker()
	var/bunker_path = file(PERSISTENCE_FILE_PB_bypass)
	if(fexists(bunker_path))
		var/list/json = json_decode(file2text(bunker_path))
		GLOB.PB_bypass = json["data"]
		for(var/ckey in GLOB.PB_bypass)
			if(daysSince(GLOB.PB_bypass[ckey]) >= CONFIG_GET(number/max_bunker_days))
				GLOB.PB_bypass -= ckey
