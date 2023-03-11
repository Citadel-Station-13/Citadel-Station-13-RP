/datum/weather_holder
	/// The temperature to set planetary walls to.
	var/temperature = T20C
	/// The direction the wind is blowing. Moving against the wind slows you down, while moving with it speeds you up.
	var/wind_dir = 0
	/// How fast or slow a mob can be due to wind acting on them.
	var/wind_speed = 0
	/// Assoc list of weather identifiers, containing the actual weather datum.
	var/list/allowed_weather_types = list()
	/// Assoc list of weather identifiers and their odds of being picked to happen at roundstart.
	var/list/roundstart_weather_chances = list()
	/// world.time when the weather subsystem will advance the forecast.
	var/next_weather_shift = null
	/// A list of what the weather will be in the future. This allows it to be pre-determined and planned around.
	var/list/forecast = list()

	// Holds the weather icon, using vis_contents. Documentation says an /atom/movable is required for placing inside another atom's vis_contents.
	var/atom/movable/weather_visuals/visuals = null
	var/atom/movable/weather_visuals/special/special_visuals = null


/datum/weather_holder/New(source)
	..()
	visuals = new()
	special_visuals = new()


/datum/weather_holder/proc/change_weather(new_weather)
	var/old_light_modifier = null
	var/datum/weather/old_weather = null
	if(current_weather)
		// We store the old one, so we can determine if recalculating the sun is needed.
		old_light_modifier = current_weather.light_modifier
		old_weather = current_weather
	current_weather = allowed_weather_types[new_weather]
	if(!current_weather)
		current_weather = old_weather
		// todo: actually unit test this because rp devs fucked it up royally and we can have unknown types!
	next_weather_shift = world.time + rand(current_weather.timer_low_bound, current_weather.timer_high_bound) MINUTES
	if(new_weather != old_weather)
		// At roundstart this is null.
		if(istype(old_weather))
			// Ensure that people who should hear the ending sound will hear it.
			old_weather.process_sounds()
			old_weather.stop_sounds()

		// Same story, make sure the starting sound is heard.
		current_weather.process_sounds()
		current_weather.start_sounds()
		show_transition_message()

	update_icon_effects()
	update_temperature()
	update_wind()

	// Updating the sun should be done sparingly.
	if(old_light_modifier && current_weather.light_modifier != old_light_modifier)
		our_planet.update_sun()
	log_debug(SPAN_DEBUGINFO("[our_planet.name]'s weather is now [new_weather], with a temperature of [temperature]&deg;K ([temperature - T0C]&deg;C | [temperature * 1.8 - 459.67]&deg;F)."))


/datum/weather_holder/process(delta_time)
	if(world.time >= next_weather_shift)
		// Roundstart (hopefully).
		if(!current_weather)
			initialize_weather()
		else
			advance_forecast()
	else
		current_weather.process_effects()
		current_weather.process_sounds()


// Should only have to be called once.
/datum/weather_holder/proc/initialize_weather()
	if(!current_weather)
		change_weather(get_next_weather())
		build_forecast()


/**
 * Used to determine what the weather will be soon, in a semi-random fashion.
 * The forecast is made by calling this repeatively, from the bottom (highest index) of the forecast list.
 */
/datum/weather_holder/proc/get_next_weather(datum/weather/W)
	// At roundstart, choose a suitable initial weather.
	if(!current_weather)
		return pickweight(roundstart_weather_chances)
	return pickweight(W?.transition_chances)


/datum/weather_holder/proc/advance_forecast()
	var/new_weather = forecast[1]
	// Remove what we just took out, shortening the list.
	forecast.Cut(1, 2)
	change_weather(new_weather)
	// To fill the forecast to the desired length.
	build_forecast()


/**
 * Creates a list of future weather shifts, that the planet will undergo at some point in the future.
 * Determining it ahead of time allows for attentive players to plan further ahead, if they can see the forecast.
 */
/datum/weather_holder/proc/build_forecast()
	var/desired_length = 3
	if(forecast.len >= desired_length)
		return

	while(forecast.len < desired_length)
		// If the forecast is empty, the current_weather is used as a base instead.
		if(!forecast.len)
			forecast += get_next_weather(current_weather)
		else
			/// Go to the bottom of the list.
			var/position = forecast[forecast.len]
			/// Get the actual datum and not a string.
			var/datum/weather/W = allowed_weather_types[position]
			/// Get a suitable weather pattern to shift to from this one.
			var/new_weather = get_next_weather(W)
			forecast += new_weather
	log_debug(SPAN_DEBUGINFO("[our_planet.name]'s weather forecast is now '[english_list(forecast, and_text = " then ", final_comma_text = ", ")]'."))


/**
 * Wipes the forecast and regenerates it.
 * Used for when the weather is forcefully changed, such as with admin verbs.
 */
/datum/weather_holder/proc/rebuild_forecast()
	forecast.Cut()
	build_forecast()


