// TODO: /mirror_scanner or combine with /mirror_tool
/obj/item/mirrorscanner
	name = "Mirror Scanner"
	desc = "A handheld scanner that will display the name of the currently stored consciousness in a mirror."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "sleevemate"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throw_force = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	materials_base = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
