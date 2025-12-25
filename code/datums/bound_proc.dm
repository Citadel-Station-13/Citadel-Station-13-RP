//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Lightweight variant of a callback.
 *
 * ! SECURITY WARNING: Do not allow arbitrarily passing things in when making this. !
 * ! It is VV and proccall guarded, but we cannot stop other functions from making  !
 * ! one while being proccalled, as there are legitimate use cases for that!!       !
 */
/datum/bound_proc
	/// target; either a /datum or [GLOBAL_PROC]
	var/delegate
	/// proc reference of what to call on target
	var/binding

/datum/bound_proc/New(delegate, binding)
	src.delegate = delegate
	src.binding = binding

/datum/bound_proc/proc/invoke(...)
	if(delegate == GLOBAL_PROC)
		call(binding)(arglist(args))
	else
		call(delegate, binding)(arglist(args))

/datum/bound_proc/proc/invoke_async(...)
	ASYNC
		if(delegate == GLOBAL_PROC)
			call(binding)(arglist(args))
		else
			call(delegate, binding)(arglist(args))

/datum/bound_proc/CanProcCall(procname)
	return FALSE

/datum/bound_proc/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	return FALSE
