// A simple turf to fake the appearance of flying.
/**
 * **WARNING**: This is labelled fake_sky because it does not handle falling behavior for you.
 *
 * This does **not** mean that you can walk around on it. Most maps using this will have step triggers that will make you fall anyways!
 *
 * So don't come complaining when the 'fake' sky actually kills you. Don't walk off a cliff. Not rocket science.
 *
 * TODO: Stop using this path. It's expensive and inefficient; use `/turf/simulated/sky` for actual skyfall-handling skies.
 */
/turf/simulated/fake_sky
	name = "sky"
	desc = "Hope you don't have a fear of heights."
	icon = 'icons/turf/sky.dmi'
	icon_state = "sky_slow"
	outdoors = TRUE

	// Assume there's a vacuum for the purposes of avoiding active edges at initialization, as well as ZAS fun if a window breaks.
	initial_gas_mix = GAS_STRING_VACUUM

	turf_flags = TURF_FLAG_ERODING

// todo: sky should generally always use planet-lighting-like's, why tf are they all light sources and why tf are they using hardset colors and dirs?
//       this should just be part of weather/parallax renderer if possible.

/turf/simulated/fake_sky/Initialize(mapload)
	. = ..()
	set_light(2, 2, "#FFFFFF")

/turf/simulated/fake_sky/north
	dir = NORTH

/turf/simulated/fake_sky/south
	dir = SOUTH

/turf/simulated/fake_sky/east
	dir = EAST

/turf/simulated/fake_sky/west
	dir = WEST

/turf/simulated/fake_sky/moving
	icon_state = "sky_fast"

/turf/simulated/fake_sky/moving/north
	dir = NORTH

/turf/simulated/fake_sky/moving/south
	dir = SOUTH

/turf/simulated/fake_sky/moving/east
	dir = EAST

/turf/simulated/fake_sky/moving/west
	dir = WEST

// Tether Variant
/turf/simulated/fake_sky/virgo3b
	color = "#FFBBBB"

/turf/simulated/fake_sky/virgo3b/Initialize(mapload)
	. = ..()
	set_light(2, 2, src.color)

/turf/simulated/fake_sky/virgo3b/north
	dir = NORTH
/turf/simulated/fake_sky/virgo3b/south
	dir = SOUTH
/turf/simulated/fake_sky/virgo3b/east
	dir = EAST
/turf/simulated/fake_sky/virgo3b/west
	dir = WEST

/turf/simulated/fake_sky/virgo3b/moving
	icon_state = "sky_fast"
/turf/simulated/fake_sky/virgo3b/moving/north
	dir = NORTH
/turf/simulated/fake_sky/virgo3b/moving/south
	dir = SOUTH
/turf/simulated/fake_sky/virgo3b/moving/east
	dir = EAST
/turf/simulated/fake_sky/virgo3b/moving/west
	dir = WEST

//Rift Variant
/turf/simulated/fake_sky/lythios43c
	color = "#DAFFFA"

/turf/simulated/fake_sky/lythios43c/Initialize()
	. = ..()
	set_light(2, 2, src.color)

/turf/simulated/fake_sky/lythios43c/north
	dir = NORTH
/turf/simulated/fake_sky/lythios43c/south
	dir = SOUTH
/turf/simulated/fake_sky/lythios43c/east
	dir = EAST
/turf/simulated/fake_sky/lythios43c/west
	dir = WEST

/turf/simulated/fake_sky/lythios43c/moving
	icon_state = "sky_fast"
/turf/simulated/fake_sky/lythios43c/moving/north
	dir = NORTH
/turf/simulated/fake_sky/lythios43c/moving/south
	dir = SOUTH
/turf/simulated/fake_sky/lythios43c/moving/east
	dir = EAST
/turf/simulated/fake_sky/lythios43c/moving/west
	dir = WEST

//Triumph Variant. Unused Currently
/turf/simulated/fake_sky/triumph
	color = "#FFBBBB"

/turf/simulated/fake_sky/triumph/Initialize(mapload)
	. = ..()
	set_light(2, 2, src.color)

/turf/simulated/fake_sky/triumph/north
	dir = NORTH
/turf/simulated/fake_sky/triumph/south
	dir = SOUTH
/turf/simulated/fake_sky/triumph/east
	dir = EAST
/turf/simulated/fake_sky/triumph/west
	dir = WEST

/turf/simulated/fake_sky/triumph/moving
	icon_state = "sky_fast"
/turf/simulated/fake_sky/triumph/moving/north
	dir = NORTH
/turf/simulated/fake_sky/triumph/moving/south
	dir = SOUTH
/turf/simulated/fake_sky/triumph/moving/east
	dir = EAST
/turf/simulated/fake_sky/triumph/moving/west
	dir = WEST
