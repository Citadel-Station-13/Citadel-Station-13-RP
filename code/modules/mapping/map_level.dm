/**
 * a struct for holding information about a zlevel
 */
/datum/map_level
	/// id - must be globally unique across all possible maps
	var/id
	/// friendly debug / code name of level
	var/name
	/// player visible id for technical displays - randomized if unset
	var/display_id
	/// player visible name for non-technical displays - randomized if unset
	var/display_name
	/// traits
	var/list/traits
	/// attributes associated key-values
	var/list/attributes
	/// absolute path from server current directory to map; overrides relative_path
	var/absolute_path
	/// relative path. useless outside of manual maploads, as we can't parse relative path from DM yet.
	var/relative_path
	/// are we modified from our prototype/definition?
	var/tmp/modified = FALSE
	/// linkage enum
	//  todo: this is not implemented yet
	var/linkage = Z_LINKAGE_NORMAL
	/// transition enum
	var/transition = Z_TRANSITION_DEFAULT
	/// set to FALSE if transition borders are defined via /turf/level_border, to disable trampling the turf into /turf/level_border
	var/transition_trampling = TRUE
	/// base turf typepath for this level
	var/base_turf = /turf/space
	/// base area typepath for this level
	var/base_area = /area/space
	/// id of north zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	/// can also be set to instance - used for structs.
	var/link_north
	/// id of south zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	/// can also be set to instance - used for structs.
	var/link_south
	/// id of west zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	/// can also be set to instance - used for structs.
	var/link_west
	/// id of east zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	/// can also be set to instance - used for structs.
	var/link_east
	/// id of below zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	/// can also be set to instance - used for structs.
	var/link_below
	/// id of above zlevel - overrides linkage if set. can be set to path, autoconverts to id on new.
	/// can also be set to instance - used for structs.
	var/link_above
	/// gas string / atmosphere path / atmosphere id for indoors air
	/// if atmosphere path, it'll be automatically packed to ID on serialize, as we don't want to serialize paths to disk.
	var/air_indoors = GAS_STRING_STP
	/// gas string / atmosphere path / atmosphere id for outdoors air
	/// if atmosphere path, it'll be automatically packed to ID on serialize, as we don't want to serialize paths to disk.
	var/air_outdoors = GAS_STRING_VACUUM
	/// load orientation - overridden if loaded as part of a /datum/map
	var/orientation = SOUTH

	//* Loading
	/// are we loaded in
	var/tmp/loaded = FALSE
	/// our zlevel once loaded
	var/tmp/z_index

	//* Tracking
	var/turfs_rebuild_count = 0
	var/transitions_rebuild_count = 0

	//* LEGACY BELOW *//

	var/flags = 0			// Bitflag of which *_levels lists this z should be put into.
	//! legacy: what planet to make/use
	var/planet_path

	// Holomaps
	var/holomap_offset_x = -1	// Number of pixels to offset the map right (for centering) for this z
	var/holomap_offset_y = -1	// Number of pixels to offset the map up (for centering) for this z
	var/holomap_legend_x = 96	// x position of the holomap legend for this z
	var/holomap_legend_y = 96	// y position of the holomap legend for this z

/datum/map_level/New()
	#define UNPACK_LINK(vname) if(ispath(vname, /datum/map_level)) { var/datum/map_level/cast_##vname = vname; vname = initial(cast_##vname.id) ; }
	UNPACK_LINK(link_north)
	UNPACK_LINK(link_south)
	UNPACK_LINK(link_east)
	UNPACK_LINK(link_west)
	UNPACK_LINK(link_below)
	UNPACK_LINK(link_above)
	BLOCK_BYOND_BUG_2072419
	#undef UNPACK_LINK

/datum/map_level/Destroy()
	if(loaded)
		. = QDEL_HINT_LETMELIVE
		CRASH("UH OH, SOMETHING TRIED TO DELETE AN INSTANTIATED LEVEL.")
	return ..()

