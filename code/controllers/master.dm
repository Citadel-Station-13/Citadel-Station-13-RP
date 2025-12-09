/**
 * StonedMC
 *
 * Designed to properly split up a given tick among subsystems
 * Note: if you read parts of this code and think "why is it doing it that way"
 * Odds are, there is a reason
 *
 **/

/**
 * This is the ABSOLUTE ONLY THING that should init globally like this.
 */
GLOBAL_REAL(Master, /datum/controller/master) = new

/**
 * THIS IS THE INIT ORDER
 * Master -> SSPreInit -> GLOB -> world -> config -> SSInit -> Failsafe
 * GOT IT MEMORIZED?
 */

/datum/controller/master
	name = "Master"

	/// Are we processing (higher values increase the processing delay by n ticks)
	var/processing = TRUE

	/// How many times have we ran?
	var/iteration = 0

	/// Stack end detector to detect stack overflows that kill the mc's main loop
	var/datum/stack_end_detector/stack_end_detector

	/// world.time of last fire, for tracking lag outside of the mc.
	var/last_run

	/// List of subsystems to process().
	var/list/subsystems

	//# Vars for keeping track of tick drift.

	/**
	 * The world.timeofday that the current Loop() started at.
	 */
	var/loop_start_timeofday
	/**
	 * The world.time that the current Loop() started at.
	 */
	var/loop_start_time
	var/tickdrift = 0

	/// How long is the MC sleeping between runs, read only (set by Loop() based off of anti-tick-contention heuristics).
	var/sleep_delta = 1

	/// Makes the mc main loop runtime.
	var/make_runtime = FALSE

	/// The type of the last subsystem to be process()'d.
	var/last_type_processed

	/// For scheduling different subsystems for different stages of the round.
	var/current_runlevel


	var/static/restart_clear = 0
	var/static/restart_timeout = 0
	var/static/restart_count = 0

	var/static/random_seed

	//*            Iniitialization             *//

	/// The subsystem currently being initialized.
	var/datum/controller/subsystem/current_initializing_subsystem
	/// Are we initialized? This means all subsystems have been initialized.
	var/initialized = FALSE
	/// Set if it is specified to pause the world while no one is logged in after initializations, and we did pause.
	var/initializations_finished_with_no_players_logged_in
	/// Set to determine if we should sleep offline after initializations if no one is connected.
	///
	/// * This is turned off by unit tests automatically.
	var/sleep_offline_after_initializations = TRUE

	//*               Global State             *//
	//* These are tracked through MC restarts. *//

	/// The current initialization stage we're at.
	var/static/init_stage_completed = 0
	/// The init stage currently being ran by the main ticker loop
	var/init_stage_ticking

	//*      Processing Variables      *//
	//* These are set during a Loop(). *//

	/// total fire_priority of all non-background subsystems in the queue
	var/queue_priority_count = 0
	/// total fire_priority of all background subsystems in the queue
	var/queue_priority_count_bg = 0

	/// Start of queue linked list.
	var/datum/controller/subsystem/queue_head
	/// End of queue linked list (used for appending to the list).
	var/datum/controller/subsystem/queue_tail

	//*                                                Control Variables                                                 *//
	//* These are accessed globally and are used to allow the MC to control the server's tick when outside of a MC proc. *//

	/**
	 * current tick limit, assigned before running a subsystem.
	 * used by CHECK_TICK as well so that the procs subsystems call can obey that SS's tick limits.
	 */
	var/static/current_ticklimit = TICK_LIMIT_RUNNING

/datum/controller/master/New()
	// Do not contaminate `usr`; if this is set, the MC main loop will have the usr of whoever called it,
	// which results in all procs called by the MC inheriting that usr.
	usr = null

	//# 1. create configs
	create_legacy_configuration()
	if(!config)
		config = new
	if(!Configuration)
		Configuration = new

	//# 2. set up random seed
	if(!random_seed)
		#ifdef UNIT_TESTS
		random_seed = 29051994 // How about 22475?
		#else
		random_seed = rand(1, 1e9)
		#endif
		rand_seed(random_seed)

	//# 3. create subsystems
	// Highlander-style: there can only be one! Kill off the old and replace it with the new.
	var/list/_subsystems = list()
	subsystems = _subsystems
	if (Master != src)
		if (istype(Master))
			Recover()
			qdel(Master)
		else
			var/list/subsytem_types = subtypesof(/datum/controller/subsystem)
			tim_sort(subsytem_types, GLOBAL_PROC_REF(cmp_subsystem_init))
			for(var/I in subsytem_types)
				var/datum/controller/subsystem/S = new I
				_subsystems += S
		Master = src

	/**
	 * # 4. call PreInit() on all subsystems
	 * we iterate on _subsystems because if we Recover(), we don't make any subsystems into _subsystems,
	 * as we instead have the old subsystems added to our normal subsystems list.
	 */
	for(var/datum/controller/subsystem/S in _subsystems)
		S.PreInit(FALSE)

	//# 5. set up globals
	if(!GLOB)
		new /datum/controller/global_vars

	/**
	 * # 6. call Preload() on all subsystems
	 * we iterate on _subsystems because if we Recover(), we don't make any subsystems into _subsystems,
	 * as we instead have the old subsystems added to our normal subsystems list.
	 */
	for(var/datum/controller/subsystem/S in _subsystems)
		S.Preload(FALSE)

