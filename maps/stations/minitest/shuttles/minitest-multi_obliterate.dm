
#warn obliterate
// /datum/shuttle/autodock/multi/multidemo
// 	name = "Multi-Demo"
// 	warmup_time = 0
// 	shuttle_area = /area/shuttle/multidemo
// 	docking_controller_tag = "multidemo_shuttle"
// 	current_location = "nav_multidemo_start"
// 	destination_tags = list("nav_station_docking2", "nav_shared_space", "nav_station_docking1", "nav_multidemo_nearby")
// 	can_cloak = TRUE

/area/shuttle/multidemo
	name = "Multi-Demo Suttle"
	music = "music/escape.ogg"
	icon_state = "shuttlegrn"

/obj/effect/shuttle_landmark/multidemo_start
	name = "Multi-Demo Starting Point"
/obj/effect/shuttle_landmark/multidemo_nearby
	name = "Multi-Demo Nearby"
/obj/effect/shuttle_landmark/transit/multidemo_transit
	name = "Multi-Demo Transient Point"
