//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* API - Get *//

/**
 * Get all organs.
 */
/mob/living/carbon/proc/get_organs()
	return external_organs + internal_organs

/**
 * Get all internal organs.
 */
/mob/living/carbon/proc/get_internal_organs()
	return internal_organs.Copy()

/**
 * Get all external organs
 */
/mob/living/carbon/proc/get_external_organs()
	return external_organs.Copy()

/**
 * Get an external organ by target zone.
 */
/mob/living/carbon/proc/get_organ_for_zone(target_zone) as /obj/item/organ/external | null
	var/static/list/target_zone_rewrites = list(
		TARGET_ZONE_EYES = BP_HEAD,
		TARGET_ZONE_MOUTH = BP_HEAD,
	)
	return keyed_organs[target_zone_rewrites[target_zone] || target_zone]



#warn impl

//! Usage of the below procs is not allowed. They're just here to aid in transition. ~//

/**
 * legacy: bodyzone to organ. technically works with internal organ keys too but please don't
 */
/mob/living/carbon/proc/legacy_organ_by_zone(what = BP_TORSO)
	// you'll notice this proc is the same as get_organ_for_zone.
	// it's because this proc doesn't have an assumption that we'll pass in only target zones.
	var/static/list/target_zone_rewrites = list(
		O_EYES = BP_HEAD,
		O_MOUTH = BP_HEAD,
	)
	return keyed_organs[what]
