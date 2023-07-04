/// /turf_flags var on /turf
/// This is used in literally one place, turf.dm, to block ethwereal jaunt.
#define NO_JAUNT					(1<<0)
/// Unused reservation turf
#define UNUSED_RESERVATION_TURF		(1<<2)
/// queued for planet turf addition
#define TURF_PLANET_QUEUED			(1<<3)
/// registered to a planet
#define TURF_PLANET_REGISTERED		(1<<4)
/// queued for ZAS rebuild
#define TURF_ZONE_REBUILD_QUEUED	(1<<5)

///CITMAIN TURF FLAGS - Completely unused
/*
/// If a turf can be made dirty at roundstart. This is also used in areas.
#define CAN_BE_DIRTY				(1<<3)
/// Should this tile be cleaned up and reinserted into an excited group?
#define EXCITED_CLEANUP				(1<<4)
/// Blocks lava rivers being generated on the turf
#define NO_LAVA_GEN					(1<<5)
/// Blocks ruins spawning on the turf
#define NO_RUINS					(1<<6)
*/

DEFINE_BITFIELD(turf_flags, list(
	BITFIELD(NO_JAUNT),
	BITFIELD(UNUSED_RESERVATION_TURF),
	BITFIELD(TURF_PLANET_QUEUED),
	BITFIELD(TURF_PLANET_REGISTERED),
	BITFIELD(TURF_ZONE_REBUILD_QUEUED),
))
