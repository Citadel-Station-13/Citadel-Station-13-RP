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

	/// is this a live examine? this means it's going to chat
	/// * things like FORMAT_LOOKITEM will only be ran on a live examine,
	///   as we don't want clickable HTML in logs now do we
	var/live_examine

	var/legacy_examine_skip_body
	var/legacy_examine_skip_gear
	var/legacy_examine_no_touch

/datum/event_args/examine/New(atom/examined, atom/movable/examiner, live_examine)
	src.examined = examined
	src.examiner = src.seer = examiner
	src.live_examine = live_examine

	if(examiner && examined)
		seer_distance = get_dist(examiner, examined)

// todo: serialize, deserialize, clone
