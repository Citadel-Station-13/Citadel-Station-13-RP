
#warn impl

/datum/shuttle/autodock/ferry/aerostat
	name = "Aerostat Ferry"
	shuttle_area = /area/shuttle/aerostat
	warmup_time = 10	//want some warmup time so people can cancel.
	landmark_station = "aerostat_east"
	landmark_offsite = "aerostat_surface"
	defer_initialisation = TRUE


/obj/effect/shuttle_landmark/shuttle_initializer/map_specifc/virgo2_ferry
	name = "Virgo 2 Aerostat (E)"

/obj/effect/shuttle_landmark/premade/virgo2_surface
	name = "Virgo 2 Surface"


#warn map
