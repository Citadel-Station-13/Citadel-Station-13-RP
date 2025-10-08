//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/status_emoji
	dupe_type = COMPONENT_DUPE_HIGHLANDER
	registered_type = /datum/component/status_emoji
	var/datum/status_emoji/emoji
	var/image/overlay

/datum/component/status_emoji/Initialize(datum/status_emoji/emoji_datum, duration)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	emoji = emoji_datum
	QDEL_IN(src, duration)

/datum/component/status_emoji/RegisterWithParent()
	var/atom/movable/casted = parent
	generate_overlay(casted)
	casted.add_overlay(overlay, TRUE)

/datum/component/status_emoji/UnregisterFromParent()
	var/atom/movable/casted = parent
	casted.cut_overlay(overlay, TRUE)
	overlay = null

/datum/component/status_emoji/proc/generate_overlay(atom/movable/align_to)
	ASSERT(!overlay)
	overlay = image(emoji.icon, emoji.icon_state)
	align_to.get_centering_pixel_x_offset()

	// we always align to their icon's top right.
	var/align_x = (align_to.get_pixel_x_self_width() - emoji.icon_size_x) + emoji.shift_x
	var/align_y = (align_to.get_pixel_y_self_width() - emoji.icon_size_y) + emoji.shift_y

	overlay.pixel_x = align_x
	overlay.pixel_y = align_y
