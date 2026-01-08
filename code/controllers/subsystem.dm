/**
 * Sorts subsystems for display (alphabetically).
 */
/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/**
 * Sorts subsystems by init_order and init_stage.
 */
/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	// Uses initial() so it can be used on types.
	if(a.init_stage != b.init_stage)
		return initial(a.init_stage) - initial(b.init_stage)
	return initial(b.init_order) - initial(a.init_order)

/**
 * Sorts subsystems by priority, from lowest to highest.
 *
 * * This does not take into account SS_BACKGROUND and SS_TICKER flags!
 */
/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

/**
 * # Subsystem base class
 *
 * Defines a subsystem to be managed by the [Master Controller][/datum/controller/master]
 *
 * Simply define a child of this subsystem, using the [SUBSYSTEM_DEF] macro, and the MC will handle registration.
 * Changing the name is required.
 *
 * ## Sleeping
 *
 * If a subsystem sleeps during a tick, it is very, very bad.
 *
 * * Sleeping orphans the subsystem's call stack from the MC's. The MC  is no longer able to control the subsystem's tick usage.
 * * Sleeping is handled, but not perfect. This means the MC won't crash / do anything nasty, but normal timing will nonetheless
 *   be affected.
 * * Sleeping causes things like paused tick tracking to be inaccurate.
 */
/datum/controller/subsystem
	//# Metadata; you should define these.

	/**
	 * Name of the subsystem
	 * YOU MUST CHANGE THIS
	 */
	name = "fire coderbus"

	//* Initialization & Shutdown *//

	/**
	 * Order of initialization.
	 * Higher numbers are initialized first, lower numbers later.
	 * Use or create defines such as [INIT_ORDER_DEFAULT] so we can see the order in one file.
	 *
	 * * This is secondary to [init_stage].
	 */
	var/init_order = INIT_ORDER_DEFAULT
	/**
	 * Which stage does this subsystem init at. Earlier stages can fire while later stages init.
	 *
	 * * This is higher in precedence than [init_order].
	 * * This determines when the subsystem starts firing; besure to set this if you need ticking even if you are using SS_NO_INIT!
	 */
	var/init_stage = INIT_STAGE_WORLD
	/**
	 * This variable is set to TRUE after the subsystem has been initialized.
	 *
	 * * If this subsystem is marked as SS_NO_FIRE, this still will be set to TRUE. We just won't call Initialize().
	 * * This will remain FALSE if initialization is an explicit failure.
	 */
	var/initialized = FALSE

	/**
	 * Time to wait (in deciseconds) between each call to fire().
	 * Must be a positive integer.
	 */
	var/wait = 20

	/**
	 * Priority Weight:
	 *
	 * When mutiple subsystems need to run in the same tick,
	 * higher priority subsystems will be given a higher share of the tick before MC_TICK_CHECK triggers a sleep,
	 * higher priority subsystems also run before lower priority subsystems.
	 */
	var/priority = FIRE_PRIORITY_DEFAULT

	/**
	 * [Subsystem Flags][SS_NO_INIT] to control binary behavior.
	 * Flags must be set at compile time or before preinit finishes to take full effect.
	 * (You can also restart the mc to force them to process again)
	 */
	var/subsystem_flags = NONE

	/**
	 * Set to FALSE to prevent fire() calls, mostly for admin use or subsystems that may be resumed later.
	 * use the [SS_NO_FIRE] flag instead for systems that never fire to keep it from even being added to list that is checked every tick.
	 */
	var/can_fire = TRUE

	/**
	 * Bitmap of what game states can this subsystem fire at.
	 * See [RUNLEVELS_DEFAULT] for more details.
	 */
	var/runlevels = RUNLEVELS_DEFAULT

	//# The following variables are managed by the MC and should not be modified directly.

	/// Last time ignite() was called and fire() ran to completion.
	///
	/// * this is set by the MC's processing loop
	/// * sleeping will count as a fire(), despite potentially not finishing a cycle.
	var/last_fire = 0
	/// Scheduled world.time for next ignite().
	///
	/// * this is set by the MC's processing loop
	var/next_fire = 0
	/// Tracks the number of times fire() was ran to completion after an ignite().
	///
	/// * this is set by the MC's processing loop
	/// * sleeping will count as a time fired, despite potentially not finishing a cycle.
	var/times_fired = 0

	/// Running average of the amount of milliseconds it takes the subsystem to complete a run (including all resumes but not the time spent paused).
	var/cost = 0

	/// Running average of the amount of tick usage in percents of a tick it takes the subsystem to complete a run.
	var/tick_usage = 0

	/// Running average of the amount of tick usage (in percents of a game tick) the subsystem has spent past its allocated time without pausing.
	var/tick_overrun = 0

	/// Tracks the current execution state of the subsystem. Used to handle subsystems that sleep in fire so the mc doesn't run them again while they are sleeping.
	var/state = SS_IDLE

	/// Tracks how many fires the subsystem has consecutively paused on in the current run.
	var/paused_ticks = 0

	/// Tracks how much of a tick the subsystem has consumed in the current run.
	var/paused_tick_usage

	/// Tracks how many fires the subsystem takes to complete a run on average.
	var/ticks = 1

	/// Time the subsystem entered the queue, (for timing and priority reasons).
	///
	/// * This doesn't take into account pauses and sleeps. queued_time is the time it was initially put into queue
	///   for a full firing cycle.
	var/queued_time = 0

	/**
	 * Priority at the time the subsystem entered the queue.
	 * Needed to avoid changes in priority (by admins and the like) from breaking things.
	 */
	var/queued_priority

	/**
	 * How many times we suspect a subsystem type has crashed the MC.
	 * 3 strikes and you're out!
	 */
	var/static/list/failure_strikes

	/// Next subsystem in the queue of subsystems to run this tick.
	///
	/// * the queue is a doubly-linked non-circular linked list
	var/datum/controller/subsystem/queue_next
	/// Previous subsystem in the queue of subsystems to run this tick.
	///
	/// * the queue is a doubly-linked non-circular linked list
	var/datum/controller/subsystem/queue_prev

	//* Recomputed at start of Loop(), as well as on changes *//

	/// The **nominal** world.time in deciseconds, before runs
	var/nominal_dt_ds
	/// The **nominal** world.time in seconds, before runs
	var/nominal_dt_s

	//* Tracked by ignite() *//

	/// running average of our 'personal' tick drift
	///
	/// * this is pretty much time dilation for this subsystem
	/// * this is based on wait time; e.g. 100% means we're running twice as slow, etc
	/// * this is also reset by update_next_fire() if 'reset timing' arg is specified
	var/tracked_average_dilation = 0
	/// Last world.time we did a full ignite()/fire() without pausing
	///
	/// * this is set when fire() finishes, whether normally or by sleeping, without pausing.
	/// * this is set by ignite()
	var/tracked_last_completion = 0


	/**
	 * # Do not blindly add vars here to the bottom, put it where it goes above.
	 * # If your var only has two values, put it in as a flag.
	 */

