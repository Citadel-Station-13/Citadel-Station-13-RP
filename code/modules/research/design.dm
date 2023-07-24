
/**
 * legacy science designs
 */
/datum/design/science
	abstract_type = /datum/design/science
	lathe_type = LATHE_TYPE_PROTOLATHE
	var/legacy_stack_amount = 1

//Make sure items don't get free power
/datum/design/science/print(atom/where, amount, list/material_parts, list/ingredient_parts, list/reagent_parts, cost_multiplier = 1)
	if(isnull(amount) || amount == 1)
		if(is_stack)
			amount = legacy_stack_amount
		else
			amount = 1
	var/obj/item/I = ..()
	var/obj/item/cell/C = I.get_cell()
	if(C)
		C.charge = 0
		I.update_icon()
	if(istype(I, /obj/item/gun))
		var/obj/item/gun/G = I
		G.pin = null

	return I
