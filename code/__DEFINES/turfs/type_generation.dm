//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Create the 4 standard subtypes for a given turf type.
 *
 * * Indoors uses indoors gas mix of level, and is indoors.
 * * Outdoors uses outdoors gas mix of level, and is outdoors.
 * * Inherit-Area inherits the gas mix and outdoors status of the area.
 * * Overhang uses outdoors gas mix of level, and is indoors.
 */
#define CREATE_STANDARD_TURFS(type) \
##type/indoors { \
	outdoors = FALSE; \
	initial_gas_mix = ATMOSPHERE_USE_INDOORS; \
} \
##type/outdoors { \
	outdoors = TRUE; \
	initial_gas_mix = ATMOSPHERE_USE_OUTDOORS; \
} \
##type/inherit_area { \
	outdoors = null; \
	initial_gas_mix = ATMOSPHERE_USE_AREA; \
} \
##type/overhang { \
	outdoors = FALSE; \
	initial_gas_mix = ATMOSPHERE_USE_OUTDOORS; \
} \
##type
