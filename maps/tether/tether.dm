#if !defined(USING_MAP_DATUM)

	#include "tether_defines.dm"
	#include "tether_turfs.dm"
	#include "tether_things.dm"
	#include "tether_areas.dm"
	#include "tether_shuttle_defs.dm"
	#include "tether_shuttles.dm"
	#include "tether_telecomms.dm"
	#include "tether_virgo3b.dm"					//Virgo3b Weather
	#include "tether_virgo4.dm"						//Virgo4 Weather
	#include "tether_class_d_weather_holder.dm"		//Virgo5 (class_d) Weather

	#include "../../_maps/map_files/tether/tether-01-surface1.dmm"
	#include "../../_maps/map_files/tether/tether-02-surface2.dmm"
	#include "../../_maps/map_files/tether/tether-03-surface3.dmm"
	#include "../../_maps/map_files/tether/tether-04-transit.dmm"
	#include "../../_maps/map_files/tether/tether-05-station1.dmm"
	#include "../../_maps/map_files/tether/tether-06-station2.dmm"
	#include "../../_maps/map_files/tether/tether-08-mining.dmm"
	#include "../../_maps/map_files/tether/tether-09-solars.dmm"

	#include "submaps/_tether_submaps.dm"
	#include "submaps/_beach.dm"

	#define USING_MAP_DATUM /datum/map/tether

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Tether

#endif
