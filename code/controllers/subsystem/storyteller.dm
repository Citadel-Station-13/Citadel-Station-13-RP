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

	/// all active objectives
	var/list/datum/storyteller_objective/objectives
	/// state
	var/datum/storyteller_state/state
	/// driver template
	var/datum/storyteller_driver/driver


#warn impl

