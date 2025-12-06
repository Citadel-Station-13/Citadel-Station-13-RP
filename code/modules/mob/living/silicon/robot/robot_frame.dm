//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A frame is a chassis-iconset tuple.
 *
 * * This is the thing you can actually choose as a player.
 * * This is a thing because icon and chassis are generally disjoint; you don't
 *   want to constrain sprite design to a single functionality, necessarily.
 *   Thus, another layer of abstraction was added.
 */
/datum/robot_frame
	abstract_type = /datum/robot_frame

	/// our name
	var/name
	/// our iconset
	/// * set to typepath; resolved on init.
	var/datum/prototype/robot_iconset
	/// our chassis
	/// * set to typepath; resolved on init.
	var/datum/prototype/robot_chassis

	/// Lock to ckeys, if set
	var/list/ckey_lock

/datum/robot_frame/New()
	// todo: DB pull if needed
	robot_iconset = RSrobot_iconsets.fetch_local_or_throw(robot_iconset)
	robot_chassis = RSrobot_chassis.fetch_local_or_throw(robot_chassis)
