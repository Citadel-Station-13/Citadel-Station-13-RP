//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Markings applied to a sprite accessory
 *
 * * the parent accessory's `icon_sidedness` will be used; this means
 *   if the parent has -front and -behind, the marking must also have -front and -behind
 * * the same alignment as the parent is used
 * * the same icon as the parent is used
 *
 */
/datum/sprite_accessory_marking
	//* basics *//
	/// the preview name of the marking
	var/name
	/// id; must be unique on the sprite accessory holding this marking.
	/// * this will be autoset by parent
	var/id

	//* coloration *//
	/// allow coloring? we use single-color matrix, so no fancy matrix shenanigans please!
	var/colorable = FALSE

	//* icon *//
	/// relative icon state append to base accessory state
	/// * example: "-abc" --> "tail-shark_big-abc"
	/// * variations will mutate base accessory state!
	var/icon_state_append
	/// direct icon state to use
	/// * this ignores base icon state
	var/icon_state_direct
	/// variation override for direct icon state
	/// * if a variation is missing, this marking will simply not render.
	var/list/icon_state_direct_variations

	// todo: has_add_state for applying -add as additive overlay on ourselves
	//       do we even need it?

	//* blending *//
	/// blend this onto parent in 'add' rather than 'overlay' mode
	var/is_additive_marking = FALSE
	/// relative layer
	/// * higher is on-top
	/// * valid values: -5 to 5
	/// * only integers are allowed
	var/layer = 0

/datum/sprite_accessory_marking/New(id)
	if(id)
		src.id = id
	#warn sanitize layer

#warn how to render gradients?
