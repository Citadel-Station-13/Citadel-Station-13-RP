//Atmosphere defines for magmatic rift station

/datum/atmosphere/planet/magmatic_rift
    base_gases = list(
    /datum/gas/chlorine = 0.37,
    /datum/gas/nitrogen = 0.10,
    /datum/gas/carbon_dioxide = 0.60,
    /datum/gas/xenon = 0.03
    )
    base_target_pressure = 200
    minimum_pressure = 192.5
    maximum_pressure = 248.9
    minimum_temp = 417
    maximum_temp = 429

//Turfmakers
#define MAGMATIC_RIFT_TURF_CREATE(x)	x/magmatic_rift/initial_gas_mix=ATMOSPHERE_ID_MAGMATIC_RIFT;x/magmatic_rift/outdoors=TRUE
#define MAGMATIC_RIFT_TURF_CREATE_UN(x)	x/magmatic_rift/initial_gas_mix=ATMOSPHERE_ID_MAGMATIC_RIFT

//MAGMATIC_RIFT_TURF_CREATE(/turf/simulated/open)
