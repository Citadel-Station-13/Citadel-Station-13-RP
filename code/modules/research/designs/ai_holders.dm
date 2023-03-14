// Various AI/mind holding device
/datum/design/science/ai_holder/generate_name(template)
	return "Mind storage device prototype ([..()])"

/datum/design/science/ai_holder/mmi
	name = "Man-machine interface"
	identifier = "mmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_PROSTHETICS
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/mmi
	category = list("Misc")

/datum/design/science/ai_holder/posibrain
	name = "Positronic brain"
	identifier = "posibrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_PROSTHETICS
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 500, MAT_PHORON = 500, MAT_DIAMOND = 100)
	build_path = /obj/item/mmi/digital/posibrain
	category = list("Misc")

/datum/design/science/ai_holder/dronebrain
	name = "Robotic intelligence circuit"
	identifier = "dronebrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_DATA = 4)
	lathe_type = LATHE_TYPE_PROTOLATHE | LATHE_TYPE_PROSTHETICS
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 500)
	build_path = /obj/item/mmi/digital/robot
	category = list("Misc")

/datum/design/science/ai_holder/paicard
	name = "'pAI', personal artificial intelligence device"
	identifier = "paicard"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 500, MAT_STEEL = 500)
	build_path = /obj/item/paicard

/datum/design/science/ai_holder/intellicard
	name = "intelliCore"
	desc = "Allows for the construction of an intelliCore."
	identifier = "intellicore"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	materials = list(MAT_GLASS = 1000, MAT_GOLD = 200)
	build_path = /obj/item/aicard
