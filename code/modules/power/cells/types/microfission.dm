//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// ---- lore note ----
// the justification for why this is a thing is [i don't care]
// go refluff it if you want this is a generic "makes radiation to make power" idea
// i literally dgaf what is written here so if you wanna bikeshed over it bikeshed
// yourself outside of my PR lol
POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/microfission, /microfission, "microfission")
/datum/prototype/power_cell/microfission
	cell_name = "microfission"
	cell_desc = "This one contains highly enriched nuclear material, which is constantly used to recharge the cell with an induced process."

	typegen_visual_stripe_color = "#007700"
	typegen_capacity_multiplier = 3 / 4

GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/microfission/small, /power_cell/microfission/small, "powercell-microfission-small")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/microfission/medium, /power_cell/microfission/medium, "powercell-microfission-medium")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/microfission/large, /power_cell/microfission/large, "powercell-microfission-large")
GENERATE_DESIGN_FOR_NT_PROTOLATHE(/obj/item/cell/microfission/weapon, /power_cell/microfission/weapon, "powercell-microfission-weapon")

/**
 * COBALT-60: DROP AND RUN
 */
/obj/item/cell/microfission
	integrity = 200
	integrity_max = 200
	integrity_failure = 0.66 * 200

	/// are we leaking?
	var/leaking = FALSE
	/// radiation power at minimum charge rate (or when not charging)
	var/leaking_strength_min = RAD_INTENSITY_CELL_MICROFISSION_LEAK_MINIMUM
	/// radiation power at maximum charge rate
	var/leaking_strength_max = RAD_INTENSITY_CELL_MICROFISSION_LEAK_MAXIMUM
	/// radiation power falloff
	var/leaking_falloff = RAD_FALLOFF_CELL_MICROFISSION

	/// additional cell units able to be recharged
	var/regen_left
	/// original [regen_left]
	/// * modulated by `c_fuel_*` on cell datums
	var/regen_initial
	/// if set, hard-sets additional cell units to be recharged; overrides [regen_as_multiplier]
	/// * modulated by `c_fuel_*` on cell datums
	var/regen_as_static
	/// if set, sets cell units to be recharged to be a multiplier of our maxcharge
	/// * modulated by `c_fuel_*` on cell datums
	var/regen_as_multiplier = 20 * (4 / 3)
	/// minimum recharge per second
	/// * modulated by `c_reaction_*` on cell datums
	var/regen_min_per_second = STATIC_KW_TO_CELL_UNITS(2.5, 1)
	/// maximum recharge per second
	/// * modulated by `c_reaction_*` on cell datums
	var/regen_max_per_second = STATIC_KW_TO_CELL_UNITS(25, 1)
	/// at what % of [regen_initial] we start to have regen drop
	var/regen_drop_start = 2 / 3
	/// at what % of [regen_initial] we fall to minimum regen
	var/regen_drop_end = 1 / 10

/obj/item/cell/microfission/Initialize(mapload)
	. = ..()
	regen_left = regen_initial = (isnull(regen_as_static) ? (regen_as_multiplier * max_charge) : regen_as_static)
	if(cell_datum)

	START_PROCESSING(SSobj, src)

/obj/item/cell/microfission/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/cell/microfission/process(delta_time)
	..()
	var/charge_rate = 0
	if(charge >= max_charge)
		// don't charge
	else
		// calc charge rate
		var/ratio = regen_left / regen_initial
	#warn impl
	#warn impl - leak

/obj/item/cell/microfission/atom_break()
	..()
	set_leaking(TRUE)

/obj/item/cell/microfission/atom_fix()
	..()
	set_leaking(FALSE)

/obj/item/cell/microfission/proc/set_leaking(new_leaking)
	leaking = new_leaking
	if(leaking)
		add_filter("microfission-cell-leak", 10, outline_filter(2, "#14ff71"))
		var/animating_filter = get_filter("microfission-cell-leak")
		animate(animating_filter, alpha = 75, time = 15, loop = -1)
		animate(alpha = 25, time = 25)
	else
		remove_filter("microfission-cell-leak")
	update_icon()

/obj/item/cell/microfission/update_icon()
	. = ..()
	if(leaking)
		add_overlay("[base_icon_state]-crack")
