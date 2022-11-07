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
	/// active clients - this is not the same as mobs because a client can be looking somewhere that isn't their mob
	var/list/client/clients = list()
	/// mobs that are using this - required for clean gcs
	var/list/mob/mobs = list()
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
	ClearMobs()
	images = null
	screens = null
	clients = null
	eye = null
	virtual_eye = null
	return ..()

/// ONLY CALL FROM CLIENT.SET_PERSPECTIVE
/// I DO NOT TRUST PEOPLE TO NOT SCREW THIS UP
/datum/perspective/proc/AddClient(client/C)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(C in clients)
		return
	if(C.using_perspective)
		CRASH("client already had perspective")
	clients += C
	C.using_perspective = src
	SEND_SIGNAL(src, COMSIG_PERSPECTIVE_CLIENT_REGISTER, C)
	Apply(C)

/// ONLY CALL FROM CLIENT.SET_PERSPECTIVE
/// I DO NOT TRUST PEOPLE TO NOT SCREW THIS UP
/datum/perspective/proc/RemoveClient(client/C, switching = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(!(C in clients))
		return
	clients -= C
	Remove(C)
	// if we're not doing this as part of a switch have them immediately switch to the mob
	// oh and make sure they unregister
	if(C.using_perspective != src)
		stack_trace("client had wrong perspective")
	C.using_perspective = null
	SEND_SIGNAL(src, COMSIG_PERSPECTIVE_CLIENT_UNREGISTER, C, switching)
	if(!switching)
		C.reset_perspective()

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
 * kicks all obs off of us
 */
/datum/perspective/proc/ClearMobs()
	for(var/mob/M as anything in mobs)
		RemoveMob(M)

/**
 * registers as a mob's current perspective
 */
/datum/perspective/proc/AddMob(mob/M)
	SHOULD_CALL_PARENT(TRUE)
	if(M.using_perspective)
		CRASH("mob already had perspective")
	if(reset_on_logout && !M.client)	// nah
		return
	mobs += M
	M.using_perspective = src
	SEND_SIGNAL(src, COMSIG_PERSPECTIVE_MOB_ADD, M)

/**
 * unregisters as a mob's current perspective
 */
/datum/perspective/proc/RemoveMob(mob/M, switching = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	mobs -= M
	SEND_SIGNAL(src, COMSIG_PERSPECTIVE_MOB_REMOVE, M, switching)
	if(M.using_perspective == src)
		M.using_perspective = null
		if(!switching)
			M.reset_perspective()
	else
		CRASH("mob had wrong perspective")

/**
 * applys screen objs, etc, stuff that shouldn't be updated regularly
 */
/datum/perspective/proc/Apply(client/C)
	SHOULD_CALL_PARENT(TRUE)
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
	// we default to eye perspectivie
	// also this is honestly pointless but theoretically mob perspective should always be used while on mob
	// this is stupid and i'm stupid
	return ((eye == C.mob) && MOB_PERSPECTIVE) || perspective

/**
 * updates eye, perspective var, virtual eye, lazy eye, sight, see in dark, see invis
 */
/datum/perspective/proc/Update(client/C)
	SEND_SIGNAL(src, COMSIG_PERSPECTIVE_CLIENT_UPDATE, C)
	var/changed = C.eye
	var/new_eye = GetEye(C)
	if(!new_eye)
		stack_trace("got null on GetEye, this shouldn't be possible")
		C.eye = C.mob
	else
		C.eye = new_eye
	if(changed != C.eye)
		C.parallax_holder?.Reset(force = TRUE)
	C.perspective = GetEyeMode(C)
	C.mob.sight = sight
	C.mob.see_in_dark = see_in_dark
	C.mob.see_invisible = see_invisible
	if(view_size)
		C.change_view(view_size, TRUE)

/**
 * update all viewers
 */
/datum/perspective/proc/UpdateAll()
	for(var/client/C as anything in clients)
		Update(C)

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

/datum/perspective/proc/SetEyeMode(perspective)
	var/change = src.perspective != perspective
	if(!change)
		return
	src.perspective = perspective
	for(var/client/C as anything in clients)
		C.perspective = GetEyeMode()

/datum/perspective/proc/SetEye(atom/movable/AM)
	var/change = src.eye != AM
	if(!change)
		return
	src.eye = AM
	for(var/client/C as anything in clients)
		var/changed = C.eye
		C.eye = GetEye(C)
		if(changed != C.eye)
			C.parallax_holder?.Reset(force = TRUE)
		C.perspective = GetEyeMode()

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
			C.change_view(new_size, TRUE)

/datum/perspective/proc/considered_remote(mob/M)
	return eye == M

/**
 * used for self-perspectives - eye should always be the owner
 */
/datum/perspective/self

/datum/perspective/self/GetEye(client/C)
	return get_top_atom(eye)

/datum/perspective/self/proc/get_top_atom(atom/movable/where)
	if(isturf(where))
		return where		// already on turf
	var/turf/T = get_turf(where)
	if(!T)
		return where	// either the perspective owner's mob or someone fucked up royally
	// we know we're on a turf now (assuming get_turf() didn't break but that'd be a byond thing) so
	while(!isturf(where.loc))
		where = where.loc
	return where

/**
 * temporary perspectives generated - automatically deletes when last mob is gone
 */
/datum/perspective/self/temporary

/datum/perspective/self/temporary/RemoveMob(mob/M, switching)
	. = ..()
	if(!mobs.len)
		qdel(src)

/**
 * always remote - you usually want to override this
 */
/datum/perspective/remote

/datum/perspective/remote/considered_remote(mob/M)
	return TRUE
