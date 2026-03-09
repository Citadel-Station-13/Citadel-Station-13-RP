
#warn impl

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
