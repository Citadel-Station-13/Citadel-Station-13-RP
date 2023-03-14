
/datum/design/circuit/disk
	lathe_type = LATHE_TYPE_CIRCUIT
	req_tech = list(TECH_DATA = 3)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 1000)
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
	name = SPECIES_SKRELL
	identifier = "prosthetic_skrell"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/disk/species/skrell

/datum/design/circuit/disk/tajprint
	name = SPECIES_TAJ
	identifier = "prosthetic_tajaran"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/disk/species/tajaran

/datum/design/circuit/disk/unathiprint
	name = SPECIES_UNATHI
	identifier = "prosthetic_unathi"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 4)
	build_path = /obj/item/disk/species/unathi

/datum/design/circuit/disk/teshariprint
	name = SPECIES_TESHARI
	identifier = "prosthetic_teshari"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 4)
	build_path = /obj/item/disk/species/teshari
