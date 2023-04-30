// TODO: Convert to /obj/abstract/map_data @Zandario
/obj/landmark/map_data
	name = "Map Data"
	desc = "An unknown location."

	/// The number of Z-Levels in the map.
	var/height = 1
	/// What the map edge should be formed with. (null = world.turf)
	var/turf/edge_type

	/// An associate list of door types/list of allowed turfs.
	VAR_PROTECTED/UT_turf_exceptions_by_door_type

#ifdef UNIT_TEST
/// Do not use this in production; for unit tests ONLY.
/obj/landmark/map_data/proc/get_UT_turf_exceptions_by_door_type()
	return UT_turf_exceptions_by_door_type
#else
/obj/landmark/map_data/proc/get_UT_turf_exceptions_by_door_type()
	CRASH("map_data.get_UT_turf_exceptions_by_door_type() called in production code!")
#endif

// If the height is more than 1, we mark all contained levels as connected.
// This is in New because it is an auxiliary effect specifically needed pre-init.
/obj/landmark/map_data/New(turf/loc, _height)
	..()
	if(!istype(loc)) // Using loc.z is safer when using the maploader and New.
		return
	if(_height)
		height = _height
	for(var/i = (loc.z - height + 1) to (loc.z-1))
		if (z_levels.len <i)
			z_levels.len = i
		z_levels[i] = src

	if (length(SSzmimic.zlev_maximums))
		SSzmimic.calculate_zstack_limits()

/obj/landmark/map_data/Destroy(forced)
	if(forced)
		new type(loc, height) // Will replace our references in z_levels
		return ..()
	return QDEL_HINT_LETMELIVE
