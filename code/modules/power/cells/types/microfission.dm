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
	typegen_capacity_multiplier = 1 / 4 // we're, however, very small, because this is mostly just a nuclear accident in a can.

/**
 * COBALT-60: DROP AND RUN
 */
/obj/item/cell/microfission
	can_be_recharged = FALSE
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
	#warn sprite for leaking
	#warn add_filter("rad_glow", 2, list("type" = "outline", "color" = "#14fff714", "size" = 2))

	/// additional cell units able to be recharged
	var/regen_left
	/// original [regen_left]
	var/regen_initial
	/// if set, hard-sets additional cell units to be recharged; overrides [regen_as_multiplier]
	var/regen_as_static
	/// if set, sets cell units to be recharged to be a multiplier of our maxcharge
	/// * the default formula multiplies back our 1/4'd capacity
	var/regen_as_multiplier = 20 * 4
	/// minimum recharge per second
	var/regen_min_per_second = STATIC_KW_TO_CELL_UNITS(2.5, 1)
	/// maximum recharge per second
	var/regen_max_per_second = STATIC_KW_TO_CELL_UNITS(12.5, 1)
	/// at what % of [regen_initial] we start to have regen drop
	var/regen_drop_start = 2 / 3
	/// at what % of [regen_initial] we fall to minimum regen
	var/regen_drop_end = 1 / 10

/obj/item/cell/microfission/Initialize(mapload)
	. = ..()
	regen_left = regen_initial = (isnull(regen_as_static) ? (regen_as_multiplier * max_charge) : regen_as_static)
	START_PROCESSING(SSobj, src)

/obj/item/cell/microfission/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/cell/microfission/process(delta_time)
	..()
	#warn impl
	#warn impl - leak

#warn use power_cell datum vars
