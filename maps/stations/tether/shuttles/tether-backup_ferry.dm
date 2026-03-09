
#warn impl
/datum/shuttle/autodock/ferry/tether_backup
	name = "Tether Backup"
	location = FERRY_LOCATION_OFFSITE //Offsite is the surface hangar
	warmup_time = 5
	move_time = 45
	landmark_offsite = "tether_backup_low"
	landmark_station = "tether_customs_shuttle"
	landmark_transition = "tether_backup_transit"
	shuttle_area = /area/shuttle/tether
	//crash_areas = list(/area/shuttle/tether/crash1, /area/shuttle/tether/crash2)
	docking_controller_tag = "tether_shuttle"
	move_direction = NORTH
