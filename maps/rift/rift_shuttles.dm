
/obj/machinery/computer/shuttle_control/multi/mercenary
	name = "vessel control console"
	shuttle_tag = "Mercenary"
	req_one_access = list(ACCESS_FACTION_SYNDICATE)


/obj/machinery/computer/shuttle_control/multi/trade
	name = "vessel control console"
	shuttle_tag = "Trade"
	req_one_access = list(ACCESS_FACTION_TRADER)

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
	color = "#72388d" //Purple
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	//req_one_access = list(ACCESS_GENERAL_PILOT)

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
	color = "#af3e97" //Pinkish Purple
	fore_dir = EAST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Courser Scouting Vessel"

/area/shuttle/courser
	name = "Courser Scouting Vessel"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/courser
	name = "short jump console"
	shuttle_tag = "Courser Scouting Vessel"
	//req_one_access = list(ACCESS_GENERAL_PILOT)

// Hammerhead Patrol Barge

/datum/shuttle/autodock/overmap/hammerhead
	name = "Hammerhead Patrol Barge"
	warmup_time = 10
	shuttle_area = list(/area/shuttle/hammerhead/cockpit, /area/shuttle/hammerhead/general, /area/shuttle/hammerhead/brig, /area/shuttle/hammerhead/bay)
	current_location = "rift_hammerhead_hangar"
	docking_controller_tag = "hammerhead_docker"
	landmark_transition = "nav_transit_hammerhead"
	move_time = 15

/obj/effect/overmap/visitable/ship/landable/hammerhead
	name = "Hammerhead Patrol Barge"
	desc = "To Detain and Enforce."
	color = "#b91a14" //Vibrant Red
	fore_dir = EAST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Hammerhead Patrol Barge"

/area/shuttle/hammerhead
	name = "Hammerhead Patrol Barge"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/hammerhead
	name = "short jump console"
	shuttle_tag = "Hammerhead Patrol Barge"
	//req_one_access = list(ACCESS_GENERAL_PILOT)

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
	color = "#754116" //Brown
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
	color = "#69b9de" //Light Blue
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
