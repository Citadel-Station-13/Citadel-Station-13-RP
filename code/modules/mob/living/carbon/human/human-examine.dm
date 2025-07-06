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

	if(length(blood_DNA) && !(examine.legacy_examine_skip_body & EXAMINE_SKIPBODY_HANDS))
		var/blood_name = "blood"
		if(hand_blood_color == SYNTH_BLOOD_COLOUR)
			blood_name = "oil"
		var/blood_render = "<font color='[hand_blood_color]'>[blood_name]</font>"
		LAZYADD(output.out_visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] [gender_datum_visible.has] [blood_render]-stained hands."))
	if(length(feet_blood_DNA) && !(examine.legacy_examine_skip_body & EXAMINE_SKIPBODY_FEET))
		var/blood_name = "blood"
		if(feet_blood_color == SYNTH_BLOOD_COLOUR)
			blood_name = "oil"
		var/blood_render = "<font color='[feet_blood_color]'>[blood_name]</font>"
		LAZYADD(output.out_visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] [gender_datum_visible.has] [blood_render]-stained feet."))

	if(nif?.examine_msg)
		LAZYADD(output.out_worn_descriptors, SPAN_NOTICE("[nif.examine_msg]"))

	var/list/descriptors = show_descriptors_to(examine.examiner)
	if(length(descriptors))
		LAZYADD(output.out_visible_descriptors, SPAN_NOTICE(jointext(descriptors, "<br>")))

	LAZYADD(output.out_ooc_descriptors, SPAN_BOLDNOTICE("Character Profile: <a href='?src=\ref[src];character_profile=1'>\[View\]</a>"))

	return output
