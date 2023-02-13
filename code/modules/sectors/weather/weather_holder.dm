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

	//? ticking
	/// ticking blackboard for general ticking - wiped on weather switch.
	/// it wouldn't be hard to retain it on switch but we choose not to.
	/// you should *not* use this for mobs/turfs, there's almost no reason to.
	var/list/tick_data
	//* general ticks have priority 1
	var/tick_last
	//* mob ticks have priority 2
	/// last mob tick start
	var/tick_mobs_last
	/// tracks mob ticking - simple, this is basically our currentrun list
	var/list/tick_mobs_left
	/// last turf tick start
	var/tick_turfs_last
	/// tracks

/**
 * set current weather
 */
/datum/weather_holder/proc/set_weather(datum/weather/new_weather)
	#warn impl


#warn impl all
