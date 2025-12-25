//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun_component/particle_array/discharge_beam, /gun_component/particle_array/discharge_beam, "gun_component-particle_array-discharge_beam")
/obj/item/gun_component/particle_array/discharge_beam
	name = /obj/item/gun_component/particle_array::name + " (discharge beam)"
	desc = "A particle array that generates an ionized pathway to send an electric discharge through."

	considered_lethal = TRUE
	selection_name = "discharge beam"
	render_color = "#ffff00"
	base_charge_cost = /obj/item/cell/basic/tier_1/weapon::max_charge / 12
	base_delay_add = 0.3 SECONDS

	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 250,
		/datum/prototype/material/gold::id = 125,
		/datum/prototype/material/silver::id = 250,
	)

	projectile_type = /obj/projectile/particle_array/discharge_beam

/obj/projectile/particle_array/discharge_beam
	name = "discharge beam"
	pass_flags = NONE
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_ENERGY
	damage_force = 0
	projectile_type = PROJECTILE_TYPE_BEAM | PROJECTILE_TYPE_ENERGY
	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY
	hitscan = TRUE
	color = "#f5ed00"
	tracer_icon = 'icons/modules/projectiles/projectile-tracer.dmi'
	tracer_icon_state = "discharge-1"
	tracer_add_state = TRUE
	tracer_add_state_alpha = 235
	auto_emissive_strength = 192
	fire_sound = /datum/soundbyte/guns/energy/taser_2
	base_projectile_effects = list(
		/datum/projectile_effect/electrical_impulse{
			shock_energy = 50;
			shock_damage = 7.5;
			shock_agony = 30;
		},
	)
