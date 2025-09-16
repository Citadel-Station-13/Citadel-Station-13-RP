//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * So why do we have discrete modules for lathe control?
 *
 * Because unfortunately, some lathes need to be able to be controlled from say,
 * a R&D console.
 *
 * This is not great because we'll potentially have to duplicate code.
 * So, we use a module to abstract it.
 */
/datum/tgui_module/lathe_control
	tgui_id = "TGUILatheControl"
	expected_type = /obj/machinery/lathe
	var/design_update_queued = FALSE

/datum/tgui_module/lathe_control/data(mob/user, ...)
	. = ..()
	var/obj/machinery/lathe/lathe = host
	if(isnull(lathe))
		return
	.["queueActive"] = lathe.queue_active
	.["printing"] = lathe.printing
	.["progress"] = lathe.progress
	.["storesMaterials"] = !isnull(lathe.stored_materials)
	.["storesReagents"] = !isnull(lathe.stored_reagents)
	.["storesItems"] = !!length(lathe.items_max)

/datum/tgui_module/lathe_control/static_data(mob/user, ...)
	. = ..()
	var/obj/machinery/lathe/lathe = host
	if(isnull(lathe))
		return
	.["latheName"] = lathe.name
	.["dynamicButtons"] = lathe.ui_custom_options()
	.["materialsContext"] = SSmaterials.tgui_materials_context(full=TRUE) //this is a full materials context now
	.["speedMultiplier"] = lathe.speed_multiplier
	.["efficiencyMultiplier"] = lathe.efficiency_multiplier
	.["powerMultiplier"] = lathe.power_multiplier
	.["designs"] = ui_design_data(lathe.design_holder.available_designs())
	.["materials"] = lathe.stored_materials?.ui_storage_data() || list()
	.["reagents"] = lathe.stored_reagents?.tgui_reagent_contents() || list()
	.["queue"] = ui_queue_data()
	.["ingredients"] = isnull(lathe.stored_items)? list() : ui_ingredients_available(lathe.stored_items)

/datum/tgui_module/lathe_control/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	var/obj/machinery/lathe/lathe = host
	switch(action)
		if("enqueue")
			var/id = params["id"]
			var/amount = text2num(params["amount"])
			if(amount <= 0)
				return FALSE
			var/immediate = text2num(params["start"])
			var/list/material_parts = params["materials"]
			var/list/item_parts = params["items"]
			var/datum/prototype/design/D = RSdesigns.fetch(id)
			if(!lathe.has_design(D))
				return TRUE
			lathe.enqueue(D, amount, material_parts, item_parts, immediate)
			return TRUE
		if("dequeue")
			var/index = text2num(params["index"])
			var/datum/lathe_queue_entry/entry = SAFEINDEXACCESS(lathe.queue, index)
			if(isnull(entry))
				return TRUE
			lathe.queue.Cut(index, index + 1)
			ui_queue_update()
			return TRUE
		if("clear")
			if(!length(lathe.queue))
				return TRUE
			lathe.queue.len = 0
			ui_queue_update()
			return TRUE
		if("modqueue")
			var/index = text2num(params["index"])
			var/new_amount = text2num(params["amount"])
			var/datum/lathe_queue_entry/entry = SAFEINDEXACCESS(lathe.queue, index)
			var/datum/prototype/design/D = RSdesigns.fetch(entry.design_id)
			if(isnull(entry))
				return FALSE
			if(isnull(new_amount) || (new_amount <= 0))
				return FALSE
			entry.amount = clamp(new_amount, 0, length(D.ingredients)? 1 : (D.is_stack? lathe.queue_max_entry_stack : lathe.queue_max_entry))
			ui_queue_update()
			return TRUE
		if("start")
			lathe.start_printing()
			return TRUE
		if("stop")
			lathe.stop_printing()
			return TRUE
		if("ejectMaterial")
			var/id = params["id"]
			var/amt = params["amount"]
			if((amt <= 0) || isnull(id))
				return FALSE
			lathe.eject_sheets(id, amt)
			ui_materials_update()
			return TRUE
		if("disposeReagent")
			var/amount = text2num(params["amount"]) || INFINITY
			if(amount <= 0)
				return FALSE
			lathe.stored_reagents.remove_reagent(params["id"], amount)
			ui_reagents_update()
			return TRUE
		if("ejectItem")
			var/obj/item/I = locate(params["ref"]) in lathe.stored_items
			if(isnull(I))
				return TRUE
			lathe.eject_item(I)
			return TRUE
		if("custom")
			if(lathe.ui_custom_act(usr, params["name"]))
				ui_custom_update()
			return TRUE

