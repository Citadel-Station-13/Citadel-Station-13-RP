/**
 *! DO NOT USE THIS. THIS IS BEING DEPRECATED BY PROCESSING SUBSYSTEMS (controllers/subsystems/processing) AND TIMERS.
 */

/**
 *! README:
 *
 * The global_iterator datum is supposed to provide a simple and robust way to
 * create some constantly "looping" processes with ability to stop and restart them at will.
 * Generally, the only thing you want to play with (meaning, redefine) is the process() proc.
 * It must contain all the things you want done.
 *
 *! Control functions:
 *?	new - used to create datum. First argument (optional) - var list(to use in process() proc) as list,
 * 	second (optional) - autostart control.
 * 	If autostart == TRUE, the loop will be started immediately after datum creation.
 *
 *?	start(list/arguments) - starts the loop. Takes arguments(optional) as a list, which is then used
 * 	by process() proc. Returns null if datum already active, 1 if loop started succesfully and 0 if there's
 * 	an error in supplied arguments (not list or empty list).
 *
 *?	stop() - stops the loop. Returns null if datum is already inactive and 1 on success.
 *
 *?	set_delay(new_delay) - sets the delay between iterations. Pretty selfexplanatory.
 * 	Returns 0 on error(new_delay is not numerical), 1 otherwise.
 *
 *?	set_process_args(list/arguments) - passes the supplied arguments to the process() proc.
 *
 *?	active() - Returns 1 if datum is active, 0 otherwise.
 *
 *?	toggle() - toggles datum state. Returns new datum state (see active()).
 *
 *! Misc functions:
 *
 *?	get_last_exec_time() - Returns the time of last iteration.
 *
 *?	get_last_exec_time_as_text() - Returns the time of last iteration as text
 *
 *
 *! Control vars:
 *
 *?	delay - 	delay between iterations
 *
 *?	check_for_null - if equals TRUE, on each iteration the supplied arguments will be checked for nulls.
 * 	If some varible equals null (and null only), the loop is stopped.
 * 	Usefull, if some var unexpectedly becomes null - due to object deletion, for example.
 * 	Of course, you can also check the variables inside process() proc to prevent runtime errors.
 *
 *! Data storage vars:
 *
 *?	result - stores the value returned by process() proc
 */

/datum/global_iterator
	var/control_switch = FALSE
	var/delay = 10
	var/list/arg_list = new
	var/last_exec = null
	var/check_for_null = TRUE
	var/forbid_garbage = FALSE
	var/result
	var/state = FALSE

/datum/global_iterator/New(list/arguments = null, autostart = TRUE)
	delay = (delay > 0) ? (delay) : FALSE
	if(forbid_garbage) //prevents garbage collection with tag != null
		tag = "\ref[src]"
	set_process_args(arguments)
	if(autostart)
		INVOKE_ASYNC(src, .proc/start)
	return

/datum/global_iterator/proc/main()
	state = TRUE
	while(src && control_switch)
		last_exec = world.timeofday
		if(check_for_null && has_null_args())
			stop()
			return FALSE
		result = process(arglist(arg_list))
		for(var/sleep_time=delay;sleep_time>0;sleep_time--) //uhh, this is ugly. But I see no other way to terminate sleeping proc. Such disgrace.
			if(!control_switch)
				return FALSE
			sleep(1)
	return FALSE

/datum/global_iterator/proc/start(list/arguments = null)
	if(active())
		return
	if(arguments)
		if(!set_process_args(arguments))
			return FALSE
	if(!state_check()) //the main loop is sleeping, wait for it to terminate.
		return
	control_switch = TRUE
	spawn()
		state = main()
	return TRUE

/datum/global_iterator/proc/stop()
	if(!active())
		return
	control_switch = FALSE
	spawn(-1) //report termination error but don't wait for state_check().
		state_check()
	return TRUE

/datum/global_iterator/proc/state_check()
	var/lag = 0
	while(state)
		sleep(1)
		if(++lag>10)
			CRASH("The global_iterator loop \ref[src] failed to terminate in designated timeframe. This may be caused by server lagging.")
	return TRUE

/datum/global_iterator/proc/active()
	return control_switch

/datum/global_iterator/proc/has_null_args()
	if(null in arg_list)
		return TRUE
	return FALSE


/datum/global_iterator/proc/set_delay(new_delay)
	if(isnum(new_delay))
		delay = max(1, round(new_delay))
		return TRUE
	else
		return FALSE

/datum/global_iterator/proc/get_last_exec_time()
	return (last_exec || 0)

/datum/global_iterator/proc/get_last_exec_time_as_text()
	return (time2text(last_exec) || "Wasn't executed yet")

/datum/global_iterator/proc/set_process_args(list/arguments)
	if(arguments && istype(arguments, /list) && arguments.len)
		arg_list = arguments
		return TRUE
	else
		return FALSE

/datum/global_iterator/proc/toggle_null_checks()
	check_for_null = !check_for_null
	return check_for_null

/datum/global_iterator/proc/toggle()
	if(!stop())
		start()
	return active()

/datum/global_iterator/Destroy()
	. = ..()
	arg_list.Cut()
	stop()
	return QDEL_HINT_LETMELIVE
	//Do not call ..()
