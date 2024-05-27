//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Descriptor / metadata about a set of carbon/mob body sprites.
 */
/datum/bodyset
	abstract_type = /datum/bodyset

	/// id - **must** be unique
	var/id
	/// name - should be unique
	var/name
	/// icon file
	///
	/// * should have a list of "[icon_state && "[icon_state]-"][bp_tag]" states
	var/icon
	/// icon state prepend
	var/icon_state
	/// bodyparts included
	var/list/body_parts = list(
		BP_HEAD,
		BP_TORSO,
		BP_GROIN,
		BP_L_ARM,
		BP_L_HAND,
		BP_R_ARM,
		BP_R_HAND,
		BP_L_LEG,
		BP_L_FOOT,
		BP_R_LEG,
		BP_R_FOOT,
	)
	/// valid variations; variations are "[bp_tag]-[variation]"
	var/list/variations

	/// our preview icon; defaults to [icon]
	var/preview_icon
	/// our preview icon state; defaults to null, for automatic generation of preview.
	var/preview_icon_state

	/// mask icon; defaults to [icon]
	///
	/// * states in here should just be "[icon_state && "[icon_state]-"][bp_tag]"
	/// * used for [damage_overlay_use_masking]
	var/mask_icon
	/// mask icon state prepend; defaults to "mask"
	///
	/// * used for [damage_overlay_use_masking]
	var/mask_icon_state

	/// damage overlay - masking system? in this system, we'll use the "[brutestage][burnstage]" with a mask applied to it to determine limb graphics
	var/damage_overlay_use_masking
	/// damage overlay icon; defaults to [icon]
	var/damage_overlay_icon
	/// damage overlay icon state prepend; defaults to "damage"
	var/damage_overlay_icon_state
	/// max brute stages
	var/damage_overlay_brute_stages
	/// max burn stages
	var/damage_overlay_burn_stages

/datum/bodyset/proc/render(bodypart_tag, list/datum/bodyset_marking_descriptor/marking_descriptors, obj/item/organ/external/for_bodypart)


#warn impl all

//* Subtypes for builtin sprite accessories used in bodysets             *//
//* These should not be used for anything other than bodyset defaulting. *//

/datum/sprite_accessory/hair/bodyset
	abstract_type = /datum/sprite_accessory/hair/bodyset
	selectable = FALSE

/datum/sprite_accessory/facial_hair/bodyset
	abstract_type = /datum/sprite_accessory/facial_hair/bodyset
	selectable = FALSE

/datum/sprite_accessory/ears/bodyset
	abstract_type = /datum/sprite_accessory/ears/bodyset
	selectable = FALSE

/datum/sprite_accessory/tail/bodyset
	abstract_type = /datum/sprite_accessory/tail/bodyset
	selectable = FALSE

/datum/sprite_accessory/wing/bodyset
	abstract_type = /datum/sprite_accessory/wing/bodyset
	selectable = FALSE
