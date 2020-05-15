#if !defined(USING_MAP_DATUM)

	#include "tether_defines.dm"
	#include "tether_turfs.dm"
	#include "tether_things.dm"
	#include "tether_phoronlock.dm"
	#include "tether_areas.dm"
	#include "tether_areas2.dm"
	#include "tether_shuttle_defs.dm"
	#include "tether_shuttles.dm"
	#include "tether_telecomms.dm"

	#include "submaps/_tether_submaps.dm"

	#define USING_MAP_DATUM /datum/map/tether

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tether

#endif