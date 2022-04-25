/**
 * a perspective, governing what sight flags/eyes/etc a client should have
 *
 * used to manage remote viewing, so on, so forth
 *
 * see mob_perspective.dm for more info
 */
/datum/perspective
	/// eye - where visual calcs go from
	var/atom/movable/eye
	/// virtual eye - the center of the map display
	var/atom/movable/virtual_eye
	/// client perspective var
	var/perspective = EYE_PERSPECTIVE
	/// images
	var/list/image/images = list()
	/// screen objects
	var/atom/movable/screens = list()
	/// sight var
	var/sight = SEE_SELF
	/// active clients
	var/list/client/clients = list()
	/// view size
	#warn standardize view size
	var/view_size
	/// when a client logs out of a mob, and it's using us, the mob should reset to its self_perspective
	var/reset_on_logout = TRUE
	/// see in dark
	var/see_in_dark = 2
	/// see_invisible
	var/see_invisible = SEE_INVISIBLE_LIVING

/datum/perspective/Destroy()
	KickAll()
	images = null
	screens = null
	clients = null
	eye = null
	virtual_eye = null
	return ..()

/datum/perspective/proc/AddClient(client/C)

/datum/perspective/proc/RemoveClient(client/C)
	#warn also have to make sure client goes back to mob's self perspective

/**
 * kicks all clients off us
 */
/datum/perspective/proc/KickAll()
	for(var/client/C as anything in clients)
		RemoveClient(C)

/datum/perspective/proc/Apply(client/C)

/datum/perspective/proc/Remove(client/C)

/datum/perspective/proc/GetEye()
	return eye

/**
 * updates eye, perspective var, virtual eye, lazy eye, sight, see in dark, see invis
 */
/datum/perspective/proc/Update(client/C)

/datum/perspective/proc/AddImage(image/I)

/datum/perspective/proc/RemoveImage(image/I)

/datum/perspective/proc/AddScreen(atom/movable/AM)

/datum/perspective/proc/RemoveScreen(atom/movable/AM)

/datum/perspective/proc/SetSight(flags)

/datum/perspective/proc/AddSight(flags)

/datum/perspective/proc/RemoveSight(flags)

/datum/perspective/proc/SetDarksight(see_in_dark)

/datum/perspective/proc/SetSeeInvis(see_invisible)

/datum/perspective/proc/SetViewSize(new_size)

#warn do all of these

/datum/perspective/proc/considered_remote(mob/M)
	return eye == M

/**
 * used for self-perspectives - eye should always be the owner
 */
/datum/perspective/self

/datum/perspective/self/GetEye(client/C)
	return isturf(eye.loc)? eye : eye.loc

/datum/perspective/self/Update(client/C)
	. = ..()
	C.perspective = C.eye == C.mob? MOB_PERSPECTIVE : EYE_PERSPECTIVE

/**
 * temporary perspectives generated - automatically deletes when last client is gone
 */
/datum/perspective/self/temporary

/datum/perspective/self/temporary/RemoveClient(client/C)
	if(!clients.len)
		qdel(src)

/**
 * always remote - you usually want to override this
 */
/datum/perspective/remote

/datum/perspective/remote/considered_remote(mob/M)
	return TRUE

/datum/perspective/remote/overrides_sight(client/C)
	return TRUE
