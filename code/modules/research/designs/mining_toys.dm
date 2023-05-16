/datum/design/item/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

// Mining digging devices

/datum/design/item/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill
	sort_string = "FAAAA"

/datum/design/item/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_SILVER = 500)
	build_path = /obj/item/pickaxe/jackhammer
	sort_string = "FAAAB"

/datum/design/item/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(MAT_STEEL = 1500, MAT_GLASS = 500, MAT_GOLD = 500, MAT_PHORON = 500)
	build_path = /obj/item/pickaxe/plasmacutter
	sort_string = "FAAAC"

/datum/design/item/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_DIAMOND = 3000)
	build_path = /obj/item/pickaxe/diamond
	sort_string = "FAAAD"

/datum/design/item/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/pickaxe/diamonddrill
	sort_string = "FAAAE"

/datum/design/item/mining/advbore
	id = "adv_bore"
	req_tech = list(TECH_MATERIAL = 5, TECH_PHORON = 5, TECH_ENGINEERING = 4, TECH_POWER = 4) //phoron 5 needs materials to get
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2500, MAT_GOLD = 2500, MAT_PHORON = 2500)
	build_path = /obj/item/gun/magnetic/matfed/advanced
	sort_string = "FAABA"

/datum/design/item/mining/vertibore
	id = "vertibore"
	req_tech = list(TECH_MATERIAL = 5, TECH_PHORON = 5, TECH_ENGINEERING = 6, TECH_POWER = 7)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 5000, MAT_GOLD = 5000, MAT_PHORON = 5000, MAT_DIAMOND = 100, MAT_URANIUM = 1000)
	build_path = /obj/item/vertibore
	sort_string = "FAABB"

// Mining other equipment
/datum/design/item/mining/mining_scanner
	id = "mining_scanner"
	req_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 150)
	build_path = /obj/item/mining_scanner
	sort_string = "FAACA"

/datum/design/item/mining/mining_scanner_adv
	id = "mining_scanner_adv"
	req_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/mining_scanner/advanced
	sort_string = "FAACB"
