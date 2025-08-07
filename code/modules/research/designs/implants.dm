/datum/prototype/design/science/implant
	abstract_type = /datum/prototype/design/science/implant
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50)

/datum/prototype/design/science/implant/generate_name(template)
	return "Implantable biocircuit design ([..()])"

/datum/prototype/design/science/implant/chemical
	design_name = "chemical"
	id = "implant_chem"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/chem

/datum/prototype/design/science/implant/freedom
	design_name = "freedom"
	id = "implant_free"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/freedom

/datum/prototype/design/science/implant/sizecontrol
	design_name = "Size control implant"
	id = "implant_size"
	category = DESIGN_CATEGORY_RECREATION
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4, TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000)
	build_path = /obj/item/implanter/sizecontrol
