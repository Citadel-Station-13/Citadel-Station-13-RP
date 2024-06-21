/turf/break_apart(method)
	ScrapeAway(1, CHANGETURF_INHERIT_AIR)

/turf/proc/run_ex_act(power, list/damage_multiplier)
	// first, take into account ourselves; we do shield our contents.
	var/remaining = ex_act(power, damage_multiplier)
	. = remaining
	for(var/atom/movable/AM as anything in contents)
		if(AM.atom_flags & (ATOM_ABSTRACT))
			continue
		// dampen power left after an object impedes it, but only by the % it impeded,
		// stacking multiplicatively.
		. *= AM.ex_act(power, damage_multiplier) / remaining


/turf/ex_act(power, list/damage_multiplier)
	return power * explosion_block_exp - explosion_block_lin
