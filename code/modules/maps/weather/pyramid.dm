/datum/time/pyramid_desert
	seconds_in_day = 24 HOURS

/datum/planet/pyramid_desert
	name = "pyramid"
	desc = "Small planetoid with an pyramid."
	weather_holder = /datum/weather_holder/pyramid_desert

/datum/atmosphere/planet/pyramid_desert
	base = list(
		/datum/gas/oxygen = 0.24,
		/datum/gas/nitrogen = 0.72,
		/datum/gas/carbon_dioxide = 0.04,
	)
	pressure_low = 110.1
	pressure_high = 110.1
	temperature_low = 317.3 //Barely enough to avoid baking Teshari
	temperature_high = 317.3

/datum/atmosphere/planet/pyramid_forest
	base = list(
		/datum/gas/oxygen = 0.22,
		/datum/gas/nitrogen = 0.78,
	)
	pressure_low = 110.1
	pressure_high = 110.1
	temperature_low = 293.3
	temperature_high = 307.3


/datum/planet/pyramid_desert/update_sun()
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
			low_brightness = 0.35
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

	set_sun_lighting(new_brightness, new_color)


/datum/weather_holder/pyramid_desert
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/lythios43c/clear(),
		WEATHER_OVERCAST	= new /datum/weather/lythios43c/overcast(),
		WEATHER_LIGHT_SNOW	= new /datum/weather/lythios43c/light_snow(),
		WEATHER_SNOW		= new /datum/weather/lythios43c/snow(),
		WEATHER_BLIZZARD	= new /datum/weather/lythios43c/blizzard(),
		WEATHER_HAIL		= new /datum/weather/lythios43c/hail(),
		WEATHER_FALLOUT		= new /datum/weather/lythios43c/fallout(),
		WEATHER_BLOODMOON	= new /datum/weather/lythios43c/blood_moon()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 27.5,
		WEATHER_OVERCAST	= 20,
		WEATHER_LIGHT_SNOW	= 20,
		WEATHER_SNOW		= 15,
		WEATHER_BLIZZARD	= 15,
		WEATHER_HAIL		= 2.5
		)

/datum/weather/pyramid_desert
	name = "pyramid_desert"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c

/datum/weather/pyramid_desert/clear
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

/datum/weather/pyramid_desert/overcast
	name = "overcast"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_CLEAR = 25,
		WEATHER_OVERCAST = 50,
		WEATHER_RAIN = 5
		)
	observed_message = "It is overcast, all you can see are clouds."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It's very cloudy."
		)

/datum/weather/pyramid_desert/light_snow
	name = "light snow"
	icon_state = "snowfall_light"
	temp_high = 260.15
	temp_low = 240.15
	light_modifier = 0.7
	transition_chances = list(
		WEATHER_LIGHT_SNOW = 100
		)
	observed_message = "It is snowing lightly."
	transition_messages = list(
		"Small snowflakes begin to fall from above.",
		"It begins to snow lightly.",
		)

