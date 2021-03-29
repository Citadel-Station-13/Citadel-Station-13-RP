/* this seems to be the turf default atmos, so this must be neutral to prevent forcing atmos conditions on future planets
	i don't know why this was lazily assigned as the default, but these values need to be habitable
*/
/datum/atmosphere/planet/virgo3b
	base_gases = list(
	/datum/gas/oxygen = 0.22,
	/datum/gas/nitrogen = 0.78
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 293.3
	maximum_temp = 307.3

//Turfmakers
#define VIRGO3B_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_VIRGO3B
#define VIRGO3B_TURF_CREATE(x)	x/virgo3b/initial_gas_mix=ATMOSPHERE_ID_VIRGO3B;x/virgo3b/outdoors=TRUE
#define VIRGO3B_TURF_CREATE_UN(x)	x/virgo3b/initial_gas_mix=ATMOSPHERE_ID_VIRGO3B

VIRGO3B_TURF_CREATE(/turf/simulated/open)
VIRGO3B_TURF_CREATE(/turf/simulated/floor)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/reinforced)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
VIRGO3B_TURF_CREATE(/turf/simulated/floor/outdoors/grass/sif)
VIRGO3B_TURF_CREATE(/turf/simulated/mineral)
VIRGO3B_TURF_CREATE(/turf/simulated/mineral/floor)
