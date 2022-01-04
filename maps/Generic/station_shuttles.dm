//// Mostly just going to stick some station specific shuttle obj's here for no so maps can compile. Eventually want to move most of station's shuttles here - Bloop
////
////////////////////////////////////////
////////      Tour Bus     /////////////
////////////////////////////////////////
// Keeping shuttle datums here in comment form just for reference - Bloop
/*
/datum/shuttle/autodock/overmap/tourbus
	name = "Tour Bus"
	warmup_time = 0
	current_location = "tourbus_dock"
	docking_controller_tag = "tourbus_docker"
	shuttle_area = list(/area/shuttle/tourbus/cockpit, /area/shuttle/tourbus/general)
	fuel_consumption = 1
	move_direction = NORTH
*/
// The 'ship' of the excursion shuttle // I find it really funny that every shuttle has this line because we've all just copy pasted from the origional lol - Bloop
/obj/effect/overmap/visitable/ship/landable/tourbus
	name = "Tour Bus"
	desc = "A small 'space bus', if you will."
	vessel_mass = 2000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Tour Bus"

/obj/machinery/computer/shuttle_control/explore/tourbus
	name = "short jump console"
	shuttle_tag = "Tour Bus"
	req_one_access = list(access_pilot)


////////////////////////////////////////
////////      Securiship   /////////////
////////////////////////////////////////
/*
/datum/shuttle/autodock/overmap/securiship
	name = "Securiship Shuttle"
	warmup_time = 0
	current_location = "tether_securiship_dock"
	docking_controller_tag = "securiship_docker"
	shuttle_area = list(/area/shuttle/securiship/cockpit, /area/shuttle/securiship/general, /area/shuttle/securiship/engines)
	fuel_consumption = 2
	move_direction = NORTH
*/

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/securiship
	name = "Securiship Shuttle"
	desc = "A security transport ship."
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Securiship Shuttle"
	fore_dir = EAST

/obj/machinery/computer/shuttle_control/explore/securiship
	name = "short jump console"
	shuttle_tag = "Securiship Shuttle"

////////////////////////////////////////
////////      Medivac      /////////////
////////////////////////////////////////
/*
/datum/shuttle/autodock/overmap/medivac
	name = "Medivac Shuttle"
	warmup_time = 0
	current_location = "tether_medivac_dock"
	docking_controller_tag = "medivac_docker"
	shuttle_area = list(/area/shuttle/medivac/cockpit, /area/shuttle/medivac/general, /area/shuttle/medivac/engines)
	fuel_consumption = 2
	move_direction = EAST
*/

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/medivac
	name = "Medivac Shuttle"
	desc = "A medical evacuation shuttle."
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Medivac Shuttle"
	fore_dir = EAST

/obj/machinery/computer/shuttle_control/explore/medivac
	name = "short jump console"
	shuttle_tag = "Medivac Shuttle"


/////////////////////////////
///Tether specific Shuttles
/obj/machinery/computer/shuttle_control/tether_backup
	name = "tether backup shuttle control console"
	shuttle_tag = "Tether Backup"
	req_one_access = list(access_heads,access_pilot)

/obj/machinery/computer/shuttle_control/surface_mining_outpost
	name = "surface mining outpost shuttle control console"
	shuttle_tag = "Mining Outpost"
	req_one_access = list(access_mining)

//////////////////////

