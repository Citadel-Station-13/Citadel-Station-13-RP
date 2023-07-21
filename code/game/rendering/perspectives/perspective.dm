/**
 * MOB PERRSPECTIVE SYSTEM
 *
 * allows managed control of client viewport/eye changes
 *
 * !  - - - ATTENTION - - -
 * ! These datums will modify mob variables.
 * ! This can result in AI mobs having inconsistent sight/whatevers
 * ! from what they'd usually have after a player enters, and
 * ! leaves them.
 * ! Mob reset_perspective() should handle most of these cases, but be wary.
 *
 * ! - - - ATTENTION - - -
 * ! View sizes should only be for clients.
 * ! Do not read off this for stuff like AI view/target tracking.
 *
 * ? - - - ATTENTION - - -
 * ? We track MAXIMUM view sizes.
 * ? Client can resize up/down as needed.
 * ? If you want to force a client to a specific size,
 * ? regardless of their widescreen setting,
 * ? use client.set_temporary_view.
 * ? Augmented view will also ignore client prefs on widescreen, *kinda.*
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
	/// client perspective var
	var/perspective = EYE_PERSPECTIVE
	/// images
	var/list/image/images
	/// screen objects
	var/list/atom/movable/screens
	/// sight var
	var/sight = SIGHT_FLAGS_DEFAULT
	/// active clients - this is not the same as mobs because a client can be looking somewhere that isn't their mob
	var/list/client/clients
	/// mobs that are using this - required for clean gcs
	var/list/mob/mobs
	/// when a client logs out of a mob, and it's using us, the mob should reset to its self_perspective
	var/reset_on_logout = TRUE
	/// see in dark
	var/see_in_dark = 2
	/// see_invisible
	var/see_invisible = SEE_INVISIBLE_LIVING

	//? planes
	/// planes
	var/datum/plane_holder/mob_perspective/planes
	/// trait-like list for forcing planes on
	var/list/planes_visible

	//? view size
	/// default view; if null, world.view
	var/default_view_size
	/// view size increase x
	var/augment_view_width = 0
	/// view size increase y
	var/augment_view_height = 0
	/// suppression sources
	var/list/view_suppression
	/// cached view x
	var/cached_view_width
	/// cached view y
	var/cached_view_height
	/// view cache needs recompute
	var/view_dirty = TRUE

	//? vision - lighting / nightvision
	// todo: most of these don't need to be on baes /datum/perspective, i think.
	//       alternatively, just add a way to control whether we bother using this system.
	//       "darksight_system"?
	var/janky_should_we_use_darksight_system = FALSE
	/// darksight overlay that we maintain
	var/atom/movable/screen/darksight_fov/darksight_fov_overlay
	/// darksight overlay that we maintain
	var/atom/movable/screen/darksight_occlusion/darksight_occlusion_overlay
	/// lighting plane alpha
	var/hard_darkvision
	/// soft darksight range
	var/darkvision_range
	/// soft darksight alpha
	var/darkvision_alpha
	/// soft darksight matrix
	var/list/darkvision_matrix
	/// do we use smart darkvision?
	var/darkvision_smart
	/// is soft darkvision in global (infinite range) mode?
	var/darkvision_unlimited
	/// soft darkvision fov cone
	var/darkvision_fov
	//  todo: legacy: stuff like mesons that require hard darkvision use this to cap see_in_dark
	var/darkvision_legacy_throttle
	//  todo: legacy: used for xray fulbright
	var/legacy_forced_hard_darkvision
	//  todo: sigh, shadekin things
	var/legacy_throttle_overridden

/datum/perspective/Destroy()
	clear_clients()
	clear_mobs()
	QDEL_NULL(darksight_fov_overlay)
	QDEL_NULL(darksight_occlusion_overlay)
	images = null
	screens = null
	clients = null
	set_eye(null)
	return ..()

/// ONLY CALL FROM CLIENT.SET_PERSPECTIVE
/// I DO NOT TRUST PEOPLE TO NOT SCREW THIS UP
/datum/perspective/proc/add_client(client/C)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(C in clients)
		return
	if(C.using_perspective)
		CRASH("client already had perspective")
	LAZYADD(clients, C)
	C.using_perspective = src
	SEND_SIGNAL(src, COMSIG_PERSPECTIVE_CLIENT_REGISTER, C)
	apply(C)

/// ONLY CALL FROM CLIENT.SET_PERSPECTIVE
/// I DO NOT TRUST PEOPLE TO NOT SCREW THIS UP
/datum/perspective/proc/remove_client(client/C, switching = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(!(C in clients))
		return
	LAZYREMOVE(clients, C)
	remove(C)
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
/datum/perspective/proc/get_clients()
	return isnull(clients)? list() : clients.Copy()

/**
 * kicks all clients off us
 */
