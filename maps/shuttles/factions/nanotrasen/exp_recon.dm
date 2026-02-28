
#warn impl

/datum/shuttle/autodock/overmap/excursion/endeavour
	name = "Excursion Shuttle"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/excursion/endeavour/cockpit, /area/shuttle/excursion/endeavour/general, /area/shuttle/excursion/endeavour/cargo)
	current_location = "endeavour_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	landmark_transition = "nav_transit_exploration"
	move_time = 20

/area/shuttle/excursion/endeavour
	name = "Endeavour Excursion Shuttle"
	icon_state = "shuttle"

#warn map
#warn this is endev's one btw