/datum/weather_holder/proc/update_icon_effects()
	if(current_weather.icon)
		visuals.icon = current_weather.icon
	visuals.icon_state = current_weather.icon_state


/datum/weather_holder/proc/update_temperature()
	temperature = LERP(current_weather.temp_low, current_weather.temp_high, our_planet.sun_position)
	our_planet.needs_work |= PLANET_PROCESS_TEMP


/datum/weather_holder/proc/update_wind()
	var/new_wind_speed = rand(current_weather.wind_low, current_weather.wind_high)
	if(!new_wind_speed)
		wind_speed = 0
		wind_dir = 0
		return
	wind_speed = new_wind_speed
	wind_dir = pick(GLOB.alldirs)
	var/message = "You feel the wind blowing [wind_speed > 2 ? "strongly ": ""]towards the <b>[dir2text(wind_dir)]</b>."
	message_all_outdoor_players(SPAN_WARNING( message))


/datum/weather_holder/proc/message_all_outdoor_players(message)
	for(var/mob/M in GLOB.player_list) // Don't need to care about clientless mobs.
		if(M.z in our_planet.expected_z_levels)
			var/turf/T = get_turf(M)
			if(!T.outdoors)
				continue
			to_chat(M, message)


/datum/weather_holder/proc/get_weather_datum(desired_type)
	return allowed_weather_types[desired_type]


/datum/weather_holder/proc/show_transition_message()
	if(!current_weather.transition_messages.len)
		return

	var/message = pick(current_weather.transition_messages) // So everyone gets the same message.
	message_all_outdoor_players(message)

/datum/weather

/datum/weather/New()
	if(outdoor_sounds_type)
		outdoor_sounds = new outdoor_sounds_type(list(), FALSE, TRUE)
	if(indoor_sounds_type)
		indoor_sounds = new indoor_sounds_type(list(), FALSE, TRUE)


/datum/weather/proc/process_effects()
	// Need to reset the show_message var, just in case.
	show_message = FALSE
	// Only bother with the code below if we actually need to display something.
	if(effect_message)
		if(world.time >= last_message + message_delay)
			last_message = world.time // Reset the timer
			show_message = TRUE // Tell the rest of the process that we need to make a message
	return


/datum/weather/proc/process_sounds()
	// No point bothering if we have no sounds.
	if(!outdoor_sounds && !indoor_sounds)
		return

	for(var/z_level in 1 to world.maxz)
		for(var/a in GLOB.players_by_zlevel[z_level])
			var/mob/M = a

			// Check if the mob left the z-levels we control. If so, make the sounds stop for them.
			if(!(z_level in holder.our_planet.expected_z_levels))
				hear_indoor_sounds(M, FALSE)
				hear_outdoor_sounds(M, FALSE)
				continue

			// Otherwise they should hear some sounds, depending on if they're inside or not.
			var/turf/T = get_turf(M)
			if(istype(T))
				if(T.outdoors) // Mob is currently outdoors.
					hear_outdoor_sounds(M, TRUE)
					hear_indoor_sounds(M, FALSE)

				else // Mob is currently indoors.
					hear_outdoor_sounds(M, FALSE)
					hear_indoor_sounds(M, TRUE)

			else
				hear_indoor_sounds(M, FALSE)
				hear_outdoor_sounds(M, FALSE)


/datum/weather/proc/start_sounds()
	if(outdoor_sounds)
		outdoor_sounds.start()
	if(indoor_sounds)
		indoor_sounds.start()


/datum/weather/proc/stop_sounds()
	if(outdoor_sounds)
		outdoor_sounds.stop()
	if(indoor_sounds)
		indoor_sounds.stop()

	// Stop everything just in case.
	for(var/z_level in 1 to world.maxz)
		for(var/a in GLOB.players_by_zlevel[z_level])
			hear_indoor_sounds(a, FALSE)
			hear_outdoor_sounds(a, FALSE)


/// Adds or removes someone from the outdoor list.
/datum/weather/proc/hear_outdoor_sounds(mob/M, adding)
	if(!outdoor_sounds)
		return
	if(adding)
		outdoor_sounds.output_atoms |= M
		return
	outdoor_sounds.output_atoms -= M


/// Adds or removes someone from the indoor list.
/datum/weather/proc/hear_indoor_sounds(mob/M, adding)
	if(!indoor_sounds)
		return
	if(adding)
		indoor_sounds.output_atoms |= M
		return
	indoor_sounds.output_atoms -= M


/// All this does is hold the weather icon.
/atom/movable/weather_visuals
	icon = 'icons/effects/weather.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = PLANE_PLANETLIGHTING


/**
 * This is for special effects for specific types of weather, such as lightning flashes in a storm.
 * It's a seperate object to allow the use of flick().
 */
/atom/movable/weather_visuals/special
	plane = ABOVE_LIGHTING_PLANE
