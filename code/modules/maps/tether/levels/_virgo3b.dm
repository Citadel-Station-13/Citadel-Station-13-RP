/* this seems to be the turf default atmos, so this must be neutral to prevent forcing atmos conditions on future planets
	i don't know why this was lazily assigned as the default, but these values need to be habitable
*/

/datum/atmosphere/planet/virgo3b
	base_gases = list(
	/datum/gas/nitrogen = 0.16,
	/datum/gas/phoron = 0.72,
	/datum/gas/carbon_dioxide = 0.12
	)
	base_target_pressure = 82.4
	minimum_pressure = 82.4
	maximum_pressure = 82.4
	minimum_temp = 234
	maximum_temp = 234

//Turfmakers
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
