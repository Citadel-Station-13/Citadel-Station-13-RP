/mob/living/Moved()
	. = ..()
	//update_turf_movespeed(loc)
	if(is_shifted)
		is_shifted = FALSE
		pixel_x = get_standard_pixel_x_offset(lying)
		pixel_y = get_standard_pixel_y_offset(lying)

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
	if(istype(mover, /obj/structure/blob) && faction == "blob") //Blobs should ignore things on their faction.
		return TRUE
	return ..()

//Called when something steps onto us. This allows for mulebots and vehicles to run things over. <3
/mob/living/Crossed(var/atom/movable/AM) // Transplanting this from /mob/living/carbon/human/Crossed()
	if(AM == src || AM.is_incorporeal()) // We're not going to run over ourselves or ghosts
		return

	if(istype(AM, /mob/living/bot/mulebot))
		var/mob/living/bot/mulebot/MB = AM
		MB.runOver(src)

	if(istype(AM, /obj/vehicle))
		var/obj/vehicle/V = AM
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

#warn old below

/mob/living/Bump(atom/movable/AM)
	var/old_pulling = pulling
	if (istype(AM, /mob/living))
		var/mob/living/tmob = AM

		//Even if we don't push/swap places, we "touched" them, so spread fire
		spread_fire(tmob)

		for(var/mob/living/M in range(tmob, 1))
			if(tmob.pinned.len ||  ((M.pulling == tmob && ( tmob.restrained() && !( M.restrained() ) && M.stat == 0)) || locate(/obj/item/grab, tmob.grabbed_by.len)) )
				if ( !(world.time % 5) )
					to_chat(src, "<span class='warning'>[tmob] is restrained, you cannot push past</span>")
				now_pushing = 0
				return
			if( tmob.pulling == M && ( M.restrained() && !( tmob.restrained() ) && tmob.stat == 0) )
				if ( !(world.time % 5) )
					to_chat(src, "<span class='warning'>[tmob] is restraining [M], you cannot push past</span>")
				now_pushing = 0
				return

		//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
		var/can_swap = 1
		if(loc.density || tmob.loc.density)
			can_swap = 0
		if(can_swap)
			for(var/atom/movable/A in loc)
				if(A == src)
					continue
				if(!A.CanPass(tmob, loc))
					can_swap = 0
				if(!can_swap) break
		if(can_swap)
			for(var/atom/movable/A in tmob.loc)
				if(A == tmob)
					continue
				if(!A.CanPass(src, tmob.loc))
					can_swap = 0
				if(!can_swap) break

		//Leaping mobs just land on the tile, no pushing, no anything.
		if(status_flags & LEAPING)
			forceMove(tmob.loc)
			status_flags &= ~LEAPING
			now_pushing = 0
			return

		if((tmob.mob_always_swap || (tmob.a_intent == INTENT_HELP || tmob.restrained()) && (a_intent == INTENT_HELP || src.restrained())) && tmob.canmove && canmove && !tmob.buckled && !buckled && can_swap && can_move_mob(tmob, 1, 0)) // mutual brohugs all around!
			var/turf/oldloc = loc
			forceMove(tmob.loc)

			if (istype(tmob, /mob/living/simple_mob)) //check bumpnom chance, if it's a simplemob that's bumped
				tmob.Bumped(src)
			else if(istype(src, /mob/living/simple_mob)) //otherwise, if it's a simplemob doing the bumping. Simplemob on simplemob doesn't seem to trigger but that's fine.
				Bumped(tmob)
			if (tmob.loc == src) //check if they got ate, and if so skip the forcemove
				now_pushing = 0
				return

			// In case of micros, we don't swap positions; instead occupying the same square!
			if (handle_micro_bump_helping(tmob))
				now_pushing = 0
				return
			// TODO - Check if we need to do something about the slime.UpdateFeed() we are skipping below.

			tmob.forceMove(oldloc)
			if(old_pulling)
				start_pulling(old_pulling, supress_message = TRUE)
			now_pushing = 0
			return

		else if((tmob.mob_always_swap || (tmob.a_intent == INTENT_HELP || tmob.restrained()) && (a_intent == INTENT_HELP || src.restrained())) && canmove && can_swap && handle_micro_bump_helping(tmob))
			forceMove(tmob.loc)
			now_pushing = 0
			if(old_pulling)
				start_pulling(old_pulling, supress_message = TRUE)
			return


		if(!can_move_mob(tmob, 0, 0))
			now_pushing = 0
			return
		if(a_intent == INTENT_HELP || src.restrained())
			now_pushing = 0
			return

		// Plow that nerd.
		if(ishuman(tmob))
			var/mob/living/carbon/human/H = tmob
			if(H.species.lightweight == 1 && prob(50))
				H.visible_message("<span class='warning'>[src] bumps into [H], knocking them off balance!</span>")
				H.Weaken(5)
				now_pushing = 0

