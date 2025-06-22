//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/pre_examine(datum/event_args/examine/examine, examine_for, examine_from)
	. = ..()
	if(. != src)
		return

#warn impl all

/mob/living/carbon/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()

	if(!examine.legacy_examine_no_touch)
		pass()

	if(pose)
		LAZYADD(output.visible_descriptors, SPAN_INFO("[T.He] [pose]"))

	return output
