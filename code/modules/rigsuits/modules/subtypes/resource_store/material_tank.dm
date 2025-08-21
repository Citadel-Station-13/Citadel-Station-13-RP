//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig_module/resource_store/material_tank

#warn impl

/obj/item/rig_module/resource_store/material_tank/internal
	var/capacity = SHEET_MATERIAL_AMOUNT * 50
	var/datum/material_container/container

/obj/item/rig_module/resource_store/material_tank/internal/Initialize(mapload)
	. = ..()
	container = new

/obj/item/rig_module/resource_store/material_tank/internal/Destroy()
	QDEL_NULL(container)
	return ..()

/obj/item/rig_module/resource_store/material_tank/internal/proc/set_capacity(capacity)
	src.capacity = capacity
	src.container?.set_capacity(capacity)

/obj/item/rig_module/resource_store/material_tank/internal/sheet_acceptor
	var/allow_eject = TRUE

/obj/item/rig_module/resource_store/material_tank/internal/sheet_acceptor/proc/ingest_sheets(obj/item/stack/material/sheets, limit_amount, datum/event_args/actor/actor, silent)
