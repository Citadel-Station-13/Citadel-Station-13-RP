//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * a struct for holding information about a zlevel
 *
 * ## Loading
 *
 * * See `map.dm` for load call order.
 */
/datum/map_level
	//* Core *//
	/// id - must be globally unique across all possible maps
	/// if we are New()'d with a map, this is namespaced with that map automatically! you do not need
	/// to namespace map levels yourself.
	/// please use 'dashes-as-spacing' to format ids.
	///
	/// * if this is null, one will be assigned.
	/// * this is used to generate mangling ID.
	var/id
	/// friendly debug / code name of level
	var/name
	/// explicit mangling id
	var/mangling_id

	//* Attributes *//
	/// traits
	var/list/traits
	/// attributes associated key-values
	var/list/attributes

	//* File *//
	/// Absolute path to the map .dmm file.
	/// * This can be a literal file.
	/// * This is determined with regards to the context of the load.
	/// * Hardcoded shuttle templates will be the path from the server's working directory.
	var/path

	//* Fluff *//
	/// player visible id for technical displays - randomized if unset
	var/display_id
	/// player visible name for non-technical displays - randomized if unset
	var/display_name

	//* Instance / Orchestration *//
	/// host /datum/map, if any
	var/datum/map/parent_map
	/// are we modified from our prototype/definition?
	var/tmp/modified = FALSE

	//* Linkage *//
	/// linkage enum
	var/linkage = Z_LINKAGE_NORMAL
	/// transition enum
	var/transition = Z_TRANSITION_DEFAULT
	/// set to FALSE if transition borders are defined via /turf/level_border, to disable trampling the turf into /turf/level_border
	var/transition_trampling = TRUE

	/// id of north zlevel
	var/link_north_id
	/// id of south zlevel
	var/link_south_id
	/// id of west zlevel
	var/link_west_id
	/// id of east zlevel
	var/link_east_id
	/// id of below zlevel
	var/link_below_id
	/// id of above zlevel
	var/link_above_id

	//* Turf Properties *//
	/// base turf typepath for this level
	/// * This is one of the few places where this is allowed to be /turf/space/basic rather
	///   than /turf/space. This optimizes mapload.
	var/base_turf = /turf/space/basic
	/// base area typepath for this level
	var/base_area = /area/space
	/// gas string / atmosphere path / atmosphere id for indoors air
	/// if atmosphere path, it'll be automatically packed to ID on serialize, as we don't want to serialize paths to disk.
	var/air_indoors = GAS_STRING_STP
	/// gas string / atmosphere path / atmosphere id for outdoors air
	/// if atmosphere path, it'll be automatically packed to ID on serialize, as we don't want to serialize paths to disk.
	var/air_outdoors = GAS_STRING_VACUUM

	//* World State *//
	/// Are we loaded in?
	var/tmp/loaded = FALSE
	/// our zlevel once loaded
	var/tmp/z_index

	//* Load Options *//
	/// load orientation - overridden if loaded as part of a /datum/map
	var/load_orientation = SOUTH
	/// load should crop - overridden if loaded as part of a /datum/map
	var/load_crop = FALSE
	/// load should center us on the world level - overridden if loaded as part of a /datum/map
	var/load_center = TRUE

	//* Rebuilds *//
	/// a vertical rebuild is blocking; don't bother queuing another
	var/tmp/multiz_vertical_rebuild_queued = FALSE
	/// multiz vertical rebuild mutex
	var/tmp/multiz_vertical_rebuild_mutex = FALSE
	/// tracking for perf
	var/tmp/multiz_vertical_rebuild_count = 0
	/// a horizontal rebuild is blocking; don't bother queuing another
	var/tmp/multiz_horizontal_rebuild_queued = FALSE
	/// multiz horizontal rebuild mutex
	var/tmp/multiz_horizontal_rebuild_mutex = FALSE
	/// tracking for perf
	var/tmp/multiz_horizontal_rebuild_count = 0

	//* Simulation *//
	/// canonical height of level in meters
	///
	/// * '100m' means that the level above is 100m above us, and we're 100m below the above level
	/// * basically, this is the height from ground before the next level, not the height below ground
	/// * if null, will inherit from the map we're in (or default to a sane value)
	/// * if non-null, the map will force that z-plane to be that height
	/// * if non-null and two levels in the same plane have different values, the parent map will runtime.
	/// * if one level on a plane is non-null height, all of them must be, and they must match.
	var/ceiling_height

	//* Structs / Stitching / Virtual Coordinates *//
	/// Are we in a struct? Do not set directly, this is set on load
	/// if struct x/y/z are set.
	var/tmp/struct_active = FALSE
	/// our virtual x on the struct; this is not tile coordinates, this is struct coordinates
	/// * set as needed so the map knows where to put us in the virtual struct.
	var/struct_x
	/// our virtual y on the struct; this is not tile coordinates, this is struct coordinates
	/// * set as needed so the map knows where to put us in the virtual struct.
	var/struct_y
	/// the coordinate we are actually on, zlevel wise
	///
	/// * basically for fluff and simulation, not byond engine
	/// * this is used for virtual coordinates as the 'z'
	/// * set as needed so the map knows where to put us in the virtual struct.
	var/struct_z

	//* Virtual Coordinates *//
	/// the coordinate of the lower-left / southwest corner border of the map
	///

	/// * this is not 1,1 on the map, this is the offset to reach 0,0 on the map from 1,1.
	/// * this is the turf right **outside** the on the lower left corner.
	/// * basically for fluff and simulation, not byond engine
	/// * 0-indexed for ease of use by implementations of get virtual coord.
	/// * this is used for virtual coordinates as the 'x + [tile.x]'
	var/tmp/virtual_alignment_x = 0
	/// the coordinate of the lower-left / southwest corner border of the map
	///
	/// * this is not 1,1 on the map, this is the offset to reach 0,0 on the map from 1,1.
	/// * this is the turf right **outside** the on the lower left corner.
	/// * basically for fluff and simulation, not byond engine
	/// * 0-indexed for ease of use by implementations of get virtual coord.
	/// * this is used for virtual coordinates as the 'y + [tile.y]'
	var/tmp/virtual_alignment_y = 0
	/// the canonical height from ground floor that we are
	///
	/// * virtual_z = 0 is always 0
	/// * virtual_z = 1 is the ceiling_height of virtual_z = 0
	/// * virtual_z = -1 is the subtracted ceiling height of virtual_z = -1
	var/tmp/virtual_elevation = 0

	//* Persistence *//
	/// loaded persistence metadata, if any
	var/tmp/datum/map_level_persistence/persistence
	/// allow persistence?
	var/persistence_allowed = FALSE
	/// override level id for persistence so two levels are considered the same
	/// two levels should **never** be loaded at the same time with the same persistence ID!
	var/persistence_id

	//* Persistence - Debris *//
	/// drop n largest zones
	///
	/// 0 to disable
	var/persistent_debris_drop_n_largest = OBJ_PERSIST_DEFAULT_TUNING_DEBRIS_DROP_N_LARGEST
	/// drop n smallest non-single zones
	///
	/// 0 to disable
	var/persistent_debris_drop_n_smallest = OBJ_PERSIST_DEFAULT_TUNING_DEBRIS_DROP_N_SMALLEST
	/// drop n single object zones
	///
	/// 0 to disable
	var/persistent_debris_drop_n_single = OBJ_PERSIST_DEFAULT_TUNING_DEBRIS_DROP_N_SINGLE
	/// % chance per round to drop 'important' persistent debris like graffiti
	/// we drop them as a zone when we drop.
	///
	/// 0 to disable
	var/persistent_debris_important_drop_chance = OBJ_PERSIST_DEFAULT_TUNING_DEBRIS_IMPORTANT_DROP_CHANCE
	/// critical mass of important debris count needed in a zone before they're treated
	/// as regular debris: mostly for grief prevention
	///
	/// 0 to disable; will override defaults
	var/persistent_debris_important_demotion_zone_threshold = OBJ_PERSIST_DEFAULT_TUNING_DEBRIS_IMPORTANT_DEMOTION_ZONE_THRESHOLD
	/// critical mass of important debris total needed before they're treated
	/// as regular debris; mostly for grief prevention
	///
	/// 0 to disable; will override defaults
	var/persistent_debris_important_demotion_level_threshold = OBJ_PERSIST_DEFAULT_TUNING_DEBRIS_IMPORTANT_DEMOTION_LEVEL_THRESHOLD

	//* Persistence - Trash *//
	/// drop n largest meshes of trash
	var/persistent_trash_drop_n_largest = OBJ_PERSIST_DEFAULT_TUNING_TRASH_DROP_N_LARGEST
	/// drop n smallest meshes of trash
	var/persistent_trash_drop_n_smallest = OBJ_PERSIST_DEFAULT_TUNING_TRASH_DROP_N_SMALLEST
	/// drop n least dense single items of trash
	var/persistent_trash_drop_n_most_isolated = OBJ_PERSIST_DEFAULT_TUNING_TRASH_DROP_N_MOST_ISOLATED
	/// drop n most dense single items of trash
	var/persistent_trash_drop_n_least_isolated = OBJ_PERSIST_DEFAULT_TUNING_TRASH_DROP_N_LEAST_ISOLATED
	/// mesh heuristic in tiles
	var/persistent_trash_mesh_heuristic = OBJ_PERSIST_DEFAULT_TUNING_TRASH_MESH_HEURISTIC
	/// additional mesh heuristic per 1000 objects
	var/persistent_trash_mesh_heuristic_escalate_per_thousand = OBJ_PERSIST_DEFAULT_TUNING_TRASH_MESH_HEURISTIC_ESCALATE_PER_THOUSAND

