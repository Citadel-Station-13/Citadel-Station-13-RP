//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A frame is a chassis-iconset tuple.
 *
 * * This is the thing you can actually choose / build as a player.
 * * This is a thing because icon and chassis are generally disjoint; you don't
 *   want to constrain sprite design to a single functionality, necessarily.
 * * Thus another layer of abstraction was added.
 */
/datum/prototype/robot_frame
	abstract_type = /datum/robot_frame

	/// our name
	var/name
	/// our iconset
	/// * set to typepath; resolved on init.
	var/datum/prototype/robot_iconset
	/// our chassis
	/// * set to typepath; resolved on init.
	var/datum/prototype/robot_chassis
