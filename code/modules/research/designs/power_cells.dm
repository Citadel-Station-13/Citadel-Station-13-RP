/datum/prototype/design/science/powercell
	abstract_type = /datum/prototype/design/science/powercell
	category = DESIGN_CATEGORY_POWER
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_MECHFAB

/datum/prototype/design/science/powercell/generate_name(template)
	return "Power Cell Model ([template])"

/datum/prototype/design/science/powercell/generate_desc(template_name, template_desc)
	if(build_path)
		var/obj/item/cell/C = build_path
		return "Allows the construction of power cells that can hold [initial(C.max_charge)] units of energy."
	return "ERROR"

/datum/prototype/design/science/powercell/print(atom/where)
	var/obj/item/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	C.update_icon()
	return C

#warn all the designs
