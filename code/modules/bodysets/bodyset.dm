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
	var/icon
	/// icon state base
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
