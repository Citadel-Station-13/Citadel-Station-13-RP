/// Uncomment this to load centcom and runtime station and thats it.
// #define LOWMEMORYMODE

#include "../maps/core/reservation_base_level.dmm"

/**
 * This map is 25x25x1.
 * The zlevel will expand as the world loads.
 */
#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#ifdef CIBUILDING
			#include "..\maps\templates.dm"
		#endif
	#endif
#endif
