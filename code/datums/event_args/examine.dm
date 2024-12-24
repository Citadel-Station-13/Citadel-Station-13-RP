//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Holds data about an examine.
 */
/datum/event_args/examine
	/// the thing actually viewing
	var/atom/movable/seer_atom
	/// distance, if set
	var/seer_distance

	/// the thing actually examining
	/// * if remote controlled, this is not the same as [seer_atom]
	var/atom/movable/examiner_atom
