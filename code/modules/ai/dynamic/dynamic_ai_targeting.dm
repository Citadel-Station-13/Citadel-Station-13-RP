//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * AI targeting information.
 *
 * Can be easily shared between cooperating controllers to
 * allow for more natural group behaviors.
 */
/datum/dynamic_ai_targeting
	/// thing being targeted
	var/atom/target
	/// average movement speed vector x in tiles; used for aiming
	var/avg_movement_x = 0
	/// average movement speed vector y in tiles; used for aiming
	var/avg_movement_y = 0
	/// emnity value
	var/emnity = 0
	/// arbitrary k-v list for user implementation use
	var/list/data = list()
