/*
** Landmark Defs
 */

// Shared landmark for docking at the station

/obj/effect/shuttle_landmark/automatic/station_dockpoint1
	name = "Station Docking Point 1"
	landmark_tag = "nav_station_docking1"
	docking_controller = "deck4_dockarm1"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/automatic/station_dockpoint2
	name = "NSV Triumph - Docking Arm 2"
	landmark_tag = "nav_capitalship_docking2"
	docking_controller = "deck4_dockarm2"
	base_turf = /turf/space
	base_area = /area/space


// Exclusive landmark for docking at the station

/obj/effect/shuttle_landmark/triumph/deck4/civvie
	name = "NSV Triumph - Civilian Transport Dock"
	landmark_tag = "triumph_civvie_home"
	docking_controller = "civvie_docker"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck3/emt
	name = "NSV Triumph - EMT Shuttle Dock"
	landmark_tag = "triumph_emt_dock"
	docking_controller = "emt_shuttle_docker"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck2/mining
	name = "NSV Triumph Mining Dock"
	landmark_tag = "triumph_mining_port"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck2/trade
	name = "NSV Triumph Annex Dock"
	landmark_tag = "triumph_annex_dock"
	base_turf = /turf/space
	base_area = /area/space

// Shared landmark for docking *inside* the station


// Exclusive landmark for docking *inside* the station

/obj/effect/shuttle_landmark/triumph/deck4/excursion
	name = "NSV Triumph - Excursion Hanger"
	landmark_tag = "triumph_excursion_hangar"
	docking_controller = "expshuttle_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/exploration/excursion_dock


// ON STATION NAV POINTS

/obj/effect/shuttle_landmark/triumph/deck4/excursion_space
	name = "Near NSV Triumph (SW)"
	landmark_tag = "triumph_space_SW"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck3/port
	name = "Near NSV Triumph (Port Deck 3)"
	landmark_tag = "triumph_space_port_3"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck3/starboard
	name = "Near NSV Triumph (Starboard Deck 3)"
	landmark_tag = "triumph_space_starboard_3"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck2/port
	name = "Near NSV Triumph (Port Deck 2)"
	landmark_tag = "triumph_space_port_2"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck2/starboard
	name = "Near NSV Triumph (Starboard Deck 2)"
	landmark_tag = "triumph_space_starboard_2"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck1/port
	name = "Near NSV Triumph (Port Deck 1)"
	landmark_tag = "triumph_space_port_1"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/deck1/starboard
	name = "Near NSV Triumph (Starboard Deck 1)"
	landmark_tag = "triumph_space_starboard_1"
	base_turf = /turf/space
	base_area = /area/space

// OFF-STATION NAV POINTS
/obj/effect/shuttle_landmark/triumph/pirate
	name = "Pirate Skiff Dock"
	landmark_tag = "piratebase_hanger"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/trade
	name = "Near Nebula Gas Food Mart"
	landmark_tag = "nebula_space_SW"
	base_turf = /turf/space
	base_area = /area/space

// EXCLUSIVE TRADE PORT NAV POINTS

/obj/effect/shuttle_landmark/triumph/trade/mining
	name = "Nebula Gas Landing Pad 2"
	landmark_tag = "nebula_pad_2"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

/obj/effect/shuttle_landmark/triumph/trade/excursion
	name = "Nebula Gas Landing Pad 3"
	landmark_tag = "nebula_pad_3"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

/obj/effect/shuttle_landmark/triumph/trade/pirate
	name = "Nebula Gas Landing Pad 4"
	landmark_tag = "nebula_pad_4"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

/obj/effect/shuttle_landmark/triumph/trade/emt
	name = "Nebula Gas Landing Pad 5"
	landmark_tag = "nebula_pad_5"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

/obj/effect/shuttle_landmark/triumph/trade/civvie
	name = "Nebula Gas Landing Pad 6"
	landmark_tag = "nebula_pad_6"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

// EXCLUSIVE TRADE PORT NAV POINT FOR DOCKING INSIDE

/obj/effect/shuttle_landmark/triumph/trade/hangar
	name = "Beruang Hangar"
	landmark_tag = "tradeport_hangar"
	docking_controller = "tradeport_hangar_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/tradeport/dock

// TRANSIT NAV POINTS

/obj/effect/shuttle_landmark/transit/triumph/excursion
	name = "In transit"
	landmark_tag = "nav_transit_exploration"

/obj/effect/shuttle_landmark/transit/triumph/pirate
	name = "In transit"
	landmark_tag = "nav_transit_pirate"

/obj/effect/shuttle_landmark/transit/triumph/civvie
	name = "In transit"
	landmark_tag = "nav_transit_civvie"

/obj/effect/shuttle_landmark/transit/triumph/mining
	name = "In transit"
	landmark_tag = "nav_transit_mining"

/obj/effect/shuttle_landmark/transit/triumph/trade
	name = "In transit"
	landmark_tag = "nav_transit_trade"

/obj/effect/shuttle_landmark/transit/triumph/emt
	name = "In transit"
	landmark_tag = "nav_transit_emt"

////////////////////////////////////////
// Triumph custom shuttle implemnetations
////////////////////////////////////////

/obj/machinery/computer/shuttle_control/triumph_backup
	name = "triumph backup shuttle control console"
	shuttle_tag = "Triumph Backup"
	req_one_access = list(access_heads,access_pilot)

/obj/machinery/computer/shuttle_control/multi/mercenary
	name = "vessel control console"
	shuttle_tag = "Mercenary"
	req_one_access = list(access_syndicate)

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
	req_one_access = list(access_cent_specops)

