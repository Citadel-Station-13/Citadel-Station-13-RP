//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * citadel rp dynamic augment system, inspired by /tg/ augments
 */
/obj/item/organ/internal/augment
	#warn identity
	#warn sprite

	biology = /datum/biology/synthetic

	/// biology types that we are functional on
	var/biology_function_type = BIOLOGY_TYPES_ALL
	/// biology types that can control us
	var/biology_control_type = BIOLOGY_TYPES_ALL

#warn impl
