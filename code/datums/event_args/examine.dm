//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Holds data about an examine.
 */
/datum/event_args/examine
	/// the thing actually viewing
	var/atom/movable/seer
	/// distance, if set
	var/seer_distance

	/// the thing doing the examining
	/// * if remote controlled, this is not the same as [seer_atom]
	var/atom/movable/examiner

	/// the thing being examined
	var/atom/examined

	var/legacy_examine_skip_body
	var/legacy_examine_skip_gear
	var/legacy_examine_no_touch

/datum/event_args/examine/New(atom/examined, atom/movable/examiner)
	src.examined = examined
	src.examiner = src.seer = examiner

	if(examiner && examined)
		seer_distance = get_dist(examiner, examined)

// todo: serialize, deserialize, clone
