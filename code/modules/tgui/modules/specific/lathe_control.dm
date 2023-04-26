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
	.["printing"] = lathe.queue_head_design()?.design_id

/datum/tgui_module/lathe_control/static_data(mob/user, ...)
	. = ..()
	var/obj/machinery/lathe/lathe = host
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
			var/amount = text2num(params["amount"])
			var/immediate = text2num(params["start"])
			var/list/material_parts = params["materials"]
			var/list/item_parts = params["items"]
			#warn impl
			return TRUE
		if("dequeue")
			var/index = text2num(params["index"])
			#warn impl
			return TRUE
		if("modqueue")
			var/index = text2num(params["index"])
			var/new_amount = text2num(params["amount"])
			#warn impl
			return TRUE
		if("start")
			#warn impl
			return TRUE
		if("stop")
			#warn impl
			return TRUE
		if("ejectMaterial")
			var/id = params["id"]
			#warn impl
			ui_materials_update()
			return TRUE
		if("disposeReagent")
			var/amount = text2num(params["amount"]) || INFINITY
			#warn impl
			ui_reagents_update()
			return TRUE
		if("disposeReagents")
			#warn impl
			ui_reagents_update()
			return TRUE
		if("ejectItem")
			var/obj/item/I = locate(params["ref"]) in lathe.stored_items
			if(isnull(I))
				ui_ingredients_update()
				return TRUE
			#warn impl
			return TRUE

/datum/tgui_module/lathe_control/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/materials)

/datum/tgui_module/lathe_control/proc/ui_design_data(datum/design/design)
	var/list/datum/design/designs = islist(design)? design : list(design)
	. = list()
	#warn impl ???
	if(!islist(designs))
		design = list(design)

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
	#warn impl

/datum/tgui_module/lathe_control/proc/ui_queue_data()
	var/obj/machinery/lathe/lathe = host
	#warn impl
