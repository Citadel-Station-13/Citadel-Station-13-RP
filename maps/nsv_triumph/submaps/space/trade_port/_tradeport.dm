// -- Objs -- //

/obj/effect/step_trigger/teleporter/tradeport_loop/north/New()
	..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/tradeport_loop/south/New()
	..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/tradeport_loop/west/New()
	..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/tradeport_loop/east/New()
	..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z

//This does nothing right now, but is framework if we do POIs for this place
/obj/away_mission_init/tradeport
	name = "away mission initializer - tradeport"

/obj/away_mission_init/tradeport/Initialize()
	return INITIALIZE_HINT_QDEL