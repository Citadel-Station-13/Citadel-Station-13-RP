#if !defined(USING_MAP_DATUM)

	#include "triumph_defines.dm"
	#include "triumph_shuttle_defs.dm"
	#include "triumph_shuttles.dm"
	#include "triumph_telecomms.dm"
	#include "triumph_overmap.dm"
	#include "triumph_weather.dm"

	#define USING_MAP_DATUM /datum/map/triumph

	#include "../../_maps/map_files/triumph/triumph-01-deck1.dmm"
	#include "../../_maps/map_files/triumph/triumph-02-deck2.dmm"
	#include "../../_maps/map_files/triumph/triumph-03-deck3.dmm"
	#include "../../_maps/map_files/triumph/triumph-04-deck4.dmm"
	#include "../../_maps/map_files/triumph/triumph-05-flagship.dmm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Triumph

#endif
