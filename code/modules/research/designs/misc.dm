/*
//
//	THIS IS GOING TO GET REAL DAMN BLOATED, SO LET'S TRY TO AVOID THAT IF POSSIBLE
//
*/

/datum/design/item/hud
	materials = list(MATERIAL_ID_STEEL = 50, MATERIAL_ID_GLASS = 50)

/datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/hud/health
	name = "health scanner"
	id = "health_hud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "GAAAA"

/datum/design/item/hud/security
	name = "security records"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "GAAAB"

/datum/design/item/hud/mesons
	name = "Optical meson scanners design"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_ID_STEEL = 50, MATERIAL_ID_GLASS = 50)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "GAAAC"

/datum/design/item/device/ano_scanner
	name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(MATERIAL_ID_STEEL = 10000,MATERIAL_ID_GLASS = 5000)
	build_path = /obj/item/device/ano_scanner
	sort_string = "UAAAH"

/datum/design/item/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(MATERIAL_ID_STEEL = 1500, MATERIAL_ID_SILVER = 150, MATERIAL_ID_GLASS = 3000)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAAAH"

datum/design/item/laserpointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	id = "laser_pointer"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(MATERIAL_ID_STEEL = 100, MATERIAL_ID_GLASS = 50)
	build_path = /obj/item/device/laser_pointer
	sort_string = "VAAAI"

/datum/design/item/paicard
	name = "'pAI', personal artificial intelligence device"
	id = "paicard"
	req_tech = list(TECH_DATA = 2)
	materials = list(MATERIAL_ID_GLASS = 500, MATERIAL_ID_STEEL = 500)
	build_path = /obj/item/device/paicard
	sort_string = "VABAI"

/datum/design/item/communicator
	name = "Communicator"
	id = "communicator"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	materials = list(MATERIAL_ID_STEEL = 500, MATERIAL_ID_GLASS = 500)
	build_path = /obj/item/device/communicator
	sort_string = "VABAJ"

/datum/design/item/beacon
	name = "Bluespace tracking beacon design"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (MATERIAL_ID_STEEL = 20, MATERIAL_ID_GLASS = 10)
	build_path = /obj/item/device/radio/beacon
	sort_string = "VADAA"

/datum/design/item/gps
	name = "Triangulating device design"
	desc = "Triangulates approximate co-ordinates using a nearby satellite network."
	id = "gps"
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_ID_STEEL = 500)
	build_path = /obj/item/device/gps
	sort_string = "VADAB"

/datum/design/item/beacon_locator
	name = "Beacon tracking pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(MATERIAL_ID_STEEL = 1000,MATERIAL_ID_GLASS = 500)
	build_path = /obj/item/device/beacon_locator
	sort_string = "VADAC"

/datum/design/item/bag_holding
	name = "'Bag of Holding', an infinite capacity bag prototype"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MATERIAL_ID_GOLD = 3000, MATERIAL_ID_DIAMOND = 1500, MATERIAL_ID_URANIUM = 250)
	build_path = /obj/item/weapon/storage/backpack/holding
	sort_string = "VAEAA"

/datum/design/item/dufflebag_holding
	name = "'DuffleBag of Holding', an infinite capacity dufflebag prototype"
	desc = "A minaturized prototype of the popular Bag of Holding, the Dufflebag of Holding is, functionally, identical to the bag of holding, but comes in a more stylish and compact form."
	id = "dufflebag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MATERIAL_ID_GOLD = 3000, MATERIAL_ID_DIAMOND = 1500, MATERIAL_ID_URANIUM = 250)
	build_path = /obj/item/weapon/storage/backpack/holding/duffle
	sort_string = "VAEAB"

/datum/design/item/experimental_welder
	name = "Experimental welding tool"
	desc = "A welding tool that generate fuel for itself."
	id = "expwelder"
	req_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3, TECH_MATERIAL = 4)
	materials = list(MATERIAL_ID_STEEL = 70, MATERIAL_ID_GLASS = 120, MATERIAL_ID_PHORON = 100)
	build_path = /obj/item/weapon/weldingtool/experimental
	sort_string = "VASCA"

/datum/design/item/hand_drill
	name = "Hand drill"
	desc = "A simple powered hand drill."
	id = "handdrill"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_ID_STEEL = 300, MATERIAL_ID_SILVER = 100)
	build_path = /obj/item/weapon/tool/screwdriver/power
	sort_string = "VASDA"

/datum/design/item/jaws_life
	name = "Jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science."
	id = "jawslife"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_ID_STEEL = 300, MATERIAL_ID_SILVER = 100)
	build_path = /obj/item/weapon/tool/crowbar/power
	sort_string = "VASEA"

/datum/design/item/device/t_scanner_upg
	name = "Upgraded T-ray Scanner"
	desc = "An upgraded version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "upgradedtscanner"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	materials = list(MATERIAL_ID_STEEL = 500, MATERIAL_ID_PHORON = 150)
	build_path = /obj/item/device/t_scanner/upgraded
	sort_string = "VASSA"

/datum/design/item/device/t_scanner_adv
	name = "Advanced T-ray Scanner"
	desc = "An advanced version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "advancedtscanner"
	req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	materials = list(MATERIAL_ID_STEEL = 1250, MATERIAL_ID_PHORON = 500, MATERIAL_ID_SILVER = 50)
	build_path = /obj/item/device/t_scanner/advanced
	sort_string = "VASSB"

/datum/design/item/translator
	name = "handheld translator"
	id = "translator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_ID_STEEL = 3000, MATERIAL_ID_GLASS = 3000)
	build_path = /obj/item/device/universal_translator
	sort_string = "HABQA"

/datum/design/item/ear_translator
	name = "earpiece translator"
	id = "ear_translator"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)	//It's been hella miniaturized.
	materials = list(MATERIAL_ID_STEEL = 2000, MATERIAL_ID_GLASS = 2000, MATERIAL_ID_GOLD = 1000)
	build_path = /obj/item/device/universal_translator/ear
	sort_string = "HABQB"

/datum/design/item/xenoarch_multi_tool
	name = "xenoarcheology multitool"
	id = "xenoarch_multitool"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3, TECH_ARCANE = 1)
	build_path = /obj/item/device/xenoarch_multi_tool
	materials = list(MATERIAL_ID_STEEL = 2000, MATERIAL_ID_GLASS = 1000, MATERIAL_ID_URANIUM = 500, MATERIAL_ID_PHORON = 500)
	sort_string = "HABQC"

/datum/design/item/excavationdrill
	name = "Excavation Drill"
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_ID_STEEL = 4000, MATERIAL_ID_GLASS = 4000)
	build_path = /obj/item/weapon/pickaxe/excavationdrill
	sort_string = "HABQD"
