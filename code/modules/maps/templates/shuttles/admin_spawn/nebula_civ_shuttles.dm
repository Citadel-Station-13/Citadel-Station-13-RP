// Teshari Runabout
/datum/map_template/shuttle/overmap/generic/teshari_runabout_b
	name = "Teshari Runabout class B"
	desc = "A small Teshari spacecraft."
	suffix = "teshari_runabout.dmm"
	annihilate = TRUE

// Caravan
/datum/map_template/shuttle/overmap/generic/caravan_b
	name = "Caravan"
	desc = "A small cheap space home."
	suffix = "caravan.dmm"
	annihilate = TRUE

// The shuttle's area(s) Teshari
/area/shuttle/teshari_runabout_b
	name = "\improper Teshari Runabout B"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "gray"
	requires_power = 1
	has_gravity = 1

// The shuttle's area(s) Caravan
/area/shuttle/caravan_b
	name = "\improper Caravan B"
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "yellow"
	requires_power = 1
	has_gravity = 1

// The shuttle's 'shuttle' computer TESHARI RUNABOUT
/obj/machinery/computer/shuttle_control/explore/teshari_runabout_b
	name = "short jump console"
	shuttle_tag = "Teshari Runabout B"
	req_one_access = list()

// The shuttle's 'shuttle' computer CARAVAN
/obj/machinery/computer/shuttle_control/explore/caravan_b
	name = "short jump console"
	shuttle_tag = "Spacena Caravan +"
	req_one_access = list()

//TESHARI RUNABOUT

// The 'shuttle'
/datum/shuttle/autodock/overmap/teshari_runabout_b
	name = "Teshari Runabout B"
	current_location = "omship_spawn_teshari"
	docking_controller_tag = "teshari_b_docking"
	shuttle_area = list(/area/shuttle/teshari_runabout_b)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 5
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/teshari_runabout_b
	name = "Teshari Runabout B"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_teshari"
	shuttle_type = /datum/shuttle/autodock/overmap/teshari_runabout_b

// The 'ship'
/obj/overmap/entity/visitable/ship/landable/teshari_runabout_b
	scanner_name = "Teshari Runabout Shuttle"
	scanner_desc = @{"[i]Registration[/i]: - - -
[i]Class[/i]: Teshari Runabout
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Old Teshari shuttle, still in use."}
	color = "#0096aa"
	vessel_mass = 4500
	vessel_size = SHIP_SIZE_LARGE
	fore_dir = WEST
	shuttle = "Teshari Runabout B"

// CARAVAN SHUTTLE

// The 'shuttle'
/datum/shuttle/autodock/overmap/caravan_b
	name = "Spacena Caravan B"
	current_location = "omship_spawn_caravan"
	docking_controller_tag = "caravan_b_docking"
	shuttle_area = list(/area/shuttle/caravan_b)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	fuel_consumption = 5
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/caravan_b
	name = "Spacena Caravan B"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_carvan"
	shuttle_type = /datum/shuttle/autodock/overmap/caravan_b

// The 'ship'
/obj/overmap/entity/visitable/ship/landable/caravan_b
	scanner_name = "Spacena Caravan B"
	scanner_desc = @{"[i]Registration[/i]: - - -
[i]Class[/i]: Spacena Caravan + Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Comfy and cheap shuttle"}
	color = "#fecb74"
	vessel_mass = 4500
	vessel_size = SHIP_SIZE_LARGE
	fore_dir = WEST
	shuttle = "Spacena Caravan B"
