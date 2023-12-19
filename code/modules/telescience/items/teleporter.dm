//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * generates portals to nearby signals
 */
/obj/item/bluespace_teleporter
	name = "bluespace teleporter"
	desc = "An experimental man-portable teleportation tunnel generator. Locks onto nearby signals, or generates a random tunnel to a location near the user."
	#warn sprite

	/// starting cell type
	var/cell_type = /obj/item/cell/device/waepon

/obj/item/bluespace_teleporter/Initialize(mapload)
	. = ..()
	init_cell_slot_easy_tool(cell_type)

/obj/item/bluespace_teleporter/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/item/bluespace_teleporter/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/bluespace_teleporter/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/bluespace_teleporter/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

#warn impl all
