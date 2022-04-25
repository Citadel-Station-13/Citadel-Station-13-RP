/**
 * a perspective, governing what sight flags/eyes/etc a client should have
 *
 * used to manage remote viewing, so on, so forth
 */
/datum/perspective
	/// eye - where visual calcs go from
	var/atom/movable/eye
	/// virtual eye - the center of the map display
	var/atom/movable/virtual_eye
	/// client perspective var
	var/perspective = EYE_PERSPECTIVE
	/// lazy eye var
	var/lazy_eye = 0
	/// images
	var/list/image/images = list()
	/// screen objects
	var/atom/movable/screens = list()
	/// sight var
	var/sight = NONE
	/// active clients
	var/list/client/clients = list()
	/// view size
	var/view_size
	/// when a client logs out of a mob, and it's using us, the mob should reset to its self_perspective
	var/reset_on_logout = TRUE

/datum/perspective/Destroy()
	for(var/client/C as anything in clients)
		RemoveClient(C)
	images = null
	screens = null
	clients = null
	eye = null
	virtual_eye = null
	return ..()

/datum/perspective/proc/AddClient(client/C)

/datum/perspective/proc/RemoveClient(client/C)

/datum/perspective/proc/Apply(client/C)

/datum/perspective/proc/Remove(client/C)

/datum/perspective/proc/GetEye()
	return eye

/datum/perspective/proc/Update(client/C)

/datum/perspective/proc/AddImage(image/I)

/datum/perspective/proc/RemoveImage(image/I)

/datum/perspective/proc/AddScreen(atom/movable/AM)

/datum/perspective/proc/RemoveScreen(atom/movable/AM)

#warn do all of these

/datum/perspective/proc/considered_remote(mob/M)
	return eye == M

/**
 * used for self-perspectives - eye should always be the owner
 */
/datum/perspective/self

/datum/perspective/self/GetEye()
	return isturf(eye.loc)? eye : eye.loc

/**
 * temporary perspectives generated - automatically deletes when last client is gone
 */
/datum/perspective/self/temporary

/datum/perspective/self/temporary/RemoveClient(client/C)
	if(!clients.len)
		qdel(src)
