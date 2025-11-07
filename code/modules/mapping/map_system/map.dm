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
 *
 * ## Loading
 *
 * Generally, the load process is like so;
 * * call ready() to initialize anything lazy-loaded
 * * call validate() to check for soundness of the map
 * * call construct() to set all variables as needed. this will recheck all current levels
 *   and set needed struct vars on ourselves and them, computing things like sparse
 *   size as needed. if the levels already exist, they'll be updated.
 */
/datum/map
	abstract_type = /datum/map

	//* Core *//
	/// id - must be unique
	var/id
	/// mangling id override
	var/mangling_id
	/// override map id for persistence so two maps are considered the same
	/// two maps should **never** be loaded at the same time with the same persistence ID!
	var/persistence_id
	/// Is this registered in SSmapping? Once registered, our reference belongs
	/// to the mapping system, and we can no longer be deleted.
	var/tmp/registered = FALSE
	/// are we modified from our prototype?
	var/tmp/modified = FALSE

	//* Chainload *//
	/// dependencies by id or path of other maps - these are critical maps to always load in
	/// * resolved during ready()
	var/list/dependencies
	/// lateload by id or path of other maps - these are non-critical maps to always load in
	/// * resolved during ready()
	var/list/lateload

	//* Config *//
	/// Allow gateway mission to load?
	var/conf_load_gateway_mission = TRUE

	//* Identity *//
	/// in-code name
	var/name = "Unknown Map"
	/// in-code category
	var/category = "Misc"

	//* Levels *//
	/// /datum/map_level datums. starts off as paths, inits later.
	/// * Automatic ordering will be enforced unless specifically overridden, but we still prefer you order it properly
	///   for style / review reasons.
	var/list/datum/map_level/levels
	/// force mangling ids of levels to be the same
	/// you usually want this to be on!
	var/levels_match_mangling_id = TRUE

	//* Properties *//
	/// declared width = must match all levels
	var/width
	/// declared height - must match all levels
	var/height

	//* Overmaps *//
	/// our overmap initializer
	///
	/// * if specified, our overmap location will be a /datum/overmap_location/map
	/// * will not be re-fired if overmaps side is what caused us to be loaded. remember,
	///   /datum/overmap_initializer is a bi-directional binding to and from /datum/map!
	var/datum/overmap_initializer/map/overmap_initializer

	//* Load Options *//
	/// orientation - defaults to south
	var/load_orientation = SOUTH
	/// crop if too big, instead of panic
	var/load_auto_crop = FALSE
	/// center us if we're smaller than world size
	var/load_auto_center = TRUE
	/// use map-wide area cache instead of individual level area caches; has no effect on submap loading, only level loading.
	/// * don't touch this unless you know what you're doing.
	var/load_shared_area_cache = TRUE

	//* Simulation *//
	/// Ceiling heights for levels that don't specify it, as well as the blank space between levels
	var/ceiling_height_default = 5

	//* World State *//
	/// Are we loaded in?
	var/tmp/loaded = FALSE
	/// Quick access - loaded indices
	/// * This should be in the same order as [levels].
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
	/// z-stacks, addressed by string key "[x],[y]"
	var/tmp/list/loaded_z_stacks
	/// z-planes, addressed by string key "[z]"
	var/tmp/list/loaded_z_planes

	//* Bindings - Overmaps *//
	/// the overmap location that is binding to us
	///
	/// * If this exists, it will be deleted if we are somehow deleted. This can result
	///   in some very weird things.
	var/datum/overmap_location/map/overmap_binding

	//! legacy : spawn these shuttle datums on load
	var/list/legacy_assert_shuttle_datums

/datum/map/New()
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
	// TODO: verify all variables are in here
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
	// TODO: verify all variables are in here
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

// todo: implement clone()

/**
 * called before we load in
 * * should be called before validate()
 * * instances any levels not instanced
 *
 * @return TRUE / FALSE
 */
/datum/map/proc/ready()
	. = TRUE
	for(var/i in 1 to length(levels))
		if(ispath(levels[i]))
			var/datum/map_level/level_path = levels[i]
			var/datum/map_level/level_instance = new level_path(src)
			levels[i] = level_instance
			if(levels_match_mangling_id)
				level_instance.mangling_id = mangling_id || id
	for(var/i in 1 to length(dependencies))
		if(ispath(dependencies[i]))
			var/datum/map/resolving = dependencies[i]
			dependencies[i] = initial(resolving.id)
	for(var/i in 1 to length(lateload))
		if(ispath(lateload[i]))
			var/datum/map/resolving = lateload[i]
			lateload[i] = initial(resolving.id)

/**
 * validates that everything works
 *
 * @params
 * * for_load - (optional) validate for loading, not just that it makes semantic sense
 * * out_errors - (optional) human readable errors get added to this list if provided
 *
 * @return TRUE / FALSE
 */
