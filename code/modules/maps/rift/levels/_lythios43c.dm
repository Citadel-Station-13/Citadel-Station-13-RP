/datum/atmosphere/planet/lythios43c
	base_gases = list(
	/datum/gas/nitrogen = 0.64,
	/datum/gas/oxygen = 0.32,
	/datum/gas/carbon_dioxide = 0.04
	)
	base_target_pressure = 76.9
	minimum_pressure = 76.9
	maximum_pressure = 76.9
	minimum_temp = 116.15
	maximum_temp = 131.15

//Turfmakers
#define LYTHIOS43C_TURF_CREATE(x)	x/lythios43c/initial_gas_mix=ATMOSPHERE_ID_LYTHIOS43C;x/lythios43c/outdoors=TRUE
#define LYTHIOS43C_TURF_CREATE_UN(x)	x/lythios43c/initial_gas_mix=ATMOSPHERE_ID_LYTHIOS43C

LYTHIOS43C_TURF_CREATE(/turf/simulated/open)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/reinforced)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/snow)
LYTHIOS43C_TURF_CREATE(/turf/unsimulated/floor/outdoors/snow)
LYTHIOS43C_TURF_CREATE(/turf/simulated/floor/outdoors/ice)
LYTHIOS43C_TURF_CREATE(/turf/unsimulated/floor/outdoors/ice)
LYTHIOS43C_TURF_CREATE(/turf/simulated/mineral)
LYTHIOS43C_TURF_CREATE(/turf/simulated/mineral/floor)
