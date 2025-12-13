/atom/movable
	/// The mimic (if any) that's *directly* copying us.
	var/tmp/atom/movable/openspace/mimic/bound_overlay
	/// Movable-level Z-Mimic flags. This uses ZMM_* flags, not ZM_* flags.
	var/zmm_flags = NONE

/atom/movable/doMove(atom/dest)
	. = ..(dest)
	if (. && bound_overlay)
		// The overlay will handle cleaning itself up on non-openspace turfs.
		if (isturf(dest))
			// If you feel a need to change this from get_step(), don't. Any change that would require that is illegal with Z-Mimic's layering model.
			bound_overlay.doMove(get_step(src, UP))
			if (bound_overlay && dir != bound_overlay.dir)
				bound_overlay.setDir(dir)
		else	// Not a turf, so we need to destroy immediately instead of waiting for the destruction timer to proc.
			qdel(bound_overlay)

/atom/movable/setDir(ndir)
	. = ..()
	if (. && bound_overlay)
		bound_overlay.setDir(ndir)

/atom/movable/update_above()
	if (!isturf(loc))
		return

	if (MOVABLE_IS_BELOW_ZTURF(src))
		if (!bound_overlay)
			SSzcopy.discover_movable(src)
			return

		SSzcopy.queued_overlays += bound_overlay
		bound_overlay.queued += 1
	else
		qdel(bound_overlay)

// Grabs a list of every openspace object that's directly or indirectly mimicking this object. Returns an empty list if none found.
/atom/movable/proc/get_above_oo()
	. = list()
	var/atom/movable/curr = src
	while (curr.bound_overlay)
		. += curr.bound_overlay
		curr = curr.bound_overlay

// -- Openspace movables --

/atom/movable/openspace
	name = ""
	atom_flags = ATOM_ABSTRACT
	anchored = TRUE
	mouse_opacity = FALSE
	abstract_type = /atom/movable/openspace

/atom/movable/openspace/can_fall()
	return FALSE

// No.
/atom/movable/openspace/set_glide_size(new_glide_size, recursive)
	return

// This is an abstract object, we don't care about the move stack or throwing events.
/atom/movable/openspace/Move()
	if (bound_overlay)
		bound_overlay.forceMove(get_vertical_step(src, UP))
		// forceMove could've deleted our overlay
		if (bound_overlay && bound_overlay.dir != dir)
			bound_overlay.setDir(dir)
	return TRUE

// No blowing up abstract objects.
/atom/movable/openspace/ex_act(ex_sev)
	SHOULD_CALL_PARENT(FALSE)
	return

/atom/movable/openspace/singularity_act()
	return

/atom/movable/openspace/singularity_pull()
	return

/atom/movable/openspace/singuloCanEat()
	return

// -- MULTIPLIER / SHADOWER --

// Holder object used for dimming openspaces & copying lighting of below turf.
/atom/movable/openspace/multiplier
	name = "openspace multiplier"
	desc = "You shouldn't see this."
	icon = LIGHTING_ICON
	icon_state = "blank"
	plane = OPENTURF_MAX_PLANE
	layer = MIMICED_LIGHTING_LAYER_MAIN
	blend_mode = BLEND_MULTIPLY
	color = SHADOWER_DARKENING_COLOR

/atom/movable/openspace/multiplier/Destroy(force)
	if(!force)
		stack_trace("Turf shadower improperly qdel'd.")
		return QDEL_HINT_LETMELIVE
	var/turf/myturf = loc
	if (istype(myturf))
		myturf.shadower = null

	return ..()

/atom/movable/openspace/multiplier/proc/copy_lighting(atom/movable/lighting_overlay/LO)
	if (LO.needs_update)
		// If this LO is pending an update, avoid this update and just let it update us.
		return
	appearance = LO
	layer = MIMICED_LIGHTING_LAYER_MAIN
	plane = OPENTURF_MAX_PLANE
	blend_mode = BLEND_MULTIPLY
	invisibility = 0

	var/turf/T = loc
	if (!(T.below.mz_flags & MZ_NO_SHADOW))
		if (icon_state == LIGHTING_BASE_ICON_STATE)
			// We're using a color matrix, so just darken the colors across the board.
			var/list/c_list = color
			c_list[CL_MATRIX_RR] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_RG] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_RB] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_GR] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_GG] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_GB] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_BR] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_BG] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_BB] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_AR] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_AG] *= SHADOWER_DARKENING_FACTOR
			c_list[CL_MATRIX_AB] *= SHADOWER_DARKENING_FACTOR
			color = c_list
		else
			// Not a color matrix, so we can just use the color var ourselves.
			color = SHADOWER_DARKENING_COLOR

	if (our_overlays || priority_overlays)
		compile_overlays()
	else if (bound_overlay)
		// compile_overlays() calls update_above().
		update_above()

