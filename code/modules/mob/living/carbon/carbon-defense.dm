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

/mob/living/carbon/slip_act(slip_class, source, hard_strength, soft_strength, suppressed)
	. = ..()
	if(buckled)
		return 0
	tactile_feedback(SPAN_WARNING("You slipped on \the [source]!"))
	// todo: sound should be on component / tile?
	playsound(src, 'sound/misc/slip.ogg', 50, TRUE, -3)
	afflict_paralyze(hard_strength)
	afflict_knockdown(soft_strength)
