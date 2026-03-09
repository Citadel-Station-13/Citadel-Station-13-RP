
#warn impl
/area/shuttle/overmapdemo
	name = "Overmap-Demo Suttle"
	music = "music/escape.ogg"
	icon_state = "shuttle"

/area/shuttle/overmapdemo
	name = "Overmap-Demo Suttle"
	music = "music/escape.ogg"
	icon_state = "shuttle"

/obj/overmap/entity/visitable/ship/landable/overmapdemo
	name = "VSS Overmap Demo"
	desc = "Small little shuttle nonetheless capable of overmap travel!"
	vessel_mass = 5000
	shuttle = "Overmap-Demo"

/datum/shuttle/autodock/overmap/overmapdemo
	name = "Overmap-Demo"
	warmup_time = 0
	shuttle_area = /area/shuttle/overmapdemo
	current_location = "nav_station_docking2"
	docking_controller_tag = "overmapdemo_docker"
	fuel_consumption = 0	// Override to infinate fuel for now.


/datum/shuttle/autodock/overmap/overmapdemo
	name = "Overmap-Demo"
	warmup_time = 0
	shuttle_area = /area/shuttle/overmapdemo
	current_location = "nav_station_docking2"
	docking_controller_tag = "overmapdemo_docker"
	fuel_consumption = 0	// Override to infinate fuel for now.

/*
** Shared Landmark Defs
*/

// Shared landmark for docking at the station
/obj/effect/shuttle_landmark/station_dockpoint1
	name = "Station Docking Point 1"

/obj/effect/shuttle_landmark/station_dockpoint2
	name = "Station Docking Point 2"

// Shared landmark for docking *inside* the station
/obj/effect/shuttle_landmark/station_inside
	name = "Internal Hangar"

/obj/effect/shuttle_landmark/shared_space
	name = "Somewhere In Space"
