//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * material cartridges for new RCDs
 */
/obj/item/polyfill_cartridge
	name = "polyfill cartridge"
	desc = "A cartridge filled with a predetermined mixture of construction polyfill. Used by holofabricators \
	and other fabrication machinery."
	icon = 'icons/items/stream_projector/holofabricator.dmi'
	icon_state = "cartridge"
	w_class = WEIGHT_CLASS_NORMAL

	/// polyfill material type
	var/polyfill_type = /datum/material/polyfill
	/// maximum capacity
	var/maximum_capacity = SHEET_MATERIAL_AMOUNT * 100
	/// current capacity
	var/stored_capacity = 0

/obj/item/polyfill_cartridge/get_materials(respect_multiplier)
	. = ..()
	var/datum/material/resolved_polyfill = SSmaterials.resolve_material(polyfill_type)
	/// only separate for weak alloys
	if(!isnull(resolved_polyfill.weak_alloy))
		for(var/key in resolved_polyfill.weak_alloy)
			.[key] += stored_capacity * resolved_polyfill.weak_alloy[key]
	else
		.[resolved_polyfill.id] += stored_capacity
	for(var/key in stored_materials)
		.[key] += stored_materials[key]

/obj/item/polyfill_cartridge/proc/use(amount)
	. = min(amount, stored_capacity)
	if(!.)
		return
	stored_capacity -= amount

/obj/item/polyfill_cartridge/proc/give(amount)
	. = min(amount, maximum_capacity - stored_capacity)
	stored_capacity += .
