


/*/datum/shuttle/autodock/multi/ninja
	name = "Ninja"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "ninja_base"
	landmark_transition = "ninja_transit"
	shuttle_area = /area/shuttle/ninja
	destination_tags = list(
		"ninja_base",
		"aerostat_northeast",
		"beach_e",
		"beach_nw",
		"triumph_space_port_3",
		"triumph_space_starboard_3",
		"triumph_space_port_2",
		"triumph_space_starboard_2",
		"triumph_space_port_1",
		"triumph_space_starboard_1"
		)
	docking_controller_tag = "ninja_shuttle"
	announcer = "Automated Traffic Control"
	arrival_message = "Attention. An unregistered vessel is approaching NSV Triumph."
	departure_message = "Attention. A unregistered vessel is now leaving NSV Triumph."

*/

/datum/shuttle/autodock/overmap/ninja
	name = "Ninja Shuttle"
	warmup_time = 0
	current_location = "dojo_dock"
	docking_controller_tag = "ninja_shuttle_docker"
	shuttle_area = list(/area/shuttle/ninja)
	fuel_consumption = 0	//Ninja craft dont need fuel
	defer_initialisation = TRUE

// The 'ship' of the shuttle
/obj/effect/overmap/visitable/ship/landable/ninja
	name = "Unknown Vessel"
	desc = "Scans inconclusive."
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Ninja Shuttle"

/obj/machinery/computer/shuttle_control/explore/ninja
	name = "short jump console"
	shuttle_tag = "Ninja Shuttle"
