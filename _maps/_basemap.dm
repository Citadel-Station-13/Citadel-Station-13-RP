/// Uncomment this to load centcom and runtime station and thats it.
// #define LOWMEMORYMODE

/**
 * This map is 25x25x1.
 * The zlevel will expand as the world loads.
 */
#include "map_files\generic\reservation_base_level.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
