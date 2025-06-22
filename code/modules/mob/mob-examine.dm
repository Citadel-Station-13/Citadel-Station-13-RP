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
		skip_gear |= EXAMINE_SKIPGEAR_SUITSTORAGE
	if(total_inv_hide & HIDEJUMPSUIT)
		skip_body |= EXAMINE_SKIPBODY_ARMS | EXAMINE_SKIPBODY_LEGS | EXAMINE_SKIPBODY_BODY | EXAMINE_SKIPBODY_GROIN
		skip_gear |= EXAMINE_SKIPGEAR_JUMPSUIT | EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER
	if(total_inv_hide & HIDETIE)
		skip_gear |= EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER
	if(total_inv_hide & HIDEHOLSTER)
		skip_gear |= EXAMINE_SKIPHOLSTER
	if(total_inv_hide & HIDESHOES)
		skip_gear |= EXAMINE_SKIPGEAR_SHOES
		skip_body |= EXAMINE_SKIPBODY_FEET
	if(total_inv_hide & HIDEGLOVES)
		skip_gear |= EXAMINE_SKIPGEAR_GLOVES
		skip_body |= EXAMINE_SKIPBODY_HANDS
	if(total_inv_hide & HIDEMASK)
		skip_gear |= EXAMINE_SKIPGEAR_MASK
	if(total_inv_hide & HIDEEYES)
		skip_gear |= EXAMINE_SKIPGEAR_EYEWEAR
		skip_body |= EXAMINE_SKIPBODY_EYES
	if(total_inv_hide & HIDEEARS)
		skip_gear |= EXAMINE_SKIPGEAR_EARS
	if(total_inv_hide & HIDEFACE)
		skip_body |= EXAMINE_SKIPBODY_FACE

	if(total_body_cover & LEGS)
		skip_body |= EXAMINE_SKIPBODY_LEGS
	if(total_body_cover & ARMS)
		skip_body |= EXAMINE_SKIPBODY_ARMS
	if(total_body_cover & UPPER_TORSO)
		skip_body |= EXAMINE_SKIPBODY_BODY
	if(total_body_cover & LOWER_TORSO)
		skip_body |= EXAMINE_SKIPBODY_GROIN
	if(total_body_cover & HANDS)
		skip_body |= EXAMINE_SKIPBODY_HANDS
	if(total_body_cover & FEET)
		skip_body |= EXAMINE_SKIPBODY_FEET

	examine.legacy_examine_skip_body = skip_body
	examine.legacy_examine_skip_gear = skip_gear

	return examine

/mob/run_examine(datum/event_args/examine/examine, examine_for, examine_from)
	var/datum/event_args/examine_output/output = ..()

	#warn impl

	if(examine_for & EXAMINE_FOR_WORN)
		for(var/id in get_inventory_slot_ids())
			var/datum/inventory_slot/slot = resolve_inventory_slot(id)
			var/obj/item/equipped = inventory.get_slot_single(id)

			var/html = slot.examinate(src, equipped, examine, examine_for, examine_from)
			if(html)
				output.worn_descriptors += html
		for(var/obj/item/held_item as anything in inventory?.get_held_items())
			#warn impl
			var/encoded = held_item.examine_encoding_as_worn(examine, examine_for, examine_from)


	if(buckled)
		LAZYADD(output.required_appearances, buckled.appearance)
		LAZYADD(output.visible_descriptors, SPAN_WARNING("<img src='\ref[buckled.appearance]'> [gender_datum_visible.He] [gender_datum_visible.is] buckled to [FORMAT_TEXT_LOOKITEM(buckled)]."))

	var/maybe_flavor_text = print_flavor_text()
	if(maybe_flavor_text)
		LAZYADD(output.ooc_descriptors, maybe_flavor_text)

	return output
