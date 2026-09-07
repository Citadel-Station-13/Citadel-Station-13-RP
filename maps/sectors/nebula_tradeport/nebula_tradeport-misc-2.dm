//Overmap Controller
/obj/overmap/entity/visitable/sector/trade_post
	name = "Nebula Gas Food Mart"
	desc = "A ubiquitous chain of traders common in this area of the Galaxy."
	scanner_desc = @{"[i]Information[/i]: A trade post and fuel depot. Possible life signs detected."}
	in_space = 1
	known = TRUE
	icon_state = "fueldepot"
	color = "#8F6E4C"

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

