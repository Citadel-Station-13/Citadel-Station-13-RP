//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * @return html to put in "[his] [output]." Example: "[his] [right arm looks like it's swollen and bruised]."
 */
/obj/item/organ/external/proc/examine_encoding_as_visible_organ(datum/event_args/examine/examine, examine_for, examine_from, only_if_injured)
	var/list/injury_descriptors = examine_get_injury_descriptors(examine, examine_for, examine_from)
	if(!length(injury_descriptors) && only_if_injured)
		return null
	var/datum/event_args/examine_output/output = examine_new(examine, EXAMINE_FOR_NAME, EXAMINE_FROM_ATTACHED)
	. = list("[examine.live_examine ? FORMAT_TEXT_LOOKITEM_NAME(src, "[output.entity_name]") : "[output.entity_name]"])")
	if(length(injury_descriptors))
		. += " looks like it's [english_list(examine_get_injury_descriptors(examine, examine_for, examine_from))]"
	else
		. += " looks okay"

/obj/item/organ/external/examine_get_injury_descriptors(datum/event_args/examine/examine, examine_for, examien_from)
	. = ..()
	if(dislocated == 2)
		. += SPAN_WARNING("dislocated")
	if(brute_dam > min_broken_damage && (status & (ORGAN_BROKEN | ORGAN_MUTATED)))
		. += SPAN_WARNING("dented and swollen")
	if(splinted)
		. += SPAN_WARNING("[examine.live_examine ? "[FORMAT_TEXT_LOOKITEM(splinted)]" : "[splinted]"]")
