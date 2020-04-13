SUBSYSTEM_DEF(openspace)
	name = "Open Space"
	init_order = INIT_ORDER_OPENSPACE
	wait = 10

	var/list/turfs_to_process = list()		// List of turfs queued for update.
	var/list/turfs_to_process_old = null	// List of turfs currently being updated.

/datum/controller/process/open_space/Initialize()
	initialize_open_space()
	return ..()

/datum/controller/process/open_space/copyStateFrom(var/datum/controller/process/open_space/other)
	. = ..()
	OS_controller = src

/datum/controller/process/open_space/doWork()
	// We use a different list so any additions to the update lists during a delay from scheck()
	// don't cause things to be cut from the list without being updated.
	turfs_to_process_old = turfs_to_process
	turfs_to_process = list()

	for(last_object in turfs_to_process_old)
		var/turf/T = last_object
		if(!QDELETED(T))
			update_turf(T)
		SCHECK

/datum/controller/process/open_space/proc/update_turf(var/turf/T)
	for(var/atom/movable/A in T)
		A.fall()
	T.update_icon()

/datum/controller/process/open_space/proc/add_turf(var/turf/T, var/recursive = 0)
	ASSERT(isturf(T))
	turfs_to_process += T
	if(recursive > 0)
		var/turf/above = GetAbove(T)
		if(above && isopenspace(above))
			add_turf(above, recursive)

// Do the initial updates of open space turfs when the game starts. This will lag!
/datum/controller/process/open_space/proc/initialize_open_space()
	// Do initial setup from bottom to top.
	for(var/zlevel = 1 to world.maxz)
		for(var/turf/simulated/open/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
			add_turf(T)
