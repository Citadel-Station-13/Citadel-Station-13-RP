/datum/design/science/implant
	abstract_type = /datum/design/science/implant
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)

/datum/design/science/implant/generate_name(template)
	return "Implantable biocircuit design ([..()])"

/datum/design/science/implant/chemical
	design_name = "chemical"
	id = "implant_chem"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/chem

/datum/design/science/implant/freedom
	design_name = "freedom"
	id = "implant_free"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/freedom

/datum/design/science/implant/sizecontrol
	design_name = "Size control implant"
	id = "implant_size"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4, TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000)
	build_path = /obj/item/implanter/sizecontrol
