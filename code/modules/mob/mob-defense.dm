//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Impact Handling *//

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
	process_damage_instance(args, def_zone)
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

//* Armor - Only run against armor. *//

/**
 * An override of /atom/proc/run_armorcalls(), with zone filter capability.
 *
 * This is what you should override, instead of the check/run procs.
 *
 * * At current moment, due to expensiveness reasons, not providing filter_zone will result in only SHIELDCALL_ARG_DAMAGE being modified.
 *
 * @params
 * * shieldcall_args - passed in shieldcall args list to modify
 * * fake_attack - are we just checking armor?
 * * filter_zone - confine to a certain hit zone. this is **required** for full processing, otherwise we just check overall damage.
 */
/mob/run_armorcalls(list/shieldcall_args, fake_attack, filter_zone)
	..() // perform default /atom level

/**
 * Generic, low-level armor check for inbound attacks
 *
 * * This will filter armor by zone.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/check_mob_armor(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, TRUE, hit_zone) // by default, use atom/var/armor on ourselves

/**
 * Generic, low-level armor processing for inbound attacks
 *
 * * This will filter armor by zone.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/run_mob_armor(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, FALSE, hit_zone) // by default, use atom/var/armor on ourselves

/**
 * Checks the average armor for a full-body attack.
 *
 * * this is used for lazy-sim's like explosion where we're not simulating every limb's individual damage tick.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/check_mob_overall_armor(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, TRUE) // by default, use atom/var/armor on ourselves

/**
 * Checks the average armor for a full-body attack.
 *
 * * this is used for lazy-sim's like explosion where we're not simulating every limb's individual damage tick.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/run_mob_overall_armor(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, FALSE) // by default, use atom/var/armor on ourselves

//* Defense - Run against armor, as well as shieldcalls *//

/**
 * Generic, low-level defense check for inbound attacks
 *
 * * This will filter defense by zone.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/check_mob_defense(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, TRUE, hit_zone) // by default, use atom/var/armor on ourselves
	run_shieldcalls(args, TRUE)

/**
 * Generic, low-level defense processing for inbound attacks
 *
 * * This will filter defense by zone.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/run_mob_defense(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, FALSE, hit_zone) // by default, use atom/var/armor on ourselves
	run_shieldcalls(args, FALSE)

/**
 * Checks the average defense for a full-body attack.
 *
 * * this is used for lazy-sim's like explosion where we're not simulating every limb's individual damage tick.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/check_mob_overall_defense(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, TRUE) // by default, use atom/var/armor on ourselves
	run_shieldcalls(args, TRUE)

/**
 * Checks the average defense for a full-body attack.
 *
 * * this is used for lazy-sim's like explosion where we're not simulating every limb's individual damage tick.
 * * This operates like [atom_shieldcall()].
 *
 * @return modified argument list, with SHIELDCALL_ARG_* defines as indices.
 */
/mob/proc/run_mob_overall_defense(SHIELDCALL_PROC_HEADER)
	SHOULD_NOT_OVERRIDE(TRUE)
	run_armorcalls(args, FALSE) // by default, use atom/var/armor on ourselves
	run_shieldcalls(args, FALSE)
