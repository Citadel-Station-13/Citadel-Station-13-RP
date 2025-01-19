//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/simple_mob/electrocute_act(efficiency, energy, damage, stun_power, flags, hit_zone, atom/movable/source, list/shared_blackboard, out_energy_consumed)
	if(!(flags & ELECTROCUTE_ACT_FLAG_INTERNAL))
		if(species.species_flags & IS_PLANT)
			switch(hit_zone)
				if("l_hand")
					efficiency = 0
				if("r_hand")
					efficiency = 0
	return ..()

/mob/living/simple_mob/inflict_electrocute_damage(damage, stun_power, flags, hit_zone)
	if(taser_kill)
		damage += stun_power * 0.5
	take_overall_damage(0, damage, null, "electrical burns")
