/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB

/datum/design/item/powercell/AssembleDesignName()
	name = "Power Cell Model ([item_name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/weapon/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	return C

/datum/design/item/powercell/basic
	name = "basic"
	build_type = PROTOLATHE | MECHFAB
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(MATERIAL_ID_STEEL = 700, MATERIAL_ID_GLASS = 50)
	build_path = /obj/item/weapon/cell
	category = "Misc"
	sort_string = "DAAAA"

/datum/design/item/powercell/high
	name = "high-capacity"
	build_type = PROTOLATHE | MECHFAB
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(MATERIAL_ID_STEEL = 700, MATERIAL_ID_GLASS = 60)
	build_path = /obj/item/weapon/cell/high
	category = "Misc"
	sort_string = "DAAAB"

/datum/design/item/powercell/super
	name = "super-capacity"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_ID_STEEL = 700, MATERIAL_ID_GLASS = 70)
	build_path = /obj/item/weapon/cell/super
	category = "Misc"
	sort_string = "DAAAC"

/datum/design/item/powercell/hyper
	name = "hyper-capacity"
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MATERIAL_ID_STEEL = 400, MATERIAL_ID_GOLD = 150, MATERIAL_ID_SILVER = 150, MATERIAL_ID_GLASS = 70)
	build_path = /obj/item/weapon/cell/hyper
	category = "Misc"
	sort_string = "DAAAD"

/datum/design/item/powercell/device
	name = "device"
	build_type = PROTOLATHE
	id = "device"
	materials = list(MATERIAL_ID_STEEL = 350, MATERIAL_ID_GLASS = 25)
	build_path = /obj/item/weapon/cell/device
	category = "Misc"
	sort_string = "DAABA"

/datum/design/item/powercell/weapon
	name = "weapon"
	build_type = PROTOLATHE
	id = "weapon"
	materials = list(MATERIAL_ID_STEEL = 700, MATERIAL_ID_GLASS = 50)
	build_path = /obj/item/weapon/cell/device/weapon
	category = "Misc"
	sort_string = "DAABB"