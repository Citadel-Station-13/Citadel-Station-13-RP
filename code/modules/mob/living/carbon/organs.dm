//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * get organ for body zone
 */
/mob/living/carbon/proc/get_bodypart_for_zone(body_zone)
	return organs_by_name[body_zone]

/**
 * get external organs
 */
/mob/living/carbon/proc/get_external_organs()
	. = list()
	for(var/obj/item/organ/external/E in organs)
		. += E

/**
 * get external organs that are targetable
 */
/mob/living/carbon/proc/get_damageable_external_organs(check_damage_cap)
	. = list()
	for(var/obj/item/organ/external/E in organs)
		if(!E.is_damageable(check_damage_cap))
			continue
		. += E
