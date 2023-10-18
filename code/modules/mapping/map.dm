/**
 * maps
 * clusters of zlevels, basically.
 *
 * when maps are loaded, areas are cached together to preserve byond-like behavior.
 */
/datum/map
	abstract_type = /datum/map
	/// id - must be unique
	var/id
	/// in-code name
	var/name = "Unknown Map"
	/// in-code category
	var/category = "Misc"
	/// /datum/map_level datums. starts off as paths, inits later.
	//  todo: for now, this must be in sequential order from bottom to top for multiz maps. this will be fixed when we rework our multiz stack system.
	var/list/datum/map_level/levels
	/// dependencies by id or path of other maps - these are critical maps to always load in
	var/list/dependencies
	/// lateload by id or path of other maps - these are non-critical maps to always load in
	var/list/lateload
	/// are we loaded in
	var/tmp/loaded = FALSE
	/// are we modified from our prototype?
	var/tmp/modified = FALSE
	/// declared width = must match all levels
	var/width
	/// declared height - must match all levels
	var/height
	/// crop if too big, instead of panic
	var/crop = FALSE
	/// center us if we're smaller than world size
	var/center = TRUE
	/// orientation - defaults to south
	var/orientation = SOUTH
	/// use map-wide area cache instead of individual level area caches; has no effect on submap loading, only level loading.
	/// don't touch this unless you know what you're doing.
	var/bundle_area_cache = TRUE

	//! legacy : spawn these shuttle datums on load
	var/list/legacy_assert_shuttle_datums

/datum/map/New()
	// immediately resolve dependencies / lateload
	for(var/i in 1 to length(dependencies))
		if(ispath(dependencies[i]))
			var/datum/map/resolving = dependencies[i]
			dependencies[i] = initial(resolving.id)
	for(var/i in 1 to length(lateload))
		if(ispath(lateload[i]))
			var/datum/map/resolving = lateload[i]
			lateload[i] = initial(resolving.id)

/datum/map/Destroy()
	if(loaded)
		. = QDEL_HINT_LETMELIVE
		CRASH("UH OH, SOMETHING TRIED TO DELETE AN INSTANTIATED MAP.")
	return ..()

/datum/map/serialize()
	. = ..()
	.["id"] = id
	.["name"] = name
	var/list/serialized_levels = (.["levels"] = list())
	for(var/datum/map_level/level as anything in levels)
		if(!istype(level))
			serialized_levels += level // isn't init'd, probably path or id
			continue
		serialized_levels += json_encode(level.serialize())
	.["dependencies"] = dependencies
	.["lateload"] = lateload
	.["width"] = width
	.["height"] = height
	.["crop"] = crop
	.["center"] = center
	.["orientation"] = orientation
	.["bundle_area_cache"] = bundle_area_cache

/datum/map/deserialize(list/data)
	if(loaded)
		CRASH("attempted deserialize while loaded")
	. = ..()
	id = data["id"]
	name = data["name"]
	levels = list()
	for(var/serialized_level in data["levels"])
		var/is_it_a_path = text2path(serialized_level)
		// path
		if(ispath(is_it_a_path, /datum/map_level))
			levels += is_it_a_path
			continue
		// json
		if(serialized_level[1] == "{")
			var/datum/map_level/level = new
			level.deserialize(json_decode(serialized_level))
			levels += level
			continue
	dependencies = data["dependencies"]
	lateload = data["lateload"]
	width = data["width"]
	height = data["height"]
	if(!isnull(data["crop"]))
		crop = data["crop"]
	if(!isnull(data["center"]))
		center = data["center"]
	if(!isnull(data["orientation"]))
		orientation = data["orientation"]
	if(!isnull(data["bundle_area_cache"]))
		bundle_area_cache = data["bundle_area_cache"]

/**
 * loads any lazyloaded stuff we need; called before we load in
 */
/datum/map/proc/prime()
	for(var/i in 1 to length(levels))
		if(ispath(levels[i]))
			var/datum/map_level/level_path = levels[i]
			levels[i] = new level_path

/**
 * anything to do immediately on load
 *
 * called after level on_loaded_immediate's
 */
/datum/map/proc/on_loaded_immediate()
	return

