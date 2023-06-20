// GPS

/datum/design/science/gps
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 500)

/datum/design/science/gps/generate_name(template)
	return "Triangulating device design ([..()])"

/datum/design/science/gps/generic
	design_name = "GEN"
	id = "gps_gen"
	build_path = /obj/item/gps

/datum/design/science/gps/command
	design_name = "COM"
	id = "gps_com"
	build_path = /obj/item/gps/command

/datum/design/science/gps/security
	design_name = "SEC"
	id = "gps_sec"
	build_path = /obj/item/gps/security

/datum/design/science/gps/medical
	design_name = "MED"
	id = "gps_med"
	build_path = /obj/item/gps/medical

/datum/design/science/gps/engineering
	design_name = "ENG"
	id = "gps_eng"
	build_path = /obj/item/gps/engineering

/datum/design/science/gps/science
	design_name = "SCI"
	id = "gps_sci"
	build_path = /obj/item/gps/science

/datum/design/science/gps/mining
	design_name = "MINE"
	id = "gps_mine"
	build_path = /obj/item/gps/mining

/datum/design/science/gps/explorer
	design_name = "EXP"
	id = "gps_exp"
	build_path = /obj/item/gps/explorer

// Other locators

/datum/design/science/locator/generate_name(template)
	return "Locator device design ([..()])"

/datum/design/science/locator/beacon_locator
	design_name = "Tracking beacon pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/beacon_locator

/datum/design/science/locator/beacon
	design_name = "Bluespace tracking beacon"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (MAT_STEEL = 20, MAT_GLASS = 10)
	build_path = /obj/item/radio/beacon
