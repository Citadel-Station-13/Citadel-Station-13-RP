/datum/prototype/design/science/gps
	abstract_type = /datum/prototype/design/science/gps
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials_base = list(MAT_STEEL = 500)

/datum/prototype/design/science/gps/generate_name(template)
	return "Triangulating device (GPS) design ([..()])"

/datum/prototype/design/science/gps/generic
	design_name = "GEN"
	id = "gps_gen"
	build_path = /obj/item/gps

/datum/prototype/design/science/gps/command
	design_name = "COM"
	id = "gps_com"
	build_path = /obj/item/gps/command

/datum/prototype/design/science/gps/security
	design_name = "SEC"
	id = "gps_sec"
	build_path = /obj/item/gps/security

/datum/prototype/design/science/gps/medical
	design_name = "MED"
	id = "gps_med"
	build_path = /obj/item/gps/medical

/datum/prototype/design/science/gps/engineering
	design_name = "ENG"
	id = "gps_eng"
	build_path = /obj/item/gps/engineering

/datum/prototype/design/science/gps/science
	design_name = "SCI"
	id = "gps_sci"
	build_path = /obj/item/gps/science

/datum/prototype/design/science/gps/mining
	design_name = "MINE"
	id = "gps_mine"
	build_path = /obj/item/gps/mining

/datum/prototype/design/science/gps/explorer
	design_name = "EXP"
	id = "gps_exp"
	build_path = /obj/item/gps/explorer

/datum/prototype/design/science/locator
	abstract_type = /datum/prototype/design/science/locator

/datum/prototype/design/science/locator/generate_name(template)
	return "Locator device design ([..()])"

/datum/prototype/design/science/locator/beacon_locator
	design_name = "Tracking beacon pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/beacon_locator

/datum/prototype/design/science/locator/beacon
	design_name = "Bluespace tracking beacon"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials_base = list (MAT_STEEL = 20, MAT_GLASS = 10)
	build_path = /obj/item/radio/beacon
