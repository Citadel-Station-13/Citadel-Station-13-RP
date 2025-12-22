//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun_component/particle_array/discharge_bolt, /gun_component/particle_array/discharge_bolt, "gun_component-particle_array-discharge_bolt")
/obj/item/gun_component/particle_array/discharge_bolt
	name = /obj/item/gun_component/particle_array::name + " (discharge bolt)"
	desc = "A particle array that generates an energy bolt that causes an electrical discharge on impact."

	considered_lethal = TRUE
	selection_name = "discharge bolt"
	render_color = "#ffff00"
	base_charge_cost = /obj/item/cell/basic/tier_1/weapon::max_charge / 12
	base_delay_add = 0.35 SECONDS

	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 250,
		/datum/prototype/material/gold::id = 125,
		/datum/prototype/material/silver::id = 250,
	)

	projectile_type = /obj/projectile/particle_array/discharge_bolt

/obj/projectile/particle_array/discharge_bolt
	name = "discharge bolt"
	icon = 'icons/modules/projectiles/projectile-hardsprited.dmi'
	icon_state = "discharge-bolt"
	pass_flags = NONE
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_ENERGY
	damage_force = 0
	projectile_type = PROJECTILE_TYPE_BEAM | PROJECTILE_TYPE_ENERGY
	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY
	color = "#f5ed00"
	auto_emissive_strength = 192
	fire_sound = /datum/soundbyte/guns/energy/taser_2
	base_projectile_effects = list(
		/datum/projectile_effect/electrical_impulse{
			shock_energy = 100;
			shock_damage = 10;
			shock_agony = 40;
		},
	)
