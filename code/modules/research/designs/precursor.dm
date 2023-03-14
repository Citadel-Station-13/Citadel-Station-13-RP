//Anomaly

/datum/design/science/anomaly/generate_name(template)
	return "Anomalous prototype ([..()])"

/datum/design/science/anomaly/camotrap
	name = "Chameleon Trap"
	desc = "A self-miraging mechanical trap, capable of producing short bursts of electric current when triggered."
	identifier = "hunt_trap"
	materials = list(MAT_DURASTEEL = 3000, MAT_METALHYDROGEN = 1000, MAT_PHORON = 2000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_PHORON = 2, TECH_ARCANE = 2)
	build_path = /obj/item/beartrap/hunting

// Precursor

/datum/design/science/precursor/generate_name(template)
	return "Alien prototype ([..()])"

/datum/design/science/precursor/crowbar
	name = "Hybrid Crowbar"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	identifier = "hybridcrowbar"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_GOLD = 250, MAT_URANIUM = 2500)
	build_path = /obj/item/tool/crowbar/hybrid

/datum/design/science/precursor/wrench
	name = "Hybrid Wrench"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	identifier = "hybridwrench"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_SILVER = 300, MAT_URANIUM = 2000)
	build_path = /obj/item/tool/wrench/hybrid

/datum/design/science/precursor/screwdriver
	name = "Hybrid Screwdriver"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	identifier = "hybridscrewdriver"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_PLASTIC = 8000, MAT_DIAMOND = 2000)
	build_path = /obj/item/tool/screwdriver/hybrid

/datum/design/science/precursor/wirecutters
	name = "Hybrid Wirecutters"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	identifier = "hybridwirecutters"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_PHORON = 2, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_PLASTIC = 8000, MAT_PHORON = 2750, MAT_DIAMOND = 2000)
	build_path = /obj/item/tool/wirecutters/hybrid

/datum/design/science/precursor/welder
	name = "Hybrid Welding Tool"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	identifier = "hybridwelder"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PHORON = 3, TECH_MAGNET = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_METALHYDROGEN = 4750, MAT_URANIUM = 6000)
	build_path = /obj/item/weldingtool/experimental/hybrid


/datum/design/science/precursor/janusmodule
	name = "Blackbox Circuit Datamass"
	desc = "A design that seems to be in a constantly shifting superposition."
	identifier = "janus_module"
	materials = list(MAT_DURASTEEL = 3000, MAT_MORPHIUM = 2000, MAT_METALHYDROGEN = 6000, MAT_URANIUM = 6000, MAT_VERDANTIUM = 1500)
	req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 2)
	build_path = /obj/random/janusmodule
