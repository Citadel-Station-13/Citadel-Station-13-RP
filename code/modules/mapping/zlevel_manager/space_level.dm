/**
 * Map level datums
 *
 * Used by the zlevel manager, contains all data about a zlevel.
 */
/datum/space_level
	//! Basic information
	/// Name
	var/name
	/// ID - defaults to null
	var/id
	/// id was autogen'd
	var/random_id

	//! Instantiation
	/// Our z value
	var/tmp/z_value
	/// Are we physically made yet?
	var/tmp/instantiated = FALSE

	//! Map File / Loading
	/// Path to .dmm - this must be relative to the folder the .json was loaded from.
	/// Yeah, this means you can't link outside of nested directories, only deeper, but frankly, sue me.
	/// To set this use "path" in the .json
	/// you can start with maps/, config/, to absolutely path from those folders.
	var/map_path
	/// load orientation
	var/orientation = SOUTH
	/// load centered?
	var/center = TRUE
	/// load "void" tiles for blank areas when we're smaller than the world zlevel size as opposed to baseturf
	var/fill_void = FALSE
	/// width - automatically set if omitted, but you should set it where possible for error checking.
	var/width
	/// height - automatically set if omitted, but you should set it where possible for error checking.
	var/height

	#warn hook these into load process and generation
	//! bounds - for when we had to fill void.
	/// start x inclusive
	var/tmp/x_min
	/// start y inclusive
	var/tmp/y_min
	/// end x inclusive
	var/tmp/x_max
	/// end y inclusive
	var/tmp/y_max

	//! Linkage - IDs
	// todo: support overriding world_struct linkage
	// Linkage/MultiZ - what zlevels are where. References by ID only!
	VAR_PRIVATE/up
	VAR_PRIVATE/down
	// Linkage - what zlevels are where - cardinals. Visual and movement transitions are automatically applied. References by ID only!
	VAR_PRIVATE/east
	VAR_PRIVATE/west
	VAR_PRIVATE/north
	VAR_PRIVATE/south

	//! Linkage - info
	/// Linkage mode
	var/linkage_mode = Z_LINKAGE_NORMAL
	/// Transition mode
	var/transition_mode = Z_TRANSITION_NORMAL

	//! Traits
	/// Traits - binary yes/no's
	var/list/traits = list()

	//! Attributes
	/// Attributes - key-value lists, value can be string/number/null only. Recursing lists are supported.
	var/list/attributes = list()

	//! Baseturf
	/// base turf - path
	var/base_turf
	/// base area - path
	var/base_area

	//! Air
	/// indoors gas string
	var/air_indoors = GAS_STRING_STP
	/// outdoors gas string
	var/air_outdoors = GAS_STRING_VACUUM

	//! Crosslinking
	/// Current crosslinking x in grid
	var/tmp/cl_x
	/// Current crosslinking y in grid
	var/tmp/cl_y

	//! Level modules
	/// /datum/level_module to execute
	var/level_module_type = NOT_IMPLEMENTED
	/// Instanced level module we hold onto
	var/datum/level_module/level_module
	#warn - impl and hook level modules

	//! Structs
	/// The world_struct we're in, if any
	var/tmp/datum/world_struct/struct
	/// x value in struct
	var/tmp/struct_x
	/// y value in struct
	var/tmp/struct_y
	/// z value in struct
	var/tmp/struct_z

	//! Performance metrics
	/// how many times we rebuilt turfs
	var/tmp/turfs_rebuild_count = 0
	/// how many times we rebuilt transitions
	var/tmp/transitions_rebuild_count = 0

#warn parse this file

/datum/space_level/New(id, list/traits, list/attributes, map_path)
	if(id)
		src.set_id(id)
	if(!src.id)
		src.set_id(GUID())
		src.random_id = TRUE
	else
		src.random_id = FALSE
	if(map_path)
		src.map_path = map_path
	if(traits)
		for(var/trait in traits)
			src.add_trait(trait)
	if(attributes)
		for(var/key in attributes)
			src.set_attribute(key, attributes[key])

