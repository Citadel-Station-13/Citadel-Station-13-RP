var/datum/planet/classg/planet_classg = null

/datum/time/classg
	seconds_in_day = 3 HOURS

/datum/planet/classg
	name = "Class-G Mineral Rich Planet"
	desc = "A mineral rich planet with a volatile atmosphere."
	current_time = new /datum/time/classg()
	expected_z_levels = list(15)

/datum/planet/classg/New()
	..()
	planet_classg = src
	weather_holder = new /datum/weather_holder/classg(src)

/datum/planet/classg/update_sun()
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

/datum/weather_holder/classg
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR		= new /datum/weather/classg/clear(),
		//WEATHER_FALLOUT		= new /datum/weather/classg/fallout()
		)
	roundstart_weather_chances = list(
		WEATHER_CLEAR		= 100
		//WEATHER_FALLOUT		= 25
		)

/datum/weather/classg
	name = "classg base"
	temp_high	= 203
	temp_low 	= 203

/datum/weather/classg/clear
	name = "clear"
	transition_chances = list(
		WEATHER_CLEAR	 = 100
		//WEATHER_FALLOUT	 = 35
		)
	transition_messages = list(
		//"The radioactive storm clears.",
		//"The stars are visible once more.",
		)
	sky_visible = TRUE
	observed_message = "The stars are visible overhead."

/*
/datum/weather/classg/fallout
	name = "fallout"
	icon_state = "fallout"
	light_modifier = 0.7
	light_color = "#CCFFCC"
	flight_failure_modifier = 30
	transition_chances = list(
		WEATHER_CLEAR	= 50,
		WEATHER_FALLOUT = 50
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

/datum/weather/classg/fallout/process_effects()
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
/datum/weather/classg/fallout/proc/irradiate_nearby_turf(mob/living/L)
	if(!istype(L))
		return
	var/list/turfs = RANGE_TURFS(world.view, L)
	var/turf/T = pick(turfs) // We get one try per tick.
	if(!istype(T))
		return
	if(T.outdoors)
		SSradiation.radiate(T, rand(fallout_rad_low, fallout_rad_high))
*/

// Shuttle Path for Mining Planet

// -- Datums -- //
/*/obj/effect/overmap/visitable/sector/classg
	name = "Mineral Rich Planet"			// The name of the destination
	desc = "Sensors indicate that this is a world filled with minerals.  There seems to be a thin atmosphere on the planet."
	icon_state = "globe"
	color = "#4e4e4e"	// Bright yellow
	initial_generic_waypoints = list("poid_main")
*/

// This is a special subtype of the thing that generates ores on a map
// It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/classg
	descriptor = "Mining planet mine ore distribution map"
	deep_val = 0.6 //More riches, normal is 0.7 and 0.8
	rare_val = 0.4

// The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/classg/check_map_sanity()
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