/datum/map_level/New(datum/map/parent_map)
	src.parent_map = parent_map

/datum/map_level/Destroy()
	if(loaded)
		. = QDEL_HINT_LETMELIVE
		CRASH("UH OH, SOMETHING TRIED TO DELETE AN INSTANTIATED LEVEL.")
	parent_map = null
	return ..()

/datum/map_level/serialize()
	. = ..()
	.["id"] = id
	.["name"] = name
	.["display_id"] = display_id
	.["display_name"] = display_name
	.["traits"] = traits
	.["attributes"] = attributes
	// not sure why we're even serializing paths but here we go lol
	.["path"] = path
	// end
	.["linkage"] = linkage
	.["transition"] = transition
	.["base_turf"] = "[base_turf]"
	.["base_area"] = "[base_area]"
	.["link_north_id"] = link_north_id
	.["link_south_id"] = link_south_id
	.["link_west_id"] = link_west_id
	.["link_east_id"] = link_east_id
	.["link_above_id"] = link_above_id
	.["link_below_id"] = link_below_id

	var/unpacked_air_indoors
	if(ispath(air_indoors, /datum/atmosphere))
		var/datum/atmosphere/cast_air_indoors = air_indoors
		// cast to id if possible, otherwise keep as type
		unpacked_air_indoors = initial(cast_air_indoors.id) || air_indoors
	var/unpacked_air_outdoors
	if(ispath(air_outdoors, /datum/atmosphere))
		var/datum/atmosphere/cast_air_outdoors = air_outdoors
		// cast to id if possible, otherwise keep as type
		unpacked_air_outdoors = initial(cast_air_outdoors.id) || air_outdoors
	.["air_indoors"] = unpacked_air_indoors
	.["air_outdoors"] = unpacked_air_outdoors

	.["load_orientation"] = load_orientation
	.["load_center"] = load_center
	.["load_crop"] = load_crop

