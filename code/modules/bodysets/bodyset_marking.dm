//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Bodymarkings 2.0
 *
 * Now with 100% more FREE LAG!
 */
/datum/bodyset_marking
	abstract_type = /datum/bodyset_marking

	/// name - should be unique
	var/name = "Unknown Marking"
	/// id - **must** be unique
	var/id
	/// category
	var/category = "Miscellaneous"

	/// icon to render from
	var/icon
	/// icon state to render from
	var/icon_state
	/// colorable? we use single-color matrix
	var/colorable = TRUE
	/// ... unless we use add coloration because people are stupid and keep using add for wahtever reason
	var/color_uses_blend_add = FALSE

	/// BP_* defines for which bodyparts render us
	var/list/body_parts = list()

	/// set to a list of bodysets by typepath or id
	/// typepaths transformed to id on boot
	/// will make other bodysets unable to pick them
	var/list/bodyset_restricted

/datum/bodyset_marking/New()
	#warn species_restricted

/datum/bodyset_marking/legacy
	// PLEASE STOP USING THIS.
	color_uses_blend_add = TRUE