/datum/tgui_module/lathe_control/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
	immediate += /datum/asset_pack/spritesheet/materials
	return ..()

/datum/tgui_module/lathe_control/proc/ui_design_data(datum/prototype/design/design)
	var/list/datum/prototype/design/designs = islist(design)? design : list(design)
	var/list/built = list()
	var/list/collated = list()
	var/list/collated_subcat = list()
	if(!islist(designs))
		design = list(design)
	for(var/datum/prototype/design/D as anything in designs)
		built[D.id] = D.ui_data_list()
		if(islist(D.category))
			for(var/elem in D.category)
				collated[elem] = TRUE
				LAZYDISTINCTADD(collated_subcat[elem], COERCE_OPTIONS_LIST(D.subcategory))
		else
			collated[D.category] = TRUE
			LAZYDISTINCTADD(collated_subcat[D.category], COERCE_OPTIONS_LIST(D.subcategory))
	var/list/flatten = list()
	for(var/key in collated)
		flatten += key
	collated = flatten
	return list(
		"instances" = built,
		"categories" = collated,
		"subcategories" = collated_subcat,
	)

/datum/tgui_module/lathe_control/proc/ui_design_add(list/datum/prototype/design/designs)
	if(design_update_queued)
		return
	addtimer(CALLBACK(src, PROC_REF(ui_design_update), 1), 0)

	design_update_queued = TRUE

/datum/tgui_module/lathe_control/proc/ui_design_remove(list/datum/prototype/design/designs)
	if(design_update_queued)
		return
	addtimer(CALLBACK(src, PROC_REF(ui_design_update), 1), 0)
	design_update_queued = TRUE

/**
 * performs a full update of designs.
 */
/datum/tgui_module/lathe_control/proc/ui_design_update(queued)
	if(queued && !design_update_queued)
		return
	design_update_queued = FALSE
	var/obj/machinery/lathe/lathe = host
	push_ui_data(data = list("designs" = ui_design_data(lathe.design_holder.available_designs())))

/datum/tgui_module/lathe_control/proc/ui_ingredients_update()
	var/obj/machinery/lathe/lathe = host
	push_ui_data(data = list("ingredients" = isnull(lathe.stored_items)? list() : ui_ingredients_available(lathe.stored_items)))

/datum/tgui_module/lathe_control/proc/ui_materials_update()
	var/obj/machinery/lathe/lathe = host
	push_ui_data(data = list("materials" = lathe.stored_materials?.ui_storage_data() || list()))

/datum/tgui_module/lathe_control/proc/ui_reagents_update()
	var/obj/machinery/lathe/lathe = host
	push_ui_data(data = list("reagents" = lathe.stored_reagents?.tgui_reagent_contents() || list()))

/datum/tgui_module/lathe_control/proc/ui_queue_update()
	push_ui_data(data = list("queue" = ui_queue_data()))

/datum/tgui_module/lathe_control/proc/ui_queue_data()
	var/obj/machinery/lathe/lathe = host
	var/list/got = list()
	for(var/datum/lathe_queue_entry/entry as anything in lathe.queue)
		got[++got.len] = entry.ui_data()
	return got

/datum/tgui_module/lathe_control/proc/ui_custom_update()
	var/obj/machinery/lathe/lathe = host
	push_ui_data(data = list("dynamicButtons" = lathe.ui_custom_options()))
