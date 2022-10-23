// ChangeTurf() flags
#define CHANGETURF_DEFER_CHANGE 1
/// This flag prevents changeturf from gathering air from nearby turfs to fill the new turf with an approximation of local air
#define CHANGETURF_IGNORE_AIR 2
#define CHANGETURF_FORCEOP 4
/// A flag for PlaceOnTop to just instance the new turf instead of calling ChangeTurf. Used for uninitialized turfs NOTHING ELSE
#define CHANGETURF_SKIP 8
/// Inherit air from previous turf. Implies CHANGETURF_IGNORE_AIR
#define CHANGETURF_INHERIT_AIR 16
/// preserves the outdoors variable
#define CHANGETURF_PRESERVE_OUTDOORS		32

// CopyTurf() flags
// -- currently none --
