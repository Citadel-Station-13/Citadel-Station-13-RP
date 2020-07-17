#if !defined(USING_MAP_DATUM)

	#include "boreas_turfs.dm"
	#include "boreas_defines.dm"
	#include "boreas_turfs.dm"
	#include "boreas_things.dm"
	#include "boreas_areas.dm"
	#include "boreas_areas2.dm"
	#include "boreas_shuttle_defs.dm"
	#include "boreas_shuttles.dm"
	#include "boreas_telecomms.dm"
	#include "boreas_boreas.dm"

	#include "../../_maps/map_files/boreas/boreas-u.dmm"
	#include "../../_maps/map_files/boreas/boreas-1.dmm"
	#include "../../_maps/map_files/boreas/boreas-2.dmm"
	#include "../../_maps/map_files/boreas/boreas-misc.dmm"
	#include "../../_maps/map_files/boreas/boreas-colony.dmm"
	#include "../../_maps/map_files/boreas/boreas-mining.dmm"

	#include "../../maps/submaps/surface_submaps/mountains/mountains.dm"

	#define USING_MAP_DATUM /datum/map/boreas


#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring boreas

#endif