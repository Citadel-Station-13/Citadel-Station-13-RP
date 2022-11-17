/**
 * DO NOT MOVE THIS FILE. EVER. THIS ABSOLUTELY MUST GO RIGHT AFTER COMPLE OPTIONS, BECAUSE WE **NEED** THESE DATUMS TO INIT BEFORE **ANY** OTHER IMPLICIT INIT PROCS!
 */

//! Log shunting - ENSURE shunt_redirected_log() IS CALLED IMMEDIATELY AFTER LOGGING IS SET UP!

/**
 * log shunter, CITRP SNOWFLAKE EDITION
 *
 * Now, WHY would you ignore /tg/'s magical nice init order for this?
 *
 * BECAUSE, my friend, when GLOB or even Master's New() runtimes, world.log is still in a void, because of TGS operation (you can't see a window that isn't there!)
 *
 * Therefore, we run world.ensure_logging_active() to shunt world.log to a temporary log that always is there.
 *
 * When world logging is set up, it's shunted into the normal logs perfectly. If the world "runtime error" is found anywhere in it, test runs will fail.
 *
 * NOW, when things break, I don't have to ping a host, a headcoder, 3 citadel maintainers, and Lummox JR trying to get a fix
 *
 * thanks oranges/MSO for hinting to me about using -verbose so we can end this fucking suffering.
 */
var/datum/world_log_shunter/world_log_shunter = new
var/world_log_redirected = FALSE

/datum/world_log_shunter/New()
	world.ensure_logging_active()

//! Debugging
var/datum/world_debug_enabler/world_debug_enabler = new

/datum/world_debug_enabler/New()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_init")()
		enable_debugging()
