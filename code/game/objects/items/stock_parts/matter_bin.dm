/obj/item/stock_parts/matter_bin
	name = "matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MAT_STEEL = 80)

/obj/item/stock_parts/matter_bin/adv
	name = "advanced matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "advanced_matter_bin"
	origin_tech = list(TECH_MATERIAL = 3)
	rating = 2
	matter = list(MAT_STEEL = 80)

/obj/item/stock_parts/matter_bin/super
	name = "super matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "super_matter_bin"
	origin_tech = list(TECH_MATERIAL = 5)
	rating = 3
	matter = list(MAT_STEEL = 80)

/obj/item/stock_parts/matter_bin/hyper
	name = "hyper matter bin"
	desc = "A container for holding compressed matter awaiting re-construction."
	icon_state = "hyper_matter_bin"
	origin_tech = list(TECH_MATERIAL = 6, TECH_ARCANE = 1)
	rating = 4
	matter = list(MAT_STEEL = 100)

/obj/item/stock_parts/matter_bin/omni
	name = "omni-matter bin"
	desc = "A strange container for holding compressed matter awaiting re-construction."
	icon_state = "omni_matter_bin"
	origin_tech = list(TECH_MATERIAL = 7, TECH_PRECURSOR  = 1)
	rating = 5
	matter = list(MAT_STEEL = 100)
