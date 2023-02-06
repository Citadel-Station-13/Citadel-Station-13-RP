/**
 * weather holders
 *
 * holds weather for world sectors
 * allocated per sector
 */
/datum/weather_holder
	//? basics
	/// our sector
	var/datum/world_sector/sector
	/// active weather, if any
	var/datum/weather/active

	//? transitions
	/// weather instances

	//? visuals


/**
 * set current weather
 */
/datum/weather_holder/proc/set_weather(datum/weather/new_weather)
	#warn impl

