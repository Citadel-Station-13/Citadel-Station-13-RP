/*
	output_atoms	(list of atoms)			The destination(s) for the sounds

	mid_sounds		(list or soundfile)		Since this can be either a list or a single soundfile you can have random sounds. May contain further lists but must contain a soundfile at the end.
	mid_length		(num)					The length to wait between playing mid_sounds

	start_sound		(soundfile)				Played before starting the mid_sounds loop
	start_length	(num)					How long to wait before starting the main loop after playing start_sound

	end_sound		(soundfile)				The sound played after the main loop has concluded

	chance			(num)					Chance per loop to play a mid_sound
	volume			(num)					Sound output volume
	muted			(bool)					Private. Used to stop the sound loop.
	max_loops		(num)					The max amount of loops to run for.
	direct			(bool)					If true plays directly to provided atoms instead of from them
	opacity_check	(bool)					If true, things behind walls/opaque things won't hear the sounds.
	pref_check		(type)					If set to a /datum/client_preference type, will check if the hearer has that preference active before playing it to them.
*/
/datum/looping_sound
	var/list/atom/output_atoms
	var/mid_sounds
	var/mid_length
	///Override for volume of start sound
	var/start_volume
	var/start_sound
	var/start_length
	///Override for volume of end sound
	var/end_volume
	var/end_sound
	var/chance
	var/volume = 100
	var/vary = FALSE
	var/max_loops
	var/direct
	var/extra_range = 0
	var/opacity_check
	var/pref_check
	var/soundenvdry
	var/soundenvwet

	var/timerid
	var/skip_starting_sounds = FALSE
	var/loop_started = FALSE

/datum/looping_sound/New(list/_output_atoms=list(), start_immediately=FALSE, _direct=FALSE, _skip_starting_sounds = FALSE)
	if(!mid_sounds)
		WARNING("A looping sound datum was created without sounds to play.")
		return

	// TODO: this should keep track of atoms and null them if they get qdeled!!!
	if(isatom(_output_atoms))
		_output_atoms = list(_output_atoms)
	output_atoms = _output_atoms
	direct = _direct
	skip_starting_sounds = _skip_starting_sounds

	if(start_immediately)
		start()

/datum/looping_sound/Destroy()
	stop()
	output_atoms = null
	return ..()

/datum/looping_sound/proc/start(atom/add_thing)
	if(add_thing)
		output_atoms |= add_thing
	if(timerid)
		return
	on_start()

/datum/looping_sound/proc/stop(atom/remove_thing)
	if(remove_thing)
		output_atoms -= remove_thing
	if(!timerid)
		return
	on_stop()
	deltimer(timerid)
	timerid = null
	loop_started = FALSE

/datum/looping_sound/proc/sound_loop(starttime)
	loop_started = TRUE
	if(max_loops && (world.time >= (starttime + mid_length * max_loops)))
		stop()
		return
	if(!chance || prob(chance))
		play(get_sound(starttime))
	if(!timerid)
		timerid = addtimer(CALLBACK(src, PROC_REF(sound_loop), world.time), mid_length, TIMER_CLIENT_TIME | TIMER_STOPPABLE | TIMER_LOOP | TIMER_DELETE_ME)

/datum/looping_sound/proc/play(soundfile, volume_override)
	var/list/atoms_cache = output_atoms
	var/sound/S = sound(soundfile)
	if(direct)
		S.channel = SSsounds.random_available_channel()
		S.volume = volume_override || volume //Use volume as fallback if theres no override
	for(var/i in 1 to atoms_cache.len)
		var/atom/thing = atoms_cache[i]
		if(direct)
			if(ismob(thing))
				var/mob/M = thing
				if(!M.is_preference_enabled(pref_check))
					continue
			SEND_SOUND(thing, S)
		else
			playsound(thing, S, volume, vary, extra_range, ignore_walls = !opacity_check, preference = pref_check)

/datum/looping_sound/proc/get_sound(starttime, _mid_sounds)
	. = _mid_sounds || mid_sounds
	while(!isfile(.) && !isnull(.))
		. = pickweight(.)

/datum/looping_sound/proc/on_start()
	var/start_wait = 0 // surely the issue is fixed now, timerid is referenced
	if(start_sound && !skip_starting_sounds)
		play(start_sound, start_volume)
		start_wait = start_length
	timerid = addtimer(CALLBACK(src, PROC_REF(sound_loop)), start_wait, TIMER_CLIENT_TIME | TIMER_DELETE_ME | TIMER_STOPPABLE)

/datum/looping_sound/proc/on_stop()
	if(end_sound && loop_started)
		play(end_sound)
