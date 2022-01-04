// Skipjack
/*
/datum/shuttle/autodock/multi/heist
	name = "Skipjack"
	warmup_time = 8
	move_time = 60
	can_cloak = TRUE
	cloaked = TRUE
	current_location = "skipjack_base"
	landmark_transition = "skipjack_transit"
	shuttle_area = /area/shuttle/skipjack
	destination_tags = list(
		"piratebase_hanger",
		"skipjack_base",
		"aerostat_south",
		"beach_e",
		"beach_nw",
		"triumph_space_port_3",
		"triumph_space_starboard_3",
		"triumph_space_port_2",
		"triumph_space_starboard_2",
		"triumph_space_port_1",
		"triumph_space_starboard_1"
		)
*/

/datum/shuttle/autodock/overmap/skipjack
	name = "Skipjack Shuttle"
	warmup_time = 0
	current_location = "skipjack_base"
	docking_controller_tag = "skipjack_docker"
	shuttle_area = list(/area/shuttle/skipjack)
	fuel_consumption = 0
	defer_initialisation = TRUE

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/skipjack
	name = "Unknown Vessel"
	desc = "Scans inconclusive."
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Skipjack Shuttle"

/obj/machinery/computer/shuttle_control/explore/skipjack
	name = "short jump console"
	shuttle_tag = "Skipjack Shuttle"