/**
 * Called before global vars are initialized
 * Called before Recover()
 *
 * ! Warning: Old subsystem won't be cleaned up yet if recovering,
 * ! be sure to reference us normally and not with SSname. pattern,
 * ! unless you are doing it on purpose.
 *
 * ? Prefer Initialize() where possible, don't put anything laggy in here please.
 */
/datum/controller/subsystem/proc/PreInit(recovering)
	return

/**
 * Called after global vars are initialized
 * Called before Recover()
 *
 * ! Warning: Old subsystem won't be cleaned up yet if recovering,
 * ! be sure to reference us normally and not with SSname. pattern,
 * ! unless you are doing it on purpose.
 *
 * ? Prefer Initialize() where possible, don't put anything laggy in here please.
 */
/datum/controller/subsystem/proc/Preload(recovering)
	return

/**
 * Used to initialize the subsystem AFTER the map has loaded.
 * This is expected to be overriden by subtypes.
 */
/datum/controller/subsystem/Initialize()
	return SS_INIT_NONE

/**
 * Usually called via datum/controller/subsystem/New() when replacing a subsystem (i.e. due to a recurring crash).
 * Should attempt to salvage what it can from the old instance of subsystem.
 */
/datum/controller/subsystem/Recover()
	return TRUE

/**
 * Handles logic used to track fire() and sleeps.
 *
 * * If fire() sleeps, the return value will be SS_SLEEPING.
 * * If fire() does not sleep, the return value will be SS_PAUSED or SS_RUNNING.
 *
 * @return the state we're now in. This return value is only used if fire() does not sleep.
 */
