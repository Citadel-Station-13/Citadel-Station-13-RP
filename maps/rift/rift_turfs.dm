//Simulated
LYTHIOS43C_TURF_CREATE(/turf/simulated/open)
/turf/simulated/open/lythios43c
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf
/turf/simulated/open/lythios43c/New()
	..()
	if(outdoors)
		SSplanets.addTurf(src)

LYTHIOS43C_TURF_CREATE(/turf/simulated/floor)

/turf/simulated/floor/lythios43c_indoors
	LYTHIOS43C_SET_ATMOS
/turf/simulated/floor/lythios43c_indoors/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	return 0

LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/reinforced)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/snow)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/ice)
/turf/simulated/floor/outdoors/snow
	turf_layers = list(
		/turf/simulated/floor/outdoors/ice/lythios43c
		)

/turf/simulated/icerock
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB
/turf/simulated/floor/outdoors
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB

LYTHIOS43C_TURF_CREATE(/turf/simulated/icerock)
LYTHIOS43C_TURF_CREATE(/turf/simulated/icerock/floor)
	//This proc is responsible for ore generation on surface turfs
/turf/simulated/icerock/lythios43c/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 20,
			"carbon" = 20,
			"diamond" = 1,
			"gold" = 8,
			"silver" = 8,
			"phoron" = 18))
	else
		mineral_name = pickweight(list(
			"uranium" = 5,
			"platinum" = 5,
			"hematite" = 35,
			"carbon" = 35,
			"gold" = 3,
			"silver" = 3,
			"phoron" = 25))
	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/turf/simulated/icerock/lythios43c/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 10,
			"carbon" = 10,
			"diamond" = 4,
			"gold" = 15,
			"silver" = 15))
	else
		mineral_name = pickweight(list(
			"uranium" = 7,
			"platinum" = 7,
			"hematite" = 28,
			"carbon" = 28,
			"diamond" = 2,
			"gold" = 7,
			"silver" = 7))
	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	update_icon()

//Unsimulated
/turf/unsimulated/wall/planetary/lythios43c
	name = "facility wall"
	desc = "An eight-meter tall carbyne wall. For when the wildlife on your planet is mostly militant megacorps."
	alpha = 0xFF
	LYTHIOS43C_SET_ATMOS

/turf/unsimulated/icerock/lythios43c
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
	icon_state = "bluespace"
/turf/space/bluespace/initialize()
	..()
	icon_state = "bluespace"

// Desert jump turf!
/turf/space/sandyscroll
	name = "sand transit"
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "desert_ns"
/turf/space/sandyscroll/initialize()
	..()
	icon_state = "desert_ns"

//Sky stuff!
/turf/simulated/sky/lythios43c
	color = "#DAFFFA"

/turf/simulated/sky/lythios43c/initialize()
	SSplanets.addTurf(src)
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
