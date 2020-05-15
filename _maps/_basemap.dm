//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\tether\tether-01-surface1.dmm"
		#include "map_files\tether\tether-02-surface2.dmm"
		#include "map_files\tether\tether-03-surface3.dmm"
		#include "map_files\tether\tether-04-transit.dmm"
		#include "map_files\tether\tether-05-station1.dmm"
		#include "map_files\tether\tether-06-station2.dmm"
		#include "map_files\tether\tether-07-station3.dmm"
		#include "map_files\tether\tether-08-mining.dmm"
		#include "map_files\tether\tether-09-solars.dmm"
		#include "map_files\tether\tether-10-colony.dmm"

		#ifdef TRAVISBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
