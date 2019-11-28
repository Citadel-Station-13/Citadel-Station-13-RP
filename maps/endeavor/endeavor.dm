#if !defined(USING_MAP_DATUM)

	#include "endeavor_defines.dm"
	#include "endeavor_elevator.dm"
	#include "endeavor_areas.dm"
	#include "endeavor_things.dm"
	#include "endeavor_turfs.dm"
	#include "endeavor_jobs.dm"
	#include "endeavor_telecomms.dm"
	#include "endeavor_shuttles.dm"

	#include "endeavor-01-ship1.dmm" 		//Deck 1
	#include "endeavor-02-ship2.dmm" 		//Deck 2
	#include "endeavor-03-ship3.dmm" 		//Deck 3
	#include "endeavor-04-ship4.dmm" 		//Deck 4
	#include "endeavor-05-ship5.dmm" 		//Deck 5
	#include "endeavor-06-centcomm.dmm" 	//CentComm
	#include "endeavor-07-mining1.dmm"
	#include "endeavor-08-mining2.dmm"

	#include "submaps/_endeavor_submaps.dm"

	#define USING_MAP_DATUM /datum/map/endeavor

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Endeavor

#endif
