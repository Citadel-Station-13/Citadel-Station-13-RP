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
 */

/**
 * called to perform a single firing operation
 */
#warn into projectile.dm
/obj/item/gun/proc/fire(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)

	// handle legacy systems
	var/held_twohanded = TRUE
	if(ismob(cycle.firing_atom))
		var/mob/mob_firer = cycle.firing_atom
		held_twohanded = item_flags & ITEM_MULTIHAND_WIELDED
		mob_firer.break_cloak()

	// point of no return
	var/obj/projectile/firing_projectile = consume_next_projectile(cycle)
	if(!istype(firing_projectile))
		// it's an error code if it's not real
		return firing_projectile
	// sike; real point of no return
	SEND_SIGNAL(src, COMSIG_GUN_FIRING_PROJECTILE_INJECTION, cycle, firing_projectile)
	// if they want to abort..
	if(cycle.next_firing_fail_result)
		qdel(firing_projectile)
		return cycle.next_firing_fail_result

	//! LEGACY
	process_accuracy(firing_projectile, cycle.firing_actor?.performer, cycle.original_target, cycle.cycle_iterations_fired, held_twohanded)
	// todo: this is ass because if the projectile misses we still get additional damage
	// todo: Reachability(), not Adjacent().
	if((cycle.firing_flags & GUN_FIRING_POINT_BLANK) && cycle.original_target && cycle.firing_atom.Adjacent(cycle.original_target))
		process_point_blank(firing_projectile, cycle.firing_actor?.performer, cycle.original_target)
	play_fire_sound(cycle.firing_actor?.performer, firing_projectile)
	launch_projectile(cycle, firing_projectile)
	//! END

	// record stuff
	last_fire = world.time

	// todo: do we really need to newtonian move always?
	if(ismovable(cycle.firing_atom))
		var/atom/movable/movable_firer = cycle.firing_atom
		movable_firer.newtonian_move(angle2dir(cycle.original_angle))

	// todo: muzzle flash