/datum/controller/master/Destroy()
	..()
	// Tell qdel() to Del() this object.
	return QDEL_HINT_HARDDEL_NOW

/datum/controller/master/Shutdown()
	processing = FALSE
	tim_sort(subsystems, GLOBAL_PROC_REF(cmp_subsystem_init))
	reverseRange(subsystems)
	for(var/datum/controller/subsystem/ss in subsystems)
		log_world("Shutting down [ss.name] subsystem...")
		ss.Shutdown()

	log_world("Shutdown complete")

/**
 * MC reboot proc.
 *
 * Returns:
 * -  1 If we created a new mc.
 * -  0 If we couldn't due to a recent restart.
 * - -1 If we encountered a runtime trying to recreate it.
 */
/proc/Recreate_MC()
	. = MC_RESTART_RTN_FAILED // So if we runtime, things know we failed.
	if (world.time < Master.restart_timeout)
		return MC_RESTART_RTN_COOLDOWN
	if (world.time < Master.restart_clear)
		Master.restart_count *= 0.5

	var/delay = 50 * ++Master.restart_count
	Master.restart_timeout = world.time + delay
	Master.restart_clear = world.time + (delay * 2)
	Master.processing = FALSE // Stop ticking this one.
	try
		new/datum/controller/master()
	catch
		return MC_RESTART_RTN_FAILED

	return MC_RESTART_RTN_SUCCESS

/datum/controller/master/Recover()
	var/msg = "## DEBUG: [time2text(world.timeofday)] MC restarted. Reports:\n"
	var/list/master_attributes = Master.vars
	var/list/filtered_variables = list(
		NAMEOF(src, name),
		NAMEOF(src, parent_type),
		NAMEOF(src, statclick),
		NAMEOF(src, tag),
		NAMEOF(src, type),
		NAMEOF(src, vars),
	)
	for (var/varname in master_attributes - filtered_variables)
		var/varval = master_attributes[varname]
		if (isdatum(varval)) // Check if it has a type var.
			var/datum/D = varval
			msg += "\t [varname] = [D]([D.type])\n"
		else
			msg += "\t [varname] = [varval]\n"
	log_world(msg)

	var/datum/controller/subsystem/BadBoy = Master.last_type_processed
	var/FireHim = FALSE
	if(istype(BadBoy))
		msg = null
		LAZYINITLIST(BadBoy.failure_strikes)
		switch(++BadBoy.failure_strikes[BadBoy.type])
			if(2)
				msg = "The [BadBoy.name] subsystem was the last to fire for 2 controller restarts. It will be recovered now and disabled if it happens again."
				FireHim = TRUE
			if(3)
				msg = "The [BadBoy.name] subsystem seems to be destabilizing the MC and will be put offline."
				BadBoy.subsystem_flags |= SS_NO_FIRE
		if(msg)
			to_chat(GLOB.admins, SPAN_BOLDANNOUNCE("[msg]"))
			log_world(msg)

	if (istype(Master.subsystems))
		if(FireHim)
			Master.subsystems += new BadBoy.type //NEW_SS_GLOBAL will remove the old one
		subsystems = Master.subsystems
		current_runlevel = Master.current_runlevel
		StartProcessing(10)
	else
		to_chat(world, SPAN_BOLDANNOUNCE("The Master Controller is having some issues, we will need to re-initialize EVERYTHING"))
		Initialize(20, TRUE, FALSE)

/**
 * Please don't stuff random bullshit here,
 * Make a subsystem, give it the SS_NO_FIRE flag, and do your work in it's Initialize()
 *
 * @params
 * * delay - wait this many deciseconds before initializing
 * * init_sss - initialize all subsystems
 * * tgs_prime - notify TGS that initializations are done after
 */
