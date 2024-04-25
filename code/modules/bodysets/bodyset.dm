//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Descriptor / metadata about a set of carbon/mob body sprites.
 */
/datum/bodyset

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