// -- OPENSPACE MIMIC --

// Object used to hold a mimiced atom's appearance.
/atom/movable/openspace/mimic
	plane = OPENTURF_MAX_PLANE
	var/atom/movable/associated_atom
	var/depth
	var/queued = 0
	var/destruction_timer
	var/mimiced_type
	var/original_z
	var/override_depth
	var/have_performed_fixup = FALSE

/atom/movable/openspace/mimic/New()
	SHOULD_CALL_PARENT(FALSE)
	atom_flags |= ATOM_INITIALIZED
	SSzcopy.openspace_overlays += 1
	loc?.Entered(src, null)

/atom/movable/openspace/mimic/Destroy()
	SSzcopy.openspace_overlays -= 1
	queued = 0

	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

	if (destruction_timer)
		deltimer(destruction_timer)

	return ..()

/atom/movable/openspace/mimic/attackby(obj/item/W, mob/user)
	to_chat(user, SPAN_NOTICE("\The [src] is too far away."))

/atom/movable/openspace/mimic/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	to_chat(user, SPAN_NOTICE("You cannot reach \the [src] from here."))

/atom/movable/openspace/mimic/examine(...)
	SHOULD_CALL_PARENT(FALSE)
	. = associated_atom.examine(arglist(args))	// just pass all the args to the copied atom

/atom/movable/openspace/mimic/doMove(turf/dest)
	var/atom/old_loc = loc
	. = ..()
	if (TURF_IS_MIMICKING(dest))
		if (destruction_timer)
			deltimer(destruction_timer)
			destruction_timer = null
		if (old_loc.z != loc.z)
			reset_internal_layering()
	else if (!destruction_timer)
		destruction_timer = ZM_DESTRUCTION_TIMER(src)

// Called when the turf we're on is deleted/changed.
/atom/movable/openspace/mimic/proc/owning_turf_changed()
	if (!destruction_timer)
		destruction_timer = ZM_DESTRUCTION_TIMER(src)

/atom/movable/openspace/mimic/proc/reset_internal_layering()
	if (bound_overlay?.override_depth)
		depth = bound_overlay.override_depth
	else if (isturf(associated_atom.loc))
		depth = min(SSzcopy.zlev_maximums[associated_atom.z] - associated_atom.z, OPENTURF_MAX_DEPTH)
		override_depth = depth

	plane = OPENTURF_MAX_PLANE - depth

	bound_overlay?.reset_internal_layering()

// -- TURF PROXY --

// This thing holds the mimic appearance for non-OVERWRITE turfs.
/atom/movable/openspace/turf_proxy
	plane = OPENTURF_MAX_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	zmm_flags = ZMM_IGNORE  // Only one of these should ever be visible at a time, the mimic logic will handle that.

/atom/movable/openspace/turf_proxy/attackby(obj/item/W, mob/user)
	loc.attackby(W, user)

/atom/movable/openspace/turf_proxy/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	loc.attack_hand(user)

/atom/movable/openspace/turf_proxy/attack_generic(mob/user as mob)
	loc.attack_generic(user)

/atom/movable/openspace/turf_proxy/examine(mob/examiner)
	SHOULD_CALL_PARENT(FALSE)
	. = loc.examine(examiner)


// -- TURF MIMIC --

// A type for copying non-overwrite turfs' self-appearance.
/atom/movable/openspace/turf_mimic
	plane = OPENTURF_MAX_PLANE	// These *should* only ever be at the top?
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/turf/delegate

/atom/movable/openspace/turf_mimic/Initialize(mapload, ...)
	. = ..()
	ASSERT(isturf(loc))
	delegate = loc:below

/atom/movable/openspace/turf_mimic/attackby(obj/item/W, mob/user)
	loc.attackby(W, user)

/atom/movable/openspace/turf_mimic/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	to_chat(user, SPAN_NOTICE("You cannot reach \the [src] from here."))

/atom/movable/openspace/turf_mimic/attack_generic(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You cannot reach \the [src] from here."))

/atom/movable/openspace/turf_mimic/examine(mob/examiner)
	SHOULD_CALL_PARENT(FALSE)
	. = delegate.examine(examiner)
