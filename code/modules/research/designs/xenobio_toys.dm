/datum/design/science/xenobio/generate_name(template)
	return "Xenobiology equipment design ([..()])"

// Xenobio Weapons

/datum/design/science/xenobio/slimebaton
	id = "slimebaton"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(MAT_STEEL = 5000)
	build_path = /obj/item/melee/baton/slime

/datum/design/science/xenobio/slimetaser
	id = "slimetaser"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 3, TECH_POWER = 4, TECH_COMBAT = 4)
	materials = list(MAT_STEEL = 5000)
	build_path = /obj/item/gun/energy/taser/xeno

// Other

/datum/design/science/xenobio/slime_scanner
	name = "slime scanner"
	desc = "A hand-held body scanner able to learn information about slimes."
	id = "slime_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/slime_scanner

/datum/design/item/xenobio/gene_disk
	name = "genetics disk"
	desc = "A disk designed to retain humanoid genetic information."
	id = "gene_disk"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	materials = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/disk/data

/datum/design/item/xenobio/botany_disk
	name = "flora data disk"
	desc = "A small disk used for carrying data on plant genetics."
	id = "plant_disk"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	materials = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/disk/botany
