/turf
	var/dynamic_lighting = TRUE
	luminosity           = 1

	var/tmp/lighting_corners_initialised = FALSE

	var/tmp/list/datum/light_source/affecting_lights       // List of light sources affecting this turf.
	var/tmp/atom/movable/lighting_object/lighting_object // Our lighting object.
	var/tmp/datum/lighting_corner/lc_topleft
	var/tmp/datum/lighting_corner/lc_topright
	var/tmp/datum/lighting_corner/lc_bottomleft
	var/tmp/datum/lighting_corner/lc_bottomright
	var/tmp/has_opaque_atom = FALSE // Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile.

// counterclockwisse 0 to 360
#define PROC_ON_CORNERS(operation) lc_topright?.##operation;lc_bottomright?.##operation;lc_bottomleft?.##operation;lc_topleft?.##operation

/// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	var/datum/light_source/L
	var/thing
	for (thing in affecting_lights)
		L = thing
		L.vis_update()

/// Forces a lighting update. Reconsider lights is preferred when possible.
/turf/proc/force_update_lights()
	var/datum/light_source/L
	for (var/thing in affecting_lights)
		L = thing
		L.force_update()


/turf/proc/lighting_clear_overlay()
	if (lighting_object)
		if (lighting_object.loc != src)
			stack_trace("Lighting overlay variable on turf [log_info_line(src)] is insane, lighting overlay actually located on [log_info_line(lighting_object.loc)]!")

	PROC_ON_CORNERS(update_active())

#define OPERATE(corner) \
	if(corner && !corner.active) { \
		for(i in corner.affecting) { \
			S = i ; \
			S.recalc_corner(corner, TRUE) \
		} \
		corner.active = TRUE \
	}

// Builds a lighting object for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay(now = FALSE)
	if (lighting_object)
		return // shrug
		// CRASH("Attempted to create lighting_object on tile that already had one.")

	if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(src))
		if (!lighting_corners_initialised)
			generate_missing_corners()

		new /atom/movable/lighting_object(src, now)

	var/datum/light_source/S
	var/i
	OPERATE(lc_topright)
	OPERATE(lc_bottomright)
	OPERATE(lc_bottomleft)
	OPERATE(lc_topleft)

#undef OPERATE


/**
 * Returns the average color of this tile.
 * Roughly corresponds to the color of a single old-style lighting overlay.
 */
/turf/proc/get_avg_color()
	if (!lighting_object)
		return null

	var/lum_r = (lc_topright? (lc_topright.lum_r) : 0) + (lc_bottomright? (lc_bottomright.lum_r) : 0) + (lc_bottomleft? (lc_bottomleft.lum_r) : 0) + (lc_topleft? (lc_topleft.lum_r) : 0)
	var/lum_g = (lc_topright? (lc_topright.lum_g) : 0) + (lc_bottomright? (lc_bottomright.lum_g) : 0) + (lc_bottomleft? (lc_bottomleft.lum_g) : 0) + (lc_topleft? (lc_topleft.lum_g) : 0)
	var/lum_b = (lc_topright? (lc_topright.lum_b) : 0) + (lc_bottomright? (lc_bottomright.lum_b) : 0) + (lc_bottomleft? (lc_bottomleft.lum_b) : 0) + (lc_topleft? (lc_topleft.lum_b) : 0)

	lum_r = CLAMP01(lum_r / 4) * 255
	lum_g = CLAMP01(lum_g / 4) * 255
	lum_b = CLAMP01(lum_b / 4) * 255

	return "#[num2hex(lum_r, 2)][num2hex(lum_g, 2)][num2hex(lum_g, 2)]"

#define SCALE(targ ,min, max) (targ - min) / (max - min)

/// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if(!lighting_object)
		return 0.5

	var/totallums = (lc_topright? (lc_topright.lum_r + lc_topright.lum_g + lc_topright.lum_b) : 0) \
	+ (lc_bottomright? (lc_bottomright.lum_r + lc_bottomright.lum_g + lc_bottomright.lum_b) : 0) \
	+ (lc_bottomleft? (lc_bottomleft.lum_r + lc_bottomleft.lum_g + lc_bottomleft.lum_b) : 0) \
	+ (lc_topleft? (lc_topleft.lum_r + lc_topleft.lum_g + lc_topleft.lum_b) : 0)

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = SCALE(totallums, minlum, maxlum)

	return CLAMP01(totallums)

/**
 * Returns a boolean whether the turf is on soft lighting.
 * Soft lighting being the threshold at which point the overlay considers
 * itself as too dark to allow sight and see_in_dark becomes useful.
 * So basically if this returns true the tile is unlit black.
 */
/turf/proc/is_softly_lit()
	if (!lighting_object)
		return FALSE

	return !lighting_object.luminosity

/// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
#ifdef AO_USE_LIGHTING_OPACITY
	var/old = has_opaque_atom
#endif

	has_opaque_atom = FALSE
	if (opacity)
		has_opaque_atom = TRUE
	else
		for (var/thing in src) // Loop through every movable atom on our tile
			var/atom/movable/A = thing
			if (A.opacity)
				has_opaque_atom = TRUE
				break 	// No need to continue if we find something opaque.

#ifdef AO_USE_LIGHTING_OPACITY
	if (old != has_opaque_atom)
		regenerate_ao()
#endif


/turf/Exited(atom/movable/Obj, atom/newloc)
	. = ..()

	if (Obj && Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

/turf/proc/change_area(area/old_area, area/new_area)
	if(SSlighting.initialized)
		if (new_area.dynamic_lighting != old_area.dynamic_lighting)
			if (new_area.dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

/turf/proc/generate_missing_corners()
	if (!TURF_IS_DYNAMICALLY_LIT_UNSAFE(src) && !light_sources && !(z_flags & ZM_ALLOW_LIGHTING))
		return

	lighting_corners_initialised = TRUE
	// counterclockwise from 0 to 360.
	if(!lc_topright)
		new /datum/lighting_corner(src, NORTHEAST)
	if(!lc_bottomright)
		new /datum/lighting_corner(src, SOUTHEAST)
	if(!lc_bottomleft)
		new /datum/lighting_corner(src, SOUTHWEST)
	if(!lc_topleft)
		new /datum/lighting_corner(src, NORTHWEST)

#undef PROC_ON_CORNERS
