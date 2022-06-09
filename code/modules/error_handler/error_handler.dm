// Why? Because when you screw up too early in init, total runtimes won't be initialized. You can see why this can be a problem, right?
GLOBAL_REAL_VAR(total_runtimes) = 0
GLOBAL_VAR_INIT(total_runtimes_seen, 0)
GLOBAL_VAR_INIT(total_runtimes_skipped, 0)
// to detect when someone fucks up royally and breaks error handling with preinit runtimes
GLOBAL_REAL_VAR(runtime_skip_once) = FALSE
GLOBAL_REAL_VAR(runtime_trap_triggered) = FALSE

#ifdef USE_CUSTOM_ERROR_HANDLER

#define ERROR_USEFUL_LEN 2
/world/Error(exception/E, datum/e_src)

#ifdef UNIT_TESTS
	if(runtime_skip_once)
		runtime_skip_once = FALSE
		runtime_trap_triggered = TRUE
		return
#endif

	++global.total_runtimes

	var/static/list/error_last_seen = list()
	var/static/list/error_cooldown = list() /* Error_cooldown items will either be positive(cooldown time) or negative(silenced error)
												If negative, starts at -1, and goes down by 1 each time that error gets skipped*/

	if(!GLOB || !error_last_seen)
		log_world("early runtime caught;")
		return ..()

	++GLOB.total_runtimes_seen

	if(!istype(E)) //Something threw an unusual exception
		log_world("uncaught runtime error: [E]")
		return ..()

	//this is snowflake because of a byond bug (ID:2306577), do not attempt to call non-builtin procs in this if
	if(copytext(E.name, 1, 32) == "Maximum recursion level reached")
		// log world without another call
		SEND_TEXT(world.log, "runtime error: [E.name]\n[E.desc]")
		// intentionally trigger the byond bug.
		pass()
		// if we got to here without silently ending, the byond bug has been fixed.
		log_world("The bug with recursion runtimes has been fixed. Please remove the snowflake check from world/Error in [__FILE__]:[__LINE__]")
		// this will never happen.
		return

	else if(copytext(E.name, 1, 18) == "Out of resources!")
		log_world("BYOND out of memory. Restarting")
		log_game("BYOND out of memory. Restarting")
		TgsEndProcess()
		Reboot(reason = 1)
		return ..()

	if (islist(stack_trace_storage))
		for (var/line in splittext(E.desc, "\n"))
			if (text2ascii(line) != 32)
				stack_trace_storage += line

	var/erroruid = "[E.file][E.line]"
	var/last_seen = error_last_seen[erroruid]
	var/cooldown = error_cooldown[erroruid] || 0

	if(last_seen == null)
		error_last_seen[erroruid] = world.time
		last_seen = world.time

	if(cooldown < 0)
		error_cooldown[erroruid]-- //Used to keep track of skip count for this error
		GLOB.total_runtimes_skipped++
		return //Error is currently silenced, skip handling it

	//Handle cooldowns and silencing spammy errors
	var/silencing = FALSE

	var/configured_error_cooldown = 600
	var/configured_error_limit = 50
	var/configured_error_silence_time = 6000

/*
	// We can runtime before config is initialized because BYOND initialize objs/map before a bunch of other stuff happens.
	// This is a bunch of workaround code for that. Hooray!
	var/configured_error_cooldown
	var/configured_error_limit
	var/configured_error_silence_time
	if(config && config_legacy.entries)
		configured_error_cooldown = CONFIG_GET(number/error_cooldown)
		configured_error_limit = CONFIG_GET(number/error_limit)
		configured_error_silence_time = CONFIG_GET(number/error_silence_time)
	else
		var/datum/config_entry/CE = /datum/config_entry/number/error_cooldown
		configured_error_cooldown = initial(CE.default)
		CE = /datum/config_entry/number/error_limit
		configured_error_limit = initial(CE.default)
		CE = /datum/config_entry/number/error_silence_time
		configured_error_silence_time = initial(CE.default)
*/

	//Each occurence of a unique error adds to its cooldown time...
	cooldown = max(0, cooldown - (world.time - last_seen)) + configured_error_cooldown
	// ... which is used to silence an error if it occurs too often, too fast
	if(cooldown > configured_error_cooldown * configured_error_limit)
		cooldown = -1
		silencing = TRUE
		spawn(0)
			usr = null
			sleep(configured_error_silence_time)
			var/skipcount = abs(error_cooldown[erroruid]) - 1
			error_cooldown[erroruid] = 0
			if(skipcount > 0)
				SEND_TEXT(world.log, "\[[time_stamp()]] Skipped [skipcount] runtimes in [E.file],[E.line].")
				GLOB.error_cache.log_error(E, skip_count = skipcount)

	error_last_seen[erroruid] = world.time
	error_cooldown[erroruid] = cooldown

	var/list/usrinfo = null
	var/locinfo
	if(istype(usr))
		usrinfo = list("  usr: [key_name(usr)]")
		locinfo = loc_name(usr)
		if(locinfo)
			usrinfo += "  usr.loc: [locinfo]"
	// The proceeding mess will almost definitely break if error messages are ever changed
	var/list/splitlines = splittext(E.desc, "\n")
	var/list/desclines = list()
	if(LAZYLEN(splitlines) > ERROR_USEFUL_LEN) // If there aren't at least three lines, there's no info
		for(var/line in splitlines)
			if(LAZYLEN(line) < 3 || findtext(line, "source file:") || findtext(line, "usr.loc:"))
				continue
			if(findtext(line, "usr:"))
				if(usrinfo)
					desclines.Add(usrinfo)
					usrinfo = null
				continue // Our usr info is better, replace it

			if(copytext(line, 1, 3) != "  ")
				desclines += ("  " + line) // Pad any unpadded lines, so they look pretty
			else
				desclines += line
	if(usrinfo) //If thi	s info isn't null, it hasn't been added yet
		desclines.Add(usrinfo)
	if(silencing)
		desclines += "  (This error will now be silenced for [DisplayTimeText(configured_error_silence_time)])"
	GLOB.error_cache?.log_error(E, desclines)

	var/main_line = "\[[time_stamp()]] Runtime in [E.file],[E.line]: [E]"
	SEND_TEXT(world.log, main_line)
	for(var/line in desclines)
		SEND_TEXT(world.log, line)

#ifdef UNIT_TESTS
	//good day, sir
	GLOB.current_test?.Fail("[main_line]\n[desclines.Join("\n")]")
#endif

	// This writes the regular format (unwrapping newlines and inserting timestamps as needed).
	log_runtime("runtime error: [E.name]\n[E.desc]")

#endif
