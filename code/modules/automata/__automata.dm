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
	ticking = TRUE
	SSautomata.ticking += src
	if(isnull(start_at))
		start_at = world.time
	if(quickstart)
		tick()

/**
 * stop ticking
 */
/datum/automata/proc/stop()
	ticking = FALSE
	SSautomata.ticking -= src

/**
 * cleans up vars
 */
/datum/automata/proc/cleanup()

/**
 * ticks
 * call parent at the END of your proc.
 */
/datum/automata/proc/tick()
	SHOULD_CALL_PARENT(TRUE)
	next_tick = world.time + delay
	++iteration
	last_tick = world.time
