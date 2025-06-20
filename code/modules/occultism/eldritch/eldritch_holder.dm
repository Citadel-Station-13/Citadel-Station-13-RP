//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Abstraction API between module and whatever role / mind system is on the side of mobs.
 * * It's valid to have more than one holder associated on a mob, but you shouldn't do so.
 */
/datum/eldritch_holder
	/// associated mob, if any
	var/mob/cultist

	/// known, researched knowledges
	/// * serialized as ids
	var/list/datum/prototype/eldritch_knowledge/knowledge = list()
	/// passives applied, associated to context
	/// * context is serialized, but not the passives
	var/list/datum/prototype/eldritch_passive/passives
	/// abilities applied, associated to applied ability datum
	/// * ability state is serialized, but not the abilities
	var/list/datum/prototype/eldritch_ability/abilities
	/// known recipe ids
	/// * not serialized
	/// * associated to a list of knowledge's if more than one tries to give it
	var/list/recipe_ids

	/// active patron, if any; null if none
	/// * serialized as id
	var/datum/prototype/eldritch_patron/active_patron

/datum/eldritch_holder/Destroy()
	if(cultist)
		disassociate()
	return ..()

/datum/eldritch_holder/proc/associate(mob/cultist)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(cultist == src.cultist)
		return TRUE
	if(src.cultist)
		disassociate()
	src.cultist = cultist
	on_mob_associate(cultist)
	return TRUE

/datum/eldritch_holder/proc/disassociate()
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!src.cultist)
		return TRUE
	var/mob/old_cultist = src.cultist
	src.cultist = null
	on_mob_disassociate(old_cultist)
	return TRUE

/datum/eldritch_holder/proc/on_mob_associate(mob/cultist)
	for(var/datum/prototype/eldritch_passive/passive as anything in passives)
		passive.on_mob_associate(cultist, src, passives[passive])
	for(var/datum/prototype/eldritch_ability/ability as anything in abilities)
		var/datum/ability/ability_instance = abilities[ability]
		ability_instance.associate(cultist)

/datum/eldritch_holder/proc/on_mob_disassociate(mob/cultist)
	for(var/datum/prototype/eldritch_passive/passive as anything in passives)
		passive.on_mob_disassociate(cultist, src, passives[passive])
	for(var/datum/prototype/eldritch_ability/ability as anything in abilities)
		var/datum/ability/ability_instance = abilities[ability]
		ability_instance.disassociate(cultist)

/datum/eldritch_holder/proc/unlock_knowledge(datum/prototype/eldritch_knowledge/knowledge)
	. = add_knowledge(knowledge)
	if(.)
		for(var/id in knowledge.unlock_eldritch_knowledge_ids)
			var/datum/prototype/eldritch_knowledge/chain_unlock = RSeldritch_knowledge.fetch_local_or_throw(id)
			if(chain_unlock)
				unlock_knowledge(chain_unlock)

/datum/eldritch_holder/proc/add_knowledge(datum/prototype/eldritch_knowledge/knowledge)
	if(knowledge in src.knowledge)
		return TRUE
	knowledge.apply(src)
	ui_push_learned_knowledge()
	return TRUE

/datum/eldritch_holder/proc/remove_knowledge(datum/prototype/eldritch_knowledge/knowledge)
	if(!(knowledge in src.knowledge))
		return TRUE
	knowledge.remove(src)
	ui_push_learned_knowledge()
	return TRUE

/datum/eldritch_holder/proc/has_knowledge(datum/prototype/eldritch_knowledge/knowledge)
	return (knowledge in src.knowledge)

/datum/eldritch_holder/proc/set_active_patron(datum/prototype/eldritch_patron/patron)
	active_patron = patron
	ui_push_active_patron()

/datum/eldritch_holder/proc/add_passive(datum/prototype/eldritch_passive/passive, datum/prototype/eldritch_knowledge/from_knowledge)
	#warn impl
	var/datum/eldritch_passive_context/context_instance
	if(!passives[passive])
		passives[passive] = context_instance = passive.create_initial_context(src)
		if(context_instance.enabled)
			passive.on_holder_enable(src)


	ui_push_learned_passives()
	ui_push_passive_contexts()

