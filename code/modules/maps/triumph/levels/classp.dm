
/datum/atmosphere/planet/classp
	base_gases = list(
	/datum/gas/oxygen = 0.23,
	/datum/gas/nitrogen = 0.77
	)
	base_target_pressure = 100.1
	minimum_pressure = 100.1
	maximum_pressure = 100.1
	minimum_temp = 259.3
	maximum_temp = 269.3

#define FROZEN_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_FROZEN
#define FROZEN_TURF_CREATE(x)	x/classp/initial_gas_mix=ATMOSPHERE_ID_FROZEN

FROZEN_TURF_CREATE(/turf/simulated/wall/planetary/frozen)

FROZEN_TURF_CREATE(/turf/simulated/wall)
FROZEN_TURF_CREATE(/turf/simulated/wall/snowbrick)
FROZEN_TURF_CREATE(/turf/simulated/floor)
FROZEN_TURF_CREATE(/turf/simulated/floor/wood)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/red)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/red)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/blue)
FROZEN_TURF_CREATE(/turf/simulated/floor/old_tile/green)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/ice)
FROZEN_TURF_CREATE(/turf/simulated/floor/outdoors/shelfice)
FROZEN_TURF_CREATE(/turf/simulated/mineral)
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
