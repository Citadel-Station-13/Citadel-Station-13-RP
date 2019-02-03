// If we are doing the map test build, do not include the main maps, only the submaps.
#if MAP_TEST
	#define USING_MAP_DATUM /datum/map
	#define MAP_OVERRIDE 1
#endif


//DO NOT ADD ANYTHING TO THIS FILE. IT IS TO BE REMOVED WHEN TRAVIS UNIT TESTS AREN'T DUMB AND STUPID.
