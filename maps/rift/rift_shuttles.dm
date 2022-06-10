/*
** Landmark Defs
 */

// Shared landmark for docking at the station

//Replace when we've got the map working and can actually place docking points
/*
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
*/

// Exclusive landmark for docking at the station

/obj/effect/shuttle_landmark/rift/deck3/excursion
	name = "NSB Atlas - Exploration Shuttle Pad"
	landmark_tag = "rift_excursion_pad"
	docking_controller = "expshuttle_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/civvie
	name = "NSB Atlas - Civilian Transport Pad"
	landmark_tag = "rift_civvie_pad"
	docking_controller = "civvie_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/emt
	name = "NSB Atlas - EMT Shuttle Pad"
	landmark_tag = "rift_emt_pad"
	docking_controller = "emt_shuttle_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck3/trade
	name = "NSB Atlas - Trade Pad"
	landmark_tag = "rift_trade_dock"
	base_turf = /turf/simulated/floor/reinforced/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

// Shared landmark for docking *inside* the station


// Exclusive landmark for docking *inside* the station

/obj/effect/shuttle_landmark/rift/deck3/courser
	name = "NSB Atlas - Courser Hanger"
	landmark_tag = "rift_courser_hangar"
	docking_controller = "courser_docker"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/exploration/courser_dock

// ON STATION NAV POINTS

/obj/effect/shuttle_landmark/rift/deck4/excursion_sky
	name = "NSB Atlas Airspace (SE)"
	landmark_tag = "rift_airspace_SE"
	base_turf = /turf/simulated/sky/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck4/east
	name = "NSB Atlas Airspace (E)"
	landmark_tag = "rift_airspace_E"
	base_turf = /turf/simulated/sky/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck4/northeast
	name = "NSB Atlas Airspace (NE)"
	landmark_tag = "rift_airspace_NE"
	base_turf = /turf/simulated/sky/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

/obj/effect/shuttle_landmark/rift/deck4/north
	name = "SB Atlas Airspace (N)"
	landmark_tag = "rift_airspace_N"
	base_turf = /turf/simulated/sky/lythios43c
	base_area = /area/rift/surfacebase/outside/outside3

// OFF-STATION NAV POINTS

/obj/effect/shuttle_landmark/rift/away/plains
	name = "NSB Atlas Western Plains"
	landmark_tag = "rift_plains"
	base_turf = /turf/simulated/floor/outdoors/snow/lythios43c
	base_area = /area/rift/surfacebase/outside/west

// TRANSIT NAV POINTS

/obj/effect/shuttle_landmark/transit/rift/excursion
	name = "In transit"
	landmark_tag = "nav_transit_exploration"

/obj/effect/shuttle_landmark/transit/rift/courser
	name = "In transit"
	landmark_tag = "nav_transit_courser"

/obj/effect/shuttle_landmark/transit/rift/pirate
	name = "In transit"
	landmark_tag = "nav_transit_pirate"

/obj/effect/shuttle_landmark/transit/rift/civvie
	name = "In transit"
	landmark_tag = "nav_transit_civvie"

/obj/effect/shuttle_landmark/transit/rift/trade
	name = "In transit"
	landmark_tag = "nav_transit_trade"

/obj/effect/shuttle_landmark/transit/rift/emt
	name = "In transit"
	landmark_tag = "nav_transit_emt"
/*
////////////////////////////////////////
// Triumph custom shuttle implemnetations
////////////////////////////////////////

/obj/machinery/computer/shuttle_control/triumph_backup
	name = "triumph backup shuttle control console"
	shuttle_tag = "Triumph Backup"
	req_one_access = list(access_heads,access_pilot)
*/

/obj/machinery/computer/shuttle_control/multi/mercenary
	name = "vessel control console"
	shuttle_tag = "Mercenary"
	req_one_access = list(access_syndicate)

