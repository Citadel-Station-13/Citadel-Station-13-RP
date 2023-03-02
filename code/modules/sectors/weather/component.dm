/**
 * stuff like lightning, fallout, etc
 *
 * always instanced on weather start, but *not* re-instanced when weather doesn't change to a different one and continues.
 */
/datum/weather_component
	/// requires ticking
	var/requires_ticking = FALSE
	#warn impl

#warn hook
/datum/weather_component/proc/on_start(datum/weather/weather, datum/weather_holder/holder)
	return

#warn hook
/datum/weather_component/proc/on_end(datum/weather/weather, datum/weather_holder/holder)
	return

#warn hook
/datum/weather_component/proc/on_tick(datum/weather/weather, datum/weather_holder/holder)
	return
