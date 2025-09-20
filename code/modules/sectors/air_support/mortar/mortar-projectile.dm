//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * mortar projectiles
 * * mortar rounds are projectiles to take advantage
 *   of existing projectile backend.
 * * mortar rounds do not necessarily need to perform the full travel path mechanically;
 *   the implementation is allowed to simply spawn the projectile at the end and
 *   proc hitting a turf.
 * * mortar rounds generally do not carry information about what happens
 *   at flight termination, instead allowing the casing to do it.
 */
/obj/projectile/mortar
	name = "mortar round"
	desc = "You really, <i>really</i> shouldn't be close enough to see this."

	/// stored internally as it has on_detonate() called when we hit
	var/obj/item/ammo_casing/mortar/mortar_round

#warn impl
