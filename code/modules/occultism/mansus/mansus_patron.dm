//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * A distinct patron a practitioner can align to.
 *
 * * By code design, you can have one 'primary' at a time, while secondary, passive effects
 *   may stay on you even if it's not active.
 * * By game design, you can only have one patron you specialize in 99% of the time.
 */
/datum/mansus_patron
	/// our blade's typepath
	#warn impl
	var/mansus_blade_typepath = /obj/item/mansus_blade

#warn impl
