/datum/atmosphere/planet/lavaland
	base_gases = list(
	/datum/gas/oxygen = 0.22,
	/datum/gas/nitrogen = 0.78
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 293.3
	maximum_temp = 350.1

#define LAVALAND_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_LAVALAND
#define LAVALAND_TURF_CREATE(x)	x/lavaland/initial_gas_mix=ATMOSPHERE_ID_LAVALAND

LAVALAND_TURF_CREATE(/turf/simulated/shuttle/floor)
LAVALAND_TURF_CREATE(/turf/simulated/shuttle/wall)
LAVALAND_TURF_CREATE(/turf/simulated/wall)
LAVALAND_TURF_CREATE(/turf/simulated/wall/wood)
LAVALAND_TURF_CREATE(/turf/simulated/wall/sandstone)
LAVALAND_TURF_CREATE(/turf/simulated/wall/sandstonediamond)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/desert)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/grass)
LAVALAND_TURF_CREATE(/turf/simulated/floor/water)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/lava)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/water/deep)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/water/shoreline)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/water/shoreline/corner)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/beach/sand/dirt)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/dirt)
LAVALAND_TURF_CREATE(/turf/simulated/floor/outdoors/rocks)
LAVALAND_TURF_CREATE(/turf/simulated/floor/plating)
LAVALAND_TURF_CREATE(/turf/simulated/floor/wood)
LAVALAND_TURF_CREATE(/turf/simulated/floor/wood/broken)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled)
LAVALAND_TURF_CREATE(/turf/simulated/tiled/old_tile)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/monotile)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/dark)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/steel_grid)
LAVALAND_TURF_CREATE(/turf/simulated/floor)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet/bcarpet)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet/blucarpet)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet/purcarpet)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/floor/lavaland)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/floor/cave/lavaland)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen/lavaland)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/triumph)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/triumph/rich)
LAVALAND_TURF_CREATE(/turf/simulated/floor/bluegrid)
LAVALAND_TURF_CREATE(/turf/simulated/floor/greengrid)
LAVALAND_TURF_CREATE(/turf/unsimulated/mineral/triumph)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/)
