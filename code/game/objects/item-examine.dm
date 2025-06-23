//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	if(examine_from & (EXAMINE_FROM_WORN | EXAMINE_FROM_STRIP))
		if(item_flags & (ITEM_ABSTRACT | ITEM_FLAG_HIDE_WORN_EXAMINE))
			return null
	var/datum/event_args/examine_output/output = ..()



	#warn how do we do 1. warning on blood stained and 2. examine link?
	#warn oil-stained? synth blood color check?
	return output

/**
 * * Also called if held.
 * @return html
 */
/obj/item/proc/examine_encoding_as_worn(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = examine_new(examine, examine_for, examine_from)
	#warn impl

	// if(shoes && !(skip_gear & EXAMINE_SKIPGEAR_SHOES) && shoes.show_examine)
	// 	if(shoes.blood_DNA)
	// 		. += SPAN_WARNING("[icon2html(shoes, user)] [T.He] [T.is] wearing [shoes.gender == PLURAL ? "some" : "a"] [(shoes.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(shoes)] on [T.his] feet!")
	// 	else
	// 		. += SPAN_INFO("[icon2html(shoes, user)] [T.He] [T.is] wearing \a [FORMAT_TEXT_LOOKITEM(shoes)] on [T.his] feet.")

/**
 * @return html
 */
/obj/item/proc/examine_encoding_as_embed(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = examine_new(examine, examine_for, examine_from)
	#warn impl

