/datum/announce_location/main_station
	name = "Main Station"
	desc = "Anyone on the main station can hear this."

/datum/announce_location/main_station/get_affected_levels()
	. = list()
	for(var/z in 1 to world.maxz)
		if(SSmapping.level_trait(z, ZTRAIT_STATION))
			. += z

/datum/announce_location/render_proper_possessive_name()
	return "The [using_map_legacy.station_name]'s"
