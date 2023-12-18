//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * boy oh boy why do we need 3 different kinds of faction datums?
 *
 * well, you see...
 *
 * /world_faction is for in universe setting definitions
 * /storyteller_faction is mapped to directly by /world_faction, and represents a spawn of a **type** of presence
 * /game_faction, which is this one, represents an actual IC faction
 *
 * while 'pirates' are one world faction, they may spawn multiple offmaps of different game factions, because
 * pirates aren't necessarily all working together.
 *
 * these factions, and their objectives, are handled by SSticker.
 */
/datum/game_faction
	abstract_type = /datum/game_faction
	/// subsystem-registered? id must be immutable once set
	var/registered = FALSE
	/// uid - must be unique across rounds. text.
	var/id
	/// friendly, player-facing name
	var/name
	/// objectives
	var/list/datum/game_objective/objectives
	/// minds
	var/list/datum/mind/minds

/datum/game_faction/Destroy()
	#warn clear minds
	return ..()

#warn impl

/**
 * tgui roundend data
 */
/datum/game_faction/proc/tgui_roundend_data()
	var/list/built_objectives = list()
	for(var/datum/game_objective/objective as anything in objectives)
		built_objectives[++built_objectives.len] = objective.tgui_roundend_data(faction = src)
	/**
	 * GameFaction{} -->
	 *
	 * name: string;
	 * id: string;
	 * objectives: GameObjective[];
	 */
	return list(
		"name" = name,
		"id" = id,
		"objectives" = built_objectives,
	)


