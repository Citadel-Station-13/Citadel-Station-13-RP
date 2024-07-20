/**
 * automata datums for propagating turf effect
 */
/datum/automata
	/// are we ready?
	var/ready = FALSE

	/// are we ticking?
	var/ticking = FALSE
	/// next world.time we should tick
	var/next_tick = 0
	/// delay in ds between ticks
	var/delay = 0
	/// iteration
	var/iteration = 1
	/// start at
	var/start_at
	/// last tick at
	var/last_tick

	/// del when done?
	var/del_on_finish = TRUE
	/// callbacks to call when done with (automata: src)
	var/list/datum/callback/on_finish

	/// turfs we're acting on
	var/list/turfs_acting = list()

/datum/automata/New()
	SSautomata.automatons += src

/datum/automata/Destroy()
	if(ticking)
		stop()
	SSautomata.automatons -= src
	return ..()

/datum/automata/proc/setup(...)
	CRASH("abstract proc called")

/datum/automata/proc/init()
	ready = TRUE

/**
 * start ticking
 */
/datum/automata/proc/start(quickstart)
	SHOULD_CALL_PARENT(TRUE)
	ASSERT(ready)
	if(ticking)
		CRASH("double start")
	ticking = TRUE
	SSautomata.ticking += src
	if(isnull(start_at))
		start_at = world.time
	if(quickstart)
		tick()

/**
 * stop ticking
 */
/datum/automata/proc/stop(done = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!ticking)
		CRASH("not started")
	ticking = FALSE
	SSautomata.ticking -= src
	for(var/datum/callback/callback in on_finish)
		callback.InvokeAsync(src, done)
	cleanup()
	if(del_on_finish && !QDELING(src))
		qdel(src)

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
 *
 * @params
 * * turfs - a list of turfs associated to data
 * * data - a data to use if turfs isn't associative; overrides turfs associativity.
 */
/datum/automata/proc/add_turfs_acting(list/turf/turfs, data)
	if(data)
		for(var/turf/T as anything in turfs)
			LAZYSET(T.acting_automata, src, data)
			turfs_acting += T
	else
		for(var/turf/T as anything in turfs)
			LAZYSET(T.acting_automata, src, turfs[T])
			turfs_acting += T

/**
 * act on crossed atom
 */
/datum/automata/proc/act_cross(atom/movable/AM, data)
	return

/**
 * ticks
 * call parent at the END of your proc.
 */
/datum/automata/proc/tick()
	SHOULD_CALL_PARENT(TRUE)
	next_tick = world.time + delay
	++iteration
	last_tick = world.time
