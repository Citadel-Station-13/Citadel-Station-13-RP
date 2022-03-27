//
// Mobs Subsystem - Process mob.Life()
//

//VOREStation Edits - Contains temporary debugging code to diagnose extreme tick consumption.
//Revert file to Polaris version when done.

SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = 100
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/log_extensively = FALSE
	var/list/timelog = list()
	var/list/busy_z_levels = list()
	var/slept_mobs = 0

/datum/controller/subsystem/mobs/stat_entry()
	..("P: [global.GLOB.mob_list.len] | S: [slept_mobs]")

/datum/controller/subsystem/mobs/fire(resumed = 0)
	if (!resumed)
		slept_mobs = 0
		src.currentrun = GLOB.mob_list.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if(QDELETED(M))
			GLOB.mob_list -= M
		else
			M.Life(times_fired)

		if (MC_TICK_CHECK)
			return
