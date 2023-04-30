/**
 * automata datums for propagating turf effects
 */
/datum/automata
	/// automata flags
	var/automata_flags = NONE
	/// are we ticking?
	var/ticking = FALSE
	/// next world.time we should tick
	var/next_tick = 0
	/// delay in ds between ticks
	var/delay = 0.5
	/// iteration
	var/iteration = 1
	/// start at
	var/start_at
	/// last tick at
	var/last_tick
	/// turfs we're acting on
	var/list/turfs_acting = list()
	/// callback to call when done
	var/datum/callback/on_finish

/datum/automata/New()
	SSautomata.automatons += src

/datum/automata/Destroy()
	if(ticking)
		stop()
	cleanup()
	SSautomata.automatons -= src
	return ..()

/**
 * sets up with a single turf and data
 * you usually want to use this
 */
/datum/automata/proc/setup_auto(...)

/**
 * start ticking
 */
/datum/automata/proc/start(quickstart)
	SHOULD_CALL_PARENT(TRUE)
	ticking = TRUE
	SSautomata.ticking += src
	if(isnull(start_at))
		start_at = world.time
	if(quickstart)
		tick()

/**
 * stop ticking
 */
/datum/automata/proc/stop(done)
	SHOULD_CALL_PARENT(TRUE)
	ticking = FALSE
	SSautomata.ticking -= src
	cleanup_turfs_acting()
	if(done)
		if(on_finish)
			on_finish.InvokeAsync()

/**
 * cleans up vars
 */
/datum/automata/proc/cleanup()
	SHOULD_CALL_PARENT(TRUE)
	cleanup_turfs_acting()

/**
 * cleans up turfs acting
 */
/datum/automata/proc/cleanup_turfs_acting()
	SHOULD_CALL_PARENT(TRUE)
	if(turfs_acting.len)
		for(var/turf/T in turfs_acting)
			LAZYREMOVE(T.acting_automata, src)
		turfs_acting.len = 0

/**
 * adds us to a turf's acting_automata
 */
/datum/automata/proc/add_turf_acting(turf/T, power)
	LAZYSET(T.acting_automata, src, power)
	turfs_acting += T

/**
 * act on crossed atom
 */
/datum/automata/proc/act_cross(atom/movable/AM, power)

/**
 * ticks
 * call parent at the END of your proc.
 */
/datum/automata/proc/tick()
	SHOULD_CALL_PARENT(TRUE)
	next_tick = world.time + delay
	++iteration
	last_tick = world.time
