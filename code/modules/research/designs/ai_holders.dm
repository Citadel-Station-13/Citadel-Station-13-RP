/datum/prototype/design/science/ai_holder
	abstract_type = /datum/prototype/design/science/ai_holder
	category = DESIGN_CATEGORY_SYNTH

/datum/prototype/design/science/ai_holder/mmi
	design_name = "Man-machine interface"
	id = "mmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_PROSTHETICS
	materials_base = list(MAT_STEEL = 750, MAT_GLASS = 250)
	build_path = /obj/item/mmi

/datum/prototype/design/science/ai_holder/posibrain
	design_name = "Positronic brain"
	id = "posibrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_PROSTHETICS
	materials_base = list(MAT_STEEL = 1250, MAT_GLASS = 500, MAT_SILVER = 1000, MAT_GOLD = 500, MAT_PHORON = 500, MAT_DIAMOND = 100)
	build_path = /obj/item/mmi/digital/posibrain

/datum/prototype/design/science/ai_holder/dronebrain
	design_name = "Robotic intelligence circuit"
	id = "dronebrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_DATA = 4)
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_PROSTHETICS
	materials_base = list(MAT_STEEL = 1250, MAT_GLASS = 500, MAT_SILVER = 1000, MAT_GOLD = 500)
	build_path = /obj/item/mmi/digital/robot

/datum/prototype/design/science/ai_holder/paicard
	design_name = "'pAI', personal artificial intelligence device"
	id = "RNDDesignPAI"
	req_tech = list(TECH_DATA = 2)
	materials_base = list(MAT_GLASS = 500, MAT_STEEL = 500)
	build_path = /obj/item/paicard

/datum/prototype/design/science/ai_holder/intellicard
	design_name = "intelliCore"
	desc = "Allows for the construction of an intelliCore."
	id = "intellicore"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	materials_base = list(MAT_GLASS = 1000, MAT_GOLD = 200)
	build_path = /obj/item/aicard