/datum/eldritch_holder/proc/remove_passive(datum/prototype/eldritch_passive/passive, datum/prototype/eldritch_knowledge/from_knowledge)
	#warn impl
	ui_push_learned_passives()

/datum/eldritch_holder/proc/add_ability(datum/prototype/eldritch_ability/ability, datum/prototype/eldritch_knowledge/from_knowledge)
	var/datum/ability/eldritch_ability/ability_instance
	var/created_new
	if(!abilities[ability])
		abilities[ability] = ability_instance = ability.create_ability(src)
		created_new = TRUE
	if(knowledge.id in ability_instance.granted_from_knowledge_ids)
		return TRUE
	ability_instance.granted_from_knowledge_ids += knowledge.id
	if(created_new)
		if(cultist)
			ability_instance.associate(cultist)
		ui_push_learned_abilities()
		ui_push_ability_contexts()
	return TRUE

/datum/eldritch_holder/proc/remove_ability(datum/prototype/eldritch_ability/ability, datum/prototype/eldritch_knowledge/from_knowledge)
	var/datum/ability/eldritch_ability/ability_instance
	if(!abilities[ability])
		return TRUE
	if(!(knowledge.id in ability_instance.granted_from_knowledge_ids))
		return TRUE
	ability_instance.granted_from_knowledge_ids -= knowledge.id
	if(length(ability_instance.granted_from_knowledge_ids))
		return TRUE
	if(cultist)
		ability_instance.disassociate(cultist)
	abilities -= ability
	ui_push_learned_abilities()
	return TRUE

/datum/eldritch_holder/proc/add_recipe(datum/crafting_recipe/eldritch_recipe/recipe, datum/prototype/eldritch_knowledge/from_knowledge)
	var/already_exists = recipe_ids[recipe.id]
	LAZYADD(recipe_ids[recipe.id], from_knowledge.id)
	if(!already_exists)
		ui_push_learned_recipes()
	return TRUE

/datum/eldritch_holder/proc/remove_recipe(datum/crafting_recipe/eldritch_recipe/recipe, datum/prototype/eldritch_knowledge/from_knowledge)
	LAZYREMOVE(recipe_ids[recipe.id], from_knowledge.id)
	if(!length(recipe_ids[recipe.id]))
		recipe_ids -= recipe.id
		ui_push_learned_recipes()
	return TRUE

/datum/eldritch_holder/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "modules/occultism/eldritch/EldritchHolder")
		ui.open()

/datum/eldritch_holder/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("switchPatron")
		if("enablePassive")
		if("disablePassive")

	if(!check_rights(show_msg = FALSE, C = usr))
		return

	switch(action)
		if("adminAddKnowledge")
		if("adminRemoveKnowledge")

#warn impl all

/datum/eldritch_holder/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

	// TODO: better admin rights check
	var/is_admin = check_rights(show_msg = FALSE, C = user)
	.["admin"] = is_admin

	var/list/serialized_knowledge = ui_serialize_repository_knowledge(is_admin)
	var/list/serialized_passives = ui_serialize_repository_passives(is_admin)
	var/list/serialized_abilities = ui_serialize_repository_abilities(is_admin)
	var/list/serialized_recipes = ui_serialize_repository_recipes(is_admin)

	.["repositoryKnowledge"] = serialized_knowledge
	.["repositoryPassives"] = serialized_passives
	.["repositoryAbilities"] = serialized_abilities
	.["repositoryRecipes"] = serialized_recipes

	.["unlockedAbilities"] = ui_serialize_learned_abilities()
	.["unlockedPassives"] = ui_serialize_learned_passives()
	.["unlockedKnowledge"] = ui_serialize_learned_knowledge()
	.["unlockedRecipes"] = ui_serialize_learned_recipes()
	.["unlockedPatrons"] = ui_serialize_learned_patrons()

	.["passiveContexts"] = ui_serialize_passive_contexts()
	.["abilityContexts"] = ui_serialize_ability_contexts()

	.["activePatron"] = active_patron?.id

/datum/eldritch_holder/proc/ui_push_learned_knowledge()
	push_ui_data(data = list("unlockedKnowledge" = ui_serialize_learned_knowledge()))

