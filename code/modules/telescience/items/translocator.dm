//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/bluespace_translocator
	name = "bluespace translocator"
	desc = "A prototype launcher that shoots bluespace grappling beacons."
	#warn sprite

	/// starting cell type
	var/cell_type = /obj/item/cell/super

/obj/item/bluespace_translocator/Initialize(mapload)
	. = ..()
	var/datum/object_system/cell_slot/cell_slot = init_cell_slot_easy_tool(cell_type)
	cell_slot.legacy_use_device_cells = FALSE
