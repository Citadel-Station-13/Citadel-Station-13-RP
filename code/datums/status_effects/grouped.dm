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

#warn what

/datum/status_effect/grouped/on_creation(mob/living/new_owner, source)
	var/datum/status_effect/grouped/existing = new_owner.has_status_effect(type)
	if(existing)
		existing.sources |= source
		qdel(src)
		return FALSE
	else
		sources |= source
		return ..()

/datum/status_effect/grouped/before_remove(source)
	sources -= source
	return !length(sources)

/datum/status_effect/grouped/proc/has_source(source)
	return !isnull(sources[source])

/datum/status_effect/grouped/proc/remove_source(source)
	if(!has_source(source))
		return FALSE
	sources -= source
	#warn impl timer stuff and whatever
	if(expires[source])
		expires -= source
		deltimer(timers[source])
		timers -= source
	if(!length(sources))
		qdel(src)
	return TRUE

/datum/status_effect/grouped/proc/apply_source(source, value, duration = src.duration)
	// source can technically be any non-number value, but to enforce code durability
	// we don't want any del'able reference types.
	ASSERT(istext(source) && !isnull(value))
	sources[source] = value
	#warn impl timer stuff and whatever


#warn impl all

//? Mob procs

/**
 * adds or contributes to a grouped status effect
 *
 * @params
 * * source - source of application; must be text
 * * value - metadata; must be non-null
 * * duration - duration override, otherwise we use default of the path.
 *
 * @return effect datum
 */
/mob/proc/apply_grouped_effect(datum/status_effect/grouped/path, source, value, duration)
	if(!ispath(path, /datum/status_effect/grouped))
		CRASH("[path] is not a grouped effect.")
	ASSERT(istext(source) && !isnull(value))
	return apply_status_effect(path, additional = list(source, value))

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
	ASSERT(istext(source))
	var/datum/status_effect/grouped/effect = has_status_effect(path)
	return effect.remove_source(source)
