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
	/// disk bay count
	var/disk_bays_count = 7

#warn impl

/obj/machinery/research_server/storage/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/machinery/research_server/storage/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/storage/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/storage/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/machinery/research_server/storage/on_join_network(datum/research_network/network)
	. = ..()

/obj/machinery/research_server/storage/on_leave_network(datum/research_network/network)
	. = ..()

/obj/machinery/research_server/storage/proc/insert_slot(slot_idx, obj/item/inserting)

/obj/machinery/research_server/storage/proc/remove_slot(slot_idx, atom/move_to) as /obj/item

/obj/machinery/research_server/storage/proc/on_slot_inserted(slot_idx, obj/item/entity)
	PROTECTED_PROC(TRUE)

/obj/machinery/research_server/storage/proc/on_slot_removed(slot_idx, obj/item/entity)
	PROTECTED_PROC(TRUE)

/obj/machinery/research_server/storage/proc/on_design_disk_change(datum/source, list/datum/prototype/design/added, list/datum/prototype/design/removed)

/obj/machinery/research_server/storage/proc/on_tech_disk_change(datum/source, list/datum/prototype/design/added, list/datum/prototype/design/removed)

/obj/machinery/research_server/storage/proc/get_projected_nodes()

/obj/machinery/research_server/storage/proc/get_projected_designs()

#warn register signals on disk as needed
