//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Damage Instance Handling *//

/mob/living/silicon/run_damage_instance(damage, damage_type, damage_tier, damage_flag, damage_mode, attack_type, datum/weapon, shieldcall_flags, hit_zone, list/additional, datum/event_args/actor/clickchain/clickchain)
	// we only care about those
	switch(damage_type)
		if(BRUTE)
		if(BURN)
		else
			return
	return ..()

/mob/living/silicon/inflict_damage_instance(damage, damage_type, damage_tier, damage_flag, damage_mode, attack_type, datum/weapon, shieldcall_flags, hit_zone, list/additional, datum/event_args/actor/clickchain/clickchain)
	// we only care about those
	switch(damage_type)
		if(BRUTE)
			adjustBruteLoss(damage)
		if(BURN)
			adjustBruteLoss(damage)
