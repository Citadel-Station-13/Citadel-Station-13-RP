#if !defined(USING_MAP_DATUM)

	#include "citadel_minitest-1.dmm"
	#include "citadel_minitest-sector-2.dmm"
	#include "citadel_minitest-sector-3.dmm"

	#include "citadel_minitest_defines.dm"
	#include "citadel_minitest_shuttles.dm"
	#include "citadel_minitest_sectors.dm"

	#define USING_MAP_DATUM /datum/map/citadel_minitest

	#warning Please uncheck citadel_minitest.dm before committing.

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Citadel_minitest

#endif
