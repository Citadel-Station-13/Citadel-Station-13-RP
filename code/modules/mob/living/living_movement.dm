/mob/living/CanPass(atom/movable/mover, turf/target, height, air_group)
	/* DEATH TO ZAS	*/
	if(air_group || height == 0)
		return TRUE
	/*				*/
	if((mover.pass_flags & PASSMOB))
		return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	if(mover.throwing)
//		return (!density || !(mobility_flags & MOBILITY_STAND))
		return (!density || lying)
	if(buckled == mover)
		return TRUE
	if(ismob(mover))
		if(mover in buckled_mobs)
			return TRUE

		if ((other_mobs && moving_mob.other_mobs))		//REFACTOR GRABS ALREADY REE
			return 1

//	return (!mover.density || !density || !(mobility_flags & MOBILITY_STAND))
	return (!mover.density || !density || lying)		//Get rid of this when mobility flags are done obviously
