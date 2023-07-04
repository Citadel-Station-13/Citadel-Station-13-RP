
/**
 * legacy science designs
 */
/datum/design/science
	abstract_type = /datum/design/science
	lathe_type = LATHE_TYPE_PROTOLATHE

//Make sure items don't get free power
/datum/design/science/print(atom/where)
	var/obj/item/I = ..()
	var/obj/item/cell/C = I.get_cell()
	if(C)
		C.charge = 0
		I.update_icon()
	if(istype(I, /obj/item/gun))
		var/obj/item/gun/G = I
		G.pin = null

	return I
