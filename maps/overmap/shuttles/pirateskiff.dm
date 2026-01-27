// PIRATE SHIP (Yaya!)
/datum/shuttle/autodock/overmap/pirate
	name = "Pirate Skiff"
	warmup_time = 3
	shuttle_area = list(/area/shuttle/pirate/deck, /area/shuttle/pirate/bridge, /area/shuttle/pirate/engine)
	current_location = "pirate_docking_arm"
	docking_controller_tag = "pirate_docker"
	landmark_transition = "nav_transit_pirate"
	fuel_consumption = 5
	move_time = 10
	defer_initialisation = TRUE

// The 'ship' of the shuttle
/obj/overmap/entity/visitable/ship/landable/pirate
	name = "Unknown Vessel"
	desc = "Scans inconclusive."
	color = "#751713" //Dark Red
	fore_dir = WEST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Pirate Skiff"

/obj/effect/shuttle_landmark/shuttle_initializer/pirate
	name = "Pirate Skiff Dock"
	shuttle_type = /datum/shuttle/autodock/overmap/pirate

// Pirate Skiff
/area/shuttle/pirate
	requires_power = TRUE
	name = "\improper Pirate Skiff"
	icon_state = "shuttle"

/area/shuttle/pirate/deck
	name = "\improper Pirate Skiff Deck"

/area/shuttle/pirate/bridge
	name = "\improper Pirate Skiff Bridge"

/area/shuttle/pirate/engine
	name = "\improper Pirate Skiff Engine"
