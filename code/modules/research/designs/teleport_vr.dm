/datum/design/science/teleport
	abstract_type = /datum/desgin/science/teleport

/datum/design/science/teleport/generate_name(template)
	return "Teleportation device prototype ([..()])"

/datum/design/science/teleport/translocator
	design_name = "Personal translocator"
	id = "translocator"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_DIAMOND = 2000)
	build_path = /obj/item/perfect_tele

/*
/datum/design/science/teleport/bluespace_crystal
	design_name = "Artificial Bluespace Crystal"
	id = "bluespace_crystal"
	req_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4)
	materials = list(MAT_DIAMOND = 1500, MAT_PHORON = 1500)
	build_path = /obj/item/ore/bluespace_crystal/artificial
*/
