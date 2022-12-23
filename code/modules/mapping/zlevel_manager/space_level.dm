#define VALIDATION(cond, msg) if(!(cond)) {errors += "validation failed on [id || "\[NO ID\]"] / [name || "\[NO NAME\]"]: [#cond] ; [msg]"; . = FALSE;}

/**
 * Map level datums
 *
 * Used by the zlevel manager, contains all data about a zlevel.
 */
/datum/space_level
	//! Basic information
	/// Name - NOT IC FACING
	var/name
	/// ID - defaults to null
	var/id
	/// id was autogen'd
	var/random_id
	/// fluff ID - seen IC by players
	var/fluff_id
	#warn fluff id impl parse rand

	//! Instantiation
	/// Our z value
	var/tmp/z_value
	/// Are we physically made yet?
	var/tmp/instantiated = FALSE
	/// Errored - validation failed
	var/tmp/errored = TRUE
	/// Absolute path we loaded from
	var/tmp/loaded_path
	/// loading errors
	var/tmp/list/errors

	// todo: lazy validation

	//! Map File / Loading
	/// Path to .dmm - this must be relative to the folder the .json was loaded from.
	/// Yeah, this means you can't link outside of nested directories, only deeper, but frankly, sue me.
	/// To set this use "path" in the .json
	/// you can start with maps/, config/, to absolutely path from those folders.
	var/map_path
	/// load orientation
	var/orientation = SOUTH
	/// load centered?
	var/center
	/// load "void" tiles for blank areas when we're smaller than the world zlevel size as opposed to baseturf
	var/fill_void
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
	var/transition_mode = Z_TRANSITION_DEFAULT

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
	#warn anything reading this should be able to handle nulls as world default

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

	//! legacy stuff refactor pending
	var/holomap_offset_x = -1
	var/holomap_offset_y = -1
	var/holomap_legend_x = 96
	var/holomap_legend_y = 96

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

/datum/space_level/proc/parse_and_validate(list/data, pathroot)
	errors = null
	parse(data, pathroot)
	validate()
	cross_validate()

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
	if(!isnull(data["name"]))
		name = data["name"]
	if(!isnull(data["id"]))
		set_id(data["id"])
		random_id = FALSE
	// still not set? set to id.
	if(!name)
		name = id

	//? files / loading
	if(!isnull(data["orientation"]))
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
	if(!isnull(data["center"]))
		center = !!data["center"]
	if(!isnull(data["fill_void"]))
		fill_void = !!data["fill_void"]
	if(!isnull(data["width"]))
		width = text2num(data["width"])
	if(!isnull(data["height"]))
		height = text2num(data["height"])

	#warn path needs to support maps/ and config/ as well as relative.
	if(data["path_absolute"])
		map_path = data["path_absolute"]
	else if(!isnull(data["path"]))
		map_path = pathroot + data["path"]


	//? linkage info
	if(!isnull(data["transition"]))
		transition_mode = data["transition"]
	if(!isnull(data["linkage"]))
		linkage_mode = data["linkage"]

	//? linkage overrides
	if(!isnull(data["up"]))
		up = data["up"]
	if(!isnull(data["down"]))
		down = data["down"]
	if(!isnull(data["east"]))
		east = data["east"]
	if(!isnull(data["west"]))
		west = data["west"]
	if(!isnull(data["north"]))
		north = data["north"]
	if(!isnull(data["south"]))
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
	if(!isnull(data["base_turf"]))
		base_turf = text2path(data["base_turf"])
	if(!isnull(data["base_area"]))
		base_area = text2path(data["base_area"])

	//? air
	if(!isnull(data["air_indoors"]))
		air_indoors = data["air_indoors"]
	if(!isnull(data["air_outdoors"]))
		air_outdoors = data["air_outdoors"]

	//? module
	if(!isnull(data["module"]))
		level_module_type = text2path(data["module"])

	//? legacy - not validated
	if(!isnull(data["holomap_offset_x"]))
		holomap_offset_x = data["holomap_offset_x"]
	if(!isnull(data["holomap_offset_y"]))
		holomap_offset_x = data["holomap_offset_y"]
	if(!isnull(data["holomap_legend_x"]))
		holomap_offset_x = data["holomap_legend_x"]
	if(!isnull(data["holomap_legend_y"]))
		holomap_offset_x = data["holomap_legend_y"]
	// Auto-center the map if needed (Guess based on maxx/maxy)
	if (holomap_offset_x < 0)
		holomap_offset_x = ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
	if (holomap_offset_x < 0)
		holomap_offset_y = ((HOLOMAP_ICON_SIZE - world.maxy) / 2)