/datum/space_level/Destroy(force)
	if(instantiated && !force)
		. = QDEL_HINT_LETMELIVE
		CRASH("Attempted to destroy an instantiated space level datum.")
	traits = null
	attributes = null
	// don't rebuild the level, if we're instantiated and this is happening shit's fucked anyways
	up = down = east = west = north = south = null
	return ..()

/**
 * Builds data from a decoded JSON list
 *
 * @param
 * - data - data list passed in by subsystem during mapload
 * - pathroot - root path of the .json
 */
/datum/space_level/proc/parse(list/data, pathroot)
	if(instantiated)
		CRASH("attempted to reload json while already instantiated")
	ASSERT(islist(data))

	//? basics
	if(data["name"])
		name = data["name"]
	if(data["id"])
		set_id(data["id"])
		random_id = FALSE

	//? files / loading
	if(data["orientation"])
		orientation = data["orientation"]
		if(istext(orientation))
			switch(lowertext(orientation))
				if("north")
					orientation = NORTH
				if("south")
					orientation = SOUTH
				if("east")
					orientation = EAST
				if("west")
					orientation = WEST
	if(data["center"])
		center = !!data["center"]
	if(data["fill_void"])
		fill_void = !!data["fill_void"]
	if(data["width"])
		width = text2num(data["width"])
	if(data["height"])
		height = text2num(data["height"])

	#warn make sure everything matches the vars
	#warn default base_turf to world.turf
	#warn default base_area to world.area
	if(data["path_absolute"])
		map_path = data["path_absolute"]
	else if(data["path"])
		map_path = pathroot + data["path"]


	//? linkage info
	if(data["transition"])
		transition_mode = data["transition"]
	if(data["linkage"])
		linkage_mode = data["linkage"]

	//? linkage overrides
	if(data["up"])
		up = data["up"]
	if(data["down"])
		down = data["down"]
	if(data["east"])
		east = data["east"]
	if(data["west"])
		west = data["west"]
	if(data["north"])
		north = data["north"]
	if(data["south"])
		south = data["south"]

	//? traits
	if(length(data["traits"]))
		for(var/trait in data["traits"])
			add_trait(trait)

	//? attributes
	if(length(data["attributes"]))
		for(var/attribute in data["attributes"])
			set_attribute(attribute, data["attributes"])

	//? baseturf
	if(data["base_turf"])
		base_turf = text2path(data["base_turf"])
	if(data["base_area"])
		base_area = text2path(data["base_area"])

	//? air
	if(data["air_indoors"])
		air_indoors = data["air_indoors"]
	if(data["air_outdoors"])
		air_outdoors = data["air_outdoors"]

	//? module
	if(data["module"])
		level_module_type = text2path(data["module"])


#warn validate()

/**
 * first validation pass, verifies all values are up to spec
 */
/datum/space_level/proc/validate()
	. = FALSE
	//? basic
	ASSERTION(istext(id), "instead [id]")
	ASSERTION(map_path, "(was null)")
	//? map
	ASSERTION(orientation in GLOB.cardinal, "not cardinal instead [orientation]")
	ASSERTION(center == TRUE || center == FALSE, "not bool instead [center]")
	ASSERTION(fill_void == TRUE || fill_void == FALSE, "not bool instead [fill_void]")
	ASSERTION(!width || isnum(width), "not num or null instead [width]")
	ASSERTION(!height || isnum(height), "not num or null instead [height]")
	#warn map path
	//? linkage - ids
	ASSERTION(!up || istext(up), "not text or null instead [up]")
	ASSERTION(!down || istext(down), "not text or null instead [down]")
	ASSERTION(!east || istext(east), "not text or null instead [east]")
	ASSERTION(!west || istext(west), "not text or null instead [west]")
	ASSERTION(!north || istext(north), "not text or null instead [north]")
	ASSERTION(!south || istext(south), "not text or null instead [south]")
	//? linkage - mode
	ASSERTION(linkage_mode in list(
		Z_LINKAGE_NORMAL,
		Z_LINKAGE_CROSSLINKED,
		Z_LINKAGE_SELFLOOP,
	), "was [linkage_mode]")
	ASSERTION(transition_mode in list(
		Z_TRANSITION_FORCED,
		Z_TRANSITION_DISABLED,
		Z_TRANSITION_DEFAULT,
		Z_TRANSITION_INVISIBLE,
	), "was [transition_mode]")
	//? baseturfs
	ASSERTION(!base_turf || ispath(base_turf, /turf), "instead [base_turf]")
	ASSERTION(!base_area || ispath(base_area, /area), "instead [base_area]")
	//? air
	#warn air
	//? module
	ASSERTION(!level_module_type || ispath(level_module_type, /datum/level_module), "not null or correct path, instead [level_module_type]")
	return TRUE

