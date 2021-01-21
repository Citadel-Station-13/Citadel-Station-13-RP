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

//And some special areas, including our shuttle landing spot (must be unique)
/area/shuttle/excursion/trader
	name = "\improper Beruang Trade Shuttle"

/area/triumph_away/tradeport
	name = "Away Mission - Trade Port"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "dark"
	flags = RAD_SHIELDED
	requires_power = 1

/area/triumph_away/tradeport/space
	icon_state = "debrisunexplored"

/area/triumph_away/tradeport/facility
	icon_state = "red"

/area/triumph_away/tradeport/engineering
	icon_state = "yellow"

/area/triumph_away/tradeport/commons
	icon_state = "green"

/area/triumph_away/tradeport/dock
	icon_state = "blue"

/area/triumph_away/tradeport/pads
	icon_state = "purple"

/area/triumph_away/tradeport/spine
	name = "\improper Commerce Spine"
	icon_state = "red"

/area/triumph_away/tradeport/commhall
	name = "\improper Commerce Hall"
	icon_state = "yellow"

/area/triumph_away/tradeport/safari
	name = "\improper Safari Shop"
	icon_state = "green"

/area/triumph_away/tradeport/safarizoo
	name = "\improper Safari Zone"
	icon_state = "blue"
