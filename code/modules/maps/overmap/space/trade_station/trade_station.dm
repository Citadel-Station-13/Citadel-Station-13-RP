//Overmap Controller
/obj/overmap/entity/visitable/sector/trade_post
	name = "Nebula Gas Food Mart"
	desc = "A ubiquitous chain of traders common in this area of the Galaxy."
	scanner_desc = @{"[i]Information[/i]: A trade post and fuel depot. Possible life signs detected."}
	in_space = 1
	known = TRUE
	icon_state = "fueldepot"
	color = "#8F6E4C"

	initial_generic_waypoints = list(
		"nebula_pad_1a",
		"nebula_pad_1b",
		"nebula_pad_2a",
		"nebula_pad_2b",
		"nebula_pad_3a",
		"nebula_pad_3b",
		"nebula_pad_3c",
		"nebula_pad_3d",
		"nebula_pad_4e",
		"nebula_pad_4a",
		"nebula_pad_4b",
		"nebula_pad_4c",
		"nebula_pad_4d",
		"nebula_pad_4e",
		"nebula_pad_5a",
		"nebula_pad_5b",
		"nebula_pad_6a",
		"nebula_pad_6b",
		"nebula_space_SE",
		"nebula_space_S",
		"nebula_space_S2",
		"nebula_space_SW",
		"nebula_space_SW2",
		"nebula_space_SDF",
		)

	initial_restricted_waypoints = list(
		"Beruang Trade Ship" = list("tradeport_hangar"),
		"Udang Transport Shuttle" = list("tradeport_udang"),
		"Scoophead trade Shuttle" = list("tradeport_scoophead"),
		"Arrowhead Racing Shuttle" = list("tradeport_arrowhead"),
		"Spacena Caravan Shuttle" = list("tradeport_caravan"),
		"Spacena Adventurer Shuttle" = list("tradeport_adventurer"),
		"Cargo Tug Hauler Shuttle" = list("tradeport_tug"),
		"Utility Micro Shuttle" = list("tradeport_utilitymicro"),
		"Teshari Runabout Shuttle" = list("tradeport_runabout"),
		"GCSS Vevalia Salvage Shuttle" = list("tradeport_scavenging")
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

/datum/spawnpoint/trade/visitor
	display_name = "Nebula Visitor Arrival"
	restrict_job = list("Traveler")
	announce_channel = "Trade"
	method = LATEJOIN_METHOD_ARRIVALS_SHUTTLE

/obj/machinery/cryopod/robot/door/gateway/trade/visitor
	name = "Trade public teleporter"
	desc = "The short-range teleporter you might've came in from. You could leave easily using this."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad_idle"
	announce_channel = "Trade"
	base_icon_state = "pad"
	occupied_icon_state = "pad_active"
	on_store_message = "has departed via short-range teleport."
	on_enter_occupant_message = "The teleporter activates, and you step into the swirling portal."
	spawnpoint_type = /datum/prototype/role/job/station/outsider

// Their shuttle

// Shuttle landmarks. Need to be removed at some point and generic waypoints used

/obj/effect/shuttle_landmark/trade
	name = "Near Nebula Gas Food Mart"
	landmark_tag = "nebula_space_SW"
	base_turf = /turf/space
	base_area = /area/space

// EXCLUSIVE TRADE PORT NAV POINTS

/obj/effect/shuttle_landmark/trade/mining
	name = "Nebula Gas Landing Pad 2"
	landmark_tag = "nebula_pad_2"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

/obj/effect/shuttle_landmark/trade/excursion
	name = "Nebula Gas Landing Pad 3"
	landmark_tag = "nebula_pad_3"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

/obj/effect/shuttle_landmark/trade/pirate
	name = "Nebula Gas Landing Pad 4"
	landmark_tag = "nebula_pad_4"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

/obj/effect/shuttle_landmark/trade/emt
	name = "Nebula Gas Landing Pad 5"
	landmark_tag = "nebula_pad_5"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

/obj/effect/shuttle_landmark/trade/civvie
	name = "Nebula Gas Landing Pad 6"
	landmark_tag = "nebula_pad_6"
	base_turf = /turf/simulated/shuttle/floor/black/airless
	base_area = /area/tradeport/pads

// EXCLUSIVE TRADE PORT NAV POINT FOR DOCKING INSIDE

/obj/effect/shuttle_landmark/trade/hangar
	name = "Beruang Hangar"
	landmark_tag = "tradeport_hangar"
	docking_controller = "tradeport_hangar_dock"
	base_turf = /turf/simulated/floor/tiled/techfloor/grid
	base_area = /area/tradeport/dock

/obj/effect/shuttle_landmark/triumph/trade/udang
	name = "Udang Underconstruction Docking bay"
	landmark_tag = "tradeport_udang"
	docking_controller = "tradeport_udang_dock"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/trade/scoophead
	name = "Scoophead Docking bay"
	landmark_tag = "tradeport_scoophead"
	docking_controller = "tradeport_scoophead_dock"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/trade/arrowhead
	name = "VIP suit docking hatch"
	landmark_tag = "tradeport_arrowhead"
	docking_controller = "tradeport_arrowhead_dock"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/triumph/trade/caravan
	name = "Caravan Docking Bay 2 Spot"
	landmark_tag = "tradeport_caravan"
	docking_controller = "tradeport_caravan_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/nebula_tradeport/dock2

/obj/effect/shuttle_landmark/triumph/trade/adventurer
	name = "Adventurer Docking Bay 2 Spot"
	landmark_tag = "tradeport_adventurer"
	docking_controller = "tradeport_adventurer_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/nebula_tradeport/dock2

/obj/effect/shuttle_landmark/triumph/trade/tug
	name = "Tug Hauler Docking Bay 2 Spot"
	landmark_tag = "tradeport_tug"
	docking_controller = "tradeport_tug_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/nebula_tradeport/dock2

/obj/effect/shuttle_landmark/triumph/trade/utilitymicro
	name = "Utility and service Docking Bay 2 Spot"
	landmark_tag = "tradeport_utilitymicro"
	docking_controller = "tradeport_utilitymicro_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/nebula_tradeport/dock2

/obj/effect/shuttle_landmark/triumph/trade/runabout
	name = "Teshari Runabout Docking Bay 2 Spot"
	landmark_tag = "tradeport_runabout"
	docking_controller = "tradeport_runabout_dock"
	base_turf = /turf/simulated/floor/reinforced
	base_area = /area/sector/nebula_tradeport/dock2

/obj/effect/shuttle_landmark/triumph/trade/scavenger
	name = "GCSS Vevalia Salvage dock"
	landmark_tag = "tradeport_scavenging"
	docking_controller = "trade_docks_4"
	base_turf = /turf/space
	base_area = /area/space

// Todo
/*
/obj/machinery/camera/network/trade
	network = list(NETWORK_TRADE_STATION)
*/

// -- Objs -- //

/obj/effect/step_trigger/teleporter/tradeport_loop/north/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/tradeport_loop/south/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/tradeport_loop/west/Initialize(mapload)
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/tradeport_loop/east/Initialize(mapload)
	. = ..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z

