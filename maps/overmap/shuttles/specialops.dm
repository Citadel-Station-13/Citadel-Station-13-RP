/*
/datum/shuttle/autodock/multi/specialops
	name = "NDV Phantom"
	can_cloak = TRUE
	cloaked = FALSE
	warmup_time = 8
	move_time = 60
	current_location = "specops_base"
	landmark_transition = "specops_transit"
	shuttle_area = /area/shuttle/specialops
	destination_tags = list(
		"specops_base",
		"aerostat_northwest",
		"triumph_space_port_3",
		"triumph_space_starboard_3",
		"triumph_space_port_2",
		"triumph_space_starboard_2",
		"triumph_space_port_1",
		"triumph_space_starboard_1"
		)
	docking_controller_tag = "specops_shuttle_hatch"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An NT support vessel is approaching NSV Triumph."
	departure_message = "Attention. A NT support vessel is now leaving NSV Triumph."

*/

/datum/shuttle/autodock/overmap/specialops2
	name = "NDV Phantom"
	warmup_time = 0
	current_location = "specops_base"
	docking_controller_tag = "ert_docker"
	shuttle_area = list(/area/shuttle/specops/centcom2)
	fuel_consumption = 0
	defer_initialisation = TRUE //We're not loaded until an admin does it (Need to check if this works with other forms of loading like map seeding - Bloop)

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/specialops2
	name = "NDV Phantom"
	desc = "A specialized emergency response vessel"
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Special Oops Shuttle"

/obj/machinery/computer/shuttle_control/explore/specialops2
	name = "short jump console"
	shuttle_tag = "Special Oops Shuttle"

