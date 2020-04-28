/datum/design/item/general/bluespace_jumpsuit
	name = "Bluespace jumpsuit"
	id = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MATERIAL_ID_STEEL = 4000, MATERIAL_ID_GLASS = 4000)
	build_path = /obj/item/clothing/under/bluespace
	sort_string = "TAVAA"

/datum/design/item/general/sizegun
	name = "Size gun"
	id = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MATERIAL_ID_STEEL = 3000, MATERIAL_ID_GLASS = 2000, "uranium" = 2000)
	build_path = /obj/item/gun/energy/sizegun
	sort_string = "TAVAB"

/datum/design/item/general/bodysnatcher
	name = "Body Snatcher"
	id = "bodysnatcher"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
	materials = list(MATERIAL_ID_STEEL = 4000, MATERIAL_ID_GLASS = 4000)
	build_path = /obj/item/bodysnatcher
	sort_string = "TBVAA"