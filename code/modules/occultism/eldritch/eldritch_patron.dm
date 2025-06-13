//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * A distinct patron a practitioner can align to.
 *
 * * By code design, you can have one 'primary' at a time, while secondary, passive effects
 *   may stay on you even if it's not active.
 * * By game design, you can only have one patron you specialize in 99% of the time.
 */
/datum/prototype/eldritch_patron
	/// our name
	var/name = "???"
	/// our desc
	var/desc = "Whom is this?"
	/// lore blurb, if any, as raw HTML
	var/lore_as_unsafe_html

	/// ui icon
	var/ui_icon
	/// ui icon state
	var/ui_icon_state

	/// our blade's typepath
	#warn impl
	var/eldritch_blade_typepath = /obj/item/eldritch_blade

#warn impl

/datum/prototype/eldritch_patron/proc/ui_serialize_patron()
	return list(
		"id" = id,
		"name" = name,
		"desc" = desc,
		"loreAsUnsafeHtml" = lore_as_unsafe_html,
	)
