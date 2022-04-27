/**
 * MOB PERRSPECTIVE SYSTEM
 *
 * allows managed control of client viewport/eye changes
 *
 * as of right now, perspectives will **trample** the following on every set:
 * client.eye
 * client.lazy_eye (unimplemented)
 * client.virtual_eye (unimplemented)
 * client.perspective
 * client.view
 * mob.see_in_dark
 * mob.see_invisible
 * mob.sight
 *
 * these will be added/removed using synchronized access,
 * and therefore existing values will be left alone,
 * as long as existing values are not also in the perspective:
 * client.screen
 * client.images
 *
 * this is intentional - most of mobcode uses their own screen/image synchronization code.
 * perspectives will never be able to replace that without ruining a lot of lazy-load
 * behavior. instead, perspective is focused on allowing using it to manage generic
 * synchronization of screen/images, rather than forcing the rest of the codebase to use it.
 *
 * however, perspectives are designed to force synchronization of the vars it does trample,
 * because there's no better way to do it (because those vars are, semantically, only relevant to our perspective),
 * while screen/images can be used for embedded maps/hud/etc.
 */

/**
  * Sets us to a /datum/perspective
  * If none is specified, defaults to self_perspective.
  *
  * @params
  * - P - perspective or atom - if atom, get_perspective() will be called on
  * - apply - whether to apply to client. this shold be false when resetting
  * 	due to a logout because the whole point is logout kills perspective!
  * - forceful - if the client is desynced from our using perspective, do we force it back?
  */
/mob/proc/reset_perspective(datum/perspective/P, apply = TRUE, forceful = TRUE)
	/// first of all if we are already on the right perspective we really don't care!
	if(P? (P == using_perspective) : (using_perspective == self_perspective))
		return
	if(!client)		// this is way easier if no client, and microoptimization
		if(using_perspective)
			using_perspective.RemoveMob(src)
			if(using_perspective)
				stack_trace("using perspective didn't clear us")
				using_perspective = null
		P = P || get_perspective()
		P.AddMob(src)
	else
		// ugh
		// get old perspective
		var/old = using_perspective
 		if(using_perspective)
			using_perspective.RemoveMob(src)
			if(using_perspective)
				stack_trace("using perspective didn't clear us")
				using_perspective = null
		// if no P, return us
		if(!P)
			P = get_perspective()
		else
			// if there's a P but client is gone, and it resets, use us again
			if(P.reset_on_logout && !client)
				P = get_perspective()
		// great, P exists
		// tell it to add us
		P.AddMob(src)
		// if client exists and we want to apply
		if(apply && client)
			if(!forceful)
				// if not forceful, only shunt if we're not desynced
				if(client.using_perspective == old)
					client.set_perspective(P)
			else
				client.set_perspective(P)

#warn nuke this from orbit
/mob/proc/reset_view(atom/A)
	if (client)
		if (istype(A, /atom/movable))
			client.perspective = EYE_PERSPECTIVE
			client.eye = A
		else
			if (isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
	return

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
	self_perspective.SetSeeInvis(flags)

/**
 * ditto
 */
/mob/proc/SetSeeInDarkSelf(see_invisible)
	ensure_self_perspective()
	self_perspective.SetDarksight(flags)

// Set client view distance (size of client's screen). Returns TRUE if anything changed.
// TODO: remove this and make everything change self perspective's viewsize
/mob/proc/set_viewsize(var/new_view = world.view)
	if (client && new_view != client.view)
		client.view = new_view
		return TRUE
	return FALSE
