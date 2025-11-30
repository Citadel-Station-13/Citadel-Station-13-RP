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
	density = TRUE
	anchored = TRUE
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

	/// material id to **sheets**
	var/list/sheets_by_material = list()
	/// how much to multiply all ores by
	var/persistence_decay_factor = 0.35
	/// how much to subtract from all ores after factor
	var/persistence_decay_constant = 10
	/// ignore overpowered ore filter
	var/persistence_allow_overpowered = FALSE

/obj/machinery/sheet_silo/decay_persisted(rounds_since_saved, hours_since_saved)
	. = ..()
	for(var/id in sheets_by_material)
		// this isn't technically mathematically accurate but honestly
		// i don't care
		sheets_by_material[id] = max(0, round(sheets_by_material[id] * (persistence_decay_factor ** rounds_since_saved) - persistence_decay_constant * rounds_since_saved))
		if(!sheets_by_material[id])
			sheets_by_material -= id

/obj/machinery/sheet_silo/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/sheets = I
		if(!user.transfer_item_to_loc(sheets, src))
			to_chat(user, SPAN_WARNING("You fail to insert [sheets] into [src]."))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		var/inserted = take_sheets(sheets)
		user.visible_message(
			SPAN_NOTICE("[user] inserts [I] into [src]."),
			SPAN_NOTICE("You insert [inserted] sheets of [I] into [src]."),
			range = MESSAGE_RANGE_INVENTORY_SOFT,
		)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/machinery/sheet_silo/proc/take_sheets(obj/item/stack/material/sheets)
	if(sheets.uses_charge)
		return 0
	var/mat_id = sheets.material.id
	var/mat_amount = sheets.amount
	. = mat_amount
	sheets.use(mat_amount)
	sheets_by_material[mat_id] += mat_amount

/obj/machinery/sheet_silo/clone(atom/location)
	var/obj/machinery/sheet_silo/clone = ..()
	clone.sheets_by_material = sheets_by_material.Copy()
	return clone

/obj/machinery/sheet_silo/serialize()
	. = ..()
	var/list/transformed_sheets = list()
	for(var/id in sheets_by_material)
		var/datum/prototype/material/mat = RSmaterials.fetch(id)
		if(isnull(mat))
			continue
		if(!persistence_allow_overpowered && (mat.material_flags & MATERIAL_FLAG_CONSIDERED_OVERPOWERED))
			continue
		var/amount = sheets_by_material[id]
		transformed_sheets[id] = amount
	.["stored"] = transformed_sheets

/obj/machinery/sheet_silo/deserialize(list/data)
	. = ..()
	sheets_by_material = data["stored"]

/obj/machinery/sheet_silo/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
	immediate += /datum/asset_pack/spritesheet/materials
	return ..()

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

/obj/machinery/sheet_silo/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
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
			if(!amount)
				return TRUE
			var/datum/prototype/material/dropping = RSmaterials.fetch(id)
			if(isnull(dropping))
				return TRUE
			// todo: ughh
			var/obj/item/stack/material/casted = dropping.stack_type
			amount = min(amount, initial(casted.max_amount))
			if(!amount)
				return TRUE
			sheets_by_material[id] -= amount
			if(sheets_by_material[id] <= 0)
				sheets_by_material -= id
			var/obj/item/stack/material/dropped = dropping.place_sheet(null, amount)
			usr.put_in_hands_or_drop(dropped)
			usr.visible_message(SPAN_NOTICE("[usr] retrieves [amount] sheets of [dropping] from [src]."), range = MESSAGE_RANGE_INVENTORY_SOFT)
			return TRUE
