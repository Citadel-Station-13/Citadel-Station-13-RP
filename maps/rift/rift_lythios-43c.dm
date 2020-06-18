var/datum/planet/lythios43c/planet_lythios43c = null

/datum/time/lythios43c
	seconds_in_day = 10 HOURS

/datum/planet/lythios43c
	name = "Lythios-43c"
	desc = "A freezing ball of ice,"
	current_time = new /datum/time/lythios43c()
	expected_z_levels = list(
						Z_LEVEL_UNDERGROUND_DEEP,
						Z_LEVEL_UNDERGROUND,
						Z_LEVEL_SURFACE_LOW,
						Z_LEVEL_SURFACE_MID
						)
	planetary_wall_type = /turf/unsimulated/wall/planetary/lythios43c

/datum/planet/lythios43c/New()
	..()
	planet_lythios43c = src
	weather_holder = new /datum/weather_holder/lythios43c(src)

/datum/planet/lythios43c/update_sun()
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
			low_color = "#000066"

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

	var/lerp_weight = (abs(min - sun_position)) * 4
	var/weather_light_modifier = 1
	if(weather_holder && weather_holder.current_weather)
		weather_light_modifier = weather_holder.current_weather.light_modifier

	var/new_brightness = (LERP(low_brightness, high_brightness, lerp_weight) ) * weather_light_modifier

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

		var/new_r = LERP(low_r, high_r, lerp_weight)
		var/new_g = LERP(low_g, high_g, lerp_weight)
		var/new_b = LERP(low_b, high_b, lerp_weight)

		new_color = rgb(new_r, new_g, new_b)

	spawn(1)
		update_sun_deferred(2, new_brightness, new_color)


/datum/weather_holder/lythios43c
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/lythios43c/clear(),
		WEATHER_OVERCAST	= new /datum/weather/lythios43c/overcast(),
		WEATHER_LIGHT_SNOW	= new /datum/weather/lythios43c/light_snow(),
		WEATHER_SNOW		= new /datum/weather/lythios43c/snow(),
		WEATHER_BLIZZARD	= new /datum/weather/lythios43c/blizzard(),
		WEATHER_HAIL		= new /datum/weather/lythios43c/hail(),
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 27.5,
		WEATHER_OVERCAST	= 20,
		WEATHER_LIGHT_SNOW	= 20,
		WEATHER_SNOW		= 15,
		WEATHER_BLIZZARD	= 15,
		WEATHER_HAIL		= 2.5
		)

/datum/weather/lythios43c
	name = "lythios-43c base"
	temp_high = 131.15  // -142c
	temp_low = 116.15 // -157c

/datum/weather/lythios43c/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR = 60,
		WEATHER_OVERCAST = 40
		)
	transition_messages = list(
		"The sky clears up.",
		"The sky is visible.",
		"The weather is calm."
		)
	sky_visible = TRUE
	observed_message = "The sky is clear."

/datum/weather/lythios43c/overcast
	name = "overcast"
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_CLEAR = 20,
		WEATHER_OVERCAST = 50,
		WEATHER_LIGHT_SNOW = 20,
		WEATHER_SNOW = 5,
		WEATHER_HAIL = 5
		)
	observed_message = "It is overcast, all you can see are clouds."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It's very cloudy."
		)

/datum/weather/lythios43c/light_snow
	name = "light snow"
	icon_state = "snowfall_light"
	temp_high = 130.15
	temp_low = 116.15
	light_modifier = 0.7
	transition_chances = list(
		WEATHER_OVERCAST = 20,
		WEATHER_LIGHT_SNOW = 50,
		WEATHER_SNOW = 25,
		WEATHER_HAIL = 5
		)
	observed_message = "It is snowing lightly."
	transition_messages = list(
		"Small snowflakes begin to fall from above.",
		"It begins to snow lightly.",
		)

/datum/weather/lythios43c/snow
	name = "moderate snow"
	icon_state = "snowfall_med"
	temp_high = 126.15
	temp_low = 116.15
	light_modifier = 0.5
	flight_failure_modifier = 5
	transition_chances = list(
		WEATHER_LIGHT_SNOW = 20,
		WEATHER_SNOW = 50,
		WEATHER_BLIZZARD = 20,
		WEATHER_HAIL = 5,
		WEATHER_OVERCAST = 5
		)
	observed_message = "It is snowing."
	transition_messages = list(
		"It's starting to snow.",
		"The air feels much colder as snowflakes fall from above."
	)

/datum/weather/lythios43c/snow/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(33))
						T.chill()

/datum/weather/lythios43c/blizzard
	name = "blizzard"
	icon_state = "snowfall_heavy"
	temp_high = 126.15
	temp_low = 116.15
	light_modifier = 0.3
	flight_failure_modifier = 10
	transition_chances = list(
		WEATHER_SNOW = 35,
		WEATHER_BLIZZARD = 30,
		WEATHER_HAIL = 30,
		WEATHER_OVERCAST = 5
		)
	observed_message = "A blizzard blows snow everywhere."
	transition_messages = list(
		"Strong winds howl around you as a blizzard appears.",
		"It starts snowing heavily, and it feels extremly cold now."
	)

/datum/weather/lythios43c/blizzard/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(50))
						T.chill()

/datum/weather/lythios43c/hail
	name = "hail"
	icon_state = "hail"
	light_modifier = 0.3
	flight_failure_modifier = 15
	timer_low_bound = 2
	timer_high_bound = 5
	effect_message = list(
		"<I>Small chunks of ice clatter to the ground around you.</I>",
		"<I>Little pellets of ice sweep at you seemingly from all sides.</I>",
		"<I>The stream of hail thickens for a moment and temporarily obscures your vision.</I>"
	)

	transition_chances = list(
		WEATHER_SNOW = 40,
		WEATHER_BLIZZARD = 30,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 20
		)
	observed_message = "Ice is falling from the sky."
	transition_messages = list(
		"Ice begins to fall from the sky.",
		"It begins to hail.",
		"An intense chill washes over you as chunks of ice start to fall from the sky."
	)

/datum/weather/lythios43c/hail/process_effects()
	..()
	for(var/humie in living_mob_list)
		var/mob/living/H = humie
		if(H.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(H)
			if(!T.outdoors)
				continue // They're indoors, so no need to pelt them with ice.

			// If they have an open umbrella, it'll guard from hail
			var/obj/item/melee/umbrella/U
			if(istype(H.get_active_hand(), /obj/item/melee/umbrella))
				U = H.get_active_hand()
			else if(istype(H.get_inactive_hand(), /obj/item/melee/umbrella))
				U = H.get_inactive_hand()
			if(U && U.open)
				if(show_message)
					to_chat(H, pick(effect_message))
				continue

//removed needless damage code that spammed the user. if they're outside on this planet, they can withstand the useless damage that was here.

			if(show_message)
				to_chat(H, pick(effect_message))