/datum/controller/master/Initialize(delay, init_sss, tgs_prime)
	set waitfor = FALSE

	if(delay)
		sleep(delay)
	if(init_sss)
		init_subtypes(/datum/controller/subsystem, subsystems)

	// Announce start
	to_chat(world, SPAN_BOLDANNOUNCE("Initializing subsystems..."))
	var/mc_started = FALSE

	// We want to initialize subsystems by stage, in the init_order provided for subsystems within the same stage.
	init_stage_completed = 0
	var/list/stage_sorted_subsystems = new(INIT_STAGE_MAX)
	for(var/i in 1 to INIT_STAGE_MAX)
		stage_sorted_subsystems[i] = list()

	// Sort subsystems by init_order, so they initialize in the correct order.
	tim_sort(subsystems, GLOBAL_PROC_REF(cmp_subsystem_init))

	// Collect subsystems by init_stage. This has precedence over init_order.
	for(var/datum/controller/subsystem/subsystem as anything in subsystems)
		var/subsystem_init_stage = subsystem.init_stage
		if (!isnum(subsystem_init_stage) || subsystem_init_stage < 1 || subsystem_init_stage > INIT_STAGE_MAX || round(subsystem_init_stage) != subsystem_init_stage)
			stack_trace("ERROR: MC: subsystem `[subsystem.type]` has invalid init_stage: `[subsystem_init_stage]`. Setting to `[INIT_STAGE_MAX]`")
			subsystem_init_stage = subsystem.init_stage = INIT_STAGE_MAX
		stage_sorted_subsystems[subsystem_init_stage] += subsystem

	// Sort subsystems by display setting for easy access.
	tim_sort(subsystems, GLOBAL_PROC_REF(cmp_subsystem_display))

	// Initialize subsystems. The ticker loop will be started immediately upon the first stage being done.
	var/rtod_start = REALTIMEOFDAY

	for(var/current_init_stage in 1 to INIT_STAGE_MAX)
		for(var/datum/controller/subsystem/subsystem in stage_sorted_subsystems[current_init_stage])
			current_initializing_subsystem = subsystem
			initialize_subsystem(subsystem)
			current_initializing_subsystem = null
			CHECK_TICK
		init_stage_completed = current_init_stage
		if(!mc_started)
			mc_started = TRUE
			if(!current_runlevel)
				// intentionally not using the defines here as the MC does not care about runlevel semantics;
				// the first runlevel is always used.
				SetRunLevel(1)
			Master.StartProcessing(0)

	var/rtod_end = REALTIMEOFDAY
	var/took_seconds = round((rtod_end - rtod_start) / 10, 0.01)

	// Announce, log, and record end
	var/msg = "Initializations complete within [took_seconds] second[took_seconds == 1 ? "" : "s"]!"
	to_chat(world, SPAN_BOLDANNOUNCE("[msg]"))
	log_world(msg)

	// Set world options.
	world.set_fps(config_legacy.fps)

	// Fire initialization toast
	if(world.system_type == MS_WINDOWS && CONFIG_GET(flag/toast_notification_on_init) && !length(GLOB.clients))
		world.shelleo("start /min powershell -ExecutionPolicy Bypass -File tools/initToast/initToast.ps1 -name \"[world.name]\" -icon %CD%\\icons\\CS13_16.png -port [world.port]")

	// Tell TGS we're initialized
	if(tgs_prime)
		world.TgsInitializationComplete()

	// Handle sleeping offline after initializations.
	var/rtod_sleep_offline_check = REALTIMEOFDAY
	if(sleep_offline_after_initializations)
		world.sleep_offline = TRUE
	sleep(1 TICK)
	if(sleep_offline_after_initializations) // && CONFIG_GET(flag/resume_after_initializations))
		world.sleep_offline = FALSE
	initializations_finished_with_no_players_logged_in = rtod_sleep_offline_check < REALTIMEOFDAY - 10

/**
 * Initialize a given subsystem and handle the results.
 *
 * Arguments:
 * * subsystem - the subsystem to initialize.
 */
