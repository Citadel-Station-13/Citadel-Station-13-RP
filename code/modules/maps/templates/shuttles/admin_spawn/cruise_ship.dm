// Map template for spawning the shuttle
/datum/map_template/shuttle/overmap/generic/cruise_ship
	name = "OM Ship - Cruise Shuttle"
	desc = "A luxury cruise shuttle. Sometimes used by diplomats for speedy transit."
	suffix = "cruise_ship.dmm"
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/cruise_ship
	name = "\improper Cruise Shuttle"
	icon_state = "blue-red2"
	area_flags = AREA_RAD_SHIELDED
	requires_power = 1

/area/shuttle/cruise_ship/bedroom
	name = "\improper Cruise Shuttle - Private Quarters"
	icon_state = "blue-red2"

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/cruise_ship
	name = "short jump console"
	shuttle_tag = "UKN Aerondight"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/cruise_ship
	name = "Origin - Cruise Shuttle"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_aerondight"
	shuttle_type = /datum/shuttle/autodock/overmap/cruise_ship

// The 'shuttle'
/datum/shuttle/autodock/overmap/cruise_ship
	name = "UKN Aerondight"
	current_location = "omship_spawn_aerondight"
	docking_controller_tag = "aerondight_docker"
	shuttle_area = /area/shuttle/cruise_ship
	fuel_consumption = 0
	defer_initialisation = TRUE //We're not loaded until an admin does it

// The 'ship'
/obj/effect/overmap/visitable/ship/landable/cruise_ship
	scanner_name = "UKN Aerondight"
	scanner_desc = @{"[i]Registration[/i]: UNKNOWN
[i]Class[/i]: Pleasure Yacht
[i]Transponder[/i]: Transmitting (CIV), UNKNOWN
[b]Notice[/b]: Diplomatic vessel"}
	color = "#b4a90a" //Indigo
	vessel_mass = 3000
	fore_dir = WEST
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "UKN Aerondight"
