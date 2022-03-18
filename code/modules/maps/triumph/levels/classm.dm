/datum/atmosphere/planet/classm
	base_gases = list(
	/datum/gas/oxygen = 0.22,
	/datum/gas/nitrogen = 0.78
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 293.3
	maximum_temp = 307.3

#define GAIA_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_GAIA
#define GAIA_TURF_CREATE(x)	x/classm/initial_gas_mix=ATMOSPHERE_ID_GAIA

GAIA_TURF_CREATE(/turf/simulated/wall/planetary/gaia)

GAIA_TURF_CREATE(/turf/simulated/wall)
GAIA_TURF_CREATE(/turf/simulated/wall/sandstone)
GAIA_TURF_CREATE(/turf/simulated/wall/sandstonediamond)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/desert)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/grass)
GAIA_TURF_CREATE(/turf/simulated/floor/wood)
GAIA_TURF_CREATE(/turf/simulated/floor/tiled)
GAIA_TURF_CREATE(/turf/simulated/floor)
GAIA_TURF_CREATE(/turf/simulated/floor/water)
GAIA_TURF_CREATE(/turf/simulated/floor/water/deep)
GAIA_TURF_CREATE(/turf/simulated/floor/water/shoreline)
GAIA_TURF_CREATE(/turf/simulated/floor/water/shoreline/corner)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand)
GAIA_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
GAIA_TURF_CREATE(/turf/simulated/mineral)
GAIA_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
GAIA_TURF_CREATE(/turf/simulated/mineral/floor)
GAIA_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

//Exterior Turfs for weather effects.
/turf/simulated/floor/tiled/classm/outdoors
	outdoors = TRUE

/turf/simulated/floor/wood/classm/outdoors
	outdoors = TRUE
