/obj/item/binoculars
	name = "binoculars"
	desc = "A pair of binoculars."
	icon = 'icons/obj/device.dmi'
	icon_state = "binoculars"
	force = 5.0
	w_class = ITEMSIZE_SMALL
	throw_force = 5.0
	throw_range = 15
	throw_speed = 3

	//matter = list("metal" = 50, MAT_GLASS = 50)


/obj/item/binoculars/attack_self(mob/user)
	zoom()
