

// Map template for spawning the shuttle
/datum/map_template/shuttle/overmap/generic/escapepod
	name = "OM Ship - Escape Pod"
	desc = "An escape pod."
	suffix = "shelter_5.dmm"
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/deployable/escapepod
	name = "\improper Escape Pod"
	icon_state = "shuttle2"
	requires_power = 1

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/escapepod
	name = "short jump console"
	shuttle_tag = "Escape Pod"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/escapepod
	name = "Origin - Escape Pod"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_escapepod"
	shuttle_type = /datum/shuttle/autodock/overmap/escapepod

// The 'shuttle'
/datum/shuttle/autodock/overmap/escapepod
	name = "Escape Pod"
	current_location = "omship_spawn_escapepod"
	docking_controller_tag = "escapepod_shuttle_docker"
	shuttle_area = /area/shuttle/deployable/escapepod
	fuel_consumption = 0
	defer_initialisation = TRUE //We're not loaded until an admin does it

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/escapepod
	scanner_name = "Escape Pod"
	scanner_desc = @{"[i]Registration[/i]: NOT AVAILABLE
[i]Class[/i]: Escape Pod
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Emergency Transponder Active"}
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Escape Pod"
