// TODO: Grab Nebula/O7 Lighting. @Zandario

/atom/movable/lighting_object
	name = ""
	anchored = TRUE
	atom_flags = ATOM_ABSTRACT

	icon = LIGHTING_ICON
	icon_state = LIGHTING_TRANSPARENT_ICON_STATE
	color = null //we manually set color in init instead
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING

	var/needs_update = FALSE
	var/turf/myturf

	#if WORLD_ICON_SIZE != 32
	transform = matrix(WORLD_ICON_SIZE / 32, 0, (WORLD_ICON_SIZE - 32) / 2, 0, WORLD_ICON_SIZE / 32, (WORLD_ICON_SIZE - 32) / 2)
	#endif

/atom/movable/lighting_object/Initialize(mapload)
	. = ..()
	verbs.Cut()
	//We avoid setting this in the base as if we do then the parent atom handling will add_atom_color it and that
	//is totally unsuitable for this object, as we are always changing its colour manually
	color = LIGHTING_BASE_MATRIX

	myturf = loc
	if (myturf.lighting_object)
		qdel(myturf.lighting_object, force = TRUE)
	myturf.lighting_object = src
	myturf.luminosity = 0

	for(var/turf/space/S in RANGE_TURFS(1, src)) //RANGE_TURFS is in code\__HELPERS\game.dm
		S.update_starlight()

	needs_update = TRUE
	GLOB.lighting_update_objects += src

/atom/movable/lighting_object/Destroy(force)
	if (force)
		GLOB.lighting_update_objects -= src
		if (loc != myturf)
			var/turf/oldturf = get_turf(myturf)
			var/turf/newturf = get_turf(loc)
			stack_trace("A lighting object was qdeleted with a different loc then it is suppose to have ([COORD(oldturf)] -> [COORD(newturf)])")
		if (isturf(myturf))
			myturf.lighting_object = null
			myturf.luminosity = 1
		myturf = null

		return ..()

	else
		return QDEL_HINT_LETMELIVE

// This is a macro PURELY so that the if below is actually readable.
#define ALL_EQUAL ((rr == gr && gr == br && br == ar) && (rg == gg && gg == bg && bg == ag) && (rb == gb && gb == bb && bb == ab))

/atom/movable/lighting_object/proc/update()
	if (loc != myturf)
		if (loc)
			var/turf/oldturf = get_turf(myturf)
			var/turf/newturf = get_turf(loc)
			stack_trace("A lighting object realised it's loc had changed in update() ([myturf]\[[myturf ? myturf.type : "null"]]([COORD(oldturf)]) -> [loc]\[[ loc ? loc.type : "null"]]([COORD(newturf)]))!")

		qdel(src, TRUE)
		return

	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

#ifdef VISUALIZE_LIGHT_UPDATES
	myturf.add_atom_colour(LIGHT_COLOR_LIGHT_CYAN, ADMIN_COLOUR_PRIORITY)
	animate(myturf, 10, color = null)
	addtimer(CALLBACK(myturf, /atom/proc/remove_atom_colour, ADMIN_COLOUR_PRIORITY, LIGHT_COLOR_LIGHT_CYAN), 10, TIMER_UNIQUE|TIMER_OVERRIDE)
#endif

	var/datum/lighting_corner/cr = myturf.lc_bottomleft  || dummy_lighting_corner
	var/datum/lighting_corner/cg = myturf.lc_bottomright || dummy_lighting_corner
	var/datum/lighting_corner/cb = myturf.lc_topleft     || dummy_lighting_corner
	var/datum/lighting_corner/ca = myturf.lc_topright    || dummy_lighting_corner

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)
	luminosity = max > LIGHTING_SOFT_THRESHOLD

	var/rr = cr.cache_r
	var/rg = cr.cache_g
	var/rb = cr.cache_b

	var/gr = cg.cache_r
	var/gg = cg.cache_g
	var/gb = cg.cache_b

	var/br = cb.cache_r
	var/bg = cb.cache_g
	var/bb = cb.cache_b

	var/ar = ca.cache_r
	var/ag = ca.cache_g
	var/ab = ca.cache_b

	if(rr + rg + rb + gr + gg + gb + br + bg + bb + ar + ag + ab >= 12)
		icon_state = LIGHTING_TRANSPARENT_ICON_STATE
		color = null
	else if (!luminosity)
		icon_state = LIGHTING_DARKNESS_ICON_STATE
		color = null
	else if (rr == LIGHTING_DEFAULT_TUBE_R && rg == LIGHTING_DEFAULT_TUBE_G && rb == LIGHTING_DEFAULT_TUBE_B && ALL_EQUAL)
		icon_state = LIGHTING_STATION_ICON_STATE
		color = null
	else
		icon_state = LIGHTING_BASE_ICON_STATE
		if (islist(color))
			// Does this even save a list alloc?
			var/list/c_list = color
			c_list[CL_MATRIX_RR] = rr
			c_list[CL_MATRIX_RG] = rg
			c_list[CL_MATRIX_RB] = rb
			c_list[CL_MATRIX_GR] = gr
			c_list[CL_MATRIX_GG] = gg
			c_list[CL_MATRIX_GB] = gb
			c_list[CL_MATRIX_BR] = br
			c_list[CL_MATRIX_BG] = bg
			c_list[CL_MATRIX_BB] = bb
			c_list[CL_MATRIX_AR] = ar
			c_list[CL_MATRIX_AG] = ag
			c_list[CL_MATRIX_AB] = ab
			color = c_list
		else
			color = list(
				rr, rg, rb, 0,
				gr, gg, gb, 0,
				br, bg, bb, 0,
				ar, ag, ab, 0,
				0, 0, 0, 1
			)

	// If there's a Z-turf above and/or below us, update its shadower.
	if (!myturf.above)
		if (myturf.above.shadower)
			myturf.above.shadower.copy_lighting(src)
		else
			myturf.above.update_mimic()

	if (myturf.below)
		if (myturf.below.shadower)
			myturf.below.shadower.copy_lighting(src)
		else
			myturf.below.update_mimic()

// Variety of overrides so the overlays don't get affected by weird things.

/atom/movable/lighting_object/legacy_ex_act(severity)
	return 0

/atom/movable/lighting_object/singularity_act()
	return

/atom/movable/lighting_object/singularity_pull()
	return

/atom/movable/lighting_object/blob_act()
	return

/atom/movable/lighting_object/onTransitZ()
	return

/atom/movable/lighting_object/forceMove()
	return

// Override here to prevent things accidentally moving around overlays.
/atom/movable/lighting_object/forceMove(atom/destination, var/no_tp=FALSE, var/harderforce = FALSE)
	if(harderforce)
		. = ..()
