//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// ---- lore note ----
// the justification for why this is a thing is [i don't care]
// go refluff it if you want this is a generic "makes radiation to make power" idea
// i literally dgaf what is written here so if you wanna bikeshed over it bikeshed
// yourself outside of my PR lol
POWER_CELL_GENERATE_TYPES(/datum/prototype/power_cell/microfission, /microfission, "microfission")
/datum/prototype/power_cell/microfission
	id = "microfission"
	cell_name = "microfission"
	cell_desc = "This one contains highly enriched nuclear material, which is constantly used to recharge the cell with an induced process."

	typegen_visual_stripe_color = "#007700"
	typegen_capacity_multiplier = 3 / 4
	typegen_materials_base = list(
		/datum/prototype/material/steel::id = 350,
		/datum/prototype/material/glass::id = 150,
		/datum/prototype/material/copper::id = 75,
		/datum/prototype/material/gold::id = 75,
		/datum/prototype/material/lead::id = 300,
		/datum/prototype/material/silver::id = 150,
		/datum/prototype/material/uranium::id = 200,
	)

/datum/prototype/design/generated/power_cell/microfission
	abstract_type = /datum/prototype/design/generated/power_cell/microfission
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
	/// * cached computation
	var/tmp/c_regen_left
	/// original [regen_left]
	/// * cached computation
	/// * modulated by `c_fuel_*` on cell datums
	var/tmp/c_regen_initial
	/// * cached computation
	var/tmp/c_regen_min_per_second
	/// * cached computation
	var/tmp/c_regen_max_per_second

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
	// TODO: automated way to update when prototypes change?
	if(cell_datum)
		c_regen_left = c_regen_initial = (isnull(regen_as_static) ? (regen_as_multiplier * max_charge) : regen_as_static) \
			* cell_datum.c_fuel_adjust + cell_datum.c_fuel_multiplier
		c_regen_min_per_second = max(0, regen_min_per_second * cell_datum.c_reaction_multiplier + cell_datum.c_reaction_adjust)
		c_regen_max_per_second = max(0, regen_max_per_second * cell_datum.c_reaction_multiplier + cell_datum.c_reaction_adjust)
	else
		c_regen_left = c_regen_initial = (isnull(regen_as_static) ? (regen_as_multiplier * max_charge) : regen_as_static)
		c_regen_min_per_second = regen_min_per_second
		c_regen_max_per_second = regen_max_per_second

	START_PROCESSING(SSobj, src)

/obj/item/cell/microfission/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/cell/microfission/use(amount)
	. = ..()
	// wake if needed
	if(!(datum_flags & DF_ISPROCESSING))
		START_PROCESSING(SSobj, src)

/obj/item/cell/microfission/set_charge(amount, update)
	..()
	if(charge < max_charge)
		// wake if needed
		if(!(datum_flags & DF_ISPROCESSING))
			START_PROCESSING(SSobj, src)

/obj/item/cell/microfission/process(delta_time)
	..()
	var/reaction_ratio = 0
	if(charge >= max_charge)
		// don't charge
		if(!leaking)
			return PROCESS_KILL
	else
		// calc charge rate
		if(c_regen_left < c_regen_initial * regen_drop_end)
			reaction_ratio = 0
		else if(c_regen_left > c_regen_initial * regen_drop_start)
			reaction_ratio = 1
		else
			// the part of the ratio that is bottom and high end can be ignored
			var/nonaffecting_portion = c_regen_initial * (1 - (regen_drop_start + regen_drop_end))
			// subtract the bottom end of the bar that would already fall to minimum rate
			reaction_ratio = (c_regen_left - (c_regen_initial * regen_drop_end)) / (nonaffecting_portion)

		var/effective_charge_units = LERP(c_regen_min_per_second, c_regen_max_per_second, reaction_ratio)
		if(effective_charge_units)
			// just to be nice, allow overcharging.
			give(effective_charge_units, TRUE)
		else if(!leaking)
			return PROCESS_KILL
	if(leaking)
		SSradiation.radiation_pulse(
			src,
			LERP(leaking_strength_min, leaking_strength_min, reaction_ratio),
			leaking_falloff,
			TRUE,
			FALSE,
		)

/obj/item/cell/microfission/atom_break()
	..()
	set_leaking(TRUE)

/obj/item/cell/microfission/atom_fix()
	..()
	set_leaking(FALSE)

/obj/item/cell/microfission/proc/set_leaking(new_leaking)
	leaking = new_leaking
	do
		var/turf/our_turf = get_turf(src)
		log_game("MISC: Microfission cell at [COORD(our_turf)] leaking set to [new_leaking][inv_inside ? ", carried by [key_name(inv_inside.owner)]" : ""]")
	while(FALSE)
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
