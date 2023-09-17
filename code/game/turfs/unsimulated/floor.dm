/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

	//! NOTICE: UNSIMULATED TURFS DO NOT SMOOTH, THIS IS MORESO FOR OTHER TURFS
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR)

/turf/unsimulated/floor/shuttle_ceiling
	icon_state = "reinforced"

/turf/unsimulated/floor/steel
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"

/turf/unsimulated/floor/dark
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "dark"

/turf/unsimulated/floor/wood
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"

/turf/unsimulated/floor/techfloor_grid
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_grid"

/turf/unsimulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"

/turf/unsimulated/floor/transit
	icon = 'icons/turf/transit_vr.dmi'