/**
 * validation called with context for cross-validation
 *
 * @params
 * - map_data - (optional) map data we're loading in from
 * - level_by_id - (optional) id-associative list of relevant other levels
 */
/datum/space_level/proc/cross_validate(datum/map_data/map, list/level_by_id)
	#warn width/height matches
	#warn didn't override linkage ids when in struct

/**
 * Called after the level is physically created.
 *
 * @param
 * - z_index - physical z value
 * - maploaded - did our map_path get used to create us or are we a bare level at time of call?
 */
/datum/space_level/proc/post_load(z_index, maploaded)
	if(isnull(name))
		name = "Unknown Level [z_index]"

/**
 * Gets DMM path
 */
/datum/space_level/proc/get_path()
	return map_path

/datum/space_level/proc/set_id(id)
	if(instantiated)
		CRASH("attempted to change id of instantiated level; this will usually break things if allowed.")
	SSmapping.level_by_id -= src.id
	src.id = id
	#warn check to make sure
	SSmapping.level_by_id[src.id] = src

#warn everything above

/**
 * call to rebuild all turfs for vertical multiz
 *
 * this will sleep
 */
/datum/space_level/proc/rebuild_turfs()
	for(var/turf/T as anything in block(locate(x_min || 1, y_min || 1, z_value), locate(x_max || world.maxx, y_max || world.maxx, z_value)))
		T.update_multiz()
		CHECK_TICK
	turfs_rebuild_count++

/**
 * call to rebuild all turfs for horizontal transitions
 *
 * this will sleep
 */
/datum/space_level/proc/rebuild_transitions()
	switch(transition_mode)
		// do nothing
		if(Z_TRANSITION_DISABLED)
		// default not implemented
		if(Z_TRANSITION_FORCED, Z_TRANSITION_DEFAULT)
			// bottom
			for(var/turf/T as anything in block(locate((x_min || 1) + 1, y_min || 1, z_value), locate((x_max || world.maxx) - 1, y_min || 1, z_value)))
				T._make_transition_border(SOUTH, TRUE)
				CHECK_TICK
			// top
			for(var/turf/T as anything in block(locate((x_min || 1) + 1, y_max || world.maxy, z_value), locate((x_max || world.maxx) - 1, y_max || world.maxy, z_value)))
				T._make_transition_border(NORTH, TRUE)
				CHECK_TICK
			// left
			for(var/turf/T as anything in block(locate(x_min || 1, (y_min || 1) + 1, z_value), locate(x_min || 1, (y_max || world.maxy) - 1, z_value)))
				T._make_transition_border(WEST, TRUE)
				CHECK_TICK
			// right
			for(var/turf/T as anything in block(locate(x_max || world.maxx, (y_min || 1) + 1, z_value), locate(x_max || world.maxx, (y_max || world.maxy) - 1, z_value)))
				T._make_transition_border(EAST, TRUE)
				CHECK_TICK

			var/turf/T
			// bottomleft
			T = locate(x_min || 1, y_min || 1, z_value)
			T._make_transition_border(SOUTHWEST, TRUE)
			CHECK_TICK
			// bottomright
			T = locate(x_max || world.maxx, y_min || 1, z_value)
			T._make_transition_border(SOUTHEAST, TRUE)
			CHECK_TICK
			// topleft
			T = locate(x_min || 1, y_max || world.maxy, z_value)
			T._make_transition_border(NORTHWEST, TRUE)
			CHECK_TICK
			// topright
			T = locate(x_max || world.maxx, y_max || world.maxy, z_value)
			T._make_transition_border(NORTHEAST, TRUE)
			CHECK_TICK
		if(Z_TRANSITION_INVISIBLE)
			// bottom
			for(var/turf/T as anything in block(locate((x_min || 1) + 1, y_min || 1, z_value), locate((x_max || world.maxx) - 1, y_min || 1, z_value)))
				T._make_transition_border(SOUTH, FALSE)
				CHECK_TICK
			// top
			for(var/turf/T as anything in block(locate((x_min || 1) + 1, y_max || world.maxy, z_value), locate((x_max || world.maxx) - 1, y_max || world.maxy, z_value)))
				T._make_transition_border(NORTH, FALSE)
				CHECK_TICK
			// left
			for(var/turf/T as anything in block(locate(x_min || 1, (y_min || 1) + 1, z_value), locate(x_min || 1, (y_max || world.maxy) - 1, z_value)))
				T._make_transition_border(WEST, FALSE)
				CHECK_TICK
			// right
			for(var/turf/T as anything in block(locate(x_max || world.maxx, (y_min || 1) + 1, z_value), locate(x_max || world.maxx, (y_max || world.maxy) - 1, z_value)))
				T._make_transition_border(EAST, FALSE)
				CHECK_TICK

			var/turf/T
			// bottomleft
			T = locate(x_min || 1, y_min || 1, z_value)
			T._make_transition_border(SOUTHWEST, FALSE)
			CHECK_TICK
			// bottomright
			T = locate(x_max || world.maxx, y_min || 1, z_value)
			T._make_transition_border(SOUTHEAST, FALSE)
			CHECK_TICK
			// topleft
			T = locate(x_min || 1, y_max || world.maxy, z_value)
			T._make_transition_border(NORTHWEST, FALSE)
			CHECK_TICK
			// topright
			T = locate(x_max || world.maxx, y_max || world.maxy, z_value)
			T._make_transition_border(NORTHEAST, FALSE)
			CHECK_TICK
	transitions_rebuild_count++

