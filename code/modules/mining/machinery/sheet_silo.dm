//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * persistence allowed storage system
 *
 * notes:
 * * bluespace ore silo/sheet delivery is explicitly not to be made. any prs attempting to do so will be closed. ~silicons
 */
/obj/machinery/sheet_silo
	name = "materials silo"
	desc = "A reinforced materials storage silo. Inserted sheets are protected via stasis field."
	icon = 'icons/modules/mining/machinery/sheet_silo.dmi'
	icon_state = "silo"

	/// material id to **sheets**
	var/list/sheets_by_material = list()
	/// how much to multiply all ores by
	var/persistence_decay_factor = 0.65
	/// how much to subtract from all ores after factor
	var/persistence_decay_constant = 10
	/// ignore overpowered ore filter
	var/persistence_allow_overpowered = FALSE

/obj/machinery/sheet_silo/decay_persisted(rounds_since_saved, hours_since_saved)
	. = ..()
	for(var/id in sheets_by_material)
		// this isn't technically mathematically accurate but honestly
		// i don't care
		sheets_by_material[id] = round(sheets_by_material[id] * (persistence_decay_factor ** rounds_since_saved) - persistence_decay_constant * rounds_since_saved)

/obj/machinery/sheet_silo/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	#warn impl
	. = ..()

/obj/machinery/sheet_silo/proc/take_sheets(obj/item/stack/material/sheets)
	#warn impl

/obj/machinery/sheet_silo/clone(atom/location, include_contents)
	var/obj/machinery/sheet_silo/clone = ..()
	clone.sheets_by_material = sheets_by_material.Copy()
	return clone

/obj/machinery/sheet_silo/serialize()
	. = ..()
	var/list/transformed_sheets = list()
	for(var/id in sheets_by_material)
		var/datum/material/mat = SSmaterials.resolve_material(id)
		if(!persistence_allow_overpowered && (mat.material_flags & MATERIAL_FLAG_CONSIDERED_OVERPOWERED))
			continue
		var/amount = sheets_by_material[id]
		transformed_sheets[id] = amount
	.["stored"] = transformed_sheets

/obj/machinery/sheet_silo/deserialize(list/data)
	. = ..()
	sheets_by_material = data["stored"]

/obj/machinery/sheet_silo/ui_assets(mob/user)
	. = ..()
	. += get_asset_datum(/datum/asset/spritesheet/materials)

/obj/machinery/sheet_silo/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["stored"] = sheets_by_material

/obj/machinery/sheet_silo/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["materialContext"] = SSmaterials.tgui_materials_context()

/obj/machinery/sheet_silo/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SheetSilo")
		ui.open()

/obj/machinery/sheet_silo/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("eject")
			var/amount = params["amount"]
			var/id = params["id"]
			if(!is_safe_number(amount))
				return TRUE
			amount = clamp(amount, 0, sheets_by_material[id])
			#warn impl
