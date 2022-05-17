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
	var/iteration = 0

/datum/automata/New()
	SSautomata.automatons += src

/datum/automata/Destroy()
	if(ticking)
		kill()
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
	iteration = 1
	if(quickstart)
		tick()

/**
 * stop ticking
 */
/datum/automata/proc/kill()
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
