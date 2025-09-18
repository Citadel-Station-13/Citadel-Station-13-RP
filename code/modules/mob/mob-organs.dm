//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* API - Get *//

/**
 * Get all organs.
 */
/mob/proc/get_organs()
	return list()

/**
 * Get all internal organs.
 */
/mob/proc/get_internal_organs()
	return list()

/**
 * Get all external organs
 */
/mob/proc/get_external_organs()
	return list()

/**
 * Get **an** organ of a key.
 */
/mob/proc/get_organ_by_key(key) as /obj/item/organ
	return null

/**
 * Get **all** organs of a key.
 */
/mob/proc/get_organs_by_key(key) as /list
	return list()

/**
 * Get an external organ by target zone.
 */
/mob/proc/get_organ_for_zone(target_zone) as /obj/item/organ/external
	return null

/**
 * Get internal organs by target zone.
 */
/mob/proc/get_internal_organs_for_zone(target_zone) as /list
	return list()

/**
 * Get an external organ by target zone, if that organ is not a stump and is otherwise physically
 * still that organ by shape.
 */
/mob/proc/get_non_stump_organ_for_zone(target_zone) as /obj/item/organ/external
	return null
