//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * desc wip
 *
 * welcome to hell: brought to you by a webdev
 *
 * naming convention: c[whatever] for the caliber, subtype to a[whatever] for different ammo lengths
 *
 * direct subtypes of /datum/caliber should be for diameter, usually,
 * and length subtypes go from the diameter subtype.
 */
/datum/caliber
	abstract_type = /datum/caliber
	/// caliber string
	var/caliber
	/// width in millimeters
	var/diameter
	/// length in millimeters, if known; if not known / unbounded, this is null
	var/length
