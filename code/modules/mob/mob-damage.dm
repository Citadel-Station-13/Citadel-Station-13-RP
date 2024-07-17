//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Damage Instance Handling *//

/**
 * standard damage handling - process an instance of damage
 *
 * args are the same as shieldcall args, because this directly invokes shield/armorcalls
 *
 * * additional args past the normal shieldcall args are allowed, but not before!
 * * the entire args list is extracted via return, allowing for handling by caller.
 * * damage is assumed to be zone'd if def_zone is set; otherwise it's overall
 * * please note that overall damage doesn't check armor properly a lot of the time!
 *
 * @return modified args
 */
/mob/proc/run_damage_instance(SHIELDCALL_PROC_HEADER)
	process_damage_instance(args, hit_zone)
	if(shieldcall_flags & SHIELDCALL_RETURNS_ABORT_ATTACK)
		return args
	inflict_damage_instance(arglist(args))
	return args

/**
 * process an instance of damage through defense handling.
 */
/mob/proc/process_damage_instance(list/shieldcall_args, filter_zone)
	run_shieldcalls(shieldcall_args, FALSE)
	if(shieldcall_args[SHIELDCALL_ARG_FLAGS] & (SHIELDCALL_RETURNS_SHOULD_TERMINATE | SHIELDCALL_RETURNS_ABORT_ATTACK))
		return
	run_armorcalls(shieldcall_args, FALSE, filter_zone)

/**
 * inflict an instance of damage.
 *
 * * this happens after shieldcalls, armor checks, etc, all resolve.
 * * at this point, nothing should modify damage
 * * for things like limb damage and armor handling, check the armor/etc in process_damage_instance
 * * this is pretty much the handoff point where defense processing hands off to medical code for wound creation.
 * * for this reason, we do not allow any returns.
 */
/mob/proc/inflict_damage_instance(SHIELDCALL_PROC_HEADER)
	return
