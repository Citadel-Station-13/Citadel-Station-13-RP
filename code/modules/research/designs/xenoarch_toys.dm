/datum/design/science/xenoarch
	abstract_type = /datum/design/science/xenoarch

/datum/design/science/xenoarch/generate_name(template)
	return "Xenoarcheology equipment design ([..()])"

/datum/design/science/xenoarch/ano_scanner
	design_name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 10000, MAT_GLASS = 5000)
	build_path = /obj/item/ano_scanner

/datum/design/science/xenoarch/depth_scanner
	desc = "Used to check spatial depth and density of rock outcroppings."
	id = "depth_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/depth_scanner

/datum/design/science/xenoarch/xenoarch_multi_tool
	design_name = "xenoarcheology multitool"
	id = "xenoarch_multitool"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3)
	build_path = /obj/item/xenoarch_multi_tool
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_URANIUM = 500, MAT_PHORON = 500)

/datum/design/science/xenoarch/excavationdrill
	design_name = "Excavation Drill"
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	lathe_type = LATHE_TYPE_PROTOLATHE
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/pickaxe/excavationdrill
