
#warn impl

/datum/shuttle/autodock/overmap/mining/endeavour
	name = "Mining Shuttle"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/mining_ship/general)
	current_location = "endeavour_mining_port"
	docking_controller_tag = "mining_docker"
	landmark_transition = "nav_transit_mining"
	move_time = 30

/area/shuttle/mining
	name = "Mining Shuttle"
	icon_state = "shuttle"

#warn map
