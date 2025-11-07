/datum/world_debug_enabler/New()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		LIBCALL(debug_server, "auxtools_init")()
		enable_debugging()
		debug_loop()

/datum/world_debug_enabler/proc/debug_loop()
	set waitfor = FALSE
	debug_loop_impl()

/**
 * the sole job of this is keep ticking so the debug server can still do stuff while no clients are conencted
 */
/datum/world_debug_enabler/proc/debug_loop_impl()
	while(TRUE)
		sleep(world.tick_lag)
