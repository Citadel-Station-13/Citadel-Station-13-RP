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
	.["printing"] = lathe.queue_head_design()?.identifier
	.["progress"] = lathe.progress

/datum/tgui_module/lathe_control/static_data(mob/user, ...)
	. = ..()
	var/obj/machinery/lathe/lathe = host
	if(isnull(lathe))
		return
	.["latheName"] = lathe.name
	.["materialsContext"] = SSmaterials.tgui_materials_context()
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
	var/obj/machinery/lathe/lathe = host
	switch(action)
		if("enqueue")
			var/id = params["id"]
			var/amount = text2num(params["amount"])
			var/immediate = text2num(params["start"])
			var/list/material_parts = params["materials"]
			var/list/item_parts = params["items"]
			lathe.enqueue(SSresearch.fetch_design(id), amount, material_parts, item_parts, immediate)
			return TRUE
		if("dequeue")
			var/index = text2num(params["index"])
			var/datum/lathe_queue_entry/entry = SAFEINDEXACCESS(lathe.queue, index)
			if(isnull(entry))
				return TRUE
			lathe.queue.Cut(index, index + 1)
			return TRUE
		if("modqueue")
			var/index = text2num(params["index"])
			var/new_amount = text2num(params["amount"])
			var/datum/lathe_queue_entry/entry = SAFEINDEXACCESS(lathe.queue, index)
			var/datum/design/D = SSresearch.fetch_design(entry.design_id)
			if(isnull(entry))
				return
			if(isnull(new_amount))
				return
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
			if(!amt || isnull(id))
				return
			lathe.eject_sheets(id, amt)
			ui_materials_update()
			return TRUE
		if("disposeReagent")
			var/amount = text2num(params["amount"]) || INFINITY
			lathe.reagents.remove_reagent(params["id"], amount)
			ui_reagents_update()
			return TRUE
		if("ejectItem")
			var/obj/item/I = locate(params["ref"]) in lathe.stored_items
			if(isnull(I))
				return TRUE
			lathe.eject_item(I)
			return TRUE

/datum/tgui_module/lathe_control/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/materials)

/datum/tgui_module/lathe_control/proc/ui_design_data(datum/design/design)
	var/list/datum/design/designs = islist(design)? design : list(design)
	var/list/built = list()
	if(!islist(designs))
		design = list(design)
	for(var/datum/design/D as anything in designs)
		built[++built.len] = D.ui_data_list()

/datum/tgui_module/lathe_control/proc/ui_design_add(list/datum/design/designs)
	if(design_update_queued)
		return
	addtimer(CALLBACK(src, PROC_REF(ui_design_update), 1), 0)

	design_update_queued = TRUE

/datum/tgui_module/lathe_control/proc/ui_design_remove(list/datum/design/designs)
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
	var/obj/machinery/lathe/lathe = host
	push_ui_data(data = list("queue" = ui_queue_data()))
	#warn impl

/datum/tgui_module/lathe_control/proc/ui_queue_data()
	var/obj/machinery/lathe/lathe = host
	#warn impl
