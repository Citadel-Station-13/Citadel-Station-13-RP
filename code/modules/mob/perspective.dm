/**
  * Sets us to a /datum/perspective
  * If none is specified, defaults to self_perspective.
  *
  * See [code/datums/perspective.dm] for more info.
  *
  * @params
  * - P - perspective or atom - if atom, get_perspective() will be called on
  * - apply - whether to apply to client. this shold be false when resetting
  * 	due to a logout because the whole point is logout kills perspective!
  * - forceful - if the client is desynced from our using perspective, do we force it back?
  * - no_optimizations - if true, it'll be a true reset. use for things like cancel camera view which should always force updates.
  */
/mob/proc/reset_perspective(datum/perspective/P, apply = TRUE, forceful = TRUE, no_optimizations)
	if(P)
		ASSERT(istype(P) || ismovable(P))
	if(!no_optimizations && (																																\
		P?	(ismovable(P)? (istype(using_perspective, /datum/perspective/self/temporary) && (using_perspective.eye == P)) : (using_perspective == P))		\
		:																																					\
			(using_perspective && (using_perspective == self_perspective))																					\
	))
		// if we don't need to reset, assume it's an update.
		// this is bad practice but stuff like mechs need this to work, since
		// they reset for brainmobs but only need to update for others.
		update_perspective(TRUE)
		return
	if(ismovable(P))
		var/atom/movable/AM = P
		P = AM.get_perspective()
	/// first of all if we are already on the right perspective we really don't care!
	if(!client)		// this is way easier if no client, and microoptimization
		if(using_perspective)
			using_perspective.RemoveMob(src, TRUE)
			if(using_perspective)
				stack_trace("using perspective didn't clear us")
				using_perspective = null
		P = P || get_perspective()
		P.AddMob(src)
		return
	var/old = using_perspective
	// get old perspective first
	if(using_perspective)
		using_perspective.RemoveMob(src, TRUE)
		if(using_perspective)
			stack_trace("using perspective didn't clear us")
			using_perspective = null
	// if no P, return us
	if(!P)
		P = get_perspective()
	else
		if(P.reset_on_logout && !client)
			// if there's a P but client is gone, and it resets, use us again
			P = get_perspective()
	// great, P exists
	// tell it to add us
	P.AddMob(src)
	// signal
	SEND_SIGNAL(src, COMSIG_MOB_RESET_PERSPECTIVE, P)
	// if client exists and we want to apply
	if(apply && client)
		if(!forceful)
			// if not forceful, only shunt if we're not desynced
			if(client.using_perspective == old)
				client.set_perspective(P)
		else
			client.set_perspective(P)

/**
 * verb that allows someone to instantly shunt their perspective back to the default
 */
/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"

	reset_perspective(no_optimizations = TRUE, apply = TRUE, forceful = TRUE)

/**
 * gets the perspective we're using
 */
/mob/proc/get_using_perspective()
	RETURN_TYPE(/datum/perspective)
	return using_perspective || get_perspective()

/mob/get_perspective()
	// mobs never lazygen their perspectives
	ensure_self_perspective()
	return ..()

/**
 * updates our curent perspective
 */
/mob/proc/update_perspective(shunted)
	if(!client)
		return
	if(using_perspective != client.using_perspective)	// shunt them back in, useful if something's temporarily shunted our client away
		if(!client.using_perspective)
			reset_perspective(using_perspective)
			CRASH("client had no using perspective, how? in mob/update_perspective")
		if(shunted)
			CRASH("Caught an infinite loop. What's going on here?")
		reset_perspective(using_perspective)
		return
	SEND_SIGNAL(src, COMSIG_MOB_UPDATE_PERSPECTIVE)
	using_perspective?.Update(client)

/**
 * we're considered to be viewing from some/something else's perspective
 */
/mob/proc/IsRemoteViewing()
	return get_using_perspective()?.considered_remote(src)

/**
 * for mob make_perspective, set our current_values
 */
/mob/make_perspective()
	. = ..()
	self_perspective.see_in_dark = see_in_dark
	self_perspective.see_invisible = see_invisible
	self_perspective.sight = sight

////////// ALL OF THESE SHOULD BE REGEXED LATER /////////////
// However, there is currently no way to deal with the getters due to them requiring self_perspective be set, but
// we don't necessarily want all mobs to have it, as perspectives are generally for client'd mobs
// We'll decide later, the setters/getters work for now.

/**
 * wrapper for self_perspective.AddSight for regexing later
 */
/mob/proc/AddSightSelf(flags)
	ensure_self_perspective()
	self_perspective.AddSight(flags)

/**
 * ditto
 */
/mob/proc/RemoveSightSelf(flags)
	ensure_self_perspective()
	self_perspective.RemoveSight(flags)

/**
 * ditto
 */
/mob/proc/SetSightSelf(flags)
	ensure_self_perspective()
	self_perspective.SetSight(flags)

/**
 * ditto
 */
/mob/proc/SetSeeInvisibleSelf(see_invisible)
	ensure_self_perspective()
	self_perspective.SetSeeInvis(see_invisible)

/**
 * ditto
 */
/mob/proc/SetSeeInDarkSelf(see_invisible)
	ensure_self_perspective()
	self_perspective.SetDarksight(see_invisible)

/**
 * ditto
 */
/mob/proc/GetSeeInDarkSelf()
	return self_perspective? self_perspective.see_in_dark : see_in_dark

