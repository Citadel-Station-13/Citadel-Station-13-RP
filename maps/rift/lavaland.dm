var/datum/planet/lavaland/planet_lavaland = null

/datum/time/lavaland
	seconds_in_day = 2 HOURS

/datum/planet/lavaland
	name = "Lava Land"
	desc = "The fabled."
	current_time = new /datum/time/lavaland()
	expected_z_levels = list(21, 22) // Debug testing.

/datum/planet/lavaland/New()
	..()
	planet_lavaland = src
	weather_holder = new /datum/weather_holder/lavaland(src)

/datum/planet/lavaland/update_sun()
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


/datum/weather_holder/lavaland
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_ASH_STORM	= new /datum/weather/lavaland/ash_storm(),
        WEATHER_CLEAR       = new /datum/weather/lavaland/clear(),
		WEATHER_PRE_ASH_STORM = new /datum/weather/lavaland/pre_ash_storm()
		)
	roundstart_weather_chances = list(
		WEATHER_ASH_STORM	= 5,
		WEATHER_CLEAR	= 5,
		WEATHER_PRE_ASH_STORM = 90
		)

/datum/weather/lavaland
	name = "lavaland base"
	temp_high = 350.1
	temp_low = 301.15  // -10c

/datum/weather/lavaland/clear
	name = "clear"
	timer_low_bound = 6			// How long this weather must run before it tries to change, in minutes
	timer_high_bound = 15		// How long this weather can run before it tries to change, in minutes
	transition_chances = list(
		WEATHER_CLEAR = 75,
		WEATHER_PRE_ASH_STORM = 25
		)
	transition_messages = list(
		"The air clears up.",
		"The ash starts to fade.",
		"The ruins are calm."
		)
	sky_visible = FALSE
	observed_message = "The air smooths out."

/datum/weather/lavaland/pre_ash_storm
	name = "transitioning to ash"
	timer_low_bound = 1			// How long this weather must run before it tries to change, in minutes
	timer_high_bound = 1		// How long this weather can run before it tries to change, in minutes
	icon_state = "ashfall_light"
	wind_high = 4
	wind_low = 2
	transition_chances = list(
		WEATHER_PRE_ASH_STORM = 10,
		WEATHER_ASH_STORM = 90
		)
	transition_messages = list(
		"The wind starts to pick up, and an ash storm grows on the horizon.",
		"The crackling of approaching ash whips through the air.",
		"A scorching ash storm begins to form in the distance."
		)
	sky_visible = FALSE
	observed_message = "The air smooths out."

/datum/weather/lavaland/ash_storm
	name = "ash storm"
	icon_state = "ashfall"
	light_modifier = 0.5
	light_color = "#1a1111ff"
	temp_high = 323.15	// 50c
	temp_low = 313.15	// 40c
	wind_high = 6
	wind_low = 3
	flight_failure_modifier = 50
	sky_visible = FALSE
	timer_low_bound = 1			// How long this weather must run before it tries to change, in minutes
	timer_high_bound = 2		// How long this weather can run before it tries to change, in minutes
	transition_chances = list(
		WEATHER_ASH_STORM = 15,
		WEATHER_CLEAR = 85
		)
	observed_message = "All that can be seen is black smoldering ash."
	transition_messages = list(
		"Smoldering clouds of scorching ash billow down around you!"
	)
	// Lets recycle.
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard

/datum/weather/lavaland/ash_storm/process_effects()
	..()
	for(var/thing in living_mob_list)
		var/mob/living/L = thing
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			var/timer = 0
			if(!T.outdoors)
				continue // They're indoors, so no need to burn them with ash.
			if(world.time - timer > 3 SECONDS)
				L.inflict_heat_damage(rand(1, 2))
				timer = world.time
