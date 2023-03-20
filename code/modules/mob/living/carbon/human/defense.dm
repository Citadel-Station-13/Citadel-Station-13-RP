/mob/living/carbon/human/check_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/obj/item/organ/external/part = get_organ(target_zone)
	for(var/obj/item/I as anything in inventory?.items_that_cover(part.body_part_flags))
		damage = I.fetch_armor().resultant_damage(damage, tier, flag)
	return ..()

/mob/living/carbon/human/run_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/obj/item/organ/external/part = get_organ(target_zone)
	for(var/obj/item/I as anything in inventory?.items_that_cover(part.body_part_flags))
		damage = I.fetch_armor().resultant_damage(damage, tier, flag)
	return ..()

/mob/living/carbon/human/check_overall_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/total = 0
	var/total_size = 0
	for(var/key in organs_by_name)
		var/rel_size = organ_rel_size[key]
		if(!rel_size)
			continue
		var/obj/item/organ/external/part = organs_by_name[key]
		var/resultant = damage
		for(var/obj/item/I as anything in inventory?.items_that_cover(part.body_part_flags))
			resultant = I.fetch_armor().resultant_damage(resultant, tier, flag)
		total += resultant * rel_size
		total_size += rel_size
	damage = total / total_size
	return ..()

/mob/living/carbon/human/run_overall_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/total = 0
	var/total_size = 0
	for(var/key in organs_by_name)
		var/rel_size = organ_rel_size[key]
		if(!rel_size)
			continue
		var/obj/item/organ/external/part = organs_by_name[key]
		var/resultant = damage
		for(var/obj/item/I as anything in inventory?.items_that_cover(part.body_part_flags))
			resultant = I.fetch_armor().resultant_damage(resultant, tier, flag)
		total += resultant * rel_size
		total_size += rel_size
	damage = total / total_size
	return ..()
