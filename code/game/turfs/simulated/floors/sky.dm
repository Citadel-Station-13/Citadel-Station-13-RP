// A simple turf to fake the appearance of flying.
/turf/simulated/sky
	name = "sky"
	desc = "Hope you don't have a fear of heights."
	icon = 'icons/turf/sky.dmi'
	icon_state = "sky_slow"
	outdoors = TRUE

	// Assume there's a vacuum for the purposes of avoiding active edges at initialization, as well as ZAS fun if a window breaks.
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/sky/Initialize(mapload)
	. = ..()
	set_light(2, 2, "#FFFFFF")

/turf/simulated/sky/north
	dir = NORTH

/turf/simulated/sky/south
	dir = SOUTH

/turf/simulated/sky/east
	dir = EAST

/turf/simulated/sky/west
	dir = WEST

/turf/simulated/sky/moving
	icon_state = "sky_fast"

/turf/simulated/sky/moving/north
	dir = NORTH

/turf/simulated/sky/moving/south
	dir = SOUTH

/turf/simulated/sky/moving/east
	dir = EAST

/turf/simulated/sky/moving/west
	dir = WEST

// Tether Variant
/turf/simulated/sky/virgo3b
	color = "#FFBBBB"

/turf/simulated/sky/virgo3b/Initialize(mapload)
	. = ..()
	set_light(2, 2, src.color)

/turf/simulated/sky/virgo3b/north
	dir = NORTH
/turf/simulated/sky/virgo3b/south
	dir = SOUTH
/turf/simulated/sky/virgo3b/east
	dir = EAST
/turf/simulated/sky/virgo3b/west
	dir = WEST

/turf/simulated/sky/virgo3b/moving
	icon_state = "sky_fast"
/turf/simulated/sky/virgo3b/moving/north
	dir = NORTH
/turf/simulated/sky/virgo3b/moving/south
	dir = SOUTH
/turf/simulated/sky/virgo3b/moving/east
	dir = EAST
/turf/simulated/sky/virgo3b/moving/west
	dir = WEST



//Rift Variant
/turf/simulated/sky/lythios43c
	color = "#DAFFFA"

/turf/simulated/sky/lythios43c/Initialize()
	. = ..()
	set_light(2, 2, src.color)

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


//Triumph Variant. Unused Currently
/turf/simulated/sky/triumph
	color = "#FFBBBB"

/turf/simulated/sky/triumph/Initialize(mapload)
	. = ..()
	set_light(2, 2, src.color)

/turf/simulated/sky/triumph/north
	dir = NORTH
/turf/simulated/sky/triumph/south
	dir = SOUTH
/turf/simulated/sky/triumph/east
	dir = EAST
/turf/simulated/sky/triumph/west
	dir = WEST

/turf/simulated/sky/triumph/moving
	icon_state = "sky_fast"
/turf/simulated/sky/triumph/moving/north
	dir = NORTH
/turf/simulated/sky/triumph/moving/south
	dir = SOUTH
/turf/simulated/sky/triumph/moving/east
	dir = EAST
/turf/simulated/sky/triumph/moving/west
	dir = WEST
