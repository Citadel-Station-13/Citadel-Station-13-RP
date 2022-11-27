
//Unsimulated

/turf/unsimulated/wall
	blocks_air = 1

/turf/unsimulated/icerock/lythios43c
	blocks_air = 1

// Some turfs to make floors look better in centcom tram station.

/turf/unsimulated/floor/techfloor_grid
	name = "floor"
	icon = 'icons/turf/flooring/techfloor_vr.dmi'
	icon_state = "techfloor_grid"

/turf/unsimulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"

/turf/unsimulated/wall/transit
	icon = 'icons/turf/transit_vr.dmi'

/turf/unsimulated/floor/transit
	icon = 'icons/turf/transit_vr.dmi'

/obj/effect/floor_decal/transit/orange
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "transit_techfloororange_edges"

/obj/effect/transit/light
	icon = 'icons/turf/transit_128.dmi'
	icon_state = "tube1-2"

// Bluespace jump turf!
/turf/space/bluespace
	name = "bluespace"
	icon_state = "bluespace"
/turf/space/bluespace/Initialize()
	..()
	icon_state = "bluespace"

// Desert jump turf!
/turf/space/sandyscroll
	name = "sand transit"
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "desert_ns"
/turf/space/sandyscroll/Initialize()
	..()
	icon_state = "desert_ns"

//Sky stuff!
/turf/simulated/sky/lythios43c
	color = "#DAFFFA"

/turf/simulated/sky/lythios43c/Initialize()
	. = ..()
	set_light(2, 2, "#DAFFFA")

/turf/simulated/sky/lythios43c/north
	dir = NORTH
/turf/simulated/sky/lythios43c/south
	dir = SOUTH
/turf/simulated/sky/lythios43c/east
	dir = EAST
/turf/simulated/sky/lythios43c/west
	dir = WEST

/turf/simulated/sky/lythios43c/moving
	icon_state = "sky_fast"
/turf/simulated/sky/lythios43c/moving/north
	dir = NORTH
/turf/simulated/sky/lythios43c/moving/south
	dir = SOUTH
/turf/simulated/sky/lythios43c/moving/east
	dir = EAST
/turf/simulated/sky/lythios43c/moving/west
	dir = WEST


