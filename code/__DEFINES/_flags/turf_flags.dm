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

/// course-level procedural generation (terrain, mostly) should avoid this turf
#define TURF_PROCGEN_MASK			(1<<22)
/// procedural generation of any kind should avoid this turf
#define TURF_PROCGEN_IGNORE			(1<<23)

/// these turf flags are carried through changeturf
#define TURF_FLAGS_STICKY (TURF_PROCGEN_MASK | TURF_PROCGEN_IGNORE)

DEFINE_BITFIELD(turf_flags, list(
	BITFIELD(NO_JAUNT),
	BITFIELD(UNUSED_RESERVATION_TURF),
	BITFIELD(TURF_PLANET_QUEUED),
	BITFIELD(TURF_PLANET_REGISTERED),
	BITFIELD(TURF_ZONE_REBUILD_QUEUED),
	BITFIELD(TURF_PROCGEN_MASK),
	BITFIELD(TURF_PROCGEN_IGNORE),
))
