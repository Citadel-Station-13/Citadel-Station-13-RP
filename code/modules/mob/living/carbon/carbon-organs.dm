//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* API - Get *//

/**
 * Get an external organ by target zone.
 */
/mob/living/carbon/proc/get_external_organ_for_zone(target_zone)
	var/static/list/target_zone_rewrites = list(
		O_EYES = BP_HEAD,
		O_MOUTH = BP_HEAD,
	)
	return keyed_organs[target_zone_rewrites[target_zone] || target_zone]



#warn impl

//! Usage of the below procs is not allowed. They're just here to aid in transition. ~//

/**
 * legacy: bodyzone to organ. technically works with internal organ keys too but please don't
 */
/mob/living/carbon/proc/legacy_organ_by_zone(what = BP_TORSO)
	if(what in list(O_EYES, O_MOUTH))
		what = BP_HEAD
	return keyed_organs[what]
