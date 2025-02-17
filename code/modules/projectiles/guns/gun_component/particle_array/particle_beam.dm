//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_component/particle_array/particle_beam
	name = /obj/item/gun_component/particle_array::name + " (laser)"
	desc = "A particle array that emits a damaging beam. Bog-standard, really."

	base_charge_cost = /obj/item/cell/device/weapon::maxcharge / 10
	considered_lethal = TRUE
	selection_name = "laser"
	render_color = "#ff0000"

	// todo: /obj/projectile/modular_energy/*
	//       allows for easier runtime reflection
	projectile_type = /obj/projectile/beam
