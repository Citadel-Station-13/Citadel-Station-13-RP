/mob/living/movement_delay()
	. = ..()
	switch(m_intent)
		if(MOVE_INTENT_RUN)
			if(drowsyness > 0)
				. += 6
			. += config_legacy.run_speed
		if(MOVE_INTENT_WALK)
			. += config_legacy.walk_speed

/mob/living/Move(atom/newloc, direct, glide_size_override)
	if(buckled && buckled.loc != newloc)
		return FALSE
	return ..()

/mob/living/Moved()
	. = ..()
	if(s_active && !CheapReachability(s_active))
		s_active.close(src)

/mob/living/forceMove(atom/destination)
	if(buckled && (buckled.loc != destination))
		unbuckle(BUCKLE_OP_FORCE | BUCKLE_OP_SILENT)
	return ..()

///Checks mobility move as well as parent checks
/mob/living/canface()
/*
	if(!(mobility_flags & MOBILITY_MOVE))
		return FALSE
*/
	if(stat != CONSCIOUS)
		return FALSE
	return ..()


/mob/living/CanAllowThrough(atom/movable/mover, turf/target)
	if(ismob(mover))
		var/mob/M = mover
		if(buckled && M.buckled == buckled)
			// riding same thing, don't block each other
			return TRUE
	// can't throw blob stuff through blob stuff
	if(istype(mover, /obj/structure/blob) && faction == "blob" && !mover.throwing) //Blobs should ignore things on their faction.
		return TRUE
	return ..()

//Called when something steps onto us. This allows for mulebots and vehicles to run things over. <3
/mob/living/Crossed(var/atom/movable/AM) // Transplanting this from /mob/living/carbon/human/Crossed()
	if(AM == src || AM.is_incorporeal()) // We're not going to run over ourselves or ghosts
		return

	if(istype(AM, /mob/living/bot/mulebot))
		var/mob/living/bot/mulebot/MB = AM
		MB.runOver(src)

	if(istype(AM, /obj/vehicle_old))
		var/obj/vehicle_old/V = AM
		V.RunOver(src)
	return ..()

/mob/living/proc/handle_stumbling(obj/O)
	if(!can_stumble_into(O))
		return FALSE
	O.stumble_into(src)
	return TRUE

/mob/living/proc/can_stumble_into(obj/O)
	if(!O.anchored)
		return FALSE
	if(!(confused || is_blind()))
		return FALSE
	if(!STAT_IS_CONSCIOUS(stat))
		return FALSE
	if(m_intent != MOVE_INTENT_RUN)
		return FALSE
	if(!prob(50))
		return FALSE
	return TRUE

/mob/living/Bump(atom/A)
	var/skip_atom_bump_handling
	if(throwing)
		skip_atom_bump_handling = TRUE
	. = ..()
	if(!skip_atom_bump_handling)
		_handle_atom_bumping(A)

/mob/living/proc/_handle_atom_bumping(atom/A)
	set waitfor = FALSE
	if(_pushing_bumped_atom)
		return
	if(buckled)		// nope!
		return
	_pushing_bumped_atom = TRUE
	if(isliving(A) && handle_living_bump(A))
		_pushing_bumped_atom = FALSE
		return
	if(isobj(A) && handle_obj_bump(A))
		_pushing_bumped_atom = FALSE
		return
	if(ismovable(A) && handle_movable_bump(A))
		_pushing_bumped_atom = FALSE
		return
	_pushing_bumped_atom = FALSE

/**
 * handles mob bumping/fire spread/pushing/etc
 */