/datum/perspective/proc/clear_clients()
	for(var/client/C as anything in clients)
		remove_client(C)

/**
 * kicks all obs off of us
 */
/datum/perspective/proc/clear_mobs()
	for(var/mob/M as anything in mobs)
		remove_mobs(M)

/**
 * registers as a mob's current perspective
 * sets mob vars as necessary
 */
/datum/perspective/proc/add_mob(mob/M)
	SHOULD_CALL_PARENT(TRUE)
	if(M.using_perspective)
		CRASH("mob already had perspective")
	if(reset_on_logout && !M.client)	// nah
		return
	LAZYADD(mobs, M)
	M.using_perspective = src
	M.sight = sight
	M.see_in_dark = clamp(see_in_dark, 0, 255)
	M.see_invisible = see_invisible
	SEND_SIGNAL(src, COMSIG_PERSPECTIVE_MOB_ADD, M)

/**
 * unregisters as a mob's current perspective
 * resets mob vars to initial() values
 */
/datum/perspective/proc/remove_mobs(mob/M, switching = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	M.sight = initial(M.sight)
	M.see_in_dark = initial(M.see_in_dark)
	M.see_invisible = initial(M.see_invisible)
	LAZYREMOVE(mobs, M)
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
/datum/perspective/proc/apply(client/C)
	SHOULD_CALL_PARENT(TRUE)
	assert_planes()
	assert_vision_overlays()
	if(!isnull(screens))
		C.screen |= screens
	if(!isnull(planes))
		C.screen |= planes.screens()
	if(!isnull(images))
		C.images |= images
	update(C)

/**
 * fully reloads
 *
 * set owner to TRUE to apply prefs like AO.
 */
/datum/perspective/proc/reload(client/C, owner)
	assert_planes()
	if(owner)
		planes.sync_owner(C)
	apply(C)

/datum/perspective/proc/remove(client/C)
	if(!isnull(screens))
		C.screen -= screens
	if(!isnull(planes))
		C.screen -= planes.screens()
	if(!isnull(images))
		C.images -= images

/**
 * updates eye, perspective var, virtual eye, lazy eye, sight, see in dark, see invis
 */
/datum/perspective/proc/update(client/C)
	SEND_SIGNAL(src, COMSIG_PERSPECTIVE_CLIENT_UPDATE, C)
	var/changed = C.eye
	var/new_eye = get_eye(C)
	if(!new_eye)
		stack_trace("got null on get_eye, this shouldn't be possible")
		C.eye = C.mob
	else
		C.eye = new_eye
	if(changed != C.eye)
		C.parallax_holder?.reset(force = TRUE)
	C.perspective = get_eye_mode(C)
	update_view_size(C)

/**
 * update all viewers
 */
/datum/perspective/proc/update_all()
	for(var/client/C as anything in clients)
		update(C)

/**
 * works with lists too
 */
/datum/perspective/proc/add_image(image/I)
	var/change = length(images)
	if(!change)
		images = list()
	images |= I
	change = images.len - change
	if(images.len != change)
		for(var/client/C as anything in clients)
			// |=, not +=, because we don't check dupes.
			C.images |= I
/**
 * works with lists too
 */
/datum/perspective/proc/remove_image(image/I)
	var/change = length(images)
	if(!change)
		return
	images -= I
	if(images.len != change)
		for(var/client/C as anything in clients)
			C.images -= I

/**
 * works with lists too
 */
/datum/perspective/proc/add_screen(atom/movable/AM)
	var/change = length(screens)
	if(!change)
		screens = list()
	screens |= AM
	if(screens.len != change)
		for(var/client/C as anything in clients)
			// |=, not +=, because we don't check dupes.
			C.screen |= AM

/**
 * works with lists too
 */
/datum/perspective/proc/remove_screen(atom/movable/AM)
	var/change = length(screens)
	if(!change)
		return
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
	sight &= ~(flags)
	if(change)
		for(var/client/C as anything in clients)
			C.mob.sight = sight

/datum/perspective/proc/SetSeeInvis(see_invisible)
	var/change = src.see_invisible != see_invisible
	src.see_invisible = see_invisible
	if(change)
		for(var/client/C as anything in clients)
			C.mob.see_invisible = see_invisible

//? Abstraction - see_in_dark

/datum/perspective/proc/update_see_in_dark()
	var/wanted = INFINITY // show everything
	// if they have hard darkvision kick it back up
	if(legacy_forced_hard_darkvision || hard_darkvision < 255)
		wanted = INFINITY
	// if they have legacy throttle..
	if(!isnull(darkvision_legacy_throttle) && !legacy_throttle_overridden)
		wanted = min(darkvision_legacy_throttle, wanted)
	if(wanted != see_in_dark)
		see_in_dark = wanted
		for(var/mob/M as anything in mobs)
			M.see_in_dark = clamp(see_in_dark, 0, 255)

//? Eye

/datum/perspective/proc/set_eye_mode(perspective)
	var/change = src.perspective != perspective
	if(!change)
		return
	src.perspective = perspective
	for(var/client/C as anything in clients)
		C.perspective = get_eye_mode(C)

/datum/perspective/proc/set_eye(atom/movable/AM)
	var/change = src.eye != AM
	if(!change)
		return
	if(!isnull(src.eye))
		detach_from_eye(src.eye)
	src.eye = AM
	if(!isnull(src.eye))
		attach_to_eye(src.eye)
	for(var/client/C as anything in clients)
		var/changed = C.eye
		C.eye = get_eye(C)
		if(changed != C.eye)
			C.parallax_holder?.reset(force = TRUE)
		C.perspective = get_eye_mode(C)

/datum/perspective/proc/attach_to_eye(atom/movable/AM)
	RegisterSignal(AM, COMSIG_ATOM_DIR_CHANGE, PROC_REF(eye_dir_changed))

/datum/perspective/proc/detach_from_eye(atom/movable/AM)
	UnregisterSignal(AM, COMSIG_ATOM_DIR_CHANGE)

/datum/perspective/proc/eye_dir_changed(atom/movable/source, old_dir, new_dir)
	darksight_fov_overlay?.dir = new_dir

/datum/perspective/proc/get_eye(client/C)
	return eye

/**
 * get perspective var for a client
 */
/datum/perspective/proc/get_eye_mode(client/C)
	// necessary for smooth transitions when calling update_perspective
	// we default to eye perspectivie
	// also this is honestly pointless but theoretically mob perspective should always be used while on mob
	// this is stupid and i'm stupid
	return eye == C.mob? MOB_PERSPECTIVE : perspective

//? lighting

/datum/perspective/proc/push_vision_stack(list/datum/vision/holders)
	// reset to default
	hard_darkvision = 255
	darkvision_range = SOFT_DARKSIGHT_RANGE_DEFAULT
	darkvision_alpha = SOFT_DARKSIGHT_ALPHA_DEFAULT
	darkvision_matrix = construct_rgba_color_matrix()
	darkvision_smart = TRUE
	darkvision_unlimited = FALSE
	darkvision_legacy_throttle = INFINITY
	darkvision_fov = SOFT_DARKSIGHT_FOV_DEFAULT
	legacy_throttle_overridden = FALSE
	// push holders
	for(var/datum/vision/holder as anything in holders)
		holder.push(src)
	// ensure darkvision matrix is full color format - we have a bug where not doing so can break shit after the first push (?!)
	darkvision_matrix = color_matrix_expand(darkvision_matrix)
	darkvision_unlimited = darkvision_range >= SOFT_DARKSIGHT_UNLIMITED_THRESHOLD
	// update
	update_vision()

/datum/perspective/proc/update_vision()
	update_see_in_dark()
	update_planes()
	update_vision_overlays()

/datum/perspective/proc/assert_vision_overlays()
	. = TRUE
	if(isnull(darksight_fov_overlay))
		darksight_fov_overlay = new
		add_screen(darksight_fov_overlay)
	if(isnull(darksight_occlusion_overlay))
		darksight_occlusion_overlay = new
		add_screen(darksight_occlusion_overlay)
	if(!.)
		return
	update_vision_overlays()

/datum/perspective/proc/update_vision_overlays()
	if(!isnull(darksight_fov_overlay))
		// handle fov
		var/state_to_use = "fade-omni-super"
		var/color_to_use = null
		switch(darkvision_fov)
			if(SOFT_DARKSIGHT_FOV_270)
				state_to_use = "fade-270-hard"
			if(SOFT_DARKSIGHT_FOV_180)
				state_to_use = "fade-180-hard"
			if(SOFT_DARKSIGHT_FOV_90)
				state_to_use = "fade-90-hard"
			else
				state_to_use = "fade-omni-super"
				color_to_use = list(
					0, 0, 0, -0.5,
					0, 0, 0, -0.5,
					0, 0, 0, -0.5,
					0, 0, 0, 0,
					0, 0, 0, 1,
				)
		darksight_fov_overlay.icon_state = state_to_use
		darksight_fov_overlay.color = color_to_use
		if(view_dirty)
			recompute_view_size()
		// todo: this should take shifting into account, for things like binoculars.
		var/needed = max(cached_view_height, cached_view_width) / 15
		var/matrix/transforming = matrix()
		if(needed > 1)
			transforming.Scale(needed, needed)
		darksight_fov_overlay.transform = transforming
	if(!isnull(darksight_occlusion_overlay))
		// now, handle occlusion
		var/matrix/cropping = matrix()
		var/factor = ((darkvision_range / (WORLD_ICON_SIZE)) / ((15 / 2) + 1))
		cropping.Scale(factor)
		darksight_occlusion_overlay.transform = cropping

/datum/perspective/proc/legacy_force_set_hard_darkvision(amt)
	. = legacy_forced_hard_darkvision == amt
	legacy_forced_hard_darkvision = amt
	if(.)
		update_see_in_dark()
		update_planes()

//? plane holder

/datum/perspective/proc/assert_planes()
	if(!isnull(planes))
		return
	planes = new /datum/plane_holder/mob_perspective
	update_planes()

/datum/perspective/proc/update_planes()
	if(isnull(planes))
		return
	var/atom/movable/screen/plane_master/darkvision_plate = planes.by_plane_type(/atom/movable/screen/plane_master/darkvision)
	if(!isnull(darkvision_plate))
		darkvision_plate.color = darkvision_matrix?.Copy()
	var/atom/movable/screen/plane_master/lighting/lighting_plane = planes?.by_plane_type(/atom/movable/screen/plane_master/lighting)
	var/wanted_alpha = isnull(legacy_forced_hard_darkvision)? (isnull(hard_darkvision)? 255 : hard_darkvision) : legacy_forced_hard_darkvision
	lighting_plane.alpha = wanted_alpha
	var/lit_factor = darkvision_alpha / 255
	darkvision_plate.alpha = round((lit_factor * (wanted_alpha / 255)) * 255, 1)

/**
 * sets a plane visible if it wasn't already
 * source should be a trait source
 *
 * @params
 * * key - path to plane
 * * source - trait source enum
 */
/datum/perspective/proc/set_plane_visible(key, source)
	LAZYINITLIST(planes_visible)
	var/was = planes_visible[key]
	if(islist(was))
		planes_visible[key] |= source
	else
		planes_visible[key] = list(source)
		show_plane(key)

/**
 * removes a plane's visibility if it was forced to be visible
 * source should be a trait source
 *
 * @params
 * * key - path to plane (optional); if not specified, all planes from that source is removed.
 * * source - trait source enum.
 */
/datum/perspective/proc/unset_plane_visible(key, source)
	if(isnull(key))
		for(key in planes_visible)
			if(source in planes_visible[key])
				planes_visible[key] -= source
				if(!length(planes_visible[key]))
					planes_visible -= key
					hide_plane(key)
		return
	var/was = planes_visible[key]
	if(islist(was))
		was -= source
		if(!length(was))
			planes_visible -= key
			hide_plane(key)

/datum/perspective/proc/is_plane_visible(var/atom/movable/screen/plane_master/key, source)
	if(!initial(key.default_invisible))
		return TRUE
	if(isnull(source))
		return planes_visible[key]
	return source in planes_visible[key]

/datum/perspective/proc/show_plane(key, force)
	assert_planes()
	var/atom/movable/screen/plane_master/plane = planes.by_plane_type(key)
	if(isnull(plane))
		return
	plane.alpha = plane.default_alpha

/datum/perspective/proc/hide_plane(key, force)
	assert_planes()
	var/atom/movable/screen/plane_master/plane = planes.by_plane_type(key)
	if(isnull(plane))
		return
	if(!plane.default_invisible && !force)
		return
	plane.alpha = 0

//? view size

/**
 * Sets our default size.
 *
 * DO NOT use this in place of augmented.
 * User widescreen preferences WILL override this!
 *
 * Ideally this shouldn't be used at all.
 */
/datum/perspective/proc/set_default_view(size)
	if(size == default_view_size)
		return
	// assert it y'know, works
	if(isnum(size))
		default_view_size = size
	else if(isnull(size))
		default_view_size = size
	else if(istext(size))
		var/list/split = splittext(size, "x")
		ASSERT(split.len == 2)
		// if the above runtimes, let it so we know who fucked up
		default_view_size = size
	else
		CRASH("What?")
	view_dirty = TRUE
	update_view_size()

/**
 * Sets augmented size ontop of default size.
 *
 * Currently only supports positive numbers. Numbers apply equally
 * to both directions of a dimension.
 */
/datum/perspective/proc/set_augmented_view(width, height)
	if(!isnum(height) || !isnum(width))
		CRASH("invalid")
	// no negative augment values for now
	augment_view_height = max(0, height)
	augment_view_width = max(0, width)
	view_dirty = TRUE
	update_view_size()

/datum/perspective/proc/update_view_size(client/C)
	if(view_dirty)
		recompute_view_size()
	update_vision_overlays()
	if(C)
		C.request_viewport_update()
	else
		for(var/client/_C as anything in clients)
			update_view_size(_C)

/datum/perspective/proc/recompute_view_size()
	view_dirty = FALSE
	if(isnum(default_view_size))
		cached_view_height = default_view_size + augment_view_width
		cached_view_width = default_view_size + augment_view_height
		return
	else if(isnull(default_view_size))
		cached_view_width = GLOB.max_client_view_x + augment_view_width
		cached_view_height = GLOB.max_client_view_y + augment_view_height
		return
	var/list/parsed = splittext(default_view_size, "x")
	if(length(parsed) != 2)
		cached_view_width = GLOB.max_client_view_x + augment_view_width
		cached_view_height = GLOB.max_client_view_y + augment_view_height
		return
	cached_view_width = parsed[1] + augment_view_width
	cached_view_height = parsed[2] + augment_view_height

/datum/perspective/proc/suppress_view(source)
	var/was = LAZYLEN(view_suppression)
	LAZYDISTINCTADD(view_suppression, source)
	if(!was && LAZYLEN(view_suppression))
		view_dirty = TRUE
		update_view_size()

/datum/perspective/proc/unsuppress_view(source)
	var/was = LAZYLEN(view_suppression)
	LAZYREMOVE(view_suppression, source)
	if(was && !LAZYLEN(view_suppression))
		view_dirty = TRUE
		update_view_size()

/datum/perspective/proc/ensure_view_cached()
	if(view_dirty)
		recompute_view_size()

//! remotes
/datum/perspective/proc/considered_remote(mob/M)
	return eye == M

/**
 * used for self-perspectives - eye should always be the owner
 */
/datum/perspective/self

/datum/perspective/self/get_eye(client/C)
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

/datum/perspective/self/temporary/remove_mobs(mob/M, switching)
	. = ..()
	if(!length(mobs))
		qdel(src)

/**
 * always remote - you usually want to override this
 */
/datum/perspective/remote

/datum/perspective/remote/considered_remote(mob/M)
	return TRUE
