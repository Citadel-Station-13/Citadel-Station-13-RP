/obj/item/disk/tech_disk
	name = "technology disk"
	desc = "A disk for storing technology data for further research."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 10)
	var/datum/tech/stored

/obj/item/disk/tech_disk/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)

// TODO: this shouldn't be needed, just have admin UIs after techweb update or an admin item for tech lmfao
/obj/item/disk/tech_disk/debug_deconstruct_this
	origin_tech = list(
		TECH_ARCANE = 20,
		TECH_BIO = 20,
		TECH_BLUESPACE = 20,
		TECH_COMBAT = 20,
		TECH_DATA = 20,
		TECH_ENGINEERING = 20,
		TECH_ILLEGAL = 20,
		TECH_MAGNET = 20,
		TECH_MATERIAL = 20,
		TECH_PHORON = 20,
		TECH_POWER = 20,
		TECH_PRECURSOR = 20,
	)
