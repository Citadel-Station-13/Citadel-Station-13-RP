/datum/world_sector/hardcoded/class_m
	name = "Class-M Planet - Hardcoded"
	player_name = "Class-M Gaia Planet"
	player_desc = "A beautiful, lush planet that is owned by the Happy Days and Sunshine Corporation."
	seconds_in_day = HOURS_TO_SECONDS(3)
	atmosphere = /datum/atmosphere/planet/class_m
	cycles = list(
		/datum/sector_cycle/sun/main{
			phases = list(
				/datum/sector_phase{ // night
					relative_ratio = 0.4;
					light_color = "#000000";
					light_power = 0;
					temperature_adjust = -5;
					phase_power = 0;
				},
				/datum/sector_phase{ // morning
					relative_ratio = 0.2;
					light_color = "#AA3300";
					light_power = 0.7;
					phase_power = 0.75;
				},
				/datum/sector_phase{ // noon
					relative_ratio = 0.2;
					light_color = "#EEEEEE";
					light_power = 1;
					temperature_adjust = 3;
					phase_power = 1;
				},
				/datum/sector_phase{ // evening
					relative_ratio = 0.2;
					light_color = "#ba5b2f";
					light_power = 0.7;
					phase_power = 0.6;
				},
			);
		}
	)
	weather_holder = /datum/weather_holder/class_m

/datum/weather_holder/class_m
	weather_datums = list(
		/datum/weather/clear,
		/datum/weather/cloudy/light,
		/datum/weather/cloudy/moderate,
		/datum/weather/cloudy/severe,
		/datum/weather/rain/light,
		/datum/weather/rain/moderate,
		/datum/weather/rain/severe,
		/datum/weather/rain/thunderstorm,
	)
	weather_roundstart = list(
		/datum/weather/clear = 75,
		/datum/weather/cloudy/light = 15,
		/datum/weather/cloudy/moderate = 10,
		/datum/weather/cloudy/severe = 5,
		/datum/weather/rain/light = 5,
		/datum/weather/rain/moderate = 2.5,
		/datum/weather/rain/severe = 2.5,
		/datum/weather/rain/thunderstorm = 2.5,
	)
	weather_transitions = list(
		/datum/weather/clear = list(
			/datum/weather/clear = 80,
			/datum/weather/cloudy/light = 20,
			/datum/weather/cloudy/moderate = 5,
			/datum/weather/cloudy/severe = 5,
		),
		/datum/weather/cloudy/light = list(
			/datum/weather/rain/light = 20,
			/datum/weather/cloudy/light = 80,
			/datum/weather/cloudy/moderate = 20,
			/datum/weather/clear = 20,
		),
		/datum/weather/cloudy/moderate = list(
			/datum/weather/cloudy/light = 20,
			/datum/weather/cloudy/moderate = 80,
			/datum/weather/clear = 10,
			/datum/weather/rain/light = 20,
			/datum/weather/rain/moderate = 10,
			/datum/weather/rain/severe = 10,
			/datum/weather/rain/thunderstorm = 5,
		),
		/datum/weather/cloudy/severe = list(
			/datum/weather/cloudy/severe = 40,
			/datum/weather/rain/moderate = 20,
			/datum/weather/rain/thunderstorm = 20,
			/datum/weather/rain/light = 10,
			/datum/weather/cloudy/moderate = 20,
		),
		/datum/weather/rain/light = list(
			/datum/weather/rain/light = 80,
			/datum/weather/clear = 20,
			/datum/weather/cloudy/light = 20,
			/datum/weather/rain/moderate = 20,
		),
		/datum/weather/rain/moderate = list(
			/datum/weather/rain/light = 20,
			/datum/weather/rain/moderate = 80,
			/datum/weather/cloudy/moderate = 10,
			/datum/weather/clear = 10,
		),
		/datum/weather/rain/severe = list(
			/datum/weather/rain/thunderstorm = 20,
			/datum/weather/rain/severe = 80,
			/datum/weather/rain/moderate = 20,
		),
		/datum/weather/rain/thunderstorm = list(
			/datum/weather/rain/thunderstorm = 50,
			/datum/weather/rain/severe = 40,
		)
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