/datum/controller/subsystem/proc/ignite(resumed = FALSE)
	SHOULD_NOT_OVERRIDE(TRUE)
	// This makes us return the last return value when we (or anything we call; e.g. fire()) sleeps.
	set waitfor = FALSE
	// Paranoid set.
	. = SS_IDLE
	// Set to SLEEPING so the MC knows if anything below this sleeps.
	. = SS_SLEEPING
	// Fire. This can potentially sleep. If it does, the rest of the proc will be disregarded by the MC.
	fire(resumed)
	// If fire() does not sleep, this will set our return value to RUNNING or PAUSED, depending on if we hit pause().
	// If fire() does sleep, 'state' will have already been overwritten by the MC to be SLEEPING,
	//     and if pause() is hit after the sleep, it will be changed to PAUSING.
	. = state

	switch(state)
		if(SS_PAUSING)
			// sleeping & did pause; MC already moved on, and we've been ejected from queue. Re-insert into queue.
			var/was_queued_at = queued_time
			enqueue()
			state = SS_PAUSED
			queued_time = was_queued_at
		if(SS_RUNNING, SS_SLEEPING)
			// full run finished ; track tick dilation average, last fire, and prepare to re-insert into queue.
			var/full_run_took = world.time - tracked_last_completion
			var/new_tick_dilation = (full_run_took / nominal_dt_ds) * 100 - 100
			tracked_average_dilation = max(0, MC_AVERAGE_SLOW(tracked_average_dilation, new_tick_dilation))
			tracked_last_completion = world.time
			state = SS_IDLE
		if(SS_PAUSED)
			// we paused; nothing special, move on. the MC will handle it.
		else
			CRASH("unexpected state in [src] ([type]): [state]")

/**
 * previously, this would have been named 'process()' but that name is used everywhere for different things!
 * fire() seems more suitable. This is the procedure that gets called every 'wait' deciseconds.
 * Sleeping in here prevents future fires until returned.
 */
/datum/controller/subsystem/proc/fire(resumed = FALSE)
	subsystem_flags |= SS_NO_FIRE
	CRASH("Subsystem [src]([type]) does not fire() but did not set the SS_NO_FIRE flag. Please add the SS_NO_FIRE flag to any subsystem that doesn't fire so it doesn't get added to the processing list and waste cpu.")

/datum/controller/subsystem/Destroy()
	dequeue()
	can_fire = FALSE
	subsystem_flags |= SS_NO_FIRE
	if (Master)
		Master.subsystems -= src
	return ..()

/**
 * Updates `next_fire` for the next run.
 *
 * @params
 * * reset_time - Entirely reset the subsystem's stateful time tracking including tick-overrun, post fire timing, etc.
 */
/datum/controller/subsystem/proc/update_next_fire(reset_time)
	if(reset_time)
		next_fire = (subsystem_flags & SS_TICKER) ? (world.time + (world.tick_lag * wait)) : (world.time + wait)
		tracked_last_completion = world.time
		return

	var/queue_node_flags = subsystem_flags

	if (queue_node_flags & SS_TICKER)
		// ticker: run this many ticks after always
		next_fire = world.time + (world.tick_lag * wait)
	else if (queue_node_flags & SS_POST_FIRE_TIMING)
		// post fire timing: fire this much wait after current time, with tick overrun punishment
		next_fire = world.time + wait + (world.tick_lag * (tick_overrun / 100))
	else if (queue_node_flags & SS_KEEP_TIMING)
		// keep timing: fire this much wait after *the last time we should have fired*, without tick overrun punishment
		// **experimental**: do not keep timing past last 10 seconds, if something is running behind that much don't permanently accelerate it.
		next_fire = max(world.time - 10 SECONDS, next_fire + wait)
	else
		// normal: fire this much wait after when we were queued, with tick overrun punishment
		next_fire = queued_time + wait + (world.tick_lag * (tick_overrun / 100))

/**
 * Queue it to run.
 * (we loop thru a linked list until we get to the end or find the right point)
 * (this lets us sort our run order correctly without having to re-sort the entire already sorted list)
 */
/datum/controller/subsystem/proc/enqueue()
	var/SS_priority = priority
	var/SS_flags = subsystem_flags
	var/datum/controller/subsystem/queue_node
	var/queue_node_priority
	var/queue_node_flags

	for (queue_node = Master.queue_head; queue_node; queue_node = queue_node.queue_next)
		queue_node_priority = queue_node.queued_priority
		queue_node_flags = queue_node.subsystem_flags

		if (queue_node_flags & SS_TICKER)
			if (!(SS_flags & SS_TICKER))
				continue

			if (queue_node_priority < SS_priority)
				break

		else if (queue_node_flags & SS_BACKGROUND)
			if (!(SS_flags & SS_BACKGROUND))
				break

			if (queue_node_priority < SS_priority)
				break

		else
			if (SS_flags & SS_BACKGROUND)
				continue

			if (SS_flags & SS_TICKER)
				break

			if (queue_node_priority < SS_priority)
				break

	queued_time = world.time
	queued_priority = SS_priority
	state = SS_QUEUED

	/// update the running total of priorities in the queue of the MC
	if (SS_flags & SS_BACKGROUND)
		Master.queue_priority_count_bg += SS_priority
	else
		Master.queue_priority_count += SS_priority

	queue_next = queue_node
	if (!queue_node) // We stopped at the end, add to tail.
		queue_prev = Master.queue_tail
		if (Master.queue_tail)
			Master.queue_tail.queue_next = src

		else // Empty queue, we also need to set the head.
			Master.queue_head = src

		Master.queue_tail = src

	else if (queue_node == Master.queue_head) // Insert at start of list.
		Master.queue_head.queue_prev = src
		Master.queue_head = src
		queue_prev = null

	else
		queue_node.queue_prev.queue_next = src
		queue_prev = queue_node.queue_prev
		queue_node.queue_prev = src

