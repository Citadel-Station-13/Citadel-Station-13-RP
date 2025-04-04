/datum/atmosphere/planet/sky_planet
	base = list(
		/datum/gas/nitrogen = 0.66,
		/datum/gas/oxygen = 0.34,
	)
	pressure_low = 110.1
	pressure_high = 110.1
	temperature_high = 310.15
	temperature_low = 290.15

/datum/atmosphere/planet/sky_planet/ground
	base = list(
		/datum/gas/nitrogen = 0.10,
		/datum/gas/oxygen = 0.03,
		/datum/gas/carbon_dioxide = 0.87,
	)
	pressure_low = 180.1
	pressure_high = 180.1
	temperature_low = 400.15
	temperature_high = 450.15

/datum/time/sky_planet
	seconds_in_day = 3 HOURS

/datum/planet/sky_planet
	name = "Lythios 43a"
	desc = "A planet with a hostile ground, but the Tajaran of the Hadii Folly made colony of rigs above the clouds."
	current_time = new /datum/time/sky_planet()

/datum/planet/sky_planet/update_sun()
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
		if(0 to 0.20) // Night
			low_brightness = 0.1
			low_color = "#27276c"

			high_brightness = 0.4
			high_color = "#66004D"
			min = 0

		if(0.20 to 0.30) // Twilight
			low_brightness = 0.4
			low_color = "#66004D"

			high_brightness = 0.7
			high_color = "#CC3300"
			min = 0.40

		if(0.30 to 0.40) // Sunrise/set
			low_brightness = 0.7
			low_color = "#CC3300"

			high_brightness = 2.0
			high_color = "#FF9933"
			min = 0.50

		if(0.40 to 1.00) // Noon
			low_brightness = 2.0
			low_color = "#DDDDDD"

			high_brightness = 12.0
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

	update_sun_deferred(new_brightness, new_color)

/datum/planet/sky_planet/ground
	weather_holder = /datum/weather_holder/sky_planet/ground

/datum/weather_holder/sky_planet/sky
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/sky_planet/clear(),
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 100
		)

/datum/weather_holder/sky_planet/ground
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_OVERCAST		= new /datum/weather/sky_planet/overcast(),
		)
	roundstart_weather_chances = list(
		WEATHER_OVERCAST		= 100
		)

/datum/planet/sky_planet/ground/update_sun()
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

	update_sun_deferred(new_brightness, new_color)

/datum/weather/sky_planet
	name = "sky_planet base"
	temp_high	= 203
	temp_low 	= 203

/datum/weather/sky_planet/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR	 = 100
		)
	sky_visible = TRUE
	observed_message = "The sky is visible overhead."

/datum/weather/sky_planet/overcast
	name = "cloudy"
	transition_chances = list(
		WEATHER_OVERCAST	 = 100
		)
	sky_visible = FALSE
	observed_message = "The sky hidden behind dense clouds."

/datum/weather/sky_planet/pre_acid_rain
	name = "transitioning to acid"
	timer_low_bound = 1			// How long this weather must run before it tries to change, in minutes
	timer_high_bound = 1		// How long this weather can run before it tries to change, in minutes
	icon_state = "rain"
	wind_high = 4
	wind_low = 2
	sky_visible = FALSE
	transition_chances = list(
		WEATHER_PRE_ACID_RAIN = 10,
		WEATHER_ACID_RAIN = 90
		)
	transition_messages = list(
		"Some greenish rain starts to fall, with a chemical odors comming from the drops."
		)
	sky_visible = FALSE
	observed_message = "The air smooths out."

/datum/weather/sky_planet/acid_rain
	name = "acid"
	icon_state = "storm"
	light_modifier = 0.5
	light_color = "#3dc74dff"
	temp_high = 323.15	// 50c
	temp_low = 313.15	// 40c
	wind_high = 6
	wind_low = 3
	flight_failure_modifier = 40
	sky_visible = FALSE
	timer_low_bound = 1			// How long this weather must run before it tries to change, in minutes
	timer_high_bound = 2		// How long this weather can run before it tries to change, in minutes
	transition_chances = list(
		WEATHER_ACID_RAIN = 5,
		WEATHER_OVERCAST = 95
		)
	observed_message = "It is raining."
	transition_messages = list(
		"The sky is dark, and a rain of yellow acid falls down upon you."
	)
	// Lets recycle.
	outdoor_sounds_type = /datum/looping_sound/weather/rain
	indoor_sounds_type = /datum/looping_sound/weather/rain/indoors

/datum/weather/sky_planet/acid_rain/process_effects()
	..()
	for(var/thing in living_mob_list)
		var/mob/living/L = thing
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			var/timer = 0
			if(!T.outdoors)
				continue // They're indoors, so no need to burn them with ash.
			if(world.time - timer > 3 SECONDS)
				L.inflict_heat_damage(rand(5, 6))
				timer = world.time

// This is a special subtype of the thing that generates ores on a map
// It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/sky_planet
	descriptor = "Mining planet mine ore distribution map"
	deep_val = 0.6 //More riches, normal is 0.7 and 0.8
	rare_val = 0.4

// The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/sky_planet/check_map_sanity()
	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

//// Something is causing the ore spawn to error out, but still spawn ores for us so we'll need to keep tabs on why this is.
//// Hopefully the increased rarity val will cause the error to vanish, but we'll see. - Enzo 9/8/2020

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	admin_notice("RARE COUNT [rare_count]", R_DEBUG)
	admin_notice("SURFACE COUNT [surface_count]", R_DEBUG)
	admin_notice("DEEP COUNT [deep_count]", R_DEBUG)
	// Sanity check.
	if(surface_count < 100)
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < 50)
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < 50)
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1
