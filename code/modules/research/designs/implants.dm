/datum/prototype/design/science/implant
	abstract_type = /datum/prototype/design/science/implant
	category = DESIGN_CATEGORY_MEDICAL
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50)


/datum/prototype/design/science/implant/chemical
	id = "chemplant"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/chem

/datum/prototype/design/science/implant/freedom
	id = "freeplant"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/freedom

/datum/prototype/design/science/implant/sizecontrol
	id = "sizeplant"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4, TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 200, MAT_GLASS = 200, MAT_SILVER = 300)
	build_path = /obj/item/implanter/sizecontrol
