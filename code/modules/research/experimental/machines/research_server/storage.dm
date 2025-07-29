//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Storage server; can hold disks full of techweb nodes & designs.
 */
/obj/machinery/research_server/storage
	name = "research storage server"

	/// inserted.
	/// * not a lazy list, entries can be null
	/// * not necessarily all disks.
	var/list/obj/item/disk_bays

#warn impl

/obj/machinery/research_server/storage/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/machinery/research_server/storage/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/storage/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/storage/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/storage/proc/get_projected_nodes()

/obj/machinery/research_server/storage/proc/get_projected_designs()

