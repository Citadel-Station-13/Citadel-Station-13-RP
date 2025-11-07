//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/// reserved turf type
#define RESERVED_TURF_TYPE /turf/space/basic
/// reserved area type
#define RESERVED_AREA_TYPE /area/space

/// Turf chunk resolution
///
/// * this is the most granular a turf reservation alloc can be (e.g. 8x8 for '8')
/// * this is the resolution of spatial gridmaps. why? this way spatial queries are aligned and super fast.
#define TURF_CHUNK_RESOLUTION 8

/// Z-Level border
///
/// * This is how many tiles the server's maploader / map system reserves for internal use.
/// * This means 'logical' 1,1 with width 1 is actually 2.
/// * This cannot be 0.
#define LEVEL_BORDER_WIDTH 1
