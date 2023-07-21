/**
 * # Parallax holders
 *
 * Holds all the information about a client's parallax
 *
 * Not on mob because parallax is area based, not mob based.
 *
 * How parallax works:
 * - Layers - normal layers, scroll with movement to relative position, can scroll
 * - Absolute - absolute layers, scroll with movement to absolute position, cannot scroll
 * - Vis - vis_contents-like model - things in this are directly applied and get no processing whatsoever. Things like overmap ships can use this.
 *
 * ## Known Issues
 *
 * Secondary map support just affixes layers. There's no way to shift them around as the eye moves automatically.
 */
/datum/parallax_holder
	/// Client that owns us
	var/client/owner
	/// The parallax object we're currently rendering
	var/datum/parallax/parallax
	/// our plane holder
	var/datum/plane_holder/parallax/planes
	/// Eye we were last anchored to - used to detect eye changes
	var/atom/cached_eye
	/// force this eye as the "real" eye - useful for secondary maps
	var/atom/forced_eye
	/// last turf loc
	var/turf/last
	/// last area - for parallax scrolling/loop animations
	var/area/last_area
	/// Holder object for vis
	var/atom/movable/screen/parallax_vis/vis_holder
	/// are we not on the main map? if so, put map id here
	var/secondary_map
	/// all layers
	var/list/atom/movable/screen/parallax_layer/layers
	/// vis contents
	var/list/atom/movable/vis
	/// currently scrolling?
	var/scrolling = FALSE
	/// current scroll speed in DS per scroll
	var/scroll_speed
	/// current scroll turn - applied after angle. if angle is 0 (picture moving north) and turn is 90, it would be like if you turned your viewport 90 deg clockwise.
	var/scroll_turn

/datum/parallax_holder/New(client/C, secondary_map, forced_eye)
	owner = C
	src.secondary_map = secondary_map
	src.forced_eye = forced_eye
	planes = new(secondary_map)
	reset()

/datum/parallax_holder/Destroy()
	if(owner)
		if(owner.parallax_holder == src)
			owner.parallax_holder = null
		remove()
	HardResetAnimations()
	QDEL_NULL(vis_holder)
	QDEL_NULL(parallax)
	layers = null
	vis = null
	last = null
	forced_eye = cached_eye = null
	owner = null
	return ..()

/datum/parallax_holder/proc/reset(auto_z_change, force)
	if(!(cached_eye = Eye()))
		// if no eye, tear down
		last = cached_eye = last_area = null
		SetParallax(null, null, auto_z_change)
		return
	// first, check loc
	var/turf/T = get_turf(cached_eye)
	if(!T)
		// if in nullspace, tear down
		last = cached_eye = last_area = null
		SetParallax(null, null, auto_z_change)
		return
	// set last loc and eye
	last = T
	last_area = T.loc
	// rebuild parallax
	SetParallax(SSparallax.get_parallax_datum(T.z), null, auto_z_change, force)
	// hard reset positions to correct positions
	for(var/atom/movable/screen/parallax_layer/L in layers)
		L.ResetPosition(T.x, T.y)

// better updates via client_mobs_in_contents can be created again when important recursive contents is ported!
/datum/parallax_holder/proc/Update(full)
	if(!full && (!cached_eye || (get_turf(cached_eye) == last)))
		return
	if(cached_eye != Eye())
		// eye mismatch, reset
		reset()
		return
	var/turf/T = get_turf(cached_eye)
	if(!last || !T || T.z != last.z)
		// z mismatch, reset
		reset()
		return
	// get rel offsets
	var/rel_x = T.x - last.x
	var/rel_y = T.y - last.y
	// set last
	last = T
	// move
	for(var/atom/movable/screen/parallax_layer/L in layers)
		L.RelativePosition(T.x, T.y, rel_x, rel_y)
	// process scrolling/movedir
	if(last_area != T.loc)
		last_area = T.loc
		UpdateMotion()

/**
 * Gets the eye we should be centered on
 */
/datum/parallax_holder/proc/Eye()
	return forced_eye || owner?.eye

/**
 * Syncs us to our parallax objects. Does NOT check if we should have those objects, that's reset()'s job.
 *
 * Doesn't move/update positions/screen locs either.
 *
 * Also ensures movedirs are correct for the eye's pos.
 */
/datum/parallax_holder/proc/Sync(auto_z_change, force)
	layers = list()
	for(var/atom/movable/screen/parallax_layer/L in parallax.objects)
		layers += L
		L.map_id = secondary_map
	if(!istype(vis_holder))
		vis_holder = new /atom/movable/screen/parallax_vis
	SyncVisContents()
	UpdateMotion(auto_z_change, force)

/**
 * syncs vis contents
 */
/datum/parallax_holder/proc/SyncVisContents()
	var/turf/T = get_turf(cached_eye)
	vis_holder.vis_contents = vis = T? SSparallax.get_parallax_vis_contents(T.z) : list()

/**
 * Updates motion if needed
 */
/datum/parallax_holder/proc/UpdateMotion(auto_z_change, force)
	var/turf/T = get_turf(cached_eye)
	if(!T)
		if(scroll_speed || scroll_turn)
			HardResetAnimations()
		return
	var/list/ret = SSparallax.get_parallax_motion(T.z)
	if(ret)
		Animation(ret[1], ret[2], auto_z_change? 0 : ret[3], auto_z_change? 0 : ret[4], force)
	else
		var/area/A = T.loc
		Animation(A.parallax_move_speed, A.parallax_move_angle, auto_z_change? 0 : null, auto_z_change? 0 : null, force)