/mob/living/proc/handle_living_bump(mob/living/L)
	// first of all spread the love of FIRE
	spread_fire(L)

	// alright well fuck micros
	// first order of business: check if they're a micro or if we are
	if(fetish_hook_for_help_intent_swapping(L) || fetish_hook_for_non_help_intent_bumps(L))
		bump_position_swap(L, TRUE)
		return TRUE		// fuck you fetishcode

	// then comes the signal
	// SEND_SIGNAL(src, COMSIG_LIVING_PUSHING_MOB, L)

	// handcuffed check - can't bump past, or even force-move past (yeah sorry bad design) cuffed people
	if(L.restrained() && L.pulledby != src)
		if(!(world.time % 5))
			to_chat(src, SPAN_WARNING("[L] is restrained, you cannot push past."))
		return TRUE

	if(L.pulling && ismob(L.pulling))
		var/mob/M = L.pulling
		if(M.restrained())
			if(!(world.time % 5))
				to_chat(src, SPAN_WARNING("[L] is restraining [M], you cannot push past."))
			return TRUE

	// todo: crawling
	//CIT CHANGES START HERE - makes it so resting stops you from moving through standing folks or over prone bodies without a short delay
	/*
		if(!CHECK_MOBILITY(src, MOBILITY_STAND))
			var/origtargetloc = L.loc
			if(!pulledby)
				if(combat_flags & COMBAT_FLAG_ATTEMPTING_CRAWL)
					return TRUE
				if(IS_STAMCRIT(src))
					to_chat(src, "<span class='warning'>You're too exhausted to crawl [(CHECK_MOBILITY(L, MOBILITY_STAND)) ? "under": "over"] [L].</span>")
					return TRUE
				combat_flags |= COMBAT_FLAG_ATTEMPTING_CRAWL
				visible_message("<span class='notice'>[src] is attempting to crawl [(CHECK_MOBILITY(L, MOBILITY_STAND)) ? "under" : "over"] [L].</span>",
					"<span class='notice'>You are now attempting to crawl [(CHECK_MOBILITY(L, MOBILITY_STAND)) ? "under": "over"] [L].</span>",
					target = L, target_message = "<span class='notice'>[src] is attempting to crawl [(CHECK_MOBILITY(L, MOBILITY_STAND)) ? "under" : "over"] you.</span>")
				if(!do_after(src, CRAWLUNDER_DELAY, target = src) || CHECK_MOBILITY(src, MOBILITY_STAND))
					combat_flags &= ~(COMBAT_FLAG_ATTEMPTING_CRAWL)
					return TRUE
			var/src_ATOM_PASS_mob = (pass_flags & ATOM_PASS_MOB)
			pass_flags |= ATOM_PASS_MOB
			Move(origtargetloc)
			if(!src_ATOM_PASS_mob)
				pass_flags &= ~ATOM_PASS_MOB
			combat_flags &= ~(COMBAT_FLAG_ATTEMPTING_CRAWL)
			return TRUE
	*/
	//END OF CIT CHANGES

	// we can either push past or swap
	if(can_bump_position_swap(L))
		bump_position_swap(L)
		return TRUE

	// sigh
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.species.lightweight && prob(50))
			H.Weaken(5)
			H.visible_message(SPAN_WARNING("[src] bumps into [H], knocking them to the floor!"))
			return TRUE

	// if not, can we bump
	// we just return at this point to let the other code handle it
	. = !can_bump_push_mob(L)
	if(.)
		// idk why this is here but i'm keeping it i guess
		L.LAssailant = src

/**
 * swaps us with another mob. assumes they're next to us.
 *
 * second arg lets us move onto them instead of swap past, used for size fetish shitcode
 * apologies.
 */
/mob/living/proc/bump_position_swap(mob/living/them, move_onto)
	// if we aren't on them for some reason maybe like
	if(!loc?.Adjacent(them))
		// don't
		return FALSE
	// warning: this is usually shitcode
	// store old flags
	var/src_pass_mob = pass_flags & ATOM_PASS_MOB
	var/their_pass_mob = them.pass_flags & ATOM_PASS_MOB

	// swap
	var/src_old_loc = loc
	var/their_old_loc = them.loc
	var/move_failed = FALSE
	var/atom/movable/old_pulling = pulling

	if(move_onto)
		pass_flags |= ATOM_PASS_MOB
		if(!Move(their_old_loc))
			forceMove(src_old_loc)
			move_failed = TRUE
	else
		pass_flags |= ATOM_PASS_MOB
		them.pass_flags |= ATOM_PASS_MOB
		if(!them.Move(src_old_loc) || !Move(their_old_loc))
			forceMove(src_old_loc)
			them.forceMove(their_old_loc)
			move_failed = TRUE

	// restore
	if(!src_pass_mob)
		pass_flags &= ~ATOM_PASS_MOB
	if(!their_pass_mob)
		them.pass_flags &= ~ATOM_PASS_MOB
	if(move_failed)
		start_pulling(old_pulling, suppress_message = TRUE)
	return !move_failed

/**
 * checks if we can swap with another mob
 */