/datum/controller/subsystem/proc/dequeue()
	// eject from doubly linked list
	if (queue_next)
		queue_next.queue_prev = queue_prev
	if (queue_prev)
		queue_prev.queue_next = queue_next
	// ensure MC's references aren't us
	if (src == Master.queue_tail)
		Master.queue_tail = queue_prev
	if (src == Master.queue_head)
		Master.queue_head = queue_next

	queued_time = 0
	if (state == SS_QUEUED)
		state = SS_IDLE

/datum/controller/subsystem/proc/pause()
	. = TRUE
	switch(state)
		if(SS_RUNNING)
			state = SS_PAUSED
		if(SS_SLEEPING)
			state = SS_PAUSING

/// Called after the config has been loaded or reloaded.
/datum/controller/subsystem/proc/on_config_loaded()
	return

/**
 * Hook for printing stats to the "MC" statuspanel for admins to see performance and related stats etc.
 */
/datum/controller/subsystem/stat_entry()
	if(can_fire && !(SS_NO_FIRE & subsystem_flags))
		. = "[round(cost,1)]ms | D:[round(tracked_average_dilation,1)]% | U:[round(tick_usage,1)]% | O:[round(tick_overrun,1)]% | T:[round(ticks,0.1)]&emsp;"
	else
		. = "OFFLINE&emsp;"

/datum/controller/subsystem/stat_key()
	return "\[[state_letter()]\] [name]"

/**
 * Returns our status symbol.
 */
/datum/controller/subsystem/proc/state_letter()
	// R: running
	// Q: queued
	// P: pausing / paused
	// S: sleeping
	// I: initializing
	// D: done initializing, waiting for init stage to finish
	// blank: idle
	if(Master.init_stage_completed >= init_stage)
		switch (state)
			if (SS_RUNNING)
				. = "Ｒ"
			if (SS_QUEUED)
				. = "Ｑ"
			if (SS_PAUSED, SS_PAUSING)
				. = "Ｐ"
			if (SS_SLEEPING)
				. = "Ｓ"
			if (SS_IDLE)
				. = "&nbsp;&nbsp;&nbsp;"
	else
		if(subsystem_flags & SS_NO_INIT)
			. = "Ｄ"
		if(src == Master.current_initializing_subsystem)
			. = "Ｉ"
		else if(initialized)
			. = "Ｄ"
		else
			. = "Ｗ"

/**
 * Could be used to postpone a costly subsystem for (default one) var/cycles, cycles.
 * For instance, during cpu intensive operations like explosions.
 */
/datum/controller/subsystem/proc/postpone(cycles = 1)
	if(next_fire - world.time < wait)
		next_fire += (wait*cycles)

/datum/controller/subsystem/vv_edit_var(var_name, var_value)
	switch (var_name)
		if (NAMEOF(src, can_fire))
			// This is so the subsystem doesn't rapid fire to make up missed ticks causing more lag
			if (var_value)
				next_fire = world.time + wait
		if (NAMEOF(src, queued_priority)) // Editing this breaks things.
			return FALSE
		if (NAMEOF(src, wait))
			return set_wait(var_value)

	. = ..()

/**
 * Called when max z is changed since subsystems hook it so much.
 *
 * todo: maploader might need to be able to init the new level before this fires if this ever does more than make indice-lists synchronize.
 *
 * Arguments:
 * * old_z_count - The old z count.
 * * new_z_count - The new z count.
 */
/datum/controller/subsystem/proc/on_max_z_changed(old_z_count, new_z_count)
	return

/**
 * Called when world ticklag is changed
 *
 * @params
 * * old_ticklag
 * * new_ticklag
 */
/datum/controller/subsystem/proc/on_ticklag_changed(old_ticklag, new_ticklag)
	recompute_wait_dt()

/**
 * Called when SQL is reconnected after being disconnected
 */
/datum/controller/subsystem/proc/on_sql_reconnect()
	return

//* Wait *//

/datum/controller/subsystem/proc/set_wait(new_wait)
	ASSERT(isnum(new_wait))
	src.wait = new_wait
	recompute_wait_dt()
	return TRUE

/datum/controller/subsystem/proc/recompute_wait_dt()
	nominal_dt_ds = max(world.tick_lag, (subsystem_flags & SS_TICKER)? (wait * world.tick_lag) : (wait))
	nominal_dt_s = nominal_dt_ds * 0.1
