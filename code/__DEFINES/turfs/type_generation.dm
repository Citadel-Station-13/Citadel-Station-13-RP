//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Create the 4 standard subtypes for a given turf type.
 *
 * * Indoors uses indoors gas mix of level, and is indoors.
 * * Outdoors uses outdoors gas mix of level, and is outdoors.
 * * Inherit-Area inherits the gas mix and outdoors status of the area.
 * * Overhang uses outdoors gas mix of level, and is indoors.
 *
 * This macro allows for annotating the type being processed by commenting above.
 * This macro acts like the type it's generating when writing prototype overrides below.
 */
#define CREATE_STANDARD_TURFS(type) \
##type {} \
##type/indoors { \
	outdoors = FALSE; \
	initial_gas_mix = ATMOSPHERE_USE_INDOORS; \
	turf_spawn_flags = ##type::turf_spawn_flags & ~(TURF_SPAWN_FLAG_LEVEL_TURF); \
} \
##type/outdoors { \
	outdoors = TRUE; \
	initial_gas_mix = ATMOSPHERE_USE_OUTDOORS; \
	turf_spawn_flags = ##type::turf_spawn_flags & ~(TURF_SPAWN_FLAG_LEVEL_TURF); \
} \
##type/inherit_area { \
	outdoors = null; \
	initial_gas_mix = ATMOSPHERE_USE_AREA; \
	turf_spawn_flags = ##type::turf_spawn_flags & ~(TURF_SPAWN_FLAG_LEVEL_TURF); \
} \
##type/overhang { \
	outdoors = FALSE; \
	initial_gas_mix = ATMOSPHERE_USE_OUTDOORS; \
	turf_spawn_flags = ##type::turf_spawn_flags & ~(TURF_SPAWN_FLAG_LEVEL_TURF); \
} \
##type
