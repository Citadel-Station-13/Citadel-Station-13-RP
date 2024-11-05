/obj/item/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 10)
	var/design_id

/obj/item/disk/design_disk/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)
