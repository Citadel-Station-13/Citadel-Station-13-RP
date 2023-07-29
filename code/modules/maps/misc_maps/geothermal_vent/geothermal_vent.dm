
#define GEOTHERMAL_TEMP 2473.15

/datum/atmosphere/geothermal_vent
		base = list(
		/datum/gas/carbon_dioxide = 0.5,
		/datum/gas/sulfur_dioxide = 0.34,
		/datum/gas/carbon_monoxide = 0.16,
	)
	pressure_high = 376.9
	pressure_low = 376.9
	temperature_low = GEOTHERMAL_TEMP - 10
	temperature_high = GEOTHERMAL_TEMP + 10

//Turfmakers
#define GEOTHERMAL_SET_ATMOS	initial_gas_mix = ATMOSPHERE_ID_GEOTHERMAL
#define GEOTHERMAL_TURF_CREATE(x)	x/geothermal/initial_gas_mix=ATMOSPHERE_ID_GEOTHERMAL;x/geothermal/outdoors=TRUE;x/geothermal/special_temperature=GEOTHERMAL_TEMP;
#define GEOTHERMAL_TURF_CREATE_UN(x)	x/geothermal/initial_gas_mix=ATMOSPHERE_ID_GEOTHERMAL;x/geothermal/outdoors=FALSE;x/geothermal/special_temperature=GEOTHERMAL_TEMP

GEOTHERMAL_TURF_CREATE_UN(/turf/simulated/open)
GEOTHERMAL_TURF_CREATE_UN(/turf/simulated/floor/outdoors/lava/indoors)
GEOTHERMAL_TURF_CREATE_UN(/turf/simulated/floor/outdoors/rocks/caves)
GEOTHERMAL_TURF_CREATE_UN(/turf/unsimulated/floor/lava)
GEOTHERMAL_TURF_CREATE_UN(/turf/simulated/mineral/ignore_cavegen)

/turf/unsimulated/floor/lava
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "lava"
	var/special_temperature
