GLOBAL_VAR_INIT(sound_extrarange_multiplier, 3)
GLOBAL_VAR_INIT(sound_env_wet, -1500)
GLOBAL_VAR_INIT(sound_env_dry, 0)

/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, is_global, frequency = null, channel = 0, pressure_affected = TRUE, ignore_walls = TRUE, preference = null, soundenvwet, soundenvdry)
	if(isnull(soundenvwet))
		soundenvwet = GLOB.sound_env_wet
	if(isnull(soundenvdry))
		soundenvdry = GLOB.sound_env_dry

	if(isarea(source))
		CRASH("playsound(): source is an area")

	var/turf/turf_source = get_turf(source)

	if (!turf_source)
		return

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	// Looping through the player list has the added bonus of working for mobs inside containers
	var/sound/S = sound(get_sfx(soundin))
	var/maxdistance = (world.view + extrarange) * GLOB.sound_extrarange_multiplier
	var/z = turf_source.z
	var/list/listeners = player_list		//SSmobs.clients_by_zlevel[z]
	if(!ignore_walls) //these sounds don't carry through walls
		listeners = listeners & hearers(maxdistance,turf_source)
	for(var/P in listeners)
		var/mob/M = P
		if(get_dist(M, turf_source) <= maxdistance)
			var/turf/MT = get_turf(M)
			if(z == MT?.z)
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, channel, pressure_affected, S, preference, soundenvwet, soundenvdry)
	/*
	for(var/P in SSmobs.dead_players_by_zlevel[z])
		var/mob/M = P
		if(get_dist(M, turf_source) <= maxdistance)
			M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, channel, pressure_affected, S, preference, soundenvwet, soundenvdry)
	*/

GLOBAL_VAR_INIT(sound_default_environment, 7)
GLOBAL_VAR_INIT(sound_pressure_echo, TRUE)
GLOBAL_VAR_INIT(sound_pressure_environment, FALSE)
GLOBAL_VAR_INIT(sound_offscreen_falloff_factor, 5)
GLOBAL_VAR_INIT(sound_distance_offscreen, 7)

/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, is_global, channel = 0, pressure_affected = TRUE, sound/S, preference, envwet, envdry, manual_x, manual_y, distance_multiplier = 1)
	if(isnull(envwet))
		envwet = GLOB.sound_env_wet
	if(isnull(envdry))
		envdry = GLOB.sound_env_dry
	/*
	if(audiovisual_redirect)
		var/turf/T = get_turf(src)
		audiovisual_redirect.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, channel, pressure_affected, S, 0, -1000, turf_source.x - T.x, turf_source.y - T.y, distance_multiplier)
	*/

