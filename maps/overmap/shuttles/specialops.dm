// ERT SHIP
//This vessel needs an overmap presence, mostly so we can stop using the shitcode old variant. CentCom will need to become notionally visitable as part of this change.
//Look into figuring out a way to spawn an OM destination adjacent to another - that way CC can always orbit Lythios, instead of being mysteriously across the map out of orbit.
/datum/shuttle/autodock/overmap/specops
	name = "NDV Quicksilver"
	warmup_time = 3
	shuttle_area = list(/area/shuttle/specops/general, /area/shuttle/specops/cockpit, /area/shuttle/specops/engine)
	current_location = "specops_hangar"
	docking_controller_tag = "specops_docker"
	landmark_transition = "nav_transit_specops"
	fuel_consumption = 5
	move_time = 5
	defer_initialisation = TRUE

// The 'ship' of the shuttle
/obj/overmap/entity/visitable/ship/landable/specops
	name = "NDV Quicksilver"
	desc = "A NanoTrasen ST-ERT rapid response vessel."
	fore_dir = EAST
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "NDV Quicksilver"

/obj/effect/shuttle_landmark/shuttle_initializer/specops
	name = "Special Operations Dock"
	landmark_tag = "specops_hangar"
	docking_controller = "specops_hangar_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/centcom/specops/dock
	shuttle_type = /datum/shuttle/autodock/overmap/specops

/obj/machinery/computer/shuttle_control/explore/specops
	name = "special operations short jump console"
	shuttle_tag = "NDV Quicksilver"

// Spec Ops Areas
/area/shuttle/specops
	area_power_override = null
	name = "\improper NDV Quicksilver"
	icon_state = "shuttle1"

/area/shuttle/specops/general
	name = "\improper NDV Quicksilver Deck"

/area/shuttle/specops/cockpit
	name = "\improper NDV Quicksilver Cockpit"

/area/shuttle/specops/engine
	name = "\improper NDV Quicksilver Engine"


//So this ship is the prior specops stuff. It was never used/implemented, and it's just a direct rip of the Beruang. I can do better.
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

/datum/shuttle/autodock/overmap/specialops2
	name = "NDV Phantom"
	warmup_time = 0
	current_location = "specops_base"
	docking_controller_tag = "ert_docker"
	shuttle_area = list(/area/shuttle/specops/centcom2)
	fuel_consumption = 0
	defer_initialisation = TRUE //We're not loaded until an admin does it (Need to check if this works with other forms of loading like map seeding - Bloop)

// The 'ship' of the excursion shuttle
/obj/overmap/entity/visitable/ship/landable/specialops2
	name = "NDV Phantom"
	desc = "A specialized emergency response vessel"
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Special Oops Shuttle"

/obj/machinery/computer/shuttle_control/explore/specialops2
	name = "short jump console"
	shuttle_tag = "Special Oops Shuttle"
*/