/datum/controller/master/proc/initialize_subsystem(datum/controller/subsystem/subsystem)
	// Do not re-init already initialized subsystems if it's somehow called again.
	if(subsystem.subsystem_flags & SS_NO_INIT)
		subsystem.initialized = TRUE
		return
	if(subsystem.initialized)
		return

	// todo: dylib high-precision timers
	var/rtod_start = REALTIMEOFDAY
	var/initialize_result = subsystem.Initialize()
	var/rtod_end = REALTIMEOFDAY
	var/took_seconds = round((rtod_end - rtod_start) / 10, 0.01)

	metric_set_nested_numerical(/datum/metric/nested_numerical/subsystem_init_time, "[subsystem.type]", took_seconds)

	// "[message_prefix] [seconds] seconds."
	var/message_prefix
	// should to_chat the message to world rather than just log
	var/tell_everyone
	// use a warning spans
	var/chat_warning

	switch(initialize_result)
		if(SS_INIT_FAILURE)
			message_prefix = "Failed to initialize [subsystem.name] ([subsystem.type]) subsystem after"
			tell_everyone = TRUE
			chat_warning = TRUE
			// Since this is an explicit failure, shut its ticking off. We also will not set its initialized variable.
			subsystem.subsystem_flags |= SS_NO_FIRE
		if(SS_INIT_NONE)
			message_prefix = "Initialized [subsystem.name] ([subsystem.type]) subsystem with errors within"
			tell_everyone = TRUE
			chat_warning = TRUE
			subsystem.initialized = TRUE
			warning("[subsystem.name] ([subsystem.type]) subsystem does not implement Initialize() or it returns ..(). If the former is true, the SS_NO_INIT flag should be set for this subsystem.")
		if(SS_INIT_SUCCESS)
			message_prefix = "Initialized [subsystem.name] subsystem within"
			tell_everyone = TRUE
			subsystem.initialized = TRUE
		if(SS_INIT_NO_MESSAGE)
			message_prefix = "Initialized [subsystem.name] subsystem within"
			subsystem.initialized = TRUE
		if(SS_INIT_NO_NEED)
		else
			warning("[subsystem.name] subsystem initialized, returning invalid result [initialize_result]. This is a bug.")

	var/message = "[message_prefix] [took_seconds] second[took_seconds == 1 ? "" : "s"]."
	var/chat_message = chat_warning ? SPAN_BOLDWARNING(message) : SPAN_BOLDANNOUNCE(message)

	if(tell_everyone && message_prefix)
		to_chat(world, chat_message)
	log_world(message)

/datum/controller/master/proc/SetRunLevel(new_runlevel)
	var/old_runlevel = current_runlevel
	if(isnull(old_runlevel))
		old_runlevel = "NULL"

	testing("MC: Runlevel changed from [old_runlevel] to [new_runlevel]")
	current_runlevel = log(2, new_runlevel) + 1
	if(current_runlevel < 1)
		CRASH("Attempted to set invalid runlevel: [new_runlevel]")

/**
 * Starts the mc, and sticks around to restart it if the loop ever ends.
 */
/datum/controller/master/proc/StartProcessing(delay)
	set waitfor = FALSE

	if(delay)
		sleep(delay)

	testing("Master starting processing")
	var/started_stage
	var/rtn = MC_LOOP_RTN_UNKNOWN
	do
		started_stage = init_stage_completed
		rtn = Loop(started_stage)
	while (rtn == MC_LOOP_RTN_NEWSTAGES && processing > 0 && started_stage < init_stage_completed)

	if (rtn >= MC_LOOP_RTN_GRACEFUL_EXIT || processing < 0)
		return //this was suppose to happen.

	//loop ended, restart the mc
	log_game("MC crashed or runtimed, restarting")
	message_admins("MC crashed or runtimed, restarting")
	var/rtn2 = Recreate_MC()
	if (rtn2 <= 0)
		log_game("Failed to recreate MC (Error code: [rtn2]), it's up to the failsafe now")
		message_admins("Failed to recreate MC (Error code: [rtn2]), it's up to the failsafe now")
		Failsafe.defcon = 2

/**
 * Main loop!
 * This is where the magic happens.
 */
