
/datum/atmosphere/planet/classp
	base_gases = list(
	/datum/gas/oxygen = 0.23,
	/datum/gas/nitrogen = 0.77
	)
	base_target_pressure = 100.1
	minimum_pressure = 100.1
	maximum_pressure = 100.1
	minimum_temp = 225.3
	maximum_temp = 230.3

#define FROZEN_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_FROZEN
#define FROZEN_TURF_CREATE(x)	x/classp/initial_gas_mix=ATMOSPHERE_ID_FROZEN

FROZEN_TURF_CREATE(/turf/simulated/wall/planetary/frozen)

FROZEN_TURF_CREATE(/turf/simulated/wall)
FROZEN_TURF_CREATE(/turf/simulated/wall/ironphoron)
FROZEN_TURF_CREATE(/turf/simulated/wall/snowbrick)
FROZEN_TURF_CREATE(/turf/simulated/floor)
FROZEN_TURF_CREATE(/turf/simulated/floor/bmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/crystal)
FROZEN_TURF_CREATE(/turf/simulated/floor/gold)
FROZEN_TURF_CREATE(/turf/simulated/floor/phoron)
FROZEN_TURF_CREATE(/turf/simulated/floor/silver)
FROZEN_TURF_CREATE(/turf/simulated/floor/wmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/wood)
FROZEN_TURF_CREATE(/turf/simulated/floor/water/indoors)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/red)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/blue)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/green)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/ice)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/grass/heavy/interior)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/mud)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/shelfice)
FROZEN_TURF_CREATE(/turf/simulated/floor/carpet/purcarpet)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/bmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/crystal)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/gold)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/phoron)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/plating)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/silver)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/wmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/wood)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/bmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/crystal)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/gold)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/phoron)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/plating)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/silver)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/wmarble)
FROZEN_TURF_CREATE(/turf/simulated/floor/trap/delayed/wood)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor/black)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor/purple)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor/red)
FROZEN_TURF_CREATE(/turf/simulated/shuttle/floor/yellow)
FROZEN_TURF_CREATE(/turf/simulated/mineral)
FROZEN_TURF_CREATE(/turf/simulated/mineral/cave)
FROZEN_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
FROZEN_TURF_CREATE(/turf/simulated/mineral/floor)
FROZEN_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

//Exterior Turfs for weather effects.
/turf/simulated/floor/classp/outdoors
	outdoors = TRUE

/turf/simulated/floor/wood/classp/outdoors
	outdoors = TRUE

/turf/simulated/floor/outdoors/snow/classp/no_tree
	tree_chance = 0
	deadtree_chance = 0

/turf/simulated/floor/old_tile/red/outdoors
	outdoors = TRUE

/turf/simulated/floor/old_tile/blue/outdoors
	outdoors = TRUE

/turf/simulated/floor/old_tile/green/outdoors
	outdoors = TRUE

/turf/simulated/floor/outdoors/mud/classp/indoors
	outdoors = FALSE

/turf/simulated/floor/outdoors/ice/classp/indoors
	outdoors = FALSE

/turf/simulated/floor/water/acid/classp/indoors
	outdoors = FALSE

/turf/simulated/floor/water/acid/deep/classp/indoors
	outdoors = FALSE