/**
 * anything to do after loading with any dependencies
 *
 * called after level on_loaded_finalize's
 */
/datum/map/proc/on_loaded_finalize()
	return

/**
 * primary station map
 *
 * this is what's loaded at init. this determines what other maps initially load.
 */
/datum/map/station
	abstract_type = /datum/map/station
	category = "Stations"

	/// force world to be bigger width
	var/world_width
	/// force world to be bigger height
	var/world_height

	//! legacy below

	var/full_name = "Unnamed Map"

	// Automatically populated lists made static for faster lookups
	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/xenoarch_exempt_levels = list()	//Z-levels exempt from xenoarch finds and digsites spawning.
	// End Static Lists

	// Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.
	var/list/map_levels

	// E-mail TLDs to use for NTnet modular computer e-mail addresses
	var/list/usable_email_tlds = list("freemail.nt")

	var/list/allowed_jobs = list()	// Job datums to use.
									// Works a lot better so if we get to a point where three-ish maps are used
									// We don't have to C&P ones that are only common between two of them
									// That doesn't mean we have to include them with the rest of the jobs though, especially for map specific ones.
									// Also including them lets us override already created jobs, letting us keep the datums to a minimum mostly.
									// This is probably a lot longer explanation than it needs to be.

	var/list/holomap_offset_x = list()
	var/list/holomap_offset_y = list()
	var/list/holomap_legend_x = list()
	var/list/holomap_legend_y = list()
	var/list/meteor_strike_areas		 // Areas meteor strikes may choose to hit.

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

	var/list/station_networks = list()		// Camera networks that will show up on the console.
	var/list/secondary_networks = list()	// Camera networks that exist, but don't show on regular camera monitors.

	var/bot_patrolling = TRUE				// Determines if this map supports automated bot patrols

	var/allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")

	// Persistence!
	var/datum/spawnpoint/spawnpoint_died = /datum/spawnpoint/arrivals	// Used if you end the round dead.
	var/datum/spawnpoint/spawnpoint_left = /datum/spawnpoint/arrivals	// Used of you end the round at centcom.
	var/datum/spawnpoint/spawnpoint_stayed = /datum/spawnpoint/cryo		// Used if you end the round on the station.
	/// legacy persistence id
	var/legacy_persistence_id

	var/use_overmap = 0			// If overmap should be used (including overmap space travel override)
	var/overmap_size = 20		// Dimensions of overmap zlevel if overmap is used.
	var/overmap_z = 0			// If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	var/overmap_event_areas = 0	// How many event "clouds" will be generated

	/// list of title cutscreens by path to display. for legacy support, tuples of list(icon, state) work too. associate to % chance, defaulting to 1.
	var/list/titlescreens = list(
		list(
			'icons/misc/title_vr.dmi',
			"title1",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title2",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title3",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title4",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title5",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title6",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title7",
		),
		list(
			'icons/misc/title_vr.dmi',
			"title8",
		),
		list(
			'icons/misc/title_vr.dmi',
			"bnny",
		),
	)

	// var/lobby_icon = 'icons/misc/title.dmi'			// The icon which contains the lobby image(s)
	// var/list/lobby_screens = list("mockingjay00")	// The list of lobby screen to pick() from. If left unset the first icon state is always selected.

	var/default_law_type = /datum/ai_laws/nanotrasen	// The default lawset use by synth units, if not overriden by their laws var.

	// Some maps include areas for that map only and don't exist when not compiled, so Travis needs this to learn of new areas that are specific to a map.
	var/list/unit_test_exempt_areas = list()
	var/list/unit_test_exempt_from_atmos = list()
	var/list/unit_test_exempt_from_apc = list()
	var/list/unit_test_z_levels	// To test more than Z1, set your z-levels to test here.

	var/list/empty_levels

/datum/map/station/New()
	..()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs || !allowed_jobs.len)
		allowed_jobs = subtypesof(/datum/role/job)

// Gets the current time on a current zlevel, and returns a time datum
/datum/map/station/proc/get_zlevel_time(var/z)
	if(!z)
		z = 1
	var/datum/planet/P = z <= SSplanets.z_to_planet.len ? SSplanets.z_to_planet[z] : null
	// We found a planet tied to that zlevel, give them the time
	if(P?.current_time)
		return P.current_time

	// We have to invent a time
	else
		var/datum/time/T = new (station_time_in_ds)
		return T

