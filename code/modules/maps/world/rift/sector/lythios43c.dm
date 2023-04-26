/datum/world_sector/hardcoded/lythios_43c
	name = "Lythios-43c - Hardcoded"
	player_name = "Lythios-43c"
	player_desc = "A freezing arctic hellscape.."
	seconds_in_day = HOURS_TO_SECONDS(10)
	atmosphere = /datum/atmosphere/planet/lythios_43c
	weather_holder = /datum/weather_holder/lythios_43c

/datum/weather_holder/lythios_43c
	#warn impl

/datum/atmosphere/planet/lythios_43c
	base_gases = list(
		/datum/gas/nitrogen = 0.66,
		/datum/gas/oxygen = 0.34,
	)
	base_target_pressure = 76.9
	minimum_pressure = 76.9
	maximum_pressure = 76.9
	minimum_temp = 220.14
	maximum_temp = 241.72
