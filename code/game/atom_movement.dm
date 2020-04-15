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
  *
  */
/atom/proc/CheckExit(atom/movable/AM, atom/newLoc)
	return TRUE
