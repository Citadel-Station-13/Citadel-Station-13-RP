
/datum/planet/virgo3b/update_sun()
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

	update_sun_deferred(new_brightness, new_color)


/datum/weather_holder/virgo3b
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/virgo3b/clear(),
		WEATHER_OVERCAST	= new /datum/weather/virgo3b/overcast(),
		WEATHER_LIGHT_SNOW	= new /datum/weather/virgo3b/light_snow(),
		WEATHER_SNOW		= new /datum/weather/virgo3b/snow(),
		WEATHER_BLIZZARD	= new /datum/weather/virgo3b/blizzard(),
		WEATHER_RAIN		= new /datum/weather/virgo3b/rain(),
		WEATHER_STORM		= new /datum/weather/virgo3b/storm(),
		WEATHER_HAIL		= new /datum/weather/virgo3b/hail(),
		WEATHER_BLOOD_MOON	= new /datum/weather/virgo3b/blood_moon()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 30,
		WEATHER_OVERCAST	= 30,
		WEATHER_LIGHT_SNOW	= 20,
		WEATHER_SNOW		= 5,
		WEATHER_BLIZZARD	= 5,
		WEATHER_RAIN		= 5,
		WEATHER_STORM		= 2.5,
		WEATHER_HAIL		= 2.5
		)

/datum/weather/virgo3b
	abstract_type = /datum/weather/virgo3b

/datum/weather/virgo3b/light_snow
	name = "light snow"
	icon_state = "snowfall_light"
	temp_high = 235
	temp_low = 	225
	light_modifier = 0.7
	transition_chances = list(
		WEATHER_OVERCAST = 20,
		WEATHER_LIGHT_SNOW = 50,
		WEATHER_SNOW = 25,
		WEATHER_HAIL = 5
		)
	observed_message = "It is snowing lightly."
	effect_message = list(
		"<i>The gentle breeze lifts tiny particles of falling snow past you.</i>",
		"<i>Cool wind rushes over your senses as the breeze softly stirs and spirals around you.</i>",
		"<i>A momentary pause in wind leaves the air still before it finds its peaceful rhythm again.</i>",
		"<i>Blanketed cold envelops you as the wind carries its chilled embrace.</i>"
	)
	transition_messages = list(
		"Small snowflakes begin to fall from above.",
		"It begins to snow lightly.",
		)

/datum/weather/virgo3b/light_snow/process_effects()
	..()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // Are they indoors?

			if(show_message)
				to_chat(L, pick(effect_message))

/datum/weather/virgo3b/snow
	name = "moderate snow"
	icon_state = "snowfall_med"
	temp_high = 230
	temp_low = 220
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
	effect_message = list(
		"<i>Snow falls gently around you with a quiet pattering song.</i>",
		"<i>Cool wind rushes over your senses as the breeze softly stirs and spirals around you.</i>",
		"<i>A momentary pause in wind leaves the air still before it finds its peaceful rhythm again.</i>",
		"<i>Blanketed cold envelops you as the wind carries its chilled embrace.</i>"
	)
	transition_messages = list(
		"It's starting to snow.",
		"The air feels much colder as snowflakes fall from above."
	)

/datum/weather/virgo3b/blizzard
	name = "blizzard"
	icon_state = "snowfall_heavy"
	temp_high = 215
	temp_low = 200
	light_modifier = 0.3
	flight_failure_modifier = 10
	transition_chances = list(
		WEATHER_SNOW = 45,
		WEATHER_BLIZZARD = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)
	observed_message = "A blizzard blows snow everywhere."
	effect_message = list(
		"<i>Distant howling wind swirls up to meet you as the blizzard tempers and flares.</i>",
		"<i>Cool wind rushes over your senses as the strong wing stirs and spirals around you.</i>",
		"<i>A strong gust of wind rushes past you.</i>"
	)
	transition_messages = list(
		"Strong winds howl around you as a blizzard appears.",
		"It starts snowing heavily, and it feels extremly cold now."
	)

