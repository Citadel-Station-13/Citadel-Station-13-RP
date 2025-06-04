//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * unlike /tg/ heretics implementation, ours is closer to one of those weird
 * ass RPG skill webs than being more tree-ish.
 */
/datum/eldritch_knowledge
	abstract_type = /datum/eldritch_knowledge

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

	/// unlock recipe ids
	var/list/give_recipe_ids
	/// unlock passive ids
	var/list/give_passive_ids
	/// unlock abilities
	/// * instances / typepaths, not ids
	var/list/datum/ability/eldritch_ability/give_abilities

#warn impl

/datum/eldritch_knowledge/proc/apply(datum/eldritch_holder/holder)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/datum/eldritch_knowledge/proc/remove(datum/eldritch_holder/holder)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