#warn old above, new below, sort it out

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
		return
	if(isobj(A) && handle_obj_bump(A))
		return
	if(ismovable(A) && handle_movable_bump(A))
		return
	_pushing_bumped_atom = FALSE

#warn impl

/**
 * handles mob bumping/fire spread/pushing/etc
 */
/mob/living/proc/handle_living_bump(mob/living/L)
	// first of all spread the love of FIRE
	spread_fire(L)

	// then comes the signal
	// SEND_SIGNAL(src, COMSIG_LIVING_PUSHING_MOB, L)

	// handcuffed check - can't bump past, or even force-move psat (yeah sorry bad design) cuffed people

	// main checks
	var/can_swap = FALSE



	// handcuffs:

	//! stupid fetish shit
	#warn we have to use pass flags swapping
	if(fetish_hook_for_help_intent_swapping(other))
	if(a_intent == INTENT_HELP && L.a_intent == INTENT_HELP && )


	//

	//! if we can't swap, do stupid fetish checks
	if(handle_micro_bump_other(L))
		return

	// if we can't push, skip other bump stuff
	if(!can_bump_push_mob(L))
		return TRUE
	else
		// provoke (tm) (it doesn't really, unfortnuately...)
		L.LAssailant = src

	#warn let handle movable bump handle pushing
	#warn do not push if on help intent, ever

/**
 * swaps us with another mob. assumes they're next to us.
 */
/mob/living/proc/bump_position_swap(mob/living/them)


/**
 * checks if we can swap with another mob
 */
/mob/living/proc/can_bump_position_swap(mob/living/them)
	// we must both be on help
	if(a_intent != INTENT_HELP || them.a_intent != INTENT_HELP)
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
	var/mob/M = ismob(AM) && AM

	// redirect forces to buckled if it prevents move
	if(M?.buckled && !M.buckled.buckle_movable)
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

#warn new-convert
//Called when we bump onto a mob
/mob/living/proc/MobBump(mob/M)
	SEND_SIGNAL(src, COMSIG_LIVING_MOB_BUMP, M)
	//Even if we don't push/swap places, we "touched" them, so spread fire
	spreadFire(M)

	if(now_pushing)
		return TRUE

	var/they_can_move = TRUE

	if(isliving(M))
		var/mob/living/L = M
		they_can_move = CHECK_MOBILITY(L, MOBILITY_MOVE)
		//Also spread diseases
		for(var/thing in diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				L.ContactContractDisease(D)

		for(var/thing in L.diseases)
			var/datum/disease/D = thing
			if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
				ContactContractDisease(D)

		//Should stop you pushing a restrained person out of the way
		if(L.pulledby && L.pulledby != src && L.restrained())
			if(!(world.time % 5))
				to_chat(src, span_warning("[L] is restrained, you cannot push past."))
			return TRUE

		if(L.pulling)
			if(ismob(L.pulling))
				var/mob/P = L.pulling
				if(P.restrained())
					if(!(world.time % 5))
						to_chat(src, span_warning("[L] is restraining [P], you cannot push past."))
					return TRUE

	//CIT CHANGES START HERE - makes it so resting stops you from moving through standing folks or over prone bodies without a short delay
	#warn this is a dumpster fire
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

	if(moving_diagonally)//no mob swap during diagonal moves.
		return TRUE

	if(!M.buckled && !M.has_buckled_mobs())
		var/mob_swap = FALSE
		var/too_strong = (M.move_resist > move_force) //can't swap with immovable objects unless they help us
		if(!they_can_move) //we have to physically move them
			if(!too_strong)
				mob_swap = TRUE
		else
			//You can swap with the person you are dragging on grab intent, and restrained people in most cases
			if(M.pulledby == src && !too_strong)
				mob_swap = TRUE
			//restrained people act if they were on 'help' intent to prevent a person being pulled from being separated from their puller
			else if((M.restrained() || M.a_intent == INTENT_HELP) && (restrained() || a_intent == INTENT_HELP))
				mob_swap = TRUE
		if(mob_swap)
			//switch our position with M
			if(loc && !loc.Adjacent(M.loc))
				return TRUE
			now_pushing = TRUE
			var/oldloc = loc
			var/oldMloc = M.loc


			var/M_ATOM_PASS_mob = (M.pass_flags & ATOM_PASS_MOB) // we give ATOM_PASS_MOB to both mobs to avoid bumping other mobs during swap.
			var/src_ATOM_PASS_mob = (pass_flags & ATOM_PASS_MOB)
			M.pass_flags |= ATOM_PASS_MOB
			pass_flags |= ATOM_PASS_MOB

			var/move_failed = FALSE
			if(!M.Move(oldloc) || !Move(oldMloc))
				M.forceMove(oldMloc)
				forceMove(oldloc)
				move_failed = TRUE
			if(!src_ATOM_PASS_mob)
				pass_flags &= ~ATOM_PASS_MOB
			if(!M_ATOM_PASS_mob)
				M.pass_flags &= ~ATOM_PASS_MOB

			now_pushing = FALSE

			if(!move_failed)
				return TRUE
