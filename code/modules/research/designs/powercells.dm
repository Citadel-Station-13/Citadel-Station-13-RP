/datum/design/science/powercell
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_MECHA

/datum/design/science/powercell/AssembleDesignName()
	name = "Power Cell Model ([build_name])"

/datum/design/science/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/science/powercell/print(atom/where)
	var/obj/item/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	return C

/datum/design/science/powercell/basic
	name = "basic"
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_MECHA
	identifier = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell
	category = "Misc"

/datum/design/science/powercell/high
	name = "high-capacity"
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_MECHA
	identifier = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 60)
	build_path = /obj/item/cell/high
	category = "Misc"

/datum/design/science/powercell/super
	name = "super-capacity"
	identifier = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 70)
	build_path = /obj/item/cell/super
	category = "Misc"

/datum/design/science/powercell/hyper
	name = "hyper-capacity"
	identifier = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 400, MAT_GOLD = 150, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/hyper
	category = "Misc"

/datum/design/science/powercell/device
	name = "device"
	lathe_type = LATHE_TYPE_PROTOLATHE
	identifier = "device"
	materials = list(MAT_STEEL = 350, MAT_GLASS = 25)
	build_path = /obj/item/cell/device
	category = "Misc"

/datum/design/science/powercell/weapon
	name = "weapon"
	lathe_type = LATHE_TYPE_PROTOLATHE
	identifier = "weapon"
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell/device/weapon
	category = "Misc"
