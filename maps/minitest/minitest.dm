#if !defined(USING_MAP_DATUM)

	#include "minitest-1.dmm"
	#include "minitest-sector-2.dmm"
	#include "minitest-sector-3.dmm"

	#include "minitest_defines.dm"
	#include "minitest_shuttles.dm"
	#include "minitest_sectors.dm"

	#define USING_MAP_DATUM /datum/map/miniteststation

	#warning Please uncheck minitest.dm before committing.

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring minitest

#endif
