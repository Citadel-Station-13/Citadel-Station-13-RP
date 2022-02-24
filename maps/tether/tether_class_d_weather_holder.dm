/// Lateloaded by tether.dm after tether_defines.dm
/// Has to be loaded this way since tether_defines.dm has Z_LEVEL_CLASS_D defined whiiiiiich this .dm uses to designate the z level for the weather to be simulated on.


var/datum/planet/class_d/planet_class_d = null

/datum/time/class_d
	seconds_in_day = 3 HOURS

/datum/planet/class_d
	name = "Virgo - 5"
	desc = "A rocky moon which has recently had its quarantine lifted following a campaign of nuclear bombings and mercinary \
	forces fighting to whipe out a large xenomorph infestation."
	current_time = new /datum/time/class_d()
	expected_z_levels = list(Z_LEVEL_CLASS_D)		// Designates z level the weather effects should be used one
	planetary_wall_type = /turf/unsimulated/wall/planetary/class_d


/datum/planet/class_d/New()
	..()
	planet_class_d = src
	weather_holder = new /datum/weather_holder/class_d(src)

/datum/planet/class_d/update_sun()
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
			low_color = "#000066"

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

	spawn(1)
		update_sun_deferred(2, new_brightness, new_color)



/datum/weather_holder/class_d
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/class_d/clear(),
		WEATHER_FALLOUT		= new /datum/weather/class_d/fallout()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 95,
		WEATHER_FALLOUT		= 5
		)

/datum/weather/class_d
	name = "class_d base"
	temp_high	= 203
	temp_low 	= 203

/datum/weather/class_d/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR	 = 85,
		WEATHER_FALLOUT	 = 15
		)
	transition_messages = list(
		"The radioactive storm clears.",
		"The stars are visible once more.",
		)
	sky_visible = TRUE
	observed_message = "The stars are visible overhead."

/datum/weather/class_d/fallout
	name = "fallout"
	icon_state = "fallout"
	light_modifier = 0.7
	light_color = "#CCFFCC"
	flight_failure_modifier = 30
	transition_chances = list(
		WEATHER_CLEAR	= 60,
		WEATHER_FALLOUT = 40
		)
	observed_message = "Radioactive soot and ash rains down from the heavens."
	transition_messages = list(
		"Radioactive soot and ash start to float down around you, contaminating whatever they touch."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

	// How much radiation a mob gets while on an outside tile.
	var/direct_rad_low = RAD_LEVEL_LOW
	var/direct_rad_high = RAD_LEVEL_MODERATE

	// How much radiation is bursted onto a random tile near a mob.
	var/fallout_rad_low = RAD_LEVEL_HIGH
	var/fallout_rad_high = RAD_LEVEL_VERY_HIGH

/datum/weather/class_d/fallout/process_effects()
	..()
	for(var/thing in living_mob_list)
		var/mob/living/L = thing
		if(L.z in holder.our_planet.expected_z_levels)
			irradiate_nearby_turf(L)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to irradiate them with fallout.

			L.rad_act(rand(direct_rad_low, direct_rad_high))

// This makes random tiles near people radioactive for awhile.
// Tiles far away from people are left alone, for performance.
/datum/weather/class_d/fallout/proc/irradiate_nearby_turf(mob/living/L)
	if(!istype(L))
		return
	var/list/turfs = RANGE_TURFS(world.view, L)
	var/turf/T = pick(turfs) // We get one try per tick.
	if(!istype(T))
		return
	if(T.outdoors)
		SSradiation.radiate(T, rand(fallout_rad_low, fallout_rad_high))
