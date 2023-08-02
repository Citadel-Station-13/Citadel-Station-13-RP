/// load in the first reserved level, necessary to not have Dream Daemon start in MUD mode.
#include "_basemap.dmm"

#ifdef ALL_MAPS

	#ifdef CIBUILDING
		#include "..\maps\templates.dm"
	#endif
#endif
