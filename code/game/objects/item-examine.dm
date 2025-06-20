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
