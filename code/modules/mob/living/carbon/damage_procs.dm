//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Damage *//

/mob/living/carbon/heal_brute_loss(amount)
	return heal_overall_damage(amount, 0)

/mob/living/carbon/heal_fire_loss(amount)
	return heal_overall_damage(0, amount)

/mob/living/carbon/heal_tox_loss(amount)
	. = toxloss
	toxloss -= amount
	return . - toxloss

/mob/living/carbon/heal_oxy_loss(amount)
	. = oxyloss
	oxyloss -= amount
	return . - oxyloss

//* Damage *//

/mob/living/carbon/heal_brute_loss(amount)
	return heal_overall_damage(amount, 0)

/mob/living/carbon/heal_fire_loss(amount)
	return heal_overall_damage(0, amount)

/mob/living/carbon/heal_tox_loss(amount)
	. = toxloss
	toxloss -= amount
	return . - toxloss

/mob/living/carbon/heal_oxy_loss(amount)
	. = oxyloss
	oxyloss -= amount
	return . - oxyloss

//* Raw Damage *//

/mob/living/carbon/take_random_targeted_damage(brute, burn, damage_mode, weapon_descriptor, defer_updates)
	if(status_flags & STATUS_GODMODE)
		return 0
	var/list/obj/item/organ/external/targets = get_damageable_external_organs()
	if(!length(targets))
		return 0
	var/obj/item/organ/external/target = pick(targets)
	return take_targeted_damage(brute, burn, damage_mode, target.organ_tag, weapon_descriptor, defer_updates)

/mob/living/carbon/take_targeted_damage(brute, burn, damage_mode, body_zone, weapon_descriptor, defer_updates)
	if(status_flags & STATUS_GODMODE)
		return 0

	var/obj/item/organ/external/bodypart = get_bodypart_for_zone(body_zone)
	if(isnull(bodypart))
		if(damage_mode & DAMAGE_MODE_REDIRECT)
			// todo: maybe don't random lmfao
			return take_random_targeted_damage(brute, burn, damage_mode & ~(DAMAGE_MODE_REDIRECT), weapon_descriptor, defer_updates)
		return 0

	. = bodypart.inflict_bodypart_damage(brute, burn, damage_mode, weapon_descriptor, TRUE)

	if(!defer_updates && .)
		update_health()
		update_damage_overlay()

/mob/living/carbon/take_overall_damage(brute, burn, damage_mode, weapon_descriptor, defer_updates)
	if(status_flags & STATUS_GODMODE)
		return 0

	. = 0

	var/list/obj/item/organ/external/targets = get_damageable_external_organs()
	var/divisor = 1 / length(targets)

	for(var/obj/item/organ/external/target as anything in targets)
		. += target.inflict_bodypart_damage(brute * divisor, burn * divisor, damage_mode, weapon_descriptor, TRUE)

	if(!defer_updates && .)
		update_health()
		update_damage_overlay()
