#if !defined(USING_MAP_DATUM)

	#include "boreas_defines.dm"
/*	#include "boreas_turfs.dm"
	#include "boreas_things.dm"
	#include "boreas_phoronlock.dm"
	#include "boreas_areas.dm"
	#include "boreas_areas2.dm"
	#include "boreas_shuttle_defs.dm"
	#include "boreas_shuttles.dm"
	#include "boreas_telecomms.dm"
	#include "boreas_virgo3b.dm" */

	#include "boreas-1.dmm"
	#include "boreas-2.dmm"


	#define USING_MAP_DATUM /datum/map/boreas

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring boreas

#endif