/datum/weather/pyramid_desert/snow
	name = "moderate snow"
	icon_state = "snowfall_med"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c
	wind_high = 2
	wind_low = 0
	light_modifier = 0.5
	flight_failure_modifier = 5
	transition_chances = list(
		WEATHER_LIGHT_SNOW = 100
		)
	observed_message = "It is snowing."
	transition_messages = list(
		"It's starting to snow.",
		"The air feels much colder as snowflakes fall from above."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/outside_snow
	indoor_sounds_type = /datum/looping_sound/weather/inside_snow

/*
/datum/weather/pyramid_desert/snow/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S as anything in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(33))
						T.chill()
*/

/datum/weather/pyramid_desert/blizzard
	name = "blizzard"
	icon_state = "snowfall_heavy"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	transition_chances = list(
		WEATHER_BLIZZARD = 100
		)
	observed_message = "A blizzard blows snow everywhere."
	transition_messages = list(
		"Strong winds howl around you as a blizzard appears.",
		"It starts snowing heavily, and it feels extremly cold now."
	)
	transition_messages = list(
		"Strong winds howl around you as a blizzard appears.",
		"It starts snowing heavily, and it feels extremly cold now."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard

/*
/datum/weather/pyramid_desert/blizzard/process_effects()
	..()
	for(var/turf/simulated/floor/outdoors/snow/S as anything in SSplanets.new_outdoor_turfs) //This didn't make any sense before SSplanets, either
		if(S.z in holder.our_planet.expected_z_levels)
			for(var/dir_checked in cardinal)
				var/turf/simulated/floor/T = get_step(S, dir_checked)
				if(istype(T))
					if(istype(T, /turf/simulated/floor/outdoors) && prob(50))
						T.chill()
*/

/datum/weather/pyramid_desert/rain
	name = "rain"
	icon_state = "rain"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c
	wind_high = 2
	wind_low = 1
	light_modifier = 0.5
	effect_message = "<span class='warning'>Rain falls on you.</span>"

	transition_chances = list(
		WEATHER_OVERCAST = 25,
		WEATHER_RAIN = 50
		)
	observed_message = "It is raining."
	transition_messages = list(
		"The sky is dark, and rain falls down upon you."
	)

/datum/weather/pyramid_desert/rain/process_effects()
	..()
	for(var/mob/living/L as anything in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll guard from rain
			var/obj/item/melee/umbrella/U = L.get_active_held_item()
			if(!istype(U) || !U.open)
				U = L.get_inactive_held_item()

			if(istype(U) && U.open)
				if(show_message)
					to_chat(L, "<span class='notice'>Rain patters softly onto your umbrella.</span>")
				continue

			L.water_act(1)
			if(show_message)
				to_chat(L, effect_message)

/datum/weather/pyramid_desert/storm
	name = "storm"
	icon_state = "storm"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c
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
		WEATHER_STORM = 100
		)

/datum/weather/pyramid_desert/storm/process_effects()
	..()
	for(var/mob/living/L as anything in living_mob_list)
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to rain on them.

			// If they have an open umbrella, it'll guard from rain
			var/obj/item/melee/umbrella/U = L.get_active_held_item()
			if(!istype(U) || !U.open)
				U = L.get_inactive_held_item()

			if(istype(U) && U.open)
				if(show_message)
					to_chat(L, "<span class='notice'>Rain showers loudly onto your umbrella!</span>")
				continue


			L.water_act(2)
			if(show_message)
				to_chat(L, effect_message)

	handle_lightning()

// This gets called to do lightning periodically.
// There is a seperate function to do the actual lightning strike, so that badmins can play with it.
/datum/weather/pyramid_desert/storm/proc/handle_lightning()
	if(world.time < next_lightning_strike)
		return // It's too soon to strike again.
	next_lightning_strike = world.time + rand(min_lightning_cooldown, max_lightning_cooldown)
	var/turf/T = pick(holder.our_planet.planet_floors) // This has the chance to 'strike' the sky, but that might be a good thing, to scare reckless pilots.
	lightning_strike(T)

/datum/weather/pyramid_desert/hail
	name = "hail"
	icon_state = "hail"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c
	light_modifier = 0.3
	flight_failure_modifier = 15
	timer_low_bound = 2
	timer_high_bound = 5
	effect_message = "<span class='warning'>The hail smacks into you!</span>"

	transition_chances = list(
		WEATHER_HAIL = 100
		)
	observed_message = "Ice is falling from the sky."
	transition_messages = list(
		"Ice begins to fall from the sky.",
		"It begins to hail.",
		"An intense chill is felt, and chunks of ice start to fall from the sky, towards you."
	)

/datum/weather/pyramid_desert/hail/process_effects()
	..()
	for(var/mob/living/carbon/H as anything in human_mob_list)
		if(H.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(H)
			if(!T.outdoors)
				continue // They're indoors, so no need to pelt them with ice.

			// If they have an open umbrella, it'll guard from hail
			var/obj/item/melee/umbrella/U = H.get_active_held_item()
			if(!istype(U) || !U.open)
				U = H.get_inactive_held_item()

			if(istype(U) && U.open)
				if(show_message)
					to_chat(H, "<span class='notice'>Hail patters onto your umbrella.</span>")
				continue

			var/target_zone = pick(BP_ALL)
			var/amount_blocked = H.run_armor_check(target_zone, "melee")
			var/amount_soaked = H.get_armor_soak(target_zone, "melee")

			var/damage = rand(1,3)

			if(amount_blocked >= 30)
				continue // No need to apply damage. Hardhats are 30. They should probably protect you from hail on your head.
				//Voidsuits are likewise 40, and riot, 80. Clothes are all less than 30.

			if(amount_soaked >= damage)
				continue // No need to apply damage.

			H.apply_damage(damage, DAMAGE_TYPE_BRUTE, target_zone, amount_blocked, amount_soaked, used_weapon = "hail")
			if(show_message)
				to_chat(H, effect_message)

/datum/weather/pyramid_desert/blood_moon
	name = "blood moon"
	light_modifier = 0.5
	light_color = "#FF0000"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c
	flight_failure_modifier = 25
	transition_chances = list(
		WEATHER_BLOODMOON = 100
		)
	observed_message = "Everything is red. Something really ominous is going on."
	transition_messages = list(
		"The sky turns blood red!"
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

// Ash and embers fall forever, such as from a volcano or something.
/datum/weather/pyramid_desert/emberfall
	name = "emberfall"
	icon_state = "ashfall_light"
	light_modifier = 0.7
	light_color = "#880000"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c
	flight_failure_modifier = 20
	transition_chances = list(
		WEATHER_EMBERFALL = 100
		)
	observed_message = "Soot, ash, and embers float down from above."
	transition_messages = list(
		"Gentle embers waft down around you like grotesque snow."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

// Like the above but a lot more harmful.
/datum/weather/pyramid_desert/ash_storm
	name = "ash storm"
	icon_state = "ashfall_heavy"
	light_modifier = 0.1
	light_color = "#FF0000"
	temp_high = 313.15 // 40c
	temp_low = 303.15  // 30c
	wind_high = 6
	wind_low = 3
	flight_failure_modifier = 50
	transition_chances = list(
		WEATHER_ASH_STORM = 100
		)
	observed_message = "All that can be seen is black smoldering ash."
	transition_messages = list(
		"Smoldering clouds of scorching ash billow down around you!"
	)
	// Lets recycle.
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard

/datum/weather/pyramid_desert/ash_storm/process_effects()
	..()
	for(var/thing in living_mob_list)
		var/mob/living/L = thing
		if(L.z in holder.our_planet.expected_z_levels)
			var/turf/T = get_turf(L)
			if(!T.outdoors)
				continue // They're indoors, so no need to burn them with ash.

			L.inflict_heat_damage(rand(1, 3))


// Totally radical.
/datum/weather/pyramid_desert/fallout
	name = "fallout"
	icon_state = "fallout"
	light_modifier = 0.7
	light_color = "#CCFFCC"
	flight_failure_modifier = 30
	transition_chances = list(
		WEATHER_FALLOUT = 100
		)
	observed_message = "Radioactive soot and ash rains down from the heavens."
	transition_messages = list(
		"Radioactive soot and ash start to float down around you, contaminating whatever they touch."
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

	// How much radiation a mob gets while on an outside tile.
	var/direct_rad_low = RAD_INTENSITY_FALLOUT_DIRECT_LOW
	var/direct_rad_high = RAD_INTENSITY_FALLOUT_DIRECT_HIGH

	// How much radiation is bursted onto a random tile near a mob.
	var/fallout_rad_low = RAD_INTENSITY_FALLOUT_INDIRECT_LOW
	var/fallout_rad_high = RAD_INTENSITY_FALLOUT_INDIRECT_HIGH

/datum/weather/pyramid_desert/fallout/process_effects()
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
/datum/weather/pyramid_desert/fallout/proc/irradiate_nearby_turf(mob/living/L)
	if(!istype(L))
		return
	var/list/turfs = RANGE_TURFS(world.view, L)
	var/turf/T = pick(turfs) // We get one try per tick.
	if(!istype(T))
		return
	if(T.outdoors)
		radiation_pulse(T, rand(fallout_rad_low, fallout_rad_high))


//forrest side

/datum/atmosphere/planet/pyramid_forest
	base = list(
		/datum/gas/oxygen = 0.22,
		/datum/gas/nitrogen = 0.78,
	)
	pressure_low = 110.1
	pressure_high = 110.1
	temperature_low = 293.3
	temperature_high = 307.3

/datum/time/pyramid_forest
	seconds_in_day = 10 HOURS

/datum/planet/pyramid_forest //This is currently unused
	name = "Class-M Gaia Planet"
	desc = "A beautiful, lush planet that is owned by the Happy Days and Sunshine Corporation."
	current_time = new /datum/time/pyramid_forest()
	weather_holder = /datum/weather_holder/pyramid_forest

/datum/planet/pyramid_forest/update_sun()
	..()
	var/datum/time/time = current_time
	var/length_of_day = time.seconds_in_day / 10 / 60 / 60
	var/noon = length_of_day / 2
	var/distance_from_noon = abs(text2num(time.show_time("hh")) - noon)
	sun_position = distance_from_noon / noon
	sun_position = abs(sun_position - 1)

	var/low_brightness = 0.9
	var/high_brightness = 1.0

	var/low_color = "#DDDDDD"
	var/high_color = "#FFFFFF"
	var/min = 0.70

/*	switch(sun_position)
		if(0 to 0.40) // Night
			low_brightness = 0.35
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
			min = 0.70 */

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

	set_sun_lighting(new_brightness, new_color)


/datum/weather_holder/pyramid_forest
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/pyramid_forest/clear(),
		WEATHER_OVERCAST	= new /datum/weather/pyramid_forest/overcast(),
		WEATHER_RAIN		= new /datum/weather/pyramid_forest/rain(),
		WEATHER_STORM		= new /datum/weather/pyramid_forest/storm(),
		WEATHER_BLOOD_MOON	= new /datum/weather/pyramid_forest/blood_moon(),
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 100
		)

/datum/weather/pyramid_forest
	name = "pyramid_forest base"
	temp_high = 293.15 // 20c
	temp_low = 303.15  // 30c

/datum/weather/pyramid_forest/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR = 100
		)
	transition_messages = list(
		"The sky clears up.",
		"The sky becomes visible.",
		"The weather grows calm."
		)
	sky_visible = TRUE
	observed_message = "The sky is clear."

/datum/weather/pyramid_forest/overcast
	name = "overcast"
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_OVERCAST = 100
		)
	observed_message = "It is overcast, all you can see are clouds."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It becomes very cloudy."
		)


/datum/weather/pyramid_forest/rain
	name = "rain"
	icon_state = "rain"
	wind_high = 2
	wind_low = 1
	light_modifier = 0.5
	effect_message = "<span class='warning'>Rain falls on you.</span>"
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors

	transition_chances = list(
		WEATHER_RAIN = 100
		)
	observed_message = "The sky is dark, and rain falls down upon you."
	transition_messages = list(
		"The sky grows dark, and rain falls down upon you."
	)

/datum/weather/pyramid_forest/rain/process_effects()
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

/datum/weather/pyramid_forest/storm
	name = "storm"
	icon_state = "storm"
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	effect_message = "<span class='warning'>Rain falls on you, drenching you in water.</span>"
	outdoor_sounds_type = /datum/looping_sound/weather/outside_snow
	indoor_sounds_type = /datum/looping_sound/weather/inside_snow

	var/next_lightning_strike = 0 // world.time when lightning will strike.
	var/min_lightning_cooldown = 5 SECONDS
	var/max_lightning_cooldown = 1 MINUTE
	observed_message = "An intense storm pours down over the region."
	transition_messages = list(
		"You feel intense winds hit you as the weather takes a turn for the worse.",
		"Loud thunder is heard in the distance.",
		"A bright flash heralds the approach of a storm."
	)


	transition_chances = list(
		WEATHER_STORM = 100
		)

/datum/weather/pyramid_forest/storm/process_effects()
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
/datum/weather/pyramid_forest/storm/proc/handle_lightning()
	if(world.time < next_lightning_strike)
		return // It's too soon to strike again.
	next_lightning_strike = world.time + rand(min_lightning_cooldown, max_lightning_cooldown)
	var/turf/T = pick(holder.our_planet.planet_floors) // This has the chance to 'strike' the sky, but that might be a good thing, to scare reckless pilots.
	lightning_strike(T)


/datum/weather/pyramid_forest/blood_moon
	name = "blood moon"
	light_modifier = 0.5
	light_color = "#FF0000"
	flight_failure_modifier = 25
	transition_chances = list(
		WEATHER_BLOODMOON = 100
		)
	observed_message = "Everything is red. Something really ominous is going on."
	transition_messages = list(
		"The sky turns blood red!"
	)
	outdoor_sounds_type = /datum/looping_sound/weather/wind
	indoor_sounds_type = /datum/looping_sound/weather/wind/indoors
