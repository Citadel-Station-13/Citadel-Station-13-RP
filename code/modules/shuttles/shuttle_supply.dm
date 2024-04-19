// Formerly /datum/shuttle/autodock/ferry/supply
/datum/shuttle/autodock/ferry/supply
	var/away_location = FERRY_LOCATION_OFFSITE	// The location to hide at while pretending to be in-transit
	var/late_chance = 80
	var/max_late_time = 300
	flags = SHUTTLE_FLAGS_PROCESS|SHUTTLE_FLAGS_SUPPLY
	category = /datum/shuttle/autodock/ferry/supply

/datum/shuttle/autodock/ferry/supply/short_jump(var/obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(isnull(location))
		return

	// Set the supply shuttle displays to read out the ETA
	var/datum/signal/S = new()
	S.source = src
	S.data = list("command" = "supply")
	var/datum/radio_frequency/F = radio_controller.return_frequency(1435)
	F.post_signal(src, S)

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)

		make_sounds(HYPERSPACE_WARMUP)
		sleep(5 SECONDS)	// So the sound finishes.

		if (moving_status == SHUTTLE_IDLE)
			make_sounds(HYPERSPACE_END)
			return	// Someone cancelled the launch

		if (at_station() && forbidden_atoms_check())
			// Cancel the launch because of forbidden atoms. announce over supply channel?
			moving_status = SHUTTLE_IDLE
			make_sounds(HYPERSPACE_END)
			return

		if (!at_station())	// At centcom
			SSsupply.buy()

		// We pretend it's a long_jump by making the shuttle stay at centcom for the "in-transit" period.
		var/obj/effect/shuttle_landmark/away_waypoint = get_location_waypoint(away_location)
		moving_status = SHUTTLE_INTRANSIT

		// If we are at the away_landmark then we are just pretending to move, otherwise actually do the move
		if (next_location == away_waypoint)
			attempt_move(away_waypoint)

		// Wait ETA here.
		arrive_time = world.time + SSsupply.movetime
		while (world.time <= arrive_time)
			sleep(5)

		if (next_location != away_waypoint)
			// Late
			if (prob(late_chance))
				sleep(rand(0,max_late_time))

			attempt_move(destination)

		moving_status = SHUTTLE_IDLE
		make_sounds(HYPERSPACE_END)

		if (!at_station())	// At centcom
			SSsupply.sell()

/datum/shuttle/autodock/ferry/supply/proc/at_station()
	return (!location)

// Returns 1 if the shuttle is idle and we can still mess with the cargo shopping list
/datum/shuttle/autodock/ferry/supply/proc/idle()
	return (moving_status == SHUTTLE_IDLE)

// Returns the ETA in minutes
/datum/shuttle/autodock/ferry/supply/proc/eta_minutes()
	return round((arrive_time - world.time) / (1 MINUTE), 1) // Floor, so it's an actual timer

// returns the ETA in seconds
/datum/shuttle/autodock/ferry/supply/proc/eta_seconds()
	return round((arrive_time - world.time) / (1 SECOND)) // Floor, so it's an actual timer
