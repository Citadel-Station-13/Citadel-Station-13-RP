
/datum/design/circuit/disk
	abstract_type = /datum/design/circuit/disk
	lathe_type = LATHE_TYPE_CIRCUIT
	req_tech = list(TECH_DATA = 3)
	materials_base = list(MAT_PLASTIC = 2000, MAT_GLASS = 1000)
	reagents = list("pacid" = 10)
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/design/circuit/disk/generate_name(template)
	if(build_path)
		var/obj/item/disk/D = build_path
		if(ispath(D, /obj/item/disk/species))
			return "Species prosthetic design ([..()])"
		else
			return "Disk design ([..()])"
	return ..()

/datum/design/circuit/disk/skrellprint
	design_name = SPECIES_SKRELL
	id = "prosthetic_skrell"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/disk/species/skrell

/datum/design/circuit/disk/tajprint
	design_name = SPECIES_TAJ
	id = "prosthetic_tajaran"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/disk/species/tajaran

/datum/design/circuit/disk/unathiprint
	design_name = SPECIES_UNATHI
	id = "prosthetic_unathi"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 4)
	build_path = /obj/item/disk/species/unathi

/datum/design/circuit/disk/teshariprint
	design_name = SPECIES_TESHARI
	id = "prosthetic_teshari"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 4)
	build_path = /obj/item/disk/species/teshari
