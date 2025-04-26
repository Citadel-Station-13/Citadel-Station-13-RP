//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * # /datum/map
 *
 * * clusters of zlevels, basically.
 * * when maps are loaded, areas are cached together to preserve byond-like behavior.
 * * A map can make a /datum/map_struct. This is used to initialize its overmaps,
 *   if an overmap initializer is provided.
 * * While multiple map structs can be made per map with some modifications, this
 *   functionality is not included as there is little reason to support such
 *   behavior. Maps should use the dependencies system to chain-load other maps,
 *   not have multiple planets in one map datum.
 * * Loading more than one instance of a map is not supported at this time,
 *   and will likely never be supported. An upcoming system will be added to handle
 *   instanced planets and similar things.
 */
/datum/map
	abstract_type = /datum/map

	//* Core *//
	/// id - must be unique
	var/id
	/// mangling id override
	var/mangling_id
	/// force mangling ids of levels to be the same
	/// you usually want this to be on!
	var/levels_match_mangling_id = TRUE

	//* Overmaps *//
	/// our overmap initializer
	///
	/// * if specified, our overmap location will be a /datum/overmap_location/struct
	/// * will not be re-fired if overmaps side is what caused us to be loaded. remember,
	///   /datum/overmap_initializer is a bi-directional binding to and from /datum/map!
	/// * a struct is required. if no struct is created, we must be a single-level, which will be auto-structed.
	var/datum/overmap_initializer/overmap_initializer

	/// override map id for persistence so two maps are considered the same
	/// two maps should **never** be loaded at the same time with the same persistence ID!
	var/persistence_id
	/// in-code name
	var/name = "Unknown Map"
	/// in-code category
	var/category = "Misc"
	/// /datum/map_level datums. starts off as paths, inits later.
	/// * This must be ordered in a way where a level above another level must never be below that level in order.
	///   This means that you can go 1-1-1, 1-1-2, 1-2-1, 1-2-2, for a 1x2x2,
	///   or 1-1-1, 1-2-1, 1-1-2, 1-2-2.
	/// * It is recommended to order this based on stacks, so 1-1-1, 1-1-2, 1-2-1, 1-2-2.
	/// * Automatic ordering will be enforced unless specifically overridden, but we still prefer you order it properly
	///   for style / review reasons.
	var/list/datum/map_level/levels
	/// dependencies by id or path of other maps - these are critical maps to always load in
	var/list/dependencies
	/// lateload by id or path of other maps - these are non-critical maps to always load in
	var/list/lateload
	/// are we modified from our prototype?
	var/tmp/modified = FALSE
	/// declared width = must match all levels
	var/width
	/// declared height - must match all levels
	var/height

	//* Load Options *//
	/// orientation - defaults to south
	var/load_orientation = SOUTH
	/// crop if too big, instead of panic
	var/load_auto_crop = FALSE
	/// center us if we're smaller than world size
	var/load_auto_center = TRUE
	/// use map-wide area cache instead of individual level area caches; has no effect on submap loading, only level loading.
	/// don't touch this unless you know what you're doing.
	var/load_shared_area_cache = TRUE

	//* World State *//
	/// are we loaded in
	/// * Once loaded in, we can never be unreferenced / deleted. SSmapping now owns the map permanently, even if unloaded again.
	var/tmp/loaded = FALSE
	/// Quick access - loaded indices
	var/tmp/list/loaded_z_indices
	/// list of stringified z coordinates to the level datum
	///
	/// * "x,y,z" is the format
	var/tmp/list/loaded_z_grid
	/// total width of all levels
	///
	/// * if a level is at 0,0,0 and another is at 5,0,0 with nothing in between, our width is 5
	var/tmp/loaded_sparse_size_x
	/// total height of all levels
	///
	/// * if a level is at 0,0,0 and another is at 0,5,0 with nothing in between, our height is 5
	var/tmp/loaded_sparse_size_y
	/// total depth of all levels
	///
	/// * if a level is at 0,0,0 and another is at 0,0,5 with nothing in between, our depth is 5
	var/tmp/loaded_sparse_size_z

	//* Bindings - Overmaps *//
	/// the overmap location that is binding to us
	///
	/// * If this exists, it will be deleted if we are somehow deleted. This can result
	///   in some very weird things.
	var/datum/overmap_location/map/overmap_binding

	//! legacy : spawn these shuttle datums on load
	var/list/legacy_assert_shuttle_datums

/datum/map/New()
	// immediately resolve dependencies / lateload
	for(var/i in 1 to length(dependencies))
		if(ispath(dependencies[i]))
			var/datum/map/resolving = dependencies[i]
			dependencies[i] = initial(resolving.id)
	for(var/i in 1 to length(lateload))
		if(ispath(lateload[i]))
			var/datum/map/resolving = lateload[i]
			lateload[i] = initial(resolving.id)
	// resolve overmap initializer
	if(ispath(overmap_initializer) || IS_ANONYMOUS_TYPEPATH(overmap_initializer))
		overmap_initializer = new overmap_initializer

