//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Microbattery ballistics.
 *
 * * Technically, any ballistic weapon can fire microbattery ammo. It's the same backend.
 *   All it needs is to be compatible with the casing priming.
 * * That said, this type has semantics like mode switches.
 */
/obj/item/gun/projectile/ballistic/microbattery
	recoil = 0

#warn impl all

#warn action for cycling the magazine

/obj/item/gun/projectile/ballistic/microbattery/proc/cycle_microbattery_group()
	#warn impl

