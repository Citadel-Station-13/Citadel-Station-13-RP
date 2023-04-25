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

/datum/tgui_module/lathe_control/data(mob/user, ...)
	. = ..()
	var/obj/machinery/lathe/lathe = host


/datum/tgui_module/lathe_control/static_data(mob/user, ...)
	. = ..()
	var/obj/machinery/lathe/lathe = host

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
	#warn impl

/datum/tgui_module/lathe_control/proc/ui_design_remove(list/datum/design/designs)
	#warn impl

/**
 * performs a full update of designs.
 */
/datum/tgui_module/lathe_control/proc/ui_design_update()
	var/obj/machinery/lathe/lathe = host
	#warn impl

/datum/tgui_module/lathe_control/proc/ui_ingredients_update()
	var/obj/machinery/lathe/lathe = host
	#warn impl

/datum/tgui_module/lathe_control/proc/ui_queue_update()
	var/obj/machinery/lathe/lathe = host
	#warn impl

/datum/tgui_module/lathe_control/proc/ui_materials_update()
	var/obj/machinery/lathe/lathe = host
	#warn impl

/datum/tgui_module/lathe_control/proc/ui_reagents_update()
	var/obj/machinery/lathe/lathe = host
	#warn impl
