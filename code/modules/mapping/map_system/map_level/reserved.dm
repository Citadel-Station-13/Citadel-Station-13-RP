//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * reserved levels for turf reservations use this
 */
/datum/map_level/reserved
	transition = Z_TRANSITION_DISABLED

/datum/map_level/reserved/allow_deallocate()
	return FALSE
