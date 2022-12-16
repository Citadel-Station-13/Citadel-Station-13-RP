///uncomment this to load centcom and runtime station and thats it.
//#define LOWMEMORYMODE
// this file is 1x1x1. the zlevel will expand as the world loads.

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
