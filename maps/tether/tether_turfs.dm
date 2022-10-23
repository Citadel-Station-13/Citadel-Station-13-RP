/* Moved to code/modules/maps/tether/levels
//Simulated
VIRGO3B_TURF_CREATE(/turf/simulated/open)
/turf/simulated/open/virgo3b
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf
/turf/simulated/open/virgo3b/Initialize(mapload)
	. = ..()
	if(outdoors)
		SSplanets.addTurf(src)

VIRGO3B_TURF_CREATE(/turf/simulated/floor)

/turf/simulated/floor/virgo3b_indoors
	initial_gas_mix = ATMOSPHERE_ID_VIRGO3B

///turf/simulated/floor/virgo3b_indoors/update_graphic(list/graphic_add = null, list/graphic_remove = null)
//	return 0

VIRGO3B_TURF_CREATE(/turf/simulated/floor/reinforced)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
/turf/simulated/floor/tiled/steel_dirty/virgo3b
	outdoors = TRUE

VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/techfloor/grid)
/turf/simulated/floor/tiled/techfloor/grid/virgo3b
	outdoors = TRUE

VIRGO3B_TURF_CREATE(/turf/simulated/floor/maglev)
/turf/simulated/floor/maglev/virgo3b
	outdoors = TRUE

/turf/simulated/floor/wood/virgo3b
	initial_gas_mix = ATMOSPHERE_ID_VIRGO3B

/turf/simulated/floor/wood/sif/virgo3b
	initial_gas_mix = ATMOSPHERE_ID_VIRGO3B

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
/turf/simulated/floor/outdoors/dirt/virgo3b
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)

VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
/turf/simulated/floor/outdoors/grass/sif
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/virgo3b,
		/turf/simulated/floor/outdoors/dirt/virgo3b
		)

// Overriding these for the sake of submaps that use them on other planets.
// This means that mining on tether base and space is oxygen-generating, but solars and mining should use the virgo3b subtype
/turf/simulated/mineral
	initial_gas_mix = GAS_STRING_STP

/turf/simulated/floor/outdoors
	initial_gas_mix = GAS_STRING_STP

/turf/simulated/floor/water
	initial_gas_mix = GAS_STRING_STP

/turf/simulated/mineral/vacuum
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/mineral/floor/vacuum
	initial_gas_mix = GAS_STRING_VACUUM


VIRGO3B_TURF_CREATE(/turf/simulated/mineral)
VIRGO3B_TURF_CREATE(/turf/simulated/mineral/floor)
	//This proc is responsible for ore generation on surface turfs
/turf/simulated/mineral/virgo3b/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	outdoors = TRUE
	if(rare_ore)
		mineral_name = pickweight(list(
			MAT_MARBLE = 3,
			MAT_URANIUM = 10,
			MAT_PLATINUM = 10,
			MAT_HEMATITE = 20,
			MAT_CARBON = 20,
			MAT_DIAMOND = 1,
			MAT_GOLD = 8,
			MAT_SILVER = 8,
			MAT_PHORON = 18,
			MAT_LEAD = 2,
			MAT_VERDANTIUM = 1))
	else
		mineral_name = pickweight(list(
			MAT_MARBLE = 2,
			MAT_URANIUM = 5,
			MAT_PLATINUM = 5,
			MAT_HEMATITE = 35,
			MAT_CARBON = 35,
			MAT_GOLD = 3,
			MAT_SILVER = 3,
			MAT_PHORON = 25,
			MAT_LEAD = 1))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		if(flags & INITIALIZED)
			UpdateMineral()

turf/simulated/mineral/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			MAT_MARBLE = 7,
			MAT_URANIUM = 10,
			MAT_PLATINUM = 10,
			MAT_HEMATITE = 10,
			MAT_CARBON = 10,
			MAT_DIAMOND = 4,
			MAT_GOLD = 15,
			MAT_SILVER = 15,
			MAT_LEAD = 5,
			MAT_VERDANTIUM = 2))
	else
		mineral_name = pickweight(list(
			MAT_MARBLE = 5,
			MAT_URANIUM = 7,
			MAT_PLATINUM = 7,
			MAT_HEMATITE = 28,
			MAT_CARBON = 28,
			MAT_DIAMOND = 2,
			MAT_GOLD = 7,
			MAT_SILVER = 7,
			MAT_LEAD = 4,
			MAT_VERDANTIUM = 1))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		if(flags & INITIALIZED)
			UpdateMineral()

//Unsimulated
/turf/unsimulated/mineral/virgo3b
	blocks_air = TRUE

/turf/unsimulated/floor/steel
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel"

/turf/simulated/mineral/virgo3b/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			MAT_MARBLE = 7,
			MAT_URANIUM = 10,
			MAT_PLATINUM = 10,
			MAT_HEMATITE = 10,
			MAT_CARBON = 10,
			MAT_DIAMOND = 4,
			MAT_GOLD = 15,
			MAT_SILVER = 15,
			MAT_LEAD = 5,
			MAT_VERDANTIUM = 2))
	else
		mineral_name = pickweight(list(
			MAT_MARBLE = 5,
			MAT_URANIUM = 7,
			MAT_PLATINUM = 7,
			MAT_HEMATITE = 28,
			MAT_CARBON = 28,
			MAT_DIAMOND = 2,
			MAT_GOLD = 7,
			MAT_SILVER = 7,
			MAT_LEAD = 4,
			MAT_VERDANTIUM = 1))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		if(flags & INITIALIZED)
			UpdateMineral()

// Some turfs to make floors look better in centcom tram station.

/turf/unsimulated/floor/techfloor_grid
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
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
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"

/turf/space/bluespace/Initialize(mapload)
	. = ..()
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"

// Desert jump turf!
/turf/space/sandyscroll
	name = "sand transit"
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "desert_ns"

/turf/space/sandyscroll/Initialize(mapload)
	. = ..()
	icon_state = "desert_ns"

//Sky stuff!
// A simple turf to fake the appearance of flying.
/turf/simulated/sky/virgo3b
	color = "#FFBBBB"

/turf/simulated/sky/virgo3b/Initialize(mapload)
	. = ..()
	SSplanets.addTurf(src)
	set_light(2, 2, "#FFBBBB")

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

/turf/simulated/floor/tiled/techmaint/airless
	initial_gas_mix = GAS_STRING_VACUUM
	temperature = TCMB