/**
 * destroys all transitions on border turfs
 * call when changing level size
 *
 * this will sleep
 */
/datum/space_level/proc/destroy_transitions()
	// bottom
	for(var/turf/T as anything in block(locate(x_min || 1, y_min || 1, z_value), locate(x_max || world.maxx, y_min || 1, z_value)))
		T._dispose_transition_border()
		CHECK_TICK
	// top
	for(var/turf/T as anything in block(locate(x_min || 1, y_max || world.maxy, z_value), locate(x_max || world.maxx, y_max || world.maxy, z_value)))
		T._dispose_transition_border()
		CHECK_TICK
	// left
	for(var/turf/T as anything in block(locate(x_min || 1, (y_min || 1) + 1, z_value), locate(x_min || 1, (y_max || world.maxy) - 1, z_value)))
		T._dispose_transition_border()
		CHECK_TICK
	// right
	for(var/turf/T as anything in block(locate(x_max || world.maxx, (y_min || 1) + 1, z_value), locate(x_max || world.maxx, (y_max || world.maxy) - 1, z_value)))
		T._dispose_transition_border()
		CHECK_TICK

/**
 * Rebuild turfs up/down of us
 * This will sleep
 */
/datum/space_level/proc/rebuild_vertical_levels()
	for(var/datum/space_level/L in list(
		resolve_level_in_dir(UP),
		resolve_level_in_dir(DOWN)
	))
		L.rebuild_turfs()

/**
 * Rebuild turfs adjacent of us
 * This will sleep
 */
/datum/space_level/proc/rebuild_adjacent_levels()
	for(var/datum/space_level/L in list(
		resolve_level_in_dir(NORTH),
		resolve_level_in_dir(SOUTH),
		resolve_level_in_dir(EAST),
		resolve_level_in_dir(WEST)
	))
		L.rebuild_transitions()

/**
 * expand the level to fill the entire level, wiping void turfs on the way
 */
