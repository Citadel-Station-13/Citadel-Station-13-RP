// PIRATE SHIP (Yaya!)
/datum/shuttle/autodock/overmap/pirate
	name = "Pirate Skiff"
	warmup_time = 3
	shuttle_area = list(/area/shuttle/pirate/cockpit, /area/shuttle/pirate/general, /area/shuttle/pirate/cargo)
	current_location = "piratebase_hanger"
	docking_controller_tag = "pirate_docker"
	landmark_transition = "nav_transit_pirate"
	fuel_consumption = 5
	move_time = 10
	defer_initialisation = TRUE

// The 'ship' of the shuttle
/obj/effect/overmap/visitable/ship/landable/pirate
	name = "Unknown Vessel"
	desc = "Scans inconclusive."
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Pirate Skiff"


// Pirate Skiff
/area/shuttle/pirate
	requires_power = TRUE
	name = "\improper Pirate Skiff"
	icon_state = "shuttle1"

/area/shuttle/pirate/general
	name = "\improper Pirate Skiff Shuttle"

/area/shuttle/pirate/cockpit
	name = "\improper Pirate Skiff Shuttle Cockpit"

/area/shuttle/pirate/cargo
	name = "\improper Pirate Skiff Shuttle Cockpit"

/obj/machinery/computer/shuttle_control/explore/pirate
	name = "short jump raiding console"
	shuttle_tag = "Pirate Skiff"

/obj/effect/shuttle_landmark/triumph/pirate
	name = "Pirate Skiff Dock"
	landmark_tag = "piratebase_hanger"
	base_turf = /turf/space
	base_area = /area/space

