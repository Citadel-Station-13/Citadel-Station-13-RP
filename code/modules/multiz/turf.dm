/turf
	/// multiz behavior flags
	var/z_flags = Z_AIR_UP | Z_OPEN_UP

/**
 * WARNING: This proc is unique. Read the doc here, especially the return value.
 * Check if an atom can move into us from either above or below
 *
 * We don't use an unified CanZPass() because our codebase does the Funny of allowing logical multiz linkages that aren't actually +1 or -1 zlevel
 * So, it's actually going to be faster doing "snowflakey" in/out calls rather than an unified call that works like CanPass().
 *
 * @param
 * AM - moving atom
 * dir - Direction it's **coming from** (e.g. if it's above us, it'll be **UP**).
 * source - turf it's coming from
 *
 * @return
 * The atom that's blocking. Returns NULL if there's no obstruction.
 */
/turf/proc/z_pass_in_obstruction(atom/movable/mover, dir, turf/source)
	if(!(z_flags & (dir == UP? Z_OPEN_UP : Z_OPEN_DOWN)))
		return src
	for(var/atom/movable/AM as anything in contents)
		if(!AM.z_pass_in(mover, dir, source))
			return AM

/**
 * WARNING: This proc is unique. Read the doc here, especially the return value.
 * Check if an atom can move out of us to either above or below
 *
 * We don't use an unified CanZPass() because our codebase does the Funny of allowing logical multiz linkages that aren't actually +1 or -1 zlevel
 * So, it's actually going to be faster doing "snowflakey" in/out calls rather than an unified call that works like CanPass().
 *
 * @param
 * AM - moving atom
 * dir - Direction it's **going to** (e.g. if it's going through the roof, it'll be **UP**).
 * dest - turf it's going to
 *
 * @return
 * The atom that's blocking. Returns NULL if there's no obstruction.
 */
/turf/proc/z_pass_out_obstruction(atom/movable/mover, dir, turf/dest)
	if(!(z_flags & (dir == UP? Z_OPEN_UP : Z_OPEN_DOWN)))
		return src
	for(var/atom/movable/AM as anything in contents)
		if(!AM.z_pass_out(mover, dir, dest))
			return AM

/**
 * checks if an atom can exit us up or down
 * checks for physical obstructions and returns first obstruction;
 * does NOT check if the atom is logically able to move under its own power!
 *
 * WARNING: If the turf above/below us doesn't exist, this returns null.
 *
 * @params
 * - mover - atom that needs to move
 * - dir - are they going UP abov eus or DOWN below us?
 */
/turf/proc/z_exit_obstruction(atom/movable/mover, dir)
	// we assume dir is up/down because why wouldn't it be
	var/turf/dest
	if(dir == UP)
		dest = Above()
		return dest && (z_pass_out_obstruction(mover, UP, dest) || dest.z_pass_in_obstruction(mover, DOWN, src))
	else if(dir == DOWN)
		dest = Below()
		return dest && (z_pass_out_obstruction(mover, DOWN, dest) || dest.z_pass_in_obstruction(mover, UP, src))
	CRASH("What?")

/**
 * simple boolean check to see if something's physically blocked from leaving us via up/down
 *
 * @params
 * - mover - atom that needs to move
 * - dir - are they going UP abov eus or DOWN below us?
 */
/turf/proc/z_exit_check(atom/movable/mover, dir)
	// we assume dir is up/down because why wouldn't it be
	var/turf/dest
	if(dir == UP)
		dest = Above()
		return dest && !z_pass_out_obstruction(mover, UP, dest) && !dest.z_pass_in_obstruction(mover, DOWN, src)
	else if(dir == DOWN)
		dest = Below()
		return dest && !z_pass_out_obstruction(mover, DOWN, dest) && !dest.z_pass_in_obstruction(mover, UP, src)
	CRASH("What?")

/**
 * checks what is going to block something from falling through us
 */
/turf/proc/z_fall_obstruction(atom/movable/mover, levels, fall_flags)
	for(var/atom/movable/AM as anything in contents)
		if(AM.prevent_z_fall(mover, levels, fall_flags))
			return AM

/**
 * simple boolean check to see if something's physically blocked from falling through us
 */
/turf/proc/z_fall_check(atom/movable/mover, levels, fall_flags)
	if(!(z_flags & Z_OPEN_DOWN))
		return FALSE
	return isnull(z_fall_obstruction(mover, levels, fall_flags))

/turf/z_pass_in(atom/movable/AM, dir, turf/old_loc)
	return isnull(z_pass_in_obstruction(AM, dir, old_loc))

/turf/z_pass_out(atom/movable/AM, dir, turf/new_loc)
	return isnull(z_pass_out_obstruction(AM, dir, new_loc))

// todo: redo
/turf/CheckFall(atom/movable/falling_atom)
	if(!(z_flags & Z_OPEN_DOWN))
		return TRUE	// impact!
	return ..()

