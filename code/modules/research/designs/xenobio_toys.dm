/datum/prototype/design/science/xenobio
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_XENOBIOLOGY
	abstract_type = /datum/prototype/design/science/xenobio

/datum/prototype/design/science/xenobio/generate_name(template)
	return "Xenobiology equipment design ([..()])"

/datum/prototype/design/science/xenobio/slimebaton
	id = "slimebaton"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	materials_base = list(
		/datum/prototype/material/steel::id = 3000,
	)
	build_path = /obj/item/melee/baton/slime

/datum/prototype/design/science/xenobio/slimetaser
	id = "slimetaser"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 3, TECH_POWER = 4, TECH_COMBAT = 4)
	materials_base = list(
		/datum/prototype/material/steel::id = 3000,
	)
	build_path = /obj/item/gun/projectile/energy/taser/xeno

/datum/prototype/design/science/xenobio/slime_scanner
	design_name = "slime scanner"
	desc = "A hand-held body scanner able to learn information about slimes."
	id = "slime_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/slime_scanner

/datum/prototype/design/science/xenobio/gene_disk
	design_name = "genetics disk"
	desc = "A disk designed to retain humanoid genetic information."
	id = "gene_disk"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	materials_base = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/disk/data

/datum/prototype/design/science/xenobio/botany_disk
	design_name = "flora data disk"
	desc = "A small disk used for carrying data on plant genetics."
	id = "plant_disk"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	materials_base = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/disk/botany
