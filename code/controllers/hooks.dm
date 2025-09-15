//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Typed hooks system.
 *
 * Simply override a hook. This is more expensive than
 * the old hooks system because it does involve creating datums
 * (i cba to figure out using text2path to invoke instead)
 * but is safer.
 *
 * * You are expected to know how 'waitfor' works in BYOND. Hooks are a relatively
 *   low level system, and it's not always safe to mess with if you don't know what
 *   you're doing.
 */
/hook
	abstract_type = /hook
	parent_type = /datum

/**
 * Always invoked asynchronously.
 * @return FALSE if failed invocation, which will be logged in debug logs / stack traces.
 */
/hook/proc/invoke()
	return TRUE

/**
 * Low level proc, don't call unless you know what you're doing.
 */
/proc/invoke_hooks(path, list/arguments)
	. = TRUE
	var/list/failed_hook_paths
	for(var/hook/hook_path as anything in typesof(path))
		if(hook_path.abstract_type == hook_path)
			continue
		var/hook/hook_instance = new hook_path
		if(!hook_instance.invoke(arglist(arguments)))
			. = FALSE
			if(!failed_hook_paths)
				failed_hook_paths = list()
			failed_hook_paths += hook_path
	if(!.)
		stack_trace("hook invocation failed for the following paths: [english_list(failed_hook_paths)]")

//* hooks - /client *//

/hook/client_stability_check
	abstract_type = /hook/client_stability_check

/**
 * Used for client stability checks.
 * Anything running in this will run asynchronously.
 */
/hook/client_stability_check/invoke(client/joining)
	return TRUE

/proc/invoke_hooks__client_stability_check(client/joining)
	invoke_hooks(/hook/client_stability_check, list(joining))
