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

	#include "../../_maps/map_files/rift/rift-01-underground3.dmm"
	#include "../../_maps/map_files/rift/rift-02-underground2.dmm"
	#include "../../_maps/map_files/rift/rift-03-underground1.dmm"
	#include "../../_maps/map_files/rift/rift-04-surface1.dmm"
	#include "../../_maps/map_files/rift/rift-05-surface2.dmm"
	#include "../../_maps/map_files/rift/rift-06-surface3.dmm"
	#include "../../_maps/map_files/rift/rift-07-west_base.dmm"
	#include "../../_maps/map_files/rift/rift-08-west_deep.dmm"
	#include "../../_maps/map_files/rift/rift-09-west_caves.dmm"
	#include "../../_maps/map_files/rift/rift-10-west_plains.dmm"
	#include "../../_maps/map_files/rift/rift-11-orbital.dmm"

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Rift

#endif
