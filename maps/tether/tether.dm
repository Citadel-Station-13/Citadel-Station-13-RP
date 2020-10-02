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

	#include "../../_maps/map_files/Tether/tether-01-surface1.dmm"
	#include "../../_maps/map_files/Tether/tether-02-surface2.dmm"
	#include "../../_maps/map_files/Tether/tether-03-surface3.dmm"
	#include "../../_maps/map_files/Tether/tether-04-transit.dmm"
	#include "../../_maps/map_files/Tether/tether-05-station1.dmm"
	#include "../../_maps/map_files/Tether/tether-06-station2.dmm"
	#include "../../_maps/map_files/Tether/tether-07-station3.dmm"
	#include "../../_maps/map_files/Tether/tether-08-mining.dmm"
	#include "../../_maps/map_files/Tether/tether-09-solars.dmm"
	#include "../../_maps/map_files/Tether/tether-10-colony.dmm"

	#include "submaps/_tether_submaps.dm"

	#define USING_MAP_DATUM /datum/map/tether

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tether

#endif