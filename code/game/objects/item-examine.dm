//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	if(examine_from & (EXAMINE_FROM_ATTACHED | EXAMINE_FROM_STRIP))
		if(item_flags & (ITEM_ABSTRACT | ITEM_FLAG_HIDE_WORN_EXAMINE))
			return null
	var/datum/event_args/examine_output/output = ..()



	#warn how do we do 1. warning on blood stained and 2. examine link?
	#warn oil-stained? synth blood color check?
	return output

/**
 * * Also called if held.
 * @return /datum/event_args/examine_output
 */
/obj/item/proc/examine_as_worn(datum/event_args/examine/examine, examine_for, examine_from)
	if(item_flags & (ITEM_ABSTRACT | (isnum(inv_slot_or_index) ? NONE : ITEM_FLAG_HIDE_WORN_EXAMINE)))
		return null
	var/datum/event_args/examine_output/output = examine_new(examine, examine_for | EXAMINE_FOR_NAME, EXAMINE_FROM_ATTACHED)

	var/use_name = output.entity_name
	var/use_appearance = output.entity_appearance
	#warn render

	if(blood_DNA)
		// todo: this is shit, do it better
		var/blood_render = blood_color == SYNTH_BLOOD_COLOUR ? "<i><font color='grey'>oil-stained</font></i>" : "<i><font color='red'>blood-staioned</font></i>"
		return "a [blood_render] [ENCODE_ATOM_HREFEXAMINE_NAME(src, "[use_name]")]"
	else
		return ENCODE_ATOM_HREFEXAMINE_NAME(src, "\a [use_name]")

/**
 * @return html
 */
/obj/item/proc/examine_encoding_as_embed(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = examine_new(examine, EXAMINE_FOR_NAME | EXAMINE_FOR_RENDER, EXAMINE_FROM_ATTACHED)
	return ENCODE_ATOM_HREFEXAMINE_NAME(src, "\a [src]")

