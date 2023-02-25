/datum/world_sector/virgo_3b
	name = "Virgo-3B"
	id = "virgo_3b"
	desc = "A mid-sized moon of the Virgo 3 gas giant, this planet has an atmosphere mainly comprised of phoron, with trace \
	amounts of both oxygen and nitrogen. Fortunately, the oxygen is not enough to be combustible in any meaningful way, however \
	the phoron is desirable by many corporations, including NanoTrasen."

	seconds_in_day = HOURS_TO_SECONDS(6)

	weather_holder = /datum/weather_holder/virgo_3b
	atmosphere = /datum/atmosphere/planet/virgo_3b

/datum/atmosphere/planet/virgo_3b
	base_gases = list(
		/datum/gas/nitrogen = 0.16,
		/datum/gas/phoron = 0.72,
		/datum/gas/carbon_dioxide = 0.12,
	)
	base_target_pressure = 82.4
	minimum_pressure = 82.4
	maximum_pressure = 82.4
	minimum_temp = 234
	maximum_temp = 234

/datum/weather_holder/virgo_3b
	weather_datums = list(
	)
	weather_transitions = list(
	)
	weather_roundstart = list(
	)
