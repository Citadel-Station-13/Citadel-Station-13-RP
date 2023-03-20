/mob/living/carbon/human/check_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/obj/item/organ/external/part = get_organ(def_zone)
	for(var/obj/item/I as anything in inventory?.items_that_cover(part.body_part_flags))
		#warn impl
	return ..()

/mob/living/carbon/human/run_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/obj/item/organ/external/part = get_organ(def_zone)
	for(var/obj/item/I as anything in inventory?.items_that_cover(part.body_part_flags))
		#warn impl
	return ..()

/mob/living/carbon/human/check_overall_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)

/mob/living/carbon/human/run_overall_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)


#warn impl
