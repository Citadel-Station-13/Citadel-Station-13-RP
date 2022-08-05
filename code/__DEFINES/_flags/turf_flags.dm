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
))

// /turf/z_flags
/// Allow air passage through top
#define Z_AIR_UP			(1<<0)
/// Allow air passage through bottom
#define Z_AIR_DOWN			(1<<1)
/// Allow atom movement through top
#define Z_OPEN_UP			(1<<2)
/// Allow atom movement through bottom
#define Z_OPEN_DOWN			(1<<3)
/// Considered open - below turfs will get the openspace overlay if so
#define Z_CONSIDERED_OPEN	(1<<4)

DEFINE_BITFIELD(z_flags, list(
	"Z_AIR_UP" = Z_AIR_UP,
	"Z_AIR_DOWN" = Z_AIR_DOWN,
	"Z_OPEN_UP" = Z_OPEN_UP,
	"Z_OPEN_DOWN" = Z_OPEN_DOWN,
	"Z_CONSIDERED_OPEN" = Z_CONSIDERED_OPEN,
))
