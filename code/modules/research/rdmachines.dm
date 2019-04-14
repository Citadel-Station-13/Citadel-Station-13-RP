<<<<<<< HEAD
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
		if(DEFAULT_WALL_MATERIAL)
			return /obj/item/stack/material/steel
		if("glass")
			return /obj/item/stack/material/glass
		if("plastic")
			return /obj/item/stack/material/plastic
		if("gold")
			return /obj/item/stack/material/gold
		if("silver")
			return /obj/item/stack/material/silver
		if("osmium")
			return /obj/item/stack/material/osmium
		if("phoron")
			return /obj/item/stack/material/phoron
		if("uranium")
			return /obj/item/stack/material/uranium
		if("diamond")
			return /obj/item/stack/material/diamond
	return null

/obj/machinery/r_n_d/proc/getMaterialName(var/type)
	switch(type)
		if(/obj/item/stack/material/steel)
			return DEFAULT_WALL_MATERIAL
		if(/obj/item/stack/material/glass)
			return "glass"
		if(/obj/item/stack/material/plastic)
			return "plastic"
		if(/obj/item/stack/material/gold)
			return "gold"
		if(/obj/item/stack/material/silver)
			return "silver"
		if(/obj/item/stack/material/osmium)
			return "osmium"
		if(/obj/item/stack/material/phoron)
			return "phoron"
		if(/obj/item/stack/material/uranium)
			return "uranium"
		if(/obj/item/stack/material/diamond)
			return "diamond"

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
=======
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

	var/list/materials = list()		// Materials this machine can accept.
	var/list/hidden_materials = list()	// Materials this machine will not display, unless it contains them. Must be in the materials list as well.

/obj/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/machinery/r_n_d/proc/getMaterialType(var/name)
	var/material/M = get_material_by_name(name)
	if(M && M.stack_type)
		return M.stack_type
	return null

/obj/machinery/r_n_d/proc/getMaterialName(var/type)
	if(istype(type, /obj/item/stack/material))
		var/obj/item/stack/material/M = type
		return M.material.name
	return null

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
>>>>>>> 59b8006... Merge pull request #5035 from VOREStation/upstream-merge-6023
	materials[material] -= eject * perUnit