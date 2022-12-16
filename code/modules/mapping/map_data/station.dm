#define VALIDATION(cond, msg) if(!(cond)) {errors += "validation failed: [#cond] ; [msg]"; . = FALSE;}

/**
 * Represents map configs that are loaded as the primary station map.
 * Called a station map config, but this doesn't have to be a station.
 */
/datum/map_data/station
	//? map type
	/// This should be used to adjust ingame behavior depending on the specific type of map being played. For instance, if an overmap were added, it'd be appropriate for it to only generate with a MAP_TYPE_SHIP
	var/maptype = MAP_TYPE_STATION
	//? persistence
	/// Persistence key: Defaults to ckey(map_name). If set to "NO_PERSIST", this map will have NO persistence.
	var/persistence_key

	#warn hoist this to base config see #warn's there
	/// Extra map levels to load. Should be {"integral" = ["centcom", "lavaland"], "planet" = ["blah"]}, etc.
	var/list/lateload

	//? job data
	// Job overrides - these process on job datum creation!
	/// Jobs whitelist - if this is not empty, ONLY these jobs are allowed. Overrides blacklist. Overrided by enable_jobs on loaded sectors.
	var/list/job_whitelist
	/// Jobs blacklist - if this is not empty, jobs in this aren't allowed. Overrides enable_jobs on loaded sectors.
	var/list/job_blacklist
	/// Job spawn position mod - type = number
	var/list/job_override_spawn_positions
	/// Job total position mod - type = number
	var/list/job_override_total_positions
	/// Add these accesses to jobs - type = list()
	var/list/job_access_add
	/// Remove these accesses from jobs - type = list()
	var/list/job_access_remove
	/// Override job accesses - type = list() - overrides everything else
	var/list/job_access_override
	// Job overrides end
	#warn impl job overrides

	//? MISC / UNSORTED - ported from legacy; some of these should probably be rethought, some should be organized later.


/datum/map_data/station/parse(list/data)
	. = ..()
	// map type
	if(data["maptype"])
		maptype = data["maptype"]
	// persistence
	if("persistence_key" in data)
		persistence_key = data["persistence_key"] || id

	// job data
	job_whitelist = data["job_whitelist"]
	job_blacklist = data["job_blacklist"]
	job_override_spawn_positions = data["job_override_spawn_positions"]
	job_override_total_positions = data["job_override_total_positions"]
	job_access_add = data["job_access_add"]
	job_access_remove = data["job_access_remove"]
	job_access_override = data["job_access_override"]
	if("allow_custom_shuttles" in data)
		allow_custom_shuttles = data["allow_custom_shuttles"]? TRUE : FALSE
	if("announcertype" in data)
		announcertype = data["announcertype"]
	if("space_ruin_levels" in data)
		space_ruin_levels = data["space_ruin_levels"]
	if("space_empty_levels" in data)
		space_empty_levels = data["space_empty_levels"]
	if("station_ruin_budget" in data && data["station_ruin_budget"] != -1)
		station_ruin_budget = data["station_ruin_budget"]
	if("shutles" in data)
		shuttles = data["shuttles"]
	if("lateload" in data)
		lateload = data["lateload"]

#undef VALIDATION
