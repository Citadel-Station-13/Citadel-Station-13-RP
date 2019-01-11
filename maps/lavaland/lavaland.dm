#if !defined(USING_MAP_DATUM)

	#include "lavaland.dmm"

	#include "lavaland_defines.dm"
	#include "lavaland_elevator.dm"
	#include "lavaland_areas.dm"


	#define USING_MAP_DATUM /datum/map/lavaland

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Northern Star

#endif