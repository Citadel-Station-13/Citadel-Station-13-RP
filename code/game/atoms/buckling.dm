/atom/movable/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	if(drag_drop_buckle_interaction(dropping, user))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/atom/movable/attack_hand(mob/living/user)
	if(click_unbuckle_interaction(user))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/atom/movable/attack_robot(mob/user)
	if(click_unbuckle_interaction(user))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/attack_robot(mob/living/user)
	if(Adjacent(user) && has_buckled_mobs()) //Checks if what we're touching is adjacent to us and has someone buckled to it. This should prevent interacting with anti-robot manual valves among other things.
		return attack_hand(user) //Process as if we're a normal person touching the object.
	return ..() //Otherwise, treat this as an AI click like usual.

/atom/movable/MouseDroppedOnLegacy(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M))
		if(user_buckle_mob(M, user))
			return TRUE


/atom/movable/proc/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(check_loc && M.loc != loc)
		return FALSE

	if(!can_buckle_check(M, forced))
		return FALSE

	M.buckled = src
	M.facing_dir = null
	M.setDir(buckle_dir ? buckle_dir : dir)
	M.update_canmove()
	M.update_floating( M.Check_Dense_Object() )
	buckled_mobs |= M

	M.update_water()

	post_buckle_mob(M)
	return TRUE

/atom/movable/proc/unbuckle_mob(mob/living/buckled_mob, force = FALSE)
	if(!buckled_mob) // If we didn't get told which mob needs to get unbuckled, just assume its the first one on the list.
		if(has_buckled_mobs())
			buckled_mob = buckled_mobs[1]
		else
			return

	if(buckled_mob && buckled_mob.buckled == src)
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob.update_floating( buckled_mob.Check_Dense_Object() )
		buckled_mobs -= buckled_mob

		buckled_mob.update_water()
		post_buckle_mob(.)

//Handle any extras after buckling/unbuckling
//Called on buckle_mob() and unbuckle_mob()
/atom/movable/proc/post_buckle_mob(mob/living/M)
	return

//Wrapper procs that handle sanity and user feedback
/atom/movable/proc/user_buckle_mob(mob/living/M, mob/user, var/forced = FALSE, var/silent = FALSE)
	if(!user.Adjacent(M) || user.restrained() || user.stat || istype(user, /mob/living/silicon/pai))
		return FALSE
	if(M in buckled_mobs)
		to_chat(user, "<span class='warning'>\The [M] is already buckled to \the [src].</span>")
		return FALSE
	if(M.buckled) //actually check if the mob is already buckled before forcemoving it jfc
		to_chat(user, "<span class='warning'>\The [M] is already buckled to \the [M.buckled].</span>")
		return FALSE
	//can't buckle unless you share locs so try to move M to the obj.
	if(M.loc != src.loc)
		if(M.Adjacent(src) && user.Adjacent(src))
			M.forceMove(get_turf(src))
	if(!can_buckle_check(M, forced))
		return FALSE

	add_fingerprint(user)
//	unbuckle_mob()


	. = buckle_mob(M, forced)
	if(.)
		var/reveal_message = list("buckled_mob" = null, "buckled_to" = null) // This being a list and messages existing for the buckle target atom.
		if(!silent)
			if(M == user)
				reveal_message["buckled_mob"] = "<span class='notice'>You come out of hiding and buckle yourself to [src].</span>"
				reveal_message["buckled_to"] = "<span class='notice'>You come out of hiding as [M.name] buckles themselves to you.</span>"
				M.visible_message(\
					"<span class='notice'>[M.name] buckles themselves to [src].</span>",\
					"<span class='notice'>You buckle yourself to [src].</span>",\
					"<span class='notice'>You hear metal clanking.</span>")
			else
				reveal_message["buckled_mob"] = "<span class='notice'>You are revealed as you are buckled to [src].</span>"
				reveal_message["buckled_to"] = "<span class='notice'>You are revealed as [M.name] is buckled to you.</span>"
				M.visible_message(\
					"<span class='danger'>[M.name] is buckled to [src] by [user.name]!</span>",\
					"<span class='danger'>You are buckled to [src] by [user.name]!</span>",\
					"<span class='notice'>You hear metal clanking.</span>")

		M.reveal(silent, reveal_message["buckled_mob"]) //Reveal people so they aren't buckled to chairs from behind.
		var/mob/living/L = src
		if(istype(L))
			L.reveal(silent, reveal_message["buckled_to"])

