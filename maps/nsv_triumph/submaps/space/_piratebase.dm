// -- Objs -- //

/obj/effect/step_trigger/teleporter/piratebase_loop/north/New()
	..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/piratebase_loop/south/New()
	..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/piratebase_loop/west/New()
	..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/piratebase_loop/east/New()
	..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z

//This does nothing right now, but is framework if we do POIs for this place
/obj/away_mission_init/piratebase
	name = "away mission initializer - piratebase"

/obj/away_mission_init/piratebase/Initialize()
	return INITIALIZE_HINT_QDEL

//And some special areas, including our shuttle landing spot (must be unique)
/area/shuttle/excursion/piratebase
	name = "\improper Excursion Shuttle - Pirate Base"

/area/triumph_away/piratebase
	name = "Away Mission - Pirate Base"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "dark"

/area/triumph_away/piratebase/space
	icon_state = "debrisunexplored"

/area/triumph_away/piratebase/facility
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')
