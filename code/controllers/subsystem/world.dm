/**
 * World subsystem
 *
 * Initializes the in game world state, factions, etc
 */
SUBSYSTEM_DEF(world)
	name = "World"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_WORLD

	/// factions by ID
	var/list/faction_lookup
	/// all factions
	var/list/datum/world_faction/factions

/datum/controller/subsystem/world/Initialize()
	#warn init factions
	return ..()
