/datum/map_template
	/// abstract type
	abstract_type = /datum/map_template

	var/name = "Default Template Name"
	var/desc = "Some text should go here. Maybe."
	/// If this is set, no more than one template in the same group will be spawned, per submap seeding.
	var/template_group = null

	/// The map generator has a set 'budget' it spends to place down different submaps. It will pick available submaps randomly until
	/// it runs out. The cost of a submap should roughly corrispond with several factors such as size, loot, difficulty, desired scarcity, etc.
	/// Set to -1 to force the submap to always be made.
	var/cost = null
	/// If false, only one map template will be spawned by the game. Doesn't affect admins spawning then manually.
	var/allow_duplicates = FALSE
	/// If non-zero, there is a chance that the map seeding algorithm will skip this template when selecting potential templates to use.
	var/discard_prob = 0
	// For ruins
	var/fixed_orientation = FALSE

	//* file
	/// path to the map
	var/map_path

	//* cached data
	/// cached map
	var/datum/dmm_parsed/parsed
	/// keep cached map
	var/cache_parsed_map = FALSE
	/// cached width
	var/width = 0
	/// cached height
	var/height = 0

	//* loading
	/// times loaded this round
	var/tmp/loaded = 0
	/// If true, all (movable) atoms at the location where the map is loaded will be deleted before the map is loaded in.
	var/annihilate = FALSE

	//* loading as its own level
	/// traits to have if loaded as standalone level
	var/list/level_traits
	/// attributes to have if loaded as standalone level
	var/list/level_attributes
	/// id to have if loaded as standalone level
	var/level_id

/datum/map_template/New(path, name)
	if(!isnull(name))
		src.name = name
	if(!isnull(path))
		src.map_path = path
	preload()

/datum/map_template/proc/preload()
	if(isnull(map_path))
		return FALSE
	var/datum/dmm_parsed/parsing = parse_map(map_path)
	. = !!parsing
	width = parsing.width
	height = parsing.height
	if(cache_parsed_map)
		parsed = parsing

/datum/map_template/proc/parsed()
	if(isnull(parsed))
		. = parse_map(map_path)
		if(cache_parsed_map)
			parsed = .
	else
		. = parsed


/datum/map_template/proc/unload()
	parsed = null

/datum/map_template/proc/load_new_z(centered = FALSE, orientation = SOUTH, list/traits = src.level_traits, list/attributes = src.level_attributes)
	SSmapping.subsystem_log("Loading template [src] ([type]) on a new z-level...")

	var/ll_x = 1
	var/ll_y = 1
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? height : width
	var/real_height = sideways? width : height

	if(centered)
		ll_x = round((world.maxx - real_width) / 2)
		ll_y = round((world.maxy - real_height) / 2)

	var/datum/map_level/dynamic/level = new
	level.traits = traits.Copy()
	level.attributes = attributes.Copy()
	SSmapping.allocate_level(level)

	ASSERT(level.loaded)

	load(locate(ll_x, ll_y, level.z_index), FALSE, orientation)

	SSmapping.subsystem_log("Loaded template [src] ([type]) on z-level [level.z_index]")

	on_z_load(level.z_index)

/**
 * loads a map template
 *
 * @params
 * * T - turf. center or lower left, depending on centered param.
 * * centered - is T the center, or lower left?
 * * orientation - the orientation to load in. default is SOUTH.
 * * deferred_callbacks - if specified, generation callbacks are deferred and added to this list, instead of fired immediately.
 */
/datum/map_template/proc/load(turf/T, centered = FALSE, orientation = SOUTH, list/datum/callback/deferred_callbacks)
	. = FALSE
	var/ll_x = T.x
	var/ll_y = T.y
	var/ll_z = T.z
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? height : width
	var/real_height = sideways? width : height

	if(centered)
		ll_x -= round(real_width / 2)
		ll_y -= round(real_height / 2)

	var/turf/real_turf = locate(ll_x, ll_y, ll_z)

	SSmapping.subsystem_log("Loading template [src] ([type]) at [COORD(real_turf)] size [width]x[height] with annihilate mode [annihilate]")

	if(annihilate)
		annihilate_bounds(real_turf, width, height)

	var/datum/dmm_parsed/parsed = parsed()
	var/list/loaded_bounds = parsed.load(ll_x, ll_y, ll_z, orientation = orientation)

	if(isnull(loaded_bounds))
		CRASH("failed to load")

	++loaded

	var/list/datum/callback/callbacks = list()
	on_normal_load(loaded_bounds, callbacks)
	if(isnull(deferred_callbacks))
		for(var/datum/callback/cb as anything in callbacks)
			cb.Invoke()
	else
		deferred_callbacks += callbacks

	init_bounds(loaded_bounds)

	// todo: inefficient as shit
	if(SSmapping.initialized)
		repopulate_sorted_areas()
	// end

	return TRUE

