//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research_vr.dmi' //VOREStation Edit - Replaced with Eris sprites
	density = 1
	anchored = 1
	use_power = 1
	var/busy = 0
	var/obj/machinery/computer/rdconsole/linked_console

	var/list/materials = list()

/obj/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/machinery/r_n_d/proc/getMaterialType(var/name)
	switch(name)
		if(MATERIAL_ID_STEEL)
			return /obj/item/stack/material/steel
		if(MATERIAL_ID_GLASS)
			return /obj/item/stack/material/glass
		if(MATERIAL_ID_PLASTIC)
			return /obj/item/stack/material/plastic
		if(MATERIAL_ID_GOLD)
			return /obj/item/stack/material/gold
		if(MATERIAL_ID_SILVER)
			return /obj/item/stack/material/silver
		if(MATERIAL_ID_OSMIUM)
			return /obj/item/stack/material/osmium
		if(MATERIAL_ID_PHORON)
			return /obj/item/stack/material/phoron
		if(MATERIAL_ID_URANIUM)
			return /obj/item/stack/material/uranium
		if(MATERIAL_ID_DIAMOND)
			return /obj/item/stack/material/diamond
	return null

/obj/machinery/r_n_d/proc/getMaterialName(var/type)
	switch(type)
		if(/obj/item/stack/material/steel)
			return MATERIAL_ID_STEEL
		if(/obj/item/stack/material/glass)
			return MATERIAL_ID_GLASS
		if(/obj/item/stack/material/plastic)
			return MATERIAL_ID_PLASTIC
		if(/obj/item/stack/material/gold)
			return MATERIAL_ID_GOLD
		if(/obj/item/stack/material/silver)
			return MATERIAL_ID_SILVER
		if(/obj/item/stack/material/osmium)
			return MATERIAL_ID_OSMIUM
		if(/obj/item/stack/material/phoron)
			return MATERIAL_ID_PHORON
		if(/obj/item/stack/material/uranium)
			return MATERIAL_ID_URANIUM
		if(/obj/item/stack/material/diamond)
			return MATERIAL_ID_DIAMOND

/obj/machinery/r_n_d/proc/eject(var/material, var/amount)
	if(!(material in materials))
		return
	var/obj/item/stack/material/sheetType = getMaterialType(material)
	var/perUnit = initial(sheetType.perunit)
	var/eject = round(materials[material] / perUnit)
	eject = amount == -1 ? eject : min(eject, amount)
	if(eject < 1)
		return
	var/obj/item/stack/material/S = new sheetType(loc)
	S.amount = eject
	materials[material] -= eject * perUnit