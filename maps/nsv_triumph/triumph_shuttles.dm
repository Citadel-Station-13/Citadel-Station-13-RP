/*
** Shared Landmark Defs
*/

// Shared landmark for docking at the station
/obj/effect/shuttle_landmark/station_dockpoint1
	name = "Station Docking Point 1"
	landmark_tag = "nav_station_docking1"
	docking_controller = "station_dock1"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/station_dockpoint2
	name = "NSV Triumph - Docking Arm 2"
	landmark_tag = "nav_capitalship_docking2"
	docking_controller = "d1a_dock"
	base_turf = /turf/space
	base_area = /area/space

// Shared landmark for docking *inside* the station

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

// PIRATE SHIP (Yaya!)
/datum/shuttle/autodock/overmap/pirate
	name = "Pirate Skiff"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/pirate/cockpit, /area/shuttle/pirate/general, /area/shuttle/pirate/cargo)
	current_location = "piratebase_hanger"
	docking_controller_tag = "pirate_docker"
	landmark_transition = "nav_transit_pirate"
	fuel_consumption = 5
	move_time = 20

/area/shuttle/pirate
	name = "Pirate Skiff"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/pirate
	name = "short jump raiding console"
	shuttle_tag = "Pirate Skiff"

// NAV POINTS /////////////////
/obj/effect/shuttle_landmark/triumph/deck4/excursion
	name = "NSV Triumph - Excursion Hanger"
	landmark_tag = "triumph_excursion_hangar"
	docking_controller = "expshuttle_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/triumph/station/excursion_dock


/obj/effect/shuttle_landmark/triumph/deck4/excursion_space
	name = "Near NSV Triumph (SW)"
	landmark_tag = "triumph_space_SW"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/transit/triumph/excursion
	name = "In transit"
	landmark_tag = "nav_transit_exploration"

/obj/effect/shuttle_landmark/triumph/pirate
	name = "Pirate Skiff Dock"
	landmark_tag = "piratebase_hanger"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/transit/triumph/pirate
	name = "In transit"
	landmark_tag = "nav_transit_pirate"


////////////////////////////////////////
////////      Tour Bus     /////////////
////////////////////////////////////////
/datum/shuttle/autodock/overmap/tourbus
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
