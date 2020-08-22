// Be sure to update planetary_vr.dm and atmosphers.dm when switching to this map.


//Simulated
TRIUMPH_TURF_CREATE(/turf/simulated/open)
/turf/simulated/open/triumph
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf
/turf/simulated/open/triumph/Initialize(mapload)
	. = ..()
	if(outdoors)
		SSplanets.addTurf(src)

TRIUMPH_TURF_CREATE(/turf/simulated/floor)

/turf/simulated/floor/triumph_indoors
	TRIUMPH_SET_ATMOS
	allow_gas_overlays = FALSE

TRIUMPH_TURF_CREATE(/turf/simulated/floor/reinforced)
TRIUMPH_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)

TRIUMPH_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
TRIUMPH_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
TRIUMPH_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
/turf/simulated/floor/outdoors/grass/sif
	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks/triumph,
		/turf/simulated/floor/outdoors/dirt/triumph
		)



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

TRIUMPH_TURF_CREATE(/turf/simulated/mineral)
TRIUMPH_TURF_CREATE(/turf/simulated/mineral/floor)
	//This proc is responsible for ore generation on surface turfs
/turf/simulated/mineral/triumph/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"marble" = 3,
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 20,
			"carbon" = 20,
			"diamond" = 1,
			"gold" = 8,
			"silver" = 8,
			"phoron" = 18,
			"lead" = 2,
			"verdantium" = 1))
	else
		mineral_name = pickweight(list(
			"marble" = 2,
			"uranium" = 5,
			"platinum" = 5,
			"hematite" = 35,
			"carbon" = 35,
			"gold" = 3,
			"silver" = 3,
			"phoron" = 25,
			"lead" = 1))
	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/turf/simulated/mineral/triumph/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"marble" = 7,
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 10,
			"carbon" = 10,
			"diamond" = 4,
			"gold" = 15,
			"silver" = 15,
			"lead" = 5,
			"verdantium" = 2))
	else
		mineral_name = pickweight(list(
			"marble" = 5,
			"uranium" = 7,
			"platinum" = 7,
			"hematite" = 28,
			"carbon" = 28,
			"diamond" = 2,
			"gold" = 7,
			"silver" = 7,
			"lead" = 4,
			"verdantium" = 1))
	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	update_icon()

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
	icon = 'icons/turf/space_vr.dmi'
	icon_state = "bluespace"
/turf/space/bluespace/Initialize()
	..()
	icon = 'icons/turf/space_vr.dmi'
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
// A simple turf to fake the appearance of flying.
/turf/simulated/sky/triumph
	color = "#FFBBBB"

/turf/simulated/sky/triumph/Initialize()
	SSplanets.addTurf(src)
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
