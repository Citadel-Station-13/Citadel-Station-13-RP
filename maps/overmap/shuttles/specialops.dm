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
	desc = "A Nanotrasen ST-ERT rapid response vessel."
	fore_dir = EAST
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "NDV Quicksilver"

/obj/effect/shuttle_landmark/shuttle_initializer/specops
	name = "Special Operations Dock"
	shuttle_type = /datum/shuttle/autodock/overmap/specops

// Spec Ops Areas
/area/shuttle/specops
	requires_power = TRUE
	name = "\improper NDV Quicksilver"
	icon_state = "shuttle"

/area/shuttle/specops/general
	name = "\improper NDV Quicksilver Deck"

/area/shuttle/specops/cockpit
	name = "\improper NDV Quicksilver Cockpit"

/area/shuttle/specops/engine
	name = "\improper NDV Quicksilver Engine"
