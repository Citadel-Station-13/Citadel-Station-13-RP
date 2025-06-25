//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/organ/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()
	#warn uhh

	return output

/obj/item/organ/proc/examine_get_descriptor_strings(datum/event_args/examine/examine, examine_for, examien_from)