/datum/map_level/serialize()
	. = ..()
	.["id"] = id
	.["name"] = name
	.["display_id"] = display_id
	.["display_name"] = display_name
	.["traits"] = traits
	.["attributes"] = attributes
	// if you are reading this in the future and you serialize/deserialize a map and it doesn't load,
	// this is because absolute/relative paths don't actually... work, right now.
	.["absolute_path"] = absolute_path
	.["relative_path"] = relative_path
	// end
	.["linkage"] = linkage
	.["transition"] = transition
	.["base_turf"] = "[base_turf]"
	.["link_north"] = link_north
	.["link_south"] = link_south
	.["link_west"] = link_west
	.["link_east"] = link_east
	.["link_above"] = link_above
	.["link_below"] = link_below

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

	.["orientation"] = orientation

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
	// if you are reading this in the future and you serialize/deserialize a map and it doesn't load,
	// this is because absolute/relative paths don't actually... work, right now.
	if(!isnull(data["absolute_path"]))
		absolute_path = data["absolute_path"]
	if(!isnull(data["relative_path"]))
		relative_path = data["relative_path"]
	// end
	if(!isnull(data["linkage"]))
		linkage = data["linkage"]
	if(!isnull(data["transition"]))
		transition = data["transition"]
	if(!isnull(data["base_turf"]))
		base_turf = text2path(data["base_turf"])
	if(!isnull(data["link_north"]))
		link_north = data["link_north"]
	if(!isnull(data["link_south"]))
		link_south = data["link_south"]
	if(!isnull(data["link_above"]))
		link_above = data["link_above"]
	if(!isnull(data["link_below"]))
		link_below = data["link_below"]
	if(!isnull(data["link_west"]))
		link_west = data["link_west"]
	if(!isnull(data["link_east"]))
		link_east = data["link_east"]
	if(!isnull(data["air_indoors"]))
		air_indoors = data["air_indoors"]
	if(!isnull(data["air_outdoors"]))
		air_outdoors = data["air_outdoors"]
	if(!isnull(data["orientation"]))
		orientation = data["orientation"]

/**
 * get .dmm path or file
 */
/datum/map_level/proc/resolve_map_path()
	return absolute_path // no relative path support yet

/**
 * get level index in dir
 */
/datum/map_level/proc/z_in_dir(dir)
	return level_in_dir(dir)?.z_index

/**
 * get level datum in dir
 *
 * if diagonal, only returns a level if both steps are consistent with each other.
 */
/datum/map_level/proc/level_in_dir(dir)
	RETURN_TYPE(/datum/map_level)
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
		var/datum/map_level/l1 = level_in_dir(d1)
		l1 = l1?.level_in_dir(d2)
		var/datum/map_level/l2 = level_in_dir(d2)
		l2 = l2?.level_in_dir(d1)
		// if one side is null, we listen to the other
		if(isnull(l1))
			return l2
		if(isnull(l2))
			return l1
		// if both sides are not null, we require agreement between the two
		return (l1 == l2)? l1 : null
	switch(dir)
		#define RESOLVE(X) istype(X, /datum/map_level)? X : SSmapping.keyed_levels[X]
		if(NORTH)
			return RESOLVE(link_north)
		if(SOUTH)
			return RESOLVE(link_south)
		if(EAST)
			return RESOLVE(link_east)
		if(WEST)
			return RESOLVE(link_west)
		if(UP)
			return RESOLVE(link_above)
		if(DOWN)
			return RESOLVE(link_below)
		#undef RESOLVE

/**
 * called right after we physically load in, before init
 * called before atom init
 *
 * this is *not* called if we are created from a zlevel, say, when dynamically generating a planet.
 * this is solely for hardcoded map levels to have load behaviors.
 * undefined behavior will result if this is overridden on a level used for dynamic generation.
 *
 * @params
 * * z_index - zlevel we loaded on
 * * generation_callbacks - callbacks to add to perform post_loaded generation. this will be done in a batch before on_loaded_finalize and before atom init.
 */
