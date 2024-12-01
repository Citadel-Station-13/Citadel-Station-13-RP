//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Declares a type of flooring.
 *
 * * Will generate two types. /datum/prototype/flooring/<type>, and /turf/simulated/floor/preset/<type>
 * * Will generate the standard (see standard turfmakers) types for the preset turf as well.
 * * Name is automatically set on the turf.
 * * Icon is automatically set on the turf.
 * * Icon state is automatically set on the turf. Make sure the `icon_state` exists in the icon.
 * * `mz_flags` is automatically set on the turf.
 */
#define DECLARE_FLOORING(TYPE) \
CREATE_STANDARD_TURFS(/turf/simulated/floor/preset##TYPE); \
/turf/simulated/floor/preset##TYPE { \
	initial_flooring = /datum/prototype/flooring##TYPE; \
	name = /datum/prototype/flooring##TYPE::name; \
	icon = /datum/prototype/flooring##TYPE::icon; \
	icon_state = /datum/prototype/flooring##TYPE::icon_base; \
	mz_flags = /datum/prototype/flooring##TYPE::mz_flags; \
}; \
/datum/prototype/flooring##TYPE { \
	__is_not_legacy = TRUE; \
} \
/datum/prototype/flooring##TYPE
