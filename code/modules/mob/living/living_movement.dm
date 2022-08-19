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

#warn old below

/mob/living/Bump(atom/movable/AM)
	if(now_pushing || !loc)
		return
	now_pushing = 1
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
				return
		// Handle grabbing, stomping, and such of micros!
		if(handle_micro_bump_other(tmob)) return

		if(istype(tmob, /mob/living/carbon/human) && (FAT in tmob.mutations))
			if(prob(40) && !(FAT in src.mutations))
				to_chat(src, "<span class='danger'>You fail to push [tmob]'s fat ass out of the way.</span>")
				now_pushing = 0
				return
		if(tmob.r_hand && istype(tmob.r_hand, /obj/item/shield/riot))
			if(prob(99))
				now_pushing = 0
				return

		if(tmob.l_hand && istype(tmob.l_hand, /obj/item/shield/riot))
			if(prob(99))
				now_pushing = 0
				return
		if(!(tmob.status_flags & CANPUSH))
			now_pushing = 0
			return

		tmob.LAssailant = src

	now_pushing = 0
	. = ..()
	if (!istype(AM, /atom/movable) || AM.anchored)
		// Object-specific proc for running into things
		if(((confused || is_blind()) && stat == CONSCIOUS && prob(50) && m_intent=="run") || flying && !SPECIES_ADHERENT)
			AM.stumble_into(src)
		return
	if (!now_pushing)
		if(isobj(AM))
			var/obj/I = AM
			if(!can_pull_size || can_pull_size < I.w_class)
				return
		now_pushing = 1

		var/t = get_dir(src, AM)
		if (istype(AM, /obj/structure/window))
			for(var/obj/structure/window/win in get_step(AM,t))
				now_pushing = 0
				return
		step(AM, t)
		if(ishuman(AM) && AM:grabbed_by)
			for(var/obj/item/grab/G in AM:grabbed_by)
				step(G:assailant, get_dir(G:assailant, AM))
				G.adjust_position()
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
	if(ismob(A) && handle_mob_bump(A))
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
/mob/living/proc/handle_mob_bump(mob/M)

/**
 * handles obj bumping/fire spread/pushing/etc
 */
/mob/living/proc/handle_obj_bump(obj/O)

/**
 * handles generic movable bumping/fire spread/pushing/etc
 */
/mob/living/proc/handle_movable_bump(atom/movable/AM)


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

	//okay, so we didn't switch. but should we push?
	//not if he's not CANPUSH of course
	if(!(M.status_flags & CANPUSH))
		return TRUE
	if(isliving(M))
		var/mob/living/L = M
		if(HAS_TRAIT(L, TRAIT_PUSHIMMUNE))
			return TRUE
	if(M.a_intent != INTENT_HELP)
		//If they're a human, and they're not in help intent, block pushing
		if(ishuman(M))
			return TRUE
		//if they are a cyborg, and they're alive and not in help intent, block pushing
		if(isrobot(M) && M.stat != DEAD)
			return TRUE
	//anti-riot equipment is also anti-push
	for(var/obj/item/I in M.held_items)
		if(!istype(M, /obj/item/clothing))
			if(prob(I.block_chance*2))
				return TRUE

//Called when we want to push an atom/movable
/mob/living/proc/PushAM(atom/movable/AM, force = move_force)
	if(now_pushing)
		return TRUE
	if(moving_diagonally)// no pushing during diagonal moves.
		return TRUE
	if(!client && (mob_size < MOB_SIZE_SMALL))
		return
	now_pushing = TRUE
	SEND_SIGNAL(src, COMSIG_LIVING_PUSHING_MOVABLE, AM)
	var/dir_to_target = get_dir(src, AM)

	// If there's no dir_to_target then the player is on the same turf as the atom they're trying to push.
	// This can happen when a player is stood on the same turf as a directional window. All attempts to push
	// the window will fail as get_dir will return 0 and the player will be unable to move the window when
	// it should be pushable.
	// In this scenario, we will use the facing direction of the /mob/living attempting to push the atom as
	// a fallback.
	if(!dir_to_target)
		dir_to_target = dir

	var/push_anchored = FALSE
	if((AM.move_resist * MOVE_FORCE_CRUSH_RATIO) <= force)
		if(move_crush(AM, move_force, dir_to_target))
			push_anchored = TRUE
	if((AM.move_resist * MOVE_FORCE_FORCEPUSH_RATIO) <= force) //trigger move_crush and/or force_push regardless of if we can push it normally
		if(force_push(AM, move_force, dir_to_target, push_anchored))
			push_anchored = TRUE
	if(ismob(AM))
		var/mob/mob_to_push = AM
		var/atom/movable/mob_buckle = mob_to_push.buckled
		// If we can't pull them because of what they're buckled to, make sure we can push the thing they're buckled to instead.
		// If neither are true, we're not pushing anymore.
		if(mob_buckle && (mob_buckle.buckle_prevents_pull || (force < (mob_buckle.move_resist * MOVE_FORCE_PUSH_RATIO))))
			now_pushing = FALSE
			return
	if((AM.anchored && !push_anchored) || (force < (AM.move_resist * MOVE_FORCE_PUSH_RATIO)))
		now_pushing = FALSE
		return
	if(istype(AM, /obj/structure/window))
		var/obj/structure/window/W = AM
		if(W.fulltile)
			for(var/obj/structure/window/win in get_step(W, dir_to_target))
				now_pushing = FALSE
				return
	if(pulling == AM)
		stop_pulling()
	var/current_dir
	if(isliving(AM))
		current_dir = AM.dir
	if(AM.Move(get_step(AM.loc, dir_to_target), dir_to_target, glide_size))
		AM.add_fingerprint(src)
		Move(get_step(loc, dir_to_target), dir_to_target)
	if(current_dir)
		AM.setDir(current_dir)
	now_pushing = FALSE
