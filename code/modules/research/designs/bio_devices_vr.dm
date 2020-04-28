/datum/design/item/biotech/nif
	name = "nanite implant framework"
	id = "nif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(/datum/material/steel = 5000, "glass" = 8000, "uranium" = 6000, "diamond" = 6000)
	build_path = /obj/item/nif
	sort_string = "JVAAA"

/datum/design/item/biotech/nifbio
	name = "bioadaptive NIF"
	id = "bioadapnif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5, TECH_BIO = 5)
	materials = list(/datum/material/steel = 10000, "glass" = 15000, "uranium" = 10000, "diamond" = 10000)
	build_path = /obj/item/nif/bioadap
	sort_string = "JVAAB"

/datum/design/item/biotech/nifrepairtool
	name = "adv. NIF repair tool"
	id = "anrt"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(/datum/material/steel = 200, "glass" = 3000, "uranium" = 2000, "diamond" = 2000)
	build_path = /obj/item/nifrepairer
	sort_string = "JVABA"