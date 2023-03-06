/datum/design/science/powercell
	build_type = PROTOLATHE | MECHFAB

/datum/design/science/powercell/AssembleDesignName()
	name = "Power Cell Model ([item_name])"

/datum/design/science/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/science/powercell/print(atom/where)
	var/obj/item/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	C.update_icon()
	return C

/datum/design/science/powercell/basic
	name = "basic"
	build_type = PROTOLATHE | MECHFAB
	identifier = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell
	category = list("Misc")

/datum/design/science/powercell/high
	name = "high-capacity"
	build_type = PROTOLATHE | MECHFAB
	identifier = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 60)
	build_path = /obj/item/cell/high
	category = list("Misc")

/datum/design/science/powercell/super
	name = "super-capacity"
	identifier = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 70)
	build_path = /obj/item/cell/super
	category = list("Misc")

/datum/design/science/powercell/hyper
	name = "hyper-capacity"
	identifier = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 400, MAT_GOLD = 150, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/hyper
	category = list("Misc")

/datum/design/science/powercell/device
	name = "device"
	build_type = PROTOLATHE
	identifier = "device"
	materials = list(MAT_STEEL = 350, MAT_GLASS = 25)
	build_path = /obj/item/cell/device
	category = list("Misc")

/datum/design/science/powercell/weapon
	name = "weapon"
	build_type = PROTOLATHE
	identifier = "weapon"
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell/device/weapon
	category = list("Misc")
