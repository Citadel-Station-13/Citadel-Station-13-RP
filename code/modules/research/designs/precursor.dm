/datum/prototype/design/science/anomaly
	category = DESIGN_CATEGORY_ANOM
	abstract_type = /datum/prototype/design/science/anomaly


/datum/prototype/design/science/anomaly/camotrap
	design_name = "Chameleon Trap"
	desc = "A self-miraging mechanical trap, capable of producing short bursts of electric current when triggered."
	id = "hunt_trap"
	materials_base = list(MAT_DURASTEEL = 500, MAT_METALHYDROGEN = 750, MAT_PHORON = 750)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_PHORON = 2, TECH_ARCANE = 2)
	build_path = /obj/item/beartrap/hunting

/datum/prototype/design/science/precursor
	abstract_type = /datum/prototype/design/science/precursor
	category = DESIGN_CATEGORY_ANOM

/datum/prototype/design/science/precursor/crowbar
	design_name = "Hybrid Crowbar"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridcrowbar"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
	materials_base = list(MAT_PLASTEEL = 250, MAT_VERDANTIUM = 300, MAT_GOLD = 250, MAT_URANIUM = 250)
	build_path = /obj/item/tool/crowbar/hybrid

/datum/prototype/design/science/precursor/wrench
	design_name = "Hybrid Wrench"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwrench"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	materials_base = list(MAT_PLASTEEL = 250, MAT_VERDANTIUM = 300, MAT_SILVER = 300, MAT_URANIUM = 200)
	build_path = /obj/item/tool/wrench/hybrid

/datum/prototype/design/science/precursor/screwdriver
	design_name = "Hybrid Screwdriver"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridscrewdriver"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	materials_base = list(MAT_PLASTEEL = 250, MAT_VERDANTIUM = 300, MAT_PLASTIC = 800, MAT_DIAMOND = 200)
	build_path = /obj/item/tool/screwdriver/hybrid

/datum/prototype/design/science/precursor/wirecutters
	design_name = "Hybrid Wirecutters"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwirecutters"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_PHORON = 2, TECH_PRECURSOR = 1)
	materials_base = list(MAT_PLASTEEL = 250, MAT_VERDANTIUM = 300, MAT_PLASTIC = 800, MAT_PHORON = 500, MAT_DIAMOND = 375)
	build_path = /obj/item/tool/wirecutters/hybrid

/datum/prototype/design/science/precursor/welder
	design_name = "Hybrid Welding Tool"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwelder"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PHORON = 3, TECH_MAGNET = 5, TECH_PRECURSOR = 1)
	materials_base = list(MAT_DURASTEEL = 250, MAT_MORPHIUM = 300, MAT_METALHYDROGEN = 750, MAT_URANIUM = 500)
	build_path = /obj/item/weldingtool/experimental/hybrid


/datum/prototype/design/science/precursor/janusmodule
	design_name = "Blackbox Circuit Datamass"
	desc = "A design that seems to be in a constantly shifting superposition."
	id = "janus_module"
	materials_base = list(MAT_DURASTEEL = 750, MAT_MORPHIUM = 350, MAT_METALHYDROGEN = 650, MAT_URANIUM = 500, MAT_VERDANTIUM = 250)
	req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 2)
	build_path = /obj/random/janusmodule
