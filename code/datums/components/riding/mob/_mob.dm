/**
 * riding filters for mobs
 *
 * can require offhands on mobs and the person riding
 */
/datum/component/riding_filter/mob
	expected_typepath = /mob
	handler_typepath = /datum/component/riding_handler/mob

	/// base number of offhands required on us
	var/offhands_needed_base = 0
	/// offhands required on us per mob buckled
	var/offhands_needed_per = 0

/datum/component/riding_filter/mob/check_offhands(mob/rider)
	// we do our checks first, as they're cheaper in cases of riders > 1
	if(!offhands_needed_base && !offhands_needed_per)
		return ..()
	var/mob/M = parent
	var/needed = offhands_needed_base + length(M.buckled_mobs)

	#warn impl

	return ..()

/datum/component/riding_handler/mob
	expected_typepath = /mob

#warn we're going to need to make laying down be able to kick people off if needed