/*
	if(!client || !can_hear())
		return
*/

	if(!client || ear_deaf > 0)
		return

	if(preference && !client.is_preference_enabled(preference))
		return

	if(!S)
		S = sound(get_sfx(soundin))

	S.wait = 0 //No queue
	S.channel = channel || SSsounds.random_available_channel()
	S.volume = vol
	// TG EDIT
	S.environment = GLOB.sound_default_environment
	//////////

	if(vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	if(isturf(turf_source))
		var/turf/T = get_turf(src)

		//sound volume falloff with distance
		var/distance = 0
		if(!manual_x && !manual_y)
			distance = get_dist(T, turf_source)

		distance *= distance_multiplier

		// Extra falloff if sound is offscreen from world's default view.
		S.volume *= (1 - CLAMP(((max(distance - GLOB.sound_distance_offscreen, 0) * GLOB.sound_offscreen_falloff_factor)/100), 0, 1))

		var/pressure_factor = 1
		if(pressure_affected)
			//Atmosphere affects sound
			var/datum/gas_mixture_old/hearer_env = T.return_air()
			var/datum/gas_mixture_old/source_env = turf_source.return_air()

			if(hearer_env && source_env)
				var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
				if(pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //space
				pressure_factor = 0

			// TG edit
			if(GLOB.sound_pressure_echo)
				S.echo = list(envdry, null, envwet, null, null, null, null, null, null, null, null, null, null, 1, 1, 1, null, null)
			//////////

			if(distance <= 1)
				pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

			S.volume *= pressure_factor
			//End Atmosphere affecting sound

		//Apply a sound environment.
		if(!is_global && GLOB.sound_pressure_environment)
			S.environment = get_sound_env(pressure_factor)

		if(S.volume <= 0)
			return //No sound

		var/dx = 0 // Hearing from the right/left
		if(!manual_x)
			dx = turf_source.x - T.x
		else
			dx = manual_x
		S.x = dx * distance_multiplier
		var/dz = 0 // Hearing from infront/behind
		if(!manual_x)
			dz = turf_source.y - T.y
		else
			dz = manual_y
		S.z = dz * distance_multiplier
		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		// No multiz support.. yet!
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	SEND_SOUND(src, S)

/proc/sound_to_playing_players(sound, volume = 100, vary)
	sound = get_sfx(sound)
	for(var/M in player_list)
		if(ismob(M) && !isnewplayer(M))
			var/mob/MO = M
			MO.playsound_local(get_turf(MO), sound, volume, vary, pressure_affected = FALSE)

/mob/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/client/proc/playtitlemusic()
	if(!SSticker || !all_lobby_tracks.len || !media)	return
	if(is_preference_enabled(/datum/client_preference/play_lobby_music))
		var/datum/track/T = pick(all_lobby_tracks)
		media.push_music(T.url, world.time, 0.85)
		to_chat(src,"<span class='notice'>Lobby music: <b>[T.title]</b> by <b>[T.artist]</b>.</span>")

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if ("explosion") soundin = pick('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg','sound/effects/Explosion3.ogg','sound/effects/Explosion4.ogg','sound/effects/Explosion5.ogg','sound/effects/Explosion6.ogg')
			if ("sparks") soundin = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks5.ogg','sound/effects/sparks6.ogg','sound/effects/sparks7.ogg')
			if ("rustle") soundin = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if ("punch") soundin = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
			if ("clownstep") soundin = pick('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
			if ("swing_hit") soundin = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if ("hiss") soundin = pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if ("pageturn") soundin = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if ("fracture") soundin = pick('sound/effects/bonebreak1.ogg','sound/effects/bonebreak2.ogg','sound/effects/bonebreak3.ogg','sound/effects/bonebreak4.ogg')
			if ("canopen") soundin = pick('sound/effects/can_open1.ogg','sound/effects/can_open2.ogg','sound/effects/can_open3.ogg','sound/effects/can_open4.ogg')
			if ("mechstep") soundin = pick('sound/mecha/mechstep1.ogg', 'sound/mecha/mechstep2.ogg')
			if ("thunder") soundin = pick('sound/effects/thunder/thunder1.ogg', 'sound/effects/thunder/thunder2.ogg', 'sound/effects/thunder/thunder3.ogg', 'sound/effects/thunder/thunder4.ogg',
			'sound/effects/thunder/thunder5.ogg', 'sound/effects/thunder/thunder6.ogg', 'sound/effects/thunder/thunder7.ogg', 'sound/effects/thunder/thunder8.ogg', 'sound/effects/thunder/thunder9.ogg',
			'sound/effects/thunder/thunder10.ogg')
			if ("keyboard") soundin = pick('sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg','sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg')
			if ("button") soundin = pick('sound/machines/button1.ogg','sound/machines/button2.ogg','sound/machines/button3.ogg','sound/machines/button4.ogg')
			if ("switch") soundin = pick('sound/machines/switch1.ogg','sound/machines/switch2.ogg','sound/machines/switch3.ogg','sound/machines/switch4.ogg')
			if ("casing_sound") soundin = pick('sound/weapons/casingfall1.ogg','sound/weapons/casingfall2.ogg','sound/weapons/casingfall3.ogg')
			//VORESTATION EDIT - vore sounds for better performance
			if ("hunger_sounds") soundin = pick('sound/vore/growl1.ogg','sound/vore/growl2.ogg','sound/vore/growl3.ogg','sound/vore/growl4.ogg','sound/vore/growl5.ogg')

			if("classic_digestion_sounds") soundin = pick(
					'sound/vore/digest1.ogg','sound/vore/digest2.ogg','sound/vore/digest3.ogg','sound/vore/digest4.ogg',
					'sound/vore/digest5.ogg','sound/vore/digest6.ogg','sound/vore/digest7.ogg','sound/vore/digest8.ogg',
					'sound/vore/digest9.ogg','sound/vore/digest10.ogg','sound/vore/digest11.ogg','sound/vore/digest12.ogg')
			if("classic_death_sounds") soundin = pick(
					'sound/vore/death1.ogg','sound/vore/death2.ogg','sound/vore/death3.ogg','sound/vore/death4.ogg','sound/vore/death5.ogg',
					'sound/vore/death6.ogg','sound/vore/death7.ogg','sound/vore/death8.ogg','sound/vore/death9.ogg','sound/vore/death10.ogg')
			if("classic_struggle_sounds") soundin = pick('sound/vore/squish1.ogg','sound/vore/squish2.ogg','sound/vore/squish3.ogg','sound/vore/squish4.ogg')

			if("fancy_prey_struggle") soundin = pick(
					'sound/vore/sunesound/prey/struggle_01.ogg','sound/vore/sunesound/prey/struggle_02.ogg','sound/vore/sunesound/prey/struggle_03.ogg',
					'sound/vore/sunesound/prey/struggle_04.ogg','sound/vore/sunesound/prey/struggle_05.ogg')
			if("fancy_digest_pred") soundin = pick(
					'sound/vore/sunesound/pred/digest_01.ogg','sound/vore/sunesound/pred/digest_02.ogg','sound/vore/sunesound/pred/digest_03.ogg',
					'sound/vore/sunesound/pred/digest_04.ogg','sound/vore/sunesound/pred/digest_05.ogg','sound/vore/sunesound/pred/digest_06.ogg',
					'sound/vore/sunesound/pred/digest_07.ogg','sound/vore/sunesound/pred/digest_08.ogg','sound/vore/sunesound/pred/digest_09.ogg',
					'sound/vore/sunesound/pred/digest_10.ogg','sound/vore/sunesound/pred/digest_11.ogg','sound/vore/sunesound/pred/digest_12.ogg',
					'sound/vore/sunesound/pred/digest_13.ogg','sound/vore/sunesound/pred/digest_14.ogg','sound/vore/sunesound/pred/digest_15.ogg',
					'sound/vore/sunesound/pred/digest_16.ogg','sound/vore/sunesound/pred/digest_17.ogg','sound/vore/sunesound/pred/digest_18.ogg')
			if("fancy_death_pred") soundin = pick(
					'sound/vore/sunesound/pred/death_01.ogg','sound/vore/sunesound/pred/death_02.ogg','sound/vore/sunesound/pred/death_03.ogg',
					'sound/vore/sunesound/pred/death_04.ogg','sound/vore/sunesound/pred/death_05.ogg','sound/vore/sunesound/pred/death_06.ogg',
					'sound/vore/sunesound/pred/death_07.ogg','sound/vore/sunesound/pred/death_08.ogg','sound/vore/sunesound/pred/death_09.ogg',
					'sound/vore/sunesound/pred/death_10.ogg')
			if("fancy_digest_prey") soundin = pick(
					'sound/vore/sunesound/prey/digest_01.ogg','sound/vore/sunesound/prey/digest_02.ogg','sound/vore/sunesound/prey/digest_03.ogg',
					'sound/vore/sunesound/prey/digest_04.ogg','sound/vore/sunesound/prey/digest_05.ogg','sound/vore/sunesound/prey/digest_06.ogg',
					'sound/vore/sunesound/prey/digest_07.ogg','sound/vore/sunesound/prey/digest_08.ogg','sound/vore/sunesound/prey/digest_09.ogg',
					'sound/vore/sunesound/prey/digest_10.ogg','sound/vore/sunesound/prey/digest_11.ogg','sound/vore/sunesound/prey/digest_12.ogg',
					'sound/vore/sunesound/prey/digest_13.ogg','sound/vore/sunesound/prey/digest_14.ogg','sound/vore/sunesound/prey/digest_15.ogg',
					'sound/vore/sunesound/prey/digest_16.ogg','sound/vore/sunesound/prey/digest_17.ogg','sound/vore/sunesound/prey/digest_18.ogg')
			if("fancy_death_prey") soundin = pick(
					'sound/vore/sunesound/prey/death_01.ogg','sound/vore/sunesound/prey/death_02.ogg','sound/vore/sunesound/prey/death_03.ogg',
					'sound/vore/sunesound/prey/death_04.ogg','sound/vore/sunesound/prey/death_05.ogg','sound/vore/sunesound/prey/death_06.ogg',
					'sound/vore/sunesound/prey/death_07.ogg','sound/vore/sunesound/prey/death_08.ogg','sound/vore/sunesound/prey/death_09.ogg',
					'sound/vore/sunesound/prey/death_10.ogg')
			//END VORESTATION EDIT
	return soundin

//Are these even used?
var/list/keyboard_sound = list ('sound/effects/keyboard/keyboard1.ogg','sound/effects/keyboard/keyboard2.ogg','sound/effects/keyboard/keyboard3.ogg', 'sound/effects/keyboard/keyboard4.ogg')
var/list/bodyfall_sound = list('sound/effects/bodyfall1.ogg','sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg')
