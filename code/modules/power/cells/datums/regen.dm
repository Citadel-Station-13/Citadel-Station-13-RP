//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

POWER_CELL_GENERATE_TYPES(/datum/power_cell/regen, /regen, "regen")
/datum/power_cell/regen
	functional = TRUE
	requires_processing = TRUE

	cell_name = "void"
	cell_desc = "This one is unlike anything you've seen before, able to generate energy seemingly out of nowhere."

	typegen_visual_stripe_color = "#aa00aa"

/datum/power_cell/regen/on_process(obj/item/cell/cell, dt)


#warn new way

// POWER_CELL_GENERATE_TYPES(/obj/item/cell/regen)
/obj/item/cell/regen

	self_recharge = TRUE
