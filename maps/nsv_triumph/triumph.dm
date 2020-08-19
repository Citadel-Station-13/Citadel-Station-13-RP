#if !defined(USING_MAP_DATUM)

	#include "triumph_defines.dm"
	#include "triumph_turfs.dm"
	#include "triumph_things.dm"
	#include "triumph_phoronlock.dm"
	#include "triumph_areas.dm"
	#include "triumph_areas2.dm"
	#include "triumph_shuttle_defs.dm"
	#include "triumph_shuttles.dm"
	#include "triumph_telecomms.dm"

	#include "../../_maps/map_files/NSV_Triumph/triumph-01-deck1.dmm"
	#include "../../_maps/map_files/NSV_Triumph/triumph-02-deck2.dmm"
	#include "../../_maps/map_files/NSV_Triumph/triumph-03-deck3.dmm"
	#include "../../_maps/map_files/NSV_Triumph/triumph-04-deck4.dmm"
	#include "../../_maps/map_files/NSV_Triumph/triumph-05-flagship.dmm"


	#include "submaps/_triumph_submaps.dm"

	#define USING_MAP_DATUM /datum/map/triumph

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Triumph

#endif