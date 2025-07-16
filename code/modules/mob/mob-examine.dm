//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Incoming *//

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
		LAZYINITLIST(output.out_worn_descriptors)

		for(var/id in get_inventory_slot_ids())
			var/datum/inventory_slot/slot = resolve_inventory_slot(id)
			var/obj/item/equipped = inventory.get_slot_single(id)

			var/html = slot.examinate(src, equipped, examine, examine_for, examine_from)
			if(html)
				output.out_worn_descriptors += html

		for(var/obj/item/held_item as anything in inventory?.get_held_items())
			var/encoded = held_item.examine_encoding_as_worn(examine, examine_for, examine_from)
			var/hand_index = held_item.inv_slot_or_index
			var/hand_str = (hand_index % 2)? "left hand[hand_index > 2? " #[round(hand_index / 2)]" : ""]" : "right hand[hand_index > 2? " #[round(hand_index / 2)]" : ""]"
			if(!isnull(encoded))
				output.out_worn_descriptors += "[gender_datum_visible.He] [gender_datum_visible.is] \
				holding [held_item.gender == PLURAL ? "some" : "a"] [held_item.examine_encoding_as_worn(examine, examine_for, examine_from)] \
				in [gender_datum_visible.his] [hand_str]"

	if(buckled)
		LAZYADD(output.required_appearances, buckled.appearance)
		LAZYADD(output.out_visible_descriptors, SPAN_WARNING("<img src='\ref[buckled.appearance]'> [gender_datum_visible.He] [gender_datum_visible.is] buckled to [ENCODE_ATOM_HREFEXAMINE(buckled)]."))

	var/maybe_flavor_text = print_flavor_text()
	if(maybe_flavor_text)
		LAZYADD(output.out_ooc_descriptors, maybe_flavor_text)

	return output

//* Outgoing *//

// TODO: what about remote-viewing?
/mob/proc/examine_entity_check_visibility(atom/entity, silent, from_href)
	if(is_blind())
		to_chat(src, SPAN_WARNING("You can't examine things while you're blind."))
		return FALSE

	// TODO: this allows for a view argument. use it.
	if(!can_see_expensive(entity))
		return FALSE

	return TRUE

/**
 * @params
 * * entity - what we're examining
 * * force - skip visibility check
 * * silent - don't emit output for the user or anyone else around them
 * * virtual - Internal call, don't trigger things like insanity on examine. Implies 'force'.
 *             Also don't trigger side effects like facing towards them.
 * * from_href - atom/Topic() routed here
 *
 * TODO: what about remote-viewing?
 *
 * @return TRUE on success, FALSE otherwise
 */
/mob/proc/examine_entity(atom/entity, force, silent, virtual, from_href)
	if(!force && !virtual && !examine_entity_check_visibility(entity, silent, from_href))
		return FALSE

	// TODO: get virtual dir from SSmapping instead so this works across z-transitions
	if(!virtual && get_dist(entity, src) < 15 && entity.z == src.z)
		face_atom(entity)

	SEND_SIGNAL(src, COMSIG_MOB_EXAMINE_ENTITY, entity, force, silent, virtual)

	var/datum/event_args/examine/input = new(entity, src, TRUE)
	var/datum/event_args/examine_output/output = entity.examine_new(
		input,
		EXAMINE_FOR_EVERYTHING,
		EXAMINE_FROM_TURF,
	)

	var/list/serialized_html = list()
	serialized_html += "<blockquote class='info'>"
	#warn impl
	serialized_html += "</blockquote>"

	// Show people around us if:
	// 1. Not silent,
	// 2. And it isn't in or on us,
	// 3. And we're on a turf,
	// 4. And it's not a turf,
	// 5. And it has a location.
	// TODO: visible_message like / proper feedback wrapper that checks for physical
	//       visibility on turf.
	var/atom/their_top_level_atom = get_top_level_atom(entity)
	if(!silent && their_top_level_atom != src && !isturf(entity))
		visible_message(SPAN_TINYNOTICE("<b>\The [src]</b> looks at \the [entity]."), range = MESSAGE_RANGE_EXAMINE)

	to_chat(src, serialized_html)

	if(!virtual)
		update_examine_panel(entity)

	return TRUE
