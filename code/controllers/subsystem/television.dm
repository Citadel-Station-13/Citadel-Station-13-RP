SUBSYSTEM_DEF(television)
	name = "Television"
	priority = FIRE_PRIORITY_TELEVISION
	init_order = INIT_ORDER_TELEVISION
	subsystem_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME

	var/running = TRUE
	var/list/channels = list()
	var/list/global_TVs = list()

/datum/controller/subsystem/television/Initialize(timeofday)\
	channels = flist(strings/television/)
	for(var/c in channels)
		Show_Master(c)

/datum/controller/subsystem/television/proc/Show_Master(channel)
	//make a list of shows
	//make a list of ads

	return
