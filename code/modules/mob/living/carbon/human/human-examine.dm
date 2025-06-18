//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/human/pre_examine(datum/event_args/examine/examine, examine_for, examine_from)
	. = ..()
	if(. != src)
		return

#warn impl all
