/datum/atmosphere/planet/classm
	base_gases = list(
	/datum/gas/oxygen = 0.22,
	/datum/gas/nitrogen = 0.78
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 293.3
	maximum_temp = 307.3


/datum/time/classm
	seconds_in_day = 3 HOURS

/datum/planet/classm
	name = "Class-M Gaia Planet"
	desc = "A beautiful, lush planet that is owned by the Happy Days and Sunshine Corporation."
	current_time = new /datum/time/classm()

/datum/planet/classm/update_sun()
	..()
	var/datum/time/time = current_time
	var/length_of_day = time.seconds_in_day / 10 / 60 / 60
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	sun_position = distance_from_noon / noon
	sun_position = abs(sun_position - 1)

	var/low_brightness = null
	var/high_brightness = null

	var/low_color = null
	var/high_color = null
	var/min = 0

	switch(sun_position)
		if(0 to 0.40) // Night
			low_brightness = 0.2
			low_color = "#110077"

			high_brightness = 0.5
			high_color = "#66004D"
			min = 0

		if(0.40 to 0.50) // Twilight
			low_brightness = 0.6
			low_color = "#66004D"

			high_brightness = 0.8
			high_color = "#CC3300"
			min = 0.40

		if(0.50 to 0.70) // Sunrise/set
			low_brightness = 0.8
			low_color = "#CC3300"

			high_brightness = 0.9
			high_color = "#FF9933"
			min = 0.50

		if(0.70 to 1.00) // Noon
			low_brightness = 0.9
			low_color = "#DDDDDD"

			high_brightness = 1.0
			high_color = "#FFFFFF"
			min = 0.70

	var/interpolate_weight = (abs(min - sun_position)) * 4
	var/weather_light_modifier = 1
	if(weather_holder && weather_holder.current_weather)
		weather_light_modifier = weather_holder.current_weather.light_modifier

	var/new_brightness = (LERP(low_brightness, high_brightness, interpolate_weight) ) * weather_light_modifier

	var/new_color = null
	if(weather_holder && weather_holder.current_weather && weather_holder.current_weather.light_color)
		new_color = weather_holder.current_weather.light_color
	else
		var/list/low_color_list = hex2rgb(low_color)
		var/low_r = low_color_list[1]
		var/low_g = low_color_list[2]
		var/low_b = low_color_list[3]

		var/list/high_color_list = hex2rgb(high_color)
		var/high_r = high_color_list[1]
		var/high_g = high_color_list[2]
		var/high_b = high_color_list[3]

		var/new_r = LERP(low_r, high_r, interpolate_weight)
		var/new_g = LERP(low_g, high_g, interpolate_weight)
		var/new_b = LERP(low_b, high_b, interpolate_weight)

		new_color = rgb(new_r, new_g, new_b)

	spawn(1)
		update_sun_deferred(2, new_brightness, new_color)


/datum/weather_holder/classm
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/classm/clear(),
		WEATHER_OVERCAST	= new /datum/weather/classm/overcast(),
		WEATHER_RAIN		= new /datum/weather/classm/rain(),
		WEATHER_STORM		= new /datum/weather/classm/storm(),
		WEATHER_BLOOD_MOON	= new /datum/weather/classm/blood_moon(),
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 75,
		WEATHER_OVERCAST	= 15,
		WEATHER_RAIN		= 5,
		WEATHER_STORM		= 4,
		WEATHER_BLOODMOON	= 1
		)

/datum/weather/classm
	name = "classm base"
	temp_high = 293.15 // 20c
	temp_low = 303.15  // 30c

/datum/weather/classm/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR = 90,
		WEATHER_OVERCAST = 10
		)
	transition_messages = list(
		"The sky clears up.",
		"The sky is visible.",
		"The weather is calm."
		)
	sky_visible = TRUE
	observed_message = "The sky is clear."

/datum/weather/classm/overcast
	name = "overcast"
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_CLEAR = 70,
		WEATHER_OVERCAST = 10,
		WEATHER_RAIN = 19,
		WEATHER_BLOODMOON = 1
		)
	observed_message = "It is overcast, all you can see are clouds."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It's very cloudy."
		)


/datum/weather/classm/rain
	name = "rain"
	icon_state = "rain"
	wind_high = 2
	wind_low = 1
	light_modifier = 0.5
	effect_message = "<span class='warning'>Rain falls on you.</span>"

	transition_chances = list(
		WEATHER_OVERCAST = 40,
		WEATHER_RAIN = 55,
		WEATHER_STORM = 5
		)
	observed_message = "It is raining."
	transition_messages = list(
		"The sky is dark, and rain falls down upon you."
	)

/datum/weather/classm/rain/process_effects()
	..()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll guard from rain
			if(istype(L.get_active_held_item(), /obj/item/melee/umbrella))
				var/obj/item/melee/umbrella/U = L.get_active_held_item()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain patters softly onto your umbrella.</span>")
					continue
			else if(istype(L.get_inactive_held_item(), /obj/item/melee/umbrella))
				var/obj/item/melee/umbrella/U = L.get_inactive_held_item()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain patters softly onto your umbrella.</span>")
					continue

			L.water_act(1)
			if(show_message)
				to_chat(L, effect_message)

/datum/weather/classm/storm
	name = "storm"
	icon_state = "storm"
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	effect_message = "<span class='warning'>Rain falls on you, drenching you in water.</span>"

	var/next_lightning_strike = 0 // world.time when lightning will strike.
	var/min_lightning_cooldown = 5 SECONDS
	var/max_lightning_cooldown = 1 MINUTE
	observed_message = "An intense storm pours down over the region."
	transition_messages = list(
		"You feel intense winds hit you as the weather takes a turn for the worst.",
		"Loud thunder is heard in the distance.",
		"A bright flash heralds the approach of a storm."
	)


	transition_chances = list(
		WEATHER_RAIN = 40,
		WEATHER_STORM = 45,
		WEATHER_OVERCAST = 5
		)

/datum/weather/classm/storm/process_effects()
	..()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll guard from rain
			if(istype(L.get_active_held_item(), /obj/item/melee/umbrella))
				var/obj/item/melee/umbrella/U = L.get_active_held_item()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain showers loudly onto your umbrella!</span>")
					continue
			else if(istype(L.get_inactive_held_item(), /obj/item/melee/umbrella))
				var/obj/item/melee/umbrella/U = L.get_inactive_held_item()
				if(U.open)
					if(show_message)
						to_chat(L, "<span class='notice'>Rain showers loudly onto your umbrella!</span>")
					continue


			L.water_act(2)
			if(show_message)
				to_chat(L, effect_message)

	handle_lightning()

// This gets called to do lightning periodically.
// There is a seperate function to do the actual lightning strike, so that badmins can play with it.
/datum/weather/classm/storm/proc/handle_lightning()
	if(world.time < next_lightning_strike)
		return // It's too soon to strike again.
	next_lightning_strike = world.time + rand(min_lightning_cooldown, max_lightning_cooldown)
	var/turf/T = pick(holder.our_planet.planet_floors) // This has the chance to 'strike' the sky, but that might be a good thing, to scare reckless pilots.
	lightning_strike(T)


/datum/weather/classm/blood_moon
	name = "blood moon"
	light_modifier = 0.5
	light_color = "#FF0000"
	flight_failure_modifier = 25
	transition_chances = list(
		WEATHER_BLOODMOON = 90,
		WEATHER_OVERCAST = 10
		)
	observed_message = "Everything is red. Something really ominous is going on."
	transition_messages = list(
		"The sky turns blood red!"
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors
