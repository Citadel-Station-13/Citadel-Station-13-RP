//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Guns that fire /obj/projectile's.
 */
/obj/item/gun/projectile
	//* Accuracy & Stability
	/// tuning factor for how much instability goes into dispersion rather than accuracy
	var/instability_balancing = 1
	#warn lmfao this tuning factor

	//* Rendering
	/// projectile typepath hint for chameleon weapons, if autodetection otherwise fails.
	var/rendered_projectile_type = /obj/projectile/bullet/pistol/strong
	#warn impl

/obj/item/gun/projectile/fire(atom/target, atom/movable/user, angle, reflex, point_blank)
	#warn impl

	var/obj/projectile/firing_projectile = consume_next_projectile()
	if(isnull(firing_projectile))
		return GUN_FIRE_NO_AMMO

/**
 * get the projectile to use
 * this is the point of no return proc.
 *
 * @params
 * * firer - (optional) ; firer
 *
 * if we return null, the firing should fail
 */
/obj/item/gun/projectile/proc/consume_next_projectile(atom/movable/firer)
	return null

/**
 * Get max ammo - used in rendering
 */
/obj/item/gun/projectile/proc/get_max_ammo()
	return 0

/**
 * Get ammo left - used in rendering
 */
/obj/item/gun/projectile/proc/get_count_ammo()
	return 0
