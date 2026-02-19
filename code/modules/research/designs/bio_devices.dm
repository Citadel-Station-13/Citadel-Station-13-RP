/datum/prototype/design/science/biotech
	abstract_type = /datum/prototype/design/science/biotech
	category = DESIGN_CATEGORY_MEDICAL
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 20)

// Biotech of various types

/datum/prototype/design/science/biotech/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spec"
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mass_spectrometer

/datum/prototype/design/science/biotech/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spec"
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/mass_spectrometer/adv

/datum/prototype/design/science/biotech/reagent_scanner
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/reagent_scanner

/datum/prototype/design/science/biotech/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/reagent_scanner/adv

/datum/prototype/design/science/biotech/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "roboscanner"
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 200)
	build_path = /obj/item/robotanalyzer

/datum/prototype/design/science/biotech/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	category = DESIGN_CATEGORY_SYNTH
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 150, MAT_GLASS = 75)
	build_path = /obj/item/stack/nanopaste
	work = 0.5 SECONDS

/datum/prototype/design/science/biotech/plant_analyzer
	desc = "A device capable of quickly scanning all relevant data about a plant."
	id = "plantscanner"
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/plant_analyzer

/datum/prototype/design/science/biotech/nif
	design_name = "nanite implant framework (NIF)"
	id = "nif"
	subcategory = DESIGN_SUBCATEGORY_NIF
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 800, MAT_URANIUM = 600, MAT_DIAMOND = 600)
	build_path = /obj/item/nif

/datum/prototype/design/science/biotech/nifbio
	design_name = "bioadaptive nanite implant framework (NIF)"
	id = "bionif"
	subcategory = DESIGN_SUBCATEGORY_NIF
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5, TECH_BIO = 5)
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 1500, MAT_URANIUM = 1000, MAT_DIAMOND = 1000)
	build_path = /obj/item/nif/bioadap

/datum/prototype/design/science/biotech/nifrepairtool
	design_name = "adv. NIF repair tool"
	id = "niftool"
	subcategory = DESIGN_SUBCATEGORY_NIF
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials_base = list(MAT_STEEL = 200, MAT_GLASS = 300, MAT_URANIUM = 200, MAT_DIAMOND = 200)
	build_path = /obj/item/nifrepairer
