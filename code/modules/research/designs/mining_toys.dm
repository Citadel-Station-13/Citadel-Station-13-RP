/datum/prototype/design/science/mining
	category = DESIGN_CATEGORY_CARGO_MINING
	abstract_type = /datum/prototype/design/science/mining

/datum/prototype/design/science/mining/generate_name(template)
	return "Mining equipment design ([..()])"

// Mining digging devices

/datum/prototype/design/science/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 6000, MAT_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill

/datum/prototype/design/science/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_SILVER = 500)
	build_path = /obj/item/pickaxe/jackhammer

/datum/prototype/design/science/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 500, MAT_GOLD = 500, MAT_PHORON = 500)
	build_path = /obj/item/pickaxe/plasmacutter

/datum/prototype/design/science/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials_base = list(MAT_DIAMOND = 3000)
	build_path = /obj/item/pickaxe/diamond

/datum/prototype/design/science/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials_base = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/pickaxe/diamonddrill

/datum/prototype/design/science/mining/advbore
	id = "adv_bore"
	req_tech = list(TECH_MATERIAL = 5, TECH_PHORON = 5, TECH_ENGINEERING = 4, TECH_POWER = 4) //phoron 5 needs materials to get
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 2500, MAT_GOLD = 2500, MAT_PHORON = 2500)
	build_path = /obj/item/gun/projectile/magnetic/matfed/advanced

/datum/prototype/design/science/mining/vertibore
	id = "vertibore"
	req_tech = list(TECH_MATERIAL = 5, TECH_PHORON = 5, TECH_ENGINEERING = 6, TECH_POWER = 7)
	materials_base = list(MAT_STEEL = 10000, MAT_GLASS = 5000, MAT_GOLD = 5000, MAT_PHORON = 5000, MAT_DIAMOND = 100, MAT_URANIUM = 1000)
	build_path = /obj/item/vertibore

// KA Upgrades (That Are Too Powerful to Just Be Vending Items)
/datum/prototype/design/science/mining/ka_modkit_aoe
	design_name = "Experimental Kinetic Accelerator Mod (Anti-Material AoE)"
	id = "kamodkit_aoe"
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_URANIUM = 500)
	build_path = /obj/item/ka_modkit/aoe/turfs

/datum/prototype/design/science/mining/ka_modkit_aoe_mob
	design_name = "Experimental Kinetic Accelerator Mod (Anti-Organic AoE)"
	id = "kamodkit_aoe_mob"
	req_tech = list(TECH_BIO = 6, TECH_ENGINEERING = 5)
	materials_base = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_GOLD = 1000, MAT_PHORON = 500)
	build_path = /obj/item/ka_modkit/aoe/mobs

/datum/prototype/design/science/mining/ka_modkit_aoe_combo
	design_name = "Experimental Kinetic Accelerator Mod (Combination AoE)"
	id = "kamodkit_aoe_combo"
	req_tech = list(TECH_MATERIAL = 7, TECH_BIO = 7, TECH_ENGINEERING = 5)
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 1500, MAT_SILVER = 500, MAT_GOLD = 500, MAT_DIAMOND = 500)
	build_path = /obj/item/ka_modkit/aoe/turfs/andmobs

// Mining other equipment
/datum/prototype/design/science/mining/mining_scanner
	id = "mining_scanner"
	req_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	materials_base = list(MAT_STEEL = 150)
	build_path = /obj/item/mining_scanner

/datum/prototype/design/science/mining/mining_scanner_adv
	id = "mining_scanner_adv"
	req_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 4)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/mining_scanner/advanced

/datum/prototype/design/science/mining/bs_mining_satchel
	design_name = "Mining Satchel of Holding"
	id = "bs_mining_satchel"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6, TECH_PHORON = 4)
	materials_base = list(MAT_GOLD = 1500, MAT_DIAMOND = 750, MAT_URANIUM = 150, MAT_PHORON = 100, MAT_VERDANTIUM = 100)
	build_path = /obj/item/storage/bag/ore/bluespace
