/**
 * Storyteller system
 *
 * Runs the round's default content, determines when to do stuff, etc
 *
 * todo:
 * * SSevents should only tick event instances & hold event data; we handle the triggering/etc
 */
SUBSYSTEM_DEF(storyteller)
	name = "Storyteller"
	wait = 30 SECONDS
	init_order = INIT_ORDER_STORYTELLER

	/// state
	var/datum/storyteller_state/storyteller_state
	/// driver template
	var/datum/storyteller_driver/storyteller_driver

	/// factions by ID
	var/list/world_faction_lookup
	/// all factions
	var/list/datum/world_faction/world_factions

	#warn world factionso

#warn impl

