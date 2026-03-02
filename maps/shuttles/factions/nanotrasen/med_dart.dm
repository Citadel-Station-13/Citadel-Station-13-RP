
#warn impl

/datum/shuttle/autodock/overmap/emt/endeavour
	name = "Dart EMT Shuttle"
	warmup_time = 5
	shuttle_area = list(/area/shuttle/emt/general, /area/shuttle/emt/cockpit)
	current_location = "endeavour_emt_dock"
	docking_controller_tag = "emt_shuttle_docker"
	landmark_transition = "nav_transit_emt"
	move_time = 20

/obj/overmap/entity/visitable/ship/landable/emt
	name = "Dart EMT Shuttle"
	desc = "The budget didn't allow for flashing lights."
	color = "#69b9de" //Light Blue
	fore_dir = NORTH
	vessel_mass = 9000
	shuttle = "Dart EMT Shuttle"

/area/shuttle/emt
	name = "Dart EMT Shuttle"
	icon_state = "shuttle"

#warn map
