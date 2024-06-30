// ChangeTurf() flags

#define CHANGETURF_DEFER_CHANGE (1<<0)
/// This flag prevents changeturf from gathering air from nearby turfs to fill the new turf with an approximation of local air
#define CHANGETURF_IGNORE_AIR (1<<1)
/// Make a new turf even if it's unnecessary / already that type.
#define CHANGETURF_FORCEOP (1<<2)
/// A flag for PlaceOnTop to just instance the new turf instead of calling ChangeTurf. Used for uninitialized turfs NOTHING ELSE
#define CHANGETURF_SKIP (1<<3)
/// Inherit air from previous turf. Implies CHANGETURF_IGNORE_AIR
#define CHANGETURF_INHERIT_AIR (1<<4)
/// preserves the outdoors variable
#define CHANGETURF_PRESERVE_OUTDOORS		(1<<5)
