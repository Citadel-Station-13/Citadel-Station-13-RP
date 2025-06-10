//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/mind
	//* Abilities *//
	/// mind-level abilities
	var/list/datum/ability/abilities

	//* Characteristics *//
	/// characteristics holder
	var/datum/characteristics_holder/characteristics

	//* Memory *//
	/// Memories, ordered
	var/list/datum/memory/memories
	/// Memories, keyed
	var/list/memories_by_key

	//* Roles *//
	#warn hook
	/// All associated roles
	var/list/datum/role/roles

	//*                Role Functional Holders             *//
	//* Role API will later handle adding/removing/access, *//
	//* this is the holder / data datums.                  *//
	/// Holder for occultism/eldritch module
	var/datum/eldritch_holder/r_holder_eldritch

/datum/mind/Destroy()
	QDEL_NULL(characteristics)
	QDEL_LIST_NULL(abilities)
	return ..()

/**
 * Removes us from our current mob.
 */
/datum/mind/proc/disassociate()

/datum/mind/proc/disassociate_impl(do_not_ghostize)
	PRIVATE_PROC(TRUE)

	ASSERT(!isnull(current))

	// LEGACY: remove changeling
	if(changeling)
		current.remove_changeling_powers()
		remove_verb(current, /datum/changeling/proc/EvolutionMenu)
	// remove characteristics
	characteristics?.disassociate_from_mob(current)
	// remove role holders
	#warn impl
	// remove roles
	#warn impl
	// remove abilities
	for(var/datum/ability/ability as anything in abilities)
		ability.disassociate(current)

	// boot active person if they're still in
	if(active && !do_not_ghostize)
		current.ghostize()

	current.mind = null
	current = null

/**
 * Puts us on a new mob.
 */
/datum/mind/proc/associate(mob/character)
	ASSERT(isnull(current))
	ASSERT(isnull(character.mind))

	current = character
	character.mind = src

	// add characteristics
	characteristics?.associate_with_mob(character)
	// add roles
	#warn impl
	// add role holders
	#warn impl
	// add abilities
	for(var/datum/ability/ability as anything in abilities)
		ability.associate(character)

	// LEGACY: add changeling
	if(changeling)
		character.make_changeling()

	// transfer active person in
	// semi-legacy because we need to evaluate what 'active' here means.
	if(active)
		var/client/found = GLOB.directory[ckey]
		// if it runtimes let it runtime; active should only be true if a client is
		// inhabiting us right now
		found.transfer_to(character)

/datum/mind/proc/transfer(mob/new_character)
	if(isnull(current))
		associate(new_character)
		return

	var/mob/old_character = current
	disassociate_impl(do_not_ghostize = TRUE)

	if(!isnull(new_character.mind))
		new_character.mind.disassociate()

	SStgui.on_transfer(old_character, new_character)
	SSnanoui.user_transferred(old_character, new_character)

	associate(new_character)

//* Abilities *//

/**
 * adds an ability to us
 *
 * @params
 * * ability - a datum or path. once passed in, this datum is owned by the mind, and the mind can delete it at any time! if a path is passed in, this will runtime on duplicates - paths must always be unique if used in this way.
 *
 * @return TRUE / FALSE success or failure
 */
/datum/mind/proc/add_ability(datum/ability/ability)
	if(ispath(ability))
		. = FALSE
		ASSERT(!(locate(ability) in abilities))
		ability = new ability
	abilities += ability
	if(current)
		ability.associate(current)
	return TRUE

/**
 * removes, and deletes, an ability on us
 *
 * @params
 * * ability - a datum or path. paths should only be used if it's an unique ability nothing else should grant!
 *
 * @return TRUE / FALSE success or failure
 */
/datum/mind/proc/remove_ability(datum/ability/ability)
	if(ispath(ability))
		ability = locate(ability) in abilities
	if(isnull(ability))
		return FALSE
	abilities -= ability
	if(current)
		ability.disassociate(current)
	qdel(ability)
	return TRUE

//* Characteristics *//

/**
 * make sure we have a characteristics holder
 */
/datum/mind/proc/characteristics_holder()
	if(!characteristics)
		characteristics = new
		characteristics.associate_with_mind(src)
	return characteristics

//* Memory *//

/**
 * @params
 * * force - remove all memories
 * * class - filter to these classes; required value, put ALL if you want to wipe
 */
/datum/mind/proc/clear_memory(force, class)
	for(var/datum/memory/memory in memories)
		if(!memory.can_delete && !force)
			continue
		if(!(memory.memory_class & class))
			continue
		memories -= memory
	ui_push_memories()

/**
 * Adds a memory.
 * * The memory datum will be cloned before adding.
 */
/datum/mind/proc/add_memory(datum/memory/memory)
	if(!memories)
		memories = list()
	BINARY_INSERT(memory, memories, /datum/memory, memory, priority, COMPARE_KEY)
	if(memory.key)
		if(!memories_by_key)
			memories_by_key = list()
		memories_by_key[memory.key] = memory
	ui_push_memories()