/datum/map_level/deserialize(list/data)
	if(loaded)
		CRASH("attempted deserialize while loaded")
	. = ..()
	if(!isnull(data["id"]))
		id = data["id"]
	if(!isnull(data["name"]))
		name = data["name"]
	if(!isnull(data["display_id"]))
		display_id = data["display_id"]
	if(!isnull(data["display_name"]))
		display_name = data["display_name"]
	if(!isnull(data["traits"]))
		traits = data["traits"]
	if(!isnull(data["attributes"]))
		attributes = data["attributes"]
	// not sure why we're even serializing paths but here we go lol
	if(!isnull(data["path"]))
		path = data["path"]
	// end
	if(!isnull(data["linkage"]))
		linkage = data["linkage"]
	if(!isnull(data["transition"]))
		transition = data["transition"]
	if(!isnull(data["base_turf"]))
		base_turf = text2path(data["base_turf"])
	if(!isnull(data["base_area"]))
		base_area = text2path(data["base_area"])

	link_north_id = data["link_north_id"]
	link_south_id = data["link_south_id"]
	link_east_id = data["link_east_id"]
	link_west_id = data["link_west_id"]
	link_above_id = data["link_above_id"]
	link_below_id = data["link_below_id"]

	if(!isnull(data["air_indoors"]))
		air_indoors = data["air_indoors"]
	if(!isnull(data["air_outdoors"]))
		air_outdoors = data["air_outdoors"]

	if(!isnull(data["load_orientation"]))
		load_orientation = data["load_orientation"]
	if(!isnull(data["load_center"]))
		load_orientation = data["load_center"]
	if(!isnull(data["load_crop"]))
		load_orientation = data["load_crop"]

