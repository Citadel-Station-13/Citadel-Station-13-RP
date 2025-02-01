//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/particle_array/particle_beam
	name = /obj/item/gun_component/particle_array::name + " (particle beam)"
	desc = "A particle array that emits a damaging beam. Bog-standard, really."

	base_energy_cost = /obj/item/cell/device/weapon::maxcharge / 8 * 500
	considered_lethal = TRUE

	// todo: /obj/projectile/modular_energy/*
	//       allows for easier runtime reflection
	projectile_type = /obj/projectile/beam