/datum/space_level/proc/remove_void()
	ASSERT(x_min && y_min && x_max && y_max)
	var/list/turf/turfs = list()
	if(x_min > 1)
		turfs += block(locate(1, 1, z_value), locate(x_min - 1, world.maxy, z_value))
	if(x_max < world.maxx)
		turfs += block(locate(x_max + 1, 1, z_value), locate(world.maxx, world.maxy, z_value))
	if(y_min > 1)
		turfs += block(locate(x_min, 1, z_value), locate(x_max, y_min - 1, z_value))
	if(y_max < world.maxy)
		turfs += block(locate(x_min, y_max + 1, z_value), locate(x_max, world.maxy, z_value))
	var/area/new_area = base_area
	if(initial(new_area.unique))
		new_area = GLOB.areas_by_type[world.area]
		if(!new_area)
			stack_trace("No area found even though unique?")
			new_area = new world.area
	else
		new_area = new world.area
	for(var/turf/T in turfs)
		if(istype(T, VOID_TURF_TYPE))
			T.ChangeTurf(base_turf)
		if(istype(T.loc, VOID_AREA_TYPE))
			T.loc = new_area

//! Attributes
/**
 * Get value of attribute
 */
/datum/space_level/proc/get_attribute(attr)
	return attributes[attr]

/**
 * Set value of attribute
 */
/datum/space_level/proc/set_attribute(attr, val)
	attributes[attr] = val
	if(!instantiated)
		return
	SSmapping.on_attribute_set(src, attr, val)

//! Traits
/**
 * Do we have a certain trait?
 */
/datum/space_level/proc/has_trait(trait)
	return traits[trait]

/**
 * Removes a trait
 */
/datum/space_level/proc/remove_trait(trait)
	traits -= trait
	if(!instantiated)
		return
	SSmapping.on_trait_del(src, trait)

/**
 * Adds a trait
 */
/datum/space_level/proc/add_trait(trait)
	traits[trait] = TRUE
	if(!instantiated)
		return
	SSmapping.on_trait_add(src, trait)

/**
 * clear traits
 */
/datum/space_level/proc/clear_traits()
	for(var/trait in traits)
		remove_trait(trait)

//! Linkage
/**
 * Sets a multiz/transition point to another level.
 *
 * WARNING: As with all core map/zlevel management backend procs, this is a dangerous proc to use.
 * Do not use this unless you know what you are doing.
 *
 * This proc does NOT automatically rebuild/update multiz and transitions - YOU have to do this.
 * SSmapping will also not update its lookups automatically.
 *
 * @param
 * - other - map level id to set this to link to, or direct reference
 */
/datum/space_level/proc/set_east(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other))
	east = other

/datum/space_level/proc/set_west(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other))
	west = other

/datum/space_level/proc/set_north(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other))
	north = other

/datum/space_level/proc/set_south(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other))
	south = other

/datum/space_level/proc/set_up(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other))
	up = other

/datum/space_level/proc/set_down(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other))
	down = other

/**
 * Gets neighbor *datum* in dir
 */
/datum/space_level/proc/resolve_level_in_dir(dir)
	RETURN_TYPE(/datum/space_level)
	// diagonal
	if(dir & (dir - 1))
		var/datum/space_level/NS = resolve_level_in_dir(NSCOMPONENT(dir))
		var/datum/space_level/EW = resolve_level_in_dir(EWCOMPONENT(dir))
		if(!NS || !EW)
			return null
		// both exist, check for "agreement"
		var/datum/space_level/potential = NS.resolve_level_in_dir(EWCOMPONENT(dir))
		return (EW.resolve_level_in_dir(NSCOMPONENT(dir)) == potential)? potential : null
	// cardinal
	else
		switch(dir)
			if(NORTH)
				return istype(north, /datum/space_level)? north : SSmapping.level_by_id[north]
			if(SOUTH)
				return istype(south, /datum/space_level)? south : SSmapping.level_by_id[south]
			if(EAST)
				return istype(east, /datum/space_level)? east : SSmapping.level_by_id[east]
			if(WEST)
				return istype(west, /datum/space_level)? west : SSmapping.level_by_id[west]
			if(UP)
				return istype(up, /datum/space_level)? up : SSmapping.level_by_id[up]
			if(DOWN)
				return istype(down, /datum/space_level)? down : SSmapping.level_by_id[down]
			else
				CRASH("Invalid dir: [dir]")
