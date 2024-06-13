//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * master system for modular guns
 *
 * used to make code-reuse less on implementing types
 */
/datum/modular_gun_system
	/// attached gun
	var/obj/item/gun/gun

#warn impl


/**
 * firing cycle tracking
 * this is faster than associative list calls
 */
/datum/modular_gun_firing

