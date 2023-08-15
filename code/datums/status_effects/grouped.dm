/**
 * ## Grouped Status Effects
 *
 * status effects that can track source.
 *
 * this and all subtypes have `source` as an argument on apply.
 */
/datum/status_effect/grouped
	abstract_type = /datum/status_effect/grouped
	/// sources list - associated to arbitrary values that evaluate to TRUE.
	var/list/sources = list()
	/// sources associated to time of expiry
	var/list/expires = list()
	/// sources associated to timerid
	var/list/timers = list()

/datum/status_effect/grouped/on_apply(source, value, duration, ...)
	apply_source(source, value, duration)
	return ..()

/datum/status_effect/grouped/on_refreshed(old_timeleft, source, value, duration, ...)
	apply_source(source, value, duration)
	return ..()

/datum/status_effect/grouped/rebuild_decay_timer()
	return // we don't use this.

/datum/status_effect/grouped/proc/has_source(source)
	return !isnull(sources[source])

/datum/status_effect/grouped/proc/remove_source(source, expiring)
	if(!has_source(source))
		return FALSE
	var/old = sources[source]
	sources -= source
	if(expires[source])
		expires -= source
		deltimer(timers[source])
		timers -= source
	on_change(source, old, null)
	if(!length(sources))
		qdel(src)
	return TRUE

/datum/status_effect/grouped/proc/apply_source(source, value, duration = src.duration)
	var/old = sources[source]
	sources[source] = value
	var/old_expires = expires[source]
	if(old_expires)
		if((old_expires - world.time) < duration)
			// refresh
			deltimer(timers[source])
			if(duration)
				expires[source] = world.time + duration
				timers[source] = addtimer(CALLBACK(src, PROC_REF(remove_source), source, TRUE), duration, TIMER_STOPPABLE)
	else if(!old && (duration > 0))
		// didn't exist, set
		expires[source] = world.time + duration
		timers[source] = addtimer(CALLBACK(src, PROC_REF(remove_source), source, TRUE), duration, TIMER_STOPPABLE)
	on_change(source, old, value)

/datum/status_effect/grouped/proc/set_source(source, value, duration = src.duration)
	if(isnull(value))
		// autodetect if we're just setting duration
		value = sources[source]
		if(isnull(value))
			return FALSE // just a duration set and it ain't there
	var/old = sources[source]
	sources[source] = value
	var/old_expires = expires[source]
	if(old_expires)
		deltimer(timers[source])
		timers -= source
		expires -= source
	if(duration > 0)
		expires[source] = world.time + duration
		timers[source] = addtimer(CALLBACK(src, PROC_REF(remove_source), source, TRUE), duration, TIMER_STOPPABLE)
	if(old != value)
		on_change(source, old, value)
	return TRUE

/**
 * called on a change of source or value.
 *
 * @params
 * * source - source
 * * old_value - what value was before ; null if we're adding the source for the first time.
 * * new_value - what value is now ; null if we're removing the source.
 */
/datum/status_effect/grouped/proc/on_change(source, old_value, new_value)
	return

//? Mob procs

/**
 * adds or contributes to a grouped status effect
 *
 * @params
 * * source - source of application; must be text
 * * value - metadata; must be non-null
 * * duration - duration override, otherwise we use default of the path.
 * * ... - additional args
 *
 * @return effect datum
 */
/mob/proc/apply_grouped_effect(datum/status_effect/grouped/path, source, value, duration, ...)
	if(!ispath(path, /datum/status_effect/grouped))
		CRASH("[path] is not a grouped effect.")
	return apply_status_effect(path, additional = args.Copy(2))

/**
 * removes a source from a grouped effect
 *
 * the effect is fully removed upon all sources being removed.
 *
 * @return TRUE if a source was removed
 */
/mob/proc/remove_grouped_effect(datum/status_effect/grouped/path, source)
	if(!ispath(path, /datum/status_effect/grouped))
		CRASH("[path] is not a grouped effect.")
	var/datum/status_effect/grouped/effect = has_status_effect(path)
	return effect.remove_source(source)
