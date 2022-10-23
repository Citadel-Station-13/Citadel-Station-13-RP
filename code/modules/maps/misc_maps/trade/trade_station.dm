//Overmap Controller
/obj/effect/overmap/visitable/sector/trade_post
	name = "Nebula Gas Food Mart"
	desc = "A ubiquitous chain of traders common in this area of the Galaxy."
	scanner_desc = @{"[i]Information[/i]: A trade post and fuel depot. Possible life signs detected."}
	in_space = 1
	known = TRUE
	icon_state = "fueldepot"
	color = "#8F6E4C"

	initial_generic_waypoints = list(
		"nebula_pad_1",
		"nebula_pad_2",
		"nebula_space_SW",
		"nebula_pad_3a",
		"nebula_pad_3b",
		"nebula_pad_3c",
		"nebula_pad_4a",
		"nebula_pad_4b",
		"nebula_pad_4c",
		"nebula_pad_5",
		"nebula_pad_6",
		"nebula_space_SE",
		"nebula_space_S",
		"nebula_space_SW"
		)

	initial_restricted_waypoints = list(
		"Beruang Trade Ship" = list("tradeport_hangar")
		)
/* // Old Restricted list. Leaving commented out for reference - Bloop
	initial_restricted_waypoints = list(
		"Beruang Trade Ship" = list("tradeport_hangar"),
		"Mining Shuttle" = list("nebula_pad_2"),
		"Excursion Shuttle" = list("nebula_pad_3"),
		"Pirate Skiff" = list("nebula_pad_4"),
		"Dart EMT Shuttle" = list("nebula_pad_5"),
		"Civilian Transport" = list("nebula_pad_6")
		)
*/

///////////////////////////
//// Spawning and despawning

/datum/spawnpoint/trade
	display_name = "Beruang Trading Corp Cryo"
	restrict_job = list("Trader")
	announce_channel = "Trade"

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

/obj/landmark/map_data/trade
    height = 1

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
	desc = "You know our motto: 'We deliver!'"
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Beruang Trade Ship"

/obj/machinery/computer/shuttle_control/explore/trade
	name = "short jump console"
	shuttle_tag = "Beruang Trade Ship"


/area/shuttle/trade_ship
	name = "Beruang Trade Ship"
	icon_state = "shuttle"

/area/shuttle/trade_ship/general
	name = "\improper Beruang Trade Ship"

/area/shuttle/trade_ship/cockpit
	name = "\improper Beruang Trade Ship Cockpit"

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

