/obj/item/stock_parts/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = list(TECH_MAGNET = 1)
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20)

/obj/item/stock_parts/scanning_module/adv
	name = "advanced scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module_adv"
	origin_tech = list(TECH_MAGNET = 3)
	rating = 2
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20)

/obj/item/stock_parts/scanning_module/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	icon_state = "scan_module_phasic"
	origin_tech = list(TECH_MAGNET = 5)
	rating = 3
	materials = list(MAT_STEEL = 50, MAT_GLASS = 20)

/obj/item/stock_parts/scanning_module/hyper
	name = "quantum scanning module"
	desc = "A compact, near-perfect resolution quantum scanning module used in the construction of certain devices."
	icon_state = "scan_module_hyper"
	origin_tech = list(TECH_MAGNET = 6, TECH_BLUESPACE = 1, TECH_ARCANE = 1)
	rating = 4
	materials = list(MAT_STEEL = 100, MAT_GLASS = 40)

/obj/item/stock_parts/scanning_module/omni
	name = "omni-scanning module"
	desc = "A compact, perfect resolution temporospatial scanning module used in the construction of certain devices."
	icon_state = "scan_module_omni"
	origin_tech = list(TECH_MAGNET = 7, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
	rating = 5
	materials = list(MAT_STEEL = 100, MAT_GLASS = 40)
