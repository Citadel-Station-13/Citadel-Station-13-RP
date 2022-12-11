#if !defined(USING_MAP_DATUM)

	#include "euthenia_defines.dm"
	#include "tether_shuttle_defs.dm"
	#include "tether_shuttles.dm"
	#include "tether_telecomms.dm"
	/*
	#include "tether_virgo3b.dm"					//Virgo3b Weather
	#include "tether_virgo4.dm"						//Virgo4 Weather
	#include "tether_class_d_weather_holder.dm"		//Virgo5 (class_d) Weather
	*/

	#include "../../_maps/map_files/NLV_Euthenia/Euthenia_Deck_1.dmm"
	#include "../../_maps/map_files/NLV_Euthenia/Euthenia_Deck_2.dmm"
	#include "../../_maps/map_files/NLV_Euthenia/Euthenia_Deck_3.dmm"
	#include "../../_maps/map_files/NLV_Euthenia/Euthenia_Deck_4.dmm"
	#include "../../_maps/map_files/NLV_Euthenia/Euthenia_Misc.dmm"
	#include "../../_maps/map_files/NLV_Euthenia/lazy_overmap.dmm"

	#define USING_MAP_DATUM /datum/map/euthenia

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring NLV Euthenia

#endif
