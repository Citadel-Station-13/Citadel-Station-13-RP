//
// Mobs Subsystem - Process mob.Life()
//

// Contains temporary debugging code to diagnose extreme tick consumption.

SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = 100
	wait = 2 SECONDS
	subsystem_flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/log_extensively = FALSE
	var/list/timelog = list()
	var/list/busy_z_levels = list()
	var/slept_mobs = 0

/datum/controller/subsystem/mobs/stat_entry()
	return ..() + " P: [global.GLOB.mob_list.len] | S: [slept_mobs]"

/datum/controller/subsystem/mobs/fire(resumed = 0)
	var/list/busy_z_levels = src.busy_z_levels

	if (!resumed)
		slept_mobs = 0
		src.currentrun = GLOB.mob_list.Copy()
		busy_z_levels.Cut()
		for(var/played_mob in GLOB.player_list)
			if(!played_mob || isobserver(played_mob))
				continue
			var/mob/pm = played_mob
			busy_z_levels |= pm.z

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	var/dt = (subsystem_flags & SS_TICKER)? (world.tick_lag * wait) : (wait * 0.1)
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if(QDELETED(M))
			GLOB.mob_list -= M
		else
			// Right now mob.Life() is unstable enough I think we need to use a try catch.
			// Obviously we should try and get rid of this for performance reasons when we can.
			if(M.low_priority && !(M.z in busy_z_levels))
				slept_mobs++
				continue
			M.Life(dt, times_fired)

		if (MC_TICK_CHECK)
			return
