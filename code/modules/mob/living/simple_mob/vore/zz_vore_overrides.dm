
/mob/living/simple_mob/animal/mimic
	vore_active = 1
	// NO VORE SPRITES
	vore_capacity = 0
	vore_pounce_chance = 33
	// Overrides to non-vore version
	maxHealth = 60
	health = 60

/mob/living/simple_mob/animal/passive/cat
	vore_active = 1
	// NO VORE SPRITES
	specific_targets = 0 // Targeting UNLOCKED
	vore_max_size = RESIZE_TINY

/mob/living/simple_mob/animal/passive/cat/PunchTarget()
	if(istype(target_mob,/mob/living/simple_mob/mouse))
		visible_message("<span class='warning'>\The [src] pounces on \the [target_mob]!]</span>")
		target_mob.Stun(5)
		return EatTarget()
	else ..()

/mob/living/simple_mob/animal/passive/cat/Found(var/atom/found_atom)
	if(!SA_attackable(found_atom))
		return null
	if(istype(found_atom,/mob/living/simple_mob/mouse))
		return found_atom
	if(found_atom in friends)
		return null
	if(will_eat(found_atom))
		return found_atom

/mob/living/simple_mob/animal/passive/cat/fluff/Found(var/atom/found_atom)
	if (friend == found_atom)
		return null
	return ..()

/mob/living/simple_mob/animal/passive/cat/fluff
	vore_ignores_undigestable = 0
	vore_pounce_chance = 100
	vore_digest_chance = 0 // just use the toggle
	vore_default_mode = DM_HOLD //can use the toggle if you wanna be catfood
	vore_standing_too = TRUE //gonna get pounced

/mob/living/simple_mob/animal/passive/cat/fluff/EatTarget()
	var/mob/living/TM = target_mob
	prey_excludes += TM //so they won't immediately re-eat someone who struggles out (or gets newspapered out) as soon as they're ate
	spawn(3600) // but if they hang around and get comfortable, they might get ate again
		if(src && TM)
			prey_excludes -= TM
	..() // will_eat check is carried out before EatTarget is called, so prey on the prey_excludes list isn't a problem.

/mob/living/simple_mob/animal/fox
	vore_active = 1
	// NO VORE SPRITES
	vore_max_size = RESIZE_TINY

/mob/living/simple_mob/animal/fox/PunchTarget()
	if(istype(target_mob,/mob/living/simple_mob/mouse))
		return EatTarget()
	else ..()

/mob/living/simple_mob/animal/fox/Found(var/atom/found_atom)
	if(!SA_attackable(found_atom))
		return null
	if(istype(found_atom,/mob/living/simple_mob/mouse))
		return found_atom
	if(found_atom in friends)
		return null
	if(will_eat(found_atom))
		return found_atom

/mob/living/simple_mob/animal/fox/fluff/Found(var/atom/found_atom)
	if (friend == found_atom)
		return null
	return ..()

/mob/living/simple_mob/animal/fox/fluff
	vore_ignores_undigestable = 0
	vore_pounce_chance = 100
	vore_digest_chance = 0 // just use the toggle
	vore_default_mode = DM_HOLD //can use the toggle if you wanna be foxfood
	vore_standing_too = TRUE // gonna get pounced

/mob/living/simple_mob/animal/fox/fluff/EatTarget()
	var/mob/living/TM = target_mob
	prey_excludes += TM //so they won't immediately re-eat someone who struggles out (or gets newspapered out) as soon as they're ate
	spawn(3600) // but if they hang around and get comfortable, they might get ate again
		if(src && TM)
			prey_excludes -= TM
	..() // will_eat check is carried out before EatTarget is called, so prey on the prey_excludes list isn't a problem.