/datum/weather/virgo3b/blizzard/process_effects()
	..()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // Are they indoors?

			if(show_message)
				to_chat(L, pick(effect_message))

	for(var/turf/simulated/floor/outdoors/snow/S in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in GLOB.cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(50))
						T.chill()

/datum/weather/virgo3b/storm/process_effects()
	..()
	for(var/mob/living/L in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // Are they indoors?

			// Lazy wind code
			if(prob(10))
				if(istype(L.get_active_held_item(), /obj/item/melee/umbrella))
					var/obj/item/melee/umbrella/U = L.get_active_held_item()
					if(U.open)
						to_chat(L, "<span class='danger'>You struggle to keep hold of your umbrella!</span>")
						L.afflict_stun(20 * 20)	// This is not nearly as long as it seems
						playsound(L, 'sound/effects/rustle1.ogg', 100, 1)	// Closest sound I've got to "Umbrella in the wind"
				else if(istype(L.get_inactive_held_item(), /obj/item/melee/umbrella))
					var/obj/item/melee/umbrella/U = L.get_inactive_held_item()
					if(U.open)
						if(L.drop_item_to_ground(U))
							to_chat(L, "<span class='danger'>A gust of wind yanks the umbrella from your hand!</span>")
							playsound(L, 'sound/effects/rustle1.ogg', 100, 1)
							U.toggle_umbrella()
							U.throw_at_old(get_edge_target_turf(U, pick(GLOB.alldirs)), 8, 1, L)
						else
							to_chat(L, "<span class='notice'>A gust of wind nearly yanks the umbrella from your hand.</span>")
							playsound(L, 'sound/effects/rustle1.ogg', 100, 1)

			// If they have an open umbrella, it'll guard from rain
			if(istype(L.get_active_held_item(), /obj/item/melee/umbrella))
				var/obj/item/melee/umbrella/U = L.get_active_held_item()
				if(U.open)
					if(show_message)
						to_chat(L, pick(effect_message))
					continue
			else if(istype(L.get_inactive_held_item(), /obj/item/melee/umbrella))
				var/obj/item/melee/umbrella/U = L.get_inactive_held_item()
				if(U.open)
					if(show_message)
						to_chat(L, pick(effect_message))
					continue


			L.water_act(2)
			if(show_message)
				to_chat(L, pick(effect_message))

	handle_lightning()

// This gets called to do lightning periodically.
// There is a seperate function to do the actual lightning strike, so that badmins can play with it.
/datum/weather/virgo3b/storm/proc/handle_lightning()
	if(world.time < next_lightning_strike)
		return // It's too soon to strike again.
	next_lightning_strike = world.time + rand(min_lightning_cooldown, max_lightning_cooldown)
	var/turf/T = pick(holder.our_planet.planet_floors) // This has the chance to 'strike' the sky, but that might be a good thing, to scare reckless pilots.
	lightning_strike(T)

/datum/weather/virgo3b/hail
	name = "hail"
	icon_state = "hail"
	light_modifier = 0.3
	flight_failure_modifier = 15
	timer_low_bound = 2
	timer_high_bound = 5
	effect_message = list(
		"<i>Small chunks of ice clatter to the ground around you.</i>",
		"<i>Little pellets of ice sweep at you seemingly from all sides.</i>",
		"<i>The stream of hail thickens for a moment and temporarily obscures your vision.</i>"
	)

	transition_chances = list(
		WEATHER_RAIN = 45,
		WEATHER_STORM = 40,
		WEATHER_HAIL = 10,
		WEATHER_OVERCAST = 5
		)
	observed_message = "Ice is falling from the sky."
	transition_messages = list(
		"Ice begins to fall from the sky.",
		"It begins to hail.",
		"An intense chill washes over you as chunks of ice start to fall from the sky."
	)