/**
 * Checks if we have a .dmm. If this is FALSE,
 * we are a naked map_level that should only generate a blank level.
 */
/datum/map_level/proc/has_map_path()
	return !!path

/**
 * get .dmm path or file
 * * null is an acceptable return, if no file is attached to us.
 */
/datum/map_level/proc/resolve_map_path()
	return path

/**
 * get /datum/dmm_parsed from us.
 * * null is an acceptable return, if no file is attached to us.
 */
/datum/map_level/proc/parse_map_path()
	var/map_path = resolve_map_path()
	if(!map_path)
		return null
	// this is a real map path
	if(isfile(map_path))
	else if(!fexists(map_path))
		return null
	else
		map_path = file(map_path)
	return parse_map(map_path)

/**
 * allow deallocation/unload
 */
/datum/map_level/proc/allow_deallocate()
	return TRUE

/**
 * should we be part of a struct?
 */
/datum/map_level/proc/is_in_struct()
	return !isnull(struct_x) && !isnull(struct_y) && !isnull(struct_z)

//* Directions *//

/**
 * Set level in dir, breaking the link whatever level was there previously had with us,
 * and adding a link for the new level to us.
 *
 * TODO: what happens if this is targeting an ID that is currently unloaded?
 */
/datum/map_level/proc/connect_level_in_dir(dir, datum/map_level/level_or_id, skip_loaded_rebuild)
	var/datum/map_level/existing_level = get_level_in_dir(dir)
	var/datum/map_level/new_level = istext(level_or_id) ? SSmapping.keyed_levels[level_or_id] : level_or_id
	if(existing_level == new_level)
		return
	if(existing_level.get_level_in_dir(turn(dir, 180)) == src)
		existing_level.set_level_in_dir(turn(dir, 180), null, skip_loaded_rebuild)
	set_level_in_dir(dir, level_or_id, skip_loaded_rebuild)
	new_level?.set_level_in_dir(turn(dir, 180), src, skip_loaded_rebuild)

/**
 * Set level in dir
 * * This will not break a link with the previous level from them to us; use [connect_level_in_dir] for that.
 *
 * TODO: what happens if this is targeting an ID that is currently unloaded?
 */
/datum/map_level/proc/set_level_in_dir(dir, datum/map_level/level_or_id, skip_loaded_rebuild)
	var/datum/map_level/new_level = istext(level_or_id) ? SSmapping.keyed_levels[level_or_id] : level_or_id
	switch(dir)
		if(NORTH)
			if(link_north_id == new_level?.id)
				return
			link_north_id = new_level?.id
		if(SOUTH)
			if(link_south_id == new_level?.id)
				return
			link_south_id = new_level?.id
		if(EAST)
			if(link_east_id == new_level?.id)
				return
			link_east_id = new_level?.id
		if(WEST)
			if(link_west_id == new_level?.id)
				return
			link_west_id = new_level?.id
		if(UP)
			if(link_above_id == new_level?.id)
				return
			link_above_id = new_level?.id
		if(DOWN)
			if(link_below_id == new_level?.id)
				return
			link_below_id = new_level?.id
		else
			CRASH("invalid dir passed in")
	if(loaded && !skip_loaded_rebuild)
		if(dir & (NORTH|SOUTH|EAST|WEST))
			rebuild_multiz_horizontal()
		else if(dir & (UP|DOWN))
			rebuild_multiz_vertical()

