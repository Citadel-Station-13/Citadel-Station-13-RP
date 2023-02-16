///uncomment this to load centcom and runtime station and thats it.
//#define LOWMEMORYMODE

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