/datum/map_template/proc/annihilate_bounds(turf/ll_turf, width, height)
	SSmapping.subsystem_log("Annihilating bounds in template spawn location: [COORD(ll_turf)] with area [width]x[height]")
	var/list/turf/cleaning = block(
		ll_turf,
		locate(
			ll_turf.x + width - 1,
			ll_turf.y + height - 1,
			ll_turf.z
		)
	)
	var/cleaned = 0
	for(var/turf/T as anything in cleaning)
		for(var/atom/movable/AM as anything in T)
			if(!(AM.atom_flags & ATOM_ABSTRACT))
				continue
			qdel(AM)
			++cleaned
	SSmapping.subsystem_log("Deleted [cleaned] atoms.")

/datum/map_template/proc/get_affecting_turfs(turf/T, centered = FALSE, orientation = SOUTH)
	var/ll_x = T.x
	var/ll_y = T.y
	var/ll_z = T.z
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? height : width
	var/real_height = sideways? width : height

	if(centered)
		ll_x -= round(real_width / 2)
		ll_y -= round(real_height / 2)

	var/turf/ll_turf = locate(ll_x, ll_y, ll_z)
	return block(
		ll_turf,
		locate(
			ll_turf.x + width - 1,
			ll_turf.y + height - 1,
			ll_turf.z
		)
	)

/datum/map_template/proc/init_bounds(list/bounds)
	initTemplateBounds(bounds)

// todo: legacy code, this can probably be made better over time
/datum/map_template/proc/initTemplateBounds(var/list/bounds)
	if (SSatoms.initialized == INITIALIZATION_INSSATOMS)
		return	// Let proper initialisation handle it later

	var/prev_shuttle_queue_state = SSshuttle.block_init_queue
	SSshuttle.block_init_queue = TRUE

	var/list/atom/atoms = list()
	var/list/area/areas = list()
	var/list/obj/structure/cable/cables = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/turf/turfs = block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
	                   			locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	for(var/L in turfs)
		var/turf/B = L
		B.queue_zone_update()
		QUEUE_SMOOTH(B)
		atoms += B
		areas |= B.loc
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
			else if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A
	atoms |= areas

	admin_notice("<span class='danger'>Initializing newly created atom(s) in submap.</span>", R_DEBUG)
	SSatoms.InitializeAtoms(atoms)

	admin_notice("<span class='danger'>Initializing atmos pipenets and machinery in submap.</span>", R_DEBUG)
	SSmachines.setup_atmos_machinery(atmos_machines)

	admin_notice("<span class='danger'>Rebuilding powernets due to submap creation.</span>", R_DEBUG)
	SSmachines.setup_powernets_for_cables(cables)

	// Ensure all machines in loaded areas get notified of power status
	for(var/I in areas)
		var/area/A = I
		A.power_change()

	SSshuttle.block_init_queue = prev_shuttle_queue_state
	SSshuttle.process_init_queues()	// We will flush the queue unless there were other blockers, in which case they will do it.

	admin_notice("<span class='danger'>Submap initializations finished.</span>", R_DEBUG)

/**
 * called when normally loaded
 *
 * @params
 * * bounds - map bounds of load. use defines like MAP_MINX/MAP_MINY/etc to access.
 * * late_generation - callbacks to fire after ruin seeding. if this is being spawned standalone, it fires immediately.
 */
/datum/map_template/proc/on_normal_load(list/bounds, list/datum/callback/late_generation)
	return

/**
 * called when loaded as a new zlevel
 *
 * @params
 * * z_index - zlevel we loaded onto
 */
/datum/map_template/proc/on_z_load(z_index)
	return
