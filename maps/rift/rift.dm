#if !defined(USING_MAP_DATUM)

	#include "rift_defines.dm"
	#include "rift_shuttle_defs.dm"
	#include "rift_shuttles.dm"
	#include "rift_telecomms.dm"
	#include "rift_weather.dm"
	#include "../../maps/submaps/engine_submaps/rift/rift_engine_submaps.dm"

	#define USING_MAP_DATUM /datum/map/rift

	#include "../../maps/map_files/rift/rift-01-underground3.dmm"
	#include "../../maps/map_files/rift/rift-02-underground2.dmm"
	#include "../../maps/map_files/rift/rift-03-underground1.dmm"
	#include "../../maps/map_files/rift/rift-04-surface1.dmm"
	#include "../../maps/map_files/rift/rift-05-surface2.dmm"
	#include "../../maps/map_files/rift/rift-06-surface3.dmm"
	#include "../../maps/map_files/rift/rift-07-west_base.dmm"
	#include "../../maps/map_files/rift/rift-08-west_deep.dmm"
	#include "../../maps/map_files/rift/rift-09-west_caves.dmm"
	#include "../../maps/map_files/rift/rift-10-west_plains.dmm"
	#include "../../maps/map_files/rift/rift-11-orbital.dmm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Rift

#endif
