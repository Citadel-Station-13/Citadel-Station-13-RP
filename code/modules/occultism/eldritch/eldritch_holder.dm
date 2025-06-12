//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Abstraction API between module and whatever role / mind system is on the side of mobs.
 * * It's valid to have more than one holder associated on a mob, but you shouldn't do so.
 * * Stateless in terms of what mob we're associated on. This is for cleanliness purposes.
 *   This also means you can technically associate one holder to multiple mobs; but you really
 *   really shouldn't.
 */
/datum/eldritch_holder
	/// known, researched knowledges
	/// * serialized as ids
	var/list/datum/prototype/eldritch_knowledge/knowledge = list()

	/// passives applied, associated to context
	/// * context is serialized, but not the passives
	var/list/datum/prototype/eldritch_passive/applied_passives
	/// abilities applied, associated to applied ability datum
	/// * ability state is serialized, but not the abilities
	var/list/datum/prototype/eldritch_ability/applied_abilities

	/// known recipe ids
	/// * not serialized
	/// * associated to a list of knowledge's if more than one tries to give it
	var/list/known_recipe_ids

	/// active patron, if any; null if none
	/// * serialized as id
	var/datum/prototype/eldritch_patron/active_patron

/datum/eldritch_holder/proc/on_mob_associate(mob/cultist)
	for(var/datum/prototype/eldritch_passive/passive as anything in applied_passives)
		passive.on_mob_associate(cultist, src, applied_passives[passive])
	for(var/datum/prototype/eldritch_ability/ability as anything in applied_abilities)
		var/datum/ability/ability_instance = applied_abilities[ability]
		ability_instance.associate(cultist)

/datum/eldritch_holder/proc/on_mob_disassociate(mob/cultist)
	for(var/datum/prototype/eldritch_passive/passive as anything in applied_passives)
		passive.on_mob_disassociate(cultist, src, applied_passives[passive])
	for(var/datum/prototype/eldritch_ability/ability as anything in applied_abilities)
		var/datum/ability/ability_instance = applied_abilities[ability]
		ability_instance.disassociate(cultist)

/datum/eldritch_holder/proc/add_knowledge(datum/prototype/eldritch_knowledge/knowledge)
	#warn impl

/datum/eldritch_holder/proc/remove_knowledge(datum/prototype/eldritch_knowledge/knowledge)
	#warn impl

/datum/eldritch_holder/proc/has_knowledge(datum/prototype/eldritch_knowledge/knowledge)
	return knowledge in src.knowledge

/datum/eldritch_holder/proc/set_active_patron(datum/prototype/eldritch_patron/patron)
	#warn tgui update?

/datum/eldritch_holder/proc/add_passive(datum/prototype/eldritch_passive/passive)
	#warn tgui update?

/datum/eldritch_holder/proc/remove_passive(datum/prototype/eldritch_passive/passive)
	#warn tgui update?

/datum/eldritch_holder/proc/add_ability(datum/prototype/eldritch_ability/ability)

	#warn tgui update?

/datum/eldritch_holder/proc/remove_ability(datum/prototype/eldritch_ability/ability)

	#warn tgui update?

/datum/eldritch_holder/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/datum/eldritch_holder/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/datum/eldritch_holder/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

	// TODO: better admin rights check
	.["admin"] = FALSE
	if(!check_rights(C = user))
		return
	.["admin"] = TRUE

/datum/eldritch_holder/proc/ui_push_learned_knowledges()

/datum/eldritch_holder/proc/ui_push_learned_passives()

/datum/eldritch_holder/proc/ui_push_learned_recipes()

/datum/eldritch_holder/proc/ui_push_learned_abilities()

#warn impl all
