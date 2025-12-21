//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun_component/particle_array/particle_bolt, /gun_component/particle_array/particle_bolt, "gun_component-particle_array-particle_bolt")
/obj/item/gun_component/particle_array/particle_bolt
	name = /obj/item/gun_component/particle_array::name + " (particle bolt)"
	desc = "A particle array that emits a damaging energy bolt. Bog-standard, really."

	considered_lethal = TRUE
	selection_name = "particle bolt"
	render_color = "#ff0000"
	base_charge_cost = /obj/item/cell/basic/tier_1/weapon::max_charge / 12

	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 250,
	)

	projectile_type = /obj/projectile/particle_array/particle_bolt

/obj/projectile/particle_array/particle_bolt
	name = "particle bolt"
	icon = 'icons/modules/projectiles/projectile-hardsprited.dmi'
	icon_state = "particle-bolt"
	pass_flags = NONE
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_LASER
	damage_tier = 3.75
	damage_force = 30
	projectile_type = PROJECTILE_TYPE_ENERGY | PROJECTILE_TYPE_PHOTONIC
	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY
	color = "#ff1100"
	auto_emissive_strength = 192
	fire_sound = /datum/soundbyte/guns/energy/laser_1
