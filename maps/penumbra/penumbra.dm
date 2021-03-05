#define FORCE_MAP "_maps/penumbra.json" //temporary snowflake for testing
#if !defined(USING_MAP_DATUM)

	#include "penumbra_defines.dm"
	#include "penumbra_turfs.dm"
	#include "penumbra_areas.dm"
	#include "penumbra_shuttles.dm"
	//#include "penumbra_shuttle_defs.dm"
	#include "penumbra_nerada8.dm"

	#if !AWAY_MISSION_TEST //Don't include these for just testing away missions
		#include "../../_maps/map_files/penumbra/penumbra_station01.dmm"
		#include "../../_maps/map_files/penumbra/penumbra_station02.dmm"
		#include "../../_maps/map_files/penumbra/penumbra_station03.dmm"
	#endif

	//#include "submaps/_penumbra_submaps.dm"

	#define USING_MAP_DATUM /datum/map/penumbra

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Penumbra

#endif