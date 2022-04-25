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
  */
/mob/proc/reset_perspective(datum/perspective/P)
	#warn standardize this
	#warn standardize perspective var
	#warn standardize sight var
	if(client)
		if(A)
			if(ismovable(A))
				//Set the the thing unless it's us
				if(A != src)
					client.perspective = EYE_PERSPECTIVE
					client.eye = A
				else
					client.eye = client.mob
					client.perspective = MOB_PERSPECTIVE
			else if(isturf(A))
				//Set to the turf unless it's our current turf
				if(A != loc)
					client.perspective = EYE_PERSPECTIVE
					client.eye = A
				else
					client.eye = client.mob
					client.perspective = MOB_PERSPECTIVE
			else
				//Do nothing
		else
			//Reset to common defaults: mob if on turf, otherwise current loc
			if(isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
		return 1


#warn this file

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
	unset_machine()
	reset_view(null)

/**
 * updates our curent perspective
 */
/mob/proc/update_perspective()
	if(!client)
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
