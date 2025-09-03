/datum/prototype/design/science/hud
	abstract_type = /datum/prototype/design/science/hud
	subcategory = DESIGN_SUBCATEGORY_SCANNING
	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 50)

/datum/prototype/design/science/hud/health
	id = "healthhud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health

/datum/prototype/design/science/hud/security
	id = "sechud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security

/datum/prototype/design/science/hud/mesons
	id = "mesonscanner"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/meson
/*
/datum/prototype/design/science/hud/material
	id = "RNDDesignMatScanner"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/clothing/glasses/material

 Graviton't
/datum/prototype/design/science/hud/graviton_visor
	design_name = "graviton visor"
	id = "graviton_goggles"
	req_tech = list(TECH_MAGNET = 5, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3, TECH_PHORON = 3)
	materials_base = list(MAT_PLASTEEL = 2000, MAT_GLASS = 3000, MAT_PHORON = 1500)
	build_path = /obj/item/clothing/glasses/graviton
*/

/datum/prototype/design/science/hud/omni
	design_name = "AR glasses"
	id = "arhud"
	req_tech = list(TECH_MAGNET = 4, TECH_COMBAT = 3, TECH_BIO = 3)
	materials_base = list(MAT_STEEL = 100, MAT_GLASS = 250)
	build_path = /obj/item/clothing/glasses/omnihud
