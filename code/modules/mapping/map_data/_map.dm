#define VALIDATION(cond, msg) if(!(cond)) {errors += "validation failed: [#cond] ; [msg]"; . = FALSE;}

/**
 * Map datums
 *
 * Holds all the data necessary to load, instantiate, and use a map.
 */
/datum/map_data
	//! Basic Information
	/// Unique ID
	var/id
	/// Player facing OOC name
	var/name

	//! Instantiation
	/// Parsed correctly? / Validated
	var/tmp/errored = TRUE
	/// Original path of .json
	var/tmp/loaded_path
	/// Instantiated?
	var/tmp/instantiated = FALSE
	/// loading errors
	var/tmp/list/errors

	// todo: lazy validation

	//! Map - you MUST set these
	/// Width
	var/width
	/// Height
	var/height
	/// Default centering
	var/center = TRUE
	/// Orientation to load in by default.
	var/orientation = SOUTH		//byond defaults to placing everyting SOUTH.
	/// default fill void
	var/fill_void = FALSE
	/// level dependencies - these will be loaded with this
	var/list/dependencies

	//! Levels
	/// zlevel datums - ordered list
	var/list/datum/space_level/levels
	/// world_structs to set up - list("id" = z_grid, "id2" = z_grid 2, etc)
	var/list/world_structs

	//! Baseturf
	/// default base turf - path
	var/base_turf
	/// default base area - path
	var/base_area

	//! Air
	/// default indoors gas string
	var/air_indoors = GAS_STRING_STP
	/// default outdoors gas string
	var/air_outdoors = GAS_STRING_VACUUM

	//! Jobs
	/*
	 * job ids/typepaths to enable for level-specific jobs - if loaded midround, the jobs will be instantiated on the spot if it's not already there
	 * if this is present roundstart, it'll make the job instantiate as normal in normal job instantiation
	 * note: there's no job slot override system other than on the station itself. this is intentional,
	 * because if you're making a job specifically for one map level, the job itself should just have the vars set correctly,
	 * not the map datum!
	 *
	 * This will override job whitelist.
	 */
	var/list/enable_jobs
	#warn enable jobs needs to be used on load

	//! Map Modules
	/// /datum/map_module to load
	var/map_module_type
	/// instanced map module
	var/datum/map_module/map_module

#warn parse this file
#warn lazyload everything, don't instantly json read
#warn /datum/map_module
#warn allow all map configs to "require" other map configs for loading
#warn when admin loading a level, make sure to confirm with them what they'll load in.
#warn world struct support
#warn planet support on level and world struct
#warn support circular references and cross referencing for structs and planets!
#warn automatic world struct generation based on closure

/datum/map_data/New(file_jsonstr_list, path)
	if(file_jsonstr_list)
		var/list/data = file_jsonstr_list
		if(!istype(data))
			if(isfile(data))
				data = safe_json_decode(file2text(data))
			else if(istext(data))
				data = safe_json_decode(data)
		parse(data, path)
	original_path = path

/datum/map_data/Destroy(force)
	if(instantiated && !force)
		. = QDEL_HINT_LETMELIVE
		CRASH("Attempted to qdel an instantiated map config. This is going to cause problems - SSmapping will cache all loaded levels for data retrieval.")
	QDEL_LIST(levels)
	return ..()

/datum/map_data/proc/parse(list/data, path)
	if(instantiated)
		CRASH("attempted to JSON parse an instantiated datum")
	ASSERT(islist(data))
	//? basic info
	id = data["id"]
	name = data["name"]
	//? map
	width = text2num(data["width"])
	height = text2num(data["height"])
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
	else
		orientation = initial(orientation)
	if(!isnull(data["center"]))
		center = !!data["center"]
	else
		center = initial(center)
	if(!isnull(data["fill_void"]))
		fill_void = !!data["fill_void"]
	else
		fill_void = initial(fill_void)
	dependencies = list()
	if(!isnull(data["dependencies"]))
		for(var/group in data["dependencies"])
			for(var/id in data["dependencies"][group])
				dependencies += "[group]:[id]"
	//? levels
	if(levels)
		QDEL_LIST(levels)
	levels = list()
	var/pathroot = path && (copytext_char(path, 1, findlasttext_char(path, "/")) + "/")
	for(var/list/level_data in data["levels"])
		var/datum/space_level/level = new
		level.parse(level_data, pathroot)
		levels += level
	world_structs = list()
	for(var/list/struct_data in data["structs"])
		world_structs += struct_data.Copy()
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
	//? Jobs
	enable_jobs = list()
	if(!isnull(data["jobs"]))
		for(var/job_id in data["jobs"])
			if(job_id[1] == "/")
				var/datum/job/maybe = text2path(job_id)
				if(ispath(maybe, /datum/job))
					job_id = initial(maybe.id)
			enable_jobs += job_id
	//? Modules
	if(!isnull(data["module"]))
		map_module_type = text2path(data["module"])
	else
		map_module_type = initial(map_module_type)

/datum/map_data/proc/parse_and_validate(list/data, pathroot)
	errors = null
	parse(data, pathroot)
	var/list/lookup = list()
	validate(level_ids = lookup)
	cross_validate(level_ids = lookup)

/datum/map_data/proc/validate(list/errors = list(), list/level_ids = list())
	. = TRUE
	//? basic
	VALIDATION(istext(id) && length(id), "must have id")
	VALIDATION(istext(name) && length(name), "must have name")
	//? map
	VALIDATION(isnum(width) && width > 0, "non-positive width")
	VALIDATION(isnum(height) && height > 0, "non-positive height")
	VALIDATION(center == TRUE || center == FALSE, "non-bool default centering")
	VALIDATION(fill_void == TRUE || fill_void == FALSE, "non-bool default voidfill")
	VALIDATION(orientation in GLOB.cardinal, "non-cardinal default orientation")
	//? baseturfs
	VALIDATION(isnull(base_turf) || ispath(base_turf, /turf), "instead [base_turf]")
	VALIDATION(isnull(base_area) || ispath(base_area, /area), "instead [base_area]")
	//? air
	#warn air
	//? jobs
	for(var/id in enable_jobs)
		// soft failure
		if(!SSjob.job_lookup[id])
			errors += "job resolution failure ; [id] no longer exists as a job and will be removed."
			enable_jobs -= id
			continue
	//? module
	VALIDATION(isnull(level_module_type) || ispath(level_module_type, /datum/level_module), "not null or correct path, instead [level_module_type]")
	//? levels
	for(var/datum/space_level/level as anything in levels)
		if(level_ids[level.id])
			errors += "fatal: level id collision on [level.id] in current load group!"
			continue
		level.validate(errors)
		level_ids[level.id] = level
	LAZYOR(src.errors, errors)

/datum/map_data/proc/cross_validate(list/errors = list(), list/level_ids = list())
	. = TRUE
	for(var/datum/space_level/level as anything in levels)
		if(!level.cross_validate(errors, src, level_ids))
			. = FALSE
	LAZYOR(src.errors, errors)

/datum/map_data/proc/asset_validate()
	for(var/id in dependencies)
		#warn this is in group:id format, convert subsystem to match

#warn for both this and space levels, validation errors need to go into unit tests AND
#warn spit errors at to chat world LOUDLY if it's mid-load.

/**
 * Called after loading with a list of z indices corrosponding to each level in the map.
 */
/datum/map_data/proc/post_load(list/ordered_z)
	for(var/list/data in world_structs)
		var/datum/world_struct/S = new
		S.Construct(data)
	#warn needs to do id lookup
	#warn need to trigger module

#undef VALIDATION
