//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Projectile Handling *//

/mob/living/carbon/process_bullet_miss(obj/projectile/proj, impact_flags, def_zone, blocked)
	. = ..()
	if(!.)
		return
	// perform normal baymiss
	. = get_zone_with_miss_chance(., src, -10, TRUE)
	// check if we even have that organ; if not, they automatically miss
	if(!get_organ(.))
		return null
