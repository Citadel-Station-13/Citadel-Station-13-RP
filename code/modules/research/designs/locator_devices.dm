

/datum/prototype/design/science/locator
	category = DESIGN_CATEGORY_BLUESPACE
	abstract_type = /datum/prototype/design/science/locator

/datum/prototype/design/science/locator/gps
	id = "RNDDesignGPS"
	build_path = /obj/item/gps

/datum/prototype/design/science/locator/beacon_locator
	design_name = "Tracking beacon pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "RNDDesignBeaconLocator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/beacon_locator

/datum/prototype/design/science/locator/beacon
	design_name = "Bluespace tracking beacon"
	id = "RNDDesignTeleBeacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials_base = list (MAT_STEEL = 20, MAT_GLASS = 10)
	build_path = /obj/item/radio/beacon
