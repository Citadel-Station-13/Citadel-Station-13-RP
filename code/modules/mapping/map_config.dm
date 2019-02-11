//used for holding information about unique properties of maps
//feed it json files that match the datum layout
//defaults to box
//  -Cyberboss

//Citadel: Defaults to Tether.

//JSON FORMAT
/*
STRING													map_name				OOC name of the map
STRING													map_path				Path to the map as _maps/{map_path}/
STRING|LIST(STRING)										map_file				Filenames in path, if list will be loaded in order.
LIST(STRING = VALUE)									traits					Z Level traits, ordered by load order - SEE __DEFINES/map.dm FOR TRAIT LISTING
LIST(TYPEPATH[/datum/spawnpoint])						allowed_spawnpoints		Datum typepaths of allowed spawnpoints.
STRING													station_name_long		Long name of station (IC)
STRING													station_name			Short name of station (IC)
*/
//JSON FORMAT END

/datum/map_config
	// Metadata
	var/config_filename = "_maps/tether.json"
	var/defaulted = TRUE  // set to FALSE by LoadConfig() succeeding

	//	Config from the JSON - Should default to a fallback map.
	var/map_name = "Tether"
	var/map_path = "map_files/Tether"
	var/list/map_file = list(

	)

	var/list/traits = list(

	)

	var/list/allowed_spawnpoints = list(

	)

	var/station_name_long = "NSB Adephagia"
	var/station_name = "Tether"

/*
	// Config from maps.txt
	//MAP ROTATION
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1

	var/space_ruin_levels = 7
	var/space_empty_levels = 1

	var/minetype = "lavaland"

	var/allow_custom_shuttles = TRUE
	var/shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"whiteship" = "whiteship_box",
		"emergency" = "emergency_box")
*/

/proc/load_map_config(filename = "data/next_map.json", force_default_config, delete_after, error_if_missing = TRUE)
	var/datum/map_config/config = new
	if (force_default_config)
		return config
	if (!config.LoadConfig(filename, error_if_missing))
		qdel(config)
		config = new /datum/map_config  // Fall back to Box
	if(delete_after)
		if(!IsAdminAdvancedProcCall())			//bad idea.
			fdel(filename)
	return config

#define CHECK_EXISTS(X) if(!istext(json[X])) { log_world("[##X] missing from json!"); return; }
/datum/map_config/proc/LoadConfig(filename, error_if_missing)
	if(!fexists(filename))
		if(error_if_missing)
			log_world("map_config not found: [filename]")
		return

	var/json = file(filename)
	if(!json)
		log_world("Could not open map_config: [filename]")
		return

	json = file2text(json)
	if(!json)
		log_world("map_config is not text: [filename]")
		return

	json = json_decode(json)
	if(!json)
		log_world("map_config is not json: [filename]")
		return

	config_filename = filename

	CHECK_EXISTS("map_name")
	map_name = json["map_name"]
	CHECK_EXISTS("map_path")
	map_path = json["map_path"]

	map_file = json["map_file"]
	// "map_file": "BoxStation.dmm"
	if (istext(map_file))
		if (!fexists("_maps/[map_path]/[map_file]"))
			log_world("Map file ([map_path]/[map_file]) does not exist!")
			return
	// "map_file": ["Lower.dmm", "Upper.dmm"]
	else if (islist(map_file))
		for (var/file in map_file)
			if (!fexists("_maps/[map_path]/[file]"))
				log_world("Map file ([map_path]/[file]) does not exist!")
				return
	else
		log_world("map_file missing from json!")
		return

	traits = json["traits"]
	// "traits": [{"Linkage": "Cross"}, {"Space Ruins": true}]
	/*if (islist(traits))
		// "Station" is set by default, but it's assumed if you're setting
		// traits you want to customize which level is cross-linked
		for (var/level in traits)
			if (!(ZTRAIT_STATION in level))
				level[ZTRAIT_STATION] = TRUE
	// "traits": null or absent -> default
	else if (!isnull(traits))
	*/
	if(!islist(traits))
		log_world("map_config traits is not a list!")
		return

	allowed_spawnpoints = json["allowed_spawnpoints"]
	for(var/path in allowed_spawnpoints.Copy())
		allowed_spawnpoints -= path
		if(!ispath(path, /datum/spawnpoint))
			log_world("map_config Errored spawnpoint: [path] removed from map config [config_filename].")
			continue
		allowed_spawnpoints += text2path(path)
	if(!length(allowed_spawnpoints))
		log_world("map_config No spawnpoints defined for map config [config_filename]!.")
		allowed_spawnpoints = FALLBACK_DEFAULT_ALLOWED_SPAWNPOINTS

	station_name_long = json["station_name_long"]
	station_name = json["station_name"]
	if(!length(station_name_long))
		log_world("map_config No long station name defined.")
		station_name_long = "$ERROR \[LONG\]"
	if(!length(station_name))
		log_world("map_config No short station name defined.")
		station_name = "$ERROR"

/*
	if (islist(json["shuttles"]))
		var/list/L = json["shuttles"]
		for(var/key in L)
			var/value = L[key]
			shuttles[key] = value
	else if ("shuttles" in json)
		log_world("map_config shuttles is not a list!")
		return

	var/temp = json["space_ruin_levels"]
	if (isnum(temp))
		space_ruin_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_ruin_levels is not a number!")
		return

	temp = json["space_empty_levels"]
	if (isnum(temp))
		space_empty_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_empty_levels is not a number!")
		return

	if ("minetype" in json)
		minetype = json["minetype"]

	allow_custom_shuttles = json["allow_custom_shuttles"] != FALSE
*/

	defaulted = FALSE
	return TRUE
#undef CHECK_EXISTS

/datum/map_config/proc/GetFullMapPaths()
	if (istext(map_file))
		return list("_maps/[map_path]/[map_file]")
	. = list()
	for (var/file in map_file)
		. += "_maps/[map_path]/[file]"

/datum/map_config/proc/MakeNextMap()
	return config_filename == "data/next_map.json" || fcopy(config_filename, "data/next_map.json")
