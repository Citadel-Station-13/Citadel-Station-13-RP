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
		// todo: proper twohanding system
		held_twohanded = mob_firer.can_wield_item(src) && is_held_twohanded(mob_firer)
		mob_firer.break_cloak()

	// point of no return
	var/obj/projectile/firing_projectile = consume_next_projectile(cycle)
	if(!istype(firing_projectile))
		// it's an error code if it's not real
		return firing_projectile

	// todo: do we really need to newtonian move always?
	if(ismovable(cycle.firing_atom))
		var/atom/movable/movable_firer = cycle.firing_atom
		movable_firer.newtonian_move(angle2dir(cycle.original_angle))

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
