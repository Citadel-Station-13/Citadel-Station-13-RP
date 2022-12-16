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
	//? Full name
	var/full_name

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
	#warn impl job overrides

	//? MISC / UNSORTED - ported from legacy; some of these should probably be rethought, some should be organized later.
	//? networks
	/// usable email tlds
	var/list/usable_email_tlds = list("freemail.nt")
	/// primary cameranets
	var/list/station_networks = list()
	/// cameranets that don't show up on regular monitors
	var/list/secondary_networks = list()
	//? silicons
	var/default_law_type = /datum/ai_laws/nanotrasen	// The default lawset use by synth units, if not overriden by their laws var.
	//? holomaps
	//? bots
	var/bot_patrolling = TRUE				// Determines if this map supports automated bot patrols
	//? overmaps
	var/use_overmap = 0			// If overmap should be used (including overmap space travel override)
	var/overmap_size = 20		// Dimensions of overmap zlevel if overmap is used.
	var/overmap_z = 0			// If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	var/overmap_event_areas = 0	// How many event "clouds" will be generated
	//? names
	var/station_name  = "BAD Station"
	var/station_short = "Baddy"
	var/dock_name	  = "THE PirateBay"
	var/dock_type	  = "station"	// For a list of valid types see the switch block in air_traffic.dm at line 148
	var/boss_name	  = "Captain Roger"
	var/boss_short	  = "Cap'"
	var/company_name  = "BadMan"
	var/company_short = "BM"
	var/starsys_name  = "Dull Star"

	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/shuttle_name  = "NAS |Hawking|"
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_called_message
	var/emergency_shuttle_recall_message

	#warn parse, don't validate legacy tho

/**
 * returns the current map config
 * use on old things converted to the new system without reorganization for easy regexing
 * e.g. direct access of station_name, etc.
 */
/proc/using_map_legacy()
	RETURN_TYPE(/datum/map_data/station)
	return SSmapping.map

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

//? legacy shit
// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
// This list needs to be purged but people insist on adding more cruft to the radio.
/datum/map_data/proc/default_internal_channels()
	return list(
		num2text(PUB_FREQ)   = list(),
		num2text(AI_FREQ)    = list(access_synth),
		num2text(ENT_FREQ)   = list(),
		num2text(ERT_FREQ)   = list(access_cent_specops),
		num2text(COMM_FREQ)  = list(access_heads),
		num2text(ENG_FREQ)   = list(access_engine_equip, access_atmospherics),
		num2text(MED_FREQ)   = list(access_medical_equip),
		num2text(MED_I_FREQ) = list(access_medical_equip),
		num2text(SEC_FREQ)   = list(access_security),
		num2text(SEC_I_FREQ) = list(access_security),
		num2text(SCI_FREQ)   = list(access_tox,access_robotics,access_xenobiology),
		num2text(SUP_FREQ)   = list(access_cargo),
		num2text(SRV_FREQ)   = list(access_janitor, access_hydroponics),
	)

