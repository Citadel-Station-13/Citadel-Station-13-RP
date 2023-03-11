// Implants

/datum/design/science/implant
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)

/datum/design/science/implant/AssembleDesignName()
	..()
	name = "Implantable biocircuit design ([build_name])"

/datum/design/science/implant/chemical
	name = "chemical"
	identifier = "implant_chem"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/chem

/datum/design/science/implant/freedom
	name = "freedom"
	identifier = "implant_free"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/freedom
