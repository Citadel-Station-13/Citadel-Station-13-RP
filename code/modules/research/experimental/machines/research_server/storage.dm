//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Storage server; can hold disks full of techweb nodes & designs.
 */
/obj/machinery/research_server/storage
	name = "research storage server"
	// TODO: NEW SPRITE PLEASE
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"

	/// inserted.
	/// * not a lazy list, entries can be null
	/// * not necessarily all disks.
	var/list/obj/item/disk_bays
	/// disk bay count
	var/disk_bays_count = 7

/obj/machinery/research_server/storage/Initialize(mapload)
	. = ..()
	set_disk_bay_count(disk_bays_count)

/**
 * * Deletes things that don't fit anymore when count is reduced!
 */
/obj/machinery/research_server/storage/proc/set_disk_bay_count(count)
	if(!disk_bays)
		disk_bays = list()
	if(length(disk_bays) > count)
		for(var/i in length(disk_bays) to count + 1 step -1)
			var/obj/item/inside = disk_bays[i]
			if(inside)
				qdel(inside)
	disk_bays.len = count

/obj/machinery/research_server/storage/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/research/server/ResearchStorageServer")
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/machinery/research_server/storage/ui_data(mob/user, datum/tgui/ui)
	. = ..()

	var/list/serialized_bays = list()

	for(var/i in 1 to length(disk_bays))
		#warn impl

	.["baysCount"] = disk_bays_count
	.["bays"] = serialized_bays

/obj/machinery/research_server/storage/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("remove")
			var/bay = params["bay"]
		if("insert")
			var/bay = params["bay"]

/obj/machinery/research_server/storage/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/disk/tech_disk) || istype(using, /obj/item/disk/design_disk))
		// attempt insert
		var/obj/item/disk/casted_disk = using

		return CLICKCHAIN_DID_SOMETHING

#warn impl all

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
