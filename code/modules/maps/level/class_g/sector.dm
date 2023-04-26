/datum/world_sector/hardcoded/class_g
	name = "Class-G Planet - Hardcoded"
	player_name = "Class-G Mineral Rich Planet"
	player_desc = "A mineral rich planet with a volatile atmosphere."
	atmosphere = /datum/atmosphere/planet/class_g
	seconds_in_day = HOURS_TO_SECONDS(3)
	weather_holder = /datum/weather_holder/class_g

/datum/weather_holder/class_g
	allowed_weather_types = list(
		/datum/weather/clear
	)

/datum/atmosphere/planet/class_g
	base_gases = list(
		/datum/gas/oxygen = 10,
		/datum/gas/nitrogen = 10,
		/datum/gas/phoron = 80,
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 293.3
	maximum_temp = 307.3

