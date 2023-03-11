/datum/world_sector/hardcoded/class_h
	atmosphere = /datum/atmosphere/planet/class_h
	seconds_in_day = HOURS_TO_SECONDS(24)
	weather_holder = /datum/weather_holder/class_h

/datum/weather_holder/class_h
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
					light_color = "#b2aaa6";
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
					light_color = "#ad2e18";
					light_power = 0.7;
					phase_power = 0.6;
				},
			);
		}
	)

/datum/atmosphere/planet/class_h
	base_gases = list(
		/datum/gas/oxygen = 0.24,
		/datum/gas/nitrogen = 0.72,
		/datum/gas/carbon_dioxide = 0.04,
	)
	base_target_pressure = 110.1
	minimum_pressure = 110.1
	maximum_pressure = 110.1
	minimum_temp = 317.3 //Barely enough to avoid baking Teshari
	maximum_temp = 317.3
