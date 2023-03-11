/datum/world_sector/hardcoded/class_m
	name = "Class-M Planet - Hardcoded"
	player_name = "Class-M Gaia Planet"
	player_desc = "A beautiful, lush planet that is owned by the Happy Days and Sunshine Corporation."
	seconds_in_day = HOURS_TO_SECONDS(3)
	atmosphere = /datum/atmosphere/planet/class_m
	cycles = list(
		/datum/sector_cycle/sun/main{
			phases = list(
				/datum/sector_phase{
					#warn impl
				},
			)
		}
	)

/datum/atmosphere/planet/class_m
	base_gases = list(
		/datum/gas/oxygen = 0.22,
		/datum/gas/nitrogen = 0.78,
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 293.3
	maximum_temp = 307.3
