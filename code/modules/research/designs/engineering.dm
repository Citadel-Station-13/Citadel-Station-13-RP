/datum/prototype/design/science/tool
	category = DESIGN_CATEGORY_TOOLS
	abstract_type = /datum/prototype/design/science/tool

/datum/prototype/design/science/tool/experimental_welder
	id = "experiwelder"
	req_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 70, MAT_GLASS = 120, MAT_PHORON = 100)
	build_path = /obj/item/weldingtool/experimental

/datum/prototype/design/science/tool/hand_drill
	id = "screwdriver_handdrill"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials_base = list(MAT_STEEL = 300, MAT_SILVER = 100)
	build_path = /obj/item/tool/screwdriver/power

/datum/prototype/design/science/tool/jaws_life
	id = "crowbar_jaws"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials_base = list(MAT_STEEL = 300, MAT_SILVER = 100)
	build_path = /obj/item/tool/crowbar/power

/datum/prototype/design/science/tool/switchtool
	design_name = "Switchtool"
	desc = "A combined wirecutter, screwdriver, crowbar, wrench and multitool. The small size makes it somewhat slower at work."
	id = "switchtool"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 750, MAT_GLASS = 250)
	build_path = /obj/item/switchtool

/datum/prototype/design/science/tool/t_scanner_upg
	design_name = "Upgraded T-ray Scanner"
	desc = "An upgraded version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "upgtrayscanner"
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	materials_base = list(MAT_STEEL = 350, MAT_PHORON = 150)
	build_path = /obj/item/t_scanner/upgraded

/datum/prototype/design/science/tool/t_scanner_adv
	design_name = "Advanced T-ray Scanner"
	desc = "An advanced version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "advtrayscanner"
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	materials_base = list(MAT_STEEL = 350, MAT_PHORON = 25, MAT_SILVER = 50)
	build_path = /obj/item/t_scanner/advanced

/datum/prototype/design/science/tool/atmosanalyzerlongrange
	design_name = "Long Range Atmospheric Analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels from a distance."
	id = "rangedatmosscanner"
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	req_tech = list(TECH_ENGINEERING = 4)
	materials_base = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/atmos_analyzer/longrange