// Returns a boolean for if it's night or not on a particular zlevel
/datum/map/station/proc/get_night(var/z)
	if(!z)
		z = 1
	var/datum/time/now = get_zlevel_time(z)
	var/percent = now.seconds_stored / now.seconds_in_day //practically all of these are in DS
	testing("get_night is [percent] through the day on [z]")

	// First quarter, last quarter
	if(percent < 0.25 || percent > 0.75)
		return TRUE
	// Second quarter, third quarter
	else
		return FALSE

// Boolean for if we should use SSnightshift night hours
/datum/map/station/proc/get_nightshift()
	return get_night(1) //Defaults to z1, customize however you want on your own maps

/datum/map/station/proc/setup_map()
	return

/datum/map/station/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/station/proc/get_transit_zlevel(current_z_level)
	. = SSmapping.crosslinked_levels() - current_z_level
	return SAFEPICK(.)

/datum/map/station/proc/get_empty_zlevel()
	if(empty_levels == null)
		var/datum/map_level/level = SSmapping.allocate_level()
		empty_levels = list(level.z_index)
		if(islist(player_levels))
			player_levels |= level.z_index
		else
			player_levels = list(level.z_index)
	return pick(empty_levels)

// Get the list of zlevels that a computer on srcz can see maps of (for power/crew monitor, cameras, etc)
// The long_range parameter expands the coverage.  Default is to return map_levels for long range otherwise just srcz.
// zLevels outside station_levels will return an empty list.
/datum/map/station/proc/get_map_levels(var/srcz, var/long_range = TRUE, var/om_range = 0)
	// Overmap behavior
	if(use_overmap)
		var/obj/overmap/entity/visitable/O = get_overmap_sector(srcz)
		if(!istype(O))
			return list(srcz)

		// Just the sector we're in
		if(!long_range || (om_range < 0))
			return O.map_z.Copy()

		// Otherwise every sector we're on top of
		var/list/connections = list()
		var/turf/T = get_turf(O)
		for(var/obj/overmap/entity/visitable/V in range(om_range, T))
			connections |= V.map_z	// Adding list to list adds contents
		return connections

	// Traditional behavior
	else
		if (long_range && (srcz in map_levels))
			return map_levels.Copy()
		else if (srcz in station_levels)
			return station_levels.Copy()
		else
			return list(srcz)

// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
// This list needs to be purged but people insist on adding more cruft to the radio.
/datum/map/station/proc/default_internal_channels()
	return list(
		num2text(PUB_FREQ) = list(),
		num2text(AI_FREQ)  = list(ACCESS_SPECIAL_SILICONS),
		num2text(ENT_FREQ) = list(),
		num2text(ERT_FREQ) = list(ACCESS_CENTCOM_ERT),
		num2text(COMM_FREQ)= list(ACCESS_COMMAND_BRIDGE),
		num2text(ENG_FREQ) = list(ACCESS_ENGINEERING_ENGINE, ACCESS_ENGINEERING_ATMOS),
		num2text(MED_FREQ) = list(ACCESS_MEDICAL_EQUIPMENT),
		num2text(MED_I_FREQ)=list(ACCESS_MEDICAL_EQUIPMENT),
		num2text(SEC_FREQ) = list(ACCESS_SECURITY_EQUIPMENT),
		num2text(SEC_I_FREQ)=list(ACCESS_SECURITY_EQUIPMENT),
		num2text(SCI_FREQ) = list(ACCESS_SCIENCE_FABRICATION,ACCESS_SCIENCE_ROBOTICS,ACCESS_SCIENCE_XENOBIO),
		num2text(SUP_FREQ) = list(ACCESS_SUPPLY_BAY),
		num2text(SRV_FREQ) = list(ACCESS_GENERAL_JANITOR, ACCESS_GENERAL_BOTANY),
		num2text(EXP_FREQ) = list(ACCESS_GENERAL_EXPLORER)
	)

/**
 * standard sector / planet maps
 */
/datum/map/sector
	category = "Sectors"
	abstract_type = /datum/map/sector

/**
 * custom maps
 */
/datum/map/custom
