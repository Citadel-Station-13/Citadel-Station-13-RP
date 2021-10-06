/**
  * Call back when an atom enters an area
  *
  * Sends signals COMSIG_AREA_ENTERED and COMSIG_ENTER_AREA (to the atom)
  *
  * If the area has ambience, then it plays some ambience music to the ambience channel
  */
/area/Entered(atom/movable/M)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, M)
	SEND_SIGNAL(M, COMSIG_ENTER_AREA, src) //The atom that enters the area
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

/*
	// Ambience goes down here -- make sure to list each area separately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(L.client && !L.client.ambience_playing && L.client.prefs.toggles & SOUND_SHIP_AMBIENCE)
		L.client.ambience_playing = 1
		SEND_SOUND(L, sound('sound/ambience/shipambience.ogg', repeat = 1, wait = 0, volume = 35, channel = CHANNEL_BUZZ))

	if(!(L.client && (L.client.prefs.toggles & SOUND_AMBIENCE)))
		return //General ambience check is below the ship ambience so one can play without the other

	if(prob(35))
		var/sound = pick(ambientsounds)

		if(!L.client.played)
			SEND_SOUND(L, sound(sound, repeat = 0, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))
			L.client.played = TRUE
			addtimer(CALLBACK(L.client, /client/proc/ResetAmbiencePlayed), 600)
*/

/**
  * Called when an atom exits an area
  *
  * Sends signals COMSIG_AREA_EXITED and COMSIG_EXIT_AREA (to the atom)
  */
/area/Exited(atom/movable/M)
	SEND_SIGNAL(src, COMSIG_AREA_EXITED, M)
	SEND_SIGNAL(M, COMSIG_EXIT_AREA, src) //The atom that exits the area

