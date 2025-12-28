//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun_component/particle_array/disabler_beam, /gun_component/particle_array/disabler_beam, "gun_component-particle_array-disabler_beam")
/obj/item/gun_component/particle_array/disabler_beam
	name = /obj/item/gun_component/particle_array::name + " (disabler beam)"
	desc = "A particle array that generates a neuromuscular disruption beam."

	considered_lethal = TRUE
	selection_name = "disabler beam"
	render_color = "#00f2ff"
	base_charge_cost = /obj/item/cell/basic/tier_1/weapon::max_charge / 20

	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 250,
		/datum/prototype/material/gold::id = 125,
		/datum/prototype/material/silver::id = 250,
	)

	projectile_type = /obj/projectile/particle_array/disabler_beam

/obj/projectile/particle_array/disabler_beam
	name = "disabler beam"
	#warn icon state
	pass_flags = NONE
	damage_type = DAMAGE_TYPE_HALLOSS
	damage_flag = ARMOR_ENERGY
	damage_force = 20
	projectile_type = PROJECTILE_TYPE_BEAM | PROJECTILE_TYPE_ENERGY
	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY
	hitscan = TRUE
	color = "#00f1f5"
	#warn tracer_icon_state, tracer_add_state, tracer_add_state_alpha
	auto_emissive_strength = 192
	#warn fire_sound
