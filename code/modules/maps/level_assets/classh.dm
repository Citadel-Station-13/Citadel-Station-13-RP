/datum/atmosphere/planet/classh
	base_gases = list(
	/datum/gas/oxygen = 0.24,
	/datum/gas/nitrogen = 0.72,
	/datum/gas/carbon_dioxide = 0.04
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 317.3 //Barely enough to avoid baking Teshari
	maximum_temp = 317.3

//Turfmakers
#define DESERT_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_CLASSH
#define DESERT_TURF_CREATE(x)	x/classh/initial_gas_mix=ATMOSPHERE_ID_DESERT

DESERT_TURF_CREATE(/turf/simulated/wall/planetary)
DESERT_TURF_CREATE(/turf/simulated/wall)
DESERT_TURF_CREATE(/turf/simulated/wall/sandstone)
DESERT_TURF_CREATE(/turf/simulated/wall/sandstonediamond)
DESERT_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/desert)
DESERT_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/dirt)
DESERT_TURF_CREATE(/turf/simulated/floor/wood)
DESERT_TURF_CREATE(/turf/simulated/floor/tiled)
DESERT_TURF_CREATE(/turf/simulated/floor)
DESERT_TURF_CREATE(/turf/simulated/floor/water)
DESERT_TURF_CREATE(/turf/simulated/floor/water/deep)
DESERT_TURF_CREATE(/turf/simulated/floor/water/shoreline)
DESERT_TURF_CREATE(/turf/simulated/floor/water/shoreline/corner)
DESERT_TURF_CREATE(/turf/simulated/mineral)
DESERT_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
DESERT_TURF_CREATE(/turf/simulated/mineral/floor)
DESERT_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

