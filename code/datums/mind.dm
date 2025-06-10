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
 */
/datum/mind/proc/clear_memory(force)

	#warn impl

/**
 * Adds a memory.
 * * The memory datum will be cloned before adding.
 */
/datum/mind/proc/add_memory(datum/memory/memory)
	#warn impl

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
	#warn impl

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

//* UI *//

/datum/mind/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("addMemory")
		if("removeMemory")

/datum/mind/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)

/datum/mind/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["realName"] = name
	.["memories"] = ui_serialize_memories()
	.["memoryMaxUserLength"] = MEMORY_MAX_USER_LENGTH
	.["memoryMaxUserLinebreaks"] = MEMORY_MAX_USER_LINEBREAKS

#warn impl

/datum/mind/proc/ui_push_memories()
	#warn impl

/datum/mind/proc/ui_serialize_memories()
	#warn impl

