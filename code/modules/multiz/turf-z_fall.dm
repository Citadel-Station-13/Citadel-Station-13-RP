//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

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
		dest = above()
		return dest && !z_pass_out_obstruction(mover, UP, dest) && !dest.z_pass_in_obstruction(mover, DOWN, src)
	else if(dir == DOWN)
		dest = below()
		return dest && !z_pass_out_obstruction(mover, DOWN, dest) && !dest.z_pass_in_obstruction(mover, UP, src)
	CRASH("Non-vertical direction '[dir]' passed in.")

/**
 * checks what is going to block something from falling through us
 */
/turf/proc/z_fall_obstruction(atom/movable/mover, levels, fall_flags)
	for(var/atom/movable/AM as anything in contents)
		if(AM.prevent_z_fall(mover, levels, fall_flags))
			return AM

/**
 * simple boolean check to see if something's physically blocked from falling through us
 *
 * * checked in addition to z_exit_check.
 */
/turf/proc/z_fall_check(atom/movable/mover, levels, fall_flags)
	if(!(mz_flags & MZ_OPEN_DOWN))
		return FALSE
	return isnull(z_fall_obstruction(mover, levels, fall_flags))
