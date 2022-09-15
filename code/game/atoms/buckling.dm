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

#warn  parse below

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


#warn parse above
#warn impl below
#warn all of the below requires duplicate re-buckle checks.
#warn signals
//! movable stuff
/**
 * use this hook for processing attempted drag/drop buckles
 *
 * @return TRUE if the calling proc should consider it as an interaction (aka don't do other click stuff)
 */
/atom/movable/proc/drag_drop_buckle_interaction(atom/A, mob/user)
	set waitfor = FALSE
	. = TRUE
	if(!user.Adjacent(src))
		return FALSE
	var/mob/buckling = A
	if(!buckle_allowed || (buckle_flags & BUCKLING_NO_USER_BUCKLE))
		return FALSE
	// todo: refactor below
	if(user.incapacitated())
		return TRUE
	// end
	if(!ismob(A) || (A in buckled_mobs))
		to_chat(user, SPAN_WARNING("[A] is already buckled to [src]!"))
		return TRUE
	user_buckle_mob(A, BUCKLE_OP_DEFAULT_INTERACTION, user)

/**
 * use this hook for processing attempted click unbuckles
 *
 * @return TRUE if the calling proc should consider it as an interaction (aka don't do other click stuff)
 */
/atom/movable/proc/click_unbuckle_interaction(mob/user)
	set waitfor = FALSE
	. = TRUE
	if(!has_buckled_mobs())
		return FALSE
	// todo: refactor below
	if(user.incapacitated())
		return TRUE
	// end
	var/mob/unbuckling = buckled_mobs[1]
	if(buckled_mobs.len > 1)
		unbuckling = input(user, "Who to unbuckle?", "Unbuckle", unbuckling) as anything|null in buckled_mobs
	user_unbuckle_mob(unbuckling, BUCKLE_OP_DEFAULT_INTERACTION, user, buckled_mobs[unbuckling])

/**
 * called when someone tries to unbuckle something from us, whether by click or otherwise
 *
 * ? SLEEPS ARE ALLOWED
 * ? Put user interaction in here.
 */
