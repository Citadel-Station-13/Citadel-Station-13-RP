/**
 * a struct for holding information about a zlevel
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
	///
	/// This is determined with regards to the context of the load.
	///
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

	/// id of north zlevel - overrides linkage if set.
	///
	/// * can also be set to path
	/// * can also be set to instance - used for structs
	/// * do not manually set it to levelpath::id, map levels generate ids dynamically!
	var/datum/map_level/link_north
	/// id of south zlevel - overrides linkage if set.
	///
	/// * can also be set to path
	/// * can also be set to instance - used for structs
	/// * do not manually set it to levelpath::id, map levels generate ids dynamically! can also be set to instance - used for structs.
	var/datum/map_level/link_south
	/// id of west zlevel - overrides linkage if set.
	///
	/// * can also be set to path
	/// * can also be set to instance - used for structs
	/// * do not manually set it to levelpath::id, map levels generate ids dynamically! can also be set to instance - used for structs.
	var/datum/map_level/link_west
	/// id of east zlevel - overrides linkage if set.
	///
	/// * can also be set to path
	/// * can also be set to instance - used for structs
	/// * do not manually set it to levelpath::id, map levels generate ids dynamically! can also be set to instance - used for structs.
	var/datum/map_level/link_east
	/// id of below zlevel - overrides linkage if set.
	///
	/// * can also be set to path
	/// * can also be set to instance - used for structs
	/// * do not manually set it to levelpath::id, map levels generate ids dynamically! can also be set to instance - used for structs.
	var/datum/map_level/link_below
	/// id of above zlevel - overrides linkage if set.
	///
	/// * can also be set to path
	/// * can also be set to instance - used for structs
	/// * do not manually set it to levelpath::id, map levels generate ids dynamically! can also be set to instance - used for structs.
	var/datum/map_level/link_above

	//* Turf Properties *//
	/// base turf typepath for this level
	var/base_turf = /turf/space
	/// base area typepath for this level
	var/base_area = /area/space
	/// gas string / atmosphere path / atmosphere id for indoors air
	/// if atmosphere path, it'll be automatically packed to ID on serialize, as we don't want to serialize paths to disk.
	var/air_indoors = GAS_STRING_STP
	/// gas string / atmosphere path / atmosphere id for outdoors air
	/// if atmosphere path, it'll be automatically packed to ID on serialize, as we don't want to serialize paths to disk.
	var/air_outdoors = GAS_STRING_VACUUM

	//* Loading *//
	/// are we loaded in
	/// *
	var/tmp/loaded = FALSE
	/// our zlevel once loaded
	var/tmp/z_index
	/// load orientation - overridden if loaded as part of a /datum/map
	var/orientation = SOUTH

	//* Simulation *//
	/// canonical height of level in meters
	///
	/// * '100m' means that the level above is 100m above us, and we're 100m below the above level
	/// * basically, this is the height from ground before the next level, not the height below ground
	/// * if null, will inherit from the map_struct we're in (or default to a sane value)
	/// * if non-null, the struct will force that z-plane to be that height
	/// * if non-null and two levels have different values, the struct will runtime.
	/// * if one level on a plane is non-null height, all of them must be, and they must match.
	var/ceiling_height
	/// default ceiling height if not inheriting from struct or specified
	///
	/// * only used if we're not on a map_struct
	var/ceiling_height_default = 5

	//* Structs / Stitching / Virtual Coordinates *//
	/// the struct we belong to, if any
	var/tmp/datum/map_struct/struct
	/// the index in our struct's [levels] list
	var/tmp/struct_level_index
	/// our virtual x on the struct; this is not tile coordinates, this is struct coordinates
	/// * set as needed so the map knows where to put us in the virtual struct.
	var/struct_x = 0
	/// our virtual y on the struct; this is not tile coordinates, this is struct coordinates
	/// * set as needed so the map knows where to put us in the virtual struct.
	var/struct_y = 0
	/// the coordinate we are actually on, zlevel wise
	///
	/// * basically for fluff and simulation, not byond engine
	/// * this is used for virtual coordinates as the 'z'
	/// * set as needed so the map knows where to put us in the virtual struct.
	var/struct_z = 0

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

	//* LEGACY BELOW *//

	var/flags = 0			// Bitflag of which *_levels lists this z should be put into.
	//! legacy: what planet to make/use
	var/planet_path

	// Holomaps
	var/holomap_offset_x = -1	// Number of pixels to offset the map right (for centering) for this z
	var/holomap_offset_y = -1	// Number of pixels to offset the map up (for centering) for this z
	var/holomap_legend_x = 96	// x position of the holomap legend for this z
	var/holomap_legend_y = 96	// y position of the holomap legend for this z

