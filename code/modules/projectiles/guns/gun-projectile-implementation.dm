//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * tl;dr
 *
 * we want eventually /gun/projectile so we don't have to have special behavior on /gun/launcher
 * and similar 'guns' that aren't actually projectile guns
 *
 * this way we have separation between behaviors only needed on guns that shoot
 * /obj/projectile's. that said, this is a little annoying to do (path length bloat)
 * so for now we put the projectile procs in their own file.
 *
 * maybe we won't do it after all due to path length bloat but the current method definitely just sucks.
 */

/**
 * Obtains the next projectile to fire.
 *
 * Either will return an /obj/projectile,
 * or return a GUN_FIRED_* define that is not SUCCESS.
 *
 * * Things like jams go in here.
 * * Things like 'the next bullet is empty so we fail' go in here
 * * This should be called *as* the point of no return. This has side effects.
 * * Everything is optional here. Things like portable turrets reserve the right to 'pull' from the gun without caring about params.
 *
 * @params
 * * iteration - (optional) the iteration of the fire
 * * firing_flags - (optional) GUN_FIRING_* flags
 * * firemode - (optional) the firemode
 * * actor - (optional) the initiator
 * * firer - (optional) the actual firer
 */
/obj/item/gun/proc/consume_next_projectile(iteration, firing_flags, datum/firemode/firemode, datum/event_args/actor/actor, atom/firer)
	. = GUN_FIRED_FAIL_UNKNOWN
	// todo: on base /gun/projectile?
	CRASH("attempted to process next projectile on base /gun")
