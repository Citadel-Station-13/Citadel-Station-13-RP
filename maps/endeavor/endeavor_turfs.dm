/turf/unsimulated/floor/steel
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel"




//Mining Turfs
/turf/simulated/mineral/vacuum
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB

/turf/simulated/mineral/vacuum/rich
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB

/turf/simulated/mineral/floor/vacuum
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB
	ignore_mapgen = TRUE//Stop spawning ore on my lawn

/turf/simulated/mineral/vacuum/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 20,
			"carbon" = 20,
			"diamond" = 2,
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

/turf/simulated/mineral/vacuum/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			"uranium" = 10,
			"platinum" = 10,
			"hematite" = 10,
			"carbon" = 10,
			"diamond" = 6,
			"gold" = 15,
			"silver" = 15,
			"phoron" = 6))
	else
		mineral_name = pickweight(list(
			"uranium" = 7,
			"platinum" = 7,
			"hematite" = 25,
			"carbon" = 25,
			"diamond" = 2,
			"gold" = 7,
			"silver" = 7,
			"phoron" = 2))
	if(mineral_name && (mineral_name in ore_data))
		mineral = ore_data[mineral_name]
		UpdateMineral()
	update_icon()

//For the edges of mining to fix the caves filling with air
/turf/unsimulated/mineral/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = T0C


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

/turf/space/sandyscroll/southnorth
	name = "sand transit"
	icon = 'maps/endeavor/endeavor_turfs.dmi'
	icon_state = "desert_sn"
/turf/space/sandyscroll/Initialize()
	..()
	icon_state = "desert_sn"

//Sky stuff!
// A simple turf to fake the appearance of flying.
/turf/simulated/sky/odin5
	color = "#FFBBBB"

/turf/simulated/sky/odin5/Initialize()
	SSplanets.addTurf(src)
	set_light(2, 2, "#FFBBBB")

/turf/simulated/sky/odin5/north
	dir = NORTH
/turf/simulated/sky/odin5/south
	dir = SOUTH
/turf/simulated/sky/odin5/east
	dir = EAST
/turf/simulated/sky/odin5/west
	dir = WEST

/turf/simulated/sky/odin5/moving
	icon_state = "sky_fast"
/turf/simulated/sky/odin5/moving/north
	dir = NORTH
/turf/simulated/sky/odin5/moving/south
	dir = SOUTH
/turf/simulated/sky/odin5/moving/east
	dir = EAST
/turf/simulated/sky/odin5/moving/west
	dir = WEST
