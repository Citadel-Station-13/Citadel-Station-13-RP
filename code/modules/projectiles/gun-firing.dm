//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Firing Cycle *//

#warn impl all

/**
 * called exactly once at the start of a firing cycle to start it
 *
 * @params
 * * firer - the thing physically firing us; whether a turret or a person
 * * angle - the angle to fire in.
 * * firing_flags - GUN_FIRING_* flags
 * * firemode - the /datum/firemode we are firing on
 * * target - (optional) what we're firing at
 * * actor - (optional) the person who initiated the firing
 */
/obj/item/gun/proc/firing_cycle(atom/firer, angle, firing_flags, datum/firemode/firemode, atom/target, datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE)

	#warn start_firing_cycle, end_firing_cycle

//* Firing *//

/**
 * called to perform a single firing operation
 *
 * @params
 * * firer - the thing physically firing us; whether a turret or a person
 * * angle - the angle to fire in.
 * * firing_flags - GUN_FIRING_* flags
 * * firemode - the /datum/firemode we are firing on
 * * iteration - burst iteration; for single-firing, this is always 1.
 * * target - (optional) what we're firing at
 * * actor - (optional) the person who initiated the firing
 */
/obj/item/gun/proc/fire(atom/firer, angle, firing_flags, datum/firemode/firemode, iteration, atom/target, datum/event_args/actor/actor)
