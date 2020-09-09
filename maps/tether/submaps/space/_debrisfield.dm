// -- Datums -- //
/obj/effect/overmap/visitable/sector/debrisfield
	name = "Debris Field"
	desc = "Space junk galore."
	scanner_desc = @{"[i]Transponder[/i]: Various faint signals
[b]Notice[/b]: Warning! Significant field of space debris detected. May be salvagable."}
	icon_state = "dust1"
	known = FALSE
	color = "#ee3333"	//Redish, so it stands out against the other debris-like icons
	initial_generic_waypoints = list("tether_excursion_debrisfield")

// -- Objs -- //

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

//This does nothing right now, but is framework if we do POIs for this place
/obj/away_mission_init/debrisfield
	name = "away mission initializer - debrisfield"

/obj/away_mission_init/debrisfield/Initialize()
	return INITIALIZE_HINT_QDEL

//And some special areas, including our shuttle landing spot (must be unique)
/area/shuttle/excursion/debrisfield
	name = "\improper Excursion Shuttle - Debris Field"

/area/tether_away/debrisfield
	name = "Away Mission - Debris Field"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "dark"

/area/tether_away/debrisfield/explored
	icon_state = "debrisexplored"

/area/tether_away/debrisfield/unexplored
	icon_state = "debrisunexplored"

/area/tether_away/debrisfield/derelict
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')