/**
 * get level datum in dir
 *
 * * This is authoritative, and is used to rebuild SSmapping's caches.
 * * If diagonal, only returns a level if both steps are consistent with each other.
 * * This will only return a level if it's currently loaded.
 */
/datum/map_level/proc/get_level_in_dir(dir) as /datum/map_level
	if(dir & (dir - 1))
		if(dir & (UP|DOWN))
			CRASH("unsupported operation of attempting to grab a vertical + diagonal direction.")
		switch(dir)
			if(NORTHWEST)
			if(NORTHEAST)
			if(SOUTHWEST)
			if(SOUTHEAST)
			else
				CRASH("invalid dir: [dir]")
		var/d1 = NSCOMPONENT(dir)
		var/d2 = EWCOMPONENT(dir)
		var/datum/map_level/l1 = get_level_in_dir(d1)
		l1 = l1?.get_level_in_dir(d2)
		var/datum/map_level/l2 = get_level_in_dir(d2)
		l2 = l2?.get_level_in_dir(d1)
		// if one side is null, we listen to the other
		if(isnull(l1))
			return l2
		if(isnull(l2))
			return l1
		// if both sides are not null, we require agreement between the two
		return (l1 == l2)? l1 : null
	switch(dir)
		if(NORTH)
			return SSmapping.keyed_levels[link_north_id]
		if(SOUTH)
			return SSmapping.keyed_levels[link_south_id]
		if(EAST)
			return SSmapping.keyed_levels[link_east_id]
		if(WEST)
			return SSmapping.keyed_levels[link_west_id]
		if(UP)
			return SSmapping.keyed_levels[link_above_id]
		if(DOWN)
			return SSmapping.keyed_levels[link_below_id]

//* Traits *//

/datum/map_level/proc/has_trait(trait)
	return trait in traits

/datum/map_level/proc/add_trait(trait)
	if(has_trait(trait))
		return
	LAZYDISTINCTADD(traits, trait)
	if(loaded)
		SSmapping.on_level_trait_add(src, trait)

/datum/map_level/proc/remove_trait(trait)
	if(!has_trait(trait))
		return
	LAZYREMOVE(traits, trait)
	if(loaded)
		SSmapping.on_level_trait_del(src, trait)

//* Attributes *//

/datum/map_level/proc/get_attribute(attribute)
	return attributes?[attribute]

/datum/map_level/proc/set_attribute(attribute, value)
	var/old = get_attribute(attribute)
	LAZYSET(attributes, attribute, value)
	if(loaded)
		SSmapping.on_level_attribute_set(src, attribute, old, value)

/datum/map_level/proc/unset_attribute(attribute)
	var/old = get_attribute(attribute)
	LAZYREMOVE(attributes, attribute)
	if(loaded)
		SSmapping.on_level_attribute_set(src, attribute, old, null)

//* Rebuilds / Transitions *//

/**
 * expensive as hell, rebuild all dirs
 * * use after loading into an existing map that didn't have us prior
 * * will block / sleep!
 *
 * @params
 * * reciprocal_if_linked - order adjacent levels to rebuild towards us if they are linked to us
 */
/datum/map_level/proc/rebuild_multiz(reciprocal_if_linked)
	rebuild_multiz_horizontal()
	rebuild_multiz_vertical()
	for(var/dir in list(NORTH, SOUTH, EAST, WEST, UP, DOWN))
		var/datum/map_level/partner = get_level_in_dir(dir)
		if(partner?.get_level_in_dir(turn(dir, 180)) == src)
			if(dir & (NORTH|SOUTH|EAST|WEST))
				partner.rebuild_multiz_horizontal()
			else
				partner.rebuild_multiz_vertical()

