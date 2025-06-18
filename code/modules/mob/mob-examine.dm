//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()

	#warn impl

	var/datum/gender/using_gender = get_visible_gender()

	for(var/id in get_inventory_slot_ids())
		var/datum/inventory_slot/slot = resolve_inventory_slot(id)
		var/obj/item/equipped = inventory.get_slot_single(id)

		var/html = slot.examinate(src, equipped, examine, examine_for, examine_from)
		if(html)
			output.worn += html

	return output
