//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun_component/particle_array/disabler_bolt, /gun_component/particle_array/disabler_bolt, "gun_component-particle_array-disabler_bolt")
/obj/item/gun_component/particle_array/disabler_bolt
	name = /obj/item/gun_component/particle_array::name + " (disabler bolt)"
	desc = "A particle array that generates an energy bolt capable of disrupting neuromuscular functions."

	considered_lethal = TRUE
	selection_name = "disabler bolt"
	render_color = "#00f2ff"
	base_charge_cost = /obj/item/cell/basic/tier_1/weapon::max_charge / 20

	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 250,
		/datum/prototype/material/gold::id = 125,
		/datum/prototype/material/silver::id = 250,
	)

	projectile_type = /obj/projectile/particle_array/disabler_bolt

/obj/projectile/particle_array/disabler_bolt
	name = "disabler bolt"
	#warn icon state
	pass_flags = NONE
	damage_type = DAMAGE_TYPE_HALLOSS
	damage_flag = ARMOR_ENERGY
	damage_force = 25
	projectile_type = PROJECTILE_TYPE_BEAM | PROJECTILE_TYPE_ENERGY
	impact_sound = PROJECTILE_IMPACT_SOUNDS_ENERGY
	color = "#00f5f1"
	auto_emissive_strength = 192
	#warn fire_sound