/**
 * causes an immediate rebuild in given dir (or all if none specified)
 * * multiple dir bits is allowed
 * * dir must be vertical if specified
 * * will block / sleep!
 *
 * TODO: this proc is a lie, it doesn't actually touch zmimic; that's fine for now, though
 */
/datum/map_level/proc/rebuild_multiz_vertical()
	// internally rebuilds are coalesced if two happen at the same time,
	// but we still want to track it to see if we're calling this unnecessarily.
	multiz_vertical_rebuild_count++
	if(multiz_vertical_rebuild_queued)
		return
	multiz_vertical_rebuild_queued = TRUE
	UNTIL(!multiz_vertical_rebuild_mutex)
	multiz_vertical_rebuild_queued = FALSE
	multiz_vertical_rebuild_mutex = TRUE
	rebuild_multiz_vertical_impl()
	multiz_vertical_rebuild_mutex = FALSE

/datum/map_level/proc/rebuild_multiz_vertical_impl()
	PROTECTED_PROC(TRUE)
	for(var/turf/T as anything in level_turfs())
		T.update_multiz()
		CHECK_TICK

/**
 * causes an immediate rebuild in given dir (or all if none specified)
 * * multiple dir bits is allowed
 * * dir must be horizontal if specified
 * * will block / sleep!
 */
/datum/map_level/proc/rebuild_multiz_horizontal()
	// internally rebuilds are coalesced if two happen at the same time,
	// but we still want to track it to see if we're calling this unnecessarily.
	multiz_horizontal_rebuild_count++
	if(multiz_horizontal_rebuild_queued)
		return
	multiz_horizontal_rebuild_queued = TRUE
	UNTIL(!multiz_horizontal_rebuild_mutex)
	multiz_horizontal_rebuild_queued = FALSE
	multiz_horizontal_rebuild_mutex = TRUE
	rebuild_multiz_horizontal_impl()
	multiz_horizontal_rebuild_mutex = FALSE

/datum/map_level/proc/rebuild_multiz_horizontal_impl()
	PROTECTED_PROC(TRUE)
	switch(transition)
		// do nothing
		if(Z_TRANSITION_DISABLED)
			for(var/turf/T as anything in transition_turfs())
				T._dispose_transition_border()
				CHECK_TICK
		// just obey the link ids
		if(Z_TRANSITION_FORCED, Z_TRANSITION_DEFAULT, Z_TRANSITION_INVISIBLE)
			var/visible = transition != Z_TRANSITION_INVISIBLE
			// cardinals
			if(!isnull(link_south_id))
				for(var/turf/T as anything in transition_turfs(SOUTH))
					T._make_transition_border(SOUTH, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(SOUTH))
					T._dispose_transition_border()
					CHECK_TICK
			if(!isnull(link_north_id))
				for(var/turf/T as anything in transition_turfs(NORTH))
					T._make_transition_border(NORTH, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(NORTH))
					T._dispose_transition_border()
					CHECK_TICK
			if(!isnull(link_east_id))
				for(var/turf/T as anything in transition_turfs(EAST))
					T._make_transition_border(EAST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(EAST))
					T._dispose_transition_border()
					CHECK_TICK
			if(!isnull(link_west_id))
				for(var/turf/T as anything in transition_turfs(WEST))
					T._make_transition_border(WEST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(WEST))
					T._dispose_transition_border()
					CHECK_TICK
			// diagonals
			var/datum/map_level/resolved
			resolved = get_level_in_dir(NORTHWEST)
			if(!isnull(resolved))
				for(var/turf/T as anything in transition_turfs(NORTHWEST))
					T._make_transition_border(NORTHWEST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(NORTHWEST))
					T._dispose_transition_border()
					CHECK_TICK
			resolved = get_level_in_dir(NORTHEAST)
			if(!isnull(resolved))
				for(var/turf/T as anything in transition_turfs(NORTHEAST))
					T._make_transition_border(NORTHEAST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(NORTHEAST))
					T._dispose_transition_border()
					CHECK_TICK
			resolved = get_level_in_dir(SOUTHWEST)
			if(!isnull(resolved))
				for(var/turf/T as anything in transition_turfs(SOUTHWEST))
					T._make_transition_border(SOUTHWEST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(SOUTHWEST))
					T._dispose_transition_border()
					CHECK_TICK
			resolved = get_level_in_dir(SOUTHEAST)
			if(!isnull(resolved))
				for(var/turf/T as anything in transition_turfs(SOUTHEAST))
					T._make_transition_border(SOUTHEAST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(SOUTHEAST))
					T._dispose_transition_border()
					CHECK_TICK

