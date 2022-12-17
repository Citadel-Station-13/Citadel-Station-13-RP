#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)

GLOBAL_VAR_INIT(used_engine, "None")
// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	subsystem_flags = SS_NO_FIRE

	var/list/areas_in_z = list()

	/// Cached map name for statpanel
	var/static/stat_map_name = "Loading..."

#warn parse

#warn Recover()

/datum/controller/subsystem/mapping/Initialize(timeofday)
	HACK_LoadMapConfig()
	if(initialized)
		return
	if(config.defaulted)
		var/old_config = config
		config = global.config.defaultmap
		if(!config || config.defaulted)
			to_chat(world, "<span class='boldannounce'>Unable to load next or default map config, defaulting to Tethermap</span>")
			config = old_config
	loadWorld()
	repopulate_sorted_areas()
	world.max_z_changed() // This is to set up the player z-level list, maxz hasn't actually changed (probably)
	maploader = new()
	load_map_templates()

	loadEngine()
	preloadShelterTemplates()
	// Mining generation probably should be here too
	using_map_legacy().perform_map_generation()
	// TODO - Other stuff related to maps and areas could be moved here too.  Look at /tg
	if(using_map_legacy())
		loadLateMaps()
	if(!using_map_legacy().overmap_z)
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
#warn reconcile
#warn initialize default zlevels needs to check if there's unexpected amounts.
/*
	// Make sure we're not being reran
	if(initialized)
		return

	// init all datums
	InitMapDatums()
	InitMapLevels()

	// set map config
	EnsureConfigLoaded()

	// Init map levels for compiled in maps
	InitializeDefaultZLevels()
	if(!reserved_level_count)
		CreateReservedLevel()

	// load world
	InstantiateWorld()

	// init vr/away
	if(CONFIG_GET(flag/roundstart_away))
		LoadAway()
	if(CONFIG_GET(flag/roundstart_vr))
		LoadVR()

	// finalize
	var/rebuild_start = REALTIMEOFDAY
	RebuildCrosslinking()		// THIS GOES FIRST
	rebuild_verticality()
	rebuild_transitions()
	RebuildMapLevelTurfs(null, TRUE, TRUE)
	repopulate_sorted_areas()
	init_log("Zlevels rebuilt in [(REALTIMEOFDAY - rebuild_start) / 10]s.")

	setup_station_z_index()

	initialize_biomes()

	PerformMapGeneration()

	GLOB.year_integer += map.year_offset
	GLOB.announcertype = (map.announcertype == "standard" ? (prob(1) ? "medibot" : "classic") : map.announcertype)

	repopulate_sorted_areas()
	process_teleport_locs()			//Sets up the wizard teleport locations
	preloadTemplates()

	repopulate_sorted_areas()
	// Set up Z-level transitions.
	generate_station_area_list()
	Feedback()
	return ..()
*/
	return ..()

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

#warn parse

/datum/controller/subsystem/mapping/proc/loadLateMaps()
#ifndef FASTBOOT_DISABLE_LATELOAD
	var/list/deffo_load = using_map_legacy().lateload_z_levels
	var/list/maybe_load = using_map_legacy().lateload_single_pick

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
