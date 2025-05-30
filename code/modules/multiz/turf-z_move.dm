//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/turf/z_pass_in(atom/movable/AM, dir, turf/old_loc)
	return isnull(z_pass_in_obstruction(AM, dir, old_loc))

/turf/z_pass_out(atom/movable/AM, dir, turf/new_loc)
	return isnull(z_pass_out_obstruction(AM, dir, new_loc))

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
	if(!(mz_flags & (dir == UP? MZ_OPEN_UP : MZ_OPEN_DOWN)))
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
	if(!(mz_flags & (dir == UP? MZ_OPEN_UP : MZ_OPEN_DOWN)))
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
		dest = above()
		return dest && (z_pass_out_obstruction(mover, UP, dest) || dest.z_pass_in_obstruction(mover, DOWN, src))
	else if(dir == DOWN)
		dest = below()
		return dest && (z_pass_out_obstruction(mover, DOWN, dest) || dest.z_pass_in_obstruction(mover, UP, src))
	CRASH("Non-vertical direction '[dir]' passed in.")
