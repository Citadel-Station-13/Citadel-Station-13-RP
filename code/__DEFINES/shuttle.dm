// Shuttle flags
#define SHUTTLE_FLAGS_NONE		0
/// Should be processed by shuttle subsystem
#define SHUTTLE_FLAGS_PROCESS	1
/// This is the supply shuttle.  Why is this a tag?
#define SHUTTLE_FLAGS_SUPPLY	2
/// Shuttle has no internal gravity generation
#define SHUTTLE_FLAGS_ZERO_G	4
#define SHUTTLE_FLAGS_ALL (~SHUTTLE_FLAGS_NONE)
// shuttle_landmark flags
/// If set, will set base area and turf type to same as where it was spawned at
#define SLANDMARK_FLAG_AUTOSET	1
/// Zero-G shuttles moved here will lose gravity unless the area has ambient gravity.
#define SLANDMARK_FLAG_ZERO_G	2
// Overmap landable shuttles (/obj/effect/overmap/visitable/ship/landable on a /datum/shuttle/autodock/overmap)
/// Ship is at any other shuttle landmark.
#define SHIP_STATUS_LANDED		1
/// Ship is at it's shuttle datum's transition shuttle landmark.
#define SHIP_STATUS_TRANSIT		2
/// Ship is at its "overmap" shuttle landmark (allowed to move on overmap now)
#define SHIP_STATUS_OVERMAP		3
// Ferry shuttle location constants
#define FERRY_LOCATION_STATION	0
#define FERRY_LOCATION_OFFSITE	1
#define FERRY_GOING_TO_STATION	0
#define FERRY_GOING_TO_OFFSITE	1
#ifndef DEBUG_SHUTTLES
	#define log_shuttle(M)
#else
	#define log_shuttle(M) log_debug("[M]")
#endif
