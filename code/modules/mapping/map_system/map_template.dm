/datum/map_template
	abstract_type = /datum/map_template

	/**
	 * ID.
	 * * Map templates that are registered proper have IDs.
	 * * ID is currently optional, because 'ephemeral' map templates
	 *   do exist.
	 * * Please still fill it in when you can.
	 */
	var/id
	#warn impl

	//* description *//
	/// template name
	var/name = "Default Template Name"
	/// template description
	var/desc = "Some text should go here. Maybe."

	//* file *//
	/// path to the map
	var/map_path
	/// prefix of path including last /
	var/prefix
	/// suffix of path (usually just the filename)
	var/suffix

	//* cached data *//
	/// cached map
	var/datum/dmm_parsed/parsed
	/// keep cached map
	var/cache_parsed_map = FALSE
	/// cached width
	var/width = 0
	/// cached height
	var/height = 0

	//* loading *//
	/// times loaded this round
	var/tmp/loaded = 0
	/// If true, all (movable) atoms at the location where the map is loaded will be deleted before the map is loaded in.
	/// * Deprecated
	var/annihilate = FALSE

	//* loading as its own level *//
	/// traits to have if loaded as standalone level
	var/list/level_traits
	/// attributes to have if loaded as standalone level
	var/list/level_get_attributes
	/// id to have if loaded as standalone level
	var/level_id

	//* global state (yes i said global state too bad) *//
	/**
	 * Increased every time recursively_load is called. This is used to prevent infinite recursion when templates load other templates.
	 */
	var/static/recursive_load_level = 0

	//* legacy below *//

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

/datum/map_template/New(path, name)
	if(!isnull(name))
		src.name = name
	if(!isnull(path))
		src.map_path = path
	if(isnull(map_path))
		map_path = "[prefix][suffix]"
	preload()

/**
 * gets our width/height
 *
 * uses cache if possible; if cache_parsed_map is TRUE, this will autoamtically cache.
 */
/datum/map_template/proc/preload()
	if(isnull(map_path))
		return FALSE
	var/datum/dmm_parsed/parsing = parse_map(isfile(map_path)? map_path : file(map_path))
	. = !!parsing
	width = parsing.width
	height = parsing.height
	if(cache_parsed_map)
		parsed = parsing

/**
 * gets our parsed map
 *
 * uses cache if possible; if cache_parsed_map is TRUE, this will autoamtically cache.
 */
/datum/map_template/proc/parsed()
	if(isnull(parsed))
		. = parse_map(isfile(map_path)? map_path : file(map_path))
		if(cache_parsed_map)
			parsed = .
	else
		. = parsed

/**
 * ensures our parsed map is cached
 */
/datum/map_template/proc/load_cache()
	var/old = cache_parsed_map
	cache_parsed_map = TRUE
	parsed()
	cache_parsed_map = old

/**
 * throws out our cached parsed map
 */
/datum/map_template/proc/unload_cache()
	parsed = null

/// deprecated
/datum/map_template/proc/load_new_z(centered = FALSE, orientation = SOUTH, list/traits = src.level_traits, list/attributes = src.level_get_attributes)
	. = FALSE

	SSmapping.subsystem_log("Loading template [src] ([type]) on a new z-level...")

	var/ll_x = 1
	var/ll_y = 1
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? height : width
	var/real_height = sideways? width : height

	if(centered)
		ll_x = round((world.maxx - real_width) / 2)
		ll_y = round((world.maxy - real_height) / 2)

	var/datum/map_level/dynamic/level = SSmapping.allocate_level(/datum/map_level/dynamic)
	for(var/trait in traits)
		level.add_trait(trait)
	for(var/key in attributes)
		var/value = attributes[key]
		level.set_attribute(key, value)

	ASSERT(level.loaded)

	load(locate(ll_x, ll_y, level.z_index), FALSE, orientation)

	SSmapping.subsystem_log("Loaded template [src] ([type]) on z-level [level.z_index]")

	return TRUE

/**
 * Gets lower left tile from a centered position.
 * @return list(x, y, z)
 */
/datum/map_template/proc/compute_lower_left_coords_from_centered_turf(turf/centered, orientation)
	if(!width || !height)
		CRASH("bounds not preloaded")

	var/ll_x = centered.x
	var/ll_y = centered.y
	var/ll_z = centered.z
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? height : width
	var/real_height = sideways? width : height

	ll_x -= round(real_width / 2)
	ll_y -= round(real_height / 2)

	return list(ll_x, ll_y, ll_z)

