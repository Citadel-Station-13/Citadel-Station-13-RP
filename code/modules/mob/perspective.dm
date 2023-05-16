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
			using_perspective.remove_mobs(src, TRUE)
			if(using_perspective)
				stack_trace("using perspective didn't clear us")
				using_perspective = null
		P = P || get_perspective()
		P.add_mob(src)
		return
	var/old = using_perspective
	// get old perspective first
	if(using_perspective)
		using_perspective.remove_mobs(src, TRUE)
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
	P.add_mob(src)
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
	if(isnull(using_perspective))
		return
	using_perspective.update(client)

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
	self_perspective.see_invisible = see_invisible
	self_perspective.sight = sight
	update_darksight()

//? Perspective - Shunting / Remote Viewing

/**
 * wrapper for things like holocalls and overmaps that shunt our view
 * returns TRUE or FALSE based on if we moved their perspective
 * will refuse to if the mob was already shunted
 * *USE THE RETURN VALUE*
 *
 * @params
 * - perspective - this must be a /datum/perspective or an /atom.
 */
/mob/proc/shunt_perspective(datum/perspective/perspective)
	if(perspective_shunted())
		return FALSE
	if(ismovable(perspective))
		var/atom/movable/AM = perspective
		perspective = AM.temporary_perspective()
	reset_perspective(perspective)
	return TRUE

/**
 * wrapper for when we want to un-shunt our perspective
 * from a shunt_perspective call.
 */
/mob/proc/unshunt_perspective()
	if(!perspective_shunted())
		return FALSE
	reset_perspective()
	return TRUE

/**
 * returns if our perspective is shunted elsewhere
 */
/mob/proc/perspective_shunted()
	return self_perspective != using_perspective

//? Perspective - Self

// * ALL OF THESE SHOULD BE REGEXED LATER *
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

//? Darksight

/**
 * get our innate darksight
 */
/mob/proc/innate_darksight()
	RETURN_TYPE(/datum/vision/baseline)
	return vision_override || GLOB.default_darksight

/**
 * get all darksight datums, ordered. 1 (front of list) is applied first.
 */
/mob/proc/query_darksight()
	RETURN_TYPE(/list)
	var/list/built = vision_modifiers?.Copy() || list()
	built.Insert(1, innate_darksight())
	return built

/**
 * updates our darksight data and pushes it to perspective
 */
/mob/proc/update_darksight()
	ensure_self_perspective()
	self_perspective.push_vision_stack(query_darksight())

/mob/proc/sort_vision_modifiers()
	if(isnull(vision_modifiers))
		return
	tim_sort(vision_modifiers)

/mob/proc/add_vision_modifier(datum/vision/modifier)
	if(ispath(modifier))
		modifier = cached_vision_holder(modifier)
	ASSERT(!(modifier in vision_modifiers))
	LAZYINITLIST(vision_modifiers)
	BINARY_INSERT(modifier, vision_modifiers, /datum/vision, modifier, priority, COMPARE_KEY)
	update_darksight()

/mob/proc/remove_vision_modifier(datum/vision/modifier)
	if(ispath(modifier))
		modifier = cached_vision_holder(modifier)
	LAZYREMOVE(vision_modifiers, modifier)
	update_darksight()

/**
 * returns if we have this exact modifier
 * usually you use this with paths / cached ones.
 */
/mob/proc/has_vision_modifier(datum/vision/modifier)
	if(ispath(modifier))
		modifier = cached_vision_holder(modifier)
	return modifier in vision_modifiers

//? Helpers

/mob/proc/can_see_plane(val)
	return val <= BYOND_PLANE || val >= HUD_PLANE || self_perspective.is_plane_visible(val)