/datum/eldritch_holder/proc/ui_push_learned_passives()
	push_ui_data(data = list("unlockedPassives" = ui_serialize_learned_passives()))

/datum/eldritch_holder/proc/ui_push_learned_recipes()
	push_ui_data(data = list("unlockedRecipes" = ui_serialize_learned_recipes()))

/datum/eldritch_holder/proc/ui_push_learned_abilities()
	push_ui_data(data = list("unlockedAbilities" = ui_serialize_learned_abilities()))

/datum/eldritch_holder/proc/ui_push_learned_patrons()
	push_ui_data(data = list("unlockedPatrons" = ui_serialize_learned_patrons()))

/datum/eldritch_holder/proc/ui_push_active_patron()
	push_ui_data(data = list("activePatron" = active_patron?.id))

/datum/eldritch_holder/proc/ui_push_ability_contexts()
	push_ui_data(data = list("abilityContexts" = ui_serialize_ability_contexts()))

/datum/eldritch_holder/proc/ui_push_passive_contexts()
	push_ui_data(data = list("passiveContexts" = ui_serialize_passive_contexts()))

/datum/eldritch_holder/proc/ui_serialize_learned_knowledge()
	var/list/serialized = list()
	for(var/datum/prototype/eldritch_knowledge/learned as anything in knowledge)
		serialized += learned.id
	return serialized

/datum/eldritch_holder/proc/ui_serialize_learned_passives()
	var/list/serialized = list()
	for(var/datum/prototype/eldritch_passive/learned as anything in passives)
		serialized += learned.id
	return serialized

/datum/eldritch_holder/proc/ui_serialize_learned_recipes()
	var/list/serialized = recipe_ids
	return serialized

/datum/eldritch_holder/proc/ui_serialize_learned_abilities()
	var/list/serialized = list()
	for(var/datum/prototype/eldritch_ability/learned as anything in abilities)
		serialized += learned.id
	return serialized

/datum/eldritch_holder/proc/ui_serialize_learned_patrons()
	var/list/serialized = list()
	#warn how?
	return serialized

/datum/eldritch_holder/proc/ui_serialize_ability_contexts()
	var/list/serialized = list()
	for(var/datum/prototype/eldritch_ability/ability as anything in abilities)
		var/datum/ability/eldritch_ability/context = abilities[ability]
		serialized[ability.id] = context.ui_serialize_ability_context()
	return serialized

/datum/eldritch_holder/proc/ui_serialize_passive_contexts()
	var/list/serialized = list()
	for(var/datum/prototype/eldritch_passive/passive as anything in passives)
		var/datum/eldritch_passive_context/context = passives[passive]
		serialized[passive.id] = context.ui_serialize_passive_context()
	return serialized

/datum/eldritch_holder/proc/ui_serialize_repository_knowledge(admin)
	var/list/serialized = list()
	for(var/datum/prototype/eldritch_knowledge/knowledge as anything in RSeldritch_knowledge.fetch_subtypes_immutable(/datum/prototype/eldritch_knowledge))
		if(!admin && (knowledge.hidden || (knowledge.secret && !(knowledge in src.knowledge))))
			continue
		serialized[knowledge.id] = knowledge.ui_serialize_knowledge()
	return serialized

/datum/eldritch_holder/proc/ui_serialize_repository_passives(admin)
	var/list/serialized = list()
	for(var/datum/prototype/eldritch_passive/passive as anything in RSeldritch_passive.fetch_subtypes_immutable(/datum/prototype/eldritch_passive))
		serialized[passive.id] = passive.ui_serialize_passive()
	return serialized

/datum/eldritch_holder/proc/ui_serialize_repository_abilities(admin)
	var/list/serialized = list()
	for(var/datum/prototype/eldritch_ability/ability as anything in RSeldritch_ability.fetch_subtypes_immutable(/datum/prototype/eldritch_ability))
		serialized[ability.id] = ability.ui_serialize_ability()
	return serialized

/datum/eldritch_holder/proc/ui_serialize_repository_recipes(admin)
	var/list/serialized = list()
	for(var/datum/crafting_recipe/eldritch_recipe/recipe in GLOB.crafting_recipes)
		serialized[recipe.id] = recipe.ui_serialize_recipe()
	return serialized
