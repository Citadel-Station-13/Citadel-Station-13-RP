//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Projectile Handling *//

/mob/living/carbon/process_bullet_miss(obj/projectile/proj, impact_flags, def_zone, efficiency)
	. = ..()
	if(!.)
		return
	// perform normal baymiss
	. = get_zone_with_miss_chance(., src, -10, TRUE)
	// check if we even have that organ; if not, they automatically miss
	if(!get_organ(.))
		return null

//* Misc Effects *//

/mob/living/carbon/electrocute_act(efficiency, energy, damage, stun_power, flags, hit_zone, atom/movable/source, list/shared_blackboard, out_energy_consumed)
	if(!(flags & ELECTROCUTE_ACT_FLAG_INTERNAL))
		if(species.species_flags & IS_PLANT)
			switch(hit_zone)
				if("l_hand")
					efficiency = 0
				if("r_hand")
					efficiency = 0
	return ..()

/mob/living/carbon/inflict_electrocute_damage(damage, stun_power, flags, hit_zone)
	flash_pain()
	if(damage)
		if(!hit_zone || (flags & (ELECTROCUTE_ACT_FLAG_DISTRIBUTE | ELECTROCUTE_ACT_FLAG_UNIFORM)))
			// hit beyond one part
			take_overall_damage(0, damage, null, "electrical burns")
		else
			// hit one part
			apply_damage(damage, DAMAGE_TYPE_BURN, hit_zone, used_weapon = "electrical burns")
	if(stun_power)
		#warn impl

/mob/living/carbon/slip_act(slip_class, source, hard_strength, soft_strength, suppressed)
	. = ..()
	if(buckled)
		return 0
	tactile_feedback(SPAN_WARNING("You slipped on \the [source]!"))
	// todo: sound should be on component / tile?
	playsound(src, 'sound/misc/slip.ogg', 50, TRUE, -3)
	afflict_paralyze(hard_strength)
	afflict_knockdown(soft_strength)
