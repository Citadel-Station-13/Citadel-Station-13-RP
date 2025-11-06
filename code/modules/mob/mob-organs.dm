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

/**
 * This weirdly named proc checks if an organ tag usually exists on our species,
 * or our nominal biology.
 */
/mob/proc/get_organ_key_usually_exists(key)
	return get_organ_key_default_type(key) ? TRUE : FALSE

/**
 * Returns the default type that would be instanced for a given organ tag,
 * with our current species and biology.
 */
/mob/proc/get_organ_key_default_type(key)
	return null

/**
 * Is a given organ considered vital?
 * This is semi-legacy; we're moving away from 'vital' organs eventually.
 */
/mob/proc/get_organ_is_vital(obj/item/organ/target)
	return get_organ_key_is_vital(target.organ_key)

/**
 * Is a given organ key considered vital?
 * This is semi-legacy; we're moving away from 'vital' organs eventually.
 */
/mob/proc/get_organ_key_is_vital(key)
	return FALSE
