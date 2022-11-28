#if !defined(USING_MAP_DATUM)

	#include "rift_defines.dm"
	#include "rift_turfs.dm"
	#include "rift_things.dm"
	#include "rift_areas.dm"
	#include "rift_areas2.dm"
	#include "rift_shuttle_defs.dm"
	#include "rift_shuttles.dm"
	#include "rift_telecomms.dm"
	#include "rift_overmap.dm"
	#include "rift_lythios-43c.dm"
	#include "classd.dm"
	#include "classg.dm"
	#include "classh.dm"
	#include "classm.dm"
	#include "classp.dm"
	#include "lavaland.dm"

	#define USING_MAP_DATUM /datum/map/rift

	#include "submaps/_rift_submaps.dm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Rift

#endif
