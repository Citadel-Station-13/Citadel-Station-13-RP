//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * unlike /tg/ heretics implementation, ours is closer to one of those weird
 * ass RPG skill webs than being more tree-ish.
 */
/datum/mansus_knowledge
	abstract_type = /datum/mansus_knowledge

	/// id. must be unique.
	var/id

	/// name in UI
	var/name = "???"
	/// desc in UI
	var/desc = "A fragment of forbidden knowledge. What's in the box? No one knows."
	/// long-desc / lore in UI
	/// * As unsafe HTML. Don't let players write this, please.
	var/lore_as_unsafe_html
	/// category, for list view
	var/category = "???"

	/// cannot be seen or acquired if not there, unless already acquired.
	var/hidden = FALSE

	/// position from origin
	/// * unset = auto position
	/// * please set this
	var/ui_pos_x
	/// position from origin
	/// * unset = auto position
	/// * please set this
	var/ui_pos_y
	/// ui icon
	var/ui_icon
	/// ui icon state
	var/ui_icon_state

#warn impl

/datum/mansus_knowledge/proc/apply(datum/mansus_holder/holder)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/datum/mansus_knowledge/proc/remove(datum/mansus_holder/holder)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
