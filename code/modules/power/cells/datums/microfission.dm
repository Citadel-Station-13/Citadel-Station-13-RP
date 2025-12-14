//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// ---- lore note ----
// the justification for why this is a thing is [i don't care]
// go refluff it if you want this is a generic "makes radiation to make power" idea
// i literally dgaf what is written here so if you wanna bikeshed over it bikeshed
// yourself outside of my PR lol
POWER_CELL_GENERATE_TYPES(/datum/power_cell/microfission, /microfission, "microfission")
/datum/power_cell/microfission
	functional = TRUE

	cell_name = "microfission"
	cell_desc = "This one contains highly enriched nuclear material, which is constantly used to recharge the cell with an induced process."

	typegen_visual_stripe_color = "#007700"
	typegen_capacity_multiplier = 1 / 4 // we're, however, very small, because this is mostly just a nuclear accident in a can.

#warn new way


/**
 * COBALT-60: DROP AND RUN
 */
/obj/item/cell/microfission

	can_be_recharged = FALSE

	/// are we leaking?
	var/leaking = FALSE
	/// catastrophic failure: force reaction rate to maximum
	var/leaking_catastrophically = FALSE
	/// radiation power at minimum charge rate (or when not charging)
	var/leaking_noncharge_strength = RAD_POWER_CELL_MICROFISSION_LEAK_MINIMUIM
	/// radiation power at maximum charge rate
	var/leaking_noncharge_strength = RAD_POWER_CELL_MICROFISSION_LEAK_MAXIMUM
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
	var/regen_as_multiplier = 35 * (1 / 4) // multiply back our 1/4'd capacity
	/// if set, lose this much 'latent' charge per second; defaults to being set from [regen_loss_per_second_as_ratio]
	var/regen_loss_per_second
	/// if set, lose this much maximum charge per second as a ratio of [regen_left]
	var/regen_loss_per_second_as_ratio = 1 / ((1 HOURS) / 10) // / 10 because the macros turn time into deciseconds.
	/// minimum recharge per second
	var/regen_min_per_second = STATIC_KW_TO_CELL_UNITS(2.5, 1)
	/// maximum recharge per second
	var/regen_max_per_second = STATIC_KW_TO_CELL_UNITS(25, 1)
	/// at what % of [regen_initial] we start to have regen drop
	var/regen_drop_start = 2 / 3
	/// at what % of [regen_initial] we fall to minimum regen
	var/regen_drop_end = 1 / 10

/obj/item/cell/microfission/Initialize(mapload)
	. = ..()
	#warn calc regen
	START_PROCESSING(SSobj, start)

/obj/item/cell/microfission/process(delta_time)
	..()
	#warn impl
	#warn impl - leak
