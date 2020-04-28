/*
	P - teleporteing item stuff
*/

/datum/design/item/teleport/AssembleDesignName()
	..()
	name = "Teleportation device prototype ([item_name])"

/datum/design/item/teleport/translocator
	name = "Personal translocator"
	id = "translocator"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	materials = list(MATERIAL_ID_STEEL = 4000, MATERIAL_ID_GLASS = 2000, "uranium" = 4000, "diamond" = 2000)
	build_path = /obj/item/perfect_tele
	sort_string = "PAAAA"

/*
/datum/design/item/teleport/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	id = "bluespace_crystal"
	req_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4)
	materials = list("diamond" = 1500, "phoron" = 1500)
	build_path = /obj/item/ore/bluespace_crystal/artificial
	sort_string = "PAAAB"
*/
