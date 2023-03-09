
/datum/design/circuit/disk
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 3)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 1000)
	chemicals = list("pacid" = 10)
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/design/circuit/disk/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/disk/D = build_path
		if(istype(D, /obj/item/disk/species))
			name = "Species Prosthetic design ([item_name])"
		else
			name = "Disk design ([item_name])"

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
