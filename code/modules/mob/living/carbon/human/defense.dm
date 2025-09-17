//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/mob/living/carbon/human/run_armorcalls(list/shieldcall_args, fake_attack, filter_zone)
	..() // perform default /mob level

	if(filter_zone)
		// just one zone
		var/obj/item/organ/external/part = get_organ(filter_zone)
		for(var/obj/item/I as anything in inventory?.query_coverage(part.body_part_flags))
			I.mob_armorcall(src, shieldcall_args, fake_attack)
			if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAG_TERMINATE)
				break
		return

	var/damage = shieldcall_args[SHIELDCALL_ARG_DAMAGE]
	// all zones, uh oh, this is about to get very ugly
	var/total = 0
	var/total_size = 0
	for(var/key in organs_by_name)
		var/rel_size = organ_rel_size[key]
		if(!rel_size)
			continue
		var/obj/item/organ/external/part = organs_by_name[key]
		var/resultant = damage
		for(var/obj/item/I as anything in inventory?.query_coverage(part.body_part_flags))
			var/list/copied_args = args.Copy()
			copied_args[SHIELDCALL_ARG_DAMAGE] = resultant
			I.mob_armorcall(src, copied_args, fake_attack)
			resultant = copied_args[SHIELDCALL_ARG_DAMAGE]
		total += resultant * rel_size
		total_size += rel_size
	shieldcall_args[SHIELDCALL_ARG_DAMAGE] = total / total_size
