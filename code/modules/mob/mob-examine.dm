//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/pre_examine(datum/event_args/examine/examine, examine_for, examine_from)
	examine = ..()

	var/total_inv_hide = NONE
	var/total_body_cover = NONE

	var/skip_gear = NONE
	var/skip_body = NONE

	for(var/obj/item/item as anything in get_equipped_items())
		total_inv_hide |= item.inv_hide_flags
		total_body_cover |= item.body_cover_flags

	if(total_inv_hide & HIDESUITSTORAGE)
		skip_gear |= EXAMINE_SKIPSUITSTORAGE
	if(total_inv_hide & HIDEJUMPSUIT)
		skip_body |= EXAMINE_SKIPARMS | EXAMINE_SKIPLEGS | EXAMINE_SKIPBODY | EXAMINE_SKIPGROIN
		skip_gear |= EXAMINE_SKIPJUMPSUIT | EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER
	if(total_inv_hide & HIDETIE)
		skip_gear |= EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER
	if(total_inv_hide & HIDEHOLSTER)
		skip_gear |= EXAMINE_SKIPHOLSTER
	if(total_inv_hide & HIDESHOES)
		skip_gear |= EXAMINE_SKIPSHOES
		skip_body |= EXAMINE_SKIPFEET
	if(total_inv_hide & HIDEGLOVES)
		skip_gear |= EXAMINE_SKIPGLOVES
		skip_body |= EXAMINE_SKIPHANDS
	if(total_inv_hide & HIDEMASK)
		skip_gear |= EXAMINE_SKIPMASK
	if(total_inv_hide & HIDEEYES)
		skip_gear |= EXAMINE_SKIPEYEWEAR
		skip_body |= EXAMINE_SKIPEYES
	if(total_inv_hide & HIDEEARS)
		skip_gear |= EXAMINE_SKIPEARS
	if(total_inv_hide & HIDEFACE)
		skip_body |= EXAMINE_SKIPFACE

	if(total_body_cover & LEGS)
		skip_body |= EXAMINE_SKIPLEGS
	if(total_body_cover & ARMS)
		skip_body |= EXAMINE_SKIPARMS
	if(total_body_cover & UPPER_TORSO)
		skip_body |= EXAMINE_SKIPBODY
	if(total_body_cover & LOWER_TORSO)
		skip_body |= EXAMINE_SKIPGROIN
	if(total_body_cover & HANDS)
		skip_body |= EXAMINE_SKIPHANDS
	if(total_body_cover & FEET)
		skip_body |= EXAMINE_SKIPFEET

	examine.legacy_examine_skip_body = skip_body
	examine.legacy_examine_skip_gear = skip_gear

	return examine

/mob/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()

	#warn impl

	var/datum/gender/using_gender = get_visible_gender()

	if(examine_for & EXAMINE_FOR_WORN)
		for(var/id in get_inventory_slot_ids())
			var/datum/inventory_slot/slot = resolve_inventory_slot(id)
			var/obj/item/equipped = inventory.get_slot_single(id)

			var/html = slot.examinate(src, equipped, examine, examine_for, examine_from)
			if(html)
				output.worn += html

	return output
