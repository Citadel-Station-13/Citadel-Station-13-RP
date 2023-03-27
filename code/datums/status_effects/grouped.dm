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

/// Gets and formats examine text associated with our status effect.
/// Return 'null' to have no examine text appear (default behavior).
/datum/status_effect/proc/get_examine_text()
	return null
