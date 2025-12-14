//*****  HEY! LISTEN! *****//
//* This file is mostly old code. It is **not** allowed to blindly copypaste these into the main map system.
//* TODO's have been left to annotate what to do with the variables.

/datum/map/station
	//! legacy below

	var/full_name = "Unnamed Map"

	// TODO: these should all use traits
	// Automatically populated lists made static for faster lookups
	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	// End Static Lists
	// Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.
	var/list/map_levels

	// TODO: use world location instead or a station prefix
	// E-mail TLDs to use for NTnet modular computer e-mail addresses
	var/list/usable_email_tlds = list("freemail.nt")

	// TODO: we don't want a flat list only, maybe
	var/list/allowed_jobs = list()	// Job datums to use.
									// Works a lot better so if we get to a point where three-ish maps are used
									// We don't have to C&P ones that are only common between two of them
									// That doesn't mean we have to include them with the rest of the jobs though, especially for map specific ones.
									// Also including them lets us override already created jobs, letting us keep the datums to a minimum mostly.
									// This is probably a lot longer explanation than it needs to be.

	// TODO: re-evaluate holomap
	var/list/holomap_offset_x = list()
	var/list/holomap_offset_y = list()
	var/list/holomap_legend_x = list()
	var/list/holomap_legend_y = list()

	// TODO: re-evaluate meteor strike
	var/list/meteor_strike_areas		 // Areas meteor strikes may choose to hit.

	// TODO: these should maybe all be structs (world location takes some of them other like command maps are different)
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

	// TODO: eventually, camera networks will be dynamic
	var/list/station_networks = list()		// Camera networks that will show up on the console.
	var/list/secondary_networks = list()	// Camera networks that exist, but don't show on regular camera monitors.

	// TODO: this should be dynamic
	var/bot_patrolling = TRUE				// Determines if this map supports automated bot patrols

	// TODO: this should use new spawnpoint system
	var/allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")

	// Persistence!
	// TODO: get rid of this, no more persisting spawnpoints until characters v2
	var/datum/spawnpoint/spawnpoint_died = /datum/spawnpoint/arrivals	// Used if you end the round dead.
	var/datum/spawnpoint/spawnpoint_left = /datum/spawnpoint/arrivals	// Used of you end the round at centcom.
	var/datum/spawnpoint/spawnpoint_stayed = /datum/spawnpoint/cryo		// Used if you end the round on the station.

	// TODO: should be a datum or something
	var/use_overmap = 0			// If overmap should be used (including overmap space travel override)
	var/overmap_size = 20		// Dimensions of overmap zlevel if overmap is used.
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

	var/default_law_type = /datum/ai_laws/nanotrasen	// The default lawset use by synth units, if not overriden by their laws var.

	// TODO: new map unit test system
	// Some maps include areas for that map only and don't exist when not compiled, so Travis needs this to learn of new areas that are specific to a map.
	var/list/unit_test_exempt_areas = list()
	var/list/unit_test_exempt_from_atmos = list()
	var/list/unit_test_exempt_from_apc = list()
	var/list/unit_test_z_levels	// To test more than Z1, set your z-levels to test here.

/datum/map/station/New()
	..()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs || !allowed_jobs.len)
		allowed_jobs = subtypesof(/datum/prototype/role/job)

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
			return O.location?.get_z_indices() || list()

		// Otherwise every sector we're on top of
		var/list/connections = list()
		for(var/obj/overmap/entity/visitable/V in bounds(O, om_range))
			var/list/levels = V.location?.get_z_indices()
			if(levels)
				connections |= levels
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
		num2text(FREQ_COMMON) = list(),
		num2text(FREQ_AI_PRIVATE)  = list(ACCESS_SPECIAL_SILICONS),
		num2text(FREQ_ENTERTAINMENT) = list(),
		num2text(FREQ_ERT) = list(ACCESS_CENTCOM_ERT),
		num2text(FREQ_COMMAND)= list(ACCESS_COMMAND_BRIDGE),
		num2text(FREQ_ENGINEERING) = list(ACCESS_ENGINEERING_ENGINE, ACCESS_ENGINEERING_ATMOS),
		num2text(FREQ_MEDICAL) = list(ACCESS_MEDICAL_EQUIPMENT),
		num2text(FREQ_MEDICAL_INTERNAL)=list(ACCESS_MEDICAL_EQUIPMENT),
		num2text(FREQ_SECURITY) = list(ACCESS_SECURITY_EQUIPMENT),
		num2text(FREQ_SECURITY_INTERNAL)=list(ACCESS_SECURITY_EQUIPMENT),
		num2text(FREQ_SCIENCE) = list(ACCESS_SCIENCE_FABRICATION,ACCESS_SCIENCE_ROBOTICS,ACCESS_SCIENCE_XENOBIO),
		num2text(FREQ_SUPPLY) = list(ACCESS_SUPPLY_BAY),
		num2text(FREQ_SERVICE) = list(ACCESS_GENERAL_JANITOR, ACCESS_GENERAL_BOTANY),
		num2text(FREQ_EXPLORER) = list(ACCESS_GENERAL_EXPLORER)
	)
