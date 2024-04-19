//
// Overmap Shuttle Demo
//

/area/shuttle/overmapdemo
	name = "Overmap-Demo Suttle"
	music = "music/escape.ogg"
	icon_state = "shuttle"

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

//
// Ferry Demo Shuttle
//

/datum/shuttle/autodock/ferry/ferrydemo
	name = "Ferry-Demo"
	warmup_time = 0
	shuttle_area = /area/shuttle/ferrydemo
	docking_controller_tag = "ferrydemo_shuttle"
	landmark_station = "nav_station_docking1"
	landmark_offsite = "nav_ferrydemo_space"

/area/shuttle/ferrydemo
	name = "Ferry-Demo Suttle"
	music = "music/escape.ogg"
	icon_state = "shuttle"

/obj/effect/shuttle_landmark/ferrydemo_space
	name = "Ferry-Demo Space Hover Point"
	shuttle_landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/transit/ferrydemo_transit
	name = "Ferry-Demo Transient Point"
	shuttle_landmark_flags = SLANDMARK_FLAG_AUTOSET

//
// MULTI DEMO SHUTTLE
//

/datum/shuttle/autodock/multi/multidemo
	name = "Multi-Demo"
	warmup_time = 0
	shuttle_area = /area/shuttle/multidemo
	docking_controller_tag = "multidemo_shuttle"
	current_location = "nav_multidemo_start"
	destination_tags = list("nav_station_docking2", "nav_shared_space", "nav_station_docking1", "nav_multidemo_nearby")
	can_cloak = TRUE

/area/shuttle/multidemo
	name = "Multi-Demo Suttle"
	music = "music/escape.ogg"
	icon_state = "shuttlegrn"

/obj/effect/shuttle_landmark/multidemo_start
	name = "Multi-Demo Starting Point"

/obj/effect/shuttle_landmark/multidemo_nearby
	name = "Multi-Demo Nearby"
	shuttle_landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/transit/multidemo_transit
	name = "Multi-Demo Transient Point"
	shuttle_landmark_flags = SLANDMARK_FLAG_AUTOSET


//
// WEB DEMO SHUTTLE
//

/area/shuttle/webdemo
	name = "Web-Demo Suttle"
	icon_state = "shuttlered"
	music = "music/escape.ogg"

/datum/shuttle/autodock/web_shuttle/webdemo
	name = "Web-Demo"
	warmup_time = 0
	shuttle_area = /area/shuttle/webdemo
	current_location = "nav_station_inside"
	docking_controller_tag = "webdemo_docker"
	web_master_type = /datum/shuttle_web_master/webdemo

/datum/shuttle_web_master/webdemo
	destination_class = /datum/shuttle_destination/webdemo
	starting_destination = /datum/shuttle_destination/webdemo/inside_bridge

//
//   inside_bridge--
//                 |---nearby_bridge---faraway
//   docked_bridge--
//

/datum/shuttle_destination/webdemo/inside_bridge
	name = "inside the Bridge"
	my_landmark = "nav_station_inside"
	radio_announce = TRUE
	announcer = "Shuttle Authority"

/datum/shuttle_destination/webdemo/inside_bridge/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at the [name]."

/datum/shuttle_destination/webdemo/inside_bridge/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from [name]."


/datum/shuttle_destination/webdemo/docked_bridge
	name = "Bridge docking pylon"
	my_landmark = "nav_station_docking1"
	radio_announce = TRUE
	announcer = "Shuttle Authority"

/datum/shuttle_destination/webdemo/docked_bridge/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at [name]."

/datum/shuttle_destination/webdemo/docked_bridge/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from [name]."


/obj/effect/shuttle_landmark/transit/webdemo_transit
	name = "Web-Demo Transient Point"
	shuttle_landmark_flags = SLANDMARK_FLAG_AUTOSET

/datum/shuttle_destination/webdemo/nearby_bridge
	name = "nearby the Bridge"
	my_landmark = "nav_shared_space"
	preferred_interim_tag = "nav_webdemo_transit"
	routes_to_make = list(
		/datum/shuttle_destination/webdemo/inside_bridge = 0,
		/datum/shuttle_destination/webdemo/docked_bridge = 0,
		/datum/shuttle_destination/webdemo/faraway = 30 SECONDS
	)

/obj/effect/shuttle_landmark/webdemo_faraway
	name = "\"Deep\" Space"
	shuttle_landmark_flags = SLANDMARK_FLAG_AUTOSET

/datum/shuttle_destination/webdemo/faraway
	name = "far away"
	my_landmark = "nav_webdemo_faraway"
	preferred_interim_tag = "nav_webdemo_transit"