/datum/map_level/proc/on_loaded_immediate(z_index, list/datum/callback/additional_generation)
	return

/**
 * called in a group after all maps and dependencies load **and** generation callbacks fire.
 * called after atom init
 *
 * this is *not* called if we are created from a zlevel, say, when dynamically generating a planet.
 * this is solely for hardcoded map levels to have load behaviors.
 * undefined behavior will result if this is overridden on a level used for dynamic generation.
 *
 * @params
 * * z_index - zlevel we loaded on
 */
/datum/map_level/proc/on_loaded_finalize(z_index)
	return

/**
 * allow deallocation/unload
 */
/datum/map_level/proc/allow_deallocate()
	return TRUE

//* traits

/datum/map_level/proc/has_trait(trait)
	return trait in traits

/datum/map_level/proc/add_trait(trait)
	if(has_trait(trait))
		return
	LAZYDISTINCTADD(traits, trait)
	if(loaded)
		SSmapping.on_trait_add(src, trait)

/datum/map_level/proc/remove_trait(trait)
	if(!has_trait(trait))
		return
	LAZYREMOVE(traits, trait)
	if(loaded)
		SSmapping.on_trait_del(src, trait)

//* attributes

/datum/map_level/proc/get_attribute(attribute)
	return attributes?[attribute]

/datum/map_level/proc/set_attribute(attribute, value)
	var/old = get_attribute(attribute)
	LAZYSET(attributes, attribute, value)
	if(loaded)
		SSmapping.on_attribute_set(src, attribute, old, value)

/datum/map_level/proc/unset_attribute(attribute)
	var/old = get_attribute(attribute)
	LAZYREMOVE(attributes, attribute)
	if(loaded)
		SSmapping.on_attribute_set(src, attribute, old, null)

//* rebuilds

/**
 * Rebuild turfs up/down of us
 * This will sleep
 */
/datum/map_level/proc/rebuild_vertical_levels()
	for(var/datum/map_level/L in list(
		level_in_dir(UP),
		level_in_dir(DOWN)
	))
		L.rebuild_turfs()

/**
 * Rebuild turfs adjacent of us
 * This will sleep
 */
/datum/map_level/proc/rebuild_adjacent_levels()
	for(var/datum/map_level/L in list(
		level_in_dir(NORTH),
		level_in_dir(SOUTH),
		level_in_dir(EAST),
		level_in_dir(WEST)
	))
		L.rebuild_transitions()

/**
 * call to rebuild all turfs for vertical multiz
 *
 * this will sleep
 */
/datum/map_level/proc/rebuild_turfs()
	for(var/turf/T as anything in block(locate(1, 1, z_index), locate(world.maxx, world.maxy, z_index)))
		T.update_multiz()
		CHECK_TICK
	turfs_rebuild_count++

/**
 * call to rebuild all turfs for horizontal transitions
 *
 * this will sleep
 */
