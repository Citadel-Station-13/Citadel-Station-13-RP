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
	/// next weather transition
	var/next_transition
	/// weather instances by path - these are typepaths, init'd on holder init.
	/// we don't globally cache weather so vv and modifications are easy.
	var/list/weather_datums
	/// transition chances: path = list(otherpath = chance, otherpath = chance), ...
	/// this must work with pickweight
	//  todo: unit test that weather_datums contains everything in here.
	var/list/weather_transitions

	//? visuals

	//? ticking
	//* general ticks have priority 1
	/// ticking blackboard for general ticking - wiped on weather switch.
	/// it wouldn't be hard to retain it on switch but we choose not to.
	/// you should *not* use this for mobs/turfs, there's almost no reason to.
	var/list/tick_data
	//* mob ticks have priority 2
	/// tracks mob ticking - simple, this is basically our currentrun list
	var/list/tick_mobs_cached
	//* turf ticks have priority 3
	/// smoothing - about how many we want to tick, per decisecond
	var/tick_turfs_speed
	/// smoothing - how many we want to tick (this is also how we do catchup and provides an upper bound to catchup)
	var/tick_turfs_left = 0
	/// tracks turf ticking - simple, this is basically our currentrun list
	var/list/tick_turfs_cached

	#warn impl all

/**
 * set current weather
 */
/datum/weather_holder/proc/set_weather(datum/weather/new_weather)
	#warn impl


#warn impl all
