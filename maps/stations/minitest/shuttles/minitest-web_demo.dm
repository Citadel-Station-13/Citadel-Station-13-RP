// TODO: web shuttles

DECLARE_STATION_SHUTTLE_TEMPLATE(/minitest, /web_demo)
	id = "minitest-web_demo"

#warn impl + make the map but don't do the web hookup

/area/shuttle/webdemo
	name = "Web-Demo Suttle"
	icon_state = "shuttlered"
	music = "music/escape.ogg"

// /datum/shuttle/autodock/web_shuttle/webdemo
// 	name = "Web-Demo"
// 	warmup_time = 0
// 	shuttle_area = /area/shuttle/webdemo
// 	current_location = "nav_station_inside"
// 	docking_controller_tag = "webdemo_docker"
// 	web_master_type = /datum/shuttle_web_master/webdemo

// /datum/shuttle_web_master/webdemo
// 	destination_class = /datum/shuttle_destination/webdemo
// 	starting_destination = /datum/shuttle_destination/webdemo/inside_bridge

// //
// //   inside_bridge--
// //                 |---nearby_bridge---faraway
// //   docked_bridge--
// //

// /datum/shuttle_destination/webdemo/inside_bridge
// 	name = "inside the Bridge"
// 	my_landmark = "nav_station_inside"
// 	radio_announce = TRUE
// 	announcer = "Shuttle Authority"

// /datum/shuttle_destination/webdemo/inside_bridge/get_arrival_message()
// 	return "Attention, [master.my_shuttle.visible_name] has arrived at the [name]."

// /datum/shuttle_destination/webdemo/inside_bridge/get_departure_message()
// 	return "Attention, [master.my_shuttle.visible_name] has departed from [name]."


// /datum/shuttle_destination/webdemo/docked_bridge
// 	name = "Bridge docking pylon"
// 	my_landmark = "nav_station_docking1"
// 	radio_announce = TRUE
// 	announcer = "Shuttle Authority"

// /datum/shuttle_destination/webdemo/docked_bridge/get_arrival_message()
// 	return "Attention, [master.my_shuttle.visible_name] has arrived at [name]."

// /datum/shuttle_destination/webdemo/docked_bridge/get_departure_message()
// 	return "Attention, [master.my_shuttle.visible_name] has departed from [name]."


/obj/effect/shuttle_landmark/transit/webdemo_transit
// 	name = "Web-Demo Transient Point"
// 	shuttle_landmark_flags = SLANDMARK_FLAG_AUTOSET

// /datum/shuttle_destination/webdemo/nearby_bridge
// 	name = "nearby the Bridge"
// 	my_landmark = "nav_shared_space"
// 	preferred_interim_tag = "nav_webdemo_transit"
// 	routes_to_make = list(
// 		/datum/shuttle_destination/webdemo/inside_bridge = 0,
// 		/datum/shuttle_destination/webdemo/docked_bridge = 0,
// 		/datum/shuttle_destination/webdemo/faraway = 30 SECONDS
// 	)

/obj/effect/shuttle_landmark/webdemo_faraway
// 	name = "\"Deep\" Space"
// 	shuttle_landmark_flags = SLANDMARK_FLAG_AUTOSET

// /datum/shuttle_destination/webdemo/faraway
// 	name = "far away"
// 	my_landmark = "nav_webdemo_faraway"
// 	preferred_interim_tag = "nav_webdemo_transit"
