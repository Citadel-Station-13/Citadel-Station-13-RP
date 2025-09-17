/// reserved turf type
#define RESERVED_TURF_TYPE /turf/space/basic
/// reserved area type
#define RESERVED_AREA_TYPE /area/space

/// Turf chunk resolution
///
/// * this is the most granular a turf reservation alloc can be (e.g. 8x8 for '8')
/// * this is the resolution of spatial gridmaps. why? this way spatial queries are aligned and super fast.
#define TURF_CHUNK_RESOLUTION 8
