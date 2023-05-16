
#define VIRGO3B_TURF_CREATE(x)	x/virgo3b/initial_gas_mix=ATMOSPHERE_ID_VIRGO3B;x/virgo3b/outdoors=TRUE
#define VIRGO3B_TURF_CREATE_UN(x)	x/virgo3b/initial_gas_mix=ATMOSPHERE_ID_VIRGO3B

VIRGO3B_TURF_CREATE(/turf/simulated/open)
VIRGO3B_TURF_CREATE(/turf/simulated/floor)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/reinforced)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/techfloor/grid)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/maglev)

VIRGO3B_TURF_CREATE_UN(/turf/simulated/floor/wood)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/floor/wood/sif)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/mineral)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/mineral/rich)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/mineral/floor)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/mineral/ignore_oregen)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/mineral/floor/ignore_oregen)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/mineral/ignore_cavegen)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/mineral/floor/ignore_cavegen)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/floor/tiled/freezer)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/shuttle/floor/voidcraft)
VIRGO3B_TURF_CREATE_UN(/turf/simulated/floor/tiled/kafel_full/yellow)



/turf/simulated/open/virgo3b
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf

/turf/simulated/floor/virgo3b_indoors
	initial_gas_mix = ATMOSPHERE_ID_VIRGO3B

/turf/simulated/floor/outdoors/dirt/virgo3b
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/simulated/floor/outdoors/grass/sif
	baseturfs = /turf/simulated/floor/outdoors/dirt/virgo3b

/turf/simulated/mineral/rich/indoors
	outdoors = FALSE

//Unsimulated
/turf/unsimulated/mineral/virgo3b
	blocks_air = TRUE

/turf/simulated/mineral/virgo3b/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	outdoors = FALSE
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
		UpdateMineral()