/atom/movable/proc/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	var/mob/living/M = unbuckle_mob(buckled_mob)
	if(M)
		if(M != user)
			M.visible_message(\
				"<span class='notice'>[M.name] was unbuckled by [user.name]!</span>",\
				"<span class='notice'>You were unbuckled from [src] by [user.name].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			M.visible_message(\
				"<span class='notice'>[M.name] unbuckled themselves!</span>",\
				"<span class='notice'>You unbuckle yourself from [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		add_fingerprint(user)
	return M

/atom/movable/proc/handle_buckled_mob_movement(newloc,direct)
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A
//			if(!L.Move(newloc, direct))
			if(!L.forceMove(newloc, direct))
				loc = L.loc
				last_move = L.last_move
				L.inertia_dir = last_move
				return FALSE
			else
				L.setDir(dir)
	return TRUE

/atom/movable/proc/can_buckle_check(mob/living/M, forced = FALSE)
	if(!buckled_mobs)
		buckled_mobs = list()

	if(!istype(M))
		return FALSE

	if((!can_buckle && !forced) || M.buckled || M.pinned.len || (buckled_mobs.len >= buckle_max_mobs) || (buckle_require_restraints && !M.restrained()))
		return FALSE

	if(has_buckled_mobs() && buckled_mobs.len >= buckle_max_mobs) //Handles trying to buckle yourself to the chair when someone is on it
		to_chat(M, "<span class='notice'>\The [src] can't buckle anymore people.</span>")

		return FALSE

	return TRUE

#warn parse above
#warn impl below
#warn signals
//! movable stuff
/**
 * use this hook for processing attempted drag/drop buckles
 *
 * @return TRUE if the calling proc should consider it as an interaction (aka don't do other click stuff)
 */
/atom/movable/proc/drag_drop_buckle_interaction(atom/A, mob/user)
	set waitfor = FALSE
	if(!ismob(A))
		return FALSE
	var/mob/buckling = A
	if(!buckle_allowed || (buckle_flags & BUCKLING_NO_USER_BUCKLE))
		return FALSE
	. = TRUE
	user_buckle_mob(A, BUCKLE_OP_DEFAULT_INTERACTION, user)

/**
 * use this hook for processing attempted click unbuckles
 *
 * @return TRUE if the calling proc should consider it as an interaction (aka don't do other click stuff)
 */
/atom/movable/proc/click_unbuckle_interaction(mob/user)

/**
 * called when someone tries to unbuckle something from us, whether by click or otherwise
 *
 * ? SLEEPS ARE ALLOWED
 * ? Put user interaction in here.
 */
/atom/movable/proc/user_unbuckle_mob(mob/M, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)
	#warn impl and check overrides

/**
 * called when someone tries to buckle something to us, whether by drag/drop interaction or otherwise
 *
 * ? SLEEPS ARE ALLOWED
 * ? Put user interaction in here.
 */
/atom/movable/proc/user_buckle_mob(mob/M, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)
	#warn impl and check overrides

/**
 * called to buckle something to us
 *
 * buckle_allowed will stop this unless you use the FORCE opflag.
 * components can always stop this
 */
/atom/movable/proc/buckle_mob(mob/M, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)
	#warn impl and check overrides

/**
 * called to unbuckle something from us
 *
 * components can always stop this
 */
/atom/movable/proc/unbuckle_mob(mob/M, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)
	#warn impl and check overrides

/**
 * can something buckle to us?
 * SLEEPS ARE ALLOWED
 *
 * ? Put user behavior in user buckle mob, not here. This however, WILL be rechecked.
 */
/atom/movable/proc/can_buckle_mob(mob/M, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)

/**
 * can something unbuckle from us?
 * SLEEPS ARE ALLOWED
 *
 * ? Put user behavior in user unbuckle mob, not here. This however, WILL be rechecked.
 */
/atom/movable/proc/can_unbuckle_mob(mob/M, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called when something is buckled to us
 */
/atom/movable/proc/mob_buckled(mob/M, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called when something is unbuckled from us
 */
/atom/movable/proc/mob_unbuckled(mob/M, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called when a mob tries to resist out of being buckled to us
 *
 * ? SLEEPS ARE ALLOWED
 * ? Put user interaction in here.
 */
/atom/movable/proc/mob_resist_buckle(mob/M)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called to initiate buckle resist
 */
/atom/movable/proc/resist_unbuckle_interaction(mob/M)
	set waitfor = FALSE
	mob_resist_buckle(M)

/**
 * if we have buckled mobs
 */
/atom/movable/proc/has_buckled_mobs()
	return length(buckled_mobs)

/**
 * unbuckle all mobs
 */
/atom/movable/proc/unbuckle_all_mobs(flags, mob/user)
	for(var/mob/M in buckled_mobs)
		unbuckle_mob(M, flags, user)

/**
 * called when a buckled mob tries to move
 */
/atom/movable/proc/relaymove_from_buckled(mob/user, direction)
	. = SEND_SIGNAL(src, COMSIG_ATOM_RELAYMOVE_FROM_BUCKLED, user, direction)
	if(. & COMPONENT_RELAYMOVE_HANDLED)
		return TRUE
	return relaymove(user, direction)

//! mob stuff

/**
 * called when we're buckled to something.
 */
/mob/proc/buckled(atom/movable/AM, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called when we're unbuckled from something
 */
/mob/proc/unbuckled(atom/movable/AM, flags, mob/user)
	SHOULD_CALL_PARENT(TRUE)

/**
 * can we buckle to something?
 *
 * we get final say
 */
/mob/proc/can_buckle(atom/movable/AM, flags, mob/user, movable_opinion)
	SHOULD_CALL_PARENT(TRUE)
	return movable_opinion

/**
 * can we unbuckle from something?
 *
 * we get final say
 */
/mob/proc/can_unbuckle(atom/movable/AM, flags, mob/user, movable_opinion)
	SHOULD_CALL_PARENT(TRUE)
	return movable_opinion

/**
 * call to try to resist out of a buckle
 */
/mob/proc/resist_buckle()
	#warn impl
