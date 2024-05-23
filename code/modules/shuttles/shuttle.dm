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
