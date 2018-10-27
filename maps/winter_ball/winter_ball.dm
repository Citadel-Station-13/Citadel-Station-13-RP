#if !defined(USING_MAP_DATUM)

	#include "winter_ball_1.dmm"
	#include "winter_ball_2.dmm"
	#include "winter_ball_jobs.dm"

	#include "winter_ball_defines.dm"


	#define USING_MAP_DATUM /datum/map/ball

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Northern Star

#endif