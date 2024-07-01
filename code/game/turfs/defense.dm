/turf/break_apart(method)
	ScrapeAway(1, CHANGETURF_INHERIT_AIR)

/turf/proc/run_ex_act(power, list/damage_multiplier)
	// first, take into account ourselves; we do shield our contents.
	var/remaining = ex_act(power, damage_multiplier)
	// KEEP IN MIND
	// the above might cause us to be destroyed, and therefore ChangeTurf'd
	. = remaining
	if(covers_underfloor_objects())
		// if underfloor is covered, run obj/mob separately
		for(var/obj/AM in contents)
			if(AM.atom_flags & (ATOM_ABSTRACT))
				continue
			// underfloor is covered
			if(AM.hides_underfloor == OBJ_UNDERFLOOR_ALWAYS)
				continue
			// dampen power left after an object impedes it, but only by the % it impeded,
			// stacking multiplicatively.
			. *= AM.ex_act(power, damage_multiplier) / remaining
		for(var/mob/AM in contents)
			if(AM.atom_flags & (ATOM_ABSTRACT))
				continue
			// dampen power left after an object impedes it, but only by the % it impeded,
			// stacking multiplicatively.
			. *= AM.ex_act(power, damage_multiplier) / remaining
	else
		for(var/atom/movable/AM as anything in contents)
			if(AM.atom_flags & (ATOM_ABSTRACT))
				continue
			// dampen power left after an object impedes it, but only by the % it impeded,
			// stacking multiplicatively.
			. *= AM.ex_act(power, damage_multiplier) / remaining

/turf/ex_act(power, list/damage_multiplier)
	return power * explosion_block_exp - explosion_block_lin
