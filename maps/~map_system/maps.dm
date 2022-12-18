/datum/map
	var/list/holomap_smoosh		// List of lists of zlevels to smoosh into single icons
	var/list/holomap_offset_x = list()
	var/list/holomap_offset_y = list()
	var/list/holomap_legend_x = list()
	var/list/holomap_legend_y = list()

// Gets the current time on a current zlevel, and returns a time datum
/datum/map/proc/get_zlevel_time(var/z)
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
/datum/map/proc/get_night(var/z)
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
/datum/map/proc/get_nightshift()
	return get_night(1) //Defaults to z1, customize however you want on your own maps

// Get the list of zlevels that a computer on srcz can see maps of (for power/crew monitor, cameras, etc)
// The long_range parameter expands the coverage.  Default is to return map_levels for long range otherwise just srcz.
// zLevels outside station_levels will return an empty list.
/datum/map/proc/get_map_levels(var/srcz, var/long_range = TRUE, var/om_range = 0)
	// Overmap behavior
	if(use_overmap)
		var/obj/effect/overmap/visitable/O = get_overmap_sector(srcz)
		if(!istype(O))
			return list(srcz)

		// Just the sector we're in
		if(!long_range || (om_range < 0))
			return O.map_z.Copy()

		// Otherwise every sector we're on top of
		var/list/connections = list()
		var/turf/T = get_turf(O)
		for(var/obj/effect/overmap/visitable/V in range(om_range, T))
			connections |= V.map_z	// Adding list to list adds contents
		return connections

	// Traditional behavior
	else
		if (long_range && (srcz in map_levels))
			return map_levels
		else if (srcz in station_levels)
			return list(srcz)
		else
			return list(srcz)

/datum/map/proc/get_zlevel_name(var/index)
	var/datum/map_z_level/Z = zlevels["[index]"]
	return Z?.name

// Another way to setup the map datum that can be convenient.  Just declare all your zlevels as subtypes of a common
// 	subtype of /datum/map_z_level and set zlevel_datum_type on /datum/map to have the lists auto-initialized.

// Structure to hold zlevel info together in one nice convenient package.
/datum/map_z_level
	var/z = 0				// Actual z-index of the zlevel. This had better be right!
	var/name				// Friendly name of the zlevel
	var/flags = 0			// Bitflag of which *_levels lists this z should be put into.
	var/turf/base_turf = /turf/space // Type path of the base turf for this z
	var/transit_chance = 0	// Percentile chance this z will be chosen for map-edge space transit.

// Holomaps
	var/holomap_offset_x = -1	// Number of pixels to offset the map right (for centering) for this z
	var/holomap_offset_y = -1	// Number of pixels to offset the map up (for centering) for this z
	var/holomap_legend_x = 96	// x position of the holomap legend for this z
	var/holomap_legend_y = 96	// y position of the holomap legend for this z

// Default constructor applies itself to the parent map datum
/datum/map_z_level/New(var/datum/map/map, _z)
	if(_z)
		src.z = _z
	if(!z)
		return
	map.zlevels["[z]"] = src
	if(flags & MAP_LEVEL_STATION) map.station_levels |= z
	if(flags & MAP_LEVEL_ADMIN) map.admin_levels |= z
	if(flags & MAP_LEVEL_CONTACT) map.contact_levels |= z
	if(flags & MAP_LEVEL_PLAYER) map.player_levels |= z
	if(flags & MAP_LEVEL_SEALED) map.sealed_levels |= z
	if(flags & MAP_LEVEL_XENOARCH_EXEMPT) map.xenoarch_exempt_levels |= z
	if(flags & MAP_LEVEL_EMPTY)
		if(!map.empty_levels) map.empty_levels = list()
		map.empty_levels |= z
	if(flags & MAP_LEVEL_CONSOLES)
		if (!map.map_levels)
			map.map_levels = list()
		map.map_levels |= z
	if(base_turf)
		map.base_turf_by_z["[z]"] = base_turf
	if(transit_chance)
		map.accessible_z_levels["[z]"] = transit_chance
	// Holomaps
	// Auto-center the map if needed (Guess based on maxx/maxy)
	if (holomap_offset_x < 0)
		holomap_offset_x = ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
	if (holomap_offset_x < 0)
		holomap_offset_y = ((HOLOMAP_ICON_SIZE - world.maxy) / 2)
	// Assign them to the map lists
	LIST_NUMERIC_SET(map.holomap_offset_x, z, holomap_offset_x)
	LIST_NUMERIC_SET(map.holomap_offset_y, z, holomap_offset_y)
	LIST_NUMERIC_SET(map.holomap_legend_x, z, holomap_legend_x)
	LIST_NUMERIC_SET(map.holomap_legend_y, z, holomap_legend_y)

/datum/map_z_level/Destroy(var/force)
	stack_trace("Attempt to delete a map_z_level instance [log_info_line(src)]")
	if(!force)
		return QDEL_HINT_LETMELIVE // No.
	if (using_map_legacy().zlevels["[z]"] == src)
		using_map_legacy().zlevels -= "[z]"
	return ..()