//* Turf Fetch *//

/**
 * get transition turfs
 *
 * * there is no overlap between any of this proc's outputs' for a given unique input.
 *   what this means is NORTH will not overlap with NORTHEAST. the only exception is when
 *   no dir is provided.
 *
 * @params
 * * dir - direction; if null, we grab all, including diagonals
 */
/datum/map_level/proc/transition_turfs(dir)
	switch(dir)
		if(null)
			. = (
				block(
					locate(LEVEL_BORDER_WIDTH, LEVEL_BORDER_WIDTH, z_index),
					locate(world.maxx - (LEVEL_BORDER_WIDTH - 1), LEVEL_BORDER_WIDTH, z_index),
				) + \
				block(
					locate(LEVEL_BORDER_WIDTH, world.maxy - (LEVEL_BORDER_WIDTH - 1), z_index),
					locate(world.maxx - (LEVEL_BORDER_WIDTH - 1), world.maxy - (LEVEL_BORDER_WIDTH - 1), z_index),
				) + \
				block(
					locate(LEVEL_BORDER_WIDTH, LEVEL_BORDER_WIDTH + 1, z_index),
					locate(LEVEL_BORDER_WIDTH, world.maxy - (LEVEL_BORDER_WIDTH + 1), z_index),
				) + \
				block(
					locate(world.maxx - (LEVEL_BORDER_WIDTH - 1), LEVEL_BORDER_WIDTH + 1, z_index),
					locate(world.maxx - (LEVEL_BORDER_WIDTH - 1), world.maxy - (LEVEL_BORDER_WIDTH + 1), z_index),
				)
			)
		if(NORTH)
			. = block(locate(LEVEL_BORDER_WIDTH + 1, world.maxy, z_index), locate(world.maxx - LEVEL_BORDER_WIDTH, world.maxy, z_index))
		if(SOUTH)
			. = block(locate(LEVEL_BORDER_WIDTH + 1, LEVEL_BORDER_WIDTH, z_index), locate(world.maxx - LEVEL_BORDER_WIDTH, LEVEL_BORDER_WIDTH, z_index))
		if(EAST)
			. = block(locate(world.maxx, LEVEL_BORDER_WIDTH + 1, z_index), locate(world.maxx, world.maxy - LEVEL_BORDER_WIDTH, z_index))
		if(WEST)
			. = block(locate(LEVEL_BORDER_WIDTH, LEVEL_BORDER_WIDTH + 1, z_index), locate(LEVEL_BORDER_WIDTH, world.maxy - LEVEL_BORDER_WIDTH, z_index))
		if(NORTHEAST)
			. = list(locate(world.maxx, world.maxy, z_index))
		if(NORTHWEST)
			. = list(locate(LEVEL_BORDER_WIDTH, world.maxy, z_index))
		if(SOUTHEAST)
			. = list(locate(world.maxx, LEVEL_BORDER_WIDTH, z_index))
		if(SOUTHWEST)
			. = list(locate(LEVEL_BORDER_WIDTH, LEVEL_BORDER_WIDTH, z_index))
		else
			CRASH("what?")
	if(transition_trampling)
		return
	var/list/transformed = list()
	for(var/turf/level_border/border in .)
		transformed += border
	return transformed

/**
 * get all turfs
 */
/datum/map_level/proc/level_turfs()
	return Z_TURFS(z_index)
