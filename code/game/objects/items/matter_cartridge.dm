//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * material cartridges for new RCDs
 */
/obj/item/matter_cartridge
	name = "matter cartridge"
	desc = "A cartridge filled with atomized materials. Used in many fabrication systems."
	w_class = WEIGHT_CLASS_NORMAL

	/// stored lazy k-v list of materials; ids only please! paths will be resolved to ids on new()
	var/list/stored_materials
	/// maximum capacity
	var/maximum_capacity = SHEET_MATERIAL_AMOUNT * 100
	/// current capacity
	var/stored_capacity = 0

#warn impl all