/obj/machinery/computer/shuttle_control/multi/trade
	name = "vessel control console"
	shuttle_tag = "Trade"
	req_one_access = list(access_trader)

/*
/obj/machinery/computer/shuttle_control/cruiser_shuttle
	name = "cruiser shuttle control console"
	shuttle_tag = "Cruiser Shuttle"
	req_one_access = list(access_heads)
*/

//
// "Tram" Emergency Shuttler
// Becuase the tram only has its own doors and no corresponding station doors, a docking controller is overkill.
// Just open the gosh darn doors!  Also we avoid having a physical docking controller obj for gameplay reasons.
/datum/shuttle/autodock/ferry/emergency
	var/tag_door_station = "escape_shuttle_hatch_station"
	var/tag_door_offsite = "escape_shuttle_hatch_offsite"
	var/frequency = 1380 // Why this frequency? BECAUSE! Thats what someone decided once.
	var/datum/radio_frequency/radio_connection

/datum/shuttle/autodock/ferry/emergency/dock()
	..()
	// Open Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)

////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////
/*
// The 'shuttle' of the excursion shuttle
/datum/shuttle/autodock/overmap/excursion
	name = "Excursion Shuttle"
	warmup_time = 0
	current_location = "triumph_excursion_hangar"
	docking_controller_tag = "expshuttle_dock"
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	//fuel_consumption = 3
	fuel_consumption = 0	//inf fuel for testing purposes

// The 'ship' of the excursion shuttle
/obj/effect/overmap/visitable/ship/landable/excursion
	name = "Excursion Shuttle"
	desc = "The traditional Excursion Shuttle. NT Approved!"
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Shuttle"
	start_x = 4
	start_y = 5
*/


// EXCURSION SHUTTLE DATA

/datum/shuttle/autodock/overmap/excursion
	name = "Excursion Shuttle"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	current_location = "triumph_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	landmark_transition = "nav_transit_exploration"
	fuel_consumption = 3
	move_time = 20

/area/shuttle/excursion
	name = "Excursion Shuttle"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	req_one_access = list(access_pilot)

// Public Civilian Shuttle

/datum/shuttle/autodock/overmap/civvie
	name = "Civilian Transport"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/civvie/cockpit, /area/shuttle/civvie/general)
	current_location = "triumph_civvie_home"
	docking_controller_tag = "civvie_docker"
	landmark_transition = "nav_transit_civvie"
	fuel_consumption = 10
	move_time = 30

/area/shuttle/civvie
	name = "Civilian Transport"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/civvie
	name = "civilian jump console"
	shuttle_tag = "Civilian Transport"

// PIRATE SHIP (Yaya!)
/datum/shuttle/autodock/overmap/pirate
	name = "Pirate Skiff"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/pirate/cockpit, /area/shuttle/pirate/general, /area/shuttle/pirate/cargo)
	current_location = "piratebase_hanger"
	docking_controller_tag = "pirate_docker"
	landmark_transition = "nav_transit_pirate"
	fuel_consumption = 5
	move_time = 10

/area/shuttle/pirate
	name = "Pirate Skiff"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/pirate
	name = "short jump raiding console"
	shuttle_tag = "Pirate Skiff"

// Mining Shuttle

/datum/shuttle/autodock/overmap/mining
	name = "Mining Shuttle"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/mining_ship/general)
	current_location = "triumph_mining_port"
	docking_controller_tag = "mining_docker"
	landmark_transition = "nav_transit_mining"
	move_time = 30

/area/shuttle/mining
	name = "Mining Shuttle"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/mining
	name = "mining jump console"
	shuttle_tag = "Mining Shuttle"

// TRADE SHIP
/datum/shuttle/autodock/overmap/trade
	name = "Beruang Trade Ship"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/trade_ship/cockpit, /area/shuttle/trade_ship/general)
	current_location = "tradeport_hangar"
	docking_controller_tag = "tradeport_hangar_docker"
	landmark_transition = "nav_transit_trade"
	fuel_consumption = 5
	move_time = 10

/area/shuttle/trade_ship
	name = "Beruang Trade Ship"
	icon_state = "shuttle"

/area/shuttle/trade_ship/general
	name = "\improper Beruang Trade Ship"

/area/shuttle/trade_ship/cockpit
	name = "\improper Beruang Trade Ship Cockpit"

/obj/machinery/computer/shuttle_control/explore/trade
	name = "short jump commerce console"
	shuttle_tag = "Beruang Trade Ship"

//EMT Shuttle
/datum/shuttle/autodock/overmap/emt
	name = "Dart EMT Shuttle"
	warmup_time = 5
	shuttle_area = list(/area/shuttle/emt/general, /area/shuttle/emt/cockpit)
	current_location = "triumph_emt_dock"
	docking_controller_tag = "emt_shuttle_docker"
	landmark_transition = "nav_transit_emt"
	move_time = 20

/area/shuttle/emt
	name = "Dart EMT Shuttle"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/emt
	name = "EMT jump console"
	shuttle_tag = "Dart EMT Shuttle"

////////////////////////////////////////
////////      Tour Bus     /////////////
////////////////////////////////////////
/*/datum/shuttle/autodock/overmap/tourbus
	name = "Tour Bus"
	warmup_time = 0
	current_location = "tourbus_dock"
	docking_controller_tag = "tourbus_docker"
	shuttle_area = list(/area/shuttle/tourbus/cockpit, /area/shuttle/tourbus/general, /area/shuttle/tourbus/engines)
	fuel_consumption = 1

// The 'ship' of the tourbus
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
*/
