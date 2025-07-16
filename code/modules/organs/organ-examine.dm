//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/organ/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()
	#warn uhh

	return output

/obj/item/organ/proc/examine_get_injury_descriptors(datum/event_args/examine/examine, examine_for, examien_from)
	. = list()
	if(germ_level > INFECTION_LEVEL_TWO && !(status & ORGAN_DEAD))
		. += SPAN_WARNING("very infected")
	else if(status & ORGAN_DEAD)
		. += SPAN_DANGER("rotten")
	if(status & ORGAN_BLEEDING)
		. += SPAN_WARNING("bleeding")