/mob/living/proc/can_bump_position_swap(mob/living/them)
	// we must both be on help (or restrained) (or be pulling them)
	// todo: only grabs should work for this..
	var/we_are_grabbing_them = them == pulling
	if(a_intent != INTENT_HELP && !restrained())
		return FALSE
	if(them.a_intent != INTENT_HELP && !them.restrained() && !we_are_grabbing_them)
		return FALSE

	// sigh, polaris.
	if(!can_move_mob(them, TRUE))
		// todo: nuke can_move_mob from orbit and either replace or remove flags.
		return FALSE

	// neither of us can have buckled mobs
	if(has_buckled_mobs() || them.has_buckled_mobs())
		return FALSE

	// can't have too little move force
	if(move_force < them.move_resist * MOVE_FORCE_PUSH_RATIO)
		return FALSE

	return TRUE

/**
 * checks if we can push another mob
 */
/mob/living/proc/can_bump_push_mob(mob/living/them)
	// check status flags
	if(!(them.status_flags & CANPUSH))
		return FALSE
	//? TRAIT_PUSHIMMUNE checked in movable bump
	//! this isn't active until we get mobility flags, right click, and shoving
	// check intent if not help do not allow push unless they're dead
	// if(them.a_intent != INTENT_HELP && !STAT_IS_DEAD(them.stat))
	//	return TRUE
	// if our intent is help, do not push
	if(a_intent == INTENT_HELP)
		return FALSE
	//! snowflake bullshit from upstream
	if(them.get_held_item_of_type(/obj/item/shield) && prob(99))
		return FALSE
	// todo: nuke above from orbit, as well as below (more stuff but not snowflakey from upstream)
	if(!can_move_mob(them, FALSE))
		return FALSE
	return TRUE

/**
 * handles obj bumping/fire spread/pushing/etc
 */
/mob/living/proc/handle_obj_bump(obj/O)
	// this proc is there for people to hook but we don't care in general
	// signal sent regardless of success
	// SEND_SIGNAL(src, COMSIG_LIVING_PUSHING_OBJ, O)
	if(handle_stumbling(O))
		return TRUE
	return FALSE

//? todo: this system of force move/move crush is shit

/**
 * handles generic movable bumping/fire spread/pushing/etc
 */
/mob/living/proc/handle_movable_bump(atom/movable/AM)
	return push_movable(AM)

/mob/living/proc/push_movable(atom/movable/AM, force = move_force)
	// no crushing during diagonal moves
	if(moving_diagonally)
		return

	var/dir_to_target = get_dir(src, AM)

	// get effective force/resists
	var/resist = AM.move_resist
	var/atom/movable/pushing = AM
	var/mob/M = ismob(AM)? AM : null

	// redirect forces to buckled if it prevents move
	if(M?.buckled)
		resist = M.buckled.move_resist
		pushing = M.buckled

	// signal sent regardless of success
	// SEND_SIGNAL(src, COMSIG_LIVING_PUSHING_MOVABLE, AM)

	// are we strong enough to push at all?
	if((resist * MOVE_FORCE_PUSH_RATIO) > force)
		return

	if(HAS_TRAIT(AM, TRAIT_PUSHIMMUNE))
		return

	// break pulls on pushing. if AM was pulled, they'd break from the move.
	if(pushing == pulling)
		stop_pulling()
	// break their pulls
	if(pulledby == AM || pulledby == pushing)
		pulledby.stop_pulling()

	// If there's no dir_to_target then the player is on the same turf as the atom they're trying to push.
	// This can happen when a player is stood on the same turf as a directional window. All attempts to push
	// the window will fail as get_dir will return 0 and the player will be unable to move the window when
	// it should be pushable.
	// In this scenario, we will use the facing direction of the /mob/living attempting to push the atom as
	// a fallback.
	if(!dir_to_target)
		dir_to_target = dir

	//? eventually we want to only allow crushing on harm intent
	var/move_anchored = FALSE
	if((resist * MOVE_FORCE_CRUSH_RATIO) <= force)
		if(move_crush(pushing, force, dir_to_target))
			move_anchored = TRUE
	if((resist * MOVE_FORCE_FORCEPUSH_RATIO) <= force)
		if(force_push(pushing, force, dir_to_target, move_anchored))
			move_anchored = TRUE

	// are we allowed to barge through
	if(pushing.anchored && !move_anchored)
		return

	// don't do the weird dir shuffle if they're a mob
	var/their_dir = isliving(pushing) && pushing.dir

	// push them
	if(pushing.Move(get_step(pushing.loc, dir_to_target), dir_to_target, glide_size))
		pushing.add_fingerprint(src)
		// follow through on success
		Move(get_step(loc, dir_to_target), dir_to_target)

	// restore dir if needed
	if(their_dir)
		pushing.setDir(their_dir)
