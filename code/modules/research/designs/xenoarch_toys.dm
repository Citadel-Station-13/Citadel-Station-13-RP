/datum/design/science/xenoarch/AssembleDesignName()
	..()
	name = "Xenoarcheology equipment design ([build_name])"

// Xenoarch tools

/datum/design/science/xenoarch/ano_scanner
	name = "Alden-Saraspova counter"
	identifier = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 5000)
	build_path = /obj/item/ano_scanner

/datum/design/science/xenoarch/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	identifier = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/depth_scanner

/datum/design/science/xenoarch/xenoarch_multi_tool
	name = "xenoarcheology multitool"
	identifier = "xenoarch_multitool"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3)
	build_path = /obj/item/xenoarch_multi_tool
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_URANIUM = 500, MAT_PHORON = 500)

/datum/design/science/xenoarch/excavationdrill
	name = "Excavation Drill"
	identifier = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/pickaxe/excavationdrill
