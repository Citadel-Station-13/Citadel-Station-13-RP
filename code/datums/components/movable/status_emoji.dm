//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/status_emoji
	var/datum/status_emoji/emoji
	var/image/overlay

/datum/component/status_emoji/Initialize(datum/status_emoji/emoji_datum)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	emoji = emoji_datum

/datum/component/status_emoji/RegisterWithParent()
	var/atom/movable/casted = parent
	generate_overlay(casted)
	casted.add_overlay(overlay, TRUE)

/datum/component/status_emoji/UnregisterFromParent()
	var/atom/movable/casted = parent
	casted.remove_overlay(overlay, TRUE)
	overlay = null

/datum/component/status_emoji/proc/generate_overlay(atom/movable/align_to)
	ASSERT(!overlay)
	overlay = image(emoji.icon, emoji.icon_state)
	#warn alignment