/datum/map/proc/validate(for_load, list/out_errors)
	. = TRUE
	var/list/struct_position_strs = list()
	var/list/keyed_levels = list()
	var/list/levels_in_plane_by_xy = list()
	// validate levels individually
	for(var/level_idx in 1 to length(levels))
		var/datum/map_level/level = levels[level_idx]
		if(!istype(level))
			out_errors?.Add("level: index [level_idx] is not a valid map level datum.")
			. = FALSE
			continue

		if(level.id)
			if(keyed_levels[level.id])
				out_errors?.Add("level: index [level_idx] collides with index [levels.Find(keyed_levels[level.id])] on level id '[level.id]'")
				. = FALSE
			else
				keyed_levels[level.id] = level

		if(level.has_map_path())
			var/datum/dmm_parsed/parsed = level.parse_map_path()
			if(!parsed)
				out_errors?.Add("level: index [level_idx] couldn't find its map file.")
				. = FALSE
			else if(!parsed.parsed)
				out_errors?.Add("level: index [level_idx] parse failed. is the .dmm malformed?")
				. = FALSE
			else
				if(parsed.width > world.maxx || parsed.height > world.maxy)
					out_errors?.Add("level: index [level_idx] dim [parsed.width]x[parsed.height] > [world.maxx]x[world.maxy]")
					. = FALSE

		var/level_struct_enabled = level.struct_x && level.struct_y && level.struct_z
		if(level_struct_enabled)
			if(!level.id)
				out_errors?.Add("level: index [level_idx] has no id but is in a struct; struct-levels must have IDs.")
				. = FALSE
			var/level_struct_valid = TRUE
			if(!isnum(level.struct_x))
				out_errors?.Add("level: index [level_idx] struct_x not num")
				level_struct_valid = FALSE
			else if(!ISINRANGE(level.struct_x, -(SHORT_REAL_LIMIT * 0.5), (SHORT_REAL_LIMIT * 0.5)) || (round(level.struct_x) != level.struct_x))
				out_errors?.Add("level: index [level_idx] struct_x out of bounds or fractional")
				level_struct_valid = FALSE
			if(!isnum(level.struct_y))
				out_errors?.Add("level: index [level_idx] struct_y not num")
				level_struct_valid = FALSE
			else if(!ISINRANGE(level.struct_y, -(SHORT_REAL_LIMIT * 0.5), (SHORT_REAL_LIMIT * 0.5)) || (round(level.struct_y) != level.struct_y))
				out_errors?.Add("level: index [level_idx] struct_y out of bounds or fractional")
				level_struct_valid = FALSE
			if(!isnum(level.struct_z))
				out_errors?.Add("level: index [level_idx] struct_z not num")
				level_struct_valid = FALSE
			else if(!ISINRANGE(level.struct_z, -(SHORT_REAL_LIMIT * 0.5), (SHORT_REAL_LIMIT * 0.5)) || (round(level.struct_z) != level.struct_z))
				out_errors?.Add("level: index [level_idx] struct_z out of bounds or fractional")
				level_struct_valid = FALSE
			if(level_struct_valid)
				var/level_struct_position_str = "[level.struct_x],[level.struct_y],[level.struct_z]"
				var/level_struct_plane_xy = "[level.struct_x],[level.struct_y]"
				if(struct_position_strs[level_struct_position_str])
					out_errors?.Add("level: index [level_idx] collides with level index [levels.Find(struct_position_strs[level_struct_position_str])] on struct position '[level_struct_position_str]'")
					. = FALSE
				else
					struct_position_strs[level_struct_position_str] = level
					if(!levels_in_plane_by_xy[level_struct_plane_xy])
						levels_in_plane_by_xy[level_struct_plane_xy] = list()
					levels_in_plane_by_xy[level_struct_plane_xy] += level

		// TODO: invoke level datum validation, including for base turf/area validity (see spawn flags & area not `special`)

	// can't run overall checks if any levels are individually invalid
	if(!.)
		return

	for(var/plane_str in levels_in_plane_by_xy)
		var/list/datum/map_level/plane_levels = levels_in_plane_by_xy[plane_str]
		var/found_ceiling_height
		for(var/datum/map_level/plane_level as anything in plane_levels)
			if(isnull(plane_level.ceiling_height))
				continue
			if(plane_level.ceiling_height == 0)
				out_errors?.Add("Plane [plane_str] has a zero ceiling height level.")
				. = FALSE
				break
			if(!isnull(found_ceiling_height) && found_ceiling_height != plane_level.ceiling_height)
				out_errors?.Add("Plane [plane_str] has mismatching ceiling heights.")
				. = FALSE
				break
			else
				found_ceiling_height = plane_level.ceiling_height

	if(for_load && !validate_load(out_errors, .))
		. = FALSE

/**
 * validate that we can currently load
 * * this checks for things like collisions with current loaded maps, levels, world state, etc
 *
 * @params
 * * out_errors - (optional) human readable errors get added to this list if provided
 * * structure_validity - (optional) pass in if structure is valid; this makes it so we don't run
 *                        future tests that would always fail if the map's contents for whatever reason
 *                        are considered invalid.
 *
 * @return TRUE / FALSE
 */
