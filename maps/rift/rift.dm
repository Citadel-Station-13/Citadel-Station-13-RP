#if !defined(USING_MAP_DATUM)

	#include "rift_defines.dm"
	#include "rift_turfs.dm"
	#include "rift_things.dm"
	#include "rift_areas.dm"
	#include "rift_areas2.dm"
	#include "rift_shuttle_defs.dm"
	#include "rift_shuttles.dm"
	#include "rift_telecomms.dm"
	#include "rift_lythios-43c.dm"

	#include "../../_maps/map_files/rift/rift-01-underground2.dmm"
	#include "../../_maps/map_files/rift/rift-02-underground1.dmm"
	#include "../../_maps/map_files/rift/rift-03-surface1.dmm"
	#include "../../_maps/map_files/rift/rift-04-surface2.dmm"
	#include "../../_maps/map_files/rift/rift-05-surface3.dmm"
	#include "../../_maps/map_files/rift/rift-06-orbital.dmm"
	#include "../../_maps/map_files/rift/rift_misc.dmm"
	#include "../../_maps/map_files/rift/rift_ships.dmm"

	#define USING_MAP_DATUM /datum/map/rift

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Rift

#endif
