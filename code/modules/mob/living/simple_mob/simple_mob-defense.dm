//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/simple_mob/inflict_electrocute_damage(damage, stun_power, flags, hit_zone)
	if(taser_kill)
		damage += stun_power * 0.5
	take_overall_damage(0, damage, null, "electrical burns")
