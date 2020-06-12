// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

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
	return ..()

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
	..()

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
