// todo: fun film with color effects?

/obj/item/camera_film
	name = "film cartridge"
	desc = "A camera film cartridge. Insert it into a camera to reload it."
	icon = 'icons/modules/photography/film.dmi'
	icon_state = "film"
	worn_render_flags = WORN_RENDER_INHAND_ALLOW_DEFAULT
	inhand_default_type = INHAND_DEFAULT_ICON_STORAGE
	inhand_state = "camera"
	w_class = ITEMSIZE_TINY

	// amount left
	var/amount = 10
