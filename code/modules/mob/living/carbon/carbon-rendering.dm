//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/flatten_standing_overlays()
	render_sprite_accessories(TRUE)
	return ..()

/mob/living/carbon/proc/resolve_sprite_accessory(slot, datum/sprite_accessory_descriptor/descriptor) as /datum/sprite_accessory
	if(!descriptor)
		descriptor = sprite_accessories?[slot]
	if(!descriptor)
		return
	#warn resolve accesosry
	if(slot == SPRITE_ACCESSORY_SLOT_TAIL && !.)
		var/datum/robolimb/limb = isSynthetic()
		if(istype(limb))
			. = limb?.legacy_includes_tail
			if(.)
				//! :skull_emoji:
				//  todo: better defaulting system, this is horrible.
				descriptor.colors = list(rgb(r_skin, g_skin, b_skin))

// todo: this shouldn't be called 'render' as this actually updates our icon
/mob/living/carbon/proc/render_sprite_accessories(flatten)
	for(var/slot in sprite_accessories)
		render_sprite_accessory(slot, flatten)

// todo: this shouldn't be called 'render' as this actually updates our icon
/mob/living/carbon/proc/render_sprite_accessory(slot, flatten)
	remove_standing_overlay(HUMAN_OVERLAY_SPRITE_ACCESSORY(slot))
	var/datum/sprite_accessory_descriptor/descriptor = sprite_accessories[slot]
	if(!descriptor)
		return
	if(is_hiding_sprite_accessory(slot))
		return
	var/datum/sprite_accessory/resolved = resolve_sprite_accessory(slot, descriptor)
	#warn layer resolution
	var/rendered = resolved.render_new(src, descriptor, layer_front, layer_behind, layer_side, flatten)
	postprocess_sprite_accessory(slot, resolved, rendered)
	. = rendered
	add_standing_overlay(HUMAN_OVERLAY_SPRITE_ACCESSORY(slot), rendered)

/mob/living/carbon/proc/set_sprite_accessory_variation(slot, variation)
	var/datum/sprite_accessory_descriptor/descriptor = sprite_accessories?[slot]
	if(!descriptor)
		return FALSE
	var/datum/sprite_accessory/resolved = resolve_sprite_accessory(slot, descriptor)
	if(!resolved.variations?[variation])
		return FALSE
	descriptor.variation = variation
	render_sprite_accessory(slot)
	return TRUE

/mob/living/carbon/proc/has_sprite_accessory_variation(slot, variation)
	var/datum/sprite_accessory_descriptor/descriptor = sprite_accessories?[slot]
	if(!descriptor)
		return FALSE
	var/datum/sprite_accessory/resolved = resolve_sprite_accessory(slot, descriptor)
	return resolved.variations?[variation] ? TRUE : FALSE

/mob/living/carbon/proc/get_sprite_accessory_variation(slot)
	var/datum/sprite_accessory_descriptor/descriptor = sprite_accessories?[slot]
	return descriptor?.variation

/mob/living/carbon/proc/should_hide_sprite_accessory(slot, datum/sprite_accessory/resolved)
	switch(slot)
		if(SPRITE_ACCESSORY_SLOT_EARS)
			var/obj/item/organ/external/head_organ = get_organ(BP_HEAD)
			if(!head_organ || head_organ.is_stump())
				return TRUE
		if(SPRITE_ACCESSORY_SLOT_FACEHAIR)
			var/obj/item/organ/external/head_organ = get_organ(BP_HEAD)
			if(!head_organ || head_organ.is_stump())
				return TRUE
		if(SPRITE_ACCESSORY_SLOT_HAIR)
			var/obj/item/organ/external/head_organ = get_organ(BP_HEAD)
			if(!head_organ || head_organ.is_stump())
				return TRUE
		if(SPRITE_ACCESSORY_SLOT_HORNS)
			var/obj/item/organ/external/head_organ = get_organ(BP_HEAD)
			if(!head_organ || head_organ.is_stump())
				return TRUE
	return FALSE

/**
 * Use at your own risk.
 *
 * @params
 * * slot - the slot
 * * rendered - an /image-like, or a list of /iamge-like's
 */
/mob/living/carbon/proc/postprocess_sprite_accessory(slot, datum/sprite_accessory/resolved, rendered)
	return
