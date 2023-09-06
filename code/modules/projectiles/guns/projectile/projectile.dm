//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Guns that fire /obj/projectile's.
 */
/obj/item/gun/projectile
	#warn impl

/obj/item/gun/projectile/fire(atom/target, atom/movable/user, angle, reflex, point_blank)
	#warn impl

	var/obj/projectile/firing_projectile = consume_next_projectile()
	if(isnull(firing_projectile))
		return FALSE

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
