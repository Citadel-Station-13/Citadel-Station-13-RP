//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun_component/particle_array/particle_beam, /gun_component/particle_array/particle_beam, "gun_component-particle_array-particle_beam")
/obj/item/gun_component/particle_array/particle_beam
	name = /obj/item/gun_component/particle_array::name + " (laser)"
	desc = "A particle array that emits a damaging beam. Bog-standard, really."

	base_charge_cost = /obj/item/cell/device/weapon::maxcharge / 12
	considered_lethal = TRUE
	selection_name = "laser"
	render_color = "#ff0000"

	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 250,
	)

	projectile_type = /obj/projectile/particle_array/particle_beam

/obj/projectile/particle_array/particle_beam
	name = "laser"
	icon_state = "laser"
	pass_flags = ATOM_PASS_FLAGS_BEAM
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_LASER
	damage_tier = 3
	damage_force = 30
	projectile_type = PROJECTILE_TYPE_BEAM | PROJECTILE_TYPE_PHOTONIC
	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY
	hitscan = TRUE
	color = "#ff1100"
	tracer_icon_state = "laser-1"
	tracer_add_state = TRUE
	tracer_add_state_alpha = 65
	auto_emissive_strength = 192
	fire_sound = 'sound/weapons/weaponsounds_laserstrong.ogg'
	eyeblur = 2
