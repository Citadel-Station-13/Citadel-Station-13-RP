//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/human/pre_examine(datum/event_args/examine/examine, examine_for, examine_from)
	. = ..()
	if(. != src)
		return

#warn impl all

/mob/living/carbon/human/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()

	if(!examine.legacy_examine_no_touch)
		#warn pulse?
		pass()

	if(nif?.examine_msg)
		LAZYADD(output.worn_descriptors, SPAN_NOTICE("[nif.examine_msg]"))

	LAZYADD(output.ooc_descriptors, SPAN_BOLDNOTICE("Character Profile: <a href='?src=\ref[src];character_profile=1'>\[View\]</a>"))

	return output
