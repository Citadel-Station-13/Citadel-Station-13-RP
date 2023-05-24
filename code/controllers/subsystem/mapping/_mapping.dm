#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)

GLOBAL_VAR_INIT(used_engine, "None")
// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	subsystem_flags = SS_NO_FIRE

	var/list/areas_in_z = list()

	/// Zlevel manager list of zlevels.
	var/datum/space_level/transit

//dlete dis once #39770 is resolved
/datum/controller/subsystem/mapping/proc/HACK_LoadMapConfig()
	if(!config)
#ifdef FORCE_MAP
		config = load_map_config(FORCE_MAP)
#else
		config = load_map_config(error_if_missing = FALSE)
#endif
	stat_map_name = config.map_name

/datum/controller/subsystem/mapping/Initialize(timeofday)
	// init first level
	#warn init default level / reservation
	// init maps
	init_maps()
	// load the map to use
	read_next_map()
	// load world
	load_station()

	#warn below
	report_progress("Initializing [name] subsystem...")
	// shim: this goes at the top
	world.max_z_changed(0, world.maxz) // This is to set up the player z-level list, maxz hasn't actually changed (probably)
	HACK_LoadMapConfig()
	if(initialized)
		return
	repopulate_sorted_areas()
	load_map_templates()

	loadEngine()
	preloadShelterTemplates()
	// Mining generation probably should be here too
	LEGACY_MAP_DATUM.perform_map_generation()
	// TODO - Other stuff related to maps and areas could be moved here too.  Look at /tg
	if(LEGACY_MAP_DATUM)
		loadLateMaps()
	if(!LEGACY_MAP_DATUM.overmap_z)
		build_overmap()

	// basemap - REEVALUATE when runtime maploading is in
	transit = z_list[1]
	initialize_reserved_level(transit.z_value)
	// initialize_reserved_level(transit.z_value)

	// Set up antagonists.
	populate_antag_type_list()

	//Set up spawn points.
	populate_spawn_points()

	repopulate_sorted_areas()
	return ..()

/datum/controller/subsystem/mapping/proc/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, orientation = SOUTH)
/*
	. = list()
	var/start_time = REALTIMEOFDAY

	if (!islist(files))  // handle single-level maps
		files = list(files)

	// check that the total z count of all maps matches the list of traits
	var/total_z = 0
	var/list/dmm_parseds = list()
	for (var/file in files)
		var/full_path = "_mapload/[path]/[file]"
		var/datum/dmm_parsed/pm = new(file(full_path))
		var/bounds = pm?.bounds
		if (!bounds)
			errorList |= full_path
			continue
		dmm_parseds[pm] = total_z  // save the start Z of this file
		total_z += bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1

	if (!length(traits))  // null or empty - default
		for (var/i in 1 to total_z)
			traits += list(default_traits)
	else if (total_z != traits.len)  // mismatch
		INIT_ANNOUNCE("WARNING: [traits.len] trait sets specified for [total_z] z-levels in [path]!")
		if (total_z < traits.len)  // ignore extra traits
			traits.Cut(total_z + 1)
		while (total_z > traits.len)  // fall back to defaults on extra levels
			traits += list(default_traits)

	// preload the relevant space_level datums
	var/start_z = world.maxz + 1
	var/i = 0
	for (var/level in traits)
		add_new_zlevel("[name][i ? " [i + 1]" : ""]", level)
		++i

	// load the maps
	for (var/P in dmm_parseds)
		var/datum/dmm_parsed/pm = P
		if (!pm.load(1, 1, start_z + dmm_parseds[P], no_changeturf = TRUE, orientation = orientation))
			errorList |= pm.original_path
	if(!silent)
		INIT_ANNOUNCE("Loaded [name] in [(REALTIMEOFDAY - start_time)/10]s!")
	return dmm_parseds
*/

/datum/controller/subsystem/mapping/proc/loadWorld()
	// Until we have runtime maploading, just load traits from config
	if(!config)
		INIT_ANNOUNCE("WARNING: FAILED TO LOAD MAP CONFIG. THIS ROUND WILL BREAK. REBOOTING WILL LIKELY NOT FIX IT AT THIS POINT, CONTACT A MAINTAINER IMMEDIATELY.")
		return
	else
		z_list = list()
		add_new_zlevel("RESERVED LEVEL", list(ZTRAIT_RESERVED = TRUE))
		var/current = 0
		if((length(config.traits) + 1) != world.maxz)
			INIT_ANNOUNCE("WARNING: MAP CONFIG TRAIT LIST MISMATCHES WITH ZCOUNT ([length(config.traits)] vs [world.maxz - 1] actual). ERRORS WILL OCCUR.")
		for(var/i in config.traits)
			var/list/traits = i
			current++
			if(!istype(traits))
				INIT_ANNOUNCE("WARNING: ERROR DETECTED IN ZTRAIT LIST.")
				add_new_zlevel("ERROR - Z [current]", list())
			else
				add_new_zlevel(traits[ZTRAIT_NAME] || "[config.map_name] [current]", traits)
		if(length(z_list) != world.maxz)
			INIT_ANNOUNCE("WARNING: Z_LIST LENGTH [length(z_list)] NOT MATCHING ZCOUNT [world.maxz]. THIS ROUND WILL BREAK. REBOOTING WILL LIKELY NOT FIX IT AT THIS POINT, CONTACT A MAINTAINER IMMEDIATELY.")
/*
	//if any of these fail, something has gone horribly, HORRIBLY, wrong
	var/list/FailedZs = list()
*/

/*
	// ensure we have space_level datums for compiled-in maps
	InitializeDefaultZLevels()
*/

