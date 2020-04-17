/**
  * Attempts to move our pulled atom/movable onto the target.
  */
/atom/movable/proc/move_pulled_towards(atom/A)
	if(!pulling)
		return
	if(pulling.anchored || !pulling.Adjacent(src))
		stop_pulling()
		return
	if(isliving(pulling))
		var/mob/living/L = pulling
		if(L.buckled && L.buckled.buckle_prevents_pull) //if they're buckled to something that disallows pulling, prevent it
			stop_pulling()
			return
	if(A == loc && pulling.density)
		return
	if(!Process_Spacemove(get_dir(pulling.loc, A)))
		return
	if(step(pulling, get_dir(pulling.loc, A)))
		on_move_pulled(pulling)

/**
  * Attempts to start pulling an object.
  */
/atom/movable/proc/start_pulling(atom/movable/AM, suppress_message = FALSE)
	if(QDELETED(AM))
		return FALSE
	if(!AM.can_be_pulled(src))
		return FALSE
	if(AM == pulling)
		return FALSE

	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(pulling)
		stop_pulling()
	if(AM.pulledby)
		log_attack("[src] pulled [AM] from [AM.pulledby].")
		// logging overhaul when??
		//log_combat(AM, AM.pulledby, "pulled from", src)
		AM.pulledby.stop_pulling() //an object can't be pulled by two mobs at once.
	pulling = AM
	AM.pulledby = src
	AM.set_glide_size(glide_size)

	if(ismob(AM))
		var/mob/M = AM
		log_attack("[src] started to pull [M].")
		//log_combat(src, M, "grabbed", addition="passive grab")
		if(!suppress_message)
			visible_message("<span class='warning'>[src] has started to pull [M] passively!</span>")
	return TRUE

/**
  * Stops pulling. Returns the object we "dropped" from our pull.
  */
/atom/movable/proc/stop_pulling()
	if(pulling)
		. = pulling
		pulling.pulledby = null
		pulling.reset_glide_size()
		pulling = null

/**
  * Checks if a pull is valid. If it ain't, stop pulling.
  */
/atom/movable/proc/check_pulling()
	if(pulling)
		var/atom/movable/pullee = pulling
		if(pullee && get_dist(src, pullee) > 1)
			stop_pulling()
			return
		if(!isturf(loc))
			stop_pulling()
			return
		if(pullee && !isturf(pullee.loc) && pullee.loc != loc) //to be removed once all code that changes an object's loc uses forceMove().
			stack_trace("[src]'s pull on [pullee] wasn't broken despite [pullee] being in [pullee.loc]. Pull stopped manually.")
			stop_pulling()
			return
		if(pulling.anchored)// || pulling.move_resist > move_force)
			stop_pulling()
			return

/**
  * Checks if we can be pulled by something/someone.
  */
/atom/movable/proc/can_be_pulled(atom/movable/user)	//, force)
	if(src == user || !isturf(loc))
		return FALSE
	if(anchored || throwing)
		return FALSE
/*
	if(force < (move_resist * MOVE_FORCE_PULL_RATIO))
		return FALSE
*/
	return TRUE

/**
  * Hook for stuff to do when we move a pulled atom/movable.
  */
/atom/movable/proc/on_move_pulled(atom/movable/moved)
	if(isliving(pulling) && !istype(pulling.loc, /turf/space))
		var/mob/living/M = pulling
		var/area/A = get_area(M)
		if(A.has_gravity)
			//this is the gay blood on floor shit -- Added back -- Skie
			if (M.lying && (prob(M.getBruteLoss() / 6)))
				var/bloodtrail = 1	//Checks if it's possible to even spill blood
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H.species.flags & NO_BLOOD)
						bloodtrail = 0
					else
						var/blood_volume = round((H.vessel.get_reagent_amount("blood")/H.species.blood_volume)*100)
						if(blood_volume < BLOOD_VOLUME_SURVIVE)
							bloodtrail = 0	//Most of it's gone already, just leave it be
						else
							H.vessel.remove_reagent("blood", 1)
				if(bloodtrail)
					var/turf/location = M.loc
					if(istype(location, /turf/simulated))
						location.add_blood(M)
			//pull damage with injured people
				if(prob(25))
					M.adjustBruteLoss(1)
					visible_message("<span class='danger'>\The [M]'s [M.isSynthetic() ? "state worsens": "wounds open more"] from being dragged!</span>")
			if(M.pull_damage())
				if(prob(25))
					M.adjustBruteLoss(2)
					visible_message("<span class='danger'>\The [M]'s [M.isSynthetic() ? "state" : "wounds"] worsen terribly from being dragged!</span>")
					var/turf/location = M.loc
					if (istype(location, /turf/simulated))
						var/bloodtrail = 1	//Checks if it's possible to even spill blood
						if(ishuman(M))
							var/mob/living/carbon/human/H = M
							if(H.species.flags & NO_BLOOD)
								bloodtrail = 0
							else
								var/blood_volume = round((H.vessel.get_reagent_amount("blood")/H.species.blood_volume)*100)
								if(blood_volume < BLOOD_VOLUME_SURVIVE)
									bloodtrail = 0	//Most of it's gone already, just leave it be
								else
									H.vessel.remove_reagent("blood", 1)
						if(bloodtrail)
							if(istype(location, /turf/simulated))
								location.add_blood(M)
