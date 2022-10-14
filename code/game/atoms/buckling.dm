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

//! movable stuff
/**
 * use this hook for processing attempted drag/drop buckles
 *
 * @return TRUE if the calling proc should consider it as an interaction (aka don't do other click stuff)
 */
/atom/movable/proc/drag_drop_buckle_interaction(atom/A, mob/user)
	set waitfor = FALSE
	. = TRUE
	if(A == src)
		return FALSE
	if(!ismob(A))
		return FALSE
	if(!user.Adjacent(src) || !A.Adjacent(src))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_DRAG_DROP_BUCKLE_INTERACTION, A, user) & COMPONENT_HANDLED_BUCKLE_INTERACTION)
		return
	if(!buckle_allowed || (buckle_flags & BUCKLING_NO_DEFAULT_BUCKLE))
		return FALSE
	// todo: refactor below
	if(user.incapacitated())
		return TRUE
	// end
	if(A in buckled_mobs)
		to_chat(user, SPAN_WARNING("[A] is already buckled to [src]!"))
		return TRUE
	user_buckle_mob(A, BUCKLE_OP_DEFAULT_INTERACTION, user)
	add_fingerprint(user)

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
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_CLICK_UNBUCKLE_INTERACTION, user) & COMPONENT_HANDLED_BUCKLE_INTERACTION)
		return
	if(!buckle_allowed || (buckle_flags & BUCKLING_NO_DEFAULT_UNBUCKLE))
		return FALSE
	// end
	var/mob/unbuckling = buckled_mobs[1]
	if(buckled_mobs.len > 1)
		unbuckling = input(user, "Who to unbuckle?", "Unbuckle", unbuckling) as null|anything in buckled_mobs
	if((user == unbuckling) && !mob_resist_buckle(user, buckled_mobs[user]))
		return
	user_unbuckle_mob(unbuckling, BUCKLE_OP_DEFAULT_INTERACTION, user, buckled_mobs[unbuckling])
	add_fingerprint(user)


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
	. = unbuckle_mob(M, flags, user, semantic)
	if(!.)
		return
	if(!(flags & BUCKLE_OP_SILENT))
		user_unbuckle_feedback(M, flags, user, semantic)

/**
 * called to provide visible/audible feedback when someone unbuckles someone else (or themselves) from us
 */
/atom/movable/proc/user_unbuckle_feedback(mob/M, flags, mob/user, semantic)
	if(user != M)
		M.visible_message(
			SPAN_NOTICE("[M] was unbuckled from [src] by [user]."),
			SPAN_NOTICE("[user] unbuckles you from [src]."),
			SPAN_NOTICE("You hear shuffling and metal clanking.")
		)
	else
		M.visible_message(
			SPAN_NOTICE("[M] unbuckles themselves from [src]."),
			SPAN_NOTICE("You unbuckle yourself from [src]."),
			SPAN_NOTICE("You hear shuffling and metal clanking.")
		)

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
	if((buckle_flags & BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF) && (user == src))
		return FALSE
	. = buckle_mob(M, flags, user, semantic)
	if(!.)
		return
	if(!(flags & BUCKLE_OP_SILENT))
		user_buckle_feedback(M, flags, user, semantic)

/**
 * called to provide visible/audible feedback when someone buckles someone else (or themselves) to us
 */
/atom/movable/proc/user_buckle_feedback(mob/M, flags, mob/user, semantic)
	if(user != M)
		M.visible_message(
			SPAN_NOTICE("[user] buckles [M] to [src]."),
			SPAN_NOTICE("[user] buckles you to [src]."),
			SPAN_NOTICE("You hear shuffling and metal clanking.")
		)
	else
		M.visible_message(
			SPAN_NOTICE("[user] buckles [M] to [src]."),
			SPAN_NOTICE("You buckle yourself to [src]."),
			SPAN_NOTICE("You hear shuffling and metal clanking.")
		)

/**
 * called to buckle something to us
 *
 * can_buckle_mob can stop this unless you use the FORCE opflag.
 * components can always stop this
 */
