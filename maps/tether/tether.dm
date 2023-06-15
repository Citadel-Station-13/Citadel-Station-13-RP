#if !defined(USING_MAP_DATUM)

	#include "tether_defines.dm"
	#include "tether_shuttle_defs.dm"
	#include "tether_shuttles.dm"
	#include "tether_telecomms.dm"
	#include "tether_weather.dm"

	#include "../../maps/map_files/tether/tether-01-surface1.dmm"
	#include "../../maps/map_files/tether/tether-02-surface2.dmm"
	#include "../../maps/map_files/tether/tether-03-surface3.dmm"
	#include "../../maps/map_files/tether/tether-04-transit.dmm"
	#include "../../maps/map_files/tether/tether-05-station1.dmm"
	#include "../../maps/map_files/tether/tether-06-station2.dmm"
	#include "../../maps/map_files/tether/tether-08-mining.dmm"
	#include "../../maps/map_files/tether/tether-09-solars.dmm"


	#define USING_MAP_DATUM /datum/map/station/tether

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tether

#endif
