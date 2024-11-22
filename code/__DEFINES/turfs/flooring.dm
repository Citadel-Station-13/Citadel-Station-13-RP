//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Declares a type of flooring.
 *
 * * Will generate two types. /datum/prototype/flooring/<type>, and /turf/simulated/floor/preset/<type>
 * * Will generate the standard (see standard turfmakers) types for the preset turf as well.
 */
#define DECLARE_FLOORING(TYPE) \
CREATE_STANDARD_TURFS(/turf/simulated/floor/preset/##TYPE); \
/turf/simulated/floor/preset/##TYPE { \

}; \
/datum/prototype/flooring/##TYPE
