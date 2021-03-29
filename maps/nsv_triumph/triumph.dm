#if !defined(USING_MAP_DATUM)

	#include "triumph_defines.dm"
	#include "triumph_turfs.dm"
	#include "triumph_things.dm"
	#include "triumph_shuttle_defs.dm"
	#include "triumph_shuttles.dm"
	#include "triumph_telecomms.dm"
	#include "triumph_overmap.dm"

	#include "submaps/_triumph_submaps.dm"

	#define USING_MAP_DATUM /datum/map/triumph

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Triumph

#endif
