//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/particle_array
	name = "weapon particle array"
	desc = "A nondescript particle array used in energy weapons."
	icon = 'icons/modules/projectiles/components/particle_array.dmi'
	component_slot = GUN_COMPONENT_PARTICLE_ARRAY

	/// base charge cost
	var/charge_cost = /obj/item/cell/device/weapon::maxcharge / 24

/obj/item/gun_component/particle_array/proc/generate_projectile(datum/gun_firing_cycle/cycle)
	return

// TODO: This file is mostly stubs and WIPs.