/atom/movable/proc/buckle_mob(mob/M, flags, mob/user, semantic)
	SHOULD_CALL_PARENT(TRUE)
	ASSERT(M)

	if(M == src)
		return FALSE

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
	LAZYINITLIST(buckled_mobs)
	buckled_mobs[M] = semantic
	M.setDir(dir)
	M.update_canmove()
	// todo: refactor the below
	M.update_floating(M.Check_Dense_Object())
	if(isliving(M))
		var/mob/living/L = M
		L.update_water()
	// end
	M.reset_pixel_shifting()
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
	ASSERT(M)

	if(!(flags & BUCKLE_OP_FORCE) && !can_unbuckle_mob(M, flags, user, semantic))
		return FALSE

	return _unbuckle_mob(M, flags, user, semantic)

/atom/movable/proc/_unbuckle_mob(mob/M, flags, mob/user, semantic)
	PRIVATE_PROC(TRUE)
	if(M.buckled != src)
		stack_trace("M buckled was not src.")
	else
		M.buckled = null
	buckled_mobs -= M
	UNSETEMPTY(buckled_mobs)
	M.update_canmove()
	// todo: refactor the below
	M.update_floating(M.Check_Dense_Object())
	if(isliving(M))
		var/mob/living/L = M
		L.update_water()
	// end
	M.reset_pixel_offsets()
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
		if(M.buckled == src)
			to_chat(user, SPAN_WARNING("[M == user? "You are" : "[M] is"] already buckled to [src]!"))
			return FALSE
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
 * DO NOT CALL user_unbuckle_mob. This is called by interaction procs!
 *
 * @return TRUE/FALSe depending on if we're allowed to user_unbuckle_mob ourselves.
 *
 * ? SLEEPS ARE ALLOWED
 * ? Put user interaction in here.
 */
/atom/movable/proc/mob_resist_buckle(mob/M, semantic)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOB_RESIST_BUCKLE, M, semantic)

	// default restrained handling
	if(buckle_restrained_resist_time && M.restrained())
		M.visible_message(
			SPAN_DANGER("[M] attempts to unbuckle themselves from [src]!"),
			SPAN_WARNING("You attempt to unbuckle yourself. (This will take a little bit and you need to stand still.)")
		)
		if(!do_after(M, buckle_restrained_resist_time, src, incapacitation_flags = INCAPACITATION_DEFAULT & ~(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_FULLY)))
			return FALSE
		M.visible_message(
			SPAN_DANGER("[M] manages to unbuckle themselves."),
			SPAN_NOTICE("You successfully unbuckle yourself.")
		)
	return TRUE

/**
 * called to initiate buckle resist
 */
/atom/movable/proc/resist_unbuckle_interaction(mob/M)
	set waitfor = FALSE
	ASSERT(M in buckled_mobs)
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_RESIST_UNBUCKLE_INTERACTION, M) & COMPONENT_HANDLED_BUCKLE_INTERACTION)
		return
	if(!buckle_allowed || (buckle_flags & BUCKLING_NO_DEFAULT_RESIST))
		return FALSE
	if(!mob_resist_buckle(M, buckled_mobs[M]))
		return
	user_unbuckle_mob(M, BUCKLE_OP_DEFAULT_INTERACTION, M, buckled_mobs[M])

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

/**
 * get the buckle_lying field for a given mob.
 */
/atom/movable/proc/buckle_lying(mob/M)
	return buckle_lying

//! mob stuff
/**
 * called to try to buckle us to something
 */
/mob/proc/buckle(atom/movable/AM, flags, mob/user, semantic)
	return AM.buckle_mob(src, flags, user, semantic)

/**
 * called to try to unbuckle us from whatever we're buckled to
 */
/mob/proc/unbuckle(flags, mob/user, semantic)
	return buckled?.unbuckle_mob(src, flags, user, semantic)

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
	if(!.)
		return
	if(istype(buckled, /obj/vehicle_old))
		var/obj/vehicle_old/vehicle = buckled
		vehicle.unload()
	else
		buckled.resist_unbuckle_interaction(src)
