#define VALIDATION(cond, msg) if(!(cond)) {errors += "validation failed: [#cond] ; [msg]"; . = FALSE;}

/**
 * Represents map configs that are loaded as the primary station map.
 * Called a station map config, but this doesn't have to be a station.
 */
/datum/map_data/station
	//? map type
	/// This should be used to adjust ingame behavior depending on the specific type of map being played. For instance, if an overmap were added, it'd be appropriate for it to only generate with a MAP_TYPE_SHIP
	var/maptype
	//? persistence
	/// Persistence key: Defaults to ckey(map_name). If set to "NO_PERSIST", this map will have NO persistence.
	var/persistence_key

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
	var/list/usable_email_tlds
	/// primary cameranets
	var/list/station_networks
	/// cameranets that don't show up on regular monitors
	var/list/secondary_networks
	//? silicons
	/// The default lawset use by synth units, if not overriden by their laws var.
	var/default_law_type
	//? holomaps
	#warn impl + parse
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
	//? map type
	maptype = data["maptype"]
	//? persistence
	persistence_key = data["persistence_key"]
	//? job data
	job_whitelist = data["job_whitelist"]
	job_blacklist = data["job_blacklist"]
	job_override_spawn_positions = data["job_override_spawn_positions"]
	job_override_total_positions = data["job_override_total_positions"]
	job_access_add = data["job_access_add"]
	job_access_remove = data["job_access_remove"]
	job_access_override = data["job_access_override"]
	//? legacy shit
	var/list/legacy = data["legacy"]
	usable_email_tlds = legacy["usable_email_tlds"] || list("freemail.nt")
	station_networks = legacy["station_networks"] || list()
	secondary_networks = legacy["secondary_networks"] || list()
	default_law_type = text2path(legacy["default_law_type"])
	if(!ispath(default_law_type, /datum/ai_laws))
		default_law_type = /datum/ai_laws/nanotrasen
	bot_patrolling = isnull(legacy["bot_patrolling"])? TRUE : legacy["bot_patrolling"]
	use_overmap = isnull(legacy["use_overmap"])? TRUE: legacy["use_overmap"]
	overmap_size = legacy["overmap_size"] || 20
	overmap_z = legacy["overmap_z"] || 0
	overmap_event_areas = legacy["overmap_event_areas"] || 0
	station_name = legacy["station_name"] || "ERR - NO STATION NAME"
	station_short = legacy["station_short"] || "ERR - NO STAITON SHORT"
	dock_name = legacy["dock_name"] || "ERR - NO DOCK NAME"
	dock_type = legacy["dock_type"] || "ERR - NO DOCK TYPE"
	boss_name = legacy["boss_name"] || "ERR - NO BOSS NAME"
	boss_short = legacy["boss_short"] || "ERR - NO BOSS SHORT"
	company_name = legacy["company_name"] || "ERR - NO COMPANY NAME"
	company_short = legacy["company_short"] || "ERR - NO COMPANY SHORT"
	starsys_name = legacy["starsys_name"] || "ERR - NO STARSYS NAME"
	shuttle_docked_message = legacy["shuttle_docked_message"] || "ERR - NO SHUTTLE DOCKED MSG"
	shuttle_leaving_dock = legacy["shuttle_leaving_dock"] || "ERR - NO SHUTTLE LEAVING DOCK MSG"
	shuttle_called_message = legacy["shuttle_called_message"] || "ERR - NO SHUTTLE CALLED MSG"
	shuttle_recall_message = legacy["shuttle_recall_message"] || "ERR - NO SHUTTLE RECALL MSG"
	shuttle_name = legacy["shuttle_name"] || "ERR - NO SHUTTLE NAME"
	emergency_shuttle_docked_message = legacy["emergency_shuttle_docked_message"] || "ERR - NO ESHUTTLE DOCKED MSG"
	emergency_shuttle_leaving_dock = legacy["emergency_shuttle_leaving_dock"] || "ERR - NO ESHUTTLE LEAVE MSG"
	emergency_shuttle_called_message = legacy["emergency_shuttle_called_message"] || "ERR - NO ESHUTTLE CALL MSG"
	emergency_shuttle_recall_message = legacy["emergency_shuttle_recall_message"] || "ERR - NO ESHUTTLE RCALL MSG"


/datum/map_data/station/validate(list/errors, list/level_ids)
	. = ..()
	//? map type
	VALIDATION(maptype in list(
		MAP_TYPE_MINIMAL,
		MAP_TYPE_PLANET,
		MAP_TYPE_SHIP,
		MAP_TYPE_STATION
	), "invalid maptype: [maptype]")
	//? persistence
	VALIDATION(isnull(persistence_key) || (istext(persistence_key) && length(persistence_key)), "invalid persistence key - must be null or text")
	//? jobs
	// todo

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

