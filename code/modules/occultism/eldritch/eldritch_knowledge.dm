//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * unlike /tg/ heretics implementation, ours is closer to one of those weird
 * ass RPG skill webs than being more tree-ish.
 */
/datum/prototype/eldritch_knowledge
	abstract_type = /datum/prototype/eldritch_knowledge

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
	/// * overridden by admisn
	var/secret = FALSE
	/// never show on UI or make known to the player / client
	/// * overridden by admisn
	var/hidden = FALSE

	/// ui icon
	var/ui_icon
	/// ui icon state
	var/ui_icon_state

	/// unlock recipe ids
	/// * superceding another id is not supported at this time; please make sure no two
	///   knowledge nodes can have the same ID.
	var/list/give_eldritch_recipe_ids
	/// unlock passive ids
	/// * superceding another id is not supported at this time; please make sure no two
	///   knowledge nodes can have the same ID.
	var/list/give_eldritch_passive_ids
	/// unlock ability ids
	/// * superceding another id is not supported at this time; please make sure no two
	///   knowledge nodes can have the same ID.
	var/list/give_eldritch_ability_ids
	/// autounlock other knowledge ids once unlocked
	var/list/give_eldritch_knowledge_ids

	/// required knowledge ids
	var/list/req_eldritch_knowledge_ids

#warn impl

/datum/prototype/eldritch_knowledge/proc/apply(datum/eldritch_holder/holder)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/datum/prototype/eldritch_knowledge/proc/remove(datum/eldritch_holder/holder)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)		"iconAsBase64" = serialized_icon,


/datum/prototype/eldritch_knowledge/proc/ui_serialize_knowledge()
	var/serialized_icon
	var/list/serialized_abilities
	var/list/serialized_passives
	var/list/serialized_recipes
	#warn impl
	return list(
		"id" = id,
		"name" = name,
		"desc" = desc,
		"category" = category,
		"loreAsUnsafeHtml" = lore_as_unsafe_html,
		"iconAsBase64" = serialized_icon,
		"secret" = secret,
		"hidden" = hidden,
		"reqKnowledgeIds" = req_eldritch_knowledge_ids,
		"giveAbilities" = serialized_abilities,
		"givePassives" = serialized_passives,
		"giveRecipes" = serialized_recipes,
		"giveKnowledgeIds" = give_eldritch_knowledge_ids,
	)
