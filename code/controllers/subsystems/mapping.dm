#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)

// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	/// Zlevel manager list of zlevels.
	var/list/z_list

	/// The current map config datum the round is using
	var/static/datum/map_config/config
	/// The next map to load
	var/static/datum/map_config/next_map_config

	/// Cached map name for statpanel
	var/static/stat_map_name = "Loading..."

	/// Lookup list for random generated IDs.
	var/static/list/random_generated_ids_by_original = list()
	/// next id for separating obfuscated ids.
	var/static/obfuscation_next_id = 1
	/// "secret" key
	var/static/obfuscation_secret

//dlete dis once #39770 is resolved
/datum/controller/subsystem/mapping/proc/HACK_LoadMapConfig()
	if(!config)
#ifdef FORCE_MAP
		config = load_map_config(FORCE_MAP)
#else
		config = load_map_config(error_if_missing = FALSE)
#endif
	stat_map_name = config.map_name

/datum/controller/subsystem/mapping/PreInit()
	if(!obfuscation_secret)
		obfuscation_secret = md5(GUID())		//HAH! Guess this!

/datum/controller/subsystem/mapping/Initialize(timeofday)
	HACK_LoadMapConfig()
	if(subsystem_initialized)
		return
	if(config.defaulted)
		var/old_config = config
		config = global.config.defaultmap
		if(!config || config.defaulted)
			to_chat(world, "<span class='boldannounce'>Unable to load next or default map config, defaulting to Tethermap</span>")
			config = old_config
	loadWorld()
	return ..()

/datum/controller/subsystem/mapping/proc/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, orientation = SOUTH)
/*
	. = list()
	var/start_time = REALTIMEOFDAY

	if (!islist(files))  // handle single-level maps
		files = list(files)

	// check that the total z count of all maps matches the list of traits
	var/total_z = 0
	var/list/parsed_maps = list()
	for (var/file in files)
		var/full_path = "_maps/[path]/[file]"
		var/datum/parsed_map/pm = new(file(full_path))
		var/bounds = pm?.bounds
		if (!bounds)
			errorList |= full_path
			continue
		parsed_maps[pm] = total_z  // save the start Z of this file
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
	for (var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		if (!pm.load(1, 1, start_z + parsed_maps[P], no_changeturf = TRUE, orientation = orientation))
			errorList |= pm.original_path
	if(!silent)
		INIT_ANNOUNCE("Loaded [name] in [(REALTIMEOFDAY - start_time)/10]s!")
	return parsed_maps
*/

/datum/controller/subsystem/mapping/proc/loadWorld()
	// Until we have runtime maploading, just load traits from config
	if(!config)
		INIT_ANNOUNCE("WARNING: FAILED TO LOAD MAP CONFIG. THIS ROUND WILL BREAK. REBOOTING WILL LIKELY NOT FIX IT AT THIS POINT, CONTACT A MAINTAINER IMMEDIATELY.")
		return
	else
		z_list = list()
		var/current = 0
		if(length(config.traits) != world.maxz)
			INIT_ANNOUNCE("WARNING: MAP CONFIG TRAIT LIST MISMATCHES WITH ZCOUNT ([length(config.traits)] vs [world.maxz] actual). ERRORS WILL OCCUR.")
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

	// ensure we have space_level datums for compiled-in maps
	InitializeDefaultZLevels()

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
// On VOREStation that means loading our random roundstart engine!
//
/datum/controller/subsystem/mapping
	var/list/map_templates = list()
	var/dmm_suite/maploader = null
	var/obj/effect/landmark/engine_loader/engine_loader
	var/list/shelter_templates = list()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT // Make extra sure we don't initialize twice.
	shelter_templates = SSmapping.shelter_templates

/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()
	if(subsystem_initialized)
		return
	world.max_z_changed() // This is to set up the player z-level list, maxz hasn't actually changed (probably)
	maploader = new()
	load_map_templates()

	if(config_legacy.generate_map)
		// Map-gen is still very specific to the map, however putting it here should ensure it loads in the correct order.
		if(GLOB.using_map.perform_map_generation())
			GLOB.using_map.refresh_mining_turfs()

	loadEngine()
	preloadShelterTemplates()
	// Mining generation probably should be here too
	// TODO - Other stuff related to maps and areas could be moved here too.  Look at /tg
	if(GLOB.using_map)
		loadLateMaps()

/datum/controller/subsystem/mapping/proc/load_map_templates()
	for(var/T in subtypesof(/datum/map_template))
		var/datum/map_template/template = T
		if(!(initial(template.mappath))) // If it's missing the actual path its probably a base type or being used for inheritence.
			continue
		template = new T()
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
	if (LAZYLEN(config_legacy.engine_map))
		var/chosen_name = pick(config_legacy.engine_map)
		chosen_type = map_templates[chosen_name]
		if(!istype(chosen_type))
			log_world("Configured engine map [chosen_name] is not a valid engine map name!")
	if(!istype(chosen_type))
		var/list/engine_types = list()
		for(var/map in map_templates)
			var/datum/map_template/engine/MT = map_templates[map]
			if(istype(MT))
				engine_types += MT
		chosen_type = pick(engine_types)
	subsystem_log("Chose Engine Map: [chosen_type.name]")
	admin_notice("<span class='danger'>Chose Engine Map: [chosen_type.name]</span>", R_DEBUG)

	// Annihilate movable atoms
	engine_loader.annihilate_bounds()
	//CHECK_TICK //Don't let anything else happen for now
	// Actually load it
	chosen_type.load(T)

/datum/controller/subsystem/mapping/proc/loadLateMaps()
	var/list/deffo_load = GLOB.using_map.lateload_z_levels
	var/list/maybe_load = GLOB.using_map.lateload_single_pick

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

/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/item in subtypesof(/datum/map_template/shelter))
		var/datum/map_template/shelter/shelter_type = item
		if(!(initial(shelter_type.mappath)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S

/datum/controller/subsystem/mapping/stat_entry(msg)
	if (!Debug2)
		return // Only show up in stat panel if debugging is enabled.
	. = ..()
