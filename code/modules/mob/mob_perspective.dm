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
 */

/**
  * Sets us to a /datum/perspective
  * If none is specified, defaults to self_perspective.
  *
  * @params
  * - P - perspective or atom - if atom, get_perspective() will be called on
  * - apply - whether to apply to client. this shold be false when resetting
  * 	due to a logout because the whole point is logout kills perspective!
  */
/mob/proc/reset_perspective(datum/perspective/P, apply = TRUE)
	if(ismovable(P))
		var/atom/movable/AM = P
		P = AM.get_perspective()
	if(!P)
		ensure_self_perspective()
		P = self_perspective
	// atm, perspective will handle transfers
	if(client && apply)
		P.AddClient(client)
	if(client || !P.reset_on_logout)
		using_perspective = P

/**
 * we're considered to be viewing from some/something else's perspective
 */
/mob/proc/IsRemoteViewing()
	return (using_perspective != self_perspective) && using_perspective

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

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"

	reset_perspective()

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
 * are we currently looking at something else?
 */
/mob/proc/perspective_is_remote()
	return using_perspective?.considered_remote(src)

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
/mob/proc/set_viewsize(var/new_view = world.view)
	#warn NUKE THIS FROM ORBIT
	if (client && new_view != client.view)
		client.view = new_view
		return TRUE
	return FALSE