/turf/check_impact(atom/movable/falling_atom)
	return TRUE

/turf/proc/multiz_turf_del(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_DEL, T, dir)

/turf/proc/multiz_turf_new(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_NEW, T, dir)

/turf/smooth_icon()
	. = ..()
	if(SSopenspace.initialized)
		var/turf/simulated/open/above = GetAbove(src)
		if(istype(above))
			above.queue()

/**
 * called during AfterChange() to request the turfs above and below us update their graphics.
 */
/turf/proc/update_vertical_turf_graphics()
	var/turf/simulated/open/above = GetAbove(src)
	if(istype(above))
		above.queue()

	var/turf/below = GetBelow(src)
	if(below)
		// To add or remove the 'ceiling-less' overlay.
		below.update_icon()

//
// Open Space - "empty" turf that lets stuff fall thru it to the layer below
//

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	desc = "\..."
	density = 0
	plane = OPENSPACE_PLANE_START
	pathweight = 100000		// Seriously, don't try and path over this one numbnuts
	can_build_into_floor = TRUE
	allow_gas_overlays = FALSE
	z_flags = Z_AIR_UP | Z_AIR_DOWN | Z_OPEN_UP | Z_OPEN_DOWN | Z_CONSIDERED_OPEN

	var/turf/below

/turf/simulated/open/Initialize(mapload)
	. = ..()
	ASSERT(HasBelow(z))
	plane = min(OPENSPACE_PLANE_END, OPENSPACE_PLANE + src.z)
	queue()

/turf/simulated/open/Entered(var/atom/movable/mover)
	..()
	if(mover.movement_type & GROUND)
		mover.fall()

// Called when thrown object lands on this turf.
/turf/simulated/open/throw_landed(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(AM.movement_type & GROUND)
		AM.fall()

/turf/simulated/open/proc/queue()
	if(smoothing_flags & SMOOTH_QUEUED)
		return
	smoothing_flags |= SMOOTH_QUEUED
	SSopenspace.add_turf(src)

//! we hijack smoothing flags.
/turf/simulated/open/smooth_icon()
	return		// nope

/turf/simulated/open/proc/update()
	below = GetBelow(src)
	below.update_icon()	// So the 'ceiling-less' overlay gets added.
	for(var/atom/movable/A in src)
		if(A.movement_type & GROUND)
			A.fall()
	SSopenspace.add_turf(src, 1)

// Override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/examine(mob/user)
	. = ..()
	var/depth = 1
	for(var/T = GetBelow(src); isopenturf(T); T = GetBelow(T))
		depth += 1
	. += "It is about [depth] levels deep."

// todo: we either need vis conetents rendering or zmimic overlays; this is a fucked system and is really just unsalvagable.

/**
* Update icon and overlays of open space to be that of the turf below, plus any visible objects on that turf.
*/
/turf/simulated/open/update_icon()
	overlays.len = 0
	var/turf/below = GetBelow(src)
	if(below)
		var/below_is_open = isopenturf(below)

		if(below_is_open)
			underlays = below.underlays
			overlays = below.overlays
		else
			var/image/bottom_turf = image(icon = below.icon, icon_state = below.icon_state, dir=below.dir, layer=below.layer)
			bottom_turf.plane = src.plane
			bottom_turf.color = below.color
			bottom_turf.copy_overlays(below)
			bottom_turf.appearance_flags = KEEP_TOGETHER
			underlays = list(bottom_turf)

		// Get objects (not mobs, they are handled by /obj/zshadow)
		var/list/o_img = list()
		for(var/obj/O in below)
			if(O.invisibility) continue	// Ignore objects that have any form of invisibility
			if(O.loc != below) continue	// Ignore multi-turf objects not directly below
			var/image/temp2 = image(O, dir = O.dir, layer = O.layer)
			temp2.plane = src.plane
			temp2.color = O.color
			temp2.overlays += O.overlays
			// TODO Is pixelx/y needed?
			o_img += temp2
		overlays += o_img
		overlays |= /obj/effect/abstract/over_openspace_darkness
		return
	return PROCESS_KILL

/obj/effect/abstract/over_openspace_darkness
	icon = 'icons/turf/open_space.dmi'
	icon_state = "black_open"
	plane = OVER_OPENSPACE_PLANE
	layer = TURF_LAYER

// Straight copy from space.
/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>Constructing support lattice ...</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(src)
		return

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor, flags = CHANGETURF_INHERIT_AIR)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	// To lay cable.
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)

// Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return TRUE

/turf/simulated/open/is_space()
	var/turf/below = GetBelow(src)
	return !below || below.is_space()

/turf/simulated/open/is_solid_structure()
	return locate(/obj/structure/lattice, src)	// Counts as solid structure if it has a lattice (same as space)

/turf/simulated/open/is_safe_to_enter(mob/living/L)
	if(L.can_fall())
		if(!locate(/obj/structure/stairs) in GetBelow(src))
			return FALSE
	return ..()
