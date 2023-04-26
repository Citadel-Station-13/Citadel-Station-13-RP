/**
 * handles sector ticking, and turf addition / deletion
 */
SUBSYSTEM_DEF(sectors)
	name = "Sectors"
	wait = 1 SECONDS
	subsystem_flags = SS_BACKGROUND
	runlevel_flags = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	init_order = INIT_ORDER_SECTORS
	priority = FIRE_PRIORITY_SECTORS


	/// current run for sectors
	var/list/datum/world_sector/currentrun


	#warn impl

/datum/controller/subsystem/sectors/fire(resumed)
	#warn impl
