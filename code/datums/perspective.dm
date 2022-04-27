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
	var/list/atom/movable/screens = list()
	/// sight var
	var/sight = SEE_SELF
	/// active clients
	var/list/client/clients = list()
	/// view size
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
	if(C in clients)
		return
	// for adding, unlike removing, if it's already on a perspective, we allow the swap smoothly since this is how it's usually done
	// in the future consider client/proc/SwitchPerspective() instead of mob only procs (???? maybe ????)
	if(C.using_perspective)
		C.using_perspective.RemoveClient(C, TRUE)
	clients += C
	if(C.using_perspective)
		stack_trace("[C] in AddClient, but perspective remained after auto swapout??")
	C.using_perspective = src
	Apply(C)

/datum/perspective/proc/RemoveClient(client/C, switching = FALSE)
	if(!(C in clients))
		return
	clients -= C
	Remove(C)
	// if we're not doing this as part of a switch have them immediately switch to the mob
	// oh and make sure they unregister
	if(C.using_perspective != src)
		stack_trace("[C] in RemoveClient, but perspective wasn't the one being removed from? Uh oh.")
	else
		C.using_perspective = null
	if(!switching)
		C.mob.reset_perspective()

/**
 * gets all clients viewing us
 */
/datum/perspective/proc/GetClients()
	return clients.Copy()

/**
 * kicks all clients off us
 */
/datum/perspective/proc/KickAll()
	for(var/client/C as anything in clients)
		RemoveClient(C)

/**
 * applys screen objs, etc, stuff that shouldn't be updated regularly
 */
/datum/perspective/proc/Apply(client/C)
	C.screen += screens
	C.images += images
	Update(C)

/datum/perspective/proc/Remove(client/C)
	C.screen -= screens
	C.images -= images

/datum/perspective/proc/GetEye(client/C)
	return eye

/**
 * get perspective var for a client
 */
/datum/perspective/proc/GetEyeMode(client/C)
	// necessary for smooth transitions when calling update_perspective
	return C.eye == C.mob? MOB_PERSPECTIVE : EYE_PERSPECTIVE

/**
 * updates eye, perspective var, virtual eye, lazy eye, sight, see in dark, see invis
 */
/datum/perspective/proc/Update(client/C)
	C.eye = GetEye()
	C.perspective = GetEyeMode()
	C.mob.sight = sight
	C.mob.see_in_dark = see_in_dark
	C.mob.see_invisible = see_invisible
	C.change_view(view_size)

/**
 * works with lists too
 */
/datum/perspective/proc/AddImage(image/I)
	var/change = images.len
	images |= I
	change = images.len - change
	if(images.len != change)
		for(var/client/C as anything in clients)
			// |=, not +=, because we don't check dupes.
			C.images |= I
/**
 * works with lists too
 */
/datum/perspective/proc/RemoveImage(image/I)
	var/change = images.len
	images -= I
	if(images.len != change)
		for(var/client/C as anything in clients)
			C.images -= I

/**
 * works with lists too
 */
/datum/perspective/proc/AddScreen(atom/movable/AM)
	var/change = screens.len
	screens |= AM
	if(screens.len != change)
		for(var/client/C as anything in clients)
			// |=, not +=, because we don't check dupes.
			C.screen |= AM

/**
 * works with lists too
 */
/datum/perspective/proc/RemoveScreen(atom/movable/AM)
	var/change = screens.len
	screens -= AM
	if(change != screens.len)
		for(var/client/C as anything in clients)
			C.screen -= AM

/datum/perspective/proc/SetSight(flags)
	var/change = sight ^ flags
	sight = flags
	if(change)
		for(var/client/C as anything in clients)
			C.mob.sight = sight

/datum/perspective/proc/AddSight(flags)
	var/change = sight ^ flags
	sight |= flags
	if(change)
		for(var/client/C as anything in clients)
			C.mob.sight = sight

/datum/perspective/proc/RemoveSight(flags)
	var/change = sight ^ flags
	sight |= ~(flags)
	if(change)
		for(var/client/C as anything in clients)
			C.mob.sight = sight

/datum/perspective/proc/SetDarksight(see_in_dark)
	var/change = src.see_in_dark != see_in_dark
	src.see_in_dark = see_in_dark
	if(change)
		for(var/client/C as anything in clients)
			C.mob.see_in_dark = see_in_dark

/datum/perspective/proc/SetSeeInvis(see_invisible)
	var/change = src.see_invisible != see_invisible
	src.see_invisible = see_invisible
	if(change)
		for(var/client/C as anything in clients)
			C.mob.see_invisible = see_invisible

/datum/perspective/proc/SetViewSize(new_size)
	var/change = view_size == new_size
	view_size = new_size
	if(change)
		for(var/client/C as anything in clients)
			C.change_view(new_size)

/datum/perspective/proc/considered_remote(mob/M)
	return eye == M

/**
 * used for self-perspectives - eye should always be the owner
 */
/datum/perspective/self

/datum/perspective/self/GetEye(client/C)
	return get_top_atom(eye)

/datum/perspective/self/proc/get_top_atom(atom/movable/where)
	while(where && !isturf(where) && !isturf(where.loc))
		where = where.loc
	return where

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
