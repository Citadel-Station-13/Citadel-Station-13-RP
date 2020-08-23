// -- Datums -- //
/datum/shuttle_destination/excursion/debrisfield
	name = "Debris Field"
	my_landmark = "triumph_excursion_debrisfield"
	preferred_interim_tag = "triumph_excursion_transit_space"
	skip_me = TRUE

	routes_to_make = list( //These are routes the shuttle connects to,
		/datum/shuttle_destination/excursion/bluespace = 30 SECONDS //This is a normal destination that's part of this map
	)

// -- Objs -- //

/obj/shuttle_connector/debrisfield
	name = "shuttle connector - debrisfield"
	shuttle_name = "Excursion Shuttle"
	destinations = list(/datum/shuttle_destination/excursion/debrisfield)

/obj/effect/step_trigger/teleporter/debrisfield_loop/north/New()
	..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/south/New()
	..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/west/New()
	..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/debrisfield_loop/east/New()
	..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z

//POI Init
/obj/away_mission_init/debrisfield
	name = "away mission initializer - debrisfield"

/obj/away_mission_init/debrisfield/Initialize()
	return INITIALIZE_HINT_QDEL

//And some special areas, including our shuttle landing spot (must be unique)
/area/shuttle/excursion/debrisfield
	name = "\improper Excursion Shuttle - Debris Field"

/area/triumph_away/debrisfield
	name = "Away Mission - Debris Field"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "dark"

/area/triumph_away/debrisfield/explored
	icon_state = "debrisexplored"

/area/triumph_away/debrisfield/unexplored
	icon_state = "debrisunexplored"

/area/triumph_away/debrisfield/derelict
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')
