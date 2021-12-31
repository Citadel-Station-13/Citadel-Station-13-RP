///////////////////////////
//// Spawning and despawning
var/global/list/latejoin_trade = list()
/obj/effect/landmark/trade
	name = "JoinLateTrade"
	delete_me = 1

/obj/effect/landmark/trade/New()
	latejoin_trade += loc // Register this turf as tram latejoin.
	..()

/datum/spawnpoint/trade
	display_name = "Beruang Trading Corp Cryo"
	restrict_job = list("Trader")
	msg = "has come out of cryostasis"
	announce_channel = "Trade"

/datum/spawnpoint/trade/New()
	..()
	turfs = latejoin_trade

/obj/machinery/cryopod/trade
	announce_channel = "Trade"
	on_store_message = "has entered cryogenic storage."
	on_store_name = "Beruang Trading Corp Cryo"
	on_enter_visible_message = "starts climbing into the"
	on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	on_store_visible_message_1 = "hums and hisses as it moves"
	on_store_visible_message_2 = "into cryogenic storage."

/obj/machinery/cryopod/robot/trade
	announce_channel = "Trade"
	on_store_name = "Beruang Trading Corp Storage"

/obj/effect/landmark/map_data/trade
    height = 2

// Their shuttle

/datum/shuttle/autodock/overmap/trade
	name = "Beruang Trade Ship"
	warmup_time = 0
	shuttle_area = list(/area/shuttle/trade_ship/cockpit, /area/shuttle/trade_ship/general)
	current_location = "tradeport_hangar"
	docking_controller_tag = "tradeport_hangar_docker"
	//landmark_transition = "nav_transit_trade"
	fuel_consumption = 5
	move_time = 10

/obj/effect/overmap/visitable/ship/landable/trade
	name = "Beruang Trade Ship"
	desc = " "
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Beruang Shuttle"

/obj/machinery/computer/shuttle_control/explore/trade
	name = "short jump console"
	shuttle_tag = "Beruang Shuttle"


/area/shuttle/trade_ship
	name = "Beruang Trade Ship"
	icon_state = "shuttle"

/area/shuttle/trade_ship/general
	name = "\improper Beruang Trade Ship"

/area/shuttle/trade_ship/cockpit
	name = "\improper Beruang Trade Ship Cockpit"

/obj/machinery/computer/shuttle_control/explore/trade
	name = "short jump commerce console"

// Shuttle landmarks. Need to be removed at some point and generic waypoints used

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

// Todo
/*
/obj/machinery/camera/network/trade
	network = list(NETWORK_TRADE_STATION)
*/

