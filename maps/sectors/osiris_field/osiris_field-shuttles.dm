/datum/map_template/shuttle/overmap/osiris/colonial
	name = "Colonial Liner"
	desc = "A luxury liner that got damaged in the osiris incident."
	map_path = "maps/submaps/level_specific/osiris_field/mobilehome.dmm"
	annihilate = TRUE

/datum/map_template/shuttle/overmap/osiris/battlestar
	name = "A mercenary battlecruiser that got damaged in the osiris incident."
	desc = "A small light cargo transport shuttle, struck by... something. Ouch."
	map_path = "maps/submaps/level_specific/osiris_field/warship.dmm"
	annihilate = TRUE

/datum/map_template/shuttle/overmap/osiris/cargoravana
	name = "Spacena Cargoravana Shuttle"
	desc = "A small light cargo transport shuttle that got damaged in the osiris incident."
	map_path = "maps/submaps/level_specific/osiris_field/mobilehome.dmm"
	annihilate = TRUE


//
// Hudge Vessel
//

//Colonial Liner
/datum/shuttle/autodock/overmap/osiris/colonial
	name = "Colonial Liner"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/osiris/colonial)
	docking_controller_tag = "colonial_docker"
	fuel_consumption = 3
	move_time = 10
	current_location = "colonial_start"

/obj/overmap/entity/visitable/ship/landable/osiris/colonial
	name = "Colonial Liner"
	desc = "A Liner made to carry people."
	scanner_name = "Colonial Liner"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Colonial Liner XXIII
[i]Transponder[/i]: Transmitting (CIV), Originialy registered as a Wreck since the Osiris Incident.
[b]Notice[/b]: It was destroyed in August 2568."}
	color = "#4b768f"
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "Colonial Liner"

/obj/machinery/computer/shuttle_control/explore/colonial
	name = "short jump console"
	shuttle_tag = "Colonial Liner"

/area/shuttle/osiris/colonial
	name = "Colonial Liner"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/effect/shuttle_landmark/shuttle_initializer/colonial
	name = "Osiris Debris Field"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "colonial_start"
	shuttle_type = /datum/shuttle/autodock/overmap/osiris/colonial

//Battlestar
/datum/shuttle/autodock/overmap/osiris/battlestar
	name = "Wrecked Mercenary Vessel Andromeda"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/osiris/battlestar)
	docking_controller_tag = "battlestar_docker"
	fuel_consumption = 3
	move_time = 10
	current_location = "battlestar_start"

/obj/overmap/entity/visitable/ship/landable/osiris/battlestar
	name = "Wrecked Mercenary Vessel Andromeda"
	desc = "A damaged military vessel."
	scanner_name = "Wrecked Mercenary Vessel Andromeda"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Andromeda BS2004
[i]Transponder[/i]: Transmitting (CIV), Originialy registered as a Wreck since the Osiris Incident.
[b]Notice[/b]: It was destroyed in August 2568, when responding to a pirate incursion. It was operated by a small merc company, but they went out of business after the incident."}
	color = "#646464"
	fore_dir = WEST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_LARGE
	shuttle = "Wrecked Mercenary Vessel Andromeda"

/obj/machinery/computer/shuttle_control/explore/battlestar
	name = "short jump console"
	shuttle_tag = "Wrecked Mercenary Vessel Andromeda"

/area/shuttle/osiris/battlestar
	name = "Wrecked Mercenary Vessel Andromeda"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/effect/shuttle_landmark/shuttle_initializer/battlestar
	name = "Osiris Debris Field"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "battlestar_start"
	shuttle_type = /datum/shuttle/autodock/overmap/osiris/battlestar

//Cargoravan

/datum/shuttle/autodock/overmap/trade/cargoravana
	name = "Spacena Cargoravana Shuttle"
	warmup_time = 8
	shuttle_area = list(/area/shuttle/cargoravana)
	current_location = "cargoravana_start"
	docking_controller_tag = "tradeport_cargoravana_docker"
	fuel_consumption = 3
	move_time = 10

/obj/overmap/entity/visitable/ship/landable/trade/cargoravana
	name = "Spacena Cargoravana Shuttle"
	desc = "A cheap shuttle made for people wanting to live and work in their shuttle."
	scanner_name = "Spacena Cargoravana Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Spacena Cargoravana Shuttle
[i]Transponder[/i]: Transmitting (CIV)
[b]Notice[/b]: Cargoravana shuttle, a few went missing during the Osiris Incident."}
	color = "#a2c118"
	fore_dir = WEST
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Spacena Cargoravana Shuttle"

/obj/machinery/computer/shuttle_control/explore/cargoravana
	name = "short jump console"
	shuttle_tag = "Spacena Cargoravana Shuttle"

/area/shuttle/cargoravana
	name = "Cargoravana"
	requires_power = 1
	icon_state = "shuttle2"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	area_flags = AREA_RAD_SHIELDED | AREA_FLAG_ERODING
	sound_env = SMALL_ENCLOSED

/obj/effect/shuttle_landmark/shuttle_initializer/cargoravana
	name = "Osiris Debris Field"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "cargoravana_start"
	shuttle_type = /datum/shuttle/autodock/overmap/trade/cargoravana

