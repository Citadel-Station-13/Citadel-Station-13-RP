// HUDs

/datum/design/science/hud
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)

/datum/design/science/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/science/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/science/hud/health
	name = "health scanner"
	id = "health_hud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "EAAAA"

/datum/design/science/hud/security
	name = "security records"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "EAAAB"

/datum/design/science/hud/mesons
	name = "optical meson scanner"
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "EAAAC"

/datum/design/science/hud/material
	name = "optical material scanner"
	id = "material"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/clothing/glasses/material
	sort_string = "EAAAD"

/* Graviton't
/datum/design/science/hud/graviton_visor
	name = "graviton visor"
	id = "graviton_goggles"
	req_tech = list(TECH_MAGNET = 5, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3, TECH_PHORON = 3)
	materials = list(MAT_PLASTEEL = 2000, MAT_GLASS = 3000, MAT_PHORON = 1500)
	build_path = /obj/item/clothing/glasses/graviton
	sort_string = "EAAAE"
*/

/datum/design/science/hud/omni
	name = "AR glasses"
	id = "omnihud"
	req_tech = list(TECH_MAGNET = 4, TECH_COMBAT = 3, TECH_BIO = 3)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/clothing/glasses/omnihud
	sort_string = "EAAVA"
