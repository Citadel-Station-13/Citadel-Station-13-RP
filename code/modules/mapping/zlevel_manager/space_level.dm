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

	#warn hook these into load process and generation
	// bounds - for when we had to fill void.
	/// start x inclusive
	var/bottomleft_x
	/// start y inclusive
	var/bottomleft_y
	/// end x inclusive
	var/topright_x
	/// end y inclusive
	var/topright_y
	/// width
	var/width
	/// height
	var/height

	//! Linkage - IDs
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

	//! Crosslinking
	/// Current crosslinking x in grid
	var/tmp/cl_x
	/// Current crosslinking y in grid
	var/tmp/cl_y

	//! Level modules
	/// /datum/level_module to execute
	var/level_module_type
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
		src.id = id
	if(!src.id)
		src.id = "[GUID()]"
		src.random_id = TRUE
	else
		src.random_id = FALSE
	if(map_path)
		src.map_path = map_path
	if(traits)
		for(var/trait in traits)
			add_trait(trait)
	if(attributes)
		for(var/key in attributes)
			set_attribute(key, attributes[key])

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
	#warn make sure everything matches the vars
	#warn default base_turf to world.turf
	#warn default base_area to world.area
	if(instantiated)
		CRASH("attempted to reload json while already instantiated")
	if(!islist(data))
		CRASH("Invalid data list")
	raw_json = data
	if(data["name"])
		name = data["name"]
	if(data["id"])
		SetID(data["id"])
		random_id = FALSE
		#warn this shouldn't use set id
	if(data["path_absolute"])
		map_path = data["path_absolute"]
	else if(data["path"])
		map_path = pathroot + data["path"]
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
				else
					orientation = SOUTH
		else if(isnum(orientation))
			if(!(orientation in GLOB.cardinal))
				orientation = SOUTH
	if(data["center"])
		center = data["center"]
	if(data["fill_void"])
		fill_void = data["fill_void"]
	// This part links us based on index.
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
	if(data["baseturf"])
		baseturf = text2path(data["baseturf"])
		if(!ispath(baseturf))
			baseturf = down? /turf/open/openspace : world.turf
			stack_trace("Invalid baseturf [data["baseturf"]].")
	if(data["traits"])
		for(var/i in data["traits"])
			add_trait(i)
	if(data["attributes"])
		for(var/key in data["attributes"])
			set_attribute(key, data["attributes"][key])
	if(data["linkage_mode"])
		linkage_mode = data["linkage_mode"]

#warn validate()

/**
 * Called after the level is physically created.
 *
 * @param
 * - z_index - physical z value
 * - maploaded - did our map_path get used to create us or are we a bare level at time of call?
 */
/datum/space_level/proc/PostLoad(z_index, maploaded)
	if(isnull(name))
		name = "Unknown Level [z_index]"

/**
 * Gets DMM path
 */
/datum/space_level/proc/GetPath()
	return map_path

/datum/space_level/proc/SetID(id)
	if(instantiated)
		CRASH("attempted to change id of instantiated level; this will usually break things if allowed.")
	SSmapping.level_by_id -= src.id
	src.id = id
	#warn check to make sure
	SSmapping.level_by_id[src.id] = src

#warn everything below

/**
 * call to rebuild all turfs for vertical multiz
 *
 * this will sleep
 */
/datum/space_level/proc/RebuildTurfs()
	for(var/turf/T as anything in block(locate(1,1,z_value), locate(world.maxx, world.maxy, z_value)))
		T.UpdateMultiZ()
		CHECK_TICK
	turfs_rebuild_count++

/**
 * call to rebuild all turfs for horizontal transitions
 *
 * this will sleep
 */
/datum/space_level/proc/RebuildTransitions()
	var/list/checking = list()
	#warn support less-than-world-size levels
	checking += block(locate(1, 1, z_value), locate(world.maxx, 1, z_value))
	checking += block(locate(1, world.maxy, z_value), locate(world.maxx, world.maxy, z_value))
	checking += block(locate(1, 2, z_value), locate(1, world.maxy - 1, z_value))
	checking += block(locate(world.maxx, 2, z_value), locate(world.maxx, world.maxy - 1, z_value))
	for(var/turf/T in checking)
		T.UpdateTransitions()
		CHECK_TICK
	transitions_rebuild_count++

#warn all of this shit is sihtcode above and below redo it
#warn add Z_TRANSITION_X handling
#warn Z_TRANSITION_DEFAULT should detect turf changes to automatically make transitions when adminbus happens

/**
 * Rebuild turfs up/down of us
 */
/datum/space_level/proc/RebuildVerticalLevels()
	for(var/datum/space_level/L in list(
		resolve_level_in_dir(UP),
		resolve_level_in_dir(DOWN)
	))
		L.RebuildTurfs()

/**
 * Rebuild turfs adjacent of us
 */
/datum/space_level/proc/RebuildAdjacentLevels()
	for(var/datum/space_level/L in list(
		resolve_level_in_dir(NORTH),
		resolve_level_in_dir(SOUTH),
		resolve_level_in_dir(EAST),
		resolve_level_in_dir(WEST)
	))
		L.RebuildTransitions()

/**
 * expand the level to fill the entire level, wiping void turfs on the way
 */
/datum/space_level/proc/RemoveVoid()
	ASSERT(bottomleft_x && bottomleft_y && topright_x && topright_y)
	var/list/turf/turfs = list()
	if(bottomleft_x > 1)
		turfs += block(locate(1, 1, z_value), locate(bottomleft_x - 1, world.maxy, z_value))
	if(topright_x < world.maxx)
		turfs += block(locate(topright_x + 1, 1, z_value), locate(world.maxx, world.maxy, z_value))
	if(bottomleft_y > 1)
		turfs += block(locate(bottomleft_x, 1, z_value), locate(topright_x, bottomleft_y - 1, z_value))
	if(topright_y < world.maxy)
		turfs += block(locate(bottomleft_x, topright_y + 1, z_value), locate(topright_x, world.maxy, z_value))
	var/area/new_area = world.area
	if(initial(new_area.area_flags) & UNIQUE_AREA)
		new_area = GLOB.areas_by_type[world.area]
		if(!new_area)
			stack_trace("No area found even though unique?")
			new_area = new world.area
	else
		new_area = new world.area
	for(var/turf/T in turfs)
		if(istype(T, VOID_TURF_TYPE))
			T.ChangeTurf(world.turf)
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
/datum/space_level/proc/remove_triat(trait)
	traits -= trait
	SSmapping.on_trait_del(src, trait)

/**
 * Adds a trait
 */
/datum/space_level/proc/add_trait(trait)
	traits[trait] = TRUE
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
