
// This creates a graphical warning to where the shuttle is about to land, in approximately five seconds.
/datum/shuttle/proc/create_warning_effect(var/obj/effect/shuttle_landmark/destination)
	destination.create_warning_effect(src)

/datum/shuttle/proc/short_jump(var/obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(!pre_warmup_checks())
		return

	var/obj/effect/shuttle_landmark/start_location = current_location
	// TODO - Figure out exactly when to play sounds.  Before warmup_time delay? Should there be a sleep for waiting for sounds? or no?
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(HYPERSPACE_WARMUP)
		create_warning_effect(destination)
		sleep(5 SECONDS)	// So the sound finishes.

		if(!post_warmup_checks())
			cancel_launch(null)

		if(!fuel_check())	//Fuel error (probably out of fuel) occured, so cancel the launch
			cancel_launch(null)

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(HYPERSPACE_END)
			return	// Someone cancelled the launch

		moving_status = SHUTTLE_INTRANSIT	// Shouldn't matter but just to be safe
		on_shuttle_departure(start_location, destination)

		attempt_move(destination)

		moving_status = SHUTTLE_IDLE
		on_shuttle_arrival(start_location, destination)

		make_sounds(HYPERSPACE_END)

// TODO - Far Future - Would be great if this was driven by process too.
/datum/shuttle/proc/long_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	//TO_WORLD("shuttle/long_jump: current_location=[current_location], destination=[destination], interim=[interim], travel_time=[travel_time]")
	if(moving_status != SHUTTLE_IDLE)
		return

	if(!pre_warmup_checks())
		return

	var/obj/effect/shuttle_landmark/start_location = current_location
	// TODO - Figure out exactly when to play sounds.  Before warmup_time delay? Should there be a sleep for waiting for sounds? or no?
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(HYPERSPACE_WARMUP)
		create_warning_effect(interim)	// Really doubt someone is gonna get crushed in the interim area but for completeness's sake we'll make the warning.
		sleep(5 SECONDS)	// So the sound finishes.

		if(!post_warmup_checks())
			cancel_launch(null)

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(HYPERSPACE_END)
			return	// Someone cancelled the launch

		arrive_time = world.time + travel_time*10
		depart_time = world.time

		moving_status = SHUTTLE_INTRANSIT
		on_shuttle_departure(start_location, destination)

		if(attempt_move(interim, TRUE))
			interim.shuttle_arrived()

			if(process_longjump(current_location, destination))	//To hook custom shuttle code in
				return	//It handled it for us (shuttle crash or such)

			var/last_progress_sound = 0
			var/made_warning = FALSE
			while (world.time < arrive_time)
				// Make the shuttle make sounds every four seconds, since the sound file is five seconds.
				if(last_progress_sound + 4 SECONDS < world.time)
					make_sounds(HYPERSPACE_PROGRESS)
					last_progress_sound = world.time

				if(arrive_time - world.time <= 5 SECONDS && !made_warning)
					made_warning = TRUE
					create_warning_effect(destination)
				sleep(5)

			if(!attempt_move(destination))
				attempt_move(start_location)	// Try to go back to where we started.  If that fails, I guess we're stuck in the interim location.

		moving_status = SHUTTLE_IDLE
		on_shuttle_arrival(start_location, destination)
		make_sounds(HYPERSPACE_END)

/*****************
* Shuttle Moved Handling	* (Observer Pattern Implementation: Shuttle Moved)
* Shuttle Pre Move Handling	* (Observer Pattern Implementation: Shuttle Pre Move)
*****************/

// Just moves the shuttle from A to B
// A note to anyone overriding move in a subtype. perform_shuttle_move() must absolutely not, under any circumstances, fail to move the shuttle.
// If you want to conditionally cancel shuttle launches, that logic must go in short_jump() or long_jump()
/datum/shuttle/proc/perform_shuttle_move(var/obj/effect/shuttle_landmark/destination, var/list/turf_translation)

	// TODO - Old code used to throw stuff out of the way instead of squashing.  Should we?

	// Move, gib, or delete everything in our way!
	for(var/turf/src_turf in turf_translation)
		var/turf/dst_turf = turf_translation[src_turf]
		if(src_turf.is_solid_structure())	// In case someone put a hole in the shuttle and you were lucky enough to be under it
			for(var/atom/movable/AM in dst_turf)
				//if(AM.movable_flags & MOVABLE_FLAG_DEL_SHUTTLE)
				//	qdel(AM)
				//	continue
				if((AM.atom_flags & ATOM_ABSTRACT))
					continue
				if(isliving(AM))
					var/mob/living/bug = AM
					bug.gib()
				else if(isobj(AM))
					qdel(AM) //it just gets atomized I guess? TODO throw it into space somewhere, prevents people from using shuttles as an atom-smasher

	for(var/area/A in shuttle_area)
		if(knockdown)
			for(var/mob/living/M in A)
				spawn(0)
					if(M.buckled)
						to_chat(M, "<font color='red'>Sudden acceleration presses you into \the [M.buckled]!</font>")
						shake_camera(M, 3, 1)
					else
						to_chat(M, "<font color='red'>The floor lurches beneath you!</font>")
						shake_camera(M, 10, 1)
						// TODO - tossing?
						if(istype(M, /mob/living/carbon))
							M.afflict_paralyze(20 * 3)
							if(move_direction)
								throw_a_mob(M,move_direction)
		// We only need to rebuild powernets for our cables.  No need to check machines because they are on top of cables.
		for(var/obj/structure/cable/C in A)
			powernets |= C.powernet

/datum/shuttle/proc/make_sounds(var/sound_type)
	var/sound_to_play = null
	switch(sound_type)
		if(HYPERSPACE_WARMUP)
			sound_to_play = 'sound/effects/shuttles/hyperspace_begin.ogg'
		if(HYPERSPACE_PROGRESS)
			sound_to_play = 'sound/effects/shuttles/hyperspace_progress.ogg'
		if(HYPERSPACE_END)
			sound_to_play = 'sound/effects/shuttles/hyperspace_end.ogg'
	for(var/area/A in shuttle_area)
		for(var/obj/machinery/door/E in A)	// Dumb, I know, but playing it on the engines doesn't do it justice
			playsound(E, sound_to_play, 50, FALSE)

/datum/shuttle/proc/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return current_location.name