/datum/parallax_holder/proc/apply(client/C = owner)
	if(QDELETED(C))
		return
	. = list()
	if(C.is_preference_enabled(/datum/client_preference/parallax))
		for(var/atom/movable/screen/parallax_layer/L in layers)
			// if(L.parallax_intensity > owner.prefs.parallax)
			// 	continue
			if(!L.ShouldSee(C, last))
				continue
			L.SetView(C.view, TRUE)
			. |= L
		if(vis_holder)
			. |= vis_holder
		var/atom/movable/screen/plane_master/space/space_plane = planes.by_plane_type(/atom/movable/screen/plane_master/space)
		space_plane.color = list(
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			1, 1, 1, 1,
			0, 0, 0, 0,
		)
	else
		var/atom/movable/screen/plane_master/space/space_plane = planes.by_plane_type(/atom/movable/screen/plane_master/space)
		space_plane.color = initial(space_plane.color)
	. |= planes.screens()
	C.screen |= .

/datum/parallax_holder/proc/remove(client/C = owner)
	if(QDELETED(C))
		return
	C.screen -= layers
	C.screen -= vis_holder
	C.screen -= planes.screens()

/datum/parallax_holder/proc/SetParallaxType(path)
	if(!ispath(path, /datum/parallax))
		CRASH("Invalid path")
	SetParallax(new path)

/datum/parallax_holder/proc/SetParallax(datum/parallax/P, delete_old = TRUE, auto_z_change, force)
	if(P == parallax)
		return
	remove()
	if(delete_old && istype(parallax) && !QDELETED(parallax))
		qdel(parallax)
	HardResetAnimations()
	parallax = P
	if(!parallax)
		return
	Sync(auto_z_change, force)
	apply()

/**
 * Runs a modifier to parallax as an animation.
 *
 * @params
 * speed - ds per loop
 * turn - angle clockwise from north to turn the motion to, where you're scrolling **towards** it
 * windup - ds to spend on windups. 0 for immediate.
 * turn_speed - ds to spend on turning. 0 for immediate.
 */
/datum/parallax_holder/proc/Animation(speed = 25, turn = 0, windup = speed, turn_speed = speed, force)
	// Parallax doesn't currently use this method of rotating.

	// #if !PARALLAX_ROTATION_ANIMATIONS
	// 	turn_speed  = 0
	// #endif

	if(speed == 0)
		StopScrolling(turn = turn, time = windup)
		return
	if(scroll_speed == speed && !force)
		// we're done
		return
	// speed diff?
	scroll_speed = speed
	scrolling = TRUE
	// always scroll from north; turn handles everything
	for(var/atom/movable/screen/parallax_layer/P in layers)
		if(P.absolute)
			continue
		var/matrix/translate_matrix = matrix()
		translate_matrix.Translate(sin(turn) * 480, cos(turn) * 480)
		var/matrix/target_matrix = matrix()
		var/move_speed = speed * P.speed
		// do the first segment by shifting down one screen
		P.transform = translate_matrix
		animate(P, transform = target_matrix, time = move_speed, easing = QUAD_EASING|EASE_IN, flags = ANIMATION_END_NOW)
		// queue up another incase lag makes QueueLoop not fire on time, this time by shifting up
		animate(transform = translate_matrix, time = 0)
		animate(transform = target_matrix, time = move_speed)
		P.QueueLoop(move_speed, speed * P.speed, translate_matrix, target_matrix)

/**
 * Smoothly stops the animation, turning to a certain angle as needed.
 */
/datum/parallax_holder/proc/StopScrolling(turn = 0, time = 30)
	// reset turn
	if(turn != scroll_turn)
		var/matrix/turn_transform = matrix()
		turn_transform.Turn(turn)
		scroll_turn = turn
		animate(planes.by_plane_type(/atom/movable/screen/plane_master/parallax), transform = turn_transform, time = time, easing = QUAD_EASING | EASE_OUT, flags = ANIMATION_END_NOW | ANIMATION_LINEAR_TRANSFORM)
	if(scroll_speed == 0)
		// we're done
		scrolling = FALSE
		scroll_speed = 0
		return
	scrolling = FALSE
	scroll_speed = 0
	// someone can do the math for "stop after a smooth iteration" later.
	for(var/atom/movable/screen/parallax_layer/P in layers)
		if(P.absolute)
			continue
		P.CancelAnimation()
		var/matrix/translate_matrix = matrix()
		translate_matrix.Translate(cos(turn) * 480, sin(turn) * 480)
		P.transform = translate_matrix
		animate(P, transform = matrix(), time = time, easing = QUAD_EASING | EASE_OUT)

/**
 * fully resets animation state
 */
/datum/parallax_holder/proc/HardResetAnimations()
	// reset vars
	scroll_turn = 0
	scroll_speed = 0
	scrolling = FALSE
	// reset turn
	animate(planes.by_plane_type(/atom/movable/screen/plane_master/parallax), transform = matrix(), time = 0, flags = ANIMATION_END_NOW)
	// reset objects
	for(var/atom/movable/screen/parallax_layer/P in layers)
		if(P.absolute)
			continue
		P.CancelAnimation()
		animate(P, transform = matrix(), time = 0, flags = ANIMATION_END_NOW)

/atom/movable/screen/parallax_vis
	screen_loc = "LEFT,BOTTOM"
	icon = null
