// GPS

/datum/design/science/gps
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(MAT_STEEL = 500)

/datum/design/science/gps/AssembleDesignName()
	..()
	name = "Triangulating device design ([name])"

/datum/design/science/gps/generic
	name = "GEN"
	id = "gps_gen"
	build_path = /obj/item/gps
	sort_string = "DAAAA"

/datum/design/science/gps/command
	name = "COM"
	id = "gps_com"
	build_path = /obj/item/gps/command
	sort_string = "DAAAB"

/datum/design/science/gps/security
	name = "SEC"
	id = "gps_sec"
	build_path = /obj/item/gps/security
	sort_string = "DAAAC"

/datum/design/science/gps/medical
	name = "MED"
	id = "gps_med"
	build_path = /obj/item/gps/medical
	sort_string = "DAAAD"

/datum/design/science/gps/engineering
	name = "ENG"
	id = "gps_eng"
	build_path = /obj/item/gps/engineering
	sort_string = "DAAAE"

/datum/design/science/gps/science
	name = "SCI"
	id = "gps_sci"
	build_path = /obj/item/gps/science
	sort_string = "DAAAF"

/datum/design/science/gps/mining
	name = "MINE"
	id = "gps_mine"
	build_path = /obj/item/gps/mining
	sort_string = "DAAAG"

/datum/design/science/gps/explorer
	name = "EXP"
	id = "gps_exp"
	build_path = /obj/item/gps/explorer
	sort_string = "DAAAH"

// Other locators

/datum/design/science/locator/AssembleDesignName()
	..()
	name = "Locator device design ([name])"

/datum/design/science/locator/beacon_locator
	name = "Tracking beacon pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/beacon_locator
	sort_string = "DBAAA"

/datum/design/science/locator/beacon
	name = "Bluespace tracking beacon"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (MAT_STEEL = 20, MAT_GLASS = 10)
	build_path = /obj/item/radio/beacon
	sort_string = "DBABA"