/**
 * first validation pass, verifies all values are up to spec
 */
/datum/space_level/proc/validate(list/errors = list())
	. = TRUE
	//? basic
	VALIDATION(istext(id) && length(id), "instead [id]")
	VALIDATION(istext(name) && length(name), "instead [name]")
	VALIDATION(istext(map_path) && length(map_path), "(was null)")
	//? map
	VALIDATION(orientation in GLOB.cardinal, "not cardinal instead [orientation]")
	VALIDATION(center == TRUE || center == FALSE, "not bool instead [center]")
	VALIDATION(fill_void == TRUE || fill_void == FALSE, "not bool instead [fill_void]")
	VALIDATION(isnull(width) || isnum(width), "not num or null instead [width]")
	VALIDATION(isnull(height) || isnum(height), "not num or null instead [height]")
	#warn map path
	//? linkage - ids
	VALIDATION(isnull(up) || (istext(up) && length(up)), "not text or null instead [up]")
	VALIDATION(isnull(down) || (istext(down) && length(up)), "not text or null instead [down]")
	VALIDATION(isnull(east) || (istext(east) && length(up)), "not text or null instead [east]")
	VALIDATION(isnull(west) || (istext(west) && length(up)), "not text or null instead [west]")
	VALIDATION(isnull(north) || (istext(north) && length(up)), "not text or null instead [north]")
	VALIDATION(isnull(south) || (istext(south) && length(up)), "not text or null instead [south]")
	//? linkage - mode
	VALIDATION(linkage_mode in list(
		Z_LINKAGE_NORMAL,
		Z_LINKAGE_CROSSLINKED,
		Z_LINKAGE_SELFLOOP,
	), "was [linkage_mode]")
	VALIDATION(transition_mode in list(
		Z_TRANSITION_FORCED,
		Z_TRANSITION_DISABLED,
		Z_TRANSITION_DEFAULT,
		Z_TRANSITION_INVISIBLE,
	), "was [transition_mode]")
	//? baseturfs
	VALIDATION(isnull(base_turf) || ispath(base_turf, /turf), "instead [base_turf]")
	VALIDATION(isnull(base_area) || ispath(base_area, /area), "instead [base_area]")
	//? air
	#warn air
	//? module
	VALIDATION(isnull(level_module_type) || ispath(level_module_type, /datum/level_module), "not null or correct path, instead [level_module_type]")
	LAZYOR(src.errors, errors)

/**
 * validation called with context for cross-validation
 *
 * @params
 * - errors - error list
 * - map_data - (optional) map data we're loading in from
 * - keyed_levels - (optional) id-associative list of relevant other levels
 */
/datum/space_level/proc/cross_validate(list/errors = list(), datum/map_data/map, list/keyed_levels)
	. = TRUE

	#warn width/height matches
	#warn didn't override linkage ids when in struct
	#warn inherit air, center, orientation, fill void if null

	LAZYOR(src.errors, errors)

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
	#warn trigger level

/**
 * Gets DMM path
 */
/datum/space_level/proc/get_path()
	return map_path

/datum/space_level/proc/set_id(id)
	if(instantiated)
		CRASH("attempted to change id of instantiated level; this will usually break things if allowed.")
	SSmapping.keyed_levels -= src.id
	src.id = id
	#warn check to make sure
	SSmapping.keyed_levels[src.id] = src

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
				return istype(north, /datum/space_level)? north : SSmapping.keyed_levels[north]
			if(SOUTH)
				return istype(south, /datum/space_level)? south : SSmapping.keyed_levels[south]
			if(EAST)
				return istype(east, /datum/space_level)? east : SSmapping.keyed_levels[east]
			if(WEST)
				return istype(west, /datum/space_level)? west : SSmapping.keyed_levels[west]
			if(UP)
				return istype(up, /datum/space_level)? up : SSmapping.keyed_levels[up]
			if(DOWN)
				return istype(down, /datum/space_level)? down : SSmapping.keyed_levels[down]
			else
				CRASH("Invalid dir: [dir]")

#undef VALIDATION
