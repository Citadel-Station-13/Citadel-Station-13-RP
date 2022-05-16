// Be sure to update planetary_vr.dm and atmosphers.dm when switching to this map.
/turf/simulated/open/triumph
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf

/turf/simulated/open/triumph/Initialize(mapload)
	. = ..()
	if(outdoors)
		SSplanets.addTurf(src)

/turf/simulated/floor/triumph_indoors
	TRIUMPH_SET_ATMOS
	allow_gas_overlays = FALSE

/turf/simulated/floor/outdoors/grass/sif
	baseturfs = /turf/simulated/floor/outdoors/dirt

// Overriding these for the sake of submaps that use them on other planets.
// This means that mining on tether base and space is oxygen-generating, but solars and mining should use the triumph subtype
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

	//This proc is responsible for ore generation on surface turfs
/turf/simulated/mineral/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	outdoors = TRUE
	if(rare_ore)
		mineral_name = pickweight(list(
			MAT_CARBON = 20,
			MAT_COPPER = 10,
			MAT_DIAMOND = 1,
			MAT_GOLD = 8,
			MAT_HEMATITE = 20,
			MAT_LEAD = 2,
			MAT_MARBLE = 3,
			MAT_PHORON = 18,
			MAT_PLATINUM = 10,
			MAT_SILVER = 8,
			MAT_URANIUM = 10,
			MAT_VERDANTIUM = 1))
	else
		mineral_name = pickweight(list(
			MAT_CARBON = 35,
			MAT_COPPER = 5,
			MAT_GOLD = 3,
			MAT_HEMATITE = 35,
			MAT_LEAD = 1,
			MAT_MARBLE = 2,
			MAT_PHORON = 25,
			MAT_PLATINUM = 5,
			MAT_SILVER = 3,
			MAT_URANIUM = 5))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()

/turf/simulated/mineral/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			MAT_CARBON = 10,
			MAT_COPPER = 10,
			MAT_DIAMOND = 4,
			MAT_GOLD = 15,
			MAT_HEMATITE = 10,
			MAT_LEAD = 5,
			MAT_MARBLE = 7,
			MAT_PLATINUM = 10,
			MAT_SILVER = 15,
			MAT_URANIUM = 10,
			MAT_VERDANTIUM = 2))
	else
		mineral_name = pickweight(list(
			MAT_CARBON = 28,
			MAT_COPPER = 7,
			MAT_DIAMOND = 2,
			MAT_GOLD = 7,
			MAT_HEMATITE = 28,
			MAT_LEAD = 4,
			MAT_MARBLE = 5,
			MAT_PLATINUM = 7,
			MAT_SILVER = 7,
			MAT_URANIUM = 7,
			MAT_VERDANTIUM = 1))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()

//Unsimulated
/turf/unsimulated/wall/planetary/triumph
	name = "facility wall"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	alpha = 0xFF
	TRIUMPH_SET_ATMOS

/turf/unsimulated/mineral/triumph
	blocks_air = TRUE

/turf/unsimulated/floor/steel
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel"


/turf/unsimulated/wall
	blocks_air = 1

/turf/unsimulated/wall/planetary
	blocks_air = 0

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
/turf/simulated/sky/triumph
	color = "#FFBBBB"

/turf/simulated/sky/triumph/Initialize(mapload)
	. = ..()
	set_light(2, 2, "#FFBBBB")

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