/*
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
*/

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
	var/frequency = 1380 // Why this frequency? BECAUSE! Thats what someone decided once.
	var/datum/radio_frequency/radio_connection

/datum/shuttle/autodock/ferry/emergency/dock()
	..()
	// Open Doorsunes // ????? what -Werewolf
	var/datum/signal/signal = new
	signal.data["tag"] = tag_door_station
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = tag_door_station
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)

//	Supply Shuttle roofing for the planetmap

/datum/shuttle/autodock/ferry/supply
	ceiling_type = /turf/simulated/floor/plasteel/lythios43c

////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////

// The 'shuttle' of the excursion shuttle
/datum/shuttle/autodock/overmap/excursion
	name = "Excursion Shuttle"
	warmup_time = 0
	current_location = "rift_excursion_pad"
	docking_controller_tag = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	fuel_consumption = 3
	move_direction = WEST

/obj/effect/overmap/visitable/ship/landable/excursion
	name = "Excursion Shuttle"
	desc = "The Mk2 Excursion Shuttle. NT Approved!"
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	req_one_access = list(access_pilot)

// COURSER SHUTTLE DATA

/datum/shuttle/autodock/overmap/courser
	name = "Courser Scouting Vessel"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/courser/cockpit, /area/shuttle/courser/general, /area/shuttle/courser/battery)
	//shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	current_location = "rift_courser_hangar"
	docking_controller_tag = "courser_docker"
	landmark_transition = "nav_transit_courser"
	move_time = 15

/obj/effect/overmap/visitable/ship/landable/courser
	name = "Courser Scouting Vessel"
	desc = "Where there's a cannon, there's a way."
	fore_dir = WEST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Courser Scouting Vessel"

/area/shuttle/courser
	name = "Courser Scouting Vessel"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/courser
	name = "short jump console"
	shuttle_tag = "Courser Scouting Vessel"
	req_one_access = list(access_pilot)

// Public Civilian Shuttle

/datum/shuttle/autodock/overmap/civvie
	name = "Civilian Transport"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/civvie/cockpit, /area/shuttle/civvie/general)
	current_location = "rift_civvie_pad"
	docking_controller_tag = "civvie_docker"
	landmark_transition = "nav_transit_civvie"
	fuel_consumption = 10
	move_time = 30

/obj/effect/overmap/visitable/ship/landable/civvie
	name = "Civilian Transport"
	desc = "A basic, but slow, transport to ferry civilian to and from the ship."
	fore_dir = NORTH
	vessel_mass = 12000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Civilian Transport"

/area/shuttle/civvie
	name = "Civilian Transport"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/civvie
	name = "civilian jump console"
	shuttle_tag = "Civilian Transport"

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

/obj/effect/overmap/visitable/ship/landable/trade
	name = "Beruang Trade Ship"
	desc = "You know our motto: 'We deliver!'"
	fore_dir = WEST
	vessel_mass = 25000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Beruang Trade Ship"

/area/shuttle/trade_ship
	name = "Beruang Trade Ship"
	icon_state = "shuttle"

/area/shuttle/trade_ship/general
	name = "\improper Beruang Trade Ship"

/area/shuttle/trade_ship/cockpit
	name = "\improper Beruang Trade Ship Cockpit"

//EMT Shuttle
/datum/shuttle/autodock/overmap/emt
	name = "Dart EMT Shuttle"
	warmup_time = 5
	shuttle_area = list(/area/shuttle/emt/general, /area/shuttle/emt/cockpit)
	current_location = "rift_emt_pad"
	docking_controller_tag = "emt_shuttle_docker"
	landmark_transition = "nav_transit_emt"
	move_time = 10

/obj/effect/overmap/visitable/ship/landable/emt
	name = "Dart EMT Shuttle"
	desc = "The budget didn't allow for flashing lights."
	fore_dir = NORTH
	vessel_mass = 9000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Dart EMT Shuttle"

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
