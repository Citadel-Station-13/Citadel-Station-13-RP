
#define LYTHIOS43C_SET_ATMOS	initial_gas_mix = ATMOSPHERE_ID_LYTHIOS43C
#define LYTHIOS43C_TURF_CREATE(x)	x/lythios43c/initial_gas_mix=ATMOSPHERE_ID_LYTHIOS43C;x/lythios43c/outdoors=TRUE
#define LYTHIOS43C_TURF_CREATE_UN(x)	x/lythios43c/initial_gas_mix=ATMOSPHERE_ID_LYTHIOS43C;x/lythios43c/outdoors=FALSE

/turf/simulated/open/lythios43c/Initialize(mapload)
	. = ..()
	if(outdoors)
		SSplanets.addTurf(src)


LYTHIOS43C_TURF_CREATE(/turf/simulated/open)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/reinforced)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/snow)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/ice)
LYTHIOS43C_TURF_CREATE(/turf/simulated/mineral)
LYTHIOS43C_TURF_CREATE(/turf/simulated/mineral/floor)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/sky/depths)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/sky/depths/west)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/plating)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/plasteel)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/tiled/steel_grid)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/tiled/techfloor/grid)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/tiled/techfloor)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/gravsnow)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/snow/noblend)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/snow/noblend/indoors)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/safeice)

//These commands generate turfs that are default indoors
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/tiled)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/trap/wood)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/trap/plating)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/trap/steel)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/tiled/monotile)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/tiled/steel)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/water/deep/indoors)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/water/indoors)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/bluegrid)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/carpet)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/carpet/bcarpet)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/carpet/arcadecarpet)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/wall)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/floor/wood)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/shuttle/floor/voidcraft)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/mineral/icerock)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/mineral/icerock/floor)
LYTHIOS43C_TURF_CREATE_UN(/turf/unsimulated/mineral/icerock)
LYTHIOS43C_TURF_CREATE_UN(/turf/unsimulated/mineral)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/mineral/ignore_cavegen)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/mineral/floor/ignore_cavegen)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/mineral/floor/icerock)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/mineral/icerock/ignore_cavegen)
LYTHIOS43C_TURF_CREATE_UN(/turf/simulated/mineral/icerock/floor/ignore_cavegen)


/turf/simulated/open/lythios43c
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf

/turf/simulated/mineral/icerock/ignore_cavegen/lythios43c
	baseturfs = /turf/simulated/mineral/icerock/floor/ignore_cavegen/lythios43c

/turf/simulated/floor/outdoors/snow/lythios43c
	baseturfs = /turf/simulated/floor/outdoors/safeice/lythios43c
	var/object_spawn_chance = 3

/turf/simulated/floor/outdoors/snow/lythios43c/Initialize(mapload)		/// Handles spawning random objs and such in the snow
	if(object_spawn_chance && prob(object_spawn_chance) && !check_density())
		new /obj/random/snow_debris(src)	///mapping.dm is where this obj's at
	. = ..()

/// Indoor Variants (Cause we need em). It bugs me that outdoor varients are the default but what can you do -Bloop
/turf/simulated/floor/outdoors/safeice/indoors
	outdoors = FALSE /* So that we don't get weather effects for the ice used indoors. Convuluted, I know, but this
	means I don't need another, almost identical turf to be created. */

/turf/simulated/open/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/floor/outdoors/safeice/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/mineral/floor/icerock/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/mineral/floor/icerock/lythios43c/indoors/ignore_cavegen	// I hate having to make such a long typepath for this, very annyoing -Bloop
	ignore_cavegen = TRUE

/turf/simulated/floor/lythios43c/indoors
	outdoors = FALSE


/turf/simulated/floor/outdoors/dirt/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/floor/outdoors/rocks/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/floor/outdoors/snow/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/floor/outdoors/gravsnow/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/mineral/floor/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/floor/plating/indoors
	outdoors = FALSE

/turf/simulated/floor/tiled/techfloor/grid/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/floor/tiled/steel_dirty/lythios43c/indoors
	outdoors = FALSE

/turf/simulated/floor/tiled/techfloor/lythios43c/indoors
	outdoors = FALSE


/// Needs to be remmapped to use /turf/unsimulated/mineral/icerock/lythios43c .
/turf/unsimulated/icerock/lythios43c
	icon = 'icons/turf/walls.dmi'
	icon_state = "icerock-dark"
	blocks_air = TRUE
