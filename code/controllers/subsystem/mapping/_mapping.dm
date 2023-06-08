#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)

GLOBAL_VAR_INIT(used_engine, "None")
// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	subsystem_flags = SS_NO_FIRE

	var/list/areas_in_z = list()

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
	// shim: this goes at the top
	repopulate_sorted_areas()
	load_map_templates()
	loadEngine()
	preloadShelterTemplates()
	// Mining generation probably should be here too
	LEGACY_MAP_DATUM.perform_map_generation()
	if(!LEGACY_MAP_DATUM.overmap_z)
		build_overmap()

	// Set up antagonists.
	populate_antag_type_list()

	//Set up spawn points.
	populate_spawn_points()

	repopulate_sorted_areas()
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
		if(!template.map_path)
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

/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/item in subtypesof(/datum/map_template/shelter))
		var/datum/map_template/shelter/shelter_type = item
		if(!(initial(shelter_type.map_path)))
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
