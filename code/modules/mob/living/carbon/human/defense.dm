/mob/living/carbon/human/check_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/obj/item/organ/external/part = get_organ(target_zone)
	for(var/obj/item/I as anything in inventory?.items_that_cover(part.body_part_flags))
		var/list/results = I.checking_mob_armor(arglist(args))
		damage = results[1]
		mode = results[4]
	return ..()

/mob/living/carbon/human/run_mob_armor(damage, tier, flag, mode, attack_type, datum/weapon, target_zone)
	var/obj/item/organ/external/part = get_organ(target_zone)
	for(var/obj/item/I as anything in inventory?.items_that_cover(part.body_part_flags))
		var/list/results = I.running_mob_armor(arglist(args))
		damage = results[1]
		mode = results[4]
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
			var/list/results = I.checking_mob_armor(resultant, tier, flag, mode, attack_type, weapon, target_zone)
			resultant = results[1]
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
			var/list/results = I.running_mob_armor(resultant, tier, flag, mode, attack_type, weapon, target_zone)
			resultant = results[1]
		total += resultant * rel_size
		total_size += rel_size
	damage = total / total_size
	return ..()