/datum/controller/master/proc/Loop(init_stage)
	. = -1

	// Prep the loop (most of this is because we want MC restarts to reset as much state as we can, and because local vars rock

	// All this shit is here so that flag edits can be refreshed by restarting the MC. (and for speed)
	var/list/ticker_subsystems = list()
	var/list/runlevel_sorted_subsystems = list(list()) // Ensure we always have at least one runlevel.
	var/timer = world.time
	for (var/thing in subsystems)
		var/datum/controller/subsystem/SS = thing
		// Skip non-firing
		if(SS.subsystem_flags & SS_NO_FIRE)
			continue
		// Skip those that are after our init stage, or are not initialized.
		if(SS.init_stage > init_stage)
			continue

		SS.queued_time = 0
		SS.queue_next = null
		SS.queue_prev = null
		SS.state = SS_IDLE

		// Set precomputed variables
		SS.recompute_wait_dt()

		if (SS.subsystem_flags & SS_TICKER)
			ticker_subsystems += SS
			// Timer subsystems aren't allowed to bunch up, so we offset them a bit.
			timer += world.tick_lag * rand(0, 1)
			SS.next_fire = timer
			continue

		var/ss_runlevels = SS.runlevels
		var/added_to_any = FALSE
		for(var/I in 1 to GLOB.bitflags.len)
			if(ss_runlevels & GLOB.bitflags[I])
				while(runlevel_sorted_subsystems.len < I)
					runlevel_sorted_subsystems += list(list())

				runlevel_sorted_subsystems[I] += SS
				added_to_any = TRUE

		if(!added_to_any)
			WARNING("[SS.name] subsystem is not SS_NO_FIRE but also does not have any runlevels set!")

	queue_head = null
	queue_tail = null

	/**
	 * These sort by lower priorities first to reduce the number of loops needed to add subsequent SS's to the queue.
	 * (higher subsystems will be sooner in the queue, adding them later in the loop means we don't have to loop thru them next queue add)
	 */
	tim_sort(ticker_subsystems, GLOBAL_PROC_REF(cmp_subsystem_priority))
	for(var/I in runlevel_sorted_subsystems)
		tim_sort(I, GLOBAL_PROC_REF(cmp_subsystem_priority))
		I += ticker_subsystems

	var/cached_runlevel = current_runlevel
	var/list/current_runlevel_subsystems = runlevel_sorted_subsystems[cached_runlevel]

	loop_start_timeofday = REALTIMEOFDAY
	loop_start_time = world.time
	init_stage_ticking = init_stage

	iteration = 1

	var/init_stage_change_pending = FALSE
	var/error_level = 0
	var/sleep_delta = 1

	//setup the stack overflow detector
	stack_end_detector = new()
	var/datum/stack_canary/canary = stack_end_detector.prime_canary()
	canary.use_variable()
	//# The actual loop.
	while (1)
		var/new_tickdrift = (((REALTIMEOFDAY - loop_start_timeofday) - (world.time - loop_start_time)) / world.tick_lag)
		tickdrift = max(0, MC_AVERAGE_FAST(tickdrift, new_tickdrift))
		var/starting_tick_usage = TICK_USAGE

		// check if we need to queue an init stage change
		if(init_stage != init_stage_completed)
			// set stage change pending; this'll stop new (but not paused / sleeping) subsystems from being queued to run.
			init_stage_change_pending = TRUE
			// ensure that 1. queue is empty and 2. no sleeping subsystems (as those don't stay in queue) exist
			if(!queue_head && !laggy_sleeping_subsystem_check())
				return MC_LOOP_RTN_NEWSTAGES

		// If we're paused for some reason, well, pause.
		if (processing <= 0)
			current_ticklimit = TICK_LIMIT_RUNNING
			sleep(10)
			continue

		// If we're fully initialized, run normal tick heuristics. Otherwise, always run every tick.
		if (init_stage == INIT_STAGE_MAX)
			/**
			 * Anti-tick-contention heuristics:
			 * If there are mutiple sleeping procs running before us hogging the cpu, we have to run later.
			 * (because sleeps are processed in the order received, longer sleeps are more likely to run first)
			 */
			if (starting_tick_usage > TICK_LIMIT_MC)
				// If there isn't enough time to bother doing anything this tick, sleep increasingly longer times.
				sleep_delta *= 2
				// Instruct CHECK_TICK to use a lot less tick than it usually wouldb e allowed to.
				current_ticklimit = TICK_LIMIT_RUNNING * 0.5
				sleep(world.tick_lag * (processing * sleep_delta))
				continue

			/**
			 * Byond resumed us late.
			 * Assume it might have to do the same next tick.
			 */
			if (last_run + CEILING(world.tick_lag * (processing * sleep_delta), world.tick_lag) < world.time)
				sleep_delta += 1

			// Decay sleep_delta
			sleep_delta = MC_AVERAGE_FAST(sleep_delta, 1)

			// We ran 3/4 of the way into the tick
			if (starting_tick_usage > (TICK_LIMIT_MC*0.75))
				sleep_delta += 1
		else
			sleep_delta = 1

		//# Debug.
		if (make_runtime)
			var/datum/controller/subsystem/SS
			SS.can_fire = 0

		if (!Failsafe || (Failsafe.processing_interval > 0 && (Failsafe.lasttick+(Failsafe.processing_interval*5)) < world.time))
			new/datum/controller/failsafe() // (re)Start the failsafe.

		//# Now do the actual stuff.

		// Check if runlevel changed
		if(cached_runlevel != current_runlevel)
			// Resechedule subsystems that are not already part of the runlevel, and are running behind.
			var/list/old_runlevel_subsystems = current_runlevel_subsystems
			cached_runlevel = current_runlevel
			current_runlevel_subsystems = runlevel_sorted_subsystems[cached_runlevel]
			for(var/datum/controller/subsystem/adding_to_runlevel as anything in (current_runlevel_subsystems - old_runlevel_subsystems))
				if(adding_to_runlevel.next_fire > world.time)
					continue
				adding_to_runlevel.next_fire = world.time + world.tick_lag * rand(0, DS2TICKS(min(adding_to_runlevel.wait, 2 SECONDS)))

		// If no init stage change is pending, re-queue any subsystems that are idle and are ready to fire.
		if(!init_stage_change_pending)
			if (CheckQueue(current_runlevel_subsystems) <= 0 || CheckQueue(ticker_subsystems) <= 0)
				stack_trace("MC: CheckQueue failed. Current error_level is [round(error_level, 0.25)]")
				if (!SoftReset(ticker_subsystems, runlevel_sorted_subsystems))
					error_level++
					CRASH("MC: SoftReset() failed, exiting loop()")

				if (error_level < 2) //except for the first strike, stop incrmenting our iteration so failsafe enters defcon
					iteration++
				else
					cached_runlevel = null //3 strikes, Lets reset the runlevel lists
				current_ticklimit = TICK_LIMIT_RUNNING
				sleep((1 SECONDS) * error_level)
				error_level++
				continue

		if (queue_head)
			var/run_result = RunQueue()
			switch(run_result)
				if(MC_RUN_RTN_UNKNOWN)
					// Error running queue
					stack_trace("MC: RunQueue failed. Current error_level is [round(error_level, 0.25)]")
					if (error_level > 1) //skip the first error,
						if (!SoftReset(ticker_subsystems, runlevel_sorted_subsystems))
							CRASH("MC: SoftReset() failed, exiting loop()")

						if (error_level <= 2) //after 3 strikes stop incrmenting our iteration so failsafe enters defcon
							iteration++
						else
							cached_runlevel = null //3 strikes, Lets also reset the runlevel lists
						current_ticklimit = TICK_LIMIT_RUNNING
						sleep((1 SECONDS) * error_level)
						error_level++
						continue
					error_level++

		if (error_level > 0)
			error_level = max(MC_AVERAGE_SLOW(error_level-1, error_level), 0)
		if (!queue_head) //reset the counts if the queue is empty, in the off chance they get out of sync
			queue_priority_count = 0
			queue_priority_count_bg = 0

		iteration++
		last_run = world.time
		src.sleep_delta = MC_AVERAGE_FAST(src.sleep_delta, sleep_delta)

		// We're about to go to sleep. Set the tick budget for other sleeping procs.
		if (init_stage != INIT_STAGE_MAX)
			// Still initializing, allow up to 100% dilation (50% of normal FPS).
			current_ticklimit = TICK_LIMIT_RUNNING * 2
		else
			// Already initialized; use normal heuristics.
			current_ticklimit = TICK_LIMIT_RUNNING
			if (processing * sleep_delta <= world.tick_lag)
				current_ticklimit -= (TICK_LIMIT_RUNNING * 0.25) //reserve the tail 1/4 of the next tick for the mc if we plan on running next tick

		sleep(world.tick_lag * (processing * sleep_delta))

