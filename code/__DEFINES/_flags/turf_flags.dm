//* /turf_flags var on /turf
/// This is used in literally one place, turf.dm, to block ethwereal jaunt.
#define NO_JAUNT						(1<<0)
/// Unused reservation turf
#define TURF_FLAG_UNUSED_RESERVATION			(1<<2)
/// queued for planet turf addition
#define TURF_PLANET_QUEUED				(1<<3)
/// registered to a planet
#define TURF_PLANET_REGISTERED			(1<<4)
/// queued for ZAS rebuild
#define TURF_ZONE_REBUILD_QUEUED		(1<<5)
/// no making dirt overlays or similar overlays on this
#define TURF_SEMANTICALLY_BOTTOMLESS	(1<<6)
/// considered a volatile-changing area by persistence, which means things like trash and debris won't stay here
#define TURF_FLAG_ERODING				(1<<7)
/// The slowdown affects a physical person, even if they aren't walking on the tile the turf represents.
#define TURF_SLOWDOWN_INCLUDE_FLYING	(1<<8)

DEFINE_BITFIELD(turf_flags, list(
	BITFIELD(NO_JAUNT),
	BITFIELD(TURF_FLAG_UNUSED_RESERVATION),
	BITFIELD(TURF_PLANET_QUEUED),
	BITFIELD(TURF_PLANET_REGISTERED),
	BITFIELD(TURF_ZONE_REBUILD_QUEUED),
	BITFIELD(TURF_SEMANTICALLY_BOTTOMLESS),
	BITFIELD(TURF_FLAG_ERODING),
	BITFIELD(TURF_SLOWDOWN_INCLUDE_FLYING),
))


//* /turf_spawn_flags on /turf *//

/// allow fill
#define TURF_SPAWN_FLAG_FILLABLE (1<<0)
/// allow admin buildmode
#define TURF_SPAWN_FLAG_BUILDMODE (1<<1)
/// allow ai holodeck and similar (**player accessible**)
#define TURF_SPAWN_FLAG_HOLODECK (1<<2)
/// allow vr and similar (**player accessible**)
#define TURF_SPAWN_FLAG_VR (1<<3)
/// valid for the base turf of a zlevel
#define TURF_SPAWN_FLAG_LEVEL_TURF (1<<4)

DEFINE_BITFIELD(turf_spawn_flags, list(
	BITFIELD_NEW("Allow Mass Fill", TURF_SPAWN_FLAG_FILLABLE),
	BITFIELD_NEW("Allow Admin Buildmode", TURF_SPAWN_FLAG_BUILDMODE),
	BITFIELD_NEW("Allow Holographic Render", TURF_SPAWN_FLAG_HOLODECK),
	BITFIELD_NEW("Allow Virtual Reality", TURF_SPAWN_FLAG_VR),
	BITFIELD_NEW("Allow as Level Baseturf", TURF_SPAWN_FLAG_LEVEL_TURF),
))

/// for turfs that can be spawned by most turf spawners / renderers
#define TURF_SPAWN_FLAGS_ALLOW_ALL ALL

//* /turf_path_danger on /turf *//
/// lava, fire, etc
#define TURF_PATH_DANGER_BURN (1<<0)
/// openspace, chasms, etc
#define TURF_PATH_DANGER_FALL (1<<1)
/// will just fucking obliterate you
#define TURF_PATH_DANGER_ANNIHILATION (1<<2)
/// this, is literally space.
#define TURF_PATH_DANGER_SPACE (1<<3)

DEFINE_SHARED_BITFIELD(turf_path_danger, list(
	"turf_path_danger",
	"turf_path_danger_ignore",
), list(
	BITFIELD(TURF_PATH_DANGER_BURN),
	BITFIELD(TURF_PATH_DANGER_FALL),
	BITFIELD(TURF_PATH_DANGER_ANNIHILATION),
	BITFIELD(TURF_PATH_DANGER_SPACE),
))
