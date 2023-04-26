/**
 * stuff like lightning, fallout, etc
 *
 * always instanced on weather start, but *not* re-instanced when weather doesn't change to a different one and continues.
 */
/datum/weather_component
	/// requires ticking general
	var/ticks_general = FALSE
	/// requires ticking mobs
	var/ticks_mobs = FALSE
	#warn impl

#warn hook
/datum/weather_component/proc/on_start(datum/weather_holder/holder)
	return

#warn hook
/datum/weather_component/proc/on_end(datum/weather_holder/holder)
	return

#warn hook
/datum/weather_component/proc/on_general_tick(datum/weather_holder/holder)
	return

#warn hook
/datum/weather_component/proc/on_mob_tick(datum/weather_holder/holder, mob/M)
	return
