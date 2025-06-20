//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()
	if(fire_stacks)
		LAZYADD(output.visible_descriptors, SPAN_WARNING("[gender_datum_visible.He] [gender_datum_visible.is] soaking wet."))
	if(on_fire)
		LAZYADD(output.visible_descriptors, SPAN_DANGER("[gender_datum_visible.He] [gender_datum_visible.is] on fire!."))
	return output