/**
 * Checks a list of subsystems and enqueues anything that is idle and is ready to run.
 *
 * @params
 * * subsystemstocheck - List of systems to check.
 */
/datum/controller/master/proc/CheckQueue(list/datum/controller/subsystem/subsystemstocheck)
	. = FALSE // So the mc knows if we runtimed.

	for (var/datum/controller/subsystem/SS as anything in subsystemstocheck)
		if(!SS)
			subsystemstocheck -= SS

		if (SS.state != SS_IDLE)
			continue
		if (SS.can_fire <= 0)
			continue
		if (SS.next_fire > world.time)
			continue

		var/SS_flags = SS.subsystem_flags

		// if it's flagged as NO_FIRE for some reason (probably because something faulted and shut it off), completely boot it
		if (SS_flags & SS_NO_FIRE)
			subsystemstocheck -= SS
			continue
		// keep timing: do not run faster than 1.33x of base speed, to prevent catch-up from going too fast
		if ((SS_flags & (SS_TICKER|SS_KEEP_TIMING)) == SS_KEEP_TIMING && SS.last_fire + (SS.wait * 0.75) > world.time)
			continue

		SS.enqueue()

	. = TRUE

/// Run thru the queue of subsystems to run, running them while balancing out their allocated tick precentage.
/datum/controller/master/proc/RunQueue()
	. = MC_RUN_RTN_UNKNOWN
	var/datum/controller/subsystem/queue_node
	var/queue_node_flags
	var/queue_node_priority
	var/queue_node_paused

	var/current_tick_budget
	var/tick_precentage
	var/tick_remaining
	var/ran = TRUE // This is right.
	var/ran_non_ticker = FALSE
	var/bg_calc // Have we swtiched current_tick_budget to background mode yet?

	// the % of tick used by the current running subsystem
	var/queue_node_tick_usage
	// is a subsystem stopping mid-cycle? this means either pausing or sleeping
	var/something_is_mid_cycle

	/**
	 * Keep running while we have stuff to run and we haven't gone over a tick
	 * this is so subsystems paused eariler can use tick time that later subsystems never used
	 */
	while (ran && queue_head && TICK_USAGE < TICK_LIMIT_MC)
		ran = FALSE
		bg_calc = FALSE
		current_tick_budget = queue_priority_count
		queue_node = queue_head
		while (queue_node)
			if (ran && TICK_USAGE > TICK_LIMIT_RUNNING)
				break

			queue_node_flags = queue_node.subsystem_flags
			queue_node_priority = queue_node.queued_priority

			/**
			 * Super special case, subsystems where we can't make them pause mid way through.
			 * If we can't run them this tick (without going over a tick) we bump up their priority and attempt to run them next tick.
			 * (unless we haven't even ran anything this tick, since its unlikely they will ever be able run in those cases, so we just let them run)
			 */
			if (queue_node_flags & SS_NO_TICK_CHECK)
				if (queue_node.tick_usage > TICK_LIMIT_RUNNING - TICK_USAGE && ran_non_ticker)
					queue_node.queued_priority += queue_priority_count * 0.1
					queue_priority_count -= queue_node_priority
					queue_priority_count += queue_node.queued_priority
					current_tick_budget -= queue_node_priority
					queue_node = queue_node.queue_next
					continue

			if ((queue_node_flags & SS_BACKGROUND) && !bg_calc)
				current_tick_budget = queue_priority_count_bg
				bg_calc = TRUE

			tick_remaining = TICK_LIMIT_RUNNING - TICK_USAGE

			if (current_tick_budget > 0 && queue_node_priority > 0)
				tick_precentage = tick_remaining / (current_tick_budget / queue_node_priority)

			else
				tick_precentage = tick_remaining

			// Reduce tick allocation for subsystems that overran on their last tick.
			tick_precentage = max(tick_precentage*0.5, tick_precentage-queue_node.tick_overrun)

			current_ticklimit = round(TICK_USAGE + tick_precentage)

			if (!(queue_node_flags & SS_TICKER))
				ran_non_ticker = TRUE

			ran = TRUE

			queue_node_paused = (queue_node.state == SS_PAUSED)
			last_type_processed = queue_node

			queue_node.state = SS_RUNNING

			// ignite() will return immediately even if fire() sleeps.
			queue_node_tick_usage = TICK_USAGE
			var/state = queue_node.ignite(queue_node_paused)
			queue_node_tick_usage = TICK_USAGE - queue_node_tick_usage

			switch(state)
				if(SS_RUNNING)
					// fire() ran to completion
					state = SS_IDLE
				if(SS_PAUSED)
					// fire() ran and then pause()'d
					something_is_mid_cycle = TRUE
				if(SS_SLEEPING)
					// fire() slept; the subsystem may or may not pause later
					something_is_mid_cycle = TRUE
				else
					stack_trace("subsystem had unexpected state: [state]")
					state = SS_IDLE

			current_tick_budget -= queue_node_priority

			if (queue_node_tick_usage < 0)
				queue_node_tick_usage = 0

			queue_node.tick_overrun = max(0, MC_AVG_FAST_UP_SLOW_DOWN(queue_node.tick_overrun, queue_node_tick_usage-tick_precentage))
			queue_node.state = state

			// if it paused mid-run, track that ; do not eject it from the queue
			if (state == SS_PAUSED)
				queue_node.paused_ticks++
				queue_node.paused_tick_usage += queue_node_tick_usage
				queue_node = queue_node.queue_next
				continue

			// it did not pause. either this is a complete run, or the subsystem is sleeping.
			// in either case, we will track what we can and eject it; if it's sleeping, we can no longer manage the fire() call.
			queue_node.ticks = MC_AVERAGE(queue_node.ticks, queue_node.paused_ticks)

			queue_node_tick_usage += queue_node.paused_tick_usage
			queue_node.tick_usage = MC_AVERAGE_FAST(queue_node.tick_usage, queue_node_tick_usage)

			queue_node.cost = MC_AVERAGE_FAST(queue_node.cost, TICK_DELTA_TO_MS(queue_node_tick_usage))

			queue_node.paused_ticks = 0
			queue_node.paused_tick_usage = 0

			if (queue_node_flags & SS_BACKGROUND) // Update our running total.
				queue_priority_count_bg -= queue_node_priority
			else
				queue_priority_count -= queue_node_priority

			queue_node.last_fire = world.time
			queue_node.times_fired++

			// update the next time it should be available to queue
			queue_node.update_next_fire()
			// remove from queue
			queue_node.dequeue()
			// move to next
			queue_node = queue_node.queue_next

	. = something_is_mid_cycle ? MC_RUN_RTN_PARTIAL_COMPLETION : MC_RUN_RTN_FULL_COMPLETION

