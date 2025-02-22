//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/gun_component/focusing_lens/divide_by
	name = "weapon focusing lens (linear multiplexer)"
	desc = {"
		A special focusing lens that multiplexes a passing particle beam.
	"}
	component_type = /obj/item/gun_component/focusing_lens/divide_by
	hook_projectile_injection = TRUE

	/// divides a beam to this number of parallel beams
	var/divide_by = 1
	/// this is extremely dangerous and i advise you not to mess with it
	/// * the default is enough to make this worth it as a damage upgrade
	///   without making it too op. if you set this to a ridiculous value like 2,
	///   i will replace your eyelids with limes.
	var/cheat_factor = 1
	/// cooldown multiplier
	var/cooldown_multiplier = 1.25
	/// power multiplier
	var/power_consumption_multiplier = 1

/obj/item/gun_component/focusing_lens/divide_by/on_projectile_injection(obj/item/gun/source, datum/gun_firing_cycle/cycle, obj/projectile/proj)
	divide_by = clamp(divide_by, 1, 20)
	cycle.overall_cooldown_multiply *= cooldown_multiplier
	cycle.next_projectile_cost_multiplier *= power_consumption_multiplier
	if(proj.submunitions)
		proj.submunitions *= divide_by
	else
		proj.submunitions = divide_by
	proj.submunitions_only = TRUE
	proj.submunition_linear_spread = divide_by * 5
	proj.submunition_uniform_linear_spread = TRUE
	proj.submunition_distribution = TRUE
	proj.submunition_distribution_mod = cheat_factor
	proj.submunition_distribution_overwrite = TRUE

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun_component/focusing_lens/divide_by/two, /gun_component/focusing_lens/divide_by_two, "gun_component-focusing_lens-divide_by_two")
/obj/item/gun_component/focusing_lens/divide_by/two
	name = "weapon focusing lens (2-linear multiplexer)"
	divide_by = 2
	cheat_factor = 1.15
	cooldown_multiplier = 1.25

	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 250,
		/datum/prototype/material/gold::id = 125,
		/datum/prototype/material/silver::id = 125,
	)

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/gun_component/focusing_lens/divide_by/three, /gun_component/focusing_lens/divide_by_three, "gun_component-focusing_lens-divide_by_three")
/obj/item/gun_component/focusing_lens/divide_by/three
	name = "weapon focusing lens (3-linear multiplexer)"
	divide_by = 3
	cheat_factor = 1.2
	cooldown_multiplier = 1.5

	materials_base = list(
		/datum/prototype/material/steel::id = 500,
		/datum/prototype/material/glass::id = 250,
		/datum/prototype/material/gold::id = 65,
		/datum/prototype/material/silver::id = 65,
		/datum/prototype/material/uranium::id = 125,
		/datum/prototype/material/diamond::id = 250,
	)
