/**
  * An atom has entered this atom's contents
  *
  * Default behaviour is to send the [COMSIG_ATOM_ENTERED]
  */
/atom/Entered(atom/movable/AM, atom/oldLoc)
	SEND_SIGNAL(src, COMSIG_ATOM_ENTERED, AM, oldLoc)

/**
  * An atom is attempting to exit this atom's contents
  *
  * Default behaviour is to send the [COMSIG_ATOM_EXIT]
  *
  * Return value should be set to FALSE if the moving atom is unable to leave,
  * otherwise leave value the result of the parent call
  */
/atom/Exit(atom/movable/AM, atom/newLoc)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_ATOM_EXIT, AM, newLoc) & COMPONENT_ATOM_BLOCK_EXIT)
		return FALSE

/**
  * An atom has exited this atom's contents
  *
  * Default behaviour is to send the [COMSIG_ATOM_EXITED]
  */
/atom/Exited(atom/movable/AM, atom/newLoc)
	SEND_SIGNAL(src, COMSIG_ATOM_EXITED, AM, newLoc)

/**
  * Check if an atom can exit us in movement.
  */
/atom/proc/CheckExit(atom/movable/AM, atom/newLoc)
	return TRUE

///Can the mover object pass this atom, while heading for the target turf
/atom/proc/CanPass(atom/movable/mover, turf/target)
	// SHOULD_NOT_OVERRIDE(TRUE)
	// SHOULD_BE_PURE(TRUE)
	// SHOULD_CALL_PARENT(TRUE)
	if(mover.movement_type & UNSTOPPABLE)
		return TRUE
	. = CanAllowThrough(mover, target)
	// This is cheaper than calling the proc every time since most things dont override CanPassThrough
	if(!mover.generic_canpass)
		return mover.CanPassThrough(src, target, .)

/// Returns true or false to allow the mover to move through src
/atom/proc/CanAllowThrough(atom/movable/mover, turf/target)
	// SHOULD_CALL_PARENT(TRUE)
	// SHOULD_BE_PURE(TRUE)
	if(mover.pass_flags & pass_flags_self)
		return TRUE
	// the && makes sure the expensive checks don't run most of the time
	if(mover.throwing && ((pass_flags_self & ATOM_PASS_THROWN) || !mover.throwing.can_hit(src, TRUE)))
		return TRUE
	return !density

/**
 * for regexing
 */
/atom/proc/check_pass_flags_self(flags)
	return pass_flags_self & flags

/**
 * checks if a movable atom should ignore us because of a pass flag match
 */
/atom/proc/check_standard_flag_pass(atom/movable/AM)
	if(pass_flags_self & AM.pass_flags)
		return TRUE
	if(AM.throwing && (pass_flags_self & ATOM_PASS_THROWN))
		return TRUE
	return FALSE
