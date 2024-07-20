/**
 * Call back when an atom enters an area
 *
 * Sends signals COMSIG_AREA_ENTERED (to the area) and COMSIG_ATOM_ENTER_AREA (to the atom)
 *
 * If the area has ambience, then it plays some ambience music to the ambience channel
 */
/area/Entered(atom/movable/M)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, M)
	SEND_SIGNAL(M, COMSIG_ATOM_ENTER_AREA, src) //The atom that enters the area
	if(!isliving(M))
		return

	var/mob/living/L = M
	if(!L.ckey)
		return

	if(!L.lastarea)
		L.lastarea = get_area(L.loc)
	var/area/newarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if((oldarea.has_gravity == 0) && (newarea.has_gravity == 1) && (L.m_intent == "run")) // Being ready when you change areas gives you a chance to avoid falling all together.
		thunk(L)
		L.update_floating( L.Check_Dense_Object() )

	L.lastarea = newarea
	play_ambience(L)

/**
  * Called when an atom exits an area
  *
  * Sends signals COMSIG_AREA_EXITED and COMSIG_ATOM_EXIT_AREA (to the atom)
  */
/area/Exited(atom/movable/M)
	SEND_SIGNAL(src, COMSIG_AREA_EXITED, M)
	SEND_SIGNAL(M, COMSIG_ATOM_EXIT_AREA, src) //The atom that exits the area
