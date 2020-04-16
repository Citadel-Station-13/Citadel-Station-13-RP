/mob/CanPass(atom/movable/mover, turf/target)
	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	return (!mover.density || !density || lying)

/mob/CanZASPass(turf/T, is_zone)
	return ATMOS_PASS_YES

/**
  * Toggle the move intent of the mob
  *
  * triggers an update the move intent hud as well
  */
/mob/proc/toggle_move_intent(mob/user)
	if(m_intent == MOVE_INTENT_RUN)
		m_intent = MOVE_INTENT_WALK
	else
		m_intent = MOVE_INTENT_RUN
/*
	if(hud_used && hud_used.static_inventory)
		for(var/obj/screen/mov_intent/selector in hud_used.static_inventory)
			selector.update_icon()
*/
	// nah, vorecode bad.
	hud_used?.move_intent?.icon_state = (m_intent == MOVE_INTENT_RUN)? "running" : "walking"

/mob/living/movement_delay()
	. = ..()
	switch(m_intent)
		if(MOVE_INTENT_RUN)
			if(drowsyness > 0)
				. += 6
			. += config_legacy.run_speed
		if(MOVE_INTENT_WALK)
			. += config_legacy.walk_speed

/mob/living/Move(NewLoc, Dir)
	if (buckled && buckled.loc != a) //not updating position
		if(istype(buckled, /mob))	//If you're buckled to a mob, a la slime things, keep on rolling.
			return buckled.Move(a, b)
		else	//Otherwise, no running around for you.
			return 0

	if (restrained())
		stop_pulling()


	var/t7 = 1
	if (restrained())
		for(var/mob/living/M in range(src, 1))
			if ((M.pulling == src && M.stat == 0 && !( M.restrained() )))
				t7 = null
	if ((t7 && (pulling && ((get_dist(src, pulling) <= 1 || pulling.loc == loc) && (client && client.moving)))))
		var/turf/T = loc
		. = ..()

		if (pulling && pulling.loc)
			if(!( isturf(pulling.loc) ))
				stop_pulling()
				return

		/////
		if(pulling && pulling.anchored)
			stop_pulling()
			return

		if (!restrained())
			var/diag = get_dir(src, pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, pulling) > 1 || diag))
				if (isliving(pulling))
					var/mob/living/M = pulling
					var/atom/movable/t = M.pulling
					M.stop_pulling()

					if(!istype(M.loc, /turf/space))
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

					if(get_dist(pulling.loc, T) > 1 || pulling.loc.z != T.z)
						M.stop_pulling()
					else
						step(pulling, get_dir(pulling.loc, T))
						if(t)
							M.start_pulling(t)
				else
					if (pulling)
						if (istype(pulling, /obj/structure/window))
							var/obj/structure/window/W = pulling
							if(W.is_fulltile())
								for(var/obj/structure/window/win in get_step(pulling,get_dir(pulling.loc, T)))
									stop_pulling()

						if(get_dist(pulling.loc, T) > 1 || pulling.loc.z != T.z) // This is needed or else pulled objects can't get pushed away.
							stop_pulling()
						else
							step(pulling, get_dir(pulling.loc, T))
	else
		stop_pulling()
		. = ..()

	if (s_active && !( s_active in contents ) && get_turf(s_active) != get_turf(src))	//check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.close(src)
