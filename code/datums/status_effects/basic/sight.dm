/**
 * Sight impairments that are currently handled by wierd procs they dont really fit into
 */
/datum/status_effect/sight/blindness
	identifier = "Blindness"

/datum/status_effect/sight/blindness/on_apply()
	. = ..()
	owner.add_blindness_source(TRAIT_BLINDNESS_STATUS_EFF)

/datum/status_effect/sight/blindness/on_remove()
	. = ..()
	owner.remove_blindness_source(TRAIT_BLINDNESS_STATUS_EFF)

