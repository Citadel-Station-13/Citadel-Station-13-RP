
/datum/planet/classh
	name = "Class-H Desert Planet"
	desc = "A nearly hostile, and almost barren, planet that orbits pretty close to its star. There is a high level of CO2 in the air."
	current_time = new /datum/time/classh()


/datum/weather_holder/classh
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/classh/clear(),
		WEATHER_OVERCAST	= new /datum/weather/classh/overcast(),
		WEATHER_RAIN		= new /datum/weather/classh/rain(),
		WEATHER_SANDSTORM	= new /datum/weather/classh/sandstorm(),
		WEATHER_BLOOD_MOON	= new /datum/weather/classh/blood_moon(),
		WEATHER_EMBERFALL	= new /datum/weather/classh/emberfall(),
		WEATHER_ASH_STORM	= new /datum/weather/classh/ash_storm(),
		WEATHER_FALLOUT		= new /datum/weather/classh/fallout()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 70,
		WEATHER_OVERCAST	= 19,
		WEATHER_SANDSTORM	= 10,
		WEATHER_RAIN		= 1
		)

/datum/weather/classh
	name = "classh base"
	temp_high = 317.3 // 44C
	temp_low = 317.3 // 44C

/datum/weather/classh/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR = 95,
		WEATHER_OVERCAST = 5
		)
	transition_messages = list(
		"The sky clears up.",
		"The sky is visible.",
		"The weather is calm."
		)
	sky_visible = TRUE
	observed_message = "The sky is clear."

/datum/weather/classh/overcast
	name = "overcast"
	light_modifier = 0.8
	transition_chances = list(
		WEATHER_CLEAR = 85,
		WEATHER_OVERCAST = 14,
		WEATHER_RAIN = 1
		)
	observed_message = "It is overcast, all you can see are clouds."
	transition_messages = list(
		"All you can see above are clouds.",
		"Clouds cut off your view of the sky.",
		"It's very cloudy."
		)

/datum/weather/classh/rain
	name = "rain"
	icon_state = "rain"
	wind_high = 2
	wind_low = 1
	light_modifier = 0.5
	effect_message = "<span class='warning'>Rain falls on you.</span>"

	transition_chances = list(
		WEATHER_OVERCAST = 75,
		WEATHER_RAIN = 25
		)
	observed_message = "It is raining."
	transition_messages = list(
		"The sky is dark, and rain falls down upon you."
	)

/datum/weather/classh/rain/process_effects()
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

/datum/weather/classh/sandstorm
	name = "sandstorm"
	icon_state = "sandstorm"
	wind_high = 4
	wind_low = 2
	light_modifier = 0.3
	flight_failure_modifier = 10
	transition_chances = list(
		WEATHER_CLEAR = 45,
		WEATHER_SANDSTORM = 50,
		WEATHER_OVERCAST = 5
		)
	observed_message = "A strong wind kicks sand everywhere."
	transition_messages = list(
		"Strong winds howl around you as a sandstorm appears.",
		"Rushing sand envelops you, and it becomes hard to see!"
	)
	outdoor_sounds_type = /datum/looping_sound/weather/outside_blizzard
	indoor_sounds_type = /datum/looping_sound/weather/inside_blizzard
