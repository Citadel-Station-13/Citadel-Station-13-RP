////////////////////////////////////////
// Strela custom shuttle implemnetations
////////////////////////////////////////

/obj/machinery/computer/shuttle_control/strelka_backup
	name = "strelka backup shuttle control console"
	shuttle_tag = "Strelka Backup"
	req_one_access = list(ACCESS_COMMAND_BRIDGE,ACCESS_GENERAL_PILOT)

/obj/machinery/computer/shuttle_control/multi/mercenary
	name = "vessel control console"
	shuttle_tag = "Mercenary"
	req_one_access = list(ACCESS_FACTION_SYNDICATE)

/obj/machinery/computer/shuttle_control/multi/ninja
	name = "vessel control console"
	shuttle_tag = "Ninja"
	//req_one_access = list()

/obj/machinery/computer/shuttle_control/multi/skipjack
	name = "vessel control console"
	shuttle_tag = "Skipjack"
	//req_one_access = list()

/obj/machinery/computer/shuttle_control/multi/specops
	name = "vessel control console"
	shuttle_tag = "NDV Phantom"
	req_one_access = list(ACCESS_CENTCOM_ERT)

/obj/machinery/computer/shuttle_control/multi/trade
	name = "vessel control console"
	shuttle_tag = "Trade"
	req_one_access = list(ACCESS_FACTION_TRADER)

// EXCURSION SHUTTLE DATA

/datum/shuttle/autodock/overmap/excursion/strelka
	name = "Excursion Javelot Shuttle"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/excursion/strelka)
	current_location = "strelka_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	move_time = 15

/area/shuttle/excursion/strelka
	name = "Excursion Javelot Shuttle"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/excursion/cockpit
	name = "Excursion Javelot Shuttle Cockpit"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/excursion/general
	name = "Excursion Javelot Shuttle"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion/strelka
	name = "short jump console"
	shuttle_tag = "Excursion Javelot Shuttle"

/obj/overmap/entity/visitable/ship/landable/excursion/strelka
	name = "Excursion Javelot Shuttle"
	desc = "A rather old design of shuttle, but still being produced today ! And this one is brand new !"
	fore_dir = EAST
	vessel_mass = 11000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Javelot Shuttle"
	scanner_name = "Excursion Javelot Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Javelot Exploration Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with NT.
[b]Notice[/b]: The shuttle is assigned to the NEV Strelka. It is also a fighter carrier vessel."}
	color = "#a890ac"

// EMT - SEC Shuttle

/datum/shuttle/autodock/overmap/emt/strelka
	name = "Hammerdart Interception and Rescue Shuttle"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/emt/strelka/main, /area/shuttle/emt/strelka/cockpit)
	current_location = "strelka_emt_hangar"
	docking_controller_tag = "emtshuttle_docker"
	move_time = 15

/area/shuttle/emt/strelka
	name = "Hammerdart Interception and Rescue Shuttle"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/emt/strelka/cockpit
	name = "Hammerdart Interception and Rescue Shuttle cockpit"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/emt/strelka/main
	name = "Hammerdart Interception and Rescue Shuttle main"
	icon_state = "shuttle"
	requires_power = 1

/obj/machinery/computer/shuttle_control/explore/emt/strelka
	name = "short jump console"
	shuttle_tag = "Hammerdart Interception and Rescue Shuttle"

/obj/overmap/entity/visitable/ship/landable/emt/strelka
	name = "Hammerdart Interception and Rescue Shuttle"
	desc = "A shuttle combining EMT search and rescue work, with security like work. The best of 2 worlds."
	fore_dir = EAST
	vessel_mass = 11000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Hammerdart Interception and Rescue Shuttle"
	scanner_name = "Hammerdart Interception and Rescue Shuttle"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: Hammerdart Orbit Patrol Shuttle, Medical refit.
[i]Transponder[/i]: Transmitting (MED) and (CIV), Registered with NT.
[b]Notice[/b]: The shuttle is assigned to the NEV Strelka. It is also a fighter carrier vessel."}
	color = "#2613d1"

// Public Civilian Shuttle

/datum/shuttle/autodock/overmap/civvie/strelka
	name = "Decades Old civilian Transport"
	warmup_time = 11
	shuttle_area = list(/area/shuttle/civvie/strelka)
	current_location = "strelka_civvie_home"
	docking_controller_tag = "civvie_dock"
	fuel_consumption = 12
	move_time = 30

/area/shuttle/civvie/strelka
	name = "Decades Old civilian Transport"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/civvie/strelka/main
	name = "Decades Old civilian Transport Main"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/civvie/strelka/cockpit
	name = "Decades Old civilian Transport Cockpit"
	icon_state = "shuttle"
	requires_power = 1

/obj/machinery/computer/shuttle_control/explore/civvie/strelka
	name = "civilian jump console"
	shuttle_tag = "Decades Old civilian Transport"

/obj/overmap/entity/visitable/ship/landable/civvie/strelka
	name = "Decades Old civilian Transport"
	desc = "A basic, but slow, transport to ferry civilian to and from the ship."
	fore_dir = WEST
	vessel_mass = 9000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Decades Old civilian Transport"
	scanner_name = "Decades Old civilian Transport"
	scanner_desc = @{"[i]Registration[/i]: ---
[i]Class[/i]: 2460 Belka class Civilian Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with NT.
[b]Notice[/b]: The shuttle is assigned to the NEV Strelka"}
	color = "#7fbd27"


//////////////////////////////////////////////////////////////
// Escape shuttle and pods
/datum/shuttle/autodock/ferry/emergency/escape/strelka
	name = "Escape"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/escape
	warmup_time = 10
	landmark_offsite = "escape_cc"
	landmark_station = "escape_strelka"
	landmark_transition = "escape_transit"
	move_time = SHUTTLE_TRANSIT_DURATION_RETURN

// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo/strelka
	name = "Supply"
	location = FERRY_LOCATION_OFFSITE
	shuttle_area = /area/shuttle/supply
	warmup_time = 10
	landmark_offsite = "supply_cc"
	landmark_station = "supply_dock"
	docking_controller_tag = "supply_shuttle"
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY

//Landmarks

// Exclusive landmark for docking *inside* the station

/obj/effect/shuttle_landmark/strelka/deck2/excursion
	name = "NEV Strelka - Javelot Hangar"
	landmark_tag = "strelka_excursion_hangar"
	docking_controller = "expshuttle_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/strelka/shipbase/deck2/explo

/obj/effect/shuttle_landmark/strelka/deck2/emt
	name = "NEV strelka - Hammerdart Hangar"
	landmark_tag = "strelka_emt_hangar"
	docking_controller = "emt_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/strelka/shipbase/deck2/explo/emt

/obj/effect/shuttle_landmark/strelka/deck1/civi
	name = "NEV strelka - Civilian Private Dock"
	landmark_tag = "strelka_civvie_home"
	docking_controller = "civvie_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/strelka/shipbase/deck1/civhangar

