/mob/CanAllowThrough(atom/movable/mover, turf/target)
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
	// what the hell does this do i don't know fine we'll keep it for now..
	if (buckled && buckled.loc != NewLoc) //not updating position
		if(istype(buckled, /mob))	//If you're buckled to a mob, a la slime things, keep on rolling.
			return buckled.Move(NewLoc, Dir)
		else	//Otherwise, no running around for you.
			return 0
	// end

	. = ..()

	if (s_active && !( s_active in contents ) && !(s_active.Adjacent(src)))	//check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.close(src)
