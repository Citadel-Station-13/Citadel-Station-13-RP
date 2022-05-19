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
	// we can optimize this for slow tickers later
	for(var/datum/automata/A as anything in ticking)
		if(world.time < A.next_tick)
			continue
		A.tick()
		if(MC_TICK_CHECK)
			return
