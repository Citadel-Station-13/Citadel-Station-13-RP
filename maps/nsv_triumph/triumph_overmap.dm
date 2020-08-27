/obj/effect/overmap/visitable/ship/triumph
	name = "NSV Triumph"	// Name of the location on the overmap.
	desc = "The Triumph is one of the many ships that is a part of the NDV Marksmans Fleet in this sector"

	scanner_desc = @{"[i]Registration[/i]: NSV Triumph
[i]Class[/i]: Science Vessel
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Vessel, authorized personnel only"}

	icon_state = "ship"
	vessel_mass = 100000
	burn_delay = 2 SECONDS
	fore_dir = EAST	// Which direction the ship/z-level is facing.  It will move dust particles from that direction when moving.
	base = TRUE		// Honestly unsure what this does but it seems the main sector or "Map" we're at has this so here it stays
	start_x = 4
	start_y = 5
	// The waypoints that are avaliable once you are at this Navpoint
	initial_generic_waypoints = list("nav_capitalship_docking2", "triumph_excursion_hangar", "triumph_space_SW")

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("triumph_excursion_hangar")
		)

// EXCURSION SHUTTLE DATA
/obj/effect/overmap/visitable/ship/landable/excursion
	name = "Excursion Shuttle"
	desc = "A modified Excursion shuttle thats seen in use of the Marksman fleet of NanoTrasen."
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Shuttle"

/datum/shuttle/autodock/overmap/excursion
	name = "Excursion Shuttle"
	warmup_time = 2
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	current_location = "triumph_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	fuel_consumption = 2

/area/shuttle/excursion
	name = "Excursion Shuttle"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	req_one_access = list(access_pilot)


// STATIC PLANET/BASE LOCATIONS

// -- Datums -- //
/obj/effect/overmap/visitable/sector/debrisfield
	name = "Debris Field"
	desc = "Space junk galore."
	icon_state = "dust4"
	color = "#AAAAAA"
	known = FALSE
	start_x = 22
	start_y = 33
	initial_generic_waypoints = list("triumph_excursion_debrisfield")

/obj/effect/overmap/visitable/sector/class_d
	name = "Unidentified Planet"
	desc = "ASdlke ERROR%%%% UNABLE TO----."
	in_space = 0
	start_x = 32
	start_y = 55
	icon_state = "globe"
	color = "#88FF33"

/obj/effect/overmap/visitable/sector/pirate_base
	name = "Vox Pirate Base"
	desc = "A nest of hostiles to the company. Caution is advised."
	in_space = 1
	start_x = 55
	start_y = 3
	known = FALSE
	icon_state = "piratebase"
	color = "#FF3333"