/**
 * Resets the queue, and all subsystems, while filtering out the subsystem lists called if any mc's queue procs runtime or exit improperly.
 *
 * Arguments:
 * * SSticker_SS - List of ticker subsystems to reset.
 * * runlevel_SS - List of runlevel subsystems to reset.
 */
/datum/controller/master/proc/SoftReset(list/SSticker_SS, list/runlevel_SS)
	. = FALSE
	log_world("MC: SoftReset called, resetting MC queue state.")
	if (!istype(subsystems) || !istype(SSticker_SS) || !istype(runlevel_SS))
		log_world("MC: SoftReset: Bad list contents: '[subsystems]' '[SSticker_SS]' '[runlevel_SS]'")
		return

	var/subsystemstocheck = subsystems + SSticker_SS
	for(var/I in runlevel_SS)
		subsystemstocheck |= I

	for (var/thing in subsystemstocheck)
		var/datum/controller/subsystem/SS = thing
		if (!SS || !istype(SS))
			// list(SS) is so if a list makes it in the subsystem list, we remove the list, not the contents
			subsystems -= list(SS)
			SSticker_SS -= list(SS)
			for(var/I in runlevel_SS)
				I -= list(SS)

			log_world("MC: SoftReset: Found bad entry in subsystem list, '[SS]'")
			continue

		if (SS.queue_next && !istype(SS.queue_next))
			log_world("MC: SoftReset: Found bad data in subsystem queue, queue_next = '[SS.queue_next]'")

		SS.queue_next = null
		if (SS.queue_prev && !istype(SS.queue_prev))
			log_world("MC: SoftReset: Found bad data in subsystem queue, queue_prev = '[SS.queue_prev]'")

		SS.queue_prev = null
		SS.queued_priority = 0
		SS.queued_time = 0
		SS.state = SS_IDLE
	if (queue_head && !istype(queue_head))
		log_world("MC: SoftReset: Found bad data in subsystem queue, queue_head = '[queue_head]'")

	queue_head = null
	if (queue_tail && !istype(queue_tail))
		log_world("MC: SoftReset: Found bad data in subsystem queue, queue_tail = '[queue_tail]'")

	queue_tail = null
	queue_priority_count = 0
	queue_priority_count_bg = 0
	log_world("MC: SoftReset: Finished.")
	. = TRUE

