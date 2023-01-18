/turf/unsimulated/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE

	//! NOTICE: UNSIMULATED TURFS DO NOT SMOOTH, THIS IS MORESO FOR OTHER TURFS
	smoothing_groups = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS)

/turf/unsimulated/wall/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = FALSE

/turf/unsimulated/wall/other
	icon_state = "r_wall"

/turf/unsimulated/wall/seperator //to block vision between transit zones
	name = ""
	icon = 'icons/effects/effects.dmi'
	icon_state = "1"

/turf/unsimulated/wall/transit
	icon = 'icons/turf/transit_vr.dmi'
