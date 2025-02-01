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
	/// coloration mode
	var/coloration_mode
	/// color amount when in overlays mode; other colors will be rendered as _2, _3, etc;
	var/coloration_amount = 1

	//* icon *//
	/// relative icon state append to base accessory state
	/// * example: "-abc" --> "tail-shark_big-abc"
	/// * variations will mutate base accessory state!
	var/icon_state_append
	// todo: icon_state_direct as text | list() for variations
	// todo: has_add_state for applying -add as additive overlay on ourselves

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
