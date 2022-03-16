/datum/atmosphere/planet/classg
	base_gases = list(
	/datum/gas/oxygen = 10,
	/datum/gas/nitrogen = 10,
	/datum/gas/phoron = 80
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 293.3
	maximum_temp = 307.3

#define MININGPLANET_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_MININGPLANET
#define MININGPLANET_TURF_CREATE(x)	x/classg/initial_gas_mix=ATMOSPHERE_ID_MININGPLANET

MININGPLANET_TURF_CREATE(/turf/simulated/wall)
MININGPLANET_TURF_CREATE(/turf/simulated/mineral/triumph)
MININGPLANET_TURF_CREATE(/turf/simulated/mineral/rich/triumph)
MININGPLANET_TURF_CREATE(/turf/simulated/mineral/floor)
MININGPLANET_TURF_CREATE(/turf/simulated/mineral/floor/ignore_cavegen)
