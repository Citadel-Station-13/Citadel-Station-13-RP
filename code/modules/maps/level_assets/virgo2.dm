/datum/atmosphere/planet/virgo2
	base_gases = list(
	/datum/gas/nitrogen = 0.10,
	/datum/gas/oxygen = 0.03,
	/datum/gas/carbon_dioxide = 0.87
	)
	base_target_pressure = 312.1
	minimum_pressure = 312.1
	maximum_pressure = 312.1
	minimum_temp = 612
	maximum_temp = 612

// Turfmakers
#define VIRGO2_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_VIRGO2
#define VIRGO2_TURF_CREATE(x)	x/virgo2/initial_gas_mix=ATMOSPHERE_ID_VIRGO2;x/virgo2/color="#eacd7c"

VIRGO2_TURF_CREATE(/turf/unsimulated/wall/planetary)
VIRGO2_TURF_CREATE(/turf/simulated/wall)
VIRGO2_TURF_CREATE(/turf/simulated/floor/plating)
VIRGO2_TURF_CREATE(/turf/simulated/floor/bluegrid)
VIRGO2_TURF_CREATE(/turf/simulated/floor/tiled/techfloor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor)
VIRGO2_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)
