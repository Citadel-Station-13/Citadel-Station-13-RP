/**
 * legacy science designs
 */
/datum/prototype/design/science
	abstract_type = /datum/prototype/design/science
	lathe_type = LATHE_TYPE_PROTOLATHE
	design_unlock = DESIGN_UNLOCK_TECHLEVEL

//Make sure items don't get free power
/datum/prototype/design/science/print(atom/where, amount, list/material_parts, list/ingredient_parts, list/reagent_parts, cost_multiplier = 1)
	var/obj/item/I = ..()
	var/obj/item/cell/C = I.get_cell()
	if(C)
		C.charge = 0
		C.update_icon()
	if(istype(I, /obj/item/gun))
		var/obj/item/gun/G = I
		G.pin = null
	return I
