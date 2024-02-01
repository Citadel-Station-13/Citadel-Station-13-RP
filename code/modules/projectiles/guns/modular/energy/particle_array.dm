//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * generates a projectile - used in energy weapons
 */
/obj/item/modular_gun_part/particle_array
	/// projectile type
	var/projectile_type = /obj/projectile/beam
	/// projectile cost
	var/projectile_cost = 300
	/// hint: is the projectile hitscan?
	var/projectile_hitscan = FALSE
	/// descriptor
	var/array_type_descriptor = "unknown"

/obj/item/modular_gun_part/particle_array/projectile
	projectile_hitscan = FALSE
	array_type_descriptor = "accelerated"

/obj/item/modular_gun_part/particle_array/hitscan
	projectile_hitscan = TRUE
	array_type_descriptor = "pulsed"


#warn impl