/datum/map/proc/validate_load(list/out_errors, structure_validity)
	. = TRUE
	for(var/level_idx in 1 to length(levels))
		var/datum/map_level/level = levels[level_idx]
		if(SSmapping.keyed_levels[level.id])
			. = FALSE
			out_errors?.Add("level: index [level_idx] has id of '[level.id]' which is already taken by a currently loaded level.")

/**
 * rebuilds state, setting variables as needed on ourselves and our level
 * * should be called after validate(); validate() doesn't require this to work
 * * if loaded maps have their multiz things change, this'll have ssmapping rebuild its cache
 *   and also rebuild the transitions
 * * this will trample any custom linkages set on levels if they're not set to LINKAGE_FORCED!
 * * this will **not** trample reciprocal custom linkages. if another level links to a level in us,
 *   that level will not be unbound despite our level now being unbound.
 *
 * TODO: mode to only re-assert internal linkages, without disrupting linkages to other levels outside of ours.
 *
 * @params
 * * skip_validation - skip data validation. this should only be done if you already validate()'d before construct().
 * * skip_loaded_rebuild - do not rebuild loaded zlevels immediately.
 */
/datum/map/proc/construct(skip_validation, skip_loaded_rebuild)
	var/list/validation_errors = list()
	if(!validate(TRUE, validation_errors))
		CRASH("validation failed at construct() with errors: [english_list(validation_errors)]; this shouldn't be failing this far in the pipeline, please remember to validate() maps yourself!")

	var/list/datum/map_level/loaded_levels_requiring_immediate_rebuild_to_dirs = list()

	var/z_grid = list()
	var/z_stacks = list()
	var/z_planes = list()

	// collect data
	for(var/datum/map_level/level as anything in levels)
		level.struct_active = level.is_in_struct()
		if(!level.struct_active)
			continue

		z_grid["[level.struct_x],[level.struct_y],[level.struct_z]"] = level

		var/x_y_str = "[level.struct_x],[level.struct_y]"
		if(!z_stacks[x_y_str])
			z_stacks[x_y_str] = list()
		z_stacks[x_y_str] += level

		var/z_str = "[level.struct_z]"
		if(!z_planes[z_str])
			z_planes[z_str] = list()
		z_planes[z_str] += level

	// sweep levels
	for(var/datum/map_level/level as anything in levels)
		level.load_orientation = load_orientation
		level.load_center = load_auto_center
		level.load_crop = load_auto_crop

		if(level.struct_active)
			var/level_multiz_changed_dirs = NONE
			switch(level.linkage)
				if(Z_LINKAGE_FORCED)
				if(Z_LINKAGE_NORMAL)
					var/datum/map_level/level_partner
					level_partner = z_grid["[level.struct_x+1],[level.struct_y],[level.struct_z]"]
					if(level.link_east_id != level_partner?.id)
						level.link_east_id = level_partner?.id
						level_multiz_changed_dirs |= EAST
					level_partner = z_grid["[level.struct_x-1],[level.struct_y],[level.struct_z]"]
					if(level.link_west_id != level_partner?.id)
						level.link_west_id = level_partner?.id
						level_multiz_changed_dirs |= WEST
					level_partner = z_grid["[level.struct_x],[level.struct_y+1],[level.struct_z]"]
					if(level.link_north_id != level_partner?.id)
						level.link_north_id = level_partner?.id
						level_multiz_changed_dirs |= NORTH
					level_partner = z_grid["[level.struct_x],[level.struct_y-1],[level.struct_z]"]
					if(level.link_south_id != level_partner?.id)
						level.link_south_id = level_partner?.id
						level_multiz_changed_dirs |= SOUTH
					level_partner = z_grid["[level.struct_x],[level.struct_y],[level.struct_z+1]"]
					if(level.link_above_id != level_partner?.id)
						level.link_above_id = level_partner?.id
						level_multiz_changed_dirs |= UP
					level_partner = z_grid["[level.struct_x],[level.struct_y],[level.struct_z-1]"]
					if(level.link_below_id != level_partner?.id)
						level.link_below_id = level_partner?.id
						level_multiz_changed_dirs |= DOWN

			if(level.loaded && level_multiz_changed_dirs)
				loaded_levels_requiring_immediate_rebuild_to_dirs[level] = level_multiz_changed_dirs

	for(var/datum/map_level/rebuilding_level as anything in loaded_levels_requiring_immediate_rebuild_to_dirs)
		var/rebuild_dirs = loaded_levels_requiring_immediate_rebuild_to_dirs[rebuilding_level]
		SSmapping.rebuild_multiz_lookup(rebuilding_level.z_index, rebuild_dirs)
		if(!skip_loaded_rebuild && rebuilding_level.loaded)
			if(rebuild_dirs & (NORTH|SOUTH|EAST|WEST))
				rebuilding_level.rebuild_multiz_horizontal()
			else
				rebuilding_level.rebuild_multiz_vertical()

	return TRUE

/**
 * Get levels sorted into z-loading order
 */
/datum/map/proc/get_sorted_levels()
	// this only works because tim_sort is stable;
	// cmp_map_level_load_sequence doesn't touch order if structs aren't active.
	return tim_sort(levels.Copy(), /proc/cmp_map_level_load_sequence)
