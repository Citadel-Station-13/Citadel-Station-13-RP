SUBSYSTEM_DEF(ai)
	name = "AI"
	init_order = INIT_ORDER_AI
	priority = FIRE_PRIORITY_AI
	wait = 5 // This gets run twice a second, however this is technically two loops in one, with the second loop being run every four iterations.
	subsystem_flags = SS_NO_INIT|SS_TICKER
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/processing = list()
	var/list/currentrun = list()
	var/list/busy_z_levels = list()
	var/slept_mobs = 0

/datum/controller/subsystem/ai/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "P:[processing.len]"
	..(msg.Join())

/datum/controller/subsystem/ai/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()
		slept_mobs = 0
		busy_z_levels.Cut()
		for(var/played_mob in player_list)
			if(!played_mob || isobserver(played_mob))
				continue
			var/turf/player_turf = get_turf(played_mob)
			busy_z_levels |= player_turf?.z

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
	//	var/mob/living/L = currentrun[currentrun.len]
		var/datum/ai_holder/A = currentrun[currentrun.len]
		--currentrun.len
		if(!A || QDELETED(A)) // Doesn't exist or won't exist soon.
			continue
		var/mob/M = null
		if(A.holder)
			M = A.holder
		if(M && M.low_priority && !(M.z in busy_z_levels))
			slept_mobs++
			continue
		if(times_fired % 4 == 0 && A.holder.stat != DEAD)
			A.handle_strategicals()
		if(A.holder.stat != DEAD) // The /TG/ version checks stat twice, presumably in-case processing somehow got the mob killed in that instant.
			A.handle_tactics()

		if(MC_TICK_CHECK)
			return
