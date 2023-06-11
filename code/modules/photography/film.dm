// todo: fun film with color effects?

/obj/item/camera_film
	name = "film cartridge"
	icon = 'icons/obj/items.dmi'
	desc = "A camera film cartridge. Insert it into a camera to reload it."
	icon_state = "film"
	item_state = "camera"
	w_class = ITEMSIZE_TINY

	// amount left
	var/amount = 10