/atom/movable/proc/user_unbuckle_mob(mob/M, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	. = SEND_SIGNAL(src, COMSIG_MOVABLE_USER_UNBUCKLE_MOB, M, flags, user, semantic)
	if(. & COMPONENT_BLOCK_BUCKLE_OPERATION)
		return FALSE
	return unbuckle_mob(M, flags, user, semantic)

/**
 * called when someone tries to buckle something to us, whether by drag/drop interaction or otherwise
 *
 * ? SLEEPS ARE ALLOWED
 * ? Put user interaction in here.
 */
/atom/movable/proc/user_buckle_mob(mob/M, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	. = SEND_SIGNAL(src, COMSIG_MOVABLE_USER_BUCKLE_MOB, M, flags, user, semantic)
	if(. & COMPONENT_BLOCK_BUCKLE_OPERATION)
		return FALSE
	if((buckle_flags & BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF) && (user == M))
		return FALSE
	return buckle_mob(M, flags, user, semantic)

/**
 * called to buckle something to us
 *
 * can_buckle_mob can stop this unless you use the FORCE opflag.
 * components can always stop this
 */
/atom/movable/proc/buckle_mob(mob/M, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_BUCKLE_MOB, M, flags, user, semantic) & COMPONENT_BLOCK_BUCKLE_OPERATION)
		return FALSE

	if(!(flags & BUCKLE_OP_FORCE) && !can_buckle_mob(M, flags, user, semantic))
		return FALSE

	if(M.buckled)
		M.buckled.unbuckle_mob(M, BUCKLE_OP_FORCE)

	return _buckle_mob(M, flags, user, semantic)

/atom/movable/proc/_buckle_mob(mob/M, flags, mob/user, semantic)
	PRIVATE_PROC(TRUE)
	if(M.loc != loc)
		M.forceMove(loc)
	if(M.buckled)
		. = FALSE
		CRASH("M already buckled?")
	M.buckled = src
	buckled_mobs[M] = semantic
	M.setDir(dir)
	M.update_canmove()
	// todo: refactor the below
	M.update_floating(M.Check_Dense_Object())
	M.update_water()
	M.reset_pixel_offsets()
	mob_buckled(M, flags, user, semantic)
	return TRUE

/**
 * called to unbuckle something from us
 *
 * components can always stop this
 */
/atom/movable/proc/unbuckle_mob(mob/M, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)

	if(!(flags & BUCKLE_OP_FORCE) && !can_unbuckle_mob(M, flags, user, semantic))
		return FALSE

	#warn impl and check overrides

/atom/movable/proc/_unbuckle_mob(mob/M, flags, mob/user, semantic)
	PRIVATE_PROC(TRUE)
	if(M.buckled != src)
		stack_trace("M buckled was not src.")
	else
		M.buckled = null
	buckled_mobs -= M
	M.update_canmove()
	// todo: refactor the below
	M.update_floating(M.Check_Dense_Object())
	M.update_water()
	mob_unbuckled(M, flags, user, semantic)
	return TRUE

/**
 * can something buckle to us?
 * SLEEPS ARE ALLOWED
 *
 * ? Put user behavior in user buckle mob, not here. This however, WILL be rechecked.
 */
/atom/movable/proc/can_buckle_mob(mob/M, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	. = SEND_SIGNAL(src, COMSIG_MOVABLE_CAN_BUCKLE_MOB, M, flags, user, semantic)
	if(. & COMPONENT_BLOCK_BUCKLE_OPERATION)
		return FALSE
	else if(. & COMPONENT_FORCE_BUCKLE_OPERATION)
		return TRUE
	if(!(flags & BUCKLE_OP_IGNORE_LOC) && !M.Adjacent(src))
		return FALSE
	if(length(buckled_mobs) >= buckle_max_mobs)
		to_chat(user, SPAN_NOTICE("[src] can't buckle any more people."))
		return FALSE
	if(M.buckled)
		to_chat(user, SPAN_WARNING("[M == user? "You are" : "[M] is"] already buckled to something!"))
		return FALSE
	if((buckle_flags & BUCKLING_REQUIRES_RESTRAINTS) && !M.restrained())
		to_chat(user, SPAN_WARNING("[M == user? "You need" : "[M] needs"] to be restrained to be buckled to [src]!"))
		return FALSE
	if(length(M.pinned))
		to_chat(user, SPAN_WARNING("[M == user? "You are" : "[M] is"] pinned to something!"))
		return FALSE
	return TRUE

/**
 * can something unbuckle from us?
 * SLEEPS ARE ALLOWED
 *
 * ? Put user behavior in user unbuckle mob, not here. This however, WILL be rechecked.
 */
/atom/movable/proc/can_unbuckle_mob(mob/M, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	. = SEND_SIGNAL(src, COMSIG_MOVABLE_CAN_UNBUCKLE_MOB, M, flags, user, semantic)
	if(. & COMPONENT_BLOCK_BUCKLE_OPERATION)
		return FALSE
	else if(. & COMPONENT_FORCE_BUCKLE_OPERATION)
		return TRUE
	return TRUE
/**
 * called when something is buckled to us
 */
/atom/movable/proc/mob_buckled(mob/M, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOB_BUCKLED, M, flags, user, semantic)

/**
 * called when something is unbuckled from us
 */
/atom/movable/proc/mob_unbuckled(mob/M, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOB_UNBUCKLED, M, flags, user, semantic)

/**
 * called when a mob tries to resist out of being buckled to us
 *
 * ? SLEEPS ARE ALLOWED
 * ? Put user interaction in here.
 */
/atom/movable/proc/mob_resist_buckle(mob/M, semantic)
	SHOULD_CALL_PARENT(TRUE)

	#warn comsig

#warn impl above

/**
 * called to initiate buckle resist
 */
/atom/movable/proc/resist_unbuckle_interaction(mob/M)
	set waitfor = FALSE
	ASSERT(M in buckled_mobs)
	mob_resist_buckle(M, buckled_mobs[M])

/**
 * if we have buckled mobs
 */
/atom/movable/proc/has_buckled_mobs()
	return length(buckled_mobs)

/**
 * get the semantic mode of a mob
 */
/atom/movable/proc/get_buckle_semantic(mob/M)
	return buckled_mobs && buckled_mobs[M]

/**
 * unbuckle all mobs
 */
/atom/movable/proc/unbuckle_all_mobs(flags, mob/user)
	for(var/mob/M in buckled_mobs)
		unbuckle_mob(M, flags, user, buckled_mobs[M])

/**
 * called when a buckled mob tries to move
 */
/atom/movable/proc/relaymove_from_buckled(mob/user, direction)
	. = SEND_SIGNAL(src, COMSIG_ATOM_RELAYMOVE_FROM_BUCKLED, user, direction)
	if(. & COMPONENT_RELAYMOVE_HANDLED)
		return TRUE
	return relaymove(user, direction)

/**
 * call when you uncuff/whatever someone
 */
/atom/movable/proc/buckled_reconsider_restraints(mob/user)
	if(!(user in buckled_mobs))
		return
	if(!(buckle_flags & BUCKLING_REQUIRES_RESTRAINTS))
		return
	if(user.restrained())
		return
	unbuckle_mob(user, BUCKLE_OP_FORCE)
	visible_message(SPAN_WARNING("[user] is freed from [src]!"))

//! mob stuff

/**
 * called when we're buckled to something.
 */
/mob/proc/buckled(atom/movable/AM, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOB_BUCKLED, AM, flags, user, semantic)

/**
 * called when we're unbuckled from something
 */
/mob/proc/unbuckled(atom/movable/AM, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOB_UNBUCKLED, AM, flags, user, semantic)

/**
 * can we buckle to something?
 *
 * we get final say
 */
/mob/proc/can_buckle(atom/movable/AM, flags, mob/user, semantic, movable_opinion)
	SHOULD_CALL_PARENT(TRUE)
	. = SEND_SIGNAL(src, COMSIG_MOB_CAN_BUCKLE, AM, flags, user, semantic, movable_opinion)
	if(. & COMPONENT_BLOCK_BUCKLE_OPERATION)
		return FALSE
	else if(. & COMPONENT_FORCE_BUCKLE_OPERATION)
		return TRUE
	return movable_opinion

/**
 * can we unbuckle from something?
 *
 * we get final say
 */
/mob/proc/can_unbuckle(atom/movable/AM, flags, mob/user, semantic, movable_opinion)
	SHOULD_CALL_PARENT(TRUE)
	. = SEND_SIGNAL(src, COMSIG_MOB_CAN_UNBUCKLE, AM, flags, user, semantic, movable_opinion)
	if(. & COMPONENT_BLOCK_BUCKLE_OPERATION)
		return FALSE
	else if(. & COMPONENT_FORCE_BUCKLE_OPERATION)
		return TRUE
	return movable_opinion

/**
 * call to try to resist out of a buckle
 */
/mob/proc/resist_buckle()
	set waitfor = FALSE
	. = !!buckled
	buckled.resist_unbuckle_interaction(src)
