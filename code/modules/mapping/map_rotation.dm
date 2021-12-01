/**
 * Writes next_map.json
 */
/proc/WriteNextMap(map_datum_path = /datum/map_config)
	var/list/compiled = list()
	compiled["PATH"] = "[map_datum_path]"
	if(fexists("data/next_map.json"))
		fdel("data/next_map.json")
	var/file/F = file("data/next_map.json")
	F << json_encode(compiled)

/**
 * Returns the next map datum
 */
/proc/ReadNextMap()
	. = /datum/map_config
	if(!fexists("data/next_map.json"))
		return
	var/list/decoded = json_decode(file2text(file("data/next_map.json")))
	ASSERT(ispath(text2path(decoded["PATH"])))
	. = new text2path(decoded["PATH"])