/datum/map_level/proc/rebuild_transitions()
	switch(transition)
		// do nothing
		if(Z_TRANSITION_DISABLED)
		// default not implemented
		if(Z_TRANSITION_FORCED, Z_TRANSITION_DEFAULT, Z_TRANSITION_INVISIBLE)
			var/visible = transition != Z_TRANSITION_INVISIBLE
			// cardinals
			if(!isnull(link_south))
				for(var/turf/T as anything in transition_turfs(SOUTH))
					T._make_transition_border(SOUTH, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(SOUTH))
					T._dispose_transition_border()
					CHECK_TICK
			if(!isnull(link_north))
				for(var/turf/T as anything in transition_turfs(NORTH))
					T._make_transition_border(NORTH, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(NORTH))
					T._dispose_transition_border()
					CHECK_TICK
			if(!isnull(link_east))
				for(var/turf/T as anything in transition_turfs(EAST))
					T._make_transition_border(EAST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(EAST))
					T._dispose_transition_border()
					CHECK_TICK
			if(!isnull(link_west))
				for(var/turf/T as anything in transition_turfs(WEST))
					T._make_transition_border(WEST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(WEST))
					T._dispose_transition_border()
					CHECK_TICK
			// diagonals
			var/datum/map_level/resolved
			resolved = level_in_dir(NORTHWEST)
			if(!isnull(resolved))
				for(var/turf/T as anything in transition_turfs(NORTHWEST))
					T._make_transition_border(NORTHWEST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(NORTHWEST))
					T._dispose_transition_border()
					CHECK_TICK
			resolved = level_in_dir(NORTHEAST)
			if(!isnull(resolved))
				for(var/turf/T as anything in transition_turfs(NORTHEAST))
					T._make_transition_border(NORTHEAST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(NORTHEAST))
					T._dispose_transition_border()
					CHECK_TICK
			resolved = level_in_dir(SOUTHWEST)
			if(!isnull(resolved))
				for(var/turf/T as anything in transition_turfs(SOUTHWEST))
					T._make_transition_border(SOUTHWEST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(SOUTHWEST))
					T._dispose_transition_border()
					CHECK_TICK
			resolved = level_in_dir(SOUTHEAST)
			if(!isnull(resolved))
				for(var/turf/T as anything in transition_turfs(SOUTHEAST))
					T._make_transition_border(SOUTHEAST, visible)
					CHECK_TICK
			else
				for(var/turf/T as anything in transition_turfs(SOUTHEAST))
					T._dispose_transition_border()
					CHECK_TICK
	transitions_rebuild_count++

/**
 * destroys all transitions on border turfs
 * call when changing level size
 *
 * this will sleep
 */
/datum/map_level/proc/destroy_transitions()
	for(var/turf/T as anything in transition_turfs())
		T._dispose_transition_border()
		CHECK_TICK

/**
 * get transition turfs
 *
 * @params
 * * dir - direction; if null, we grab all, including diagonals
 */
/datum/map_level/proc/transition_turfs(dir)
	switch(dir)
		if(null)
			. = (
				block(locate(1, 1, z_index), locate(world.maxx, 1, z_index)) + \
				block(locate(1, world.maxy, z_index), locate(world.maxx, world.maxy, z_index)) + \
				block(locate(1, 2, z_index), locate(1, world.maxy - 2, z_index)) + \
				block(locate(world.maxx, 2, z_index), locate(world.maxx, world.maxy - 2, z_index))
			)
		if(NORTH)
			. = block(locate(2, world.maxy, z_index), locate(world.maxx - 1, world.maxy, z_index))
		if(SOUTH)
			. = block(locate(2, 1, z_index), locate(world.maxx - 1, 1, z_index))
		if(EAST)
			. = block(locate(world.maxx, 2, z_index), locate(world.maxx, world.maxy - 1, z_index))
		if(WEST)
			. = block(locate(1, 2, z_index), locate(1, world.maxy - 1, z_index))
		if(NORTHEAST)
			. = list(locate(world.maxx, world.maxy, z_index))
		if(NORTHWEST)
			. = list(locate(1, world.maxy, z_index))
		if(SOUTHEAST)
			. = list(locate(world.maxx, 1, z_index))
		if(SOUTHWEST)
			. = list(locate(1, 1, z_index))
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

//* subtypes

/**
 * dynamically generated levels should use this
 */
/datum/map_level/dynamic
	modified = TRUE

/**
 * "free" / unallocated zlevels use this
 */
/datum/map_level/unallocated
	transition = Z_TRANSITION_DISABLED

/**
 * reserved levels for turf reservations use this
 */
/datum/map_level/reserved
	transition = Z_TRANSITION_DISABLED

/datum/map_level/reserved/allow_deallocate()
	return FALSE

/**
 * transit levels for shuttles
 */
/datum/map_level/transit
	transition = Z_TRANSITION_DISABLED
