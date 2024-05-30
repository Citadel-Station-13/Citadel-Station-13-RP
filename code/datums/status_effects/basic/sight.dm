/**
 * Sight impairments that are currently handled by wierd procs they dont really fit into
 */
/datum/status_effect/sight/blindness
	identifier = "Blindness"

/datum/status_effect/sight/blindness/on_apply()
	. = ..()
	owner.overlay_fullscreen("blind", /atom/movable/screen/fullscreen/scaled/blind)

/datum/status_effect/sight/blindness/on_remove()
	. = ..()
	owner.clear_fullscreen("blind")

