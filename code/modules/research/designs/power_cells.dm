/datum/prototype/design/science/powercell
	abstract_type = /datum/prototype/design/science/powercell
	category = DESIGN_CATEGORY_POWER
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_MECHFAB

/datum/prototype/design/science/powercell/print(atom/where)
	var/obj/item/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	C.update_icon()
	return C

/datum/prototype/design/science/powercell/basic
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials_base = list(MAT_STEEL = 350, MAT_GLASS = 50)
	build_path = /obj/item/cell


/datum/prototype/design/science/powercell/high
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 400, MAT_GLASS = 60)
	build_path = /obj/item/cell/high


/datum/prototype/design/science/powercell/super
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials_base = list(MAT_STEEL = 700, MAT_GLASS = 70)
	build_path = /obj/item/cell/super


/datum/prototype/design/science/powercell/hyper
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 400, MAT_GOLD = 150, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/hyper


/datum/prototype/design/science/powercell/device
	lathe_type = LATHE_TYPE_PROTOLATHE
	id = "device"
	materials_base = list(MAT_STEEL = 250, MAT_GLASS = 25)
	build_path = /obj/item/cell/device


/datum/prototype/design/science/powercell/weapon
	lathe_type = LATHE_TYPE_PROTOLATHE
	id = "weapon"
	materials_base = list(MAT_STEEL = 450, MAT_GLASS = 50)
	build_path = /obj/item/cell/device/weapon

