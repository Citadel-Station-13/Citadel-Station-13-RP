SUBSYSTEM_DEF(vore)
	name = "Vore"
	priority = FIRE_PRIORITY_VORE
	wait = 1 SECONDS
	subsystem_flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	var/list/obj/vore_holder/active_holders = list()
	var/list/obj/vore_holder/cycle_holders = list()

/datum/controller/subsystem/vore/Recover()
	. = ..()
	if(islist(SSvore.active_holders))
		src.active_holders = SSvore.active_holders
	else
		. = FALSE

/datum/controller/subsystem/vore/fire(resumed)
	if(!resumed)
		cycle_holders = active_holders.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.cycle_holders
	var/times_fired = src.times_fired
	var/dt = (subsystem_flags & SS_TICKER)? (wait * world.tick_lag) : (wait * 0.)
	while(length(cycles))
		var/obj/vore_holder/B = currentrun[currentrun.len]
		--currentrun.len

		B.process_vore(dt, times_fired)

		if (MC_TICK_CHECK)
			return
