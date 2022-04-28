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
  */
/mob/proc/reset_perspective(datum/perspective/P, apply = TRUE, forceful = TRUE)
	if(P? ((ismovable(P) && istype(using_perspective, /datum/perspective/self/temporary))? (using_perspective?.eye == P) : (P == using_perspective)) : (using_perspective && (using_perspective == self_perspective)))
		return
	if(ismovable(P))
		var/atom/movable/AM = P
		P = AM.get_perspective()
	/// first of all if we are already on the right perspective we really don't care!
	if(!client)		// this is way easier if no client, and microoptimization
		if(using_perspective)
			using_perspective.RemoveMob(src)
			if(using_perspective)
				stack_trace("using perspective didn't clear us")
				using_perspective = null
		P = P || get_perspective()
		P.AddMob(src)
		return
	var/old = using_perspective
	// get old perspective first
	if(using_perspective)
		using_perspective.RemoveMob(src)
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

	reset_perspective()

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
/mob/proc/update_perspective()
	if(!client)
		return
	if(using_perspective != client.using_perspective)	// shunt them back in, useful if something's temporarily shunted our client away
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

// Set client view distance (size of client's screen). Returns TRUE if anything changed.
// TODO: remove this and make everything change self perspective's viewsize
/mob/proc/set_viewsize(var/new_view = world.view)
	if (client && new_view != client.view)
		client.view = new_view
		return TRUE
	return FALSE
