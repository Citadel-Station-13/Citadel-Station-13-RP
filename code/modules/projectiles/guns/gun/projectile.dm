//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Guns that shoot projectiles. Simple, eh?
 */
/obj/item/gun/projectile

/obj/item/gun/projectile/fire(datum/gun_firing_cycle/cycle)
	//! LEGACY
	// handle legacy systems
	var/held_twohanded = TRUE
	if(ismob(cycle.firing_atom))
		held_twohanded = item_flags & ITEM_MULTIHAND_WIELDED
	//! END

	// point of no return
	var/obj/projectile/firing_projectile = consume_next_projectile(cycle)
	if(!istype(firing_projectile))
		// it's an error code if it's not real
		return firing_projectile
	// sike; real point of no return
	SEND_SIGNAL(src, COMSIG_GUN_FIRING_PROJECTILE_INJECTION, cycle, firing_projectile)
	// if they want to abort..
	if(cycle.next_firing_fail_result)
		// todo: deleting projectile here immediately in all cases is potentially unsound
		qdel(firing_projectile)
		return cycle.next_firing_fail_result

	//! LEGACY
	process_accuracy(firing_projectile, cycle.firing_actor?.performer, cycle.original_target, cycle.cycle_iterations_fired, held_twohanded)
	// todo: this is ass because if the projectile misses we still get additional damage
	// todo: Reachability(), not Adjacent().
	if((cycle.firing_flags & GUN_FIRING_POINT_BLANK) && cycle.original_target && cycle.firing_atom.Adjacent(cycle.original_target))
		process_point_blank(firing_projectile, cycle.firing_actor?.performer, cycle.original_target)
	play_fire_sound(cycle.firing_actor?.performer, firing_projectile)
	//! END

	if(!isturf(cycle.firing_atom.loc))
		return GUN_FIRED_FAIL_UNMOUNTED
	launch_projectile(cycle, firing_projectile)

	..()
	. = GUN_FIRED_SUCCESS

/**
 * Called to actually fire a projectile.
 */
/obj/item/gun/projectile/proc/launch_projectile(datum/gun_firing_cycle/cycle, obj/projectile/launching)
	//! LEGACY
	// this is just stupid lol why are we transcluding name directly into autopsy reports??
	launching.shot_from = src.name
	// this shouldn't be a hard-set thing and should be attachment set
	launching.silenced = src.silenced
	launching.p_x = cycle.original_tile_pixel_x
	launching.p_y = cycle.original_tile_pixel_y
	//! END

	launching.original_target = cycle.original_target
	launching.firer = cycle.firing_atom
	launching.def_zone = cycle.original_target_zone

	var/effective_angle = cycle.original_angle + cycle.base_angle_adjust + cycle.next_angle_adjust
	var/effective_dispersion = cycle.base_dispersion_adjust + cycle.next_dispersion_adjust

	effective_angle += rand(-effective_dispersion, effective_dispersion)
	launching.set_angle(effective_angle)

	launching.forceMove(cycle.firing_atom.loc)
	launching.add_projectile_effects(cycle.firemode.projectile_effects_add)
	launching.fire(effective_angle, get_turf(cycle.original_target) == get_turf(src) ? cycle.original_target : null)

/**
 * Obtains the next projectile to fire.
 *
 * Either will return an /obj/projectile,
 * or return a GUN_FIRED_* define that is not SUCCESS.
 *
 * * Things like jams go in here.
 * * Things like 'the next bullet is empty so we fail' go in here
 * * Everything is optional here. Things like portable turrets reserve the right to 'pull' from the gun without caring about params.
 *
 * This should be called as the point of no return.
 *
 * * All of your checks that can / should fail go before the ..() call, as that's what makes the projectile.
 * * Anything that doesn't do anything but emit side effects go after.
 * * Once the projectile is made, you must delete it if you want to cancel. Otherwise, it's a memory leak.
 */
/obj/item/gun/projectile/proc/consume_next_projectile(datum/gun_firing_cycle/cycle)
	SHOULD_NOT_SLEEP(TRUE)
	. = GUN_FIRED_FAIL_UNKNOWN
	// todo: on base /gun/projectile?
	CRASH("attempted to process next projectile on base /gun")
