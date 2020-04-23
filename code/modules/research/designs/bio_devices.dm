/datum/design/item/biotech
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 20)

/datum/design/item/biotech/AssembleDesignName()
	..()
	name = "Biotech device prototype ([item_name])"

// Biotech of various types

/datum/design/item/biotech/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mass_spectrometer
	sort_string = "JAAAA"

/datum/design/item/biotech/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/mass_spectrometer/adv
	sort_string = "JAAAB"

/datum/design/item/biotech/reagent_scanner
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/reagent_scanner
	sort_string = "JAABA"

/datum/design/item/biotech/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/reagent_scanner/adv
	sort_string = "JAABB"

/datum/design/item/biotech/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 200)
	build_path = /obj/item/robotanalyzer
	sort_string = "JAACA"

/datum/design/item/biotech/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 7000)
	build_path = /obj/item/stack/nanopaste
	sort_string = "JAACB"

/datum/design/item/biotech/plant_analyzer
	desc = "A device capable of quickly scanning all relevant data about a plant."
	id = "plant_analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 500)
	build_path = /obj/item/analyzer/plant_analyzer
	sort_string = "JAADA"

/datum/design/item/biotech/nif
	name = "nanite implant framework"
	id = "nif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 8000, "uranium" = 6000, "diamond" = 6000)
	build_path = /obj/item/nif
	sort_string = "JVAAA"

/datum/design/item/biotech/nifbio
	name = "bioadaptive NIF"
	id = "bioadapnif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 15000, "uranium" = 10000, "diamond" = 10000)
	build_path = /obj/item/nif/bioadap
	sort_string = "JVAAB"

/datum/design/item/biotech/nifrepairtool
	name = "adv. NIF repair tool"
	id = "anrt"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 200, "glass" = 3000, "uranium" = 2000, "diamond" = 2000)
	build_path = /obj/item/nifrepairer
	sort_string = "JVABA"
