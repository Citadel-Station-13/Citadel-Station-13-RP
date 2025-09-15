/datum/prototype/design/science/teleport
	category = DESIGN_CATEGORY_BLUESPACE
	abstract_type = /datum/prototype/design/science/teleport


/datum/prototype/design/science/teleport/generate_name(template)
	return "Teleportation device prototype ([..()])"

/datum/prototype/design/science/teleport/translocator
	design_name = "Personal translocator"
	id = "translocator"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_URANIUM = 4000, MAT_DIAMOND = 2000)
	build_path = /obj/item/perfect_tele

/*
/datum/prototype/design/science/teleport/bluespace_crystal
	design_name = "Artificial Bluespace Crystal"
	id = "bluespace_crystal"
	req_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4)
	materials_base = list(MAT_DIAMOND = 1500, MAT_PHORON = 1500)
	build_path = /obj/item/bluespace_crystal/artificial
*/
