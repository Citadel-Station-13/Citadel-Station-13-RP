/// Temporarilly adding this in here so if someone tick's tether's dm file virgo 2's shuttle will still function. Eventually just need to have virgo 2 on both triumph and tether
/// but this is a temporary fix to get triumph working. - Bloop
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
