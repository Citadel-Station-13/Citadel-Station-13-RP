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