/datum/map/Destroy()
	if(loaded)
		. = QDEL_HINT_LETMELIVE
		CRASH("UH OH, SOMETHING TRIED TO DELETE AN INSTANTIATED MAP.")
	for(var/datum/map_level/level in levels)
		if(level.parent_map != src)
			stack_trace("how?")
			continue
		level.parent_map = null
	levels = null
	return ..()

/datum/map/serialize()
	. = ..()
	.["id"] = id
	.["name"] = name
	var/list/serialized_levels = (.["levels"] = list())
	for(var/datum/map_level/level as anything in levels)
		if(!istype(level))
			serialized_levels += level // isn't init'd, probably path or id
			continue
		serialized_levels += json_encode(level.serialize())
	.["dependencies"] = dependencies
	.["lateload"] = lateload
	.["width"] = width
	.["height"] = height
	.["load_auto_crop"] = load_auto_crop
	.["load_auto_center"] = load_auto_center
	.["load_orientation"] = load_orientation
	.["load_shared_area_cache"] = load_shared_area_cache

/datum/map/deserialize(list/data)
	if(loaded)
		CRASH("attempted deserialize while loaded")
	. = ..()
	id = data["id"]
	name = data["name"]
	levels = list()
	for(var/serialized_level in data["levels"])
		var/is_it_a_path = text2path(serialized_level)
		// path
		if(ispath(is_it_a_path, /datum/map_level))
			levels += is_it_a_path
			continue
		// json
		if(serialized_level[1] == "{")
			var/datum/map_level/level = new
			level.deserialize(json_decode(serialized_level))
			levels += level
			continue
	dependencies = data["dependencies"]
	lateload = data["lateload"]
	width = data["width"]
	height = data["height"]
	if(!isnull(data["load_auto_crop"]))
		load_auto_crop = data["load_auto_crop"]
	if(!isnull(data["load_auto_center"]))
		load_auto_center = data["load_auto_center"]
	if(!isnull(data["load_orientation"]))
		load_orientation = data["load_orientation"]
	if(!isnull(data["load_shared_area_cache"]))
		load_shared_area_cache = data["load_shared_area_cache"]

/datum/map/clone()
	. = ..()
	#warn impl

/**
 * validates that everything works
 *
 * @params
 * * out_errors - (optional) human readable errors get added to this list if provided
 * * dry_run - (optional) do not validate loading; otherwise we also validate that we currently can load,
 *             which invokes non-deterministic checks based on current round state
 *
 * @return TRUE / FALSE
 */
/datum/map/proc/validate(list/out_errors, dry_run)
	. = TRUE
	var/list/struct_positions = list()
	var/list/keyed_levels = list()
	// validate levels individually
	for(var/level_idx in 1 to length(levels))
		var/datum/map_level/level = levels[level_idx]
		if(!istype(level))
			out_errors?.Add("map: Index [level_idx] is not a valid map level datum.")
			. = FALSE
			continue
		if(struct_positions[level.struct_create_pos])
			out_errors?.Add("map: Index [level_idx] collides with index [levels.Find(struct_positions[level.struct_create_pos])] on struct position '[level.struct_create_pos]'")
			. = FALSE
		else
			struct_positions[level.struct_create_pos] = level
		if(level.id)
			if(keyed_levels[level.id])
				out_errors?.Add("map: Index [level_idx] collides with index [levels.Find(keyed_levels[level.id])] on level id '[level.id]'")
			else
				keyed_levels[level.id] = level
	// can't run overall checks if any levels are individually invalid
	if(!.)
		return
	// validate struct
	var/datum/map_struct/validation_struct = new
	if(!validation_struct.validate(struct_positions))
		return FALSE
	var/list/struct_errors_out = out_errors ? list() : null
	if(!dry_run && !validate_load(struct_errors_out))
		. = FALSE
	if(length(struct_errors_out))
		for(var/str in struct_errors_out)
			out_errors?.Add("struct: [str]")

/**
 * validate that we can currently load
 *
 * @params
 * * out_errors - (optional) human readable errors get added to this list if provided
 *
 * @return TRUE / FALSE
 */
/datum/map/proc/validate_load(list/out_errors)
	. = TRUE
	for(var/level_idx in 1 to length(levels))
		var/datum/map_level/level = levels[level_idx]
		if(SSmapping.keyed_levels[level.id])
			. = FALSE
			out_errors?.Add("map: Index [level_idx] has id of '[level.id]' which is already taken by a currently loaded level.")

/**
 * loads any lazyloaded stuff we need; called before we load in
 */
/datum/map/proc/prime()
	for(var/i in 1 to length(levels))
		if(ispath(levels[i]))
			var/datum/map_level/level_path = levels[i]
			var/datum/map_level/level_instance = new level_path(src)
			level_instance.hardcoded = TRUE // todo: map can just also not be hardcoded
			levels[i] = level_instance
			if(levels_match_mangling_id)
				level_instance.mangling_id = mangling_id || id

/**
 * Get levels sorted into z-loading order
 */
/datum/map/proc/get_sorted_levels()
	// this only works because tim_sort is stable;
	// cmp_map_level_load_sequence doesn't touch order if structs aren't active.
	return tim_sort(levels.Copy(), /proc/cmp_map_level_load_sequence)