/datum/controller/master/stat_entry()
	return "(TickRate:[Master.processing]) (Iteration:[Master.iteration])"

/datum/controller/master/StartLoadingMap()
	// todo: this is kind of awful because this procs every subsystem unnecessarily
	//       you might say this is microoptimizations but this is called a seriously high number of times during a load.
	for(var/S in subsystems)
		var/datum/controller/subsystem/SS = S
		SS.StartLoadingMap()

/datum/controller/master/StopLoadingMap(bounds)
	// todo: this is kind of awful because this procs every subsystem unnecessarily
	//       you might say this is microoptimizations but this is called a seriously high number of times during a load.
	for(var/S in subsystems)
		var/datum/controller/subsystem/SS = S
		SS.StopLoadingMap()

/datum/controller/master/proc/on_config_loaded()
	for (var/thing in subsystems)
		var/datum/controller/subsystem/SS = thing
		SS.on_config_loaded()
	for(var/datum/controller/repository/repository in SSrepository.get_all_repositories())
		repository.on_config_loaded()

/**
 * CitRP snowflake special: Check if any subsystems are sleeping.
 */
/datum/controller/master/proc/laggy_sleeping_subsystem_check()
	for(var/datum/controller/subsystem/ss in subsystems)
		if(ss.state == SS_SLEEPING)
			return TRUE
	return FALSE
