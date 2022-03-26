SUBSYSTEM_DEF(ai)
	name = "AI"
	init_order = INIT_ORDER_AI
	priority = FIRE_PRIORITY_AI
	wait = 5 // This gets run twice a second, however this is technically two loops in one, with the second loop being run every four iterations.
	flags = SS_NO_INIT|SS_TICKER
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/processing = list()
	var/list/currentrun = list()

	var/list/process_z = list()//Z-levels on which AI should be processing, levels without living players dont process

/datum/controller/subsystem/ai/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "P:[processing.len]"
	..(msg.Join())

/datum/controller/subsystem/ai/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()
		//Addition from vorestation to not simulate levels with no living players
		process_z.Cut()
		var/level = 1
		while(process_z.len < GLOB.living_players_by_zlevel.len)
			process_z.len++
			process_z[level] = GLOB.living_players_by_zlevel[level].len
			level++

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
	//	var/mob/living/L = currentrun[currentrun.len]
		var/datum/ai_holder/A = currentrun[currentrun.len]
		--currentrun.len

		if(!A || QDELETED(A)) // Doesn't exist or won't exist soon.
			continue
		
		var/mob/living/L = A.holder	//VOREStation Edit Start
		if(!L?.loc)
			continue

		if(process_z[get_z(L)] || !L.low_priority)//check if we need to process the AI as there is no living player here
			if(times_fired % 4 == 0 && A.holder.stat != DEAD)
				A.handle_strategicals()
			if(A.holder.stat != DEAD) // The /TG/ version checks stat twice, presumably in-case processing somehow got the mob killed in that instant.
				A.handle_tactics()
		else//If its not worth, tell the mob to idle
			A.set_stance(STANCE_IDLE)


		if(MC_TICK_CHECK)
			return
