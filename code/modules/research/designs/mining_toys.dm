/datum/design/item/weapon/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

// Mining digging devices

/datum/design/item/weapon/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill
	sort_string = "FAAAA"

/datum/design/item/weapon/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "silver" = 500)
	build_path = /obj/item/pickaxe/jackhammer
	sort_string = "FAAAB"

/datum/design/item/weapon/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 500, "gold" = 500, "phoron" = 500)
	build_path = /obj/item/pickaxe/plasmacutter
	sort_string = "FAAAC"

/datum/design/item/weapon/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list("diamond" = 3000)
	build_path = /obj/item/pickaxe/diamond
	sort_string = "FAAAD"

/datum/design/item/weapon/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000, "diamond" = 2000)
	build_path = /obj/item/pickaxe/diamonddrill
	sort_string = "FAAAE"

/datum/design/item/weapon/mining/advbore
	id = "adv_bore"
	req_tech = list(TECH_MATERIAL = 5, TECH_PHORON = 5, TECH_ENGINEERING = 4, TECH_POWER = 4) //phoron 5 needs materials to get
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500, "gold" = 2500, "phoron" = 2500)
	build_path = /obj/item/gun/magnetic/matfed/advanced
	sort_string = "FAABA"

/datum/design/item/weapon/mining/vertibore
	id = "vertibore"
	req_tech = list(TECH_MATERIAL = 5, TECH_PHORON = 5, TECH_ENGINEERING = 6, TECH_POWER = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000, "gold" = 5000, "phoron" = 5000, "diamond" = 100, "uranium" = 1000)
	build_path = /obj/item/vertibore
	sort_string = "FAABB"

// Mining other equipment
/datum/design/item/weapon/mining/mining_scanner
	id = "mining_scanner"
	req_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 150)
	build_path = /obj/item/mining_scanner
	sort_string = "FAACA"

/datum/design/item/weapon/mining/mining_scanner_adv
	id = "mining_scanner_adv"
	req_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000)
	build_path = /obj/item/mining_scanner/advanced
	sort_string = "FAACB"
