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

	/// driver template
	var/datum/storyteller_driver/storyteller_driver
	/// current state
	var/datum/storyteller_state/storyteller_state

	/// factions by ID
	var/list/world_faction_lookup

	#warn world factions

	// todo: configured time & some randomization
	var/legacy_intercept_time = 15 MINUTES

#warn impl

/datum/controller/subsystem/storyteller/Initialize()
	create_factions()
	create_state()
	create_driver()
	pregame_cycle()
	return ..()

// todo: Recover()

/datum/controller/subsystem/storyteller/proc/create_factions()
	world_faction_lookup = list()
	world_factions = list()
	for(var/datum/world_faction/faction as anything in subtypesof(/datum/world_faction))
		if(initial(faction.abstract_type) == faction)
			continue
		faction = new faction
		world_faction_lookup[faction.id] = faction

/datum/controller/subsystem/storyteller/proc/create_state()
	storyteller_state = new

/datum/controller/subsystem/storyteller/proc/create_driver()
	storyteller_driver = new
	// todo: verify map values are valid
	storyteller_driver.primary_faction_id = SSmapping.loaded_station.world_faction_id
	storyteller_driver.world_location_ids = SSmapping.loaded_station.world_location_ids
	#warn impl

/**
 * called at some point before roundstart, probably during init
 */
/datum/controller/subsystem/storyteller/proc/pregame_cycle()

	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(roundstart_cycle)))

/**
 * called on roundstart, right after everyone's loaded in
 */
/datum/controller/subsystem/storyteller/proc/roundstart_cycle()

	addtimer(CALLBACK(src, PROC_REF(trigger_intercept_cycle)), legacy_intercept_time)


// todo: this is a bad proc
/datum/controller/subsystem/storyteller/proc/trigger_intercept_cycle()
	intercept_cycle()

/**
 * called at configured intercept time
 */
/datum/controller/subsystem/storyteller/proc/intercept_cycle()

/**
 * called every minute
 */
/datum/controller/subsystem/storyteller/proc/midround_cycle()

/**
 * called right before roundend completion is declared
 */
/datum/controller/subsystem/storyteller/proc/roundend_cycle()
