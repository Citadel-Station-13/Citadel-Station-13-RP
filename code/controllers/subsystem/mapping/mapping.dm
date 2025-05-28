#define INIT_ANNOUNCE(X) to_chat(world, "<span class='boldannounce'>[X]</span>"); log_world(X)

/**
 * The map management subsystem.
 */
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	subsystem_flags = SS_NO_FIRE

	//* Allocation *//
	/// list of levels ready for reuse
	/// * This must be sorted from low z-index to high.
	var/static/list/ordered_reusable_levels = list()

	//* Levels *//
	/// indexed level datums
	/// * If an index is null, there's no level there.
	var/static/list/datum/map_level/ordered_levels = list()
	/// k-v id to level datum lookup
	var/static/list/datum/map_level/keyed_levels = list()

	//* Levels - Fluff *//
	/// literally just a random hexadecimal store to prevent collision
	var/static/list/random_fluff_level_hashes = list()

	//* Levels - Multiz *//
	/// Ordered lookup list for multiz up
	var/list/cached_level_up
	/// Ordered lookup list for multiz down
	var/list/cached_level_down
	/// Ordered lookup list for east transition
	var/list/cached_level_east
	/// Ordered lookup list for west transition
	var/list/cached_level_west
	/// Ordered lookup list for north transition
	var/list/cached_level_north
	/// Ordered lookup list for south transition
	var/list/cached_level_south
	/// Z access lookup - z = list() of zlevels it can directly access vertically
	/// * For performance, this is currently only including bidirectional links
	/// * For performance, this does not support looping.
	/// * This is a direct stack lookup. This does not take map_struct's into account.
	var/list/z_stack_lookup
	/// does z stack lookup need a rebuild?
	var/z_stack_dirty = TRUE

	//* Maps *//
	/// station is loaded
	var/world_is_loaded = FALSE
	/// loaded station map
	var/static/datum/map/station/loaded_station
	/// next station map
	var/datum/map/station/next_station
	/// loaded maps
	var/static/list/datum/map/loaded_maps = list()
	/// available maps - k-v lookup by id
	var/list/datum/map/keyed_maps

	//* Obfuscation *//
	/// used to ensure global-ness
	//  todo: should this be here? this is used literally everywhere
	var/static/round_global_descriptor
	/// round-local hash storage for specific map ids
	var/static/round_local_mangling_cache = list()
	/// round-local hash storage for specific map ids, reverse lookup
	var/static/round_local_mangling_reverse_cache = list()
	/// round-local hash storage for obfuscated ids
	var/static/round_local_obfuscation_cache = list()
	/// round-local hash storage for obfuscated ids, reverse lookup
	var/static/round_local_obfuscation_reverse_cache = list()

	//* Reservations *//
	/// reserved levels allocated
	var/static/reservation_level_count = 0
	/// reserved turfs allowed - we can over-allocate this if we're only going to be slightly over and can always allocate atleast one level.
	var/static/reservation_turf_limit = 192 * 192 * 3
	/// allocated space reservations
	var/static/list/datum/map_reservation/reservations = list()
	/// list of reserved z-indices for fast access
	var/static/list/reservation_levels = list()
	/// doing some blocking op on reservation system
	var/static/reservation_system_mutex = FALSE
	/// singleton area holding all free reservation turfs
	var/static/area/reservation_unused/reservation_unallocated_area = new
	/// spatial grid of turf reservations. the owner of a chunk is the bottom left tile's owner.
	///
	/// this is a list with length of world.maxz, with the actual spatial grid list being at the index of the z
	/// e.g. to grab a reserved level's lookup, do `reservation_spatia_lookups[z_index]`
	///
	/// * null means that a level isn't a reservation level
	/// * this also means that we can't zclear / 'free' reserved levels; they're effectively immovable due to this datastructure
	/// * if it is a reserved level, it returns the spatial grid
	/// * to get a chunk, do `spatial_lookup[ceil(where.x / TURF_CHUNK_RESOLUTION) + (ceil(where.y / TURF_CHUNK_RESOLUTION) - 1) * ceil(world.maxx / TURF_CHUNK_RESOLUTION)]`
	/// * being in border counts as being in the reservation. you won't be soon, though.
	var/static/list/reservation_spatial_lookups = list()

	//* System *//
	/// global mutex for ensuring two map/level load ops don't go at once
	/// a separate mutex is used at the actual maploader level
	/// this ensures we aren't shoving maps in during map init, as that can be both laggy and/or bad to legacy code that
	/// expect zlevel adjacency.
	var/map_system_mutex = FALSE

	//! Legacy !//

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

	// init obfuscation
	init_obfuscation_data()
	// init maps
	init_maps()
	// load the map to use
	read_next_map()
	// load world - this also initializes our first reserved level, which is compiled in.
	load_station()

	// todo: refactor - Set up antagonists.
	populate_antag_type_list()
	// todo: refactor - Set up spawn points.
	populate_spawn_points()

	// finalize
	// todo: refactor
	repopulate_sorted_areas()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapping/Recover()
	. = ..()
	reservation_system_mutex = FALSE

/datum/controller/subsystem/mapping/Shutdown()
	. = ..()
	write_next_map()

/datum/controller/subsystem/mapping/on_max_z_changed(old_z_count, new_z_count)
	. = ..()
	if(length(reservation_spatial_lookups) < new_z_count)
		reservation_spatial_lookups.len = new_z_count
	// just to make sure order of ops / assumptions are right
	ASSERT(length(ordered_levels) == world.maxz)
	synchronize_datastructures()

/**
 * Ensure all synchronized lists are valid
 */
/datum/controller/subsystem/mapping/proc/synchronize_datastructures()
#define SYNC(var) if(!var) { var = list() ; } ; if(var.len != world.maxz) { . = TRUE ; var.len = world.maxz; }
	. = FALSE
	SYNC(cached_level_up)
	SYNC(cached_level_down)
	SYNC(cached_level_east)
	SYNC(cached_level_west)
	SYNC(cached_level_north)
	SYNC(cached_level_south)
	SYNC(z_stack_lookup)
	z_stack_dirty = FALSE
	if(.)
		z_stack_dirty = TRUE
#undef SYNC

//! Legacy Below !//

//
// Mapping subsystem handles initialization of random map elements at server start
// For us that means loading our random roundstart engine!
//
/datum/controller/subsystem/mapping
	var/list/map_templates = list()
	var/list/shelter_templates = list()

/datum/controller/subsystem/mapping/Recover()
	. = ..()
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