/*
	// load the station
	station_start = world.maxz + 1
	INIT_ANNOUNCE("Loading [config.map_name]...")
	LoadGroup(FailedZs, "Station", config.map_path, config.map_file, config.traits, ZTRAITS_STATION, FALSE, config.orientation)

	if(SSdbcore.Connect())
		var/datum/DBQuery/query_round_map_name = SSdbcore.NewQuery("UPDATE [format_table_name("round")] SET map_name = '[config.map_name]' WHERE id = [GLOB.round_id]")
		query_round_map_name.Execute()
		qdel(query_round_map_name)

#ifndef LOWMEMORYMODE
	// TODO: remove this when the DB is prepared for the z-levels getting reordered
	while (world.maxz < (5 - 1) && space_levels_so_far < config.space_ruin_levels)
		++space_levels_so_far
		add_new_zlevel("Empty Area [space_levels_so_far]", ZTRAITS_SPACE)

	// load mining
	if(config.minetype == "lavaland")
		LoadGroup(FailedZs, "Lavaland", "map_files/Mining", "Lavaland.dmm", default_traits = ZTRAITS_LAVALAND)
	else if (!isnull(config.minetype) && config.minetype != "none")
		INIT_ANNOUNCE("WARNING: An unknown minetype '[config.minetype]' was set! This is being ignored! Update the maploader code!")
#endif

	if(LAZYLEN(FailedZs))	//but seriously, unless the server's filesystem is messed up this will never happen
		var/msg = "RED ALERT! The following map files failed to load: [FailedZs[1]]"
		if(FailedZs.len > 1)
			for(var/I in 2 to FailedZs.len)
				msg += ", [FailedZs[I]]"
		msg += ". Yell at your server host!"
		INIT_ANNOUNCE(msg)
*/

//
// Mapping subsystem handles initialization of random map elements at server start
// For us that means loading our random roundstart engine!
//
/datum/controller/subsystem/mapping
	var/list/map_templates = list()
	var/dmm_suite/maploader = null
	var/obj/landmark/engine_loader/engine_loader
	var/list/shelter_templates = list()

/datum/controller/subsystem/mapping/Recover()
	subsystem_flags |= SS_NO_INIT // Make extra sure we don't initialize twice.
	shelter_templates = SSmapping.shelter_templates

/datum/controller/subsystem/mapping/proc/load_map_templates()
	for(var/T in subtypesof(/datum/map_template))
		var/datum/map_template/template = T
		template = new T
		if(!template.mappath)
			qdel(template)
			continue
		map_templates[template.name] = template
	return TRUE

/datum/controller/subsystem/mapping/proc/loadEngine()
	if(!engine_loader)
		return // Seems this map doesn't need an engine loaded.

	var/turf/T = get_turf(engine_loader)
	if(!isturf(T))
		subsystem_log("[log_info_line(engine_loader)] not on a turf! Cannot place engine template.")
		return

	// Choose an engine type
	var/datum/map_template/engine/chosen_type = null
	var/list/probabilities = CONFIG_GET(keyed_list/engine_submap)
	if (length(probabilities))
		var/chosen_name = lowertext(pickweightAllowZero(probabilities))
		for(var/mapname in map_templates)
			// yeah yeah yeah inefficient fight me someone can code me a better subsystem if they want to bother
			if(lowertext(mapname) == chosen_name)
				chosen_type = map_templates[mapname]
		if(!istype(chosen_type))
			log_config("Configured engine map [chosen_name] is not a valid engine map name!")
	if(!istype(chosen_type))
		var/list/engine_types = list()
		for(var/map in map_templates)
			var/datum/map_template/engine/MT = map_templates[map]
			if(istype(MT))
				engine_types += MT
		chosen_type = pick(engine_types)
	subsystem_log("Chose Engine Map: [chosen_type.name]")
	admin_notice("<span class='danger'>Chose Engine Map: [chosen_type.name]</span>", R_DEBUG)
	to_chat(world, "<span class='danger'>Engine loaded: [chosen_type.display_name]</span>")
	GLOB.used_engine = chosen_type.display_name

	// Annihilate movable atoms
	engine_loader.annihilate_bounds()
	//CHECK_TICK //Don't let anything else happen for now
	// Actually load it
	chosen_type.load(T)

/datum/controller/subsystem/mapping/proc/loadLateMaps()
#ifndef FASTBOOT_DISABLE_LATELOAD
	var/list/deffo_load = LEGACY_MAP_DATUM.lateload_z_levels
	var/list/maybe_load = LEGACY_MAP_DATUM.lateload_single_pick

	for(var/list/maplist in deffo_load)
		if(!islist(maplist))
			log_world("Lateload Z level [maplist] is not a list! Must be in a list!")
			continue
		for(var/mapname in maplist)
			var/datum/map_template/MT = map_templates[mapname]
			if(!istype(MT))
				log_world("Lateload Z level \"[mapname]\" is not a valid map!")
				continue
			MT.load_new_z(centered = FALSE)
			CHECK_TICK

	if(LAZYLEN(maybe_load))
		var/picklist = pick(maybe_load)

		if(!picklist) //No lateload maps at all
			return

		if(!islist(picklist)) //So you can have a 'chain' of z-levels that make up one away mission
			log_world("Randompick Z level [picklist] is not a list! Must be in a list!")
			return

		for(var/map in picklist)
			var/datum/map_template/MT = map_templates[map]
			if(!istype(MT))
				log_world("Randompick Z level \"[map]\" is not a valid map!")
			else
				MT.load_new_z(centered = FALSE)
#endif

/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/item in subtypesof(/datum/map_template/shelter))
		var/datum/map_template/shelter/shelter_type = item
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S

// todo: admin subsystems panel
// admin tooling below

/client/proc/change_next_map()
	set name = "Change Map"
	set desc = "Change the next map."
	set category = "Server"

	#warn impl
