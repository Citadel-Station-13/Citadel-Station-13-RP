//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Bodymarkings 2.0
 *
 * Now with 100% more FREE LAG!
 *
 * Why is this not just /sprite_accessory?
 *
 * Because we're a lot more simple than sprite accessories.
 * We directly blend into limbs; we don't have our own layers or anything.
 * We also inherently don't need things like sidedness for that matter.
 *
 * Basically
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
	///
	/// * this is a prepend. the real state will be, say, "[icon_state]-head" for head.
	var/icon_state
	/// emissive state to use instead of emissive-ing the entire icon state
	var/emissive_state
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
	/// restrict to a specific group id
	var/bodyset_group_restricted = "human"

/datum/bodyset_marking/New()
	#warn bodyset_restricted

/**
 * returns the normal and emissive overlays to blend onto a limb
 *
 * @params
 * * for_bodypart - the bodypart we're rendering for
 * * with_descriptor - our marking descriptor that specifies colors and other things
 *
 * @return list(normal overlay | null, emissive_overlay | null)
 */
/datum/bodyset_marking/proc/render(bodypart_tag, datum/bodyset_marking_descriptor/using_descriptor, obj/item/organ/external/for_bodypart)

/datum/bodyset_marking/legacy
	// PLEASE STOP USING THIS.
	color_uses_blend_add = TRUE