/datum/map_level/New(datum/map/parent_map)
	src.parent_map = parent_map

	if(!isnull(parent_map) && id)
		id = "[parent_map.id]-[id]"

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

	// Resolve links, including if they got serlalized as typepaths.
	// todo: typepaths should be trampled into ids on save instead.
	var/resolving_link
	var/maybe_link_path
	if(!isnull(data["link_north"]))
		resolving_link = data["north"]
		maybe_link_path = text2path(resolving_link)
		link_north = ispath(maybe_link_path) ? maybe_link_path : resolving_link
	if(!isnull(data["link_south"]))
		resolving_link = data["south"]
		maybe_link_path = text2path(resolving_link)
		link_south = ispath(maybe_link_path) ? maybe_link_path : resolving_link
	if(!isnull(data["link_above"]))
		resolving_link = data["above"]
		maybe_link_path = text2path(resolving_link)
		link_above = ispath(maybe_link_path) ? maybe_link_path : resolving_link
	if(!isnull(data["link_below"]))
		resolving_link = data["below"]
		maybe_link_path = text2path(resolving_link)
		link_below = ispath(maybe_link_path) ? maybe_link_path : resolving_link
	if(!isnull(data["link_west"]))
		resolving_link = data["west"]
		maybe_link_path = text2path(resolving_link)
		link_west = ispath(maybe_link_path) ? maybe_link_path : resolving_link
	if(!isnull(data["link_east"]))
		resolving_link = data["east"]
		maybe_link_path = text2path(resolving_link)
		link_east = ispath(maybe_link_path) ? maybe_link_path : resolving_link

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
	return path

/**
 * allow deallocation/unload
 */
/datum/map_level/proc/allow_deallocate()
	return TRUE

//* Directions *//

/**
 * get level datum in dir
 *
 * * This is authoritative, and is used to rebuild SSmapping's caches.
 * * If diagonal, only returns a level if both steps are consistent with each other.
 */
/datum/map_level/proc/level_in_dir(dir) as /datum/map_level
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
		#define RESOLVE(X) istype(X, /datum/map_level)? X : (istext(X)? SSmapping.keyed_levels[X] : SSmapping.keyed_levels[X.id])
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
		else
			pass() // macro used immediately before being undefined; BYOND bug 2072419
		#undef RESOLVE

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
 * * reciprocal - order the level in that dir to rebuild towards us.
 *                this doesn't always make sense to enable, because
 *                it's possible (albeit rare) that a level is one-way
 *                linked and the other level doesn't link back.
 */
/datum/map_level/proc/rebuild_multiz(reciprocal)
	for(var/dir in list(NORTH, SOUTH, EAST, WEST, UP, DOWN))
		rebuild_multiz_in_dir(dir)
		if(reciprocal)
			var/datum/map_level/partner = level_in_dir(dir)
			partner?.rebuild_multiz_in_dir(turn(dir, 180))

/**
 * expensive as hell, teardown all dirs
 * * use when being unloaded or something
 * * will block / sleep!
 *
 * @params
 * * reciprocal - order the level in that dir to teardown our dir.
 *                this doesn't always make sense to enable, because
 *                it's possible (albeit rare) that a level is one-way
 *                linked and the other level doesn't link back.
 */
/datum/map_level/proc/teardown_multiz(reciprocal)
	for(var/dir in list(NORTH, SOUTH, EAST, WEST, UP, DOWN))
		teardown_multiz_in_dir(dir)
		if(reciprocal)
			var/datum/map_level/partner = level_in_dir(dir)
			partner?.teardown_multiz_in_dir(turn(dir, 180))

/**
 * * will block / sleep!
 */
/datum/map_level/proc/rebuild_multiz_in_dir(dir)
	#warn impl

/**
 * * will block / sleep!
 */
/datum/map_level/proc/teardown_multiz_in_dir(dir)
	#warn impl

/**
 * causes an immediate rebuild in given dir (or all if none specified)
 * * dir must be vertical if specified
 * * will block / sleep!
 */
/datum/map_level/proc/rebuild_vertical_transitions(dir)
	if(dir)
		ASSERT((dir & (UP|DOWN)) == dir)
	for(var/turf/T as anything in level_turfs())
		T.update_multiz()
		CHECK_TICK

/**
 * causes an immediate rebuild in given dir (or all if none specified)
 * * dir must be horizontal if specified
 * * will block / sleep!
 */
/datum/map_level/proc/rebuild_horizontal_transitions(dir)
	if(dir)
		ASSERT((dir & (NORTH|SOUTH|EAST|WEST)) == dir)
	#warn impl

/**
 * call to rebuild all turfs for horizontal transitions
 *
 * this will sleep
 */
#warn kill
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

/**
 * destroys all transitions on border turfs
 * call when changing level size
 *
 * this will sleep
 */
#warn kill
/datum/map_level/proc/destroy_transitions()
	for(var/turf/T as anything in transition_turfs())
		T._dispose_transition_border()
		CHECK_TICK

//* Turf Fetch *//

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

//* ---- Subtypes ---- *//

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
/datum/map_level/freeflight
	transition = Z_TRANSITION_DISABLED
