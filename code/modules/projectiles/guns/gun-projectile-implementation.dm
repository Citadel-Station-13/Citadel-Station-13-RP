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
/obj/item/gun/proc/fire(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	#warn impl; check unmount

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

/**
 * Called to actually fire a projectile.
 */
/obj/item/gun/proc/launch_projectile(datum/gun_firing_cycle/cycle, obj/projectile/launching)
	//! LEGACY
	// this is just stupid lol why are we transcluding name directly into autopsy reports??
	launching.shot_from = src.name
	// this shouldn't be a hard-set thing and should be attachment set
	launching.silenced = src.silenced
	//! END

	var/effective_angle = cycle.original_angle

	#warn launching's launch_projectile_common

	launching.fire(effective_angle, get_turf(cycle.original_target) == get_turf(src) ? cycle.original_target : null)

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
 */
/obj/item/gun/proc/consume_next_projectile(datum/gun_firing_cycle/cycle)
	. = GUN_FIRED_FAIL_UNKNOWN
	// todo: on base /gun/projectile?
	CRASH("attempted to process next projectile on base /gun")
