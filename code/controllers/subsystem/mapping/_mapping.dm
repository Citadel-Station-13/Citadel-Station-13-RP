#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)

GLOBAL_VAR_INIT(used_engine, "None")
// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	subsystem_flags = SS_NO_FIRE

	/// global mutex for ensuring two map/level load ops don't go at once
	/// a separate mutex is used at the actual maploader level
	/// this ensures we aren't shoving maps in during map init, as that can be both laggy and/or bad to legacy code that
	/// expect zlevel adjacency.
	var/load_mutex = FALSE

	// todo: this is going to need a lot more documentation
	// the idea of a single zlevel for areas is sorta flawed
	// this is an acceptable lazy lookup but we need to standardize what this means / look at how this is generated.
	var/list/areas_in_z = list()

/datum/controller/subsystem/mapping/Initialize(timeofday)
	// load data
	// todo: refactor
	load_map_templates()
	// todo: refactor
	preloadShelterTemplates()

	// init maps
	init_maps()
	// load the map to use
	read_next_map()

	// load world - this also initializes our first reserved level, which is compiled in.
	load_station()

	// perform snowflake legacy init stuff
	// todo: refactor
	if(!(LEGACY_MAP_DATUM).overmap_z)
		build_overmap()
	// todo: refactor - Set up antagonists.
	populate_antag_type_list()
	// todo: refactor - Set up spawn points.
	populate_spawn_points()

	// finalize
	// todo: refactor
	repopulate_sorted_areas()

	return ..()

//
// Mapping subsystem handles initialization of random map elements at server start
// For us that means loading our random roundstart engine!
//
/datum/controller/subsystem/mapping
	var/list/map_templates = list()
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

/datum/controller/subsystem/mapping/proc/preloadShelterTemplates()
	for(var/item in subtypesof(/datum/map_template/shelter))
		var/datum/map_template/shelter/shelter_type = item
		if(!(initial(shelter_type.map_path)))
			continue
		var/datum/map_template/shelter/S = new shelter_type()

		shelter_templates[S.shelter_id] = S
