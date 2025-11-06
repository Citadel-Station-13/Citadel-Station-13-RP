//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * macro to make sure a /type/path is in a spatial grid
 *
 * they are put in during Initialize()
 *
 * * TYPEPATH must be a subtype of /atom/movable
 * * this is a define so we can add recovery/rebuild registration to this later.
 *
 * todo: /atom/movable/recover_spatial_grid(), macro should have components remade using that.
 */
#define TYPE_REGISTER_SPATIAL_GRID(TYPEPATH, GRID) \
##TYPEPATH{} \
##TYPEPATH/Initialize(...) { \
	. = ..(); \
	if(. == INITIALIZE_HINT_QDEL) { \
		return; \
	} \
	AddComponent(/datum/component/spatial_grid, GRID); \
}

//* init flags to determine behavior *//

#define SPATIAL_GRID_INIT_OPTIMIZE_ALL_Z (1<<0)