/**
 * Adds a html memory
 * * further uses of this is not allowed
 */
/datum/mind/proc/legacy_add_html_memory(html)
	add_memory(new /datum/memory/unsafe_html(html))

/**
 * Gets a keyed memory.
 * * Modifying returned memories is valid other than its key and priority.
 */
/datum/mind/proc/get_memory_by_key(key)
	return memories_by_key[key]

/**
 * Removes a keyed memory.
 */
/datum/mind/proc/remove_memory_by_key(key)
	return remove_memory(memories_by_key[key])

/**
 * Removes a memory
 */
/datum/mind/proc/remove_memory(datum/memory/memory)
	. = memory in memories
	if(!.)
		return
	memories -= memory
	if(memories_by_key)
		memories_by_key -= memory.key
	ui_push_memories()

//* Preferences Checks - Legacy; remove these on rework *//

/datum/mind/proc/original_background_religion()
	RETURN_TYPE(/datum/lore/character_background/religion)
	var/id = original_save_data?[CHARACTER_DATA_RELIGION]
	if(isnull(id))
		return
	return SScharacters.resolve_religion(id)

/datum/mind/proc/original_background_citizenship()
	RETURN_TYPE(/datum/lore/character_background/citizenship)
	var/id = original_save_data?[CHARACTER_DATA_CITIZENSHIP]
	if(isnull(id))
		return
	return SScharacters.resolve_citizenship(id)

/datum/mind/proc/original_background_origin()
	RETURN_TYPE(/datum/lore/character_background/origin)
	var/id = original_save_data?[CHARACTER_DATA_ORIGIN]
	if(isnull(id))
		return
	return SScharacters.resolve_origin(id)

/datum/mind/proc/original_background_faction()
	RETURN_TYPE(/datum/lore/character_background/faction)
	var/id = original_save_data?[CHARACTER_DATA_FACTION]
	if(isnull(id))
		return
	return SScharacters.resolve_faction(id)

/datum/mind/proc/original_background_culture()
	RETURN_TYPE(/datum/lore/character_background/culture)
	var/id = original_save_data?[CHARACTER_DATA_CULTURE]
	if(isnull(id))
		return
	return SScharacters.resolve_culture(id)

/datum/mind/proc/original_background_datums()
	if(isnull(original_save_data))
		return list()
	. = list(
		original_background_citizenship(),
		original_background_faction(),
		original_background_origin(),
		original_background_religion(),
		original_background_culture(),
	)
	listclearnulls(.)

/datum/mind/proc/original_background_ids()
	if(isnull(original_save_data))
		return list()
	. = list(
		original_save_data[CHARACTER_DATA_CITIZENSHIP],
		original_save_data[CHARACTER_DATA_ORIGIN],
		original_save_data[CHARACTER_DATA_FACTION],
		original_save_data[CHARACTER_DATA_CULTURE],
		original_save_data[CHARACTER_DATA_RELIGION],
	)
	listclearnulls(.)

//* Roles *//

/datum/mind/proc/add_role(datum/role/role)

/datum/mind/proc/remove_role(datum/role/role)

//* Role Holder - Eldritch *//

/datum/mind/proc/create_eldritch_holder()

/datum/mind/proc/delete_eldritch_holder()

#warn impl all

//* UI *//

/datum/mind/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("addMemory")
		if("removeMemory")

	if(!check_rights(C = usr, show_msg = FALSE))
		return

	switch(action)
		// TODO: admin memory edit
		if("adminAddEldritchHolder")
		if("adminDelEldritchHolder")
		if("adminOpenEldritchHolder")
			r_holder_eldritch.ui_interact(usr)

#warn mind panel from player panel? vv options too?
/datum/mind/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)

#warn impl

/datum/mind/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["realName"] = name
	.["memories"] = ui_serialize_memories()
	.["memoryMaxUserLength"] = MEMORY_MAX_USER_LENGTH
	.["memoryMaxUserLinebreaks"] = MEMORY_MAX_USER_LINEBREAKS

	var/list/serialized_objectives = list()
	for(var/datum/objective/objective in objectives)
		serialized_objectives += objective.explanation_text
	.["legacyObjectives"] = serialized_objectives
	.["legacyAmbitions"] = splittext_char(ambitions, "\n")

	// TODO: better admin rights check
	.["admin"] = FALSE
	if(!check_rights(C = user))
		return
	.["admin"] = TRUE

	.["rHolderEldritchPresent"] = !!r_holder_eldritch

/datum/mind/proc/ui_push_memories()
	push_ui_data(data = list("memories" = ui_serialize_memories()))

/datum/mind/proc/ui_serialize_memories()
	var/list/serialized = list()
	for(var/datum/memory/memory as anything in memories)
		serialized[++serialized.len] = memory.ui_memory_data()
	return serialized
