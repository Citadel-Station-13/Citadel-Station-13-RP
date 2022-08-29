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

/datum/component/riding_handler/mob
	expected_typepath = /mob
