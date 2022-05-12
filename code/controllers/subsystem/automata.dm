/**
 * subsystem for ticking automata datums
 */
SUBSYSTEM_DEF(automata)
	name = "Automata"
	wait = 1
	subsystem_flags = SS_TICKER

	/// all automata in world
	var/static/list/datum/automata/automatons = list()
	/// all active automata
	var/static/list/datum/automata/ticking = list()

/datum/controller/subsystem/automata/fire(resumed)
	. = ..()
	for(var/datum/automata/A as anything in ticking)


