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
	var/transition_next
	/// weather transition rate - please don't set this too low. this is added to the datum's speed.
	var/transition_speed = 8 MINUTES
	/// obey weather-specific transition multipliers
	var/transition_override = FALSE
	/// weather instances by path - these are typepaths, init'd on holder init.
	/// we don't globally cache weather so vv and modifications are easy.
	var/list/weather_datums
	/// transition chances: path = list(otherpath = chance, otherpath = chance), ...
	/// this must work with pickweight
	//  todo: unit test that weather_datums contains everything in here.
	var/list/weather_transitions
	/// chances of weather at roundstart / load; null = pick randomly with even chance.
	var/list/weather_roundstart
	/// override what we're going to next
	var/datum/weather_next
	/// forecast - weather *instances*.
	var/list/forecast
	/// forecast size
	var/forecast_size = 3

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

/datum/weather_holder/New(datum/world_sector/sector)
	src.sector = sector
	init_weather

//? core

/datum/weather_holder/proc/init_weather()
	LAZYINITLIST(weather_datums)
	var/list/built = list()
	for(var/thing in weather_datums)
		if(ispath(thing, /datum/weather))
			built[thing] = new thing
		else if(istype(thing, /datum/weather))
			var/datum/weather/instance = thing
			built[instance.type] = instance
		else
			stack_trace("unexpected [thing] in weather datums not /datum/weather or path to such; skipping.")
	weather_datums = built()

/**
 * set current weather
 */
/datum/weather_holder/proc/set_weather(datum/weather/new_weather)
	#warn impl


#warn impl all

/datum/weather_holder/proc/build_forecast()
	forecast_size = clamp(forecast_size, 0, 10)
	LAZYINITLIST(forecast)
	if(length(forecast) >= forecast_size)
		return
	while(length(forecast) < forecast_size)

	#warn impl

/**
 * random path to roundstart weather
 */
/datum/weather_holder/proc/random_roundstart_weather_type()
	return length(weather_roundstart)? pickweight(weather_roundstart) : (length(weather_datums)? pick(weather_datums) : null)

/**
 * gets our next weather based on probabilities set in transitions
 *
 * @params
 * * override - path or instance to use instead
 */
/datum/weather_holder/proc/next_weather(datum/weather/override)
	var/effective_path = override?.type || active?.type || random_roundstart_weather_type()
	if(!effective_path)
		// what?
		return
	var/list/probabilities = weather_transitions?[effective_path]
	var/path
	if(length(probabilities))
		path = pickweight(probabilities)
	else
		stack_trace("no probabilities on [path], defaulting.")
		path = random_roundstart_weather_type()
	. = weather_datums[path]
	if(!.)
		stack_trace("no datum for [path], nulling.")

/datum/weather_holder/proc/advance_weather()
	if(!length(forecast))
		build_forecast()
	if(!length(forecast))
		return
	set_weather(forecast[1])
	forecast.Cut(1, 2)
	build_forecast()

/datum/weather_holder/proc/on_weather_change()
	#warn impl

/datum/weather_holder/proc/tick(delta_time)
	#warn impl

//? visuals

#warn impl