/**
 * Loads a map template and executes postload for its context.
 *
 * @params
 * * lower_left - lower left corner of where to load the template
 * * orientation - the orientation to load in. default is SOUTH.
 * * context - dmm_context to use; one will be created if not provided.
 * * annihilate_bounds - (deprecated) wipe out bounds
 *
 * @return loaded dmm_context, or null if failed
 */
/datum/map_template/proc/load_standalone(turf/lower_left, orientation = SOUTH, datum/dmm_context/context, annihilate_bounds = annihilate)
	var/datum/dmm_context/context = load_deferred(lower_left, orientation, context, annihilate_bounds)
	if(!context)
		return

	context.execute_post_init()
	return context

/datum/map_template/proc/load_standalone_centered(turf/centered, orientation = SOUTH, datum/dmm_context/context, annihilate_bounds = annihilate)
	return load_standalone(
		locate(arglist(compute_lower_left_coords_from_centered_turf(centered, orientation))),
		orientation,
		context,
		annihilate_bounds,
	)

/**
 * Loads a map template without executing postload for its context.
 *
 * @params
 * * lower_left - lower left corner of where to load the template
 * * orientation - the orientation to load in. default is SOUTH.
 * * context - dmm_context to use; one will be created if not provided.
 * * annihilate_bounds - (deprecated) wipe out bounds
 *
 * @return loaded dmm_context, or null if failed
 */
/datum/map_template/proc/load_deferred(turf/lower_left, orientation = SOUTH, datum/dmm_context/context, annihilate_bounds = annihilate)
	var/datum/dmm_context/context = load_impl(lower_left, orientation, context, annihilate_bounds)
	return context

/datum/map_template/proc/load_deferred_centered(turf/centered, orientation = SOUTH, datum/dmm_context/context, annihilate_bounds = annihilate)
	return load_deferred(
		locate(arglist(compute_lower_left_coords_from_centered_turf(centered, orientation))),
		orientation,
		context,
		annihilate_bounds,
	)

/datum/map_template/proc/load_impl(turf/real_turf, orientation, datum/dmm_context/context, annihilate_bounds)

	SSmapping.subsystem_log("Loading template [src] ([type]) at [COORD(real_turf)] size [width]x[height] with annihilate mode [annihilate]")

	if(annihilate_bounds)
		annihilate_bounds(real_turf, width, height)

	// ensure the dmm is parsed
	var/datum/dmm_parsed/parsed = parsed()

	// create context
	if(isnull(context))
		context = new
	if(isnull(context.mangling_id))
		context.mangling_id = generate_mangling_id()

	context = parsed.load(real_turf.x, real_turf.y, real_turf.z, orientation = orientation, context = context)

	if(!context.loaded())
		CRASH("failed to load")

	var/list/loaded_bounds = context.loaded_bounds

	++loaded

	context.execute_pre_init()

	if(!SSatoms.initialized)
		init_bounds(loaded_bounds)

	// todo: inefficient as shit
	if(SSmapping.initialized)
		repopulate_sorted_areas()
	// end

	return context

/**
 * generate a random mangling ID for us to use
 */
/datum/map_template/proc/generate_mangling_id()
	var/static/notch = 0
	if(notch >= SHORT_REAL_LIMIT)
		notch = 0
	return "template-[++notch]"

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
			if(AM.atom_flags & (ATOM_ABSTRACT | ATOM_NONWORLD))
				continue
			qdel(AM)
			++cleaned
	SSmapping.subsystem_log("Deleted [cleaned] atoms.")

/datum/map_template/proc/get_affecting_turfs(turf/where, centered = FALSE, orientation = SOUTH)
	var/ll_x = where.x
	var/ll_y = where.y
	var/ll_z = where.z
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? height : width
	var/real_height = sideways? width : height

	if(centered)
		ll_x -= round(real_width / 2)
		ll_y -= round(real_height / 2)

	var/turf/ll_turf = clamped_locate(ll_x, ll_y, ll_z)
	return block(
		ll_turf,
		clamped_locate(
			ll_x + width - 1,
			ll_y + height - 1,
			ll_z
		)
	)

/datum/map_template/proc/init_bounds(list/bounds)
	SSatoms.init_map_bounds(bounds)

/**
 * Called post-load, pre-init.
 *
 * * Use the context reference to pass in callbacks as needed to map init pre/post load lists.
 *
 * @params
 * * context - load context
 */
/datum/map_template/proc/on_load(datum/dmm_context/context)
	return

/**
 * Just used for map specific templates.
 * * Format: `/datum/map_template/map_specific/[map name]`
 */
/datum/map_template/map_specific
	abstract_type = /datum/map_template/map_specific